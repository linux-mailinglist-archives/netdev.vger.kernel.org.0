Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647F240A5E2
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhINFUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbhINFUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:20:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28479C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:18:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h3so11636373pgb.7
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtbDDcJrGWDDTdVFkFJ4E28VZe4unPdXc0NjzTsWPZY=;
        b=dKvq1bLol4LmQ+yz66SgxtB0bxEodNzV5bcqriL+RQ2uHz2eesru5xMzQBPlx8gTR0
         fdKnJ48YsOGXoeoAn1f/zI5EvojJfYjVt/3/CNAWzRbwLmliBvPHY+PcQuLk9YHR0Ne9
         qqtyfQNcejBZH6/DMz+hiyH4qHb8qIYz986sfajSpXCRq6NRGo+enNcDZxwGGdJp9Woy
         Qi4Z/UuBd4605wejjSiq2Uo/pb4ISUxYA9MTOwJNMTyO092q4hZkyZ9dbdDdCs2CWRl2
         FA0dJtu2A8+zcMeQbFXiHYxXaVmGMI1I1oBDGq3iHXFr6+SNJ5wNFh1GEtAOEj3F1Pwv
         llvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtbDDcJrGWDDTdVFkFJ4E28VZe4unPdXc0NjzTsWPZY=;
        b=X/FcSrvGMjF44WCrtbmvmh1lk8S84VXEx/UNZNepBCqw//IOyokOe/aW+tHwyjKuZj
         SwIYta6ePJULcrQtkQ1FJ32ftYqb4FBNe7sPlzDLqGq2i08f3MrSoO6X+AY5TM7ULuJf
         CfrfVjv9rzPsL/FtSJw1VxngHtrWtyjTQ1PQR3Nx6VvYynClOLvcuu2nwovifTFChwV+
         MpE+0A8KWVaJpc3tmgq8QXdqs893JlssMNEedn0heTtH25bvYvHSATHZTDpNQcVKyj9I
         Cb59dk+tTNeV75XneX3WHiI+lwBB6bMBwukgPGGlhR6agGkcr1DFOpiOcIAIQGD8q7ob
         8wDg==
X-Gm-Message-State: AOAM5338lYouXBNGpfa6V1pmd7WEHNdBrSs5h04BAE8kEL3ggLn4J3vL
        6QpBRiTD793WBYL9/RHEc2AjEL7u1ok=
X-Google-Smtp-Source: ABdhPJxJxrJB9qwT2zKRWMnbo8VAZoLktuxY6HmulGOSiJIYiO6hEJ8t1fufUFDorpXbWcPivNoyoQ==
X-Received: by 2002:a05:6a00:164c:b0:434:a68b:326a with SMTP id m12-20020a056a00164c00b00434a68b326amr2952050pfc.63.1631596734674;
        Mon, 13 Sep 2021 22:18:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:77da:7605:5a70:a0cd])
        by smtp.gmail.com with ESMTPSA id e13sm8625614pfi.210.2021.09.13.22.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 22:18:54 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net] Revert "Revert "ipv4: fix memory leaks in ip_cmsg_send() callers""
Date:   Mon, 13 Sep 2021 22:18:51 -0700
Message-Id: <20210914051851.1056723-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commit d7807a9adf4856171f8441f13078c33941df48ab.

As mentioned in https://lkml.org/lkml/2021/9/13/1819
5 years old commit 919483096bfe ("ipv4: fix memory leaks in ip_cmsg_send() callers")
was a correct fix.

  ip_cmsg_send() can loop over multiple cmsghdr()

  If IP_RETOPTS has been successful, but following cmsghdr generates an error,
  we do not free ipc.ok

  If IP_RETOPTS is not successful, we have freed the allocated temporary space,
  not the one currently in ipc.opt.

Sure, code could be refactored, but let's not bring back old bugs.

Fixes: d7807a9adf48 ("Revert "ipv4: fix memory leaks in ip_cmsg_send() callers"")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/ip_sockglue.c | 2 +-
 net/ipv4/ping.c        | 5 +++--
 net/ipv4/raw.c         | 5 +++--
 net/ipv4/udp.c         | 5 +++--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 7cef9987ab4ace4444c4b470a3393ce50219a69a..b297bb28556ec5cf383068f67ee910af38591cc3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -279,7 +279,7 @@ int ip_cmsg_send(struct sock *sk, struct msghdr *msg, struct ipcm_cookie *ipc,
 		case IP_RETOPTS:
 			err = cmsg->cmsg_len - sizeof(struct cmsghdr);
 
-			/* Our caller is responsible for freeing ipc->opt when err = 0 */
+			/* Our caller is responsible for freeing ipc->opt */
 			err = ip_options_get(net, &ipc->opt,
 					     KERNEL_SOCKPTR(CMSG_DATA(cmsg)),
 					     err < 40 ? err : 40);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index c588f9f2f46c2b91fc9424ecfc0590b2b63a3470..1e44a43acfe2dfe57efdc64479c2d18402881d73 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -727,9 +727,10 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
-		if (unlikely(err))
+		if (unlikely(err)) {
+			kfree(ipc.opt);
 			return err;
-
+		}
 		if (ipc.opt)
 			free = 1;
 	}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 1c98063a3ae816ecfd7135b0168fea5a9380676f..bb446e60cf58057b448f094b4d6f48d6e91d113c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -562,9 +562,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (msg->msg_controllen) {
 		err = ip_cmsg_send(sk, msg, &ipc, false);
-		if (unlikely(err))
+		if (unlikely(err)) {
+			kfree(ipc.opt);
 			goto out;
-
+		}
 		if (ipc.opt)
 			free = 1;
 	}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d5f5981d7a43244cace63653b790a34174364e3e..8851c9463b4b62c9017565f545250c4ffe22927c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1122,9 +1122,10 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (err > 0)
 			err = ip_cmsg_send(sk, msg, &ipc,
 					   sk->sk_family == AF_INET6);
-		if (unlikely(err < 0))
+		if (unlikely(err < 0)) {
+			kfree(ipc.opt);
 			return err;
-
+		}
 		if (ipc.opt)
 			free = 1;
 		connected = 0;
-- 
2.33.0.309.g3052b89438-goog

