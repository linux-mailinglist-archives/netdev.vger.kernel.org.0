Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406166C3033
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCULUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCULUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:08 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3251B42BFB
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:19:38 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id cz11so6638144vsb.6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679397576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cy6rEFFa7FuhpkiV6z1/z/6q9p+HmdMsU9YrKukw/Lc=;
        b=B6h6X1xgFtzyzjwQHnE8EhNucl7SNELHg9RGh7vIki7HjcY49CIM8mP+0Now0v8kwM
         SYrI6+htn049C3exdjMYIV86G5ySFvM58KiXUwPq06+iM3i/HfffjUfIR3DJ6hddg1gQ
         QayzdxbOzG4MaTNRzFPZd8AwiOFgDRgUNGAJ9LPxDis+c8g9ta4MebjcX8oRXVff8XyC
         4yzUbn3KPvgAq/k3MtYgrC9uVPZLdLvKw/layN8TE/YbHG9nGnXzd9CEpFkHBukTAmmC
         T2QEa1mp4LNIpc1doQ+um9i26n/bIsnlYA1vMpBkjtphiRhbICtFf09a5xV2lmZIa/Dg
         HTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679397576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cy6rEFFa7FuhpkiV6z1/z/6q9p+HmdMsU9YrKukw/Lc=;
        b=Xjt8ce10+ZSFvC0Hf+PW0Om4ORA059Fx6PXx2TzXspz7B2h96v5Ne3oaGeLfd4sn2w
         wMInxb48JwOw36nYVKG4MsL78bYRJnZqViklANj234Q6jPiR9TVxMysErneqQdwQFlT/
         vFcUYDLP00+cgCnlZmtUVjBUMvNLumWwy5G8eZFhDty8JtO4UBD3EkaweHeLHO4JBgC6
         ZYfMzxf2IZ2xV2kxdenkyEEmVCprfZZnAwpMkgBfFxgoF2/0JDXICKuCBRsOER2x6Yqa
         xu9Wh7lwKAi7cB1KiLBBy9eYOItuIoKYip40CeZUYM9+CI62DODNFjc7fD6rlEGGNAPG
         WjPw==
X-Gm-Message-State: AO0yUKVfXy9HA7zTLdcHZb4J6OxnzhHXdATv6hk9cqAVYf79Nq5TSP2Q
        DHtt9VuZ8UhbiMgcokjLgb9gJOSp0Lb1lb8K3Ml1WQ==
X-Google-Smtp-Source: AKy350aBMbijEI+bU6Of7w7HDJlELwIh/EGXKtsr4dYp3EfFwblGbx0FRuVF9P/r3Q5XEG0odnXtUHmVeHQLNA95Ftw=
X-Received: by 2002:a67:d581:0:b0:425:dd21:acc8 with SMTP id
 m1-20020a67d581000000b00425dd21acc8mr1197101vsj.7.1679397576497; Tue, 21 Mar
 2023 04:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230321024946.GA21870@ubuntu> <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu> <ZBmMUjSXPzFBWeTv@gauss3.secunet.de> <20230321111430.GA22737@ubuntu>
In-Reply-To: <20230321111430.GA22737@ubuntu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 04:19:25 -0700
Message-ID: <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, tudordana@google.com,
        netdev@vger.kernel.org, imv4bel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 4:14=E2=80=AFAM Hyunwoo Kim <v4bel@theori.io> wrote=
:
>
> I'm not sure what 'ip x p' means, as my understanding of XFRM is limited,=
 sorry.

Since your repro does not set up a private netns.

Please install the iproute2 package (if not there already) and run the
following command

sudo ip x p

man ip

IP(8)                                      Linux
               IP(8)

NAME
       ip - show / manipulate routing, network devices, interfaces and tunn=
els

SYNOPSIS

>
> Instead, here is the (dirty) code I used to trigger this:
> ```
> #include <endian.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <sched.h>
> #include <fcntl.h>
>
>
> uint64_t r[2] =3D {0xffffffffffffffff, 0xffffffffffffffff};
>
> int main(void)
> {
>         int ret;
>         intptr_t res =3D 0;
>
>         syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>         syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0u=
l);
>         syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>
>         res =3D syscall(__NR_socket, 0x10ul, 3ul, 0);
>         printf("socket() 1 : %ld\n", res);
>         if (res !=3D -1)
>                 r[0] =3D res;
>         *(uint64_t*)0x20000000 =3D 0;
>         *(uint32_t*)0x20000008 =3D 0;
>         *(uint64_t*)0x20000010 =3D 0x20000140;
>         *(uint64_t*)0x20000140 =3D 0x20000040;
>         memcpy((void*)0x20000040,
>                         "\x3c\x00\x00\x00\x10\x00\x01\x04\x00\xee\xff\xff=
\xff\xff\xff\xff\x00"
>                         "\x00\x00\x00",
>                         20);
>         *(uint32_t*)0x20000054 =3D -1;
>         memcpy((void*)0x20000058,
>                         "\x01\x00\x00\x00\x01\x00\x00\x00\x1c\x00\x12\x00=
\x0c\x00\x01\x00\x62"
>                         "\x72\x69\x64\x67\x65",
>                         22);
>         *(uint64_t*)0x20000148 =3D 0x3c;
>         *(uint64_t*)0x20000018 =3D 1;
>         *(uint64_t*)0x20000020 =3D 0;
>         *(uint64_t*)0x20000028 =3D 0;
>         *(uint32_t*)0x20000030 =3D 0;
>         ret =3D syscall(__NR_sendmsg, r[0], 0x20000000ul, 0ul);
>         printf("sendmsg() 1 : %d\n", ret);
>
>         res =3D syscall(__NR_socket, 0x10ul, 3ul, 6);
>         printf("socket() 2 : %ld\n", res);
>         if (res !=3D -1)
>                 r[1] =3D res;
>         *(uint64_t*)0x20000480 =3D 0;
>         *(uint32_t*)0x20000488 =3D 0;
>         *(uint64_t*)0x20000490 =3D 0x20000200;
>         *(uint64_t*)0x20000200 =3D 0x200004c0;
>         *(uint32_t*)0x200004c0 =3D 0x208;
>         *(uint16_t*)0x200004c4 =3D 0x19;
>         *(uint16_t*)0x200004c6 =3D 1;
>         *(uint32_t*)0x200004c8 =3D 0;
>         *(uint32_t*)0x200004cc =3D 0;
>         memset((void*)0x200004d0, 0, 16);
>         *(uint8_t*)0x200004e0 =3D -1;
>         *(uint8_t*)0x200004e1 =3D 1;
>         memset((void*)0x200004e2, 0, 13);
>         *(uint8_t*)0x200004ef =3D 1;
>         *(uint16_t*)0x200004f0 =3D htobe16(0);
>         *(uint16_t*)0x200004f2 =3D htobe16(0);
>         *(uint16_t*)0x200004f4 =3D htobe16(0);
>         *(uint16_t*)0x200004f6 =3D htobe16(0);
>         *(uint16_t*)0x200004f8 =3D 2;
>         *(uint8_t*)0x200004fa =3D 0;
>         *(uint8_t*)0x200004fb =3D 0;
>         *(uint8_t*)0x200004fc =3D 0;
>         *(uint32_t*)0x20000500 =3D 0;
>         *(uint32_t*)0x20000504 =3D -1;
>         *(uint64_t*)0x20000508 =3D 0;
>         *(uint64_t*)0x20000510 =3D 0;
>         *(uint64_t*)0x20000518 =3D 0;
>         *(uint64_t*)0x20000520 =3D 0;
>         *(uint64_t*)0x20000528 =3D 0;
>         *(uint64_t*)0x20000530 =3D 0;
>         *(uint64_t*)0x20000538 =3D 0;
>         *(uint64_t*)0x20000540 =3D 0;
>         *(uint64_t*)0x20000548 =3D 0;
>         *(uint64_t*)0x20000550 =3D 0;
>         *(uint64_t*)0x20000558 =3D 0;
>         *(uint64_t*)0x20000560 =3D 0;
>         *(uint32_t*)0x20000568 =3D 0;
>         *(uint32_t*)0x2000056c =3D 0;
>         *(uint8_t*)0x20000570 =3D 1;
>         *(uint8_t*)0x20000571 =3D 0;
>         *(uint8_t*)0x20000572 =3D 0;
>         *(uint8_t*)0x20000573 =3D 0;
>         *(uint16_t*)0x20000578 =3D 0xc;
>         *(uint16_t*)0x2000057a =3D 0x15;
>         *(uint32_t*)0x2000057c =3D 0;
>         *(uint32_t*)0x20000580 =3D 6;
>         *(uint16_t*)0x20000584 =3D 0x144;
>         *(uint16_t*)0x20000586 =3D 5;
>         memset((void*)0x20000588, 0, 16);
>         *(uint32_t*)0x20000598 =3D htobe32(0);
>         *(uint8_t*)0x2000059c =3D 0x6c;
>         *(uint16_t*)0x200005a0 =3D 0;
>         *(uint32_t*)0x200005a4 =3D htobe32(0);
>         *(uint32_t*)0x200005b4 =3D 0;
>         *(uint8_t*)0x200005b8 =3D 4;
>         *(uint8_t*)0x200005b9 =3D 0;
>         *(uint8_t*)0x200005ba =3D 0x10;
>         *(uint32_t*)0x200005bc =3D 0;
>         *(uint32_t*)0x200005c0 =3D 0;
>         *(uint32_t*)0x200005c4 =3D 0;
>         *(uint32_t*)0x200005c8 =3D htobe32(0xe0000002);
>         *(uint32_t*)0x200005d8 =3D htobe32(0);
>         *(uint8_t*)0x200005dc =3D 0x33;
>         *(uint16_t*)0x200005e0 =3D 0xa;
>         *(uint8_t*)0x200005e4 =3D 0xfc;
>         *(uint8_t*)0x200005e5 =3D 0;
>         memset((void*)0x200005e6, 0, 13);
>         *(uint8_t*)0x200005f3 =3D 0;
>         *(uint32_t*)0x200005f4 =3D 0;
>         *(uint8_t*)0x200005f8 =3D 1;
>         *(uint8_t*)0x200005f9 =3D 0;
>         *(uint8_t*)0x200005fa =3D 0x20;
>         *(uint32_t*)0x200005fc =3D 0;
>         *(uint32_t*)0x20000600 =3D 0;
>         *(uint32_t*)0x20000604 =3D 0;
>         *(uint8_t*)0x20000608 =3D 0xac;
>         *(uint8_t*)0x20000609 =3D 0x14;
>         *(uint8_t*)0x2000060a =3D 0x14;
>         *(uint8_t*)0x2000060b =3D 0xfa;
>         *(uint32_t*)0x20000618 =3D htobe32(0);
>         *(uint8_t*)0x2000061c =3D 0x2b;
>         *(uint16_t*)0x20000620 =3D 0xa;
>         *(uint8_t*)0x20000624 =3D 0xac;
>         *(uint8_t*)0x20000625 =3D 0x14;
>         *(uint8_t*)0x20000626 =3D 0x14;
>         *(uint8_t*)0x20000627 =3D 0xbb;
>         *(uint32_t*)0x20000634 =3D 0;
>         *(uint8_t*)0x20000638 =3D 0;
>         *(uint8_t*)0x20000639 =3D 0;
>         *(uint8_t*)0x2000063a =3D 3;
>         *(uint32_t*)0x2000063c =3D 0;
>         *(uint32_t*)0x20000640 =3D 0;
>         *(uint32_t*)0x20000644 =3D 0;
>         memcpy((void*)0x20000648,
>                         " \001\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\001", 16);
>         *(uint32_t*)0x20000658 =3D htobe32(0);
>         *(uint8_t*)0x2000065c =3D 0x33;
>         *(uint16_t*)0x20000660 =3D 0xa;
>         *(uint32_t*)0x20000664 =3D htobe32(0);
>         *(uint32_t*)0x20000674 =3D 0;
>         *(uint8_t*)0x20000678 =3D 3;
>         *(uint8_t*)0x20000679 =3D 0;
>         *(uint8_t*)0x2000067a =3D 0;
>         *(uint32_t*)0x2000067c =3D 0;
>         *(uint32_t*)0x20000680 =3D 0;
>         *(uint32_t*)0x20000684 =3D 0;
>         *(uint32_t*)0x20000688 =3D htobe32(0x7f000001);
>         *(uint32_t*)0x20000698 =3D htobe32(0);
>         *(uint8_t*)0x2000069c =3D 0x6c;
>         *(uint16_t*)0x200006a0 =3D 0xa;
>         *(uint8_t*)0x200006a4 =3D -1;
>         *(uint8_t*)0x200006a5 =3D 1;
>         memset((void*)0x200006a6, 0, 13);
>         *(uint8_t*)0x200006b3 =3D 1;
>         *(uint32_t*)0x200006b4 =3D 0;
>         *(uint8_t*)0x200006b8 =3D 0;
>         *(uint8_t*)0x200006b9 =3D 0;
>         *(uint8_t*)0x200006ba =3D 0;
>         *(uint32_t*)0x200006bc =3D 0;
>         *(uint32_t*)0x200006c0 =3D 0;
>         *(uint32_t*)0x200006c4 =3D -1;
>         *(uint64_t*)0x20000208 =3D 0x208;
>         *(uint64_t*)0x20000498 =3D 1;
>         *(uint64_t*)0x200004a0 =3D 0;
>         *(uint64_t*)0x200004a8 =3D 0;
>         *(uint32_t*)0x200004b0 =3D 0;
>         ret =3D syscall(__NR_sendmsg, r[1], 0x20000480ul, 0ul);
>         printf("sendmsg() 2 : %d\n", ret);
>         return 0;
> }
> ```
