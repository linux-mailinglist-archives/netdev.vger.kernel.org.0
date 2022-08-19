Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9159A7B4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352414AbiHSVYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352409AbiHSVYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:24:07 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1057B5C35D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:24:05 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-31f445bd486so153429877b3.13
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=Y6QwoVZVicOlVCtE7c/suMyZbLEm/X8sYTuoOY17aP8=;
        b=Pg6j74ClZ4u3ciAjGeVATapbOuX7TryyaYQhY/ONqHud/ndF5+OBkmoao+GTRgjkEN
         w4Bn+WmZekdAloy2kiGt7POrpDThYcNFxXHRPi9aQotlEIMazh8t0NSHOtgEkDo2TZcY
         sgMUGgY6TjgcgUeiMPC8iQh/owopnqH4V3LbleKUCf72AInbFB8lb0T2bLHhHbKyF5fh
         nR5lBEx1pEiFQ9UNjzvD8pyAfbqp0HLnrBTnwNIYIYyHtEAQk5p+GZzXvlHYNqb9cAuV
         r8JCEUj5coumykLCFHVQrevpEdZjlkenLd4I8CkTghl46gbE9a0NfkZbB6r7JP0A1Ft/
         n79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=Y6QwoVZVicOlVCtE7c/suMyZbLEm/X8sYTuoOY17aP8=;
        b=rDDt3ObiaEv/y6qfE9HGrXmTsK5yP/9CjtRpaEDRInNTXNd7dNBNMAOElZyFQakVg6
         MjIEV/Giojly+TexIUumML4lmm7UOsEjfTLFBHyol5X2oMt9zo27BcFRHlDy3CR/Wrqm
         e9BzgpBQ6X+zZXwbgt8EIpEINmdT1qoKfuc/OJ8gLYBdKfubsCAwrcP0IJk6osUnqvpC
         mu5BE7B4ydRqxmtHLQfWqyKZPm6i4n+8YRfNHqx+PkYlXz5NkdmPAJe3AJ3LR4CLNdFk
         VpjZeBR2eXtfJO5cxoIB99Jhp24XbYZMQvV6lk5Y60Mb8/3v5hXXVb9G9Z1eeXMLVBec
         x3vw==
X-Gm-Message-State: ACgBeo0dqvD6iaH6EtDmWA4+JPGTGTKE+P5grVK78MiRIup9bOQ+6pCX
        h+RKDuIPc2GpWV/4j2kUkLvA90Mg1qNShAFItzh0uCzca9JeXQ==
X-Google-Smtp-Source: AA6agR5I8T82dnw4LDMcR1q4iQM0q8naijH15mGEpwPD55IdJJk39uM9aPMuAoD3pMU6shQEiCHYzyqOflBTs2s7gvk=
X-Received: by 2002:a0d:fd06:0:b0:324:e4fe:9e6c with SMTP id
 n6-20020a0dfd06000000b00324e4fe9e6cmr9286130ywf.332.1660944244044; Fri, 19
 Aug 2022 14:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAEHB24_nMMdHw1tQ0Jb0rhOLXgi6X=_Ou6r8BcbV3r-6HeueEA@mail.gmail.com>
In-Reply-To: <CAEHB24_nMMdHw1tQ0Jb0rhOLXgi6X=_Ou6r8BcbV3r-6HeueEA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 19 Aug 2022 14:23:53 -0700
Message-ID: <CANn89iK2O_-m3KUooE8TUOupYZwXAjfrV64bhS0UAn8hFZVdgw@mail.gmail.com>
Subject: Re: data-race in __tcp_alloc_md5sig_pool / tcp_alloc_md5sig_pool
To:     abhishek.shah@columbia.edu
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, trix@redhat.com,
        Yonghong Song <yhs@fb.com>, Gabriel Ryan <gabe@cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 8:40 AM Abhishek Shah
<abhishek.shah@columbia.edu> wrote:
>
> Hi all,
>

Not sure why you included so many people in this report ?

You have not exactly said what could be the issue (other than the raw
kcsan report)

> We found a race involving the tcp_md5sig_pool_populated variable. Upon fu=
rther investigation, we think that __tcp_alloc_md5sig_pool can be run multi=
ple times before tcp_md5sig_pool_populated is set to true here. However, we=
 are not sure. Please let us know what you think.

I think this is a false positive, because the data race is properly handled
with the help of tcp_md5sig_mutex.

We might silence it, of course, like many other existing data races.



>
> Thanks!
>
>
> --------------------Report--------------
>
> write to 0xffffffff883a2438 of 1 bytes by task 6542 on cpu 0:
>  __tcp_alloc_md5sig_pool+0x239/0x260 net/ipv4/tcp.c:4343
>  tcp_alloc_md5sig_pool+0x58/0xb0 net/ipv4/tcp.c:4352
>  tcp_md5_do_add+0x2c4/0x470 net/ipv4/tcp_ipv4.c:1199
>  tcp_v6_parse_md5_keys+0x473/0x490
>  do_tcp_setsockopt net/ipv4/tcp.c:3614 [inline]
>  tcp_setsockopt+0xda6/0x1be0 net/ipv4/tcp.c:3698
>  sock_common_setsockopt+0x62/0x80 net/core/sock.c:3505
>  __sys_setsockopt+0x2d1/0x450 net/socket.c:2180
>  __do_sys_setsockopt net/socket.c:2191 [inline]
>  __se_sys_setsockopt net/socket.c:2188 [inline]
>  __x64_sys_setsockopt+0x67/0x80 net/socket.c:2188
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> read to 0xffffffff883a2438 of 1 bytes by task 6541 on cpu 1:
>  tcp_alloc_md5sig_pool+0x15/0xb0 net/ipv4/tcp.c:4348
>  tcp_md5_do_add+0x2c4/0x470 net/ipv4/tcp_ipv4.c:1199
>  tcp_v4_parse_md5_keys+0x42f/0x500 net/ipv4/tcp_ipv4.c:1303
>  do_tcp_setsockopt net/ipv4/tcp.c:3614 [inline]
>  tcp_setsockopt+0xda6/0x1be0 net/ipv4/tcp.c:3698
>  sock_common_setsockopt+0x62/0x80 net/core/sock.c:3505
>  __sys_setsockopt+0x2d1/0x450 net/socket.c:2180
>  __do_sys_setsockopt net/socket.c:2191 [inline]
>  __se_sys_setsockopt net/socket.c:2188 [inline]
>  __x64_sys_setsockopt+0x67/0x80 net/socket.c:2188
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 6541 Comm: syz-executor2-n Not tainted 5.18.0-rc5+ #107
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/0=
1/2014
>
>
> Reproducing Inputs
>
> Input CPU 0:
> r0 =3D socket(0xa, 0x1, 0x0)
> setsockopt$inet_tcp_TCP_MD5SIG(r0, 0x6, 0xe, &(0x7f0000000000)=3D{@in6=3D=
{{0xa, 0x0, 0x0, @private0}}, 0x0, 0x0, 0x10, 0x0, "a04979dcb0f6e3666c36f59=
053376c1d2e245fbad5b4749a8c55dda1bd819ec87afb7f5ac2483f179675d3c23fdba661af=
cca7cca5661a7b52ac11cc8085800c2c0d8e7de309eb57b89292880a563154"}, 0xd8)
> setsockopt$inet_tcp_TCP_MD5SIG(r0, 0x6, 0xe, &(0x7f0000000100)=3D{@in6=3D=
{{0xa, 0x0, 0x0, @loopback}}, 0x0, 0x0, 0x28, 0x0, "f386ea32b026420a2c65ea3=
75667090000000000000000a300001e81f9c22181fe9cef51a4070736c7a33d08c1dd5c35eb=
9b0e6c6aa490d4f1b18f7b09103bf18619b49a9ce10f4bd98e0b00"}, 0xd8)
>
> Input CPU 1:
> r0 =3D socket$inet_tcp(0x2, 0x1, 0x0)
> setsockopt$inet_tcp_TCP_MD5SIG(r0, 0x6, 0xe, &(0x7f0000000080)=3D{@in=3D{=
{0x2, 0x0, @remote}}, 0x0, 0x0, 0x47, 0x0, "2a34e559cc66f8b453edeb61450c389=
9cc1d1304f0e5f1758293ddd3597b84447d3056ed871ae397b0fd27a54e4ff8ba83f0cf3e5f=
323acb74f974c0b87333e0570e9019d8fdcf0bc1044a5e96d68296"}, 0xd8)
