Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7036A6E7E78
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjDSPiF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Apr 2023 11:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjDSPiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:38:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BB69762
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:38:01 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-135-8VMVLINFM4iofKKNHiZ6yw-1; Wed, 19 Apr 2023 16:37:58 +0100
X-MC-Unique: 8VMVLINFM4iofKKNHiZ6yw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 19 Apr
 2023 16:37:57 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 19 Apr 2023 16:37:57 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Louis Peens' <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: RE: [PATCH net v2] nfp: correct number of MSI vectors requests
 returned
Thread-Topic: [PATCH net v2] nfp: correct number of MSI vectors requests
 returned
Thread-Index: AQHZcpcs9qwN2O/UuUKbylF4iYea3K8yxA+Q
Date:   Wed, 19 Apr 2023 15:37:57 +0000
Message-ID: <36322e3475804855a28c7e91a7ccdf3e@AcuMS.aculab.com>
References: <20230419081520.17971-1-louis.peens@corigine.com>
In-Reply-To: <20230419081520.17971-1-louis.peens@corigine.com>
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

From: Louis Peens
> Sent: 19 April 2023 09:15
> 
> From: Xiaoyu Li <xiaoyu.li@corigine.com>
> 
> Before the referenced commit, if fewer interrupts are supported by
> hardware than requested, then pci_msix_vec_count() returned the
> former. However, after the referenced commit, an error is returned
> for this condition. This causes a regression in the NFP driver
> preventing probe from completing.

I believe the relevant change to the msix vector allocation
function has been reverted.
(Or at least, the over-zealous check of nvec removed.)

So this change to bound the number of interrupts
isn't needed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

