Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8886CD1E52
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbfJJCKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:10:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50173 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732599AbfJJCH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:07:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 53F3D20963;
        Wed,  9 Oct 2019 22:06:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 22:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=0W/usZNXhyMNI
        sw8q7SzfZokc2ewQzqfo920euFsCVM=; b=NwmmRozZlTgjttXStjhFwzJWXVL3w
        /yYViPG7a3iKaq9FfF5mxMlb54iHBgjUio5gPYOUy5uOVzuy50BeTJ1I8x4fTja8
        GRaBpaDz3SRELmBtLfmZnzxRXHhK+gKwwgFhEaU2nOIbXQYHo7Atd0x5LQXg4Y3X
        bVs+AQvSJhteiTpHjvWworuxA+k7uGTWWyH7oDhNWPSCkGreOycXCl81k0j38444
        eUBwQO+CFZvD9gQfRLrUu7iRywH80YVAbKzI9i683YsoLM1uYshI1Aa39a4boQnL
        B2wVQv65AIjS7OCS2ud/QAXNmhxHT6aq7WBYXk7vWescUU+8hmCu1ZqUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0W/usZNXhyMNIsw8q7SzfZokc2ewQzqfo920euFsCVM=; b=syn9HLHh
        nQhZND7rdrUgRaKPfCfJZjLhA9wmm+7rQcd0b9nSZVKZcpgyIWZDCucgE8SVAH36
        w3jyRW01JN0To/1gqQfNc4FHF7hx/jT/b0SlrrU+YvFnc0ofM+55j2T21kAdFnRY
        cbGzttoxdRfnsSSbp+Qe2R0cW+SbRwMYozQxR9AvVFZaJj1gnnlu1LGwKWs3Zaw+
        0FFMtYbADKv0CORqnkVaIlRC75zs7yA0J1dKKVJJ1smWbPc4CHfZnwiD1UTj6VpM
        7LBrNOiAoVkMeKeAo6u/DcJctFCRkGXBcHjI8i2pHKyfDtE2xtF357BZcvqnd0zC
        gjio90VO77Jw+Q==
X-ME-Sender: <xms:QpKeXUq8ROxqBkOMtvkEUi_3e9hH5sFCXYkOlwZBf1lIaH2rJ6wO3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtvddrkedurddukedrfedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihiivgep
    ge
X-ME-Proxy: <xmx:QpKeXRHjJ2DmUpEbaY8TEK1LNOpyvzrePzz81mRCM6nqMnds7Hw4og>
    <xmx:QpKeXSAHQ8N0wPR65BF6Za8XwTBIGdSQr3NyQjVG-myAreUru4HwgQ>
    <xmx:QpKeXeyt3LGeQuA2zQM05oJKv0iX1tzpEsU8SPEON7fR0itzWsVRNg>
    <xmx:QpKeXTl-UyZhm2le3voM-zgsOUS9UOAVdw_HBLtUy9aybRJAaNgP9A>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3272D80059;
        Wed,  9 Oct 2019 22:06:54 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH v2 1/3] dt-bindings: net: ftgmac100: Document AST2600 compatible
Date:   Thu, 10 Oct 2019 12:37:54 +1030
Message-Id: <20191010020756.4198-2-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191010020756.4198-1-andrew@aj.id.au>
References: <20191010020756.4198-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 contains an FTGMAC100-compatible MAC, although the MDIO
controller previously embedded in the MAC has been moved out to a
dedicated MDIO block.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
Acked-by: Joel Stanley <joel@jms.id.au>
---
 Documentation/devicetree/bindings/net/ftgmac100.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
index 72e7aaf7242e..04cc0191b7dd 100644
--- a/Documentation/devicetree/bindings/net/ftgmac100.txt
+++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
@@ -9,6 +9,7 @@ Required properties:
 
      - "aspeed,ast2400-mac"
      - "aspeed,ast2500-mac"
+     - "aspeed,ast2600-mac"
 
 - reg: Address and length of the register set for the device
 - interrupts: Should contain ethernet controller interrupt
-- 
2.20.1

