Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7968B181
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 21:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBEULs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 15:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjBEULr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 15:11:47 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260C31BAC0;
        Sun,  5 Feb 2023 12:11:46 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AE2505C01FC;
        Sun,  5 Feb 2023 15:11:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 05 Feb 2023 15:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1675627903; x=1675714303; bh=B8XJNRt07J
        reiTXrKz9mZLWzRB51+bpePuQYGrdWsbE=; b=SlIK8oHjgLWYYQhyLktOvarncr
        P/KDP6yZ3ZYzInamjnhHn3V4ZCxqzx9MUlB6Tc94s5w4h0KdwLLw5XxyGM0WSMYe
        5tQz5RD9aj1OisjarBABLxWvNya9dzd9tW3nf8UV+RLUa2LW18bHGFLY7517f8gK
        ICcKSii4yX0C3bvGmN20n7SewTolN5mOZdKnygrZ01i6S/ZpbPyj3cnP7cF4TRBn
        Rh892eYx/SCuZqh2GulwKMIQUwPraF+OCXU0faZMZqwic1WCS5h/ZYeb4K3I3GfN
        YMTYKAzvLsaLsogSjgtejwaz47cRfKFhM5yTYnQmshH8rZ5mxXfqYheGn4sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1675627903; x=1675714303; bh=B8XJNRt07JreiTXrKz9mZLWzRB51+bpePuQ
        YGrdWsbE=; b=gwA8quD1NEvAMhhgVibL9dxPFCaElufGzSq99smTgeF3x610ADr
        BwTlkvGUE225hKd6Ax1qqpdV+V4AeSvToAiIdblulOn/QzYdfquCTJMch+8CItY6
        QHNLocb1wh9G4PwSjFiwrJX4jrCeW2KVHuOW0qwAq1kSGWlQg++2fHaCBek4qTCG
        bDFw1mN0LNABog+WX1/UqAvBzHfKwfM9BMSoQQ4hLIRsRtbU4T4fXrbIc0bG2wN8
        IdYdq9tSYRRLT/8Ui/O4Ei18YBUG/HqQ0D4hqUOJ8dcoPTmFnfSICeuoLzW/wkUw
        +Y3GhUlDoOB6pe9lJmjZfaBr9vNV+nAX08g==
X-ME-Sender: <xms:fg3gY_gd0iWP02az8Qw1xhakNf-aG9k64eRv9LBRnxYvikF_p9YxKQ>
    <xme:fg3gY8Cu-dnB-aaEYxQPcxYMWrUgl4HsCeKfPNQtFAgy1RduciEF9tITKwEX2LyRa
    8loHIpAaWjn6JfYwBM>
X-ME-Received: <xmr:fg3gY_E_sLI_Ke0PHJ09fmwZiRGeD0COPu1cM7_Tlzd1JLhKwwFAYsF3hDZlqqvrlPyPnC082EVU-Jr6sSeDjQ4Efx91tItBFCTs0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeggedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghs
    ucfuuhhhrhcuvehhrhhishhtvghnshgvnhcuoehjshgtsehumhgsrhgrtghulhhumhdroh
    hrgheqnecuggftrfgrthhtvghrnhepfeevgeeihfdttdefvdegleehffevveejgefhtefh
    hedvjeefudfgfeeigfelgfelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepjhhstgesuhhmsghrrggtuhhluhhmrdhorhhg
X-ME-Proxy: <xmx:fg3gY8QrjaMXmihqYZGesuPNENhR1ZfXX9xbH_3d2fX4Bzxw-IGekQ>
    <xmx:fg3gY8x-YQXH93AsUEBIBNx6adxU1pE2Idds6talM91RhYO974vK1w>
    <xmx:fg3gYy7hZC_bUSVzQuLds1atLIqrb_6Qx2vZdd5DG-XkQg0vHY0qyg>
    <xmx:fw3gYxJnwzCgTtENGMMRnmZhiFfk9CaTf74CIcdSD3guNZec6SN58Q>
Feedback-ID: i06314781:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Feb 2023 15:11:38 -0500 (EST)
From:   Jonas Suhr Christensen <jsc@umbraculum.org>
To:     netdev@vger.kernel.org
Cc:     jsc@umbraculum.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] Fix dma leaking
Date:   Sun,  5 Feb 2023 21:11:26 +0100
Message-Id: <20230205201130.11303-1-jsc@umbraculum.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes an error in the ll_temac driver releated to
dma mapping.

The main change adds missing conversion of address when unampping
dma.

Changes in v2:
  - Fix wrong (static) indexing when iterating in for-loop
  - Variable declaration order longest to shortest
  - Add fixes tags
  - improve commit message 

Jonas Suhr Christensen (2):
  net: ll_temac: Fix DMA resources leak
  net: ll_temac: Reset buffer on dma_map_single() errors

 drivers/net/ethernet/xilinx/ll_temac_main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
2.39.1

