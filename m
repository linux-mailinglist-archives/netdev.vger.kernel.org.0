Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE37323B9B
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhBXLx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbhBXLxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:53:22 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B3DC06178C;
        Wed, 24 Feb 2021 03:52:12 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u20so1669209iot.9;
        Wed, 24 Feb 2021 03:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vv8e+Q64O0YOnZPfFWuAU+JcY2c3un2uq0nf6BdI8TQ=;
        b=WUHmJpGd4JhuzwHrZklF4hnBIt30FW+aVavOfZzmRidKN66gbK85O+iCO9OGeZCn5J
         YHV0isOxRHoayg74DqGLs/GWDcKgbK6t2J6G5Nt29E91ILFf0HqMSmEUYhmpWAxB+puA
         zbv2uShMy5NN/a4zorI2zEjDf+FThgiEOAw40qrmnFo47KWHNdzeWHHUMCXkH0VOjjQ2
         NHAlPGKLkXcEoS1S+voO5lt2aVqaqQGh1rjgYZv4AgichI4jlJZhZKpa8b4RJpBtF8Kx
         JirQu+CWF+s1lTvXW6+W3tUv5ZZQcGjFP0efAkDVZwCBlT7zkD8M1LdDQa1Li7UuZVQ7
         sekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vv8e+Q64O0YOnZPfFWuAU+JcY2c3un2uq0nf6BdI8TQ=;
        b=d3ZRd+b16KbI3/FCm6kQiKDZVefs+Pgla/dlTLT/cII73ufqQAdfn/JSKO7OE2yyU7
         e0/yxpmtZCu+sgXCN0BgO2ldXEfjnQsoyTG7aHM/AvGaCAz6NIM3eIEk44rA9y+ko+HA
         qVvuM9lOKB3hrDZLOHp5u6w2RY+p78ceUwKx8sOXgqGPt7aRoUMg2A61QcAs0hyrIlZE
         Wu9hh0XEMHX5GEOG+5wJvQEPjRgmyXuVw0jVwjeBIFpeexe9j0qJ0Od3giWEkgjFS0aQ
         MCBa2BOdF248YPwbh42k6/dGCAGPadMShaB/zNihwIeRrPDIiXG8CjJsXl1Vj96ujb9m
         +2/w==
X-Gm-Message-State: AOAM532aat3Yzk7966ZD8wmpNCwMaCELXuKh1/IJoyJ17Td2woXZx3eQ
        sN571YccM5f4/ptLcGvWtCn2jVxKLUa+Fw==
X-Google-Smtp-Source: ABdhPJzqMuYbUTFoFmYyOX4XzjuCRsBxFbouWEUNy31yHTK43kr8jwYdhgn296WX4/ec6XTGuNPzEA==
X-Received: by 2002:a6b:b415:: with SMTP id d21mr1377811iof.149.1614167531229;
        Wed, 24 Feb 2021 03:52:11 -0800 (PST)
Received: from aford-IdeaCentre-A730.lan ([2601:448:8400:9e8:de9c:d296:189b:385a])
        by smtp.gmail.com with ESMTPSA id l16sm1500001ils.11.2021.02.24.03.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:52:10 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aford@beaconembedded.com, Adam Ford <aford173@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
Date:   Wed, 24 Feb 2021 05:51:45 -0600
Message-Id: <20210224115146.9131-5-aford173@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224115146.9131-1-aford173@gmail.com>
References: <20210224115146.9131-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AVB refererence clock assumes an external clock that runs
automatically.  Because the Versaclock is wired to provide the
AVB refclock, the device tree needs to reference it in order for the
driver to start the clock.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
V3:  New to series

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 8d3a4d6ee885..75355c354c38 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -53,6 +53,8 @@ &avb {
 	phy-handle = <&phy0>;
 	rx-internal-delay-ps = <1800>;
 	tx-internal-delay-ps = <2000>;
+	clocks = <&cpg CPG_MOD 812>, <&versaclock5 4>;
+	clock-names = "fck", "refclk";
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-- 
2.25.1

