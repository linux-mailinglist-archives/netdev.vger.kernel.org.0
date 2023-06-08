Return-Path: <netdev+bounces-9357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9860472896A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF7D51C21002
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541A231EE7;
	Thu,  8 Jun 2023 20:26:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4965D31EE4
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:26:48 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990572D68
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:26:45 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 753EE3F33C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686256003;
	bh=LbwhS6u2Gc04e5gm9H5aiasFIe5ctbHPuzK68rld63g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
	b=ojSSSP9EZHOmz2TCfwH1p9PJhwM9DpfXRGQlLiyO7jlqcHpdzDz/9GLBnl6Vx7TlW
	 dYRtqbsMmGR1GLMTCL6gEYuypAfv/3yuvg5djv/oWVqATwmr1qtW5cipg+e9TRa73Y
	 6hFc0AcEifRzb/f3mx4Ht39a8+Ze8jieMyDR26xL8NfWLWAoj62JfZ76Plj+B83xO0
	 BDF8rxSycoXT90ZL1d6HTrp0LH1mzDBsvyoXERrzRGY+u8VenBCleAECm5+go1+kzV
	 xpHKL+GJozO0UkzmObo0U5Nv0/4mCsxG3YsfTGdbQjjemqiY86gLxuADcC3XEYj8lv
	 8Ei29+f4Utu6w==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-977cf886f17so86997966b.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 13:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686256002; x=1688848002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbwhS6u2Gc04e5gm9H5aiasFIe5ctbHPuzK68rld63g=;
        b=HXQG7vrIuHembYPQQG85opW7dw8bSuhgCj2rb/O9Lzu7GfFn3JsPQJH2fOXrnH8Gd4
         j2/ZVP60uZ1PKnwkGJWoQ06htlho17hltuNcbAkfQPZyZQNt+VmWLwXwQNm3Mzl6xeTr
         //ndIH1v91au+krbdW6zMOeha0izkWo86f0LJPRyzRd4nsiB3+nOXjBvnpJ1YtX0VpDI
         vzrYQUwwRP1QB6jD2//3SAZQFevxejTMXwRjLju3D50MrOwNtZavC3Mijds6BO+0Ph6I
         DvosBBR7MhHjCU92F74FCw4ayLOq1+c0+v7Urud/mLyfw7i2HQtx+B94DPQpvNxXDtGP
         7NPw==
X-Gm-Message-State: AC+VfDzSMCZw/K21SQukwkEsI/IsRaWBpyhodq+jHi9MOa8KCbxMbxlB
	p6GFWZKLmJW6SKYszBgRG/X7jMop+LlzpV+WPpULDh/DDyt8xff3qrrUzNKTG8riosYowKQY7y6
	6ICDT0sURLvvtMfehVOpJFhxc2zWtGdo0Rg==
X-Received: by 2002:a17:906:4fcb:b0:977:95f4:5cca with SMTP id i11-20020a1709064fcb00b0097795f45ccamr194485ejw.54.1686256002308;
        Thu, 08 Jun 2023 13:26:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4OdGLWAJDBbmUZ+EFtvntonHfbS8gV6YTP0DXZiZb5dI99NbU9VgBDkiFNL4tXYXEHDjTVBw==
X-Received: by 2002:a17:906:4fcb:b0:977:95f4:5cca with SMTP id i11-20020a1709064fcb00b0097795f45ccamr194475ejw.54.1686256002010;
        Thu, 08 Jun 2023 13:26:42 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906491000b0095342bfb701sm315592ejq.16.2023.06.08.13.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:26:41 -0700 (PDT)
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
Subject: [PATCH net-next v7 0/4] Add SCM_PIDFD and SO_PEERPIDFD
Date: Thu,  8 Jun 2023 22:26:24 +0200
Message-Id: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
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

Alexander Mikhalitsyn (4):
  scm: add SO_PASSPIDFD and SCM_PIDFD
  net: core: add getsockopt SO_PEERPIDFD
  selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
  af_unix: Kconfig: make CONFIG_UNIX bool

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
 net/unix/Kconfig                              |   6 +-
 net/unix/af_unix.c                            |  34 +-
 tools/include/uapi/asm-generic/socket.h       |   3 +
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 430 ++++++++++++++++++
 16 files changed, 565 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

-- 
2.34.1


