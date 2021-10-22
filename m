Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032CD437668
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhJVMJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:09:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:21642 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhJVMJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:09:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634904419; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=43eUuvVwpjJCMsH4ez5g8cOt1iRAYdjbVJ+xSmjBPBk=; b=moX5/N7kr/znCWCyyCuNhI42MVt+GPmn5c+k33/5hhU5C1iJlU+silwitvScB5GJel0AqVSi
 BDRnCZsxVAT97N4L/cY32+zcVorZ2d1GvlVu6ug9x4ftBUSK1sUv3csT+GokO0fsWqWbX/J5
 Nv/SY1ST8ITboka4tsIettjbgA8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6172a94d5ca800b6c18ee493 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Oct 2021 12:06:37
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6AE7C43617; Fri, 22 Oct 2021 12:06:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6ED5C4338F;
        Fri, 22 Oct 2021 12:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E6ED5C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v4 0/14] net: phy: Add qca8081 ethernet phy driver
Date:   Fri, 22 Oct 2021 20:06:10 +0800
Message-Id: <20211022120624.18069-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the qca8081 ethernet phy driver support, which
improve the wol feature, leverage at803x phy driver and add the fast
retrain, master/slave seed and CDT feature.

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

