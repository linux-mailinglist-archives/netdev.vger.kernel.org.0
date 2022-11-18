Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E334F6302B0
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiKRXNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiKRXNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:06 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EB6C688D
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:45 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k7so5807118pll.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xwLplXiEpPrUmSEHFT+BgoTZCCql8nBlITMimy16qjg=;
        b=Sbc24CgHVGc6lRJB7yrdnREDXtXo7UfPzp+nABfQe/zRDwP34t/Zdclq/T6GYamPR8
         /1gLDKXXKTGHsWl0rSNthx7YcJ0MFOgNYPqP4PtWM4IcVLz0w7a9dpEa9sFlQuoCzkvF
         YZdh+htMdMqbmRXhFqAP8YdPyeawLUk9BcI4wErZoAmJ2g3IKQ121ZZtPkV9GoBGs+Uu
         xAaQNsRlu7vHIgGqvvsX/fHBZvQ3Ap1yVxcBqgvannGa+otQIih3aobuOAC9fU8r/mGO
         QZEpP+mi70jjeESlECVrQD0gbcTRiviOtlxVuGRD072VW3BfPJesSsuu87OXBfO12O+i
         dS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwLplXiEpPrUmSEHFT+BgoTZCCql8nBlITMimy16qjg=;
        b=eAGMqZspTDcGRwQ4BclnLuzN769ECvgEsDisaNDOmoqPzmE33jC5vu+WwitbdryIIX
         5EltKRee+GVjI/vSwcW4S99rLqs7JfLHrlXibK/ip0YwnDiNTX6N8UO3+2O/Nj27NLeV
         a/+QoenfZGQZvITpMnmdqrza5pDYaGvSgppZKAqb796KRNCcftj1gwx+Imxj55TR8gq7
         rKWLBtn2croz9oVdcLEhBCCill3lPwd9lDexqMj9FyExgys3o5uqitoTIQ4DShu9I16F
         Ar2yk0oFZM10mwBpsH+gZwiwsi2pUxo0NqPU+MxH9SLzUhOaW+GR0o0kYVQ0lz58aDBR
         HKAA==
X-Gm-Message-State: ANoB5pkoWBXABFKuOHYtKuqf4dhWfsgozqoiVXC5Fh1iADn8ORmgrDwT
        B9/njlqpySLYnzhyVDGbiH4Dr63seHlLRA==
X-Google-Smtp-Source: AA0mqf62zHtW5rKhfGyuZQMkijjjMSIeM7PC5DATE1oAvOjipJcvDX+xT9hc0v4Yi5AWhMtBjWPQkw==
X-Received: by 2002:a17:90b:1102:b0:212:d76f:b9e6 with SMTP id gi2-20020a17090b110200b00212d76fb9e6mr15395765pjb.224.1668812241774;
        Fri, 18 Nov 2022 14:57:21 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 07/19] pds_core: set up the VIF definitions and defaults
Date:   Fri, 18 Nov 2022 14:56:44 -0800
Message-Id: <20221118225656.48309-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Virtual Interfaces (VIFs) supported by the DSC's
configuration (VFio Live Migration, vDPA, etc) are reported
in the dev_ident struct.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/pds_core/core.c | 54 +++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h | 14 +++++
 .../net/ethernet/pensando/pds_core/debugfs.c  | 23 ++++++++
 include/linux/pds/pds_common.h                | 19 +++++++
 4 files changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index e2017cee8284..203a27a0fc5c 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -358,6 +358,47 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	return err;
 }
 
+static struct pdsc_viftype pdsc_viftype_defaults[] = {
+	[PDS_DEV_TYPE_VDPA] = { .name = PDS_DEV_TYPE_VDPA_STR,
+				.vif_id = PDS_DEV_TYPE_VDPA,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET },
+	[PDS_DEV_TYPE_LM]   = { .name = PDS_DEV_TYPE_LM_STR,
+				.vif_id = PDS_DEV_TYPE_LM,
+				.dl_id = PDSC_DEVLINK_PARAM_ID_LM },
+	[PDS_DEV_TYPE_MAX] = { 0 }
+};
+
+static int pdsc_viftypes_init(struct pdsc *pdsc)
+{
+	enum pds_core_vif_types vt;
+
+	pdsc->viftype_status = devm_kzalloc(pdsc->dev,
+					    sizeof(pdsc_viftype_defaults),
+					    GFP_KERNEL);
+	if (!pdsc->viftype_status)
+		return -ENOMEM;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		bool vt_support;
+
+		if (!pdsc_viftype_defaults[vt].name)
+			continue;
+
+		/* Grab the defaults */
+		pdsc->viftype_status[vt] = pdsc_viftype_defaults[vt];
+
+		/* See what the Core device has for support */
+		vt_support = !!le16_to_cpu(pdsc->dev_ident.vif_types[vt]);
+		dev_dbg(pdsc->dev, "VIF %s is %ssupported\n",
+			pdsc->viftype_status[vt].name,
+			vt_support ? "" : "not ");
+
+		pdsc->viftype_status[vt].supported = vt_support;
+	}
+
+	return 0;
+}
+
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int numdescs;
@@ -400,6 +441,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (err)
 		goto err_out_teardown;
 
+	/* Set up the VIFs */
+	err = pdsc_viftypes_init(pdsc);
+	if (err)
+		goto err_out_teardown;
+
+	if (init)
+		pdsc_debugfs_add_viftype(pdsc);
+
 	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
 	return 0;
 
@@ -416,6 +465,11 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	if (pdsc->viftype_status) {
+		devm_kfree(pdsc->dev, pdsc->viftype_status);
+		pdsc->viftype_status = NULL;
+	}
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 687e1debd079..46d10afb0bde 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -123,8 +123,18 @@ struct pdsc_qcq {
 	struct dentry *dentry;
 };
 
+struct pdsc_viftype {
+	char *name;
+	bool supported;
+	bool enabled;
+	int dl_id;
+	int vif_id;
+	struct pds_auxiliary_dev *padev;
+};
+
 enum pdsc_devlink_param_id {
 	PDSC_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	PDSC_DEVLINK_PARAM_ID_LM,
 	PDSC_DEVLINK_PARAM_ID_FW_BOOT,
 };
 
@@ -178,6 +188,7 @@ struct pdsc {
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
+	struct pdsc_viftype *viftype_status;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -232,6 +243,7 @@ struct pdsc *pdsc_dl_alloc(struct device *dev);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
 void pdsc_dl_unregister(struct pdsc *pdsc);
+int pdsc_dl_vif_add(struct pdsc *pdsc, enum pds_core_vif_types vt, const char *name);
 
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
@@ -239,6 +251,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
@@ -248,6 +261,7 @@ static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq) { }
 static inline void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq) { }
diff --git a/drivers/net/ethernet/pensando/pds_core/debugfs.c b/drivers/net/ethernet/pensando/pds_core/debugfs.c
index 294bb97ca639..5b8d53912691 100644
--- a/drivers/net/ethernet/pensando/pds_core/debugfs.c
+++ b/drivers/net/ethernet/pensando/pds_core/debugfs.c
@@ -82,6 +82,29 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 	debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
 }
 
+static int viftype_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (!pdsc->viftype_status[vt].name)
+			continue;
+
+		seq_printf(seq, "%s\t%d supported %d enabled\n",
+			   pdsc->viftype_status[vt].name,
+			   pdsc->viftype_status[vt].supported,
+			   pdsc->viftype_status[vt].enabled);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(viftype);
+
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc)
+{
+	debugfs_create_file("viftypes", 0400, pdsc->dentry, pdsc, &viftype_fops);
+}
+
 static int irqs_show(struct seq_file *seq, void *v)
 {
 	struct pdsc *pdsc = seq->private;
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index e7fe84379a2f..2fa4ec440ef5 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -50,6 +50,25 @@ enum pds_core_driver_type {
 	PDS_DRIVER_ESXI    = 6,
 };
 
+enum pds_core_vif_types {
+	PDS_DEV_TYPE_CORE	= 0,
+	PDS_DEV_TYPE_VDPA	= 1,
+	PDS_DEV_TYPE_VFIO	= 2,
+	PDS_DEV_TYPE_ETH	= 3,
+	PDS_DEV_TYPE_RDMA	= 4,
+	PDS_DEV_TYPE_LM		= 5,
+
+	/* new ones added before this line */
+	PDS_DEV_TYPE_MAX	= 16   /* don't change - used in struct size */
+};
+
+#define PDS_DEV_TYPE_CORE_STR	"Core"
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_DEV_TYPE_VFIO_STR	"VFio"
+#define PDS_DEV_TYPE_ETH_STR	"Eth"
+#define PDS_DEV_TYPE_RDMA_STR	"RDMA"
+#define PDS_DEV_TYPE_LM_STR	"LM"
+
 /* PDSC interface uses identity version 1 and PDSC uses 2 */
 #define PDSC_IDENTITY_VERSION_1		1
 #define PDSC_IDENTITY_VERSION_2		2
-- 
2.17.1

