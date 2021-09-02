Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA963FEAA2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 10:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbhIBIcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243834AbhIBIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 04:32:00 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2C2C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 01:31:02 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t19so2534552lfe.13
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 01:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNqRw10rZHR5ReQJZ4EZPClJnf+Q+1FVfbcd/gZtEok=;
        b=PLOI+u+7FCVGOYCubex6gMpoAGkd8ZGlvyZ8/+yHl3A0kDRx6IVQw53SunPh+Bfqds
         qC8uFq4hRxKHJGuABmqdVeaorq7p4qEf0+46oo+m42N3Lap2hVrvJkbmCIZjblRpkBXJ
         c2dcUm6MkS7LtmTU7Dr7+rBIU42xsC2UAoXP24dL0psmAjg6uX37nVxY4TgQvlNhLpbY
         zl/sem6iHPBT4B5D45GDYov96zCYJDJSHEoe+3DEbxcpFa7jrP5wr3WngAfV1fTAydtg
         S8gH6V3+5yusH80+BcVyb/TflybOCxg4vz9ESh8939i1g5hrC28mbjfhM9NYpWuqPseV
         UJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNqRw10rZHR5ReQJZ4EZPClJnf+Q+1FVfbcd/gZtEok=;
        b=R+0ot8JPlcIFn0HGkNZssTglp8A0eo+AuaaIiTnqoc6Mf1c+tUJxsr9eQbja9zF2oH
         w7Ad3Qyq3qfPNsF7B7SGY9EN9CwBUlbQPhX9jkJBDPWIS2ZNYjtr0lIZnoNpgKZlb3H5
         2LUXM70JpJKzna44xhaC0MHcp62+EkpYVMLfzjoziAH6KwagvFv1RXcJSmodjJvTS+Lz
         XBQtVgu6uz+8KKBTJWqtb5TLClGB7GrRhRLwCooHFF62j0iAehuiRvkitX77d6gN4IVL
         E8orZpQtNLnV7/mCyfnhN8gLoc2em3z/nlYR5tn+wB5uQEtiPwtoe9tAB6M/ue8jPwdy
         SZ1g==
X-Gm-Message-State: AOAM530POp6gmnRe+ND8SYg0jNj9OJvOKhlPwMQVwVnbDBKso++yn+X+
        iyuusE30OtMxFaAsPOeItwk=
X-Google-Smtp-Source: ABdhPJyy0aTxCdokVicJ1N7mtmll8ccC0CTUc1EVe+yoVZRAHit6Jp/dSP4E3MurpeBwIMF9EDjb0Q==
X-Received: by 2002:a05:6512:10c1:: with SMTP id k1mr576777lfg.329.1630571461230;
        Thu, 02 Sep 2021 01:31:01 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id 131sm137042ljj.52.2021.09.02.01.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 01:31:00 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net 2/2] net: dsa: b53: Set correct number of ports in the DSA struct
Date:   Thu,  2 Sep 2021 10:30:51 +0200
Message-Id: <20210902083051.18206-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210902083051.18206-1-zajec5@gmail.com>
References: <20210901092141.6451-1-zajec5@gmail.com>
 <20210902083051.18206-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Setting DSA_MAX_PORTS caused DSA to call b53 callbacks (e.g.
b53_disable_port() during dsa_register_switch()) for invalid
(non-existent) ports. That made b53 modify unrelated registers and is
one of reasons for a broken BCM5301x support.

This problem exists for years but DSA_MAX_PORTS usage has changed few
times. It seems the most accurate to reference commit dropping
dsa_switch_alloc() in the Fixes tag.

Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Update commit & add Fixes tag
---
 drivers/net/dsa/b53/b53_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index dcf9d7e5ae14..5646eb8afe38 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2615,6 +2615,8 @@ static int b53_switch_init(struct b53_device *dev)
 	dev->enabled_ports |= BIT(dev->cpu_port);
 	dev->num_ports = fls(dev->enabled_ports);
 
+	dev->ds->num_ports = min_t(unsigned int, dev->num_ports, DSA_MAX_PORTS);
+
 	/* Include non standard CPU port built-in PHYs to be probed */
 	if (is539x(dev) || is531x5(dev)) {
 		for (i = 0; i < dev->num_ports; i++) {
@@ -2659,7 +2661,6 @@ struct b53_device *b53_switch_alloc(struct device *base,
 		return NULL;
 
 	ds->dev = base;
-	ds->num_ports = DSA_MAX_PORTS;
 
 	dev = devm_kzalloc(base, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
-- 
2.26.2

