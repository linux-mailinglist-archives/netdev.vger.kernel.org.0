Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB946DAD6B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240719AbjDGN1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjDGN1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9FC76AB;
        Fri,  7 Apr 2023 06:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65A064DC6;
        Fri,  7 Apr 2023 13:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B91AC4339B;
        Fri,  7 Apr 2023 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680874021;
        bh=dKR9JXPNGW1vGc4GpH3hyRN+kbHPQL1J6CUm7tbP1Ws=;
        h=From:Date:Subject:To:Cc:From;
        b=R+YqcmpsZpr0gGA+quyJV2jhBCVgGu+qUdROSIu14X6ExnK/lT3JWL1UNdnU26tn2
         FLLgx/zmNwfZu0biiH5SNUwNVcVefVJr7inrOUDP2dt+g7ezG3t6da/kfkeQY+odVO
         3f30jadqimQ4yHjflFtsb8BC/C9OMcFWlRuBbuy280sVbowLkRm6Ad3+3YhH2Imsm/
         qCDH7w6A+H3UZkFyJvXrW0A7zTw/fDDt6glsnKSE2vc7Cm3DRTgSgK9G10hJ8O//CK
         oZOtM/O8v1WCXM/ivq4klJx5aJGphofcpkZF2/PH3n/PM7yIPW/Oz1m8ap4/0TT0u2
         BmIj5gzqB4TEg==
From:   Simon Horman <horms@kernel.org>
Date:   Fri, 07 Apr 2023 15:26:51 +0200
Subject: [PATCH net-next v2] net: ethernet: mtk_eth_soc: use be32 type to
 store be32 values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230401-mtk_eth_soc-sparse-v2-1-963becba3cb7@kernel.org>
X-B4-Tracking: v=1; b=H4sIABoaMGQC/32OUQqDMBBEr1L2uymJCtp+9R5FJImrCdqNbFKxi
 Hdv8AD9fDMMb3aIyB4jPC47MK4++kAZiusFrNM0ovB9ZihkUcpKKvFOU4fJdTFYERfNEYWsdGl
 kb+uyGSAPjc6hYU3W5Sl95jmHC+Pgt9P0AsIkCLcEbW6cjynw97ywqrP/Z1uVUKKp8D7Y2jSoz
 XNCJpxvgUdoj+P4AXd7RCDUAAAA
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

n_addr is used to store be32 values,
so a sparse-friendly array of be32 to store these values.

Flagged by sparse:
  .../mtk_ppe_debugfs.c:59:27: warning: incorrect type in assignment (different base types)
  .../mtk_ppe_debugfs.c:59:27:    expected unsigned int
  .../mtk_ppe_debugfs.c:59:27:    got restricted __be32 [usertype]
  .../mtk_ppe_debugfs.c:161:46: warning: cast to restricted __be16

No functional changes intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
Changes in v2:
- Drop change to make use of the cpu_to_be32_array helper.
  It was suggested that a new helper is in order.
  Let's leave that as a follow-up.
- Link to v1: https://lore.kernel.org/r/20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org
---
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 53cf87e9acbb..316fe2e70fea 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -47,7 +47,7 @@ static const char *mtk_foe_pkt_type_str(int type)
 static void
 mtk_print_addr(struct seq_file *m, u32 *addr, bool ipv6)
 {
-	u32 n_addr[4];
+	__be32 n_addr[4];
 	int i;
 
 	if (!ipv6) {

