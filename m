Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE545376C4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiE3IUr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 May 2022 04:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiE3IUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:20:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D44F76CF5D
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 01:20:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-139-NigGQzOVOBiJ5QN7pfRCSg-1; Mon, 30 May 2022 09:20:30 +0100
X-MC-Unique: NigGQzOVOBiJ5QN7pfRCSg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 30 May 2022 09:20:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 30 May 2022 09:20:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tobias Klauser' <tklauser@distanz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
CC:     Akhmat Karakotov <hmukos@yandex-team.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] socket: Use __u8 instead of u8 in uapi socket.h
Thread-Topic: [PATCH v2] socket: Use __u8 instead of u8 in uapi socket.h
Thread-Index: AQHYc/1yNpoABuOwwke/tSVetiTi/603FAag
Date:   Mon, 30 May 2022 08:20:29 +0000
Message-ID: <2d48c65078ff424398588237e5fe1279@AcuMS.aculab.com>
References: <20220525085126.29977-1-tklauser@distanz.ch>
 <20220530081450.16591-1-tklauser@distanz.ch>
In-Reply-To: <20220530081450.16591-1-tklauser@distanz.ch>
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

From: Tobias Klauser
> Sent: 30 May 2022 09:15
> 
> Use the uapi variant of the u8 type.
> 
> Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
> v2: add missing <linux/types.h> include as reported by kernel test robot
> 
>  include/uapi/linux/socket.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> index 51d6bb2f6765..62a32040ad4f 100644
> --- a/include/uapi/linux/socket.h
> +++ b/include/uapi/linux/socket.h
> @@ -2,6 +2,8 @@
>  #ifndef _UAPI_LINUX_SOCKET_H
>  #define _UAPI_LINUX_SOCKET_H
> 
> +#include <linux/types.h>
> +
>  /*
>   * Desired design of maximum size and alignment (see RFC2553)
>   */
> @@ -31,7 +33,7 @@ struct __kernel_sockaddr_storage {
> 
>  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
> 
> -#define SOCK_TXREHASH_DEFAULT	((u8)-1)
> +#define SOCK_TXREHASH_DEFAULT	((__u8)-1)

I can't help feeling that 255u (or 0xffu) would be a better
way to describe that value.

	David

>  #define SOCK_TXREHASH_DISABLED	0
>  #define SOCK_TXREHASH_ENABLED	1
> 
> --
> 2.36.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

