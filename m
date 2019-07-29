Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD26C78433
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 06:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfG2Ejn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 00:39:43 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56253 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfG2Ejm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 00:39:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0AEB815E6;
        Mon, 29 Jul 2019 00:39:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jul 2019 00:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=gbLCW5fm9NgGd
        7NHSQsOKrpG0gqK4d9GLmhDrnziGJs=; b=hp55ISoU8+QgD334QT5GIX0PfHxLJ
        cWMvGN9B788ZGK9aVgcIsD2ftEo+x9HRPTXoFnXiCrzRpIVPGM3pc+BfAtjZWkgP
        CwIKZAN+/9ZqOfooOhvWy/GdAIrIq/BLf1eSqIkFPYYtNCqSH1QzX+yTwYUiTHkF
        OaNdFXCl8O51IgFY2G51Kx6lkU9QM1hgZPO3gdrdSE46P7r+WCPZX6Sk1uyGtEai
        BDxO3QVb0AOsqZrvnrJ366LV8Wfc95ymwrJn4OwkBG/3Vwzvrr/19kMn5+XVxnqh
        kDttFzMPueC52PJQMoA+B21s09Ov8YTiQ9aj0lP6cy1Pgm6VB8opK78Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gbLCW5fm9NgGd7NHSQsOKrpG0gqK4d9GLmhDrnziGJs=; b=Sfu5Udh3
        PIIwUkU+eLLEDQPjOSZXztBhSJDvGsjmlZVef8IFw3zQaslUaFHBXRSkfqlWjgE9
        WTz4hJp+2vBF8aQbaeVW4OWsxz75fHNegnguK3gCFVwGNR9nF9P/J2zyc3BqItqQ
        bM+eFcW5VGHz5QQjpwWQhfj9DEA2nNWn2FL2cHUc9N3xBo3/f1SW2jLvC4SrqNpy
        Mh9nANtV9BR9VQHHt+I3s5InfjFFhik+GDtyW++WGWPoi2swiRtRzkWrH/MI5dwM
        wMo9xH2W8aVO3atUUfM30BWxKrMwDa9pTIUCqGKA9mvJFWssh4GKoluzRRJsPMIG
        HaoEb3nwEc1hmg==
X-ME-Sender: <xms:jHg-XXPK51iR4BfWppR7-D7MruukohO680rZTa-7jaOXfakR5sv-lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledtgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    vd
X-ME-Proxy: <xmx:jHg-XXOOl4VUPd_LYePOGJ5Pmw0bLPq_LYXBF1DFfVcTi5JkuYLOQw>
    <xmx:jHg-XX-YGvCONlIW1rtRfkSmX3OErjkltvkCFRk7HF3-EwZA8-HRSQ>
    <xmx:jHg-XT7-sQvC5-4mj0JPeWJ1H8emLKDxCd1k8t7sNFmA8pM47Ipdxw>
    <xmx:jXg-XW6cX41nswoNqn4yEttHtHJMqDRsP0avOLrCJLO2nfNvOKDiGQ>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE0FF8005A;
        Mon, 29 Jul 2019 00:39:36 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, joel@jms.id.au,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: ftgmac100: Select ASPEED MDIO driver for the AST2600
Date:   Mon, 29 Jul 2019 14:09:26 +0930
Message-Id: <20190729043926.32679-5-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729043926.32679-1-andrew@aj.id.au>
References: <20190729043926.32679-1-andrew@aj.id.au>
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

