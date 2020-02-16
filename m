Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F13160720
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgBPXMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37422 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBPXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:12 -0500
Received: by mail-pg1-f194.google.com with SMTP id z12so8065938pgl.4
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pdraga5Sd1kFqllBRnZwSDaXxBbnqiI1HBERiKi/0pQ=;
        b=nPpd/bAlhCP0YunoED+wNG9HYdwogHK+Xuy3KGKqkeOGQmli7j+4/vwZV1FJ9chUMU
         ovxp00minWKZnWeLYjUY+FMIkSKTWaGRJhfv7Zv6+dvtlOt+wCfc46z6wi4eg0Q7rpTt
         PGOSSWPctWk1lhp8C/1XPOp9vrdqOGJFqaeI81XQ4KVRFoBicuK/13tMK4L5dgNawaKT
         W+RLvjqa3hnkBkvzV9ubI1pGy1uFTKyy/xca+C0jKqqJKhrAxIxFRR1mOypg3RBQGG7b
         7b71jVQUzOFUj0PLssL8T45UktrNzP40ge7nakH1RxlA/rg+r+nWzZCmC37Wr0NNTZX9
         6UJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Pdraga5Sd1kFqllBRnZwSDaXxBbnqiI1HBERiKi/0pQ=;
        b=WyHQ00ioIKFGEBVbsVoRB8z6hkkRLNF1DD5DmSwnAHiucUUx+1PtTMZi83ScvPtCUZ
         hTGRqAyu/cjcdEAX88qf0nHHam8fcgJoUvWmXrXXecUTvkgX9spbW3+JfTmc8cGb1wn5
         PeBpY8/hnW1PZ1ZtZ9NtDTZDWMvtxGxILnLRvipSjkTjkcVtCt44M7kWvLp5pvgD6vZg
         nMsdwi5EsU+NwrO11YX9vZ4L7reyGZLZ+7muFYWy7XLZTAHBplcQZ4Xvz1JIaEQD/2oN
         96gogpmL0R+xLr15iViZeEt0tcA3xPBp9Wrr9oID7kY6jr7gxGOYIpbZE5Eb6cepwfrR
         MFvg==
X-Gm-Message-State: APjAAAWcsbzpFqH7vW4E3cuAiBqeYYpqEOrJ6/CqPXsW7thhEAofFMfY
        qS4zpCsNNrR7rQcG0yXddsubeg==
X-Google-Smtp-Source: APXvYqz97o7YWfmc8WHK47IW3e1yJ5/AN5YS0TqehoasM0KBPkS3orh3Nowo1pSf8a/D8CnBBY3NWg==
X-Received: by 2002:a62:3892:: with SMTP id f140mr13706594pfa.190.1581894731800;
        Sun, 16 Feb 2020 15:12:11 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:11 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/9] ionic: add event queue definitions to hw interface
Date:   Sun, 16 Feb 2020 15:11:53 -0800
Message-Id: <20200216231158.5678-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define the hw interface and driver structures for the Event
Queue operations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 22 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    | 24 +++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index e5a2a44d9308..faf2b748bd20 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -47,6 +47,8 @@ struct ionic {
 	struct ionic_identity ident;
 	struct xarray lifs;
 	struct ionic_lif *master_lif;
+	struct ionic_eq **eqs;
+	unsigned int neth_eqs;
 	unsigned int nnqs_per_lif;
 	unsigned int nrdma_eqs_per_lif;
 	unsigned int ntxqs_per_lif;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 7838e342c4fd..d40be30536ae 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -232,6 +232,28 @@ struct ionic_cq {
 	unsigned int desc_size;
 };
 
+struct ionic_eq_ring {
+	struct ionic_eq_comp *base;
+	dma_addr_t base_pa;
+
+	int index;
+	u8 gen_color;	/* generation counter */
+};
+
+struct ionic_eq {
+	struct ionic *ionic;
+	struct ionic_eq_ring ring[2];
+	struct ionic_intr_info intr;
+
+	int index;
+	int depth;
+
+	bool is_init;
+};
+
+#define IONIC_EQ_DEPTH		0x1000
+#define IONIC_MAX_ETH_EQS	64
+
 struct ionic;
 
 static inline void ionic_intr_init(struct ionic_dev *idev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index ce07c2931a72..72a4c0448afc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -277,6 +277,7 @@ union ionic_dev_identity {
 		__le32 ndbpgs_per_lif;
 		__le32 intr_coal_mult;
 		__le32 intr_coal_div;
+		__le32 eq_count;
 	};
 	__le32 words[512];
 };
@@ -2392,6 +2393,7 @@ union ionic_dev_cmd {
 	struct ionic_qos_reset_cmd qos_reset;
 
 	struct ionic_q_init_cmd q_init;
+	struct ionic_q_control_cmd q_control;
 };
 
 union ionic_dev_cmd_comp {
@@ -2565,6 +2567,28 @@ union ionic_notifyq_comp {
 	struct ionic_log_event log;
 };
 
+/**
+ * struct ionic_eq_comp - Event queue completion descriptor
+ *
+ * @code:  Event code, see enum ionic_eq_comp_code.
+ * @lif_index: To which lif the event pertains.
+ * @qid:   To which queue id the event pertains.
+ * @gen_color: Event queue wrap counter, init 1, incr each wrap.
+ */
+struct ionic_eq_comp {
+	__le16 code;
+	__le16 lif_index;
+	__le32 qid;
+	u8 rsvd[7];
+	u8 gen_color;
+};
+
+enum ionic_eq_comp_code {
+	IONIC_EQ_COMP_CODE_NONE = 0,
+	IONIC_EQ_COMP_CODE_RX_COMP = 1,
+	IONIC_EQ_COMP_CODE_TX_COMP = 2,
+};
+
 /* Deprecate */
 struct ionic_identity {
 	union ionic_drv_identity drv;
-- 
2.17.1

