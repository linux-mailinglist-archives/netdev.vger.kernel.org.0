Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1706D9EBB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjDFRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFRaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2F7AB9
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5697564A79
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C469FC433EF;
        Thu,  6 Apr 2023 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680802216;
        bh=hCCX2cA3QYGfj6QxeCyQVv6uXMkVZB5gXlYoQklEu+A=;
        h=From:Subject:Date:To:Cc:From;
        b=EOGTPMH6ZXuqE4xz3Nrf2FvN3yCGnO7fkPr8WQQwmh7WLzK32NhjVfgBSvAmWQTTg
         xGOTv5I13I/A9BiAqFu0ybxlZaT8IBC0W07XRecaEojLs/kxzUtnea6S+9RWAiaqws
         fm/p9xOq6wv/hZr87U90U6KNFNmpMjPXDM8JisV54uzsBBI6epBxpcslfqLGSPlJ9f
         73kF69CVGl4JqtCtvHWf0dgkOmxGHoOUuFRuOJ2yGcNEqZnTgn3AGitl0A1pDGqlDi
         WbukwAZXs8N9sgw/YJM9sgjDIihr1EgjUYKUMO4uqgG81Q49IeJBKC43CwORFe8ZQX
         mbicwgJqxyeww==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH net-next 0/2] net: stmmac: dwmac-anarion: address issues
 flagged by sparse
Date:   Thu, 06 Apr 2023 19:30:08 +0200
Message-Id: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKABL2QC/x2NQQrCQAxFr1KyNjDtWKleRVxkZqIdqLEkVQuld
 ze4fI//+BsYa2WDS7OB8qdafYlDe2ggjyQPxlqcoQtdDMdwwvJ9UkYSUl+izaTG2PZDjGFIfeE
 zeJrIZVKSPHos72lyOSvf6/r/uoLwgsLrArd9/wEEpRZOhQAAAA==
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two minor enhancements to dwmac-anarion to address issues flagged by
sparse.

1. Always return struct anarion_gmac * from anarion_config_dt()
2. Add __iomem annotation to register base

No functional change intended.
Compile tested only.

---
Simon Horman (2):
      net: stmmac: dwmac-anarion: Use annotation __iomem for register base
      net: stmmac: dwmac-anarion: Always return struct anarion_gmac * from anarion_config_dt()

 drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

base-commit: 0ebd4fd6b9064764a3af3d671463b1350abffb6c

