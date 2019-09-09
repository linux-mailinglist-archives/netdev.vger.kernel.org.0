Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B60CAD455
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388679AbfIIH5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:57:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36581 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfIIH5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:57:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so7350946pgm.3;
        Mon, 09 Sep 2019 00:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=CU2s6tg88IjajhyVTh8zjloCz3yMLwmiGt2Qrh7Vf0E=;
        b=TqW6RiIaG4GdFeON+Wwqs2H2pEO3iBS96Q2SVmsDOCTn4MYx6DU7g1iLPuW3yFc4j8
         SNxCeOBc22BVsjJMR31MP38VCB3JcTpiSfkYkT7mxIcogPQEnhWv5HyqKVHkoj3j2BWK
         Io/5LfuDIGm3r9HeMu1Mh2IlT9pDtbW6sxgPhsNZh0LXd2k3oJZzZ+Y8atAaGI3R8Ndk
         qEccKHiVnMXGAVzwcBz7EPv1CYJEy/3jfbZlZ47Myp6MY5M+s5cpZtWyi4vCI9DJiSye
         LJWlFx2LthQW+5odh2awf/t1CAi8lFQ5C3B3VkYBtNyYqOpcYebemry02wxM9fUfYbuo
         vDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=CU2s6tg88IjajhyVTh8zjloCz3yMLwmiGt2Qrh7Vf0E=;
        b=XMH/RhgWc+jywDHESTPsshNYZe0vnqK+YVHiXwoVhexW4WRry1LT3iQqZjU06zjYxu
         A28wYYiYr0pA/CXDBErBbO7Oaa/o6mgXeRj7GK8iU0IgYFe1CayfwiCkz5pcWQWAg9BD
         t3hs3Y3Akcy3GGO+MYcaCuewSbVkKlw4tooig2K5rLVSF1DFhMm+yAlSNPr5/nRPeMnm
         0UiUiBT3ilG+vFz2pNneR2PIZlfc/f9XrIW7JGoC6YryuDh5YX5sSKgGL9fdfzKku8qZ
         PW6dTbFr8NQjFp+M8pB/RdIrUuI0wQ/hRPzcDhG8qxRi8XU7JbAtQANyPnoiFC30xZX+
         HP6Q==
X-Gm-Message-State: APjAAAVyDpmuwXskS1h6zultFKnqST9gbGHvJLlZgrp0DGUtUSlf0gAX
        WhVmGrJ9oCVTuFEwwIh21aaYtPKWTaU=
X-Google-Smtp-Source: APXvYqxwMNHIkSUvh+j/9F8FqxGimUpmjVbJPty1m6q3G/QetarrHUc7X4qxwm360vECnKsarhvs6g==
X-Received: by 2002:a63:1507:: with SMTP id v7mr19358460pgl.397.1568015858889;
        Mon, 09 Sep 2019 00:57:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p20sm18998335pgi.81.2019.09.09.00.57.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 00:57:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Date:   Mon,  9 Sep 2019 15:56:51 +0800
Message-Id: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
 <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
 <4836d0d8bb96e807b63f46e6c59af78b9b3e286b.1568015756.git.lucien.xin@gmail.com>
 <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568015756.git.lucien.xin@gmail.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
added to allow a user to change ps_retrans per sock/asoc/transport, as
other 2 paddrthlds: pf_retrans, pathmaxrxt.

Note that ps_retrans is not allowed to be greater than pf_retrans.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a15cc28..dfd81e1 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
 	struct sockaddr_storage spt_address;
 	__u16 spt_pathmaxrxt;
 	__u16 spt_pathpfthld;
+	__u16 spt_pathcpthld;
 };
 
 /*
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5e2098b..5b9774d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			   sizeof(struct sctp_paddrthlds)))
 		return -EFAULT;
 
+	if (val.spt_pathpfthld > val.spt_pathcpthld)
+		return -EINVAL;
+
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
 					       val.spt_assoc_id);
@@ -3963,6 +3966,7 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 		if (val.spt_pathmaxrxt)
 			trans->pathmaxrxt = val.spt_pathmaxrxt;
 		trans->pf_retrans = val.spt_pathpfthld;
+		trans->ps_retrans = val.spt_pathcpthld;
 
 		return 0;
 	}
@@ -3978,17 +3982,20 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			if (val.spt_pathmaxrxt)
 				trans->pathmaxrxt = val.spt_pathmaxrxt;
 			trans->pf_retrans = val.spt_pathpfthld;
+			trans->ps_retrans = val.spt_pathcpthld;
 		}
 
 		if (val.spt_pathmaxrxt)
 			asoc->pathmaxrxt = val.spt_pathmaxrxt;
 		asoc->pf_retrans = val.spt_pathpfthld;
+		asoc->ps_retrans = val.spt_pathcpthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		if (val.spt_pathmaxrxt)
 			sp->pathmaxrxt = val.spt_pathmaxrxt;
 		sp->pf_retrans = val.spt_pathpfthld;
+		sp->ps_retrans = val.spt_pathcpthld;
 	}
 
 	return 0;
@@ -7232,6 +7239,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		if (!trans)
 			return -ENOENT;
 
+		val.spt_pathcpthld = trans->ps_retrans;
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
 
@@ -7244,11 +7252,13 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		return -EINVAL;
 
 	if (asoc) {
+		val.spt_pathcpthld = asoc->ps_retrans;
 		val.spt_pathpfthld = asoc->pf_retrans;
 		val.spt_pathmaxrxt = asoc->pathmaxrxt;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
+		val.spt_pathcpthld = sp->ps_retrans;
 		val.spt_pathpfthld = sp->pf_retrans;
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
-- 
2.1.0

