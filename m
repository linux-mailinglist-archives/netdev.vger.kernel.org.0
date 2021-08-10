Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E43E5BBC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbhHJNc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:32:57 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62364 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241373AbhHJNcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:32:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628602353; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=6hqzkdfKqree8jFawrQLQ5Nin89Qt5mL93Mi7px0A9c=; b=UTDKaBtUTXNDAwjHx2YDFefqU37kLy4tC8Kq8thwrK4o4BAWyT0TJ0d9QFZt0oF3oT7+LbXD
 dY++X4f8z+vQiyPaNzGJDB/LEyVZQ5LeQTgDMlAHRswP8VpDdWYMtDASnoftGZsQP8XVYBKP
 LdOihlIyH2u7KCsX6ZnLmYpVVNo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 61127fb591487ad5206e91fa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Aug 2021 13:31:33
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CB3FBC433F1; Tue, 10 Aug 2021 13:31:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from akronite-sh-dev02.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE42CC433F1;
        Tue, 10 Aug 2021 13:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DE42CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
From:   Luo Jie <luoj@codeaurora.org>
To:     andrew@lunn.ch, agross@kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        robert.marko@sartura.hr
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org, Luo Jie <luoj@codeaurora.org>
Subject: [PATCH v2 0/3] net: mdio: Add IPQ MDIO reset related function
Date:   Tue, 10 Aug 2021 21:31:13 +0800
Message-Id: <20210810133116.29463-1-luoj@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the MDIO reset features, which includes
configuring MDIO clock source frequency and indicating CMN_PLL that
ethernet LDO has been ready, this ethernet LDO is dedicated in the
IPQ5018 platform.

Specify more chipset IPQ40xx, IPQ807x, IPQ60xx and IPQ50xx supported by
this MDIO driver.

Changes in v2:
	* Addressed review comments (Andrew Lunn).
	* Remove the IS_ERR().
	* make binding patch part of series.
	* document the property 'reg' and 'clock'.

Changes in v1:
	* make MDIO_IPQ4019 unchanged for backwards compatibility.
	* remove the PHY reset functions

Luo Jie (3):
  net: mdio: Add the reset function for IPQ MDIO driver
  MDIO: Kconfig: Specify more IPQ chipset supported
  dt-bindings: net: Add the properties for ipq4019 MDIO

 .../bindings/net/qcom,ipq4019-mdio.yaml       | 15 +++++-
 drivers/net/mdio/Kconfig                      |  3 +-
 drivers/net/mdio/mdio-ipq4019.c               | 48 +++++++++++++++++++
 3 files changed, 64 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

