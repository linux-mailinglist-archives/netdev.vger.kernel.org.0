Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2E64FAD5E
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiDJKtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiDJKtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:49:45 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88DE52E7C
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:34 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso10311910wme.5
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 03:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ivs50OGRJHFGwNpFNc+agiJsbX/PoeocJmJxK3yuRk0=;
        b=eZXiSiP1+IdozcuR6JEa+r6IftQJHuY+1ImpnGmTHhP/jts58WnPOcN62DotyHByan
         Bz6WyaRvU72aCTsyuZgIhwseJRw78aylIGtYrdMw344ZvZ7nuVK97NtyUdtIXFWAfO+J
         MuMzrxRg9ToM0PpV7AtSs8uBn0Vb1YEqxfiEuRTxxicr5iCA2n4UqLlNYMcHZTFemVhZ
         SOVRmiCxQyioXslgkRHsro9XR//UyjO2N2a6vukwP7vry3DUooA7jhqK7zSBTQ/AlK7t
         zlTPpZxpc3kKG6Ee7l3wQQUT0xCREkN0luFNOivdi7QBLsH82D1hg+YwhzlG3u++yUVR
         eRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ivs50OGRJHFGwNpFNc+agiJsbX/PoeocJmJxK3yuRk0=;
        b=ONGSSaACMp77dmjGo16P/Jm2CGpQHLh6sDd4CzHvutyJawdBmVnYLJrNhYhIuH00Du
         qiXQ4vnTTwQ5Ghw3wBHjbpHCG6KRylp0seY4LylGM7gEVywcqKgLm5WWUpI5TGcTbLjS
         HzGR3S6Ajw+/Nj7XTLUBJDg/a6/vrsHGHYxYdbpSj5w/c739vf2zzFcXN9fzrqUfqoFD
         faYnk+p4dgtm1MKwqtHCgZGRGIljA3jtiuk2tNVnzlz7E0/zlvR57jFpnu2rv9om735f
         J2ecEGV2E+DE+WlgErOMGRQ4nThHeyHtbgfu4Lh2HJSkntYtqL+ejU2M9scazaW58U5G
         Ocww==
X-Gm-Message-State: AOAM533PzKMEL+ZMTsvITWPalLieRQK5dtjH7Z11J1vIATpX5MI0sTTg
        YfZEUC/tSbX+HWo3Sm44e8OP5WvLbs4q8aJyi4o=
X-Google-Smtp-Source: ABdhPJwHS2oOr4C0n6QmvlsHbRGXujl67211nxeGKqg2wDyinJfOqOFZtunggq2h3DT437qtaPTOjQ==
X-Received: by 2002:a05:600c:35cc:b0:38c:6d25:f4ad with SMTP id r12-20020a05600c35cc00b0038c6d25f4admr24438298wmq.127.1649587652980;
        Sun, 10 Apr 2022 03:47:32 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d64c8000000b0020784359295sm12839196wri.54.2022.04.10.03.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 03:47:32 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
Date:   Sun, 10 Apr 2022 13:46:26 +0300
Message-Id: <20220410104626.11517-4-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220410104626.11517-1-josua@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since SoM revision 1.9 the PHY has been replaced with an ADIN1300,
add an entry for it next to the original.

Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
index f86efd0ccc40..04fd4c02b1c6 100644
--- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
@@ -83,6 +83,12 @@ ethernet-phy@4 {
 			qca,clk-out-frequency = <125000000>;
 			qca,smarteee-tw-us-1g = <24>;
 		};
+
+		/* ADIN1300 (som rev 1.9 or later) */
+		ethernet-phy@1 {
+			reg = <1>;
+			adi,clk-out-frequency = <125000000>;
+		};
 	};
 };
 
-- 
2.34.1

