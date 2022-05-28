Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0D536BBA
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 10:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiE1Is1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 04:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiE1Is0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 04:48:26 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984CB245B0
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 01:48:25 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id f12so143840ilj.1
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 01:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=o86lPL239hgThaxEgxzxXRRG18rh0IBJUgZL+T4mLXo=;
        b=fMsN9f7lsl4ZIHH/QyRbQGVdHBx0VZ4aTw1a2gg0kSvSwa041pIaNbi+PIWz4fzMVi
         xkK+s6nWO+f9B4ZeaC/rZRuraktCXZQ4cE1JJ22QqfPZQ//HP4CoAOZfMyeghiz/C1Lz
         9/dH+qCp1Kn6HF8hh5dIfVJ+VKHaojuYSqcMrcqHm7v8ziwx7itsMOnRutfMWnllS3FQ
         HocoFPCQghtnYulyW0PUbXXrb7HiF/bn/xn2i92/iTeE8tYxjwEhm5fMF06kjWqIsvra
         QZgpVPNLIOrYSSk1Ky5Pa6uD4mkqTfZvs4FgaEJzM8Uc+ox2DsTsGygIBLnl8yP29wVX
         oJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=o86lPL239hgThaxEgxzxXRRG18rh0IBJUgZL+T4mLXo=;
        b=nzpX4zhdyBgvxbBymDmj4o5mWaM86bfzHkeFwc3QuNXmkhOsp5qOPuT3KpkgDQxr82
         0Qf7lKtduZcurMDDzvxKLx/P48PlTOsDdIlyuxi58IBlrDtFgexl8pa1PrFnaBrUHVMP
         UC5ohbzitHPCh5l0UlgqHZhshylaBHQc/RuZr/WAZ+Gw8m9j1ofJ7FcTZ0Jm5f82LQlV
         7JLmLvrmtkFbO9NDCg2oseoaSREj4mCeo77pP26P9ez26h/0kKr4qPorVS+rVCxldQ8Q
         TLgrHKZ+ukS1Qxj4fKDn1LoT2i7sngg9N+7aeajFRz1z9u6MMMsfjkGfTMXiKv9jyJ0I
         YFaw==
X-Gm-Message-State: AOAM531/ei0X42x+lW4rM8OVFKcdoivOqXm5leK2Z8AK8rCowf2vJsm1
        dA2rdZfZjrziRatqOGCWydiv3Eolc+5sYEKM0ssgww==
X-Google-Smtp-Source: ABdhPJxKPOt+wAmUepKHZm6Ai9MdPZr1oi6i2JLYkE3PAs+PIDyTrWGsl4Cr8xwjTPTnb3p3FrUHMc6eLXhu1H6xJ/s=
X-Received: by 2002:a05:6e02:178b:b0:2d1:ddcc:ebbb with SMTP id
 y11-20020a056e02178b00b002d1ddccebbbmr8297059ilu.277.1653727704749; Sat, 28
 May 2022 01:48:24 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sat, 28 May 2022 01:48:13 -0700
Message-ID: <CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com>
Subject: REGRESSION?? ping ipv4 sockets and binding to 255.255.255.255 without IP_TRANSPARENT
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Android net test framework fails (on 5.17+ but not on 5.16) due to:

  commit 8ff978b8b222bc9d51dd109a46b51026336c95d8
  ipv4/raw: support binding to nonlocal addresses

(quoting relevant portions)

+++ b/include/net/inet_sock.h
+static inline bool inet_addr_valid_or_nonlocal(struct net *net,
+                                              struct inet_sock *inet,
+                                              __be32 addr,
+                                              int addr_type)
+{
+       return inet_can_nonlocal_bind(net, inet) ||
+               addr =3D=3D htonl(INADDR_ANY) ||
+               addr_type =3D=3D RTN_LOCAL ||
+               addr_type =3D=3D RTN_MULTICAST ||
+               addr_type =3D=3D RTN_BROADCAST;
+}
+

+++ b/net/ipv4/ping.c
@@ -311,15 +311,11 @@ static int ping_check_bind_addr(struct sock *sk,
struct inet_sock *isk,
                pr_debug("ping_check_bind_addr(sk=3D%p,addr=3D%pI4,port=3D%=
d)\n",
                         sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port))=
;

-               if (addr->sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
-                       chk_addr_ret =3D RTN_LOCAL;
-               else
-                       chk_addr_ret =3D inet_addr_type(net,
addr->sin_addr.s_addr);
-
-               if ((!inet_can_nonlocal_bind(net, isk) &&
-                    chk_addr_ret !=3D RTN_LOCAL) ||
-                   chk_addr_ret =3D=3D RTN_MULTICAST ||   <---  note this
was =3D=3D not !=3D
-                   chk_addr_ret =3D=3D RTN_BROADCAST)   <---- ditto
+               chk_addr_ret =3D inet_addr_type(net, addr->sin_addr.s_addr)=
;
+
+               if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
+                                                addr->sin_addr.s_addr,
+                                                chk_addr_ret))
                        return -EADDRNOTAVAIL;

The test case is:
  sudo bash -c "echo 0 $[0x7FFFFFFF] > /proc/sys/net/ipv4/ping_group_range"

  python3 <<-EOF
  import socket
  s =3D socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_ICM=
P)
  s.bind(("255.255.255.255", 1026))
  EOF

This is *expected* to fail with ENOADDRAVAIL (and used to), but now succeed=
s.
(ie. OSError: [Errno 99] Cannot assign requested address )

Looking at the commit message of the above commit, this change in behaviour
isn't actually described as something it does... so it might be an
unintended consequence (ie. bug).

I can easily relax the test to skip this test case on 5.17+...
although I'm not entirely certain
we don't depend on this somewhere... While I sort of doubt that, I
wonder if this has some security implications???.

My main problem is that binding the source of a ping socket to a
multicast or broadcast address does seem pretty bogus...
and this is not something I would want unprivileged users to be able to do.=
..

I've verified reverting the net/ipv4/ping.c chunk of the above commit
does indeed fix the testcase.

Thoughts? Skip test? or fix the kernel to disallow it?

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
