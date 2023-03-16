Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6306BD095
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCPNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjCPNRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:17:30 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2EFCC307
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:17:08 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EADD741BA7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678972625;
        bh=TIeBauVImjPXzYAvRcfNoVw+yoh5HGBy0fsQQgD7rqw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=LirlVIVO5vxhKzZjCHVO4YShg6n0Og0BMBf6HxDHplaSacXrq37vXJ2AphJHLYM99
         E21npDYjHfwwBNupe4ENTHwH5c1C25vdUgDYu2HxAlEYzLUTA4hM0os1tHHD04nte0
         yDxKnkPDr8gDcIJ1zCwFdeG2Nc8+yptQBV5k8hwrAkqCjPrNMI88wvzRv9yE1Tve2g
         Toesh8W+UqslEWWoG8jF+bVh/gYRjpRoHCFiYsGpja8q5AixkQBiaTkAo5E4KOj0ZE
         6WsmLGxJC+oNregMUi0Hn0IZjX53wXDfcHPrPSGMfKq0WGFURaHduvMZYOkjKA86ph
         de74Q94J+qM/g==
Received: by mail-ed1-f72.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso2971394edu.17
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TIeBauVImjPXzYAvRcfNoVw+yoh5HGBy0fsQQgD7rqw=;
        b=IEUplA7yG7kkq94xX/12mLBnrSSSqOZHb1x6hHuO2eP1IbSsos/ryLPwurz7dRCeHm
         4zwHXX8EEPGIem7wPkqeCwoJBcT4smof7xdm+WrJ0y5EPRLfI+N/9dRpceCLBECrMnjI
         0Ua3ioAcxBhZLhxILl8WIaDFbYAsBwShltiGoIwHNpvcKpYQlwERHIC6B6fmhhRS2dmV
         epI2syUN7w3LgHB4reL1AlEJzQ0MeknnNH46QGwL2wh+YPz376dHzYEl+7DlK8+ukfF5
         yYmuOjplTZHd3pYGpNY8iaE8ZKZcZjRjNBO9AMMPhEgVue9CHyw2FcyTMRJvmI1w16uz
         ezHA==
X-Gm-Message-State: AO0yUKWGdOWSSkrztc4xq4yHqzPj0ZLEQWax3TLZ6x+AExOSQw79Qyx0
        u+8azm4P+CE3VQFvZ1GtLrg9BXGYfu/GeSOvjTihjvIgX0477jDfbdh4LvWnN7shIP7vH2LjGji
        3WVnTrSnl0RcYXghZ8nqEzqzkspmaMftnIg==
X-Received: by 2002:a05:6402:10d3:b0:4fd:8333:e29f with SMTP id p19-20020a05640210d300b004fd8333e29fmr6590978edu.41.1678972625680;
        Thu, 16 Mar 2023 06:17:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set/d6Gqh8ZNR1f9QpudCgLyrB70ZekM7LGV0RQ4Y3rmXQsXKlMCP87/MWnPkD7pWqvlcSjtrbA==
X-Received: by 2002:a05:6402:10d3:b0:4fd:8333:e29f with SMTP id p19-20020a05640210d300b004fd8333e29fmr6590950edu.41.1678972625375;
        Thu, 16 Mar 2023 06:17:05 -0700 (PDT)
Received: from amikhalitsyn.. ([2a02:8109:bd40:1414:5e7c:880e:420d:8cc7])
        by smtp.gmail.com with ESMTPSA id d20-20020a50cd54000000b004fd1ee3f723sm3812336edj.67.2023.03.16.06.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:17:04 -0700 (PDT)
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
        linux-arch@vger.kernel.org
Subject: [PATCH net-next 2/3] net: core: add getsockopt SO_PEERPIDFD
Date:   Thu, 16 Mar 2023 14:15:25 +0100
Message-Id: <20230316131526.283569-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 arch/alpha/include/uapi/asm/socket.h    |  1 +
 arch/mips/include/uapi/asm/socket.h     |  1 +
 arch/parisc/include/uapi/asm/socket.h   |  1 +
 arch/sparc/include/uapi/asm/socket.h    |  1 +
 include/uapi/asm-generic/socket.h       |  1 +
 net/core/sock.c                         | 24 ++++++++++++++++++++++++
 tools/include/uapi/asm-generic/socket.h |  1 +
 7 files changed, 30 insertions(+)

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
index 3f974246ba3e..3aa1ccd4bcf3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1763,6 +1763,30 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		goto lenout;
 	}
 
+	case SO_PEERPIDFD:
+	{
+		struct pid *peer_pid;
+		int pidfd;
+		if (len > sizeof(pidfd))
+			len = sizeof(pidfd);
+
+		spin_lock(&sk->sk_peer_lock);
+		peer_pid = get_pid(sk->sk_peer_pid);
+		spin_unlock(&sk->sk_peer_lock);
+
+		if (!peer_pid ||
+		    !pid_has_task(peer_pid, PIDTYPE_TGID))
+			pidfd = -ESRCH;
+		else
+			pidfd = pidfd_create(peer_pid, 0);
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

