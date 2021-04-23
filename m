Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6816368C75
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbhDWFVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhDWFVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:21:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B4BC061574;
        Thu, 22 Apr 2021 22:21:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j14-20020a17090a694eb0290152d92c205dso611457pjm.0;
        Thu, 22 Apr 2021 22:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MieVHBeftBWgRkSvI3T/dSTqRh2CCLfDKWUB6Ipjrsw=;
        b=IWpkNMmz1YRQVdQSOWklrN/tXKJ1wpQbTrwgcxxKAPf1u16qOGtO3U7c+p7BojGrkQ
         DZsy+EVCb4UDoGBvC6yxUtdL4hk0yB/K/eKI0KpeSaNaSxC49bmZg0XAR27QL1pbKgMY
         GW1v2ELOwEXRUmxr5DyUYq7hw6/f307l+Zs7072gaOtk3wOXXnz7FvC8Yf3itrkXx5G2
         Z6YUIifWcPlT3+ztReqDiO4zv13FykAaPkIosbpvHVWsOojDl0TKHb9nWa1uXs8NUNij
         Agcm11yhZk6qu+424GmqohPhWt1moS7OxWbGMEb8KTh+7l9OddJlY1/qq4tWZg81OpOP
         XZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MieVHBeftBWgRkSvI3T/dSTqRh2CCLfDKWUB6Ipjrsw=;
        b=VsC7j4mBY+nx5eY/6lekuYMzwyfMIhoMv3BzDLxIDQffaa/D3W4I+wDl14mLfCuei9
         X+hPiORRx4oWF5P4GKS9RERNrTrGrANcz7xWBFwTvf4KllUI/3jaNTHyZZEh5gtWaGXk
         0XuJn1eYxdOUQaz4qeakeRatsSUKarAqQ9iHpQAZOu7c9Sbs84Rrw7q19kTEtm2q32wJ
         BllTLjctKsb94Yzga23qTzl/WIvaYnMYyouiGIre6mpwqbdYtAV4al80erI6apiD946p
         c3Eg7PutqKqXeb4fCgNDDBfd5EQay9IJRCty7LZNAu99JbZm/g+BirI9RGLdELc+M85b
         Ahjw==
X-Gm-Message-State: AOAM530QEfM6Ptk2n7oeZOUlLMHKRMg+Iqf8sZJ5RLW7CACKtVtdOgjm
        RWBXQOOO6ENtW9A4NGVbJl4=
X-Google-Smtp-Source: ABdhPJwa3spCgV3cEcDEi0fTP6+lYrXOYeaSNyrzY5MLC9mY2ytrThcyR2496gqtePPNhXwXRz9RBA==
X-Received: by 2002:a17:90a:d3c6:: with SMTP id d6mr2429812pjw.25.1619155276923;
        Thu, 22 Apr 2021 22:21:16 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:16 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 00/15] mtk_eth_soc: fixes and performance improvements
Date:   Thu, 22 Apr 2021 22:20:53 -0700
Message-Id: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of these changes come from OpenWrt where they have been present and
tested for months.

First three patches are bug fixes. The rest are performance
improvements. The last patch is a cleanup to use the iopoll.h macro for
busy-waiting instead of a custom loop.

v2:
 - Reverse christmas tree in "use iopoll.h macro for DMA init"
 - Use cond_resched() instead of iopoll.h macro in "reduce MDIO bus
   access latency"
 - Use napi_complete_done and rework NAPI callbacks in a new patch

Felix Fietkau (12):
  net: ethernet: mtk_eth_soc: fix RX VLAN offload
  net: ethernet: mtk_eth_soc: unmap RX data before calling build_skb
  net: ethernet: mtk_eth_soc: use napi_consume_skb
  net: ethernet: mtk_eth_soc: reduce MDIO bus access latency
  net: ethernet: mtk_eth_soc: remove unnecessary TX queue stops
  net: ethernet: mtk_eth_soc: use larger burst size for QDMA TX
  net: ethernet: mtk_eth_soc: increase DMA ring sizes
  net: ethernet: mtk_eth_soc: implement dynamic interrupt moderation
  net: ethernet: mtk_eth_soc: cache HW pointer of last freed TX
    descriptor
  net: ethernet: mtk_eth_soc: only read the full RX descriptor if DMA is
    done
  net: ethernet: mtk_eth_soc: reduce unnecessary interrupts
  net: ethernet: mtk_eth_soc: set PPE flow hash as skb hash if present

Ilya Lipnitskiy (3):
  net: ethernet: mtk_eth_soc: fix build_skb cleanup
  net: ethernet: mtk_eth_soc: rework NAPI callbacks
  net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init

 drivers/net/ethernet/mediatek/Kconfig       |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 262 +++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  50 +++-
 3 files changed, 213 insertions(+), 100 deletions(-)

-- 
2.31.1

