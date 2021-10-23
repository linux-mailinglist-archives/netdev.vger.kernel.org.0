Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF24438177
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 05:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJWD0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 23:26:46 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11861 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhJWD0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 23:26:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634959468; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=Gl2wyK878D0rfEtWuCrFWlxset7oDDz1zjWRi4xGgzI=; b=goU+emIJ+/+F1ouHv41GME7SVJYduv33kOHOlBoPLOlY9K2j1CwlhvUJ9x2jIdpND/2NSpUV
 /hniZFjk0lZxuB4/NgXpX2Yn6x82g+aEUlWIHdvM460WPMZoNHVVx81DagZgKGpZB1EoIS9b
 EkzetAqxALzgrUOQL9nrFcCiAYU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6173806959612e01001c3df6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 03:24:25
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AB932C43619; Sat, 23 Oct 2021 03:24:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACF20C4338F;
        Sat, 23 Oct 2021 03:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org ACF20C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v5 0/14] net: phy: Add qca8081 ethernet phy driver
Date:   Sat, 23 Oct 2021 11:23:58 +0800
Message-Id: <20211023032412.30479-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the qca8081 ethernet phy driver support, which
improve the wol feature, leverage at803x phy driver and add the fast
retrain, master/slave seed and CDT feature.

Changes in v5:
	* rebase the patches on net-next/master.

Changes in v4:
	* handle other interrupts in set_wol.
	* add genphy_c45_fast_retrain.

Changes in v3:
	* correct a typo "excpet".
	* remove the suffix "PHY" from phy name.

Changes in v2:
	* add definitions of fast retrain related registers in mdio.h.
	* break up the patch into small patches.
	* improve the at803x legacy code.

Changes in v1:
	* merge qca8081 phy driver into at803x.
	* add cdt feature.
	* leverage at803x phy driver helpers.

Luo Jie (14):
  net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
  net: phy: at803x: use phy_modify()
  net: phy: at803x: improve the WOL feature
  net: phy: at803x: use GENMASK() for speed status
  net: phy: add qca8081 ethernet phy driver
  net: phy: add qca8081 read_status
  net: phy: add qca8081 get_features
  net: phy: add qca8081 config_aneg
  net: phy: add constants for fast retrain related register
  net: phy: add genphy_c45_fast_retrain
  net: phy: add qca8081 config_init
  net: phy: add qca8081 soft_reset and enable master/slave seed
  net: phy: adjust qca8081 master/slave seed value if link down
  net: phy: add qca8081 cdt feature

 drivers/net/phy/at803x.c  | 580 +++++++++++++++++++++++++++++++++++---
 drivers/net/phy/phy-c45.c |  34 +++
 include/linux/phy.h       |   1 +
 include/uapi/linux/mdio.h |   9 +
 4 files changed, 577 insertions(+), 47 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

