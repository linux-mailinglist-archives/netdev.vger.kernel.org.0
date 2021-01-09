Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B72F023C
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAIR2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbhAIR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BB1C0617AA
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:36 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id g20so18919391ejb.1
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6ApqBmYJPVuM89MlPQNToDynXEEzwj/6TydzQNxRN9s=;
        b=RIJnYyVZSGpbsoifJUFj8Ov2HInZn/2SlEWV6zVXjUIDAg6fvkv9eaEu9pYGCP6A5K
         xlOaqUwQsZj9i6yG+ONQt+36BY6Ln8BoGrFwI0bDDYXVBxb/V3tiflQhOu8iQH8zEb/F
         plUDKpf/ts8ucs21FBJl20U8ig3+hgLNAUhN1MYnGUflbLlIoLl5KzTyRMj/YkN3QB+C
         lntnSy7fvKhNWo3kq3+7c64SAym8XfAQcM9XUu+3ceNRU8WHUXM8n4LJIV1d7aLlwVwI
         csEEgscHCP7CHVKpggQcYXa++ptHLH3fUXaZomy3JRJ7D5unXdcl3tj0vXVEiINaO3aa
         zZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6ApqBmYJPVuM89MlPQNToDynXEEzwj/6TydzQNxRN9s=;
        b=cCedFEA+/2qPyhhzAsg7mGd02YjUpLYCyMUgxGbWhSY2YmiNOoUvdTDne/3h5I4/ID
         RVbKf2e9RoDuL6O54b/LAr+9uQ+AI9hzFVRDgy6qnL1hkN/NxKFkFt0L4QLqUOMisEej
         QoEZVDe8/5GhZAYteM8nfkMYpnUK18QDWzix/N+hawOs9V9xAvTdpdCPNWkJq2Ex3ImS
         4g2Py4H5sFxqErhg138SGzT+E2syxLKLqHIVmEPLceS7HG55XTXS17wdjR7Vr87Zelx2
         kkL3mtihD/vs0NOZtLMUKtE+G/bx5sz3Eu0HyVfdC8P2VtN9H7/b4Hz/bd2Eg0so7ww0
         mmgA==
X-Gm-Message-State: AOAM533SZnUNDV/aiw/4JNLqgkmc9/ovqDdGa9q54LbIhG8c641sGPrB
        CorPeyS8pJ82arSjgjXG0Qk=
X-Google-Smtp-Source: ABdhPJx/rIHYhKIpkHvsQAer9hoaKBd33G3utt5k/OChKjWaf6KO7sSkUun6FIhBs19QXLhxXX+pXQ==
X-Received: by 2002:a17:906:3499:: with SMTP id g25mr6128050ejb.18.1610213255463;
        Sat, 09 Jan 2021 09:27:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v6 net-next 09/15] scsi: fcoe: propagate errors from dev_get_stats
Date:   Sat,  9 Jan 2021 19:26:18 +0200
Message-Id: <20210109172624.2028156-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The FCoE callback for the Link Error Status Block retrieves the FCS
error count using dev_get_stats. This function can now return errors.
Propagate these all the way to the sysfs device attributes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
Patch is new (Eric's suggestion).

 drivers/scsi/fcoe/fcoe_sysfs.c     |  9 +++++++--
 drivers/scsi/fcoe/fcoe_transport.c | 24 +++++++++++++++---------
 drivers/scsi/libfc/fc_rport.c      |  5 ++++-
 include/scsi/fcoe_sysfs.h          | 12 ++++++------
 include/scsi/libfc.h               |  2 +-
 include/scsi/libfcoe.h             |  8 ++++----
 6 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index af658aa38fed..a197e66ffa8a 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -139,8 +139,13 @@ static ssize_t show_fcoe_ctlr_device_##field(struct device *dev, \
 					    char *buf)			\
 {									\
 	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);		\
-	if (ctlr->f->get_fcoe_ctlr_##field)				\
-		ctlr->f->get_fcoe_ctlr_##field(ctlr);			\
+	int err;							\
+									\
+	if (ctlr->f->get_fcoe_ctlr_##field) {				\
+		err = ctlr->f->get_fcoe_ctlr_##field(ctlr);		\
+		if (err)						\
+			return err;					\
+	}								\
 	return snprintf(buf, sz, format_string,				\
 			cast fcoe_ctlr_##field(ctlr));			\
 }
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 213ee9efb044..5d19650e9bc1 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -166,15 +166,16 @@ EXPORT_SYMBOL_GPL(fcoe_link_speed_update);
  * Note, the Link Error Status Block (LESB) for FCoE is defined in FC-BB-6
  * Clause 7.11 in v1.04.
  */
-void __fcoe_get_lesb(struct fc_lport *lport,
-		     struct fc_els_lesb *fc_lesb,
-		     struct net_device *netdev)
+int __fcoe_get_lesb(struct fc_lport *lport,
+		    struct fc_els_lesb *fc_lesb,
+		    struct net_device *netdev)
 {
 	struct rtnl_link_stats64 dev_stats;
 	unsigned int cpu;
 	u32 lfc, vlfc, mdac;
 	struct fc_stats *stats;
 	struct fcoe_fc_els_lesb *lesb;
+	int err;
 
 	lfc = 0;
 	vlfc = 0;
@@ -190,8 +191,14 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 	lesb->lesb_link_fail = htonl(lfc);
 	lesb->lesb_vlink_fail = htonl(vlfc);
 	lesb->lesb_miss_fka = htonl(mdac);
-	dev_get_stats(netdev, &dev_stats);
+
+	err = dev_get_stats(netdev, &dev_stats);
+	if (err)
+		return err;
+
 	lesb->lesb_fcs_error = htonl(dev_stats.rx_crc_errors);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
 
@@ -200,12 +207,11 @@ EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
  * @lport: the local port
  * @fc_lesb: the link error status block
  */
-void fcoe_get_lesb(struct fc_lport *lport,
-			 struct fc_els_lesb *fc_lesb)
+int fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb)
 {
 	struct net_device *netdev = fcoe_get_netdev(lport);
 
-	__fcoe_get_lesb(lport, fc_lesb, netdev);
+	return __fcoe_get_lesb(lport, fc_lesb, netdev);
 }
 EXPORT_SYMBOL_GPL(fcoe_get_lesb);
 
@@ -215,14 +221,14 @@ EXPORT_SYMBOL_GPL(fcoe_get_lesb);
  * @ctlr_dev: The given fcoe controller device
  *
  */
-void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
+int fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
 {
 	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
 	struct net_device *netdev = fcoe_get_netdev(fip->lp);
 	struct fc_els_lesb *fc_lesb;
 
 	fc_lesb = (struct fc_els_lesb *)(&ctlr_dev->lesb);
-	__fcoe_get_lesb(fip->lp, fc_lesb, netdev);
+	return __fcoe_get_lesb(fip->lp, fc_lesb, netdev);
 }
 EXPORT_SYMBOL_GPL(fcoe_ctlr_get_lesb);
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 56003208d2e7..cb299fef7a78 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1633,6 +1633,7 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 	struct fc_els_lesb *lesb;
 	struct fc_seq_els_data rjt_data;
 	struct fc_host_statistics *hst;
+	int err;
 
 	lockdep_assert_held(&rdata->rp_mutex);
 
@@ -1659,7 +1660,9 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 	lesb = &rsp->rls_lesb;
 	if (lport->tt.get_lesb) {
 		/* get LESB from LLD if it supports it */
-		lport->tt.get_lesb(lport, lesb);
+		err = lport->tt.get_lesb(lport, lesb);
+		if (err)
+			goto out_rjt;
 	} else {
 		fc_get_host_stats(lport->host);
 		hst = &lport->host_stats;
diff --git a/include/scsi/fcoe_sysfs.h b/include/scsi/fcoe_sysfs.h
index 4b1216de3f22..076b593f2625 100644
--- a/include/scsi/fcoe_sysfs.h
+++ b/include/scsi/fcoe_sysfs.h
@@ -16,12 +16,12 @@ struct fcoe_ctlr_device;
 struct fcoe_fcf_device;
 
 struct fcoe_sysfs_function_template {
-	void (*get_fcoe_ctlr_link_fail)(struct fcoe_ctlr_device *);
-	void (*get_fcoe_ctlr_vlink_fail)(struct fcoe_ctlr_device *);
-	void (*get_fcoe_ctlr_miss_fka)(struct fcoe_ctlr_device *);
-	void (*get_fcoe_ctlr_symb_err)(struct fcoe_ctlr_device *);
-	void (*get_fcoe_ctlr_err_block)(struct fcoe_ctlr_device *);
-	void (*get_fcoe_ctlr_fcs_error)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_link_fail)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_vlink_fail)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_miss_fka)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_symb_err)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_err_block)(struct fcoe_ctlr_device *);
+	int  (*get_fcoe_ctlr_fcs_error)(struct fcoe_ctlr_device *);
 	void (*set_fcoe_ctlr_mode)(struct fcoe_ctlr_device *);
 	int  (*set_fcoe_ctlr_enabled)(struct fcoe_ctlr_device *);
 	void (*get_fcoe_fcf_selected)(struct fcoe_fcf_device *);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 9b87e1a1c646..510654796db5 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -501,7 +501,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
+	int (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
 	 * Reset an exchange manager, completing all sequences and exchanges.
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 2568cb0627ec..a42cbe847ce6 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -255,13 +255,13 @@ int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 u32 fcoe_fc_crc(struct fc_frame *fp);
 int fcoe_start_io(struct sk_buff *skb);
 int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type);
-void __fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb,
-		     struct net_device *netdev);
+int __fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb,
+		    struct net_device *netdev);
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len);
 int fcoe_validate_vport_create(struct fc_vport *vport);
 int fcoe_link_speed_update(struct fc_lport *);
-void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
-void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev);
+int fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
+int fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.
-- 
2.25.1

