Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AED2024DC
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgFTPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgFTPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:43:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CC7C0613EF
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:58 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id cy7so3613471edb.5
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xfjhTUB9k4PvWtpo6fzk7roEd14VJ2jahTii7ss7AcY=;
        b=TmzuyIo6XvZWaA3guP1i9wgGi/1bU2KP7k7KM+iWBgCtrz2MJ/nyFwTkFrhJzjXVvB
         H1gWEJt+oYu6pxKFpOd2qVEt18vWUFhn/UIGPANqdzQCP0pLXa7/nlh/vP80xDeTqc1C
         /pN9TzM2RbjNRoqIz+mWZ93dDGLTl0KUkpU5aWBnxBBP8vxAOaX20VLgRnn/vCX7FRCV
         xKsCOxeq5nEf67nUN1Xj/yzDOk4oQvZIF575bNlTlDsSTrRL1t2HRzAhIakjO3AdK/z9
         LM6hw84pHULIpwx87wUXFl8pTvxmhqG6G2WG1YZPiav7B8Elys1WUfynw+KH/qpSuft2
         wqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xfjhTUB9k4PvWtpo6fzk7roEd14VJ2jahTii7ss7AcY=;
        b=BfPrk038KBXqn4iR0zwSUCRk46FVj9Mou87U/DFt1ECPjSeEoRbK/fASNbz4wgPhXo
         jZmNP/JQ35BpUg1I48t/vnG05UkI4sNcfHAkN8Iq2wWXrznlqhDIua62kLb4qhpO6/10
         RxemwRyUeSvFvdcSf3Ogpd22LRGX//VvwQ5kIMTPsDfLFLIbC9TsVtLhUTMuSPooYUH0
         tBGLlr/8ZjjuMkHBkhmSK4xpTa0lLLPP0+07OnVq4pEA381v3GfCsBX97AmfB2n9uat/
         Z4iD2XVt12qrqEyVaLw6GP4ii6WINPEmsSrSl6t5ceXKtsYdCHCaPqz3Q24KkHj3NeKx
         XG6A==
X-Gm-Message-State: AOAM533CbCAolibIs5UxRt8J1jukTLBGXBhVcmvzQIomBsqmpg5F0sjR
        Ah8KfpxsSUdy6HwAahuXNaLvyXhP
X-Google-Smtp-Source: ABdhPJyHen54g8nrhTFL/Gwz1hQlmXQucYQQMOA4s8f2V5gHFdhakzoxUV5wAZtzaIMS+C13O1x5kQ==
X-Received: by 2002:aa7:d987:: with SMTP id u7mr2911470eds.116.1592667837018;
        Sat, 20 Jun 2020 08:43:57 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 02/12] net: mscc: ocelot: use plain int when interacting with TCAM tables
Date:   Sat, 20 Jun 2020 18:43:37 +0300
Message-Id: <20200620154347.3587114-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

sparse is rightfully complaining about the fact that:

warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
   26 |   __builtin_constant_p((l) > (h)), (l) > (h), 0)))
      |                            ^
note: in expansion of macro ‘GENMASK_INPUT_CHECK’
   39 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
      |   ^~~~~~~~~~~~~~~~~~~
note: in expansion of macro ‘GENMASK’
  127 |   mask = GENMASK(width, 0);
      |          ^~~~~~~

So replace the variables that go into GENMASK with plain, signed integer
types.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index dfd82a3baab2..17b642e4d291 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -119,7 +119,8 @@ static void vcap_cache2entry(struct ocelot *ocelot, struct vcap_data *data)
 static void vcap_action2cache(struct ocelot *ocelot, struct vcap_data *data)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-	u32 action_words, i, width, mask;
+	u32 action_words, mask;
+	int i, width;
 
 	/* Encode action type */
 	width = vcap_is2->action_type_width;
@@ -141,7 +142,8 @@ static void vcap_action2cache(struct ocelot *ocelot, struct vcap_data *data)
 static void vcap_cache2action(struct ocelot *ocelot, struct vcap_data *data)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-	u32 action_words, i, width;
+	u32 action_words;
+	int i, width;
 
 	action_words = DIV_ROUND_UP(vcap_is2->action_width, ENTRY_WIDTH);
 
@@ -161,8 +163,8 @@ static void vcap_cache2action(struct ocelot *ocelot, struct vcap_data *data)
 static void is2_data_get(struct ocelot *ocelot, struct vcap_data *data, int ix)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
-	u32 i, col, offset, count, cnt, base;
-	u32 width = vcap_is2->tg_width;
+	int i, col, offset, count, cnt, base;
+	int width = vcap_is2->tg_width;
 
 	count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
 	col = (ix % 2);
-- 
2.25.1

