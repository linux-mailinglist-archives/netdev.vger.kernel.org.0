Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8A6DB050
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjDGQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbjDGQLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:11:55 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02570A5CE;
        Fri,  7 Apr 2023 09:11:34 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-211-012.ewe-ip-backbone.de [91.248.211.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2BF6B66031D8;
        Fri,  7 Apr 2023 17:11:33 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680883893;
        bh=hIFxz7AIRQRELp5o7Q1GvVMvBpn53V0Sa3K92H3lugU=;
        h=From:To:Cc:Subject:Date:From;
        b=iIJ2UcOJLouFkJJgG1dIEnCxWuLyJ/kbKBJMekUxM2IxgK5ojrasxQcKCOGL+s2Mz
         wgeKiGwnpHjwFflvQ9+/o2PvYtXGrBEvIw5XEJlPDXbFvnpxfRD8dA8Bp1F2xlYrVa
         X6Nvux2fA6/M16FOHnMSNaAlqG8IdUY/EPOYweoQnk9BNcQA2yPuk5kXPNyu6tY3LA
         TMsJthsbkyinJEWoTNxEXdLH4DUYbgC/TQz3PE40zTa96mpBEv4pG4d5ck5pt9+8h5
         gAxe8XmBnf7/GbjilI679yfHWHsSK20n52Riik+4N20PVqc10E0zy9h9+pY60YET/Z
         swItd0jsu+58A==
Received: by jupiter.universe (Postfix, from userid 1000)
        id F11104807E1; Fri,  7 Apr 2023 18:11:30 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv3 0/2] Fix RK3588 error prints
Date:   Fri,  7 Apr 2023 18:11:27 +0200
Message-Id: <20230407161129.70601-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This fixes a couple of false positive error messages printed by stmmac on
RK3588. I added Fixes tags, but I expect them to go via net-next, since
the patches are more or less cleanups :)

Changes since PATCHv2:
 * https://lore.kernel.org/all/20230405161043.46190-1-sebastian.reichel@collabora.com/
 * Remove regulator NULL check
 * Switch to devm_clk_bulk_get_optional as suggested by Andrew Lunn

Changes since PATCHv1:
 * https://lore.kernel.org/all/20230317174243.61500-1-sebastian.reichel@collabora.com/
 * Add Fixes tags
 * Use loop to request clocks

-- Sebastian

Sebastian Reichel (2):
  net: ethernet: stmmac: dwmac-rk: rework optional clock handling
  net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling

 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 197 +++++++-----------
 1 file changed, 74 insertions(+), 123 deletions(-)

-- 
2.39.2

