Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE413C270
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391123AbfFKElB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41075 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391095AbfFKEk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so6832905qkk.8
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j35GrI+XV3Ydg2l0UfCFmtIZW7GzpG/n52xhSTLHljY=;
        b=tOsqKi4MIUrDSOPPlWe8kGYllzhOhCdhV6BF1FZ3mLC+wXq/vJVb0kR9grrrnr0AhK
         o3racvA2paxiyrl519u+cgvfQTKzxaowaDgyL0a9DIgVdqD6ozDAHL/aqYnCuHDOjn/s
         m6Kva/0HRPo+y3JKFBpKK37qQ+J7zklmaDqhTULDKiYMzdo4pyXKxynxZ7lnzFWEZTnw
         wKRn32y7xm2fDHHNIomiMdgmpwautWAyC/UIiC07dPSvA3dAMs4FP4xifMHqs9bGwaNq
         qgmCl2O4TQY3ghffBz+1rVo19QKaNvereLBipwISme3MaWo9NIofU1DEDssV7zwY09te
         4KoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j35GrI+XV3Ydg2l0UfCFmtIZW7GzpG/n52xhSTLHljY=;
        b=T/efZRrYWMnNbEndJc+NMxTx1UEWVdRQCe2pAFZ9q3V9jdYcX+WVMcA5V9nHBDJhb4
         iDIuBNbNxCAs0BYDPFNYxV2WQ1/eyhVZ+mtcfuQOoLGVmWFZBL8cSdG8tTFB6JqauTqQ
         GoVQjNGowPtIa0j355wFebzoEuRIb1seyZ67V0lphazdG9weqQmQpOG/UjgPhj15iygA
         rYJmPFa8m280hTrTFbSahp+W7FjFXXiEWnetxQogtxL0CkefhGXmvQOnjKyzJkE3Ia/4
         EGsWtNJLAPzE5gD0CIoMk3+3OMe8m+qdanhSLE6CCgTvubdq652hVM/xysXG6G6zqOev
         SnCg==
X-Gm-Message-State: APjAAAUb+7lwtUYzKmJuolNm3qQpcokUa599mAVCNkUgQ40Ra9mFejhJ
        ZnYLjP8yPak0VjBF2ZdegixADA==
X-Google-Smtp-Source: APXvYqy+jW63+tcamMzfEpRaOiucUeLPQASpoxm4L4Pwzx8pLKL3whav0snB/jZ3HMqwKCyz84YhYA==
X-Received: by 2002:a37:5d07:: with SMTP id r7mr39613498qkb.4.1560228058554;
        Mon, 10 Jun 2019 21:40:58 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:58 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 06/12] nfp: rename nfp_ccm_mbox_alloc()
Date:   Mon, 10 Jun 2019 21:40:04 -0700
Message-Id: <20190611044010.29161-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need the name nfp_ccm_mbox_alloc() for allocating the mailbox
communication channel itself.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm.h        | 4 ++--
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c   | 4 ++--
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index 01efa779ab31..c905898ab26e 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -112,8 +112,8 @@ nfp_ccm_communicate(struct nfp_ccm *ccm, struct sk_buff *skb,
 
 bool nfp_ccm_mbox_fits(struct nfp_net *nn, unsigned int size);
 struct sk_buff *
-nfp_ccm_mbox_alloc(struct nfp_net *nn, unsigned int req_size,
-		   unsigned int reply_size, gfp_t flags);
+nfp_ccm_mbox_msg_alloc(struct nfp_net *nn, unsigned int req_size,
+		       unsigned int reply_size, gfp_t flags);
 int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 			     enum nfp_ccm_type type,
 			     unsigned int reply_size,
diff --git a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
index e5acd96c3335..53995d53aa3f 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
+++ b/drivers/net/ethernet/netronome/nfp/ccm_mbox.c
@@ -564,8 +564,8 @@ int nfp_ccm_mbox_communicate(struct nfp_net *nn, struct sk_buff *skb,
 }
 
 struct sk_buff *
-nfp_ccm_mbox_alloc(struct nfp_net *nn, unsigned int req_size,
-		   unsigned int reply_size, gfp_t flags)
+nfp_ccm_mbox_msg_alloc(struct nfp_net *nn, unsigned int req_size,
+		       unsigned int reply_size, gfp_t flags)
 {
 	unsigned int max_size;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index c638223e9f60..b7d7317d71d1 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -94,9 +94,9 @@ nfp_net_tls_conn_remove(struct nfp_net *nn, enum tls_offload_ctx_dir direction)
 static struct sk_buff *
 nfp_net_tls_alloc_simple(struct nfp_net *nn, size_t req_sz, gfp_t flags)
 {
-	return nfp_ccm_mbox_alloc(nn, req_sz,
-				  sizeof(struct nfp_crypto_reply_simple),
-				  flags);
+	return nfp_ccm_mbox_msg_alloc(nn, req_sz,
+				      sizeof(struct nfp_crypto_reply_simple),
+				      flags);
 }
 
 static int
@@ -283,7 +283,7 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	if (err)
 		return err;
 
-	skb = nfp_ccm_mbox_alloc(nn, req_sz, sizeof(*reply), GFP_KERNEL);
+	skb = nfp_ccm_mbox_msg_alloc(nn, req_sz, sizeof(*reply), GFP_KERNEL);
 	if (!skb) {
 		err = -ENOMEM;
 		goto err_conn_remove;
-- 
2.21.0

