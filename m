Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163903FD6B6
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243552AbhIAJXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243536AbhIAJXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:23:46 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E570FC061575;
        Wed,  1 Sep 2021 02:22:49 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id s10so4983277lfr.11;
        Wed, 01 Sep 2021 02:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QCLzqE4WaxkGI/C/C+CMLvLGK3ujcpZunMWfcty+x0=;
        b=PQsobL4kUvemesFGEkRG9zDyUVLxh03DU5TJCC6dLKhGRAfUxVSP1nPUW73GI0N68I
         Yir/LY7pHJqwNp6xLSGUN3q+XgbVvKqRqk4/Vn/5OMCgUVLdUqcxRG0wG/qu6vgh+CxV
         3LGGzTq/piHoMgF7XxDnAmN6rZDfuGSburV/Wnqun62zjRubC7MOlMwO1+t1FJKNBqRm
         EWzpwoKsczCC7xHl5TL3iyYHtV31ETjTix6tYKhKt5so36rqgUAcPEBu4a4I75bLn3wa
         Xtoo0zeqG4b+Ec8ENvcqP3cLWLMGTIk1cnxL6w3OsWD5KgfVWd0g/XGa3jcuhYa/y7ft
         7/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QCLzqE4WaxkGI/C/C+CMLvLGK3ujcpZunMWfcty+x0=;
        b=mQjwwmgNCt5AF2PNy+cafVpqaBjwNX2Vo32P+uHk75EoGeQSUfhglHcaB7nt15a3Fm
         MLt7ZXmB9f14mpBqZT6r/ndqG79ReTrZ0tdzBQP3lkgpSYxaISbYzIVy1sIFKwlYuKp/
         0L+SSRHQZgcEad6OQPQybv9lKSMxaXzVovp0oNuROf2dLqVK042gzKp5ZE101CDi2cL2
         xG8Nu7g7yfzLLBwJnGGJp/CR8OsqdX3mztWqH/rz6DwgT7dIrMQRq4/NziiwGVyQv/gs
         dENXtoV1TMl5sqpdDmPcQbM54Qm0mgBcNx11e/Ndq/S/kbmRp4EGXZUOpprJA/XVnuUT
         3zXg==
X-Gm-Message-State: AOAM532H8U9V9o0HThT0qgfjrzC0QmLxuqsWmTL0/Ddw55DVRMDmz13j
        K8lJksP1VZi/lSI5ElcrdT0=
X-Google-Smtp-Source: ABdhPJzpkc0xnOetBW5TM2eK94UW2SwTadSsKE4mKZqUj1qdvkZj4t/gC2yeVJkJSyblRU84XEba7Q==
X-Received: by 2002:a19:48d0:: with SMTP id v199mr24216365lfa.620.1630488168265;
        Wed, 01 Sep 2021 02:22:48 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d24sm2492372ljj.8.2021.09.01.02.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:22:47 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: b53: Set correct number of ports in the DSA struct
Date:   Wed,  1 Sep 2021 11:21:41 +0200
Message-Id: <20210901092141.6451-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210901092141.6451-1-zajec5@gmail.com>
References: <20210901092141.6451-1-zajec5@gmail.com>
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
times so it's hard to specify a single commit this change fixes.

Cc: stable@vger.kernel.org
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
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

