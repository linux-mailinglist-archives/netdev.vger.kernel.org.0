Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDECC6C3967
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjCUSpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjCUSpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:45:40 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F253739
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:38 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 91AC444526
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679424337;
        bh=Mx9copdPAUdn8FijFDNq0iA18WBzMqS1dQbdSvHOv/I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ODgSclNEAJ8m9nPr1rHxo9zHRiJP8gH8UItzr+MgrZjAvxidjbFPfmRbLDK3sxAh+
         QNRkwqdUQBEVfwYSrpFKYYQb8+wt30GotUfKMjRYqFxkCVYngv+YxGVRgrPiMjuTdy
         4X8luyLlpKzPbry8xdH04cKlN9BMsDAj7cyxqaoFSDKE++EwnFSDPN/MAjkb8rDAL+
         hBK0NFsCmYPP27qlQw4ym/cxzYwHP0p8DrN/gRoJdccucv5lBbOORKo/EZRqWbLmdQ
         oZcXhPEc5GUU3POhuZpMcO1Q6X5FoRH8hHAmgSTRgl0KAN47Lq9Qc0KNmocZPWeM5n
         Ok3pZI+ciYfgw==
Received: by mail-ed1-f69.google.com with SMTP id i42-20020a0564020f2a00b004fd23c238beso23246490eda.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mx9copdPAUdn8FijFDNq0iA18WBzMqS1dQbdSvHOv/I=;
        b=7UMhelExlc/pXKLQDWNfZ6OrSwNM8IcLNtoN5DFlV0QuvBXBCOYn/zSnRrTy5ysiAz
         kxoczmXI8RSQHCq+xrIEFkxz31Ubrl+jCv6vApXQwFt++e2OEKYH/2Li08j3QHUSFw4M
         vnurLgmaYv8f9V6+vrMXcHKTnkaLCM0+hGralijVFlWdvf5C/sIWvYpTMOn0F/71Cvyk
         R7ICgqXEIuV8ct3vfHQGDEImx4/TxMMTOSF1bGphSh08JX9r2tZk03jcOXVl1UCNCT7o
         FuvtczTzwqILeDMORGxJM6aDfTUjtcbwl8mLTaHHQsRVBnp7MkOXPxqAJj68xEZYZUWs
         yNBQ==
X-Gm-Message-State: AO0yUKUVLmEQy1uIAlRGhhXAkHdb4Ajys6xNsgFgwf5fSmePA2kU0094
        e5rOEQJA9WSikNPVZvnbZRDA6ImRZSiIX551OLW58w8i5OTr51GqcrLb/8gkD7MR+qKqqzyRv+N
        Z+ICv03yk5uWbuWtB2+CDs4RR/k00ACtTX899uxlazA==
X-Received: by 2002:a17:906:d54f:b0:8e9:afb1:65c6 with SMTP id cr15-20020a170906d54f00b008e9afb165c6mr16973848ejc.13.1679424336938;
        Tue, 21 Mar 2023 11:45:36 -0700 (PDT)
X-Google-Smtp-Source: AK7set8ol/PaGR4Y7Bnh4yVDAV14YWMIHSPPQrt1OyJgTZQRkjL+kCk0hq7JDvRnWKqPYjt597SMwQ==
X-Received: by 2002:a17:906:d54f:b0:8e9:afb1:65c6 with SMTP id cr15-20020a170906d54f00b008e9afb165c6mr16973833ejc.13.1679424336713;
        Tue, 21 Mar 2023 11:45:36 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bd076.dynamic.kabel-deutschland.de. [95.91.208.118])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709060e8900b0093313f4fc3csm4928194ejf.70.2023.03.21.11.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 11:45:36 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
        linux-arch@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: core: add getsockopt SO_PEERPIDFD
Date:   Tue, 21 Mar 2023 19:33:41 +0100
Message-Id: <20230321183342.617114-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
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

Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
This thing is direct analog of SO_PEERCRED which allows to get plain PID.

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
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v2:
	According to review comments from Kuniyuki Iwashima and Christian Brauner:
	- use pidfd_create(..) retval as a result
	- whitespace change
---
 arch/alpha/include/uapi/asm/socket.h    |  1 +
 arch/mips/include/uapi/asm/socket.h     |  1 +
 arch/parisc/include/uapi/asm/socket.h   |  1 +
 arch/sparc/include/uapi/asm/socket.h    |  1 +
 include/uapi/asm-generic/socket.h       |  1 +
 net/core/sock.c                         | 21 +++++++++++++++++++++
 tools/include/uapi/asm-generic/socket.h |  1 +
 7 files changed, 27 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index ff310613ae64..e94f621903fe 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -138,6 +138,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 762dcb80e4ec..60ebaed28a4c 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -149,6 +149,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index df16a3e16d64..be264c2b1a11 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -130,6 +130,7 @@
 #define SO_RCVMARK		0x4049
 
 #define SO_PASSPIDFD		0x404A
+#define SO_PEERPIDFD		0x404B
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 6e2847804fea..682da3714686 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -131,6 +131,7 @@
 #define SO_RCVMARK               0x0054
 
 #define SO_PASSPIDFD             0x0055
+#define SO_PEERPIDFD             0x0056
 
 #if !defined(__KERNEL__)
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index b76169fdb80b..8ce8a39a1e5f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -133,6 +133,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 3f974246ba3e..85c269ca9d8a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1763,6 +1763,27 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		goto lenout;
 	}
 
+	case SO_PEERPIDFD:
+	{
+		struct pid *peer_pid;
+		int pidfd;
+
+		if (len > sizeof(pidfd))
+			len = sizeof(pidfd);
+
+		spin_lock(&sk->sk_peer_lock);
+		peer_pid = get_pid(sk->sk_peer_pid);
+		spin_unlock(&sk->sk_peer_lock);
+
+		pidfd = pidfd_create(peer_pid, 0);
+
+		put_pid(peer_pid);
+
+		if (copy_to_sockptr(optval, &pidfd, len))
+			return -EFAULT;
+		goto lenout;
+	}
+
 	case SO_PEERGROUPS:
 	{
 		const struct cred *cred;
diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
index fbbc4bf53ee3..54d9c8bf7c55 100644
--- a/tools/include/uapi/asm-generic/socket.h
+++ b/tools/include/uapi/asm-generic/socket.h
@@ -122,6 +122,7 @@
 #define SO_RCVMARK		75
 
 #define SO_PASSPIDFD		76
+#define SO_PEERPIDFD		77
 
 #if !defined(__KERNEL__)
 
-- 
2.34.1

