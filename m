Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2283AE29F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 07:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhFUFO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 01:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFUFOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 01:14:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28EC061574;
        Sun, 20 Jun 2021 22:12:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y13so1760732plc.8;
        Sun, 20 Jun 2021 22:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HaH5unS1AysbRIEpLRFXHHZaHGqckXJCcf5aMH0w3qo=;
        b=S7xkkatBIxyw8Ml0wapeOghAojKDBfx59rpe6dQB46KQCr7GX8pYnOa0RjfKxFwNXn
         C1YdFjmWpS7NhFeuW/C/WZ+gLYXRKqRfyGS7WCZnKqVGGsub8rA86Yp4My5jPwwvcNwk
         xYE5+8GtDo1hNz6FFH4IrO43DXB060Egq9N6qBWhp1NgKhdJQJs3DTL7TDN2qPhIJdev
         lyQeA7/9ZgZV9QKmJOkmhNFEStjhLE98fVGSG8Iw4d/cUS65xx7iFSl501ERMQod73kO
         t7mEZIjPUXxKy2mqpvbiFL0gMFPTjDRwr0eVx1c7UxbQ+NV9D2nmL3GIEQptU3/RWlSN
         YC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HaH5unS1AysbRIEpLRFXHHZaHGqckXJCcf5aMH0w3qo=;
        b=M2nzWx59UuLFYgwKy4WCDOVtlHcAYSFGyqXH9QFIxrcOzhKSal6ZLWvy/DGmtGvcXR
         1N4FoN8WqcFAYHy4KU0eVI1+OiylVN8TWl8YFG3s3D9g4hgLcwqC7YsuwFseS2PKdODA
         /1YEr2kwADyVVZkEIhWrY+4iht2YasMYkY3UP7vnzrYJYIInSOouQCx7PAhZv48n4UGg
         Z1Hv/DHo1EC2FSPKKMg2hs0LpH0Rx02AwfQ4OMmMmaeTdVqlsUCAOnhHJhIJ5CjFr0WR
         sTVQxQV5VsUTEizyO5Yt36ADICdEY7YOf9vhNww8vWPW7mkAL2GyMAHxxXUtfOsRmBvG
         fkgw==
X-Gm-Message-State: AOAM533zhQ1Uc/WnU0spRWbBbAWIIqnGSDiH4vf0PDYWMfw+75GnejNi
        gspRLI8YLt11f9oHny46W0GYrupQiwUo5sMj
X-Google-Smtp-Source: ABdhPJxk/okA8AJ+zQxIXq1Dn/2ph8vdLsfFwO7eImZTeWu2At8jjd0XgPBQ9ddLUvYNxfidHPQKSg==
X-Received: by 2002:a17:90a:9302:: with SMTP id p2mr24082918pjo.202.1624252357305;
        Sun, 20 Jun 2021 22:12:37 -0700 (PDT)
Received: from sz-dl-056.autox.sz ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id u7sm15461024pgl.39.2021.06.20.22.12.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jun 2021 22:12:36 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejune.deng@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2] net: add pf_family_names[] for protocol family
Date:   Mon, 21 Jun 2021 13:12:25 +0800
Message-Id: <20210621051225.24018-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the pr_info content from int to char * in sock_register() and
sock_unregister(), this looks more readable.

Fixed build error in ARCH=sparc64.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 net/socket.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 4f2c6d2795d0..bd9233da2497 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -165,6 +165,54 @@ static const struct file_operations socket_file_ops = {
 	.show_fdinfo =	sock_show_fdinfo,
 };
 
+static const char * const pf_family_names[] = {
+	[PF_UNSPEC]	= "PF_UNSPEC",
+	[PF_UNIX]	= "PF_UNIX/PF_LOCAL",
+	[PF_INET]	= "PF_INET",
+	[PF_AX25]	= "PF_AX25",
+	[PF_IPX]	= "PF_IPX",
+	[PF_APPLETALK]	= "PF_APPLETALK",
+	[PF_NETROM]	= "PF_NETROM",
+	[PF_BRIDGE]	= "PF_BRIDGE",
+	[PF_ATMPVC]	= "PF_ATMPVC",
+	[PF_X25]	= "PF_X25",
+	[PF_INET6]	= "PF_INET6",
+	[PF_ROSE]	= "PF_ROSE",
+	[PF_DECnet]	= "PF_DECnet",
+	[PF_NETBEUI]	= "PF_NETBEUI",
+	[PF_SECURITY]	= "PF_SECURITY",
+	[PF_KEY]	= "PF_KEY",
+	[PF_NETLINK]	= "PF_NETLINK/PF_ROUTE",
+	[PF_PACKET]	= "PF_PACKET",
+	[PF_ASH]	= "PF_ASH",
+	[PF_ECONET]	= "PF_ECONET",
+	[PF_ATMSVC]	= "PF_ATMSVC",
+	[PF_RDS]	= "PF_RDS",
+	[PF_SNA]	= "PF_SNA",
+	[PF_IRDA]	= "PF_IRDA",
+	[PF_PPPOX]	= "PF_PPPOX",
+	[PF_WANPIPE]	= "PF_WANPIPE",
+	[PF_LLC]	= "PF_LLC",
+	[PF_IB]		= "PF_IB",
+	[PF_MPLS]	= "PF_MPLS",
+	[PF_CAN]	= "PF_CAN",
+	[PF_TIPC]	= "PF_TIPC",
+	[PF_BLUETOOTH]	= "PF_BLUETOOTH",
+	[PF_IUCV]	= "PF_IUCV",
+	[PF_RXRPC]	= "PF_RXRPC",
+	[PF_ISDN]	= "PF_ISDN",
+	[PF_PHONET]	= "PF_PHONET",
+	[PF_IEEE802154]	= "PF_IEEE802154",
+	[PF_CAIF]	= "PF_CAIF",
+	[PF_ALG]	= "PF_ALG",
+	[PF_NFC]	= "PF_NFC",
+	[PF_VSOCK]	= "PF_VSOCK",
+	[PF_KCM]	= "PF_KCM",
+	[PF_QIPCRTR]	= "PF_QIPCRTR",
+	[PF_SMC]	= "PF_SMC",
+	[PF_XDP]	= "PF_XDP",
+};
+
 /*
  *	The protocol list. Each protocol is registered in here.
  */
@@ -2975,7 +3023,7 @@ int sock_register(const struct net_proto_family *ops)
 	}
 	spin_unlock(&net_family_lock);
 
-	pr_info("NET: Registered protocol family %d\n", ops->family);
+	pr_info("NET: Registered %s protocol family\n", pf_family_names[ops->family]);
 	return err;
 }
 EXPORT_SYMBOL(sock_register);
@@ -3003,7 +3051,7 @@ void sock_unregister(int family)
 
 	synchronize_rcu();
 
-	pr_info("NET: Unregistered protocol family %d\n", family);
+	pr_info("NET: Unregistered %s protocol family\n", pf_family_names[family]);
 }
 EXPORT_SYMBOL(sock_unregister);
 
-- 
2.32.0

