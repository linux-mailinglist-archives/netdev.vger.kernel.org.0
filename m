Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493FACF8DB
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfJHLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:50:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55641 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730503AbfJHLuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:50:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 45E1E21F41;
        Tue,  8 Oct 2019 07:50:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Oct 2019 07:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=80t49yUmTjxMS
        nA8I9JIsl6t600IjN1hqbYbWjxh6s8=; b=OcxVbD6Z2YMjrrXDDSCjtJ/v0gkOn
        1t98zad/dA8j6Y1OxgFeSw+hv0dwuvZndHikQSAveYHhnKyhm0S2gsdfDiA+PETp
        cqRbTlzV6CboiKJ8CvpmfYvx3LhsCqCDcuSUX7TmKMNAmoKOorPl6PEabm8twY6j
        V65gRCb/ZUBRhVxXRXf/rvOkyLQH8xYqcL39DdkL/KsL3Oqk+1dCh3vw8YUt7qqT
        8jPbXrcVD5rIiP0SF8UtQFaoBIVDXp0GbBgk3XEcefe5QdmR7aQsY3IbDjN8LWPh
        JEHyCmYdinyYG1aaUmGZl35RCSxFAFu/NedmmKURK1YuS75gjfzEbwNfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=80t49yUmTjxMSnA8I9JIsl6t600IjN1hqbYbWjxh6s8=; b=TUF5/F8j
        BQaQXEVRY4MBuYU1ga8TMR5aZF3oCvvxW4gu293ddv1JYSBjtd+KnFE05oqRr+oq
        l/I70mB+O2HL/LkZqS49pSif7nQRNkCzGSs3Sb73mUQfIAD57GIIkIivjnzu4igd
        S6A34nj1xEA2zQLLwKfUhXO9eInPb3dpr5GroyU7S4p4mk7swCt5jnYf5T71wKjk
        b5IogpqXDckhjV3JJBL5rp/Umy2NrbfPqXYJXG0Tf52NVQ7/f18hBdP5fetp8tXM
        NLFvOPqef8PMBOh65TZ2227wXb7xk+Ln1Y7wyuORoiyYVPZ44URz0OdSZ7WbYBE4
        GRzHUACGF+Xw3g==
X-ME-Sender: <xms:E3icXTzImyvkDFqMmycjxcB4ht6HZCA8glYgJQYgBiOos8tDhfCqUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghj
    rdhiugdrrghuqeenucfkphepvddtfedrheejrddvudehrddujeeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrnhgurhgvfiesrghjrdhiugdrrghunecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:E3icXewOTI1J4zJr62qsgxzcXLG7aNSV0a0FN_a1D5rYlEAECzYjeg>
    <xmx:E3icXV0JbK5DWVvy5D_qwx3vUJATWL4keDsl3suTi5-TjgbLgMJgZQ>
    <xmx:E3icXQUnIGp-BDq507t4NMPuP5KiZ3TLOtEKAATbUqIVK6j2smxdTw>
    <xmx:E3icXYHTq-5ZYBO_73bjqIB0hZTKJ4lT41BViCwvuRsl6HrZDrhjsA>
Received: from mistburn.lan (203-57-215-178.dyn.iinet.net.au [203.57.215.178])
        by mail.messagingengine.com (Postfix) with ESMTPA id F0FC780066;
        Tue,  8 Oct 2019 07:50:39 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org
Subject: [PATCH 1/3] dt-bindings: net: ftgmac100: Document AST2600 compatible
Date:   Tue,  8 Oct 2019 22:21:41 +1030
Message-Id: <20191008115143.14149-2-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008115143.14149-1-andrew@aj.id.au>
References: <20191008115143.14149-1-andrew@aj.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 contains an FTGMAC100-compatible MAC, although it no-longer
contains an MDIO controller.

Signed-off-by: Andrew Jeffery <andrew@aj.id.au>
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

