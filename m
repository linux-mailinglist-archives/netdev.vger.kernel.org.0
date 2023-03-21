Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED0E6C307A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCULfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCULfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:35:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B95D460B5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:35:15 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d13so15301605pjh.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1679398515;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ruL2TO3xIwsv2r6CzuqTDhEIvzBKdhGVwehcVIIpMdk=;
        b=TA3B2nQu0jhoSHZJswMA27Qn9yR54BA+sb9zaiIJXCi7bxexXoc9+HUI/WPm+z/1Ey
         2lCbcvIlJyeufgP29y5PNkulT7gf4atY/i2718A97DbISr4l2G93fgYEywIE9TxRfaZO
         YwACghDB6naUa0gIsx9JS4wjndkLpQkS7Buss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679398515;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ruL2TO3xIwsv2r6CzuqTDhEIvzBKdhGVwehcVIIpMdk=;
        b=CJknj/9Z9z/kjA0cDIekQb/yS9thrb2qVbkAnsTAE/7hHPxasAqb+5wWX6AxI8vXvh
         0a42EAk8i42LOW3jCTGQsiyj9KOOWYEpwvk/WPBWYPhiCYTZ/0dIYJ7Q0Tq60Hs+mhr8
         x5p5sTqc8Vt8DdWaggqHHRsbZke+Q5a0Qhytxg2Wqb0kX0xDsN3g8jNMZ2UhcBND2evZ
         VFK0UAoya6Qho/XM8j09ZcD/R1dAcRXnTxsdnnq314NNKsobq+9++ZrMWPzvRzQ6Bx/R
         SPJD2VTBa+dyvJZpAONXNPdxXqlpOSTnhvvZWg8fUhAjjvjKnzbEb/0ZBfZbatveIIwo
         MvQg==
X-Gm-Message-State: AO0yUKUs1HKGYHQj46ReHhPslmpLHzyk++wHxvWjACwHox/mOIN98kmi
        Soe/MlJWdhYSqoAGzleXWidNwg==
X-Google-Smtp-Source: AK7set8Z1O8Uyo64xs7idS/hrZIm+HeOwCX/Tl/vVR/OxmcsuTb4f3Jn3SR/jqNvXWVAXk6Ry6PUSQ==
X-Received: by 2002:a17:902:da8a:b0:19e:b38c:860b with SMTP id j10-20020a170902da8a00b0019eb38c860bmr2369210plx.24.1679398514836;
        Tue, 21 Mar 2023 04:35:14 -0700 (PDT)
Received: from ubuntu ([121.133.63.188])
        by smtp.gmail.com with ESMTPSA id k23-20020a170902ba9700b0019a95baaaa6sm8503241pls.222.2023.03.21.04.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 04:35:14 -0700 (PDT)
Date:   Tue, 21 Mar 2023 04:35:09 -0700
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, tudordana@google.com,
        netdev@vger.kernel.org, imv4bel@gmail.com, v4bel@theori.io
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <20230321113509.GA23276@ubuntu>
References: <20230321024946.GA21870@ubuntu>
 <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
 <20230321050803.GA22060@ubuntu>
 <ZBmMUjSXPzFBWeTv@gauss3.secunet.de>
 <20230321111430.GA22737@ubuntu>
 <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJVU1yfCfyyUpmMeZA7BEYLfVXYsK80H26WM=hB-1B27Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 04:19:25AM -0700, Eric Dumazet wrote:
> On Tue, Mar 21, 2023 at 4:14 AM Hyunwoo Kim <v4bel@theori.io> wrote:
> >
> > I'm not sure what 'ip x p' means, as my understanding of XFRM is limited, sorry.
> 
> Since your repro does not set up a private netns.
> 
> Please install the iproute2 package (if not there already) and run the
> following command
> 
> sudo ip x p
> 
> man ip
> 
> IP(8)                                      Linux
>                IP(8)
> 
> NAME
>        ip - show / manipulate routing, network devices, interfaces and tunnels
> 
> SYNOPSIS

This is the result of creating a new netns, running repro, and then running the ip x p command:
```
src 255.1.0.0/0 dst 0.0.0.0/0
	dir out priority 0
	mark 0/0x6
	tmpl src 0.0.0.0 dst 0.0.0.0
		proto comp reqid 0 mode beet
		level 16
	tmpl src fc00:: dst e000:2::
		proto ah reqid 0 mode tunnel
		level 32
	tmpl src ac14:14bb:: dst ac14:14fa::
		proto route2 reqid 0 mode transport
		level 3
	tmpl src :: dst 2001::1
		proto ah reqid 0 mode in_trigger
	tmpl src ff01::1 dst 7f00:1::
		proto comp reqid 0 mode transport
```

> 
> >
> > Instead, here is the (dirty) code I used to trigger this:
> > ```
> > #include <endian.h>
> > #include <stdint.h>
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <sys/syscall.h>
> > #include <sys/types.h>
> > #include <unistd.h>
> > #include <sched.h>
> > #include <fcntl.h>
> >
> >
> > uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};
> >
> > int main(void)
> > {
> >         int ret;
> >         intptr_t res = 0;
> >
> >         syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> >         syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> >         syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> >
> >         res = syscall(__NR_socket, 0x10ul, 3ul, 0);
> >         printf("socket() 1 : %ld\n", res);
> >         if (res != -1)
> >                 r[0] = res;
> >         *(uint64_t*)0x20000000 = 0;
> >         *(uint32_t*)0x20000008 = 0;
> >         *(uint64_t*)0x20000010 = 0x20000140;
> >         *(uint64_t*)0x20000140 = 0x20000040;
> >         memcpy((void*)0x20000040,
> >                         "\x3c\x00\x00\x00\x10\x00\x01\x04\x00\xee\xff\xff\xff\xff\xff\xff\x00"
> >                         "\x00\x00\x00",
> >                         20);
> >         *(uint32_t*)0x20000054 = -1;
> >         memcpy((void*)0x20000058,
> >                         "\x01\x00\x00\x00\x01\x00\x00\x00\x1c\x00\x12\x00\x0c\x00\x01\x00\x62"
> >                         "\x72\x69\x64\x67\x65",
> >                         22);
> >         *(uint64_t*)0x20000148 = 0x3c;
> >         *(uint64_t*)0x20000018 = 1;
> >         *(uint64_t*)0x20000020 = 0;
> >         *(uint64_t*)0x20000028 = 0;
> >         *(uint32_t*)0x20000030 = 0;
> >         ret = syscall(__NR_sendmsg, r[0], 0x20000000ul, 0ul);
> >         printf("sendmsg() 1 : %d\n", ret);
> >
> >         res = syscall(__NR_socket, 0x10ul, 3ul, 6);
> >         printf("socket() 2 : %ld\n", res);
> >         if (res != -1)
> >                 r[1] = res;
> >         *(uint64_t*)0x20000480 = 0;
> >         *(uint32_t*)0x20000488 = 0;
> >         *(uint64_t*)0x20000490 = 0x20000200;
> >         *(uint64_t*)0x20000200 = 0x200004c0;
> >         *(uint32_t*)0x200004c0 = 0x208;
> >         *(uint16_t*)0x200004c4 = 0x19;
> >         *(uint16_t*)0x200004c6 = 1;
> >         *(uint32_t*)0x200004c8 = 0;
> >         *(uint32_t*)0x200004cc = 0;
> >         memset((void*)0x200004d0, 0, 16);
> >         *(uint8_t*)0x200004e0 = -1;
> >         *(uint8_t*)0x200004e1 = 1;
> >         memset((void*)0x200004e2, 0, 13);
> >         *(uint8_t*)0x200004ef = 1;
> >         *(uint16_t*)0x200004f0 = htobe16(0);
> >         *(uint16_t*)0x200004f2 = htobe16(0);
> >         *(uint16_t*)0x200004f4 = htobe16(0);
> >         *(uint16_t*)0x200004f6 = htobe16(0);
> >         *(uint16_t*)0x200004f8 = 2;
> >         *(uint8_t*)0x200004fa = 0;
> >         *(uint8_t*)0x200004fb = 0;
> >         *(uint8_t*)0x200004fc = 0;
> >         *(uint32_t*)0x20000500 = 0;
> >         *(uint32_t*)0x20000504 = -1;
> >         *(uint64_t*)0x20000508 = 0;
> >         *(uint64_t*)0x20000510 = 0;
> >         *(uint64_t*)0x20000518 = 0;
> >         *(uint64_t*)0x20000520 = 0;
> >         *(uint64_t*)0x20000528 = 0;
> >         *(uint64_t*)0x20000530 = 0;
> >         *(uint64_t*)0x20000538 = 0;
> >         *(uint64_t*)0x20000540 = 0;
> >         *(uint64_t*)0x20000548 = 0;
> >         *(uint64_t*)0x20000550 = 0;
> >         *(uint64_t*)0x20000558 = 0;
> >         *(uint64_t*)0x20000560 = 0;
> >         *(uint32_t*)0x20000568 = 0;
> >         *(uint32_t*)0x2000056c = 0;
> >         *(uint8_t*)0x20000570 = 1;
> >         *(uint8_t*)0x20000571 = 0;
> >         *(uint8_t*)0x20000572 = 0;
> >         *(uint8_t*)0x20000573 = 0;
> >         *(uint16_t*)0x20000578 = 0xc;
> >         *(uint16_t*)0x2000057a = 0x15;
> >         *(uint32_t*)0x2000057c = 0;
> >         *(uint32_t*)0x20000580 = 6;
> >         *(uint16_t*)0x20000584 = 0x144;
> >         *(uint16_t*)0x20000586 = 5;
> >         memset((void*)0x20000588, 0, 16);
> >         *(uint32_t*)0x20000598 = htobe32(0);
> >         *(uint8_t*)0x2000059c = 0x6c;
> >         *(uint16_t*)0x200005a0 = 0;
> >         *(uint32_t*)0x200005a4 = htobe32(0);
> >         *(uint32_t*)0x200005b4 = 0;
> >         *(uint8_t*)0x200005b8 = 4;
> >         *(uint8_t*)0x200005b9 = 0;
> >         *(uint8_t*)0x200005ba = 0x10;
> >         *(uint32_t*)0x200005bc = 0;
> >         *(uint32_t*)0x200005c0 = 0;
> >         *(uint32_t*)0x200005c4 = 0;
> >         *(uint32_t*)0x200005c8 = htobe32(0xe0000002);
> >         *(uint32_t*)0x200005d8 = htobe32(0);
> >         *(uint8_t*)0x200005dc = 0x33;
> >         *(uint16_t*)0x200005e0 = 0xa;
> >         *(uint8_t*)0x200005e4 = 0xfc;
> >         *(uint8_t*)0x200005e5 = 0;
> >         memset((void*)0x200005e6, 0, 13);
> >         *(uint8_t*)0x200005f3 = 0;
> >         *(uint32_t*)0x200005f4 = 0;
> >         *(uint8_t*)0x200005f8 = 1;
> >         *(uint8_t*)0x200005f9 = 0;
> >         *(uint8_t*)0x200005fa = 0x20;
> >         *(uint32_t*)0x200005fc = 0;
> >         *(uint32_t*)0x20000600 = 0;
> >         *(uint32_t*)0x20000604 = 0;
> >         *(uint8_t*)0x20000608 = 0xac;
> >         *(uint8_t*)0x20000609 = 0x14;
> >         *(uint8_t*)0x2000060a = 0x14;
> >         *(uint8_t*)0x2000060b = 0xfa;
> >         *(uint32_t*)0x20000618 = htobe32(0);
> >         *(uint8_t*)0x2000061c = 0x2b;
> >         *(uint16_t*)0x20000620 = 0xa;
> >         *(uint8_t*)0x20000624 = 0xac;
> >         *(uint8_t*)0x20000625 = 0x14;
> >         *(uint8_t*)0x20000626 = 0x14;
> >         *(uint8_t*)0x20000627 = 0xbb;
> >         *(uint32_t*)0x20000634 = 0;
> >         *(uint8_t*)0x20000638 = 0;
> >         *(uint8_t*)0x20000639 = 0;
> >         *(uint8_t*)0x2000063a = 3;
> >         *(uint32_t*)0x2000063c = 0;
> >         *(uint32_t*)0x20000640 = 0;
> >         *(uint32_t*)0x20000644 = 0;
> >         memcpy((void*)0x20000648,
> >                         " \001\000\000\000\000\000\000\000\000\000\000\000\000\000\001", 16);
> >         *(uint32_t*)0x20000658 = htobe32(0);
> >         *(uint8_t*)0x2000065c = 0x33;
> >         *(uint16_t*)0x20000660 = 0xa;
> >         *(uint32_t*)0x20000664 = htobe32(0);
> >         *(uint32_t*)0x20000674 = 0;
> >         *(uint8_t*)0x20000678 = 3;
> >         *(uint8_t*)0x20000679 = 0;
> >         *(uint8_t*)0x2000067a = 0;
> >         *(uint32_t*)0x2000067c = 0;
> >         *(uint32_t*)0x20000680 = 0;
> >         *(uint32_t*)0x20000684 = 0;
> >         *(uint32_t*)0x20000688 = htobe32(0x7f000001);
> >         *(uint32_t*)0x20000698 = htobe32(0);
> >         *(uint8_t*)0x2000069c = 0x6c;
> >         *(uint16_t*)0x200006a0 = 0xa;
> >         *(uint8_t*)0x200006a4 = -1;
> >         *(uint8_t*)0x200006a5 = 1;
> >         memset((void*)0x200006a6, 0, 13);
> >         *(uint8_t*)0x200006b3 = 1;
> >         *(uint32_t*)0x200006b4 = 0;
> >         *(uint8_t*)0x200006b8 = 0;
> >         *(uint8_t*)0x200006b9 = 0;
> >         *(uint8_t*)0x200006ba = 0;
> >         *(uint32_t*)0x200006bc = 0;
> >         *(uint32_t*)0x200006c0 = 0;
> >         *(uint32_t*)0x200006c4 = -1;
> >         *(uint64_t*)0x20000208 = 0x208;
> >         *(uint64_t*)0x20000498 = 1;
> >         *(uint64_t*)0x200004a0 = 0;
> >         *(uint64_t*)0x200004a8 = 0;
> >         *(uint32_t*)0x200004b0 = 0;
> >         ret = syscall(__NR_sendmsg, r[1], 0x20000480ul, 0ul);
> >         printf("sendmsg() 2 : %d\n", ret);
> >         return 0;
> > }
> > ```
