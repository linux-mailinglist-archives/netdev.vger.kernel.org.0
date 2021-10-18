Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124BC430E47
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhJRDhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:37:12 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34706 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhJRDgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 23:36:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634528052; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=cwjN/hTxbJx/qTzwJ1MRcttdNqPbjp6GgrHcvzehJ9g=; b=GphwIRXiwHTsqkYarnRiEaufuy8DpItCpJBOirxyg7lr/opEHqb/Ya1bSpAFeZ8BBj4bu2bC
 ncRKEGFC5BCeUWLczzbu7bm4QGYNSoTXEDN6W+aZv1FNHZ4KIq0su0L4J3O83Fdm/mROlkoU
 laEcLjTMLvC0Rem1+1oRDcvW3t4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 616ceb20446c6db0cbb23956 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 03:33:52
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 38AFEC43460; Mon, 18 Oct 2021 03:33:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A931C4338F;
        Mon, 18 Oct 2021 03:33:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 4A931C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v3 0/13] net: phy: Add qca8081 ethernet phy driver
Date:   Mon, 18 Oct 2021 11:33:20 +0800
Message-Id: <20211018033333.17677-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the qca8081 ethernet phy driver support, which
improve the wol feature, leverage at803x phy driver and add the fast
retrain, master/slave seed and CDT feature.

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

Luo Jie (13):
  net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
  net: phy: at803x: use phy_modify()
  net: phy: at803x: improve the WOL feature
  net: phy: at803x: use GENMASK() for speed status
  net: phy: add qca8081 ethernet phy driver
  net: phy: add qca8081 read_status
  net: phy: add qca8081 get_features
  net: phy: add qca8081 config_aneg
  net: phy: add constants for fast retrain related register
  net: phy: add qca8081 config_init
  net: phy: add qca8081 soft_reset and enable master/slave seed
  net: phy: adjust qca8081 master/slave seed value if link down
  net: phy: add qca8081 cdt feature

 drivers/net/phy/at803x.c  | 572 +++++++++++++++++++++++++++++++++++---
 include/uapi/linux/mdio.h |  10 +
 2 files changed, 536 insertions(+), 46 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

