Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549482160A0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGFUxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:53:06 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEE6C08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:53:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id y18so23436667lfh.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f4F27NvYH7YHeuYKRHbuc0Pqyyr+0B+jF6d12ClwIkI=;
        b=lOW1Wg/PzgJlEH+GqjhrxmTv3li0t626WCwwPoL6jeD55GR1+mIMCvoF8Thzf2T5sK
         rLJxpMmZ+sS6+PIzU3TwaiH4y+/FQyfsIxPpTXUocUxF0H9/v9NUr670HttAabkNfvfq
         Yj76IHiRc4an4LNkLTkRaTbpTGOuZQine0yUk25XXrtJHWQaPNoK+grfuhhf2MrHTqx4
         cgkgbdoKyM1ZadeGrUWVA4rNcg8A08Uf0fDOhFc8erb0hz3NcckZNUkCX+1vNdFh+bVh
         ksx6Y7+P0VIRAJ3z1lwgk2WH80GLIadVYwbtWQ5MBXwn8MkUpQrrvSNiLVfcYdPwORwH
         aA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f4F27NvYH7YHeuYKRHbuc0Pqyyr+0B+jF6d12ClwIkI=;
        b=kiqE57bGGBnVqpgY65rxQ5FHKhB21zE5GRxz0H2C6g2JxNXT2g3T/4Kn8KNGV4t2cm
         1OyAJRvbMdsw6VuYVmyv3wyvGkiFAnUTJpiEQlvXWV3i4LWBsbG3OQobLoJDhuby7SLm
         bOtpNAtoFL2HzDGJPZP98xzDprTgN9cbzeLsxCT2P5og/n8xuzYVcwlr3SO90VKvl/LL
         KcU+zlVrCjp+INlgHUju6I9BV87bx6iOO48oQt6IsJVWc15xfNDvVMG6j67F6/az/DDe
         MIEzym4cawn/KBKKsANLms2Ys0e+5idK3aNYDaItEIrG1JEMxEdWdS/E4eu8+w1drFNq
         PRlw==
X-Gm-Message-State: AOAM530pgodsI+yNgPgMiX24doJkwwMKYAiPgPWWV5itljHNIdlKmrWA
        5Fu8qAHpBzTXNorf33EPRJWuSQ==
X-Google-Smtp-Source: ABdhPJweudQ4Zps5g3GaP+6vIwfBjVW4ykzkwUD6KuhgpRarif8Chp4AWsRzjMzBMLZwc2sWZxtlxg==
X-Received: by 2002:ac2:5593:: with SMTP id v19mr30767322lfg.43.1594068784389;
        Mon, 06 Jul 2020 13:53:04 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id t10sm624714ljg.60.2020.07.06.13.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:53:03 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 5/5 v4] net: dsa: rtl8366: Use top VLANs for default
Date:   Mon,  6 Jul 2020 22:52:45 +0200
Message-Id: <20200706205245.937091-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706205245.937091-1-linus.walleij@linaro.org>
References: <20200706205245.937091-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8366 DSA switches will not work unless we set
up a default VLAN for each port. We are currently using
e.g. VLAN 1..6 for a 5-port switch as default VLANs.

This is not very helpful for users, move it to allocate
the top VLANs for default instead, for example on
RTL8366RB there are 16 VLANs so instead of using
VLAN 1..6 as default use VLAN 10..15 so VLAN 1
thru VLAN 9 is available for users.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Resend with the rest
ChangeLog v2->v3:
- Collect Andrew's reviewed-by.
ChangeLog v1->v2:
- Rebase on v5.8-rc1.
---
 drivers/net/dsa/rtl8366.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index a000d458d121..06adcf68ff8d 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -260,8 +260,8 @@ static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
 	u16 vid;
 	int ret;
 
-	/* This is the reserved default VLAN for this port */
-	vid = port + 1;
+	/* Use the top VLANs for per-port default VLAN */
+	vid = smi->num_vlan_mc - smi->num_ports + port;
 
 	if (port == smi->cpu_port)
 		/* For the CPU port, make all ports members of this
-- 
2.26.2

