Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0DD1E53
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbfJJCKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:10:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37343 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732609AbfJJCH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:07:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AD4E221F40;
        Wed,  9 Oct 2019 22:07:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 22:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=cJ+DJjMGi+ga6
        3uOIeMsVnocUVSdYidlPeybXfHXFnI=; b=J7BQ1YWHB7gOmC9oGcZd71Z1f7AFg
        ruendSeyoVlhR3niFZPBsVRZd0crZ1/kHXSbPmBfrHaL2wDWoDi6mfFe1+/3Of7/
        z7ZB8wjfgN9sIkJlF5FXRQZ/BwawY9AJ0MPDWMCm3fA+gV9jfojwim4m9deMqS2L
        7vuuvbr3StMqteMb9eMdqt7ROYNr8Ohtd9mbWJ+APLCfrOo5054CC5GXtwzTeN18
        O0CRj6m3qFEH8ro/Jit8JlOJEUBlPqoophPmm4Sh9DrnNdjhsoTCgeMJbKRwleYF
        eNPIJgVSH6nT1c37O5gn10VpQIpUhJ/JrBq4nXOyrPLpdXYMSkdDSpndg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=cJ+DJjMGi+ga63uOIeMsVnocUVSdYidlPeybXfHXFnI=; b=FBidB5KD
        KXGwoHQuiuNNl9Rclrv3GzyIeCdEwBmAcr8oMiaKTPOMJYMKGI57lfQMfs8WZUZI
        kVtIH3rFr+OiSYtAONR9q/47ckIW0lVi8QbymO2JEm9cXnCfOT3Owgpj+gxM4IvA
        mw9X9fnCccSzagXKuie8bzjZuULJKRjK0cP9TUUFKWc6xBzSCtvw2YgrVQZLp4AW
        UKpfuak9u4xts5vPjiHazRsfw/jLvDfsKrSa/ndKJi6lpuiBpXwP2OlyeMIYYWrL
        e0jKCoD3oKjiavR5UXussWyiEK2Rh7oljptPNhtP6m+ubOuLIXVhFCvR0A0HeiDh
        RuRF9zERNdeGRg==
X-ME-Sender: <xms:RZKeXRcTZYBRMdo4_Pth3T3wLe0xXjjb5RWPZ_2o_TwPu6nU-9Y9pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    he
X-ME-Proxy: <xmx:RZKeXRd3qAIUbfy7pYl2CGRpvucQbfVu2117GLmmutJxQzEKJpSoMA>
    <xmx:RZKeXal9LFYP0OQ7Pac0DCeb0ldZ4K18h6or0gR0znViPh0Zj99DPA>
    <xmx:RZKeXT5dVDw2O_05-MefHTwV88fTnV88Y8bcsgooAk35uTTbd5tQpw>
    <xmx:RZKeXXJCpODUHV6LByL_8zD4lXHbVpax5dslvtJ4h_oT2vDaEZTtJw>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F58980059;
        Wed,  9 Oct 2019 22:06:58 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH v2 2/3] dt-bindings: net: ftgmac100: Describe clock properties
Date:   Thu, 10 Oct 2019 12:37:55 +1030
Message-Id: <20191010020756.4198-3-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191010020756.4198-1-andrew@aj.id.au>
References: <20191010020756.4198-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Critically, the AST2600 requires ungating the RMII RCLK if e.g. NCSI is
in use.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Acked-by: Joel Stanley <joel@jms.id.au>
---
 Documentation/devicetree/bindings/net/ftgmac100.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
index 04cc0191b7dd..f878c1103463 100644
--- a/Documentation/devicetree/bindings/net/ftgmac100.txt
+++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
@@ -24,6 +24,13 @@ Optional properties:
 - no-hw-checksum: Used to disable HW checksum support. Here for backward
   compatibility as the driver now should have correct defaults based on
   the SoC.
+- clocks: In accordance with the generic clock bindings. Must describe the MAC
+  IP clock, and optionally an RMII RCLK gate for the AST2500/AST2600. The
+  required MAC clock must be the first cell.
+- clock-names:
+
+      - "MACCLK": The MAC IP clock
+      - "RCLK": Clock gate for the RMII RCLK
 
 Example:
 
-- 
2.20.1

