Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663E17B928
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfGaFkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:40:14 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:36211 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbfGaFkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:40:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5F2C82D4C;
        Wed, 31 Jul 2019 01:40:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 31 Jul 2019 01:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=gbLCW5fm9NgGd
        7NHSQsOKrpG0gqK4d9GLmhDrnziGJs=; b=VlfQ+jaBx6M1eNbpsmY9c7XoFMwP1
        5iExP5LSTZ/+R2f7B488M+OtC1opnjEMBx/poItkTpP6FtPY1ClROIyFvRHHdUef
        LVgvqY/k7LJnW52DsTtX38pnAzOLMh6HYqvwNHkiZ5XvAnaHijeK2hG1lHSsZtch
        4GVnAFeR7nNHZyrH917dPmWTl+vJGCy8woOYj3MIUrkZm3AjeBrzQbg4/Dn9PVTJ
        QJz9K80Miastnfs5pMgE8/tauF/wOwVEV5m0TZqr2Ip7X/vMdvivhaP+Mig8hqBv
        5caGt2iYNBGAKw8FYb9D3B2atK1n8/bgCvQW7U5d2rxNmyLoOo4ETb4eQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gbLCW5fm9NgGd7NHSQsOKrpG0gqK4d9GLmhDrnziGJs=; b=yxYgPtcM
        rqeEijTvAgpyROeVysMp5lUdI8iwsmWj60tFvhL8AZBfuMu/A7GaT5tLBg5UU+ep
        TTquIN4tv68bCy7LneQRjTDjb89Iue4IBr5S4fZ3LaaWNlAnNFsoq1GpsyAzu6iK
        eGhaG+HLYn9xZUHJZc/FFpXjwaHc38Boi23fe3mQS4bQaIgNpmziNJkxxeHAYoKD
        EHyBZ1L/j7Z512JukWokYQJM0E3JhhTmyMHS3rIxurrwT1EGa8V4N1h6spQiaiCp
        UUAKojLEo+iWuiuaMJr3recWLzs09o9saECTBrXoRgJQSmzJvsdApmE54upwfwMH
        OGMmMJaDJq2+Hg==
X-ME-Sender: <xms:uilBXbe6YnMmqo2bvXPRVM49tzeY7xaees9Lr-bB_pIzhCmTB-AlVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    ud
X-ME-Proxy: <xmx:uilBXeD5KwrEpmb7kKRGYNIdxbEkJ9ifuNAFDqEj2OtBAT3fFsEV-g>
    <xmx:uilBXYspYjrGPLI-NWjiffNVdRe-fgTdCULKIuGyB5WbxShrrzC5AQ>
    <xmx:uilBXbH74Q90FmAehzDptAdn_seNLkNzDdDfcaglWRRUbf3CfY2z_g>
    <xmx:uilBXXDO62O3BrkRI80kvynlh83Pzok8exg_49HvtyTQjcfBHIqtFg>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1CC780059;
        Wed, 31 Jul 2019 01:40:05 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, joel@jms.id.au,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/4] net: ftgmac100: Select ASPEED MDIO driver for the AST2600
Date:   Wed, 31 Jul 2019 15:09:59 +0930
Message-Id: <20190731053959.16293-5-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731053959.16293-1-andrew@aj.id.au>
References: <20190731053959.16293-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensures we can talk to a PHY via MDIO on the AST2600, as the MDIO
controller is now separate from the MAC.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
---
 drivers/net/ethernet/faraday/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
index a9b105803fb7..73e4f2648e49 100644
--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -32,6 +32,7 @@ config FTGMAC100
 	depends on ARM || NDS32 || COMPILE_TEST
 	depends on !64BIT || BROKEN
 	select PHYLIB
+	select MDIO_ASPEED if MACH_ASPEED_G6
 	---help---
 	  This driver supports the FTGMAC100 Gigabit Ethernet controller
 	  from Faraday. It is used on Faraday A369, Andes AG102 and some
-- 
2.20.1

