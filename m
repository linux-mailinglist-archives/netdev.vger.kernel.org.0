Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68326E0EED
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjDMNiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjDMNh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:37:29 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B08C169
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:35:16 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 1CB763F4D8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681392878;
        bh=rNULU6RAxGb0BQBeZqXiTKDNImvgPcuxWTYLoRGLo/w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=X0TvC3pb5hUaEzzjJSf2FiczF1/K7a/7T+nzTBs+nO473J0K/fZM5ENugrEOjico2
         t0uTeBIXm3AepQyDl4tc341SU2sNvRDstszwt7++IyOLWd8E79j780NNX3z6hEIosF
         RTUYI/SEBVY47GzL+fdjzpiXO5DWkJViaF5AdUENNGuI8m6s1IkSZTMCe/xpNsykXU
         WMb5qUsiF1h241BPMpp7RkDdp2GCr5y4eafgTdRUNtB7b/EiSZ/S+5PiKTNfmOuD+b
         V2cs1eoryv5gPTjzAulizMUtxTJlmnuoEyDzJMexHrUFQsr3+W/UHb1TKs9SKfDZiW
         /IPxpp7w6aSgg==
Received: by mail-ed1-f71.google.com with SMTP id r1-20020a50d681000000b0050504eaf919so2628254edi.8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681392868; x=1683984868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNULU6RAxGb0BQBeZqXiTKDNImvgPcuxWTYLoRGLo/w=;
        b=crSokVVWoJ3Uc6M1YTyBeAwrQRT4EvLCId28mjKNYNjLM5fzLz/WjTme2FwubihP58
         /VH9Dez3QaStpIvSS0lcKcpA3mXN6/tfiS5JRq5TcG2goK7xu6xacVOIHLS610V7fgIW
         fEMhzURpjDLlJmiS2uu/wSkNQ+N8zEfeFJfLKERHZdzRqqklD8YO2YOTz8Ak+UTW9RN7
         yTJFzSHGDcFO9IGFYbvHPt0Z2AGysQUH6xj2QTbp8UyjCtqFKCXHvNBOpJeJBi7n2n4D
         5h8VnvFAH3Tw5AV9T/TeNWk1ismlqG6OSQP7N7qMqo16pIqHu3HUt4rGefLXej1NC0CZ
         0xbQ==
X-Gm-Message-State: AAQBX9czb2SfI4m6t6DozG4TikNR+ei8t7bI0d5lnaqKOpMHK31xgXeX
        okb2jRqx2duHiUJnMGiGgi4vMB64bDSQkivKAoVXrTITXW1AK9YAwFvulcW7L88It4MhCAFqnWt
        Xz1YuoTG+6r3O7DWSJv1WvMqJAlv1Ktj+EA==
X-Received: by 2002:a17:906:4a94:b0:94a:67a9:6052 with SMTP id x20-20020a1709064a9400b0094a67a96052mr2534949eju.67.1681392868358;
        Thu, 13 Apr 2023 06:34:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350a4+fAjAw/1QDbyv41gi/1EMTYh6zw3QQsJ+TVo04/81Tcy15Y1w8vFTEKCKGgyb6/G4NvG5A==
X-Received: by 2002:a17:906:4a94:b0:94a:67a9:6052 with SMTP id x20-20020a1709064a9400b0094a67a96052mr2534924eju.67.1681392868038;
        Thu, 13 Apr 2023 06:34:28 -0700 (PDT)
Received: from amikhalitsyn.. ([95.91.208.118])
        by smtp.gmail.com with ESMTPSA id et22-20020a170907295600b0094a966330fdsm976806ejc.211.2023.04.13.06.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 06:34:27 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Luca Boccassi <bluca@debian.org>
Subject: [PATCH net-next v4 0/4] Add SCM_PIDFD and SO_PEERPIDFD
Date:   Thu, 13 Apr 2023 15:33:51 +0200
Message-Id: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
but it contains pidfd instead of plain pid, which allows programmers not
to care about PID reuse problem.

2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
This thing is direct analog of SO_PEERCRED which allows to get plain PID.

3. Add SCM_PIDFD / SO_PEERPIDFD kselftest

Idea comes from UAPI kernel group:
https://uapi-group.org/kernel-features/

Big thanks to Christian Brauner and Lennart Poettering for productive
discussions about this and Luca Boccassi for testing and reviewing this.

=== Motivation behind this patchset

Eric Dumazet raised a question:
> It seems that we already can use pidfd_open() (since linux-5.3), and
> pass the resulting fd in af_unix SCM_RIGHTS message ?

Yes, it's possible, but it means that from the receiver side we need
to trust the sent pidfd (in SCM_RIGHTS),
or always use combination of SCM_RIGHTS+SCM_CREDENTIALS, then we can
extract pidfd from SCM_RIGHTS,
then acquire plain pid from pidfd and after compare it with the pid
from SCM_CREDENTIALS.

A few comments from other folks regarding this.

Christian Brauner wrote:

>Let me try and provide some of the missing background.

>There are a range of use-cases where we would like to authenticate a
>client through sockets without being susceptible to PID recycling
>attacks. Currently, we can't do this as the race isn't fully fixable.
>We can only apply mitigations.

>What this patchset will allows us to do is to get a pidfd without the
>client having to send us an fd explicitly via SCM_RIGHTS. As that's
>already possibly as you correctly point out.

>But for protocols like polkit this is quite important. Every message is
>standalone and we would need to force a complete protocol change where
>we would need to require that every client allocate and send a pidfd via
>SCM_RIGHTS. That would also mean patching through all polkit users.

>For something like systemd-journald where we provide logging facilities
>and want to add metadata to the log we would also immensely benefit from
>being able to get a receiver-side controlled pidfd.

>With the message type we envisioned we don't need to change the sender
>at all and can be safe against pid recycling.

>Link: https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/154
>Link: https://uapi-group.org/kernel-features

Lennart Poettering wrote:

>So yes, this is of course possible, but it would mean the pidfd would
>have to be transported as part of the user protocol, explicitly sent
>by the sender. (Moreover, the receiver after receiving the pidfd would
>then still have to somehow be able to prove that the pidfd it just
>received actually refers to the peer's process and not some random
>process. – this part is actually solvable in userspace, but ugly)

>The big thing is simply that we want that the pidfd is associated
>*implicity* with each AF_UNIX connection, not explicitly. A lot of
>userspace already relies on this, both in the authentication area
>(polkit) as well as in the logging area (systemd-journald). Right now
>using the PID field from SO_PEERCREDS/SCM_CREDENTIALS is racy though
>and very hard to get right. Making this available as pidfd too, would
>solve this raciness, without otherwise changing semantics of it all:
>receivers can still enable the creds stuff as they wish, and the data
>is then implicitly appended to the connections/datagrams the sender
>initiates.

>Or to turn this around: things like polkit are typically used to
>authenticate arbitrary dbus methods calls: some service implements a
>dbus method call, and when an unprivileged client then issues that
>call, it will take the client's info, go to polkit and ask it if this
>is ok. If we wanted to send the pidfd as part of the protocol we
>basically would have to extend every single method call to contain the
>client's pidfd along with it as an additional argument, which would be
>a massive undertaking: it would change the prototypes of basically
>*all* methods a service defines… And that's just ugly.

>Note that Alex' patch set doesn't expose anything that wasn't exposed
>before, or attach, propagate what wasn't before. All it does, is make
>the field already available anyway (the struct ucred .pid field)
>available also in a better way (as a pidfd), to solve a variety of
>races, with no effect on the protocol actually spoken within the
>AF_UNIX transport. It's a seamless improvement of the status quo.

===

This patch series is on top of net-next tree with pidfd.file.api.v6.4
tag (from git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git) merged in.

Git tree:
https://github.com/mihalicyn/linux/tree/scm_pidfd

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Luca Boccassi <bluca@debian.org>

Tested-by: Luca Boccassi <bluca@debian.org>

Alexander Mikhalitsyn (4):
  scm: add SO_PASSPIDFD and SCM_PIDFD
  net: socket: add sockopts blacklist for BPF cgroup hook
  net: core: add getsockopt SO_PEERPIDFD
  selftests: net: add SCM_PIDFD / SO_PEERPIDFD test

 arch/alpha/include/uapi/asm/socket.h          |   3 +
 arch/mips/include/uapi/asm/socket.h           |   3 +
 arch/parisc/include/uapi/asm/socket.h         |   3 +
 arch/sparc/include/uapi/asm/socket.h          |   3 +
 include/linux/net.h                           |   1 +
 include/linux/socket.h                        |   1 +
 include/net/scm.h                             |  39 +-
 include/uapi/asm-generic/socket.h             |   3 +
 net/core/sock.c                               |  44 ++
 net/mptcp/sockopt.c                           |   1 +
 net/socket.c                                  |  45 +-
 net/unix/af_unix.c                            |  18 +-
 tools/include/uapi/asm-generic/socket.h       |   3 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   2 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 430 ++++++++++++++++++
 16 files changed, 589 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

-- 
2.34.1

