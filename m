Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16FF409767
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhIMPfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbhIMPf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:28 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D52C12C757
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g1so10172539lfj.12
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xd3umkjYwct/iEHcKdn/6TrUhyPynjPbO3LzmHR3PlQ=;
        b=FGJxvDqcWqiPbYFwhIrJ0dK0VR2FrCiR+FMhJpzBxx3KpTQ92J+P+Btd9IX3iHDpKN
         XNd0A3/tcrxnrP6AZ6y0w33syHd1m9xwQFg/nx2tsJwlGc0pB3YPr2TnFiEVNeWpG6ML
         6Ub+akRJbSUbNlpwl/U8ALkJvRNGLg8LDO1NTe3fI/Wn5LJXxKTsMph97Nptg8euRCXA
         Q2LrJ8vh9xuFkjAw7ss4ICmkkCSIiUWzv/1WcFGkZqv7XBRBovLZC1bmHML27nnTElh4
         mSS6H51EWXevgXJaV4EQM+np1tMbfkav1yCEqIKwwfWfN6u/f9arviRwo4KiNmajtX0P
         55eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xd3umkjYwct/iEHcKdn/6TrUhyPynjPbO3LzmHR3PlQ=;
        b=0uaTSwLRX1cEuENM+BAERymul+qKmUHnwahcDS/zFZf+SqNDdV+t4rx7ZlIIvJ7t4C
         BwDw7w9E2MprRmvVI/JsXxKwafpdMOuXOxtr0S5Fmm85m8zYR/59SQ+VukrCNwufxG0n
         dG+q/sZ7pvAT/hWB8IiuQqdn1DPjvIXLvPRqRaVy8se36XXzFdWYBCB1Xos8Y7UqRAua
         DDTvlv442ZBpixiLA0woU/G3aQbKbmoPRdxIhOHVDqyGF9bF0hDk1eUNR/ZgX/vgcuuG
         16xpZ3KIsVw1dh1m3ud3/ztfuEv8ziPDgAf2CDVo5RvCOTpqIEUz5tOdYwB/ovD23Lk4
         MUHw==
X-Gm-Message-State: AOAM533jsXNP3lkeQ8A4959+BlN+IxEeeTirRmIgIUaxBCwd8EESgZbM
        dYFqt/3kyEP7QrK5F82nrwD1Sg==
X-Google-Smtp-Source: ABdhPJzyloPpM9xqBMsZqFJGEmHWoBIrTXOQKiARfnmwclHxNdE4tnzTVHEZylrQJnsctRpEGCcmzw==
X-Received: by 2002:a19:c145:: with SMTP id r66mr9687199lff.563.1631544339476;
        Mon, 13 Sep 2021 07:45:39 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 5/8] net: dsa: rtl8366: Disable "4K" VLANs
Date:   Mon, 13 Sep 2021 16:42:57 +0200
Message-Id: <20210913144300.1265143-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913144300.1265143-1-linus.walleij@linaro.org>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have to disable this feature to have working VLANs on the
RTL8366RB at least, probably on all of them.

It appears that the very custom VLAN set-up was using this
feature by setting up one VLAN per port for a reason: when
using "4K" VLAN, every frame transmitted by the switch
MUST have a VLAN tag.

This is the reason that every port had its own VLAN,
including the CPU port, and all of them had PVID turned on:
this way every frame going in or out of the switch will
indeed have a VLAN tag.

However the way Linux userspace like to use VLANs such as
by default assigning all ports on a bridge to the same VLAN
this does not work at all because PVID is not set for these,
and all packets get lost.

Therefore we have to do with 16 VLAN for now, the "4K"
4096 VLAN feature is clearly only for switches in
environments where everything is a VLAN.

This was discovered when testing with OpenWrt that join
the LAN ports lan0 ... lan3 into a bridge and then assign
each of them into VLAN 1 with PVID set on each port: without
this patch this will not work and the bridge goes numb.

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v4:
- New patch after discovering that the VLAN configuration in
  OpenWrt was not working.
---
 drivers/net/dsa/rtl8366.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index fae14c448fe4..9652323167c2 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -313,13 +313,15 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		untagged = true;
 
 
-	/* Enable VLAN in the hardware
-	 * FIXME: what's with this 4k business?
-	 * Just rtl8366_enable_vlan() seems inconclusive.
+	/* Enable VLAN in the hardware, do NOT enable VLAN4K, because the
+	 * 4K VLAN will activate a 4096 entries VID table, but has the side
+	 * effect that every processed frame MUST have a VID, meaning non-VLAN
+	 * traffic will now work at all. So we will let the 16 VLAN entries
+	 * suffice.
 	 */
-	ret = rtl8366_enable_vlan4k(smi, true);
+	ret = rtl8366_enable_vlan(smi, true);
 	if (ret) {
-		NL_SET_ERR_MSG_MOD(extack, "Failed to enable VLAN 4K");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to enable VLAN");
 		return ret;
 	}
 
-- 
2.31.1

