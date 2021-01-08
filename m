Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F0B2EEA4F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbhAHAVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbhAHAVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:50 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F64FC061282
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:39 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ga15so12248475ejb.4
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m1Szwz+SMdD4dmadUGtjTPzY7MQn2FcypbNbLf2dyPw=;
        b=jIXhJiyXlPCPGlFCx/QmxzbGFPdqpAuEqUuZKPKvULJMJAmtIPM/QeOJZzBJblYigS
         N5NyGVLccLBKuIEXA7ZEGwT510WZRCj6Bg7UpgdTKbAzzgMNdiQoHmiS7R+RulDxNmSU
         KpAtw/uuKRWWEWTSgAPd6e5x08Btliq7C0sae0HGo8gCb+HvE6rxrMPK85ApUQb3Wc9L
         SapK7MiFC+inIxm8UM0/CgyrgCR3SShMMfhvqbTsWrs6LbxF8VIJ0mKisp7Q1RSrqEhq
         Hv6RbyrH+oikxgTX8I8/0TGzdYZ9nXtC6nj2cFvKCfE8qwl9ZvYZv1VIF59HT8FBfxQo
         2m5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m1Szwz+SMdD4dmadUGtjTPzY7MQn2FcypbNbLf2dyPw=;
        b=K7uPhJoEHWY3wFZqfVw7s85gpgOHHT39lUsj6LQqOELYvtPs0KktCxj1YbEIK5BDwB
         QkmOmqT4ZxInGpqtBP1kjBXdQoXVMwU6Nmzfflad0cSQNw7giXfBNvx5K6tSVYEbwA/6
         +Mz9F6ui4V37PQjwFj0gjFhi2h1sBwZB99vR/ZDV229EZNdjkckzMAgo4OeDANcS7FxT
         jSs0QojmOmXyAcVtJYm4w2zH4b/466Y/mQZjcY1BjIcDF3r67rjK1By8y01U0xKfaY/O
         nWpje+kB+3HcBWk3mRXUQCOCsx2t95yNbf0tqXSZqhO/nuMzuAbK2HrIzxbzvGWccz4G
         mLQQ==
X-Gm-Message-State: AOAM533Hdnr5tMwZrB8Eu3x51qhWwraICXsXsDU99o/VIHOlaODEZJpv
        qRAX19wQohKg662LE789GHY=
X-Google-Smtp-Source: ABdhPJyDFVHaOZLj2bNA1ad2NqyxYvLp4PwGoDaBcg0Rg+vGr5CRmM76e4p+yMoi722mUQzcQ4JZFw==
X-Received: by 2002:a17:906:8693:: with SMTP id g19mr980813ejx.111.1610065238151;
        Thu, 07 Jan 2021 16:20:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 10/18] scsi: fcoe: propagate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 02:19:57 +0200
Message-Id: <20210108002005.3429956-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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

