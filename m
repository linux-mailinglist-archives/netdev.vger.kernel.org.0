Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6342033A5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgFVJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgFVJlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:31 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D919C061797
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q5so3552479wru.6
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mOzBIeRVdsbICiHu3pBzNsfTlUAFWbCE1cSbRbG1tJ8=;
        b=JaPBL52s4sikmFvHY2AeWFMdnIt4op0dMdw+2FQiSixTq4d3+bBSRsdwR810I4r17W
         Dc1Sq8XgKmuI3/9qeQSaRigNEUtgpr3V54J04DIfxrMUrogAvx9GOjtxzTIREfdMQfH/
         ZIoRTVgzdEw7FUgW+wJfkmEOOAhCW69U1CPS7FhzT/GuIAsc5CiRXTTEG/mAZov3cV1/
         Kw2v4DduJlhcgiBk0rJIlyn1FmnjOS6Kg1a7IMwNMqUETbLfpnIxgx6hHvx4LD/zZ23w
         MiFdp3RuROPF6Vz8gGOhgj1XQ/lErO7eajC9HU+kNQCI4qgh6cJgSRDclHcQ/M0Q+ZK0
         akZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mOzBIeRVdsbICiHu3pBzNsfTlUAFWbCE1cSbRbG1tJ8=;
        b=XghrrwB5eMmRdVtU8lSIvD4yLbDtzAoS+Y76uU1ntopGzPgBkOsUdhU9JaC+YEVxfE
         gvCWwfCxSWo8xM7CD9XSudgU+0EKV0pxn+zW8ET22tT4V5YBBXq4Z5XiGDhqmKEAbJ5P
         mrsrFObsBs8kjyCpWIRgyGGO14glcnQK+xEhFQIGF6SAmmnJ8DiUdGILn90PUJ5RVg91
         EX8i4Ca4qaZL4OARLTNJIBk0Mhwq9TMfiFhkeyxNOKzvlXjcmDYmocoV63IZL1OpIKdT
         RrkuTQdhS8qbemLm74y1aYf5SytT9sP3FOi4iajbZ5iNgyeWiSU3tNRfJR6VJ2jXh2eL
         L7YQ==
X-Gm-Message-State: AOAM533FELXYpz17x68Chsuu/TIzI/ZqFZt9qh77fiZ4G97Z3qKb0Nve
        O516FRugc73TkPNRDoR6rKUIVQ==
X-Google-Smtp-Source: ABdhPJxEiAeVa66A6smNF2oImo2X8TfJpMFC5Ia7rzUA6Mu5ujbCfk8T+XkaVik5JQL7C6EsJsyEww==
X-Received: by 2002:adf:f608:: with SMTP id t8mr3023154wrp.308.1592818889179;
        Mon, 22 Jun 2020 02:41:29 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:28 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 04/15] net: mdio: add a forward declaration for reset_control to mdio.h
Date:   Mon, 22 Jun 2020 11:37:33 +0200
Message-Id: <20200622093744.13685-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This header refers to struct reset_control but doesn't include any reset
header. The structure definition is probably somehow indirectly pulled in
since no warnings are reported but for the sake of correctness add the
forward declaration for struct reset_control.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 include/linux/mdio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 36d2e0673d03..9ac5e7ff6156 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -17,6 +17,7 @@
 #define MII_REGADDR_C45_MASK	GENMASK(15, 0)
 
 struct gpio_desc;
+struct reset_control;
 struct mii_bus;
 
 /* Multiple levels of nesting are possible. However typically this is
-- 
2.26.1

