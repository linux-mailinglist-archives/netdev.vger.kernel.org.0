Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4E6E7EC2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjDSPoT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Apr 2023 11:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjDSPoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:44:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16570AD30
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:43:48 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-66-8kzx0OtrNuu2tXAPYOXeXQ-1; Wed, 19 Apr 2023 16:43:45 +0100
X-MC-Unique: 8kzx0OtrNuu2tXAPYOXeXQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 19 Apr
 2023 16:43:45 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 19 Apr 2023 16:43:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Brad Spencer' <bspencer@blackberry.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: netlink getsockopt() sets only one byte?
Thread-Topic: netlink getsockopt() sets only one byte?
Thread-Index: AQHZciCdeGKq7qWD/UKbta8L5WEwQ68yxwaw
Date:   Wed, 19 Apr 2023 15:43:45 +0000
Message-ID: <0c2ea86d55454b55a88db716f967dda4@AcuMS.aculab.com>
References: <ZD7VkNWFfp22kTDt@datsun.rim.net>
In-Reply-To: <ZD7VkNWFfp22kTDt@datsun.rim.net>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brad Spencer <bspencer@blackberry.com>
> Sent: 18 April 2023 18:38
> 
> Calling getsockopt() on a netlink socket with SOL_NETLINK options that
> use type int only sets the first byte of the int value but returns an
> optlen equal to sizeof(int), at least on x86_64.
> 
> 
> The detailed description:
> 
> It looks like netlink_getsockopt() calls put_user() with a char*
> pointer, and I think that causes it to copy only one byte from the val
> result, despite len being sizeof(int).
> 
> Is this the expected behaviour?  The returned size is 4, after all,
> and other int-sized socket options (outside of netlink) like
> SO_REUSEADDR set all bytes of the int.

It will be horribly broken on anything big-endian.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

