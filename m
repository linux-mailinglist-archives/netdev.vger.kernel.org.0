Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F822362BF6
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDPXnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhDPXnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:43:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27E7C061756;
        Fri, 16 Apr 2021 16:43:15 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f29so20205386pgm.8;
        Fri, 16 Apr 2021 16:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R63R/upCSv4omHhh/l8CMUKQo5RwOLVyxJH6CYRJFL4=;
        b=qE1B+rVpuF0TMUP/+7PU15pJBMujqHXduuZPDG3HCG50UmnaYjHTue5Ddu8UjYrD+A
         8oWuogkDLUwTR5BVfJ/us6NWVkHeNxG2HulbdfmZanEwAHcRRhg3AWaxr5QrpmEGslgl
         tWA2+Gd2uOgX0ZLt6gduXbXcInoNBWEKVz57eJ6BBA8bPQgWrvIOwB/L2Ku5lCaA+3v1
         Z/T0AhlciTyHDRxHBkrGrnVYU6RVkoziOlPz43zfamlBF/YJKdzVQZNJD3bqxb97Bpis
         E4TVKbaHqQkiv+n/rCwGHATrW+ROX/wHRWyeljU5NElt90ho4BaGJ3TSxS371SU2O16Z
         bCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R63R/upCSv4omHhh/l8CMUKQo5RwOLVyxJH6CYRJFL4=;
        b=SxmYHxsh5ANr8fOx8cQaXBRZcxGjPO1KWMga/iffAcFwS7JHhbld1gugr25paQvB4N
         /vAMiIaQwGhse6nGRrRNYpdQlfClbFcMo8m0PEw96amOG1dOUgsQ+oS1xtDSiMEXsoBD
         SLmyrcaG6g49mCbbDof/IQVjHPbXpL2ExqKS28gUFRuhg5lR+qbHDF9GuSmVdz0WApWg
         Jdmop5QAs6QjYbUQ7ct8shTe1CeeKnPeVWPcsLi0oOiiT34SHUhXbOI8rAoxCWtl51v4
         Lq7Fk94IRpzzQLZJmcOJk6NBpx2IGq9uUeeH71T3EGFo5FQUfqp029F3TKrm3eUunyoi
         RrRg==
X-Gm-Message-State: AOAM530Zg2RIqAob8p3fsKzh5WPVG/IPdD7Tu7BkmI2eeHB5CvnmHImi
        gNg0IZdlLa9oklojFlPHHsw=
X-Google-Smtp-Source: ABdhPJydLvD1XLAzIb46xm4dpsRz7a8aCUdOAGZNnH2rJsYVJ93VVgAzD9GbaCsL9w9PyYVRDj6mdg==
X-Received: by 2002:aa7:82cc:0:b029:213:db69:18d9 with SMTP id f12-20020aa782cc0000b0290213db6918d9mr10129639pfn.36.1618616595516;
        Fri, 16 Apr 2021 16:43:15 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/5] net: enetc: create a common enetc_pf_to_port helper
Date:   Sat, 17 Apr 2021 02:42:21 +0300
Message-Id: <20210416234225.3715819-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Even though ENETC interfaces are exposed as individual PCIe PFs with
their own driver instances, the ENETC is still fundamentally a
multi-port Ethernet controller, and some parts of the IP take a port
number (as can be seen in the PSFP implementation).

Create a common helper that can be used outside of the TSN code for
retrieving the ENETC port number based on the PF number. This is only
correct for LS1028A, the only Linux-capable instantiation of ENETC thus
far.

Note that ENETC port 3 is PF 6. The TSN code did not care about this
because ENETC port 3 does not support TSN, so the wrong mapping done by
enetc_get_port for PF 6 could have never been hit.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h     | 16 ++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 16 ++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 3de71669e317..08b283347d9c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -237,6 +237,22 @@ static inline bool enetc_si_is_pf(struct enetc_si *si)
 	return !!(si->hw.port);
 }
 
+static inline int enetc_pf_to_port(struct pci_dev *pf_pdev)
+{
+	switch (pf_pdev->devfn) {
+	case 0:
+		return 0;
+	case 1:
+		return 1;
+	case 2:
+		return 2;
+	case 6:
+		return 3;
+	default:
+		return -1;
+	}
+}
+
 #define ENETC_MAX_NUM_TXQS	8
 #define ENETC_INT_NAME_MAX	(IFNAMSIZ + 8)
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index cb7fa4bceaf2..af699f2ad095 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -455,11 +455,6 @@ static struct enetc_psfp epsfp = {
 
 static LIST_HEAD(enetc_block_cb_list);
 
-static inline int enetc_get_port(struct enetc_ndev_priv *priv)
-{
-	return priv->si->pdev->devfn & 0x7;
-}
-
 /* Stream Identity Entry Set Descriptor */
 static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 				 struct enetc_streamid *sid,
@@ -504,7 +499,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	si_conf = &cbd.sid_set;
 	/* Only one port supported for one entry, set itself */
-	si_conf->iports = cpu_to_le32(1 << enetc_get_port(priv));
+	si_conf->iports = cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
 	si_conf->id_type = 1;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -529,7 +524,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	si_conf->en = 0x80;
 	si_conf->stream_handle = cpu_to_le32(sid->handle);
-	si_conf->iports = cpu_to_le32(1 << enetc_get_port(priv));
+	si_conf->iports = cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
 	si_conf->id_type = sid->filtertype;
 	si_conf->oui[2] = 0x0;
 	si_conf->oui[1] = 0x80;
@@ -591,7 +586,8 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
 	}
 
 	sfi_config->sg_inst_table_index = cpu_to_le16(sfi->gate_id);
-	sfi_config->input_ports = cpu_to_le32(1 << enetc_get_port(priv));
+	sfi_config->input_ports =
+		cpu_to_le32(1 << enetc_pf_to_port(priv->si->pdev));
 
 	/* The priority value which may be matched against the
 	 * frame’s priority value to determine a match for this entry.
@@ -1562,10 +1558,10 @@ int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		set_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
+		set_bit(enetc_pf_to_port(priv->si->pdev), &epsfp.dev_bitmap);
 		break;
 	case FLOW_BLOCK_UNBIND:
-		clear_bit(enetc_get_port(priv), &epsfp.dev_bitmap);
+		clear_bit(enetc_pf_to_port(priv->si->pdev), &epsfp.dev_bitmap);
 		if (!epsfp.dev_bitmap)
 			clean_psfp_all();
 		break;
-- 
2.25.1

