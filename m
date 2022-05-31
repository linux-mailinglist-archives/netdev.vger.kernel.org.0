Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A03538DAA
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbiEaJY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245168AbiEaJYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:24:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38EF584A36
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653989092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6P95NKv5J75UDyhLz30/tdSQWDhNkRy2BgkpUcXftuM=;
        b=I7pv1iS93IqAmNahtebLr2nQ+r94EMaXz3n2tCDqL8gzwZLPbhPma/G7lJmag6fbQNGTFE
        3Ek8iiBVrG0VpGzzNzQwS/MDNd9Kl3t/u7sx9aGAjreYD9Sk8UOxu2vSDoVkmI4H7mXKe9
        QvPjiolGraj5ZTsjnJfdEPPydVbowy8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-siiFdxDTPruV7N8sv8odVA-1; Tue, 31 May 2022 05:24:51 -0400
X-MC-Unique: siiFdxDTPruV7N8sv8odVA-1
Received: by mail-qk1-f199.google.com with SMTP id g14-20020ae9e10e000000b006a394d35dbfso10123745qkm.5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6P95NKv5J75UDyhLz30/tdSQWDhNkRy2BgkpUcXftuM=;
        b=IFd70mkpLbYb7c2ouwJjI33oC7JrR4ZFKFS8xVLtRpUyidDU96wUZMuLPUJ/WY6rAW
         5BkxZaT4LsxZe7C8jsUNeuHnpMlLnmyYWjSIfhQzBuKKkHw3vWkjxQdNy5MZW1snTX22
         mJQgSvkDOowys824qhBL3+ZkVeHT0Eo/VQ6Nic5tw+8+N04BjSA+/5OY8Dr+FQhghAc8
         qujXijISkg1yw7PMoXb+DQ4mIBQV5ZWwNBmZ66dsVyZC5LA4JHsaBad4R4LagGR92w+0
         vOWml/16xzLEdAkfHQvop3641Tj7iIDc5MTkXyZJ2akT+iIlwlAzeA2QULEPC32bsy2x
         fptg==
X-Gm-Message-State: AOAM533GUp2asutxqvoXPKuuW8iPQSwDYHSuwVcO+pHOSkUoVNHCc5rs
        SDWvsh0LeDkhwuZ4CEso4NsbmH8yEEuGRHd1qTR9d9BXI+CB1DdIgCA0zFOyNsq8ierqAndCcGA
        XqFN2tBAolaaNLEcl
X-Received: by 2002:a37:61c6:0:b0:6a3:6deb:51b0 with SMTP id v189-20020a3761c6000000b006a36deb51b0mr32088495qkb.256.1653989090223;
        Tue, 31 May 2022 02:24:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDQ3saUc3j3r8qbgKiZMd7azlywBiVjq2NMHzzdJ39YCZw5YMHkctRIdGFUBaIffISu+uNeg==
X-Received: by 2002:a37:61c6:0:b0:6a3:6deb:51b0 with SMTP id v189-20020a3761c6000000b006a36deb51b0mr32088481qkb.256.1653989089953;
        Tue, 31 May 2022 02:24:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id bz11-20020a05622a1e8b00b002f940c06d93sm144028qtb.16.2022.05.31.02.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 02:24:49 -0700 (PDT)
Message-ID: <7e77647a5c3c538ae6beb668083e1b6090dccb62.camel@redhat.com>
Subject: Re: [PATCH v2] socket: Use __u8 instead of u8 in uapi socket.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Tobias Klauser' <tklauser@distanz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Akhmat Karakotov <hmukos@yandex-team.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 31 May 2022 11:24:46 +0200
In-Reply-To: <2d48c65078ff424398588237e5fe1279@AcuMS.aculab.com>
References: <20220525085126.29977-1-tklauser@distanz.ch>
         <20220530081450.16591-1-tklauser@distanz.ch>
         <2d48c65078ff424398588237e5fe1279@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-30 at 08:20 +0000, David Laight wrote:
> From: Tobias Klauser
> > Sent: 30 May 2022 09:15
> > 
> > Use the uapi variant of the u8 type.
> > 
> > Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > ---
> > v2: add missing <linux/types.h> include as reported by kernel test robot
> > 
> >  include/uapi/linux/socket.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
> > index 51d6bb2f6765..62a32040ad4f 100644
> > --- a/include/uapi/linux/socket.h
> > +++ b/include/uapi/linux/socket.h
> > @@ -2,6 +2,8 @@
> >  #ifndef _UAPI_LINUX_SOCKET_H
> >  #define _UAPI_LINUX_SOCKET_H
> > 
> > +#include <linux/types.h>
> > +
> >  /*
> >   * Desired design of maximum size and alignment (see RFC2553)
> >   */
> > @@ -31,7 +33,7 @@ struct __kernel_sockaddr_storage {
> > 
> >  #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
> > 
> > -#define SOCK_TXREHASH_DEFAULT	((u8)-1)
> > +#define SOCK_TXREHASH_DEFAULT	((__u8)-1)
> 
> I can't help feeling that 255u (or 0xffu) would be a better
> way to describe that value.

Even plain '255' would do. Additionally, any of the above will avoid
the additional header dependency.

Thanks,

Paolo

