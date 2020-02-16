Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D39C160723
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgBPXMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34055 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgBPXMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id j7so5963963plt.1
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cgJB9VikLuEvhb1Eo0YJDo9o7cxyqPc6dmI6dCjYmPk=;
        b=zyPPpTnwputY3YMoA8M5h6xvZOxjFFy3ZIxISmT8qhnmpGJIIZj4+6ayuBvf3GGFht
         9cm9hoGj6zNB981ryKjbekvLwwAwY1jeQzD9LQkJevDC4cmpeUYLRmFqHLN0E2O4zhUb
         Y6Jltg9ngU7Xa+iqfMfzHMqEZNhEp1povjBZN9KpDawhQf7Gfij4ujmaCwbya/oMHuAp
         tO99foVkD4wL9nJLlF3oeRFFJIWJeKVNkxMP420UcjKqv978MEcuxcCE2zD+Vp0ysQvq
         MX7VXOXPl2krQRaciz3bUErhAh9p6Fvn3UO0U2E5NSkvNrXN0Ro6LEEFE31UX8b+ExBK
         huQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cgJB9VikLuEvhb1Eo0YJDo9o7cxyqPc6dmI6dCjYmPk=;
        b=R1e2H+rLw8KBNrrmc5P1+a2NlkYQKLJ6i6HhpjgfzjQtE+tqpSYUCqwWqZypYOScqN
         LIIrgvlC6C4SSdZe97mHM6IrusA8dyKmlmsfPfaq9H4aP/4Oftb+oEoz3MZwtYzdvt1L
         1KaOaMT+Dguj7F62gErk8GHFXeC3UHmAb+n2EwkgNCuEE4cVV/z+XqVYR0tLTCAG/B7x
         U85U68yo4Ae+hMIgOhIEqz++86nYz4Li6t4iWXM8k/afczU0VSL1qqxYNyWmXs/ggEV7
         /bUmOJc6oKQ8Ti9nba2hDO+ESy8wJmkwoY25SfnijfNUx7k7qFVIs85TaiIk5pFthjHr
         Zbhg==
X-Gm-Message-State: APjAAAXzkKgiZpUvPERMLxs/kU2CKoC1Shb5YXT9YIcW2Qx1wS96Y21s
        aqvRtTR6QU/RRHlvp22F1dMM0g==
X-Google-Smtp-Source: APXvYqyMhL+Z0zf86BykqjigBbzjxdOcjd/HdRJG6AGfowyKPa66ixM0O6MVrf6HRFAn18JdMjWUxA==
X-Received: by 2002:a17:90a:2e86:: with SMTP id r6mr16505965pjd.104.1581894734322;
        Sun, 16 Feb 2020 15:12:14 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:13 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/9] ionic: add q ident query for eq
Date:   Sun, 16 Feb 2020 15:11:56 -0800
Message-Id: <20200216231158.5678-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the queue identity query and use it to verify that
EventQueues are supported in the FW.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 34 ++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 62 +++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index a1e45f4b0c88..add0e026ba55 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -347,6 +347,19 @@ int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data)
 }
 
 /* LIF commands */
+void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
+				  u16 lif_type, u8 qtype, u8 qver)
+{
+	union ionic_dev_cmd cmd = {
+		.q_identify.opcode = IONIC_CMD_Q_IDENTIFY,
+		.q_identify.lif_type = lif_type,
+		.q_identify.type = qtype,
+		.q_identify.ver = qver,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver)
 {
 	union ionic_dev_cmd cmd = {
@@ -669,6 +682,7 @@ void ionic_eqs_deinit(struct ionic *ionic)
 static int ionic_eq_init(struct ionic_eq *eq)
 {
 	struct ionic *ionic = eq->ionic;
+	union ionic_q_identity *q_ident;
 	union ionic_dev_cmd cmd = {
 		.q_init = {
 			.opcode = IONIC_CMD_Q_INIT,
@@ -684,6 +698,26 @@ static int ionic_eq_init(struct ionic_eq *eq)
 	};
 	int err;
 
+	q_ident = (union ionic_q_identity *)&ionic->idev.dev_cmd_regs->data;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_queue_identify(&ionic->idev, IONIC_LIF_TYPE_CLASSIC,
+				     IONIC_QTYPE_EQ, 0);
+	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	cmd.q_init.ver = q_ident->version;
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	if (err == -EINVAL) {
+		dev_err(ionic->dev, "eq init failed, not supported\n");
+		return err;
+	} else if (err == -EIO) {
+		dev_err(ionic->dev, "q_ident eq failed, not supported on older FW\n");
+		return err;
+	} else if (err) {
+		dev_warn(ionic->dev, "eq version type request failed %d, defaulting to %d\n",
+			 err, cmd.q_init.ver);
+	}
+
 	ionic_intr_mask(ionic->idev.intr_ctrl, eq->intr.index,
 			IONIC_INTR_MASK_SET);
 	ionic_intr_clean(ionic->idev.intr_ctrl, eq->intr.index);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index a9e7249b5680..6a4f060505fd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -304,6 +304,8 @@ void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
 void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
 
 int ionic_set_vf_config(struct ionic *ionic, int vf, u8 attr, u8 *data);
+void ionic_dev_cmd_queue_identify(struct ionic_dev *idev,
+				  u16 lif_type, u8 qtype, u8 qver);
 void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
 void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 72a4c0448afc..af38ebb543cd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -42,6 +42,7 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_RX_FILTER_DEL			= 32,
 
 	/* Queue commands */
+	IONIC_CMD_Q_IDENTIFY			= 39,
 	IONIC_CMD_Q_INIT			= 40,
 	IONIC_CMD_Q_CONTROL			= 41,
 
@@ -461,6 +462,65 @@ struct ionic_lif_init_cmd {
 	u8     rsvd2[48];
 };
 
+/**
+ * struct ionic_q_identify_cmd - queue identify command
+ * @opcode:     opcode
+ * @lif_type:   lif type (enum lif_type)
+ * @type:       logical queue type (enum logical_qtype)
+ * @ver:        highest queue type version that the driver supports
+ */
+struct ionic_q_identify_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 lif_type;
+	u8     type;
+	u8     ver;
+	u8     rsvd2[58];
+};
+
+/**
+ * struct ionic_q_identify_comp - queue identify command completion
+ * @status:  status of the command (enum status_code)
+ * @ver:     queue type version that can be used with FW
+ */
+struct ionic_q_identify_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	u8     ver;
+	u8     rsvd2[11];
+};
+
+/**
+ * union ionic_q_identity - queue identity information
+ *     @version:        queue type version that can be used with FW
+ *     @supported:      bitfield of queue versions, first bit = ver 0
+ *     @features:       queue features
+ *     @desc_sz:        descriptor size
+ *     @comp_sz:        completion descriptor size
+ *     @sg_desc_sz:     sg descriptor size
+ *     @max_sg_elems:   maximum number of sg elements
+ *     @sg_desc_stride: number of sg elements per descriptor
+ */
+union ionic_q_identity {
+	struct {
+		u8      version;
+		u8      supported;
+		u8      rsvd[6];
+#define IONIC_QIDENT_F_CQ	0x01	/* queue has completion ring */
+#define IONIC_QIDENT_F_SG	0x02	/* queue has scatter/gather ring */
+#define IONIC_QIDENT_F_EQ	0x04	/* queue can use event queue */
+#define IONIC_QIDENT_F_CMB	0x08	/* queue is in cmb bar */
+		__le64  features;
+		__le16  desc_sz;
+		__le16  comp_sz;
+		__le16  sg_desc_sz;
+		__le16  max_sg_elems;
+		__le16  sg_desc_stride;
+	};
+	__le32 words[478];
+};
+
 /**
  * struct ionic_lif_init_comp - LIF init command completion
  * @status: The status of the command (enum status_code)
@@ -2392,6 +2452,7 @@ union ionic_dev_cmd {
 	struct ionic_qos_init_cmd qos_init;
 	struct ionic_qos_reset_cmd qos_reset;
 
+	struct ionic_q_identify_cmd q_identify;
 	struct ionic_q_init_cmd q_init;
 	struct ionic_q_control_cmd q_control;
 };
@@ -2425,6 +2486,7 @@ union ionic_dev_cmd_comp {
 	ionic_qos_init_comp qos_init;
 	ionic_qos_reset_comp qos_reset;
 
+	struct ionic_q_identify_comp q_identify;
 	struct ionic_q_init_comp q_init;
 };
 
-- 
2.17.1

