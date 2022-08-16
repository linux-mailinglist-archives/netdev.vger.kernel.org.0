Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B5F59612F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiHPRap convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Aug 2022 13:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiHPRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:30:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D4D1AF23
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:29:57 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-310-DUc9I98gMAqUl9ItPa7P5w-1; Tue, 16 Aug 2022 18:29:54 +0100
X-MC-Unique: DUc9I98gMAqUl9ItPa7P5w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Tue, 16 Aug 2022 18:29:53 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Tue, 16 Aug 2022 18:29:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kuniyuki Iwashima' <kuniyu@amazon.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tkhai@ya.ru" <tkhai@ya.ru>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v2 1/2] fs: Export __receive_fd()
Thread-Topic: [PATCH v2 1/2] fs: Export __receive_fd()
Thread-Index: AQHYsQ/E5egn5U5P0k6Simqj85Zt/a2xKtgwgACJvoCAABNVkA==
Date:   Tue, 16 Aug 2022 17:29:53 +0000
Message-ID: <3d655b0e4d4d4c2991f54c79b1f50ccd@AcuMS.aculab.com>
References: <e3e2fe6a2b8f4a65a4e28d9d7fddd558@AcuMS.aculab.com>
 <20220816171509.98183-1-kuniyu@amazon.com>
In-Reply-To: <20220816171509.98183-1-kuniyu@amazon.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima
> Sent: 16 August 2022 18:15
> 
> From:   David Laight <David.Laight@ACULAB.COM>
> Date:   Tue, 16 Aug 2022 08:03:14 +0000
> > From: Kirill Tkhai
> > > Sent: 15 August 2022 22:15
> > >
> > > This is needed to make receive_fd_user() available in modules, and it will be used in next patch.
> > >
> > > Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> > > ---
> > > v2: New
> > >  fs/file.c |    1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/fs/file.c b/fs/file.c
> > > index 3bcc1ecc314a..e45d45f1dd45 100644
> > > --- a/fs/file.c
> > > +++ b/fs/file.c
> > > @@ -1181,6 +1181,7 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> > >  	__receive_sock(file);
> > >  	return new_fd;
> > >  }
> > > +EXPORT_SYMBOL_GPL(__receive_fd);
> >
> > It doesn't seem right (to me) to be exporting a function
> > with a __ prefix.
> 
> +1.
> Now receive_fd() has inline and it's the problem.
> Can we avoid this by moving receive_fd() in fs/file.c without inline and
> exporting it?

It looks like it is receive_fd_user() that should be made a real
function and then exported.
__receive_fd() can then be static.
The extra function call will be noise - and the compiler may
well either tail-call it or inline different copies of __receive_fd()
into the two callers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

