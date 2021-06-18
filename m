Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23343ACD9B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhFROfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFROfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:35:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B78C061574;
        Fri, 18 Jun 2021 07:33:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k22-20020a17090aef16b0290163512accedso7286215pjz.0;
        Fri, 18 Jun 2021 07:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GKvf9rlx+iJJiqPLHHqeWdx4Fzi+fAGaRpvuS2pVCM=;
        b=LOy35p5WFfPKtpMtzXLBXwo2tw/F25JEmwoC7IKaKmcnG5XfN1Y4rQon0BNoGO1Rgt
         HfjFUb7cEdVvKSOrOx6gdRNflqNFMtApBRsrndS12TUxPN2HLHhZGnpQwebs8Ijg4Rt5
         bVVUsTBVfA7O1MLGnQUYpVUlZXJktJn0uPrj1FLbTfRydHQ7t0w0NAN6Rlvf8XxOWRUB
         TyRA+WyltpC7Hp2J/CR0nmx8/F5qC4CD8zatmUHZ0cdoLk1zHFtAjRpoUcP66WMcsrhZ
         kN4rt1xml+Ho0k0uHweSuEcBnULOOTyvFMr2+2t42YyDml0fbZAzHY1pPttF4HkG4ls1
         8zUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GKvf9rlx+iJJiqPLHHqeWdx4Fzi+fAGaRpvuS2pVCM=;
        b=sSgM/JPt1KBhGTSD6uN3PSyRtckfEyYb65Ua2EbQnT6JSH3mgrLqY5pFlv2jfPEuBb
         4bvsitDVe+KiI50agutChC8p/Xi610hR4+KlXOlVvsPEAoZTbNGZISF8n9NpEnH6HWcJ
         OQDhOtxvAiLmpYWBqSDq757J/5UFVX87bfOF+fsO90ujgccEcYvmLwGjGyCvq6MHbQpP
         GjIF+5Gm2FH/CqugZk/kTySfekeq16k4y4JBzhMwe2o3MwsIGIQy1BaFda++JInisIXp
         5ghC4zM7/4QplGvGla9SlpEK3wH7DjkZEl3df+IFPg5ojztp5nDhHd5PIZOAqJ8qBEVF
         IjZw==
X-Gm-Message-State: AOAM531otTyhvtndqsA1zA5UJNmOWmjdJdtOCaWztJXCp9v9dxeXjsJR
        Ci5mMSmc3h5o8VkQyQcGIsggfVsRE/ilKs7v
X-Google-Smtp-Source: ABdhPJwwvkLc53aBNKEcB1P5wwvCtfPDYiUU8V5jQpgRhggO3BchDSznU1EtFWRPZsznY6SJXcUR/w==
X-Received: by 2002:a17:90b:3c7:: with SMTP id go7mr21934658pjb.113.1624026812279;
        Fri, 18 Jun 2021 07:33:32 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id y20sm9528191pfb.207.2021.06.18.07.33.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 07:33:26 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH] net: add pf_family_names[] for protocol family
Date:   Fri, 18 Jun 2021 22:32:47 +0800
Message-Id: <20210618143247.3690-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the pr_info content from int to char *, this looks more readable.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 include/uapi/linux/net.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/socket.c             |  2 +-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/net.h b/include/uapi/linux/net.h
index 4dabec6..a28caaf 100644
--- a/include/uapi/linux/net.h
+++ b/include/uapi/linux/net.h
@@ -55,4 +55,52 @@ typedef enum {
 
 #define __SO_ACCEPTCON	(1 << 16)	/* performed a listen		*/
 
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
 #endif /* _UAPI_LINUX_NET_H */
diff --git a/net/socket.c b/net/socket.c
index 27e3e7d..ff544cf 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2988,7 +2988,7 @@ int sock_register(const struct net_proto_family *ops)
 	}
 	spin_unlock(&net_family_lock);
 
-	pr_info("NET: Registered protocol family %d\n", ops->family);
+	pr_info("NET: Registered %s protocol family\n", pf_family_names[ops->family]);
 	return err;
 }
 EXPORT_SYMBOL(sock_register);
-- 
2.7.4

