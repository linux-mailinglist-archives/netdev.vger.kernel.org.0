Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B108149302E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349550AbiARVvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiARVvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:51:09 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14026C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:51:09 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b14so975000lff.3
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=AWI6aoNyLAPkZZ8TVn/5bAW0H4n7GYrXBOENpTnZGf4=;
        b=NYcgZZyprPzAiNYbOerdo22wiU7h8FLHHJGNQcfnzGM39WooPamdl/87eqzXffQRLX
         9Auc3bp58WdDSAU+gLN4j5YxYDV7otI52PtoBCw9Fmrwrs1x1/bjdJ/1qoO0BVy18XhZ
         1s+K4PImuod7kdKWa3e1YsjOr7FEndHMgbA7fDNnBl7gFcAs9sAdtau+DQ5woLXuXp2J
         k3204siIVCqkCAzNPOETFYQx164y4J5xH+zuYi2fXUY3GkY8ya8u9DhW1YakHfakLR9r
         fUxPCXxxe/c0Vv4VTeAX9JPX9eQLRJ8ekUQ5DqaagPK96ZAVh6sjhf47Xi89J/EOFEOa
         lc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=AWI6aoNyLAPkZZ8TVn/5bAW0H4n7GYrXBOENpTnZGf4=;
        b=g3QBGcfnh8LslnWzmY0kx3ZQau+e8ynTafwEXsj+inoMwFDBP/ag7AaQpZGz7vsDDU
         s7R1hsMEhPYOss3nWi0ZT7VUbdccAE99XMN2HSQM/493Wfj/YptWEoV1BMAvK74Wlhz9
         Z2Lu0UlmXHGN07iUcmqwZK9wYDJ5mLYZNLdLjSsbUyfuTHuviIrXIpw2nEdPALtwq+OL
         PPbCJDWbiquawIiaJhOE8SfsrRwMPPUCkMZsEO5bPhZup7Ygyf2JCxDU+fGjnOzytPOe
         bCqKSW4fz004cF5vwielTkyk7VuJSaGdl55zQcbBC7ftW1Bji0CZbDiGvRakG4XNK2tQ
         m6mA==
X-Gm-Message-State: AOAM530QHa+4RtWolPGJmMbz5w8PBVprAh5m072Ie+vCiNgERXIwzSbm
        yVbNhDV/W90WrkcK9XxOnCaGCIMAkmjE4A==
X-Google-Smtp-Source: ABdhPJwVq67oRZNS/K8lfHJgQmuVhNSTJcFr0Cn0eEdafISv0qosU7a1+fKAfKIskirihGvpRYaCtw==
X-Received: by 2002:a05:6512:2824:: with SMTP id cf36mr13493536lfb.568.1642542667387;
        Tue, 18 Jan 2022 13:51:07 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w5sm1704808ljm.55.2022.01.18.13.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 13:51:06 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net 0/4] net/fsl: xgmac_mdio: Add workaround for erratum A-009885
Date:   Tue, 18 Jan 2022 22:50:49 +0100
Message-Id: <20220118215054.2629314-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The individual messages mostly speak for themselves.

It is very possible that there are more chips out there that are
impacted by this, but I only have access to the errata document for
the T1024 family, so I've limited the DT changes to the exact FMan
version used in that device. Hopefully someone from NXP can supply a
follow-up if need be.

The final commit is an unrelated fix that was brought to my attention
by sparse.

v1 -> v2:
 - Added Fixed tags to 1/4 and 3/4

Tobias Waldekranz (4):
  net/fsl: xgmac_mdio: Add workaround for erratum A-009885
  dt-bindings: net: Document fsl,erratum-a009885
  powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
  net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

 .../devicetree/bindings/net/fsl-fman.txt      |  9 ++++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi |  2 ++
 drivers/net/ethernet/freescale/xgmac_mdio.c   | 28 ++++++++++++++-----
 3 files changed, 32 insertions(+), 7 deletions(-)

-- 
2.25.1

