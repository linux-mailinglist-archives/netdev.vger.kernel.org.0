Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D038CF8E0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfJHLut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:50:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53019 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730393AbfJHLus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:50:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D4A8221E5B;
        Tue,  8 Oct 2019 07:50:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Oct 2019 07:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=4L2uciMlwPKw6
        NVgmSskfFKGJ+TIqBRdUNzu7aGn5q0=; b=fGAhUa/M4VYY/lOb1BARcq7RDC9mW
        pyGTQmmOmT0LOKzi40AUqOW0IZvK9MEkoOWJtVzzv+sTHC9mELcpEGOOzGcY/LJS
        o1D+uYIUQwhgns/JO+/zGnwNqRCUV7OAwfex3KJF30lTUrjOnI5iAaiuarDX1Nnp
        pChAEUTMxQVXizdJtatGHg5z5N/IEsYiwza3c7hHBom8QLPPWDUM9JdzMALRu3uy
        ydEa9Ll3y1NG8Al2m3EeiGWk4wuOsCeP8l9Ut3Gcu40jWxhbMpefAB/vxeGbkfQd
        NkAV/dDvaTKtdt0ePysj1+rDD19GBW2sxyD3M14R6uuFPaihJW38Si3AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4L2uciMlwPKw6NVgmSskfFKGJ+TIqBRdUNzu7aGn5q0=; b=dZJNgShK
        rdRQo9urUX6JBqnnshotNFcrV+8aWExF3n2/WXh0lmQ8fxYzBAdapLvKMsHu+OPZ
        kJYOFXNMfINmoQp+Pvi83VgcNyLspL4Dr1PrDNLBxTYv/tvpbRIPTQRdmk5bMK0M
        4pyIa/WVZ0wrGd5lEdrsvnvCDPJ+4HfZNbnpizMuo6NPsegRNKr+5myUmgLWv5FO
        5vL3kTzblDZlaDLn9hgSEqUwf+r5HGrDyMFK8Z94hcidm2RJ7xsS6uQvIodigr1g
        TZMz+PbvOjo20dPskfvXnbLu67+u4z1ycuEB63id/qHfI5696yDXf3nLeERv2KhJ
        sb6w/rgRkLngfg==
X-ME-Sender: <xms:FnicXcjLVSLu3xXo6xmKmXcjcB-qdvvmoh4HfaRNBlWiKoyV3ORHgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtfedrheejrddvudehrddujeeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:FnicXQeGRv9PVhWotf1nsLn6wDjKIg3Om4Wd8q1Zki4bQON-CKwJIA>
    <xmx:FnicXSyB1v2nhKdbNKobFVdhvjIbJnnIMr-r6gYCw9Urvd1Kbo-Uug>
    <xmx:FnicXaa2lGGAO1c1lA-dL22Od9dQhUiNQ2CMxmYedPCvVhsH6cBeDw>
    <xmx:FnicXcr_DbscJWmAOVSNpFs8S19rEGXTjYxeA84XJwlh5pPFc-4OuQ>
Received: from mistburn.lan (203-57-215-178.dyn.iinet.net.au [203.57.215.178])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DE6D8005B;
        Tue,  8 Oct 2019 07:50:43 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org
Subject: [PATCH 2/3] dt-bindings: net: ftgmac100: Describe clock properties
Date:   Tue,  8 Oct 2019 22:21:42 +1030
Message-Id: <20191008115143.14149-3-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008115143.14149-1-andrew@aj.id.au>
References: <20191008115143.14149-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Critically, the AST2600 requires ungating the RMII RCLK if e.g. NCSI is
in use.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
---
 Documentation/devicetree/bindings/net/ftgmac100.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
index 04cc0191b7dd..c443b0b84be5 100644
--- a/Documentation/devicetree/bindings/net/ftgmac100.txt
+++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
@@ -24,6 +24,12 @@ Optional properties:
 - no-hw-checksum: Used to disable HW checksum support. Here for backward
   compatibility as the driver now should have correct defaults based on
   the SoC.
+- clocks: In accordance with the generic clock bindings. Must describe the MAC
+  IP clock, and optionally an RMII RCLK gate for the AST2600.
+- clock-names:
+
+      - "MACCLK": The MAC IP clock
+      - "RCLK": Clock gate for the RMII RCLK
 
 Example:
 
-- 
2.20.1

