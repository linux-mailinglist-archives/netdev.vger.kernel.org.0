Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFEE6146EB
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKAJkW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Nov 2022 05:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiKAJkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:40:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1FC19026
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 02:39:27 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-187-iRoj6YtCMo2VjsB38UYWMQ-1; Tue, 01 Nov 2022 09:39:24 +0000
X-MC-Unique: iRoj6YtCMo2VjsB38UYWMQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 1 Nov
 2022 09:39:22 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Tue, 1 Nov 2022 09:39:22 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jiri Slaby (SUSE)'" <jirislaby@kernel.org>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Liska" <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "wireguard@lists.zx2c4.com" <wireguard@lists.zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] wireguard (gcc13): cast enum limits members to int in
 prints
Thread-Topic: [PATCH] wireguard (gcc13): cast enum limits members to int in
 prints
Thread-Index: AQHY7R5F39fDc134tkipsCBRXoDaea4p0HMQ
Date:   Tue, 1 Nov 2022 09:39:22 +0000
Message-ID: <dde406ed000b41d4985599aff0916e2b@AcuMS.aculab.com>
References: <20221031114424.10438-1-jirislaby@kernel.org>
In-Reply-To: <20221031114424.10438-1-jirislaby@kernel.org>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Slaby (SUSE)
> Sent: 31 October 2022 11:44
> 
> Since gcc13, each member of an enum has the same type as the enum [1]. And
> that is inherited from its members. Provided "REKEY_AFTER_MESSAGES = 1ULL
> << 60", the named type is unsigned long.
> 
> This generates warnings with gcc-13:
>   error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'
> 
> Cast the enum members to int when printing them.
> 
> Alternatively, we can cast it to ulong (to silence gcc < 12) and use %lu.
> Alternatively, we can move REKEY_AFTER_MESSAGES away from the enum.

I'd suggest moving the 'out of range' value out of the enum.
Otherwise integer promotion to 'long' might happen elsewhere
and the effects might not be desirable.

It is a shame that gcc doesn't force you to add the type
to 'big enums' (or emit a warning) so that the behavioural
change is properly detected.

From reading the gcc bug it seems that C++ has a syntax for that.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

