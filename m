Return-Path: <netdev+bounces-3320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 086217066C9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD57B2810CC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFF12C736;
	Wed, 17 May 2023 11:34:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C514211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:34:21 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974363A9C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:34:16 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EAF4F3F4DF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684323254;
	bh=HKuR0leq9JWpjhp3ZyDhJpalTo2jRYOfikwPIv5EKao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
	b=m0WgXMRpog6kLp/Ne6xB8SQuqX7agz2xFzO+ZrRiPuL98uU3oKHtLdDDK1u2GcrJz
	 jwpAUPUo9eumJ1nR03mYgyD5x3bxb/CDxiNv2JHNUDFxigPeLh5PGrPoVyrWWtBENr
	 yaDRn6lVbI7GKlTJ+cb7hcO38K7241WaNPCMB2/Sbj64V2fHTUOY/em4aVfp1flU67
	 NIDTi5JYkZv3q6CG0yKZDQwen0bKfpEXPNqvmZ35ig6TK+i4gFG+FF97mV7U1dE5KE
	 27VM+bzUihml0xhCV2OMXChKvRFtFBgmb/qNeCcUXizaA7IMVeOlFZW/opGd4Lb0Zn
	 IWycF5vxL/wNw==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-965e5cfca7cso86301166b.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684323254; x=1686915254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HKuR0leq9JWpjhp3ZyDhJpalTo2jRYOfikwPIv5EKao=;
        b=bN0EXjiUyBkrGjz5Xk5gGDbvxcBVCAeSdJsUTtNNTPYbSX+wAdp2BAfIpXVL4NFBq+
         sGS/bAkz26dh/Xgy5Uwi1+LeE4yZn+uMPLK89FlRFQhvg+MnL19hYsx3xj9q6thGuFsq
         CP6TxEtR13HWwoBiSSSAtIHLNqYoQeAbcDa6LjDvN5Ps8trGbZrn1U5Q0y4n4g6wZgig
         g1oRKOe8R4sPzDX8dBe9uPNseHJUJRQyLHWHgmpDHaNDGX6KrjU6xzSylFKiFjee6IKX
         TYmTRTxQZmu8CvdFikqrWgUzhhnoAvSrMt4JwIH3FiXsqs8ofUSjOQMr94m3zSomMl8m
         iapQ==
X-Gm-Message-State: AC+VfDyHML7rtqyknOJg2Wv8MgvFptJs+T2D1ZA+xJkvztezC1Oc5e1O
	8zlTFDXpVwlb3GbjUxEvwD+HV2wcWKBGXx7PaFVav03/drycYZCWa9Ny4wtAKkJ6evKCnEs9Z9b
	sKS+5yCWKRopETOdV7KAaJk0I3lWak3DQ+w==
X-Received: by 2002:a17:907:6e10:b0:968:1e8:a754 with SMTP id sd16-20020a1709076e1000b0096801e8a754mr27137050ejc.72.1684323254553;
        Wed, 17 May 2023 04:34:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5hPlyLnjaPKKQqlm5H00NNoerrsreBCcVJ8rGUa9razY3/8sGLsh64ku66WUbR5wlgxgjTvA==
X-Received: by 2002:a17:907:6e10:b0:968:1e8:a754 with SMTP id sd16-20020a1709076e1000b0096801e8a754mr27137015ejc.72.1684323254166;
        Wed, 17 May 2023 04:34:14 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p1-20020a170906838100b009662b4230cesm12404387ejx.148.2023.05.17.04.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:34:13 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
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
	Luca Boccassi <bluca@debian.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>
Subject: [PATCH net-next v5 0/3] Add SCM_PIDFD and SO_PEERPIDFD
Date: Wed, 17 May 2023 13:33:48 +0200
Message-Id: <20230517113351.308771-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Stanislav Fomichev <sdf@google.com>

Tested-by: Luca Boccassi <bluca@debian.org>

Alexander Mikhalitsyn (3):
  scm: add SO_PASSPIDFD and SCM_PIDFD
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
 net/unix/af_unix.c                            |  34 +-
 tools/include/uapi/asm-generic/socket.h       |   3 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 430 ++++++++++++++++++
 15 files changed, 564 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

-- 
2.34.1


