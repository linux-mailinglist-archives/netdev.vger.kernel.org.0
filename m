Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CACB2ACBBA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgKJDbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgKJDbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95223C0613CF;
        Mon,  9 Nov 2020 19:31:32 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f27so5564051pgl.1;
        Mon, 09 Nov 2020 19:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bCVuVEgoDcCcvqw+GX5Dvfo/jzFsWFu+LIWrAArgS+k=;
        b=F7GWDSQCMxvFwLDmebe4wyu4R3lM/O5FGZULfAykKKe29iYrbKeT0gr/cfu7wiI8zG
         Ltxd0IxUTTVXDFMyMkW1SSsBWf625z+cijbh67bW/WTaomizKMZjWiV7pQ7Ag0hhh4j5
         3fr2ljf5zeVda5Npp5jutslluKG8xnRMTV5mxqGuGDLWkWgr6QG049MxhYL2wX+GK7MG
         /jTxICAIh5//rufdigejRYtUiDx/lxLSWOe75WCqi2j3CKdUDqNvVk7qU+hoI7VBkH8N
         2QpDW7DFqShjQSqkFrYgUF7iMK+vdTaCsr4n+RJxZq4Ns4hZSEsKCfH5fbiBOFTJuK+v
         yV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCVuVEgoDcCcvqw+GX5Dvfo/jzFsWFu+LIWrAArgS+k=;
        b=Y9i3JY3AupyCRO97WdhjpF4IPYQUCZVZgjiHoJGCW03kolsUfcDf/Jdo+u6z5eqzdm
         jpwgkRXG62HUF95xMbb/s9e1R636RBOG2q6d4xwYFXsMwEiR0+XSqqUVvsDvFV3isxP4
         7Zgxv7fmO/uU0J3N67kLGig4TTAtAn5oa04ykWlNkB4Jk/+6vLKitlOsd5BqIr0dUzTu
         ya+jh1kec0jLxSlpyGVU0INFri/QBdz5pXFQXC9UEgcKGCR2csv42cae/D1J2TUXPUN1
         yuWpD10qugYV2cL6rc5YVdO+poytvN4fFb8klBhtmAIBCnLLJ/h0WPdgdiWGFl0lCx5W
         fxBA==
X-Gm-Message-State: AOAM531VBAuQASxj2/s/+Kz29Q+gcLiWJy7WXjlRQzT4gh/ThPkMYULy
        6JGZ6UK/gQSf0roTeZ96/CVxoRmVOTA=
X-Google-Smtp-Source: ABdhPJwI28iFjIM7LbzN7ZN53mRYQ0UzjmjttFfnObProWJ4W5222HZrEZAI81RSL3/UtXNLtLHfng==
X-Received: by 2002:a17:90a:bc94:: with SMTP id x20mr2762402pjr.92.1604979091811;
        Mon, 09 Nov 2020 19:31:31 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:31 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 05/10] ARM: dts: BCM5301X: Provide defaults ports container node
Date:   Mon,  9 Nov 2020 19:31:08 -0800
Message-Id: <20201110033113.31090-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an empty 'ports' container node with the correct #address-cells
and #size-cells properties. This silences the following warning:

arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
        'ports' is a required property
        'ethernet-ports' is a required property
        From schema:
Documentation/devicetree/bindings/net/dsa/b53.yaml

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 807580dd89f5..89993a8a6765 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -489,6 +489,10 @@ srab: ethernet-switch@18007000 {
 		status = "disabled";
 
 		/* ports are defined in board DTS */
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
 	};
 
 	rng: rng@18004000 {
-- 
2.25.1

