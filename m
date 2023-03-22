Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9E6C4D54
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCVOTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjCVOSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:18:46 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325FB65066
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:18:16 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 791F64185C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679494692;
        bh=7XZVyJw56GOSYCywV6LPILMZhj++FZFsBU6mgCuT8fQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=VQYrKktrnLgqItulloCSwlvz2afiiR0sC3L8iiAwwvssAbXt+tmQTIaPcaUOXvsKs
         Cb8sbFC4dcMdeYPLD2qvZkk4pCxAoBjjAvBjsPQ73VOFekjwt0Q3aXwsoAbr3Exw/A
         lum3wE6nMRorlg0Ult1EXLnezhbQ683fSMyUs7bJa71kHhoQS61lp6dkHX8B92LxBs
         FUgPXZeyyIlb/NPgMCUqv88RPc2uYrmpwhNBwBvyBkl9CE2mBa5Hov+J9UC5OomhEh
         Tlb0FVqJp2QWHO3X5CE5NEvnk1RAOFyxiE313jhDyp3U46jbQTiMy9WD+LBh87ZMgu
         Z7pYqB+KNP17Q==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-54196bfcd5fso185633597b3.4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679494689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XZVyJw56GOSYCywV6LPILMZhj++FZFsBU6mgCuT8fQ=;
        b=SK8VsRY7Y84mHqCZULCVsXY4Hu35/qQoz2z0WmpIFkOHHLIwRkCniIDGuRF9t+QuN7
         cAvtLv3+Xty8xJacIoNb0UYREvxNyC/VnZGUSpjEVAxKXzRFUoEJ4Jqgm4P1+tV8pUcI
         nGlVMC2f1YWe0wxp9TJ2Pd3U9Jzld5jt8eId7L+9z+aSHMgVKfgGbzOxD4rCj39yG4dK
         ljpe6miE5v5zGXh8Q9AFQiBcSFYZcu5z5yg7GH5x4K11toI3zRKuzaL1y01pd397rtej
         NAtA6Ls/z/o+WBJxDNiHcUq83dhKsVNRQ/4SIRviMnBSrTisBzCucR2+sb3wbflEa7ws
         LDaw==
X-Gm-Message-State: AAQBX9dz13aQ5hgli52NdoxM+G3Zrls9OxXymjbRJFsL0lQ8GW4XOW+w
        gsJqgxomEK3vCqLLAjlwL9Q+nLfrMaymFsRZ/cSkkfyPyL7ryFdIC6z2nwzEBEMJnQq9XhdxeHg
        GHKwHN6oT5mvNu4cm/loRwHMUlxl6NH8CLc1KmemDCzHO4hp/ZA==
X-Received: by 2002:a5b:34a:0:b0:a99:de9d:d504 with SMTP id q10-20020a5b034a000000b00a99de9dd504mr4017149ybp.12.1679494689201;
        Wed, 22 Mar 2023 07:18:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZaWd695Qr21xcE8I1197J/xWJayD/EbAbBFsqd+2Q3QKbwsqkT95oOZVCdGbYgv0QLG2bxQu7uTn00fpCib4I=
X-Received: by 2002:a5b:34a:0:b0:a99:de9d:d504 with SMTP id
 q10-20020a5b034a000000b00a99de9dd504mr4017144ybp.12.1679494688982; Wed, 22
 Mar 2023 07:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com> <20230322141317.am2j6ml4rvwc5hrx@wittgenstein>
In-Reply-To: <20230322141317.am2j6ml4rvwc5hrx@wittgenstein>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Mar 2023 15:17:58 +0100
Message-ID: <CAEivzxd6oqxxa1=mTd7pn+MrTotOY71PuuVJDRDCLGc+NY-7oQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] Add SCM_PIDFD and SO_PEERPIDFD
To:     Christian Brauner <brauner@kernel.org>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 3:13=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Mar 21, 2023 at 07:33:39PM +0100, Alexander Mikhalitsyn wrote:
> > 1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDE=
NTIALS,
> > but it contains pidfd instead of plain pid, which allows programmers no=
t
> > to care about PID reuse problem.
> >
> > 2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pid=
fd.
> > This thing is direct analog of SO_PEERCRED which allows to get plain PI=
D.
> >
> > 3. Add SCM_PIDFD / SO_PEERPIDFD kselftest
> >
> > Idea comes from UAPI kernel group:
> > https://uapi-group.org/kernel-features/
> >
> > Big thanks to Christian Brauner and Lennart Poettering for productive
> > discussions about this.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> >
> > Alexander Mikhalitsyn (3):
> >   scm: add SO_PASSPIDFD and SCM_PIDFD
> >   net: core: add getsockopt SO_PEERPIDFD
> >   selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
> >
> >  arch/alpha/include/uapi/asm/socket.h          |   3 +
> >  arch/mips/include/uapi/asm/socket.h           |   3 +
> >  arch/parisc/include/uapi/asm/socket.h         |   3 +
> >  arch/sparc/include/uapi/asm/socket.h          |   3 +
> >  include/linux/net.h                           |   1 +
> >  include/linux/socket.h                        |   1 +
> >  include/net/scm.h                             |  14 +-
> >  include/uapi/asm-generic/socket.h             |   3 +
> >  net/core/sock.c                               |  32 ++
> >  net/mptcp/sockopt.c                           |   1 +
> >  net/unix/af_unix.c                            |  18 +-
> >  tools/include/uapi/asm-generic/socket.h       |   3 +
> >  tools/testing/selftests/net/.gitignore        |   1 +
> >  tools/testing/selftests/net/af_unix/Makefile  |   3 +-
> >  .../testing/selftests/net/af_unix/scm_pidfd.c | 336 ++++++++++++++++++
> >  15 files changed, 417 insertions(+), 8 deletions(-)
> >  create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c
>
> What's the commit for this work? Because this seems to fail to apply
> cleanly on anything from v6.3-rc1 until v6.3-rc3.

It's based on net-next https://git.kernel.org/netdev/net-next/c/a02d83f9947=
d

Kind regards,
Alex

>
