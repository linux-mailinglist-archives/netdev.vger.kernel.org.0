Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB596324E6
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfFBVMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:12:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37567 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfFBVMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:12:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id h1so9976657wro.4
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/7idbJYbPkvOwXVW3F5WgG4aMeUuxl7rBeCsGS57eDU=;
        b=e6Ayehf8/PKp4dyuHktqCbzZW3gPe6RQt+4KlwS7CR8QOOn/uLIiIPBmJc2Ipcovcm
         MA5xAyO8TRcIHvgso7XN0I8rMbMJrjAyO15x3PHIKGafaYD2nc5C8fUDyOOBZ6so5l+s
         mQg1sFvgtE6/I3/UBKI1hlu7aC4TVVroTYa5V18CVPkPuyya45Du3+mbH1214ocn5TDL
         BAxri6hByLAIpwH98Fx47imd6/luz6+PLSHCCQW4VTN36gcksTLxkFAVNYVjNqM/KW6S
         yZdawHgyel9YG0uQDh7iQR+w4VUZ1YOe1pwq9oUFvx80O3B71PqyAjmsi7dg4Y+VRDjL
         lSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/7idbJYbPkvOwXVW3F5WgG4aMeUuxl7rBeCsGS57eDU=;
        b=cKcPhAWQ2b7oT8HHZ7HvcPqJDoEbbRZmGGiA+2LEavf8C4MazqfwJBepPpblaOUohr
         70t3k6rmbTisYpA7h895ceJ3IeEL5UfnaszpqsLgs+2rXwOc51fxcHPIXzDmvCEvMsyb
         c8aOhm8Qt2wJBbIOlyh13UYcXJEWMyqhdtco16+iPNFZtwhZnpH6nyBENeLa5aUdrQyK
         lpoyLld+O9fLaoP7DY8LdmBjUsnjF0Q7ZiS4sfCar+AZ7BvJxjLgylan/+/u+/HxDhaP
         88xC359pJxJFIJHTPjSp/oJrnBODcHvFhZvZBcdpkWxrpX4DVAHs4gRV8hNpTNKVfLXE
         GCvQ==
X-Gm-Message-State: APjAAAWIW0j0jwmYlBpUazzqI7CQH+vILfEY7I0/6hS0qfp0zQrtW7i5
        MoAHdhsaGU43In8zk9dx2eVC4Ule
X-Google-Smtp-Source: APXvYqw2cLTIMKRA82vFlUkKm59+/5K3SGJnWX7A8MvdxyOTlPiEumPX7QMp/Q6W7HsrUTXC87LBfA==
X-Received: by 2002:adf:e34e:: with SMTP id n14mr9014274wrj.169.1559509960242;
        Sun, 02 Jun 2019 14:12:40 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 03/11] net: dsa: sja1105: Add missing L2 Forwarding Table definitions for P/Q/R/S
Date:   Mon,  3 Jun 2019 00:11:55 +0300
Message-Id: <20190602211203.17773-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This appends to the L2 Forwarding and L2 Forwarding Parameters tables
(originally added for first-generation switches) the bits that are new
in the second generation.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_static_config.c   | 18 ++++++++++---
 .../net/dsa/sja1105/sja1105_static_config.h   | 26 +++++++++++++++++++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 7e90e62da389..6d65a7b09395 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -236,10 +236,20 @@ size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 	const size_t size = SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
 	struct sja1105_l2_lookup_entry *entry = entry_ptr;
 
-	/* These are static L2 lookup entries, so the structure
-	 * should match UM11040 Table 16/17 definitions when
-	 * LOCKEDS is 1.
-	 */
+	if (entry->lockeds) {
+		sja1105_packing(buf, &entry->tsreg,    159, 159, size, op);
+		sja1105_packing(buf, &entry->mirrvlan, 158, 147, size, op);
+		sja1105_packing(buf, &entry->takets,   146, 146, size, op);
+		sja1105_packing(buf, &entry->mirr,     145, 145, size, op);
+		sja1105_packing(buf, &entry->retag,    144, 144, size, op);
+	} else {
+		sja1105_packing(buf, &entry->touched,  159, 159, size, op);
+		sja1105_packing(buf, &entry->age,      158, 144, size, op);
+	}
+	sja1105_packing(buf, &entry->mask_iotag,   143, 143, size, op);
+	sja1105_packing(buf, &entry->mask_vlanid,  142, 131, size, op);
+	sja1105_packing(buf, &entry->mask_macaddr, 130,  83, size, op);
+	sja1105_packing(buf, &entry->iotag,         82,  82, size, op);
 	sja1105_packing(buf, &entry->vlanid,        81,  70, size, op);
 	sja1105_packing(buf, &entry->macaddr,       69,  22, size, op);
 	sja1105_packing(buf, &entry->destports,     21,  17, size, op);
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 069ca8fd059c..d513b1c91b98 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -122,9 +122,35 @@ struct sja1105_l2_lookup_entry {
 	u64 destports;
 	u64 enfport;
 	u64 index;
+	/* P/Q/R/S only */
+	u64 mask_iotag;
+	u64 mask_vlanid;
+	u64 mask_macaddr;
+	u64 iotag;
+	bool lockeds;
+	union {
+		/* LOCKEDS=1: Static FDB entries */
+		struct {
+			u64 tsreg;
+			u64 mirrvlan;
+			u64 takets;
+			u64 mirr;
+			u64 retag;
+		};
+		/* LOCKEDS=0: Dynamically learned FDB entries */
+		struct {
+			u64 touched;
+			u64 age;
+		};
+	};
 };
 
 struct sja1105_l2_lookup_params_entry {
+	u64 start_dynspc;    /* P/Q/R/S only */
+	u64 drpnolearn;      /* P/Q/R/S only */
+	u64 use_static;      /* P/Q/R/S only */
+	u64 owr_dyn;         /* P/Q/R/S only */
+	u64 learn_once;      /* P/Q/R/S only */
 	u64 maxage;          /* Shared */
 	u64 dyn_tbsz;        /* E/T only */
 	u64 poly;            /* E/T only */
-- 
2.17.1

