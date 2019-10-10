Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52101D1E4A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbfJJCJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:09:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51285 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731589AbfJJCH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:07:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C44621650;
        Wed,  9 Oct 2019 22:06:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Oct 2019 22:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=from
        :to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=x3RE897M5F/dnmR/2Ok3f4oZJT
        eYElmylbpXjY9R6Iw=; b=R4zreAWrlLRXLiFZci5z7dmfxEQouExBqH+Uw6yre1
        k3qF5/+TuikKp4N4VYgNEQLp1pgwDL466kRwB9VW55Oa3rcReKra/SNYLeiUiDRj
        gUAmIDiDkgEPlNyTRPrL1ILLXPM1hq+Trc5YgynmpBH43vkIZq8d2tDrZ0JsU8Ez
        IWTMvn2T/uPVavnhvz+iwobu0/0+Zc1R+N1mtc0CB0oUwMui/7Ro3gNUEDGgLv+X
        afdXzYFMoyXfICMoggo8lfEW4mjlDn/qLuywwnq3Rbx+L/bThm9HqvVfSjeoZZMy
        o+xXXYMld22QwX/Hvq39Zk6z5c6rYhKN9f594p4i53/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=x3RE897M5F/dnmR/2
        Ok3f4oZJTeYElmylbpXjY9R6Iw=; b=gbX5yrExxC/b+xFBGN2bYcT8hjz+t0fQe
        0/+J8xXBMtUr1CtWpsu9AVl98cPk3mNA69cSebsgsBAHlqpbkM2tWKPsi5ga43lT
        IXjI19PklRm3GaXbUL/W9fexM7PXoFRqKG9awkvtJ/u4dtr8xAf6BaJIrqvS8uHN
        hTYka9gVtKnDvl6Y1FaoCaJlToFPMfFXwXzZ65iHu8iqp1OTCcdIC89Jyf9vEEgx
        z2qcaSwOgz353mLRmSCNEhkAQOT4OYK/hhBOiUpXJCS6/xhpVZpTKZpci4EFezrD
        IQGsCyuwNBS13bcK1a1+5r1lUIuYtH175bEsbaby5NR59K4Os8jSQ==
X-ME-Sender: <xms:PpKeXfq1M__LrjncpJ81iq4uhR2RTk_qFUjkuL3Sy5s1tDE2vAOWjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetnhgurhgvficulfgvfhhfvghrhicuoegrnhgurhgvfiesrghjrdhi
    ugdrrghuqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvtddvrdekud
    drudekrdeftdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvgifsegrjhdrihgu
    rdgruhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:PpKeXXCAu0Dj4TyIV6IZf2Uzi6WyrHP5frzgoCYm6-K8rUPLSNFNtw>
    <xmx:PpKeXVtg7E4hl5HlUHXaco4xqTGFhkPyIlMqco3s70S6dJqAANnxHw>
    <xmx:PpKeXeKKlUAZksDZBYPZd8PGhAufV5PkGtTYy98T16JmIK8mEj0s-g>
    <xmx:P5KeXTOIJFM-GV-fdE4iM5wcdN4iteNKcmq-chPXyXEdqRz07NnGpA>
Received: from mistburn.au.ibm.com (bh02i525f01.au.ibm.com [202.81.18.30])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99D668005A;
        Wed,  9 Oct 2019 22:06:51 -0400 (EDT)
From:   Andrew Jeffery <andrew@aj.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH v2 0/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
Date:   Thu, 10 Oct 2019 12:37:53 +1030
Message-Id: <20191010020756.4198-1-andrew@aj.id.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series slightly extends the devicetree binding and driver for the
FTGMAC100 to describe an optional RMII RCLK gate in the clocks property.
Currently it's necessary for the kernel to ungate RCLK on the AST2600 in NCSI
configurations as u-boot does not yet support NCSI (which uses the
R(educed)MII).

v2:
* Clear up Reduced vs Reversed MII in the cover letter
* Mitigate anxiety in the commit message for 1/3 
* Clarify that AST2500 is also affected in the clocks property description in
  2/3
* Rework the error paths and update some comments in 3/3

v1 can be found here: https://lore.kernel.org/netdev/20191008115143.14149-1-andrew@aj.id.au/

Please review!

Andrew

Andrew Jeffery (3):
  dt-bindings: net: ftgmac100: Document AST2600 compatible
  dt-bindings: net: ftgmac100: Describe clock properties
  net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs

 .../devicetree/bindings/net/ftgmac100.txt     |  8 +++
 drivers/net/ethernet/faraday/ftgmac100.c      | 50 +++++++++++++++----
 2 files changed, 48 insertions(+), 10 deletions(-)

-- 
2.20.1

