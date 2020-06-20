Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2119F2024E4
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgFTPoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgFTPoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:09 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C960C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:09 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t21so10094699edr.12
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eope7FddXCZR+RWQxWuK75kXDpLZ2IFBmup8u0DZ9+k=;
        b=Cq4HNy2So9Nm0thiGneNu5bZaBJGy7GH4+wFljGyrHLzFp2vkAIhSUHNod8r8AFHYU
         C0gZ+kVoylXeA53cgybVbFTCMTISIKaV3PR5SbTlbpDwNACB6nHW3rOqSHCmVqk0wBtz
         5JOnV0T6wHm6be9VrF3YV6bwk/TzCZfZJmRoAHYuWGzzeM4uIr4WGgFVEFvJ9PoZHxS/
         w8oRiZuuiIZcxWEbOKnFW63TBUzdy+oWXByOVPeX3YuC2EmZWTGmqHw1LvyfJKwp2gkg
         lhWUMmQAHl7SnF99a8RBEqm0Em2dl/I3tT++1cdfjAU9z+1+amaNyXtzeXFYhzeZnss1
         brkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eope7FddXCZR+RWQxWuK75kXDpLZ2IFBmup8u0DZ9+k=;
        b=LGwdwuwd9ucuqDLf/IAD23h0ykO1JFchlr8Fq9aLFJXu56Oh7MqI3ly6th9sTpYlt/
         DlmU5knhcWGiI30c4R0BI+o+ex5tSV8EB6+vI/OK1OcICMEA7XCszH6VFKYTHWBHXe2C
         2+n28aF012msCNYrKx/0v220uelSz34mRBMdroujXnrMHwMqMd/dhZQlEB0J4AKOhtLe
         DFmdPhoq65inTK1Vw1H7xC/3Ys+5W6kF+75X+P3F6zlkyyn3Dx8qPVrjmuF9JwFcDGGI
         fyQzCqaT+5mA8AvqhCxigsKKg3zJZCMsTVvW+nxu17hQ3q8D8nDGk8i2njgJQ9ilBu1I
         /BqQ==
X-Gm-Message-State: AOAM5300HC5ecJfnHtQtIl7kI+U73pUVAJbtIwpQzQoZ9lsYmNMsXTt6
        fjye5UwcyJNADmzx+7LKxVI=
X-Google-Smtp-Source: ABdhPJwQQ9Q6FWcqIwIiFRCsNrppjH0tTYgSKNXDFGLa1vKsLA7npJdXXelEtM6J+clJK+FCfC0pPw==
X-Received: by 2002:aa7:da03:: with SMTP id r3mr8649675eds.158.1592667848261;
        Sat, 20 Jun 2020 08:44:08 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 12/12] net: mscc: ocelot: unexpose ocelot_vcap_policer_{add,del}
Date:   Sat, 20 Jun 2020 18:43:47 +0300
Message-Id: <20200620154347.3587114-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Remove the function prototypes from ocelot_police.h and make these
functions static. We need to move them above their callers. Note that
moving the implementations to ocelot_police.c is not trivially possible
due to dependency on is2_entry_set() which is static to ocelot_vcap.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_police.h |  5 --
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 96 +++++++++++------------
 2 files changed, 45 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index be6f2286a5cd..7adb05f71999 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -33,9 +33,4 @@ struct qos_policer_conf {
 int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 			 struct qos_policer_conf *conf);
 
-int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
-			    struct ocelot_policer *pol);
-
-int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
-
 #endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 8597034fd3b7..3ef620faf995 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -651,6 +651,49 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_vcap_filter *filt
 	filter->stats.pkts = cnt;
 }
 
+static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+				   struct ocelot_policer *pol)
+{
+	struct qos_policer_conf pp = { 0 };
+
+	if (!pol)
+		return -EINVAL;
+
+	pp.mode = MSCC_QOS_RATE_MODE_DATA;
+	pp.pir = pol->rate;
+	pp.pbs = pol->burst;
+
+	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+}
+
+static void ocelot_vcap_policer_del(struct ocelot *ocelot,
+				    struct ocelot_vcap_block *block,
+				    u32 pol_ix)
+{
+	struct ocelot_vcap_filter *filter;
+	struct qos_policer_conf pp = {0};
+	int index = -1;
+
+	if (pol_ix < block->pol_lpr)
+		return;
+
+	list_for_each_entry(filter, &block->rules, list) {
+		index++;
+		if (filter->action == OCELOT_VCAP_ACTION_POLICE &&
+		    filter->pol_ix < pol_ix) {
+			filter->pol_ix += 1;
+			ocelot_vcap_policer_add(ocelot, filter->pol_ix,
+						&filter->pol);
+			is2_entry_set(ocelot, index, filter);
+		}
+	}
+
+	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
+	qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+
+	block->pol_lpr++;
+}
+
 static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 					    struct ocelot_vcap_block *block,
 					    struct ocelot_vcap_filter *filter)
@@ -848,55 +891,6 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	return 0;
 }
 
-int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
-			    struct ocelot_policer *pol)
-{
-	struct qos_policer_conf pp = { 0 };
-
-	if (!pol)
-		return -EINVAL;
-
-	pp.mode = MSCC_QOS_RATE_MODE_DATA;
-	pp.pir = pol->rate;
-	pp.pbs = pol->burst;
-
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
-}
-
-int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix)
-{
-	struct qos_policer_conf pp = { 0 };
-
-	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
-
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
-}
-
-static void ocelot_vcap_police_del(struct ocelot *ocelot,
-				   struct ocelot_vcap_block *block,
-				   u32 ix)
-{
-	struct ocelot_vcap_filter *filter;
-	int index = -1;
-
-	if (ix < block->pol_lpr)
-		return;
-
-	list_for_each_entry(filter, &block->rules, list) {
-		index++;
-		if (filter->action == OCELOT_VCAP_ACTION_POLICE &&
-		    filter->pol_ix < ix) {
-			filter->pol_ix += 1;
-			ocelot_vcap_policer_add(ocelot, filter->pol_ix,
-						&filter->pol);
-			is2_entry_set(ocelot, index, filter);
-		}
-	}
-
-	ocelot_vcap_policer_del(ocelot, block->pol_lpr);
-	block->pol_lpr++;
-}
-
 static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 					    struct ocelot_vcap_block *block,
 					    struct ocelot_vcap_filter *filter)
@@ -908,8 +902,8 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
 		if (tmp->id == filter->id) {
 			if (tmp->action == OCELOT_VCAP_ACTION_POLICE)
-				ocelot_vcap_police_del(ocelot, block,
-						       tmp->pol_ix);
+				ocelot_vcap_policer_del(ocelot, block,
+							tmp->pol_ix);
 
 			list_del(pos);
 			kfree(tmp);
-- 
2.25.1

