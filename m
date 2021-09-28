Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA8541B252
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhI1Oqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241411AbhI1Oqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:46:37 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AF3C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:57 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y28so93049605lfb.0
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyJepoAP9gqp9xgp/GjgHi1fMuvyMC7LLl2uqf6Q+6k=;
        b=GVHGXwAsDT/eVNmLUaxXkb9bjMePwv2tWQbge/wagGCzMLSae4sqS0CySacAC3PTh4
         285PCkzi699QZd4DIy7CG0iwk0WdVHDWs/Vp+i3qr24hGAVYAG62UBICdpXelLCT3Qik
         s0BhL7ULHKUPCGYNV4nCRDnJFSAztBNtP6vyI3ykMM6Fys3ssNSnq+GkVUUv0i26zEKQ
         bkyEchtrURiEcpMI/AdiegbCPy5UVV78n8IA3hTOlWggL5jkjmRNzTs3WsNT4lHPcDq2
         cREOlrl1s/wETHpTW0Qq7D2z2MAcY1Ao3WVA0cSKjwGnyh+QWLHu2sJOakF16U3oepJb
         HhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyJepoAP9gqp9xgp/GjgHi1fMuvyMC7LLl2uqf6Q+6k=;
        b=3X5Vclnx/+ZQtZb7Oy3ZKmH/3kzIfTAwnpcKwrfpysqkWtHnvEY1loXemDZO8FDUN7
         LK+bhgYNdWrT6kKhY+Qklvht+0L8ikfsMM8ePjB6tHK8FaknrpUqLP0WCZY3beyZoeXj
         gAO7HrieCmCnSR5HMurw0fvbYi0su6kwWqOFlzXjvSDFKK6Q5zd29YGVe8+zc61zzNPk
         WZ8zQW9UTDaSAKELvvSdi1+PIJy2K24PlxIVMsZYwOyWkCloz0eHxcPp/BMLfMdnfr5e
         OTcvmhhJjWdrRvLmLTyMfgaNPDhqwmdN9En7+LzpfABy5vjnqnJJioObo31EzQBDE1op
         HA7w==
X-Gm-Message-State: AOAM532Ic6XBb0ze/c5emx3RACvLQX2pJfSfcL9HKxqtuG2sWk+LCyMO
        7aGAqVB50CZ5o1XPU7Siy6Qibg==
X-Google-Smtp-Source: ABdhPJz2ASAtwsAG1gh2UlbgkFrOEhSKwpIUUFKYNhCwpiWrrVZ+EIKe+ZQA2WlxHOECbdIAjus5Dg==
X-Received: by 2002:a05:6512:1303:: with SMTP id x3mr6083260lfu.291.1632840293564;
        Tue, 28 Sep 2021 07:44:53 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:44:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 5/6 v8] net: dsa: rtl8366: Fix a bug in deleting VLANs
Date:   Tue, 28 Sep 2021 16:41:48 +0200
Message-Id: <20210928144149.84612-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were checking that the MC (member config) was != 0
for some reason, all we need to check is that the config
has no ports, i.e. no members. Then it can be recycled.
This must be some misunderstanding.

Fixes: 4ddcaf1ebb5e ("net: dsa: rtl8366: Properly clear member config")
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v7->v8:
- No changes just resending with the rest of the
  patches.
ChangeLog v6->v7:
- Collect Alvin's and Vladimir's review tags.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- Collect Florians review tag
- Add Fixes tag
ChangeLog v1->v4:
- New patch for a bug found while fixing the other issues.
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 0672dd56c698..f815cd16ad48 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -374,7 +374,7 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 			 * anymore then clear the whole member
 			 * config so it can be reused.
 			 */
-			if (!vlanmc.member && vlanmc.untag) {
+			if (!vlanmc.member) {
 				vlanmc.vid = 0;
 				vlanmc.priority = 0;
 				vlanmc.fid = 0;
-- 
2.31.1

