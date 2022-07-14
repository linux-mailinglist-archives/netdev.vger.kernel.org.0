Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474615745F5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiGNHqR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Jul 2022 03:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiGNHqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:46:16 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29D3832074
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:46:14 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-2-mZeh0vbrPpqDvlEaKMiibQ-1; Thu, 14 Jul 2022 08:46:11 +0100
X-MC-Unique: mZeh0vbrPpqDvlEaKMiibQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Thu, 14 Jul 2022 08:46:10 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Thu, 14 Jul 2022 08:46:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dylan Yudaken' <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>
Subject: RE: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Thread-Topic: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Thread-Index: AQHYlpI5075XXmpT5EGvlEm+mgTHvK19fcuQ
Date:   Thu, 14 Jul 2022 07:46:10 +0000
Message-ID: <27f219d07e4e4ce4bfb3263d8d94eae6@AcuMS.aculab.com>
References: <20220713082321.1445020-1-dylany@fb.com>
 <20220713082321.1445020-4-dylany@fb.com>
In-Reply-To: <20220713082321.1445020-4-dylany@fb.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dylan Yudaken
> Sent: 13 July 2022 09:23
> 
> Similar to multishot recv, this will require provided buffers to be
> used. However recvmsg is much more complex than recv as it has multiple
> outputs. Specifically flags, name, and control messages.
...

Why is this any different from adding several 'recvmsg' requests
into the request ring?

IIUC the requests are all processed sequentially by a single thread.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

