Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836E0367840
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhDVEKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhDVEKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E69C06174A;
        Wed, 21 Apr 2021 21:09:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso240238pjn.0;
        Wed, 21 Apr 2021 21:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9ndYHHujvr1zav297RhllK1op/Od2oHV/TZTHj5aJs=;
        b=sl0iLZcInFVAtLnDOFrIXPW2KwmX5CPRzW7Wl29+gSD1dN/KP7OeEsfr7anUJpf7IH
         vtF0SDUkffma2cQ7e5s2QjBXQ4ifU/pbb51BFC4jWaXFMJkFJ8SFDpzSFOrM8m3W+MsP
         j6T7bed+GaTDS0aytX66+omjj6BTQhy0/BY3ls4tnt7OuMzuI0df8TgVpEtaleixw9wA
         h1OV++0OVlBnDSRj+QutLb1f5QbZrIP2ZCbTgPb2bZt3Wp+pk47elXdyEPvGq3R36Lzd
         wQHsI2J/sSgR4V5edR+waJDZnYUinPfbTLA/ZOe4UNohr43LEI8rNzfOzL2aV/lZtSdV
         etrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9ndYHHujvr1zav297RhllK1op/Od2oHV/TZTHj5aJs=;
        b=MgRJ4XlXNq2LgRUGepaq91EVwMVP/YIXTmJg2D0cI3+oj828CupJpakYmHDRwHgDR5
         CTo4dFNQDWIJQfCtIJmOOORc2H9ObI+TiK484N7xAsWgMP+dK4gmZlgPulSa7r5zTVKK
         ck0WXT2OcNlN6vNGNaFSrjnO7CCOn+IW/B2oleRenmLnJqEWdmAoXKu/J79EYsUPVLUu
         SS4z6XPsHFbkLjwQx7kvqZxjZGq4MMf7pmjaOcDPZ3iqKNP6tk+Pdb1TT1Rjrw+6ov/4
         JYAEYePViMx7/3qMpiXcc6bmfzqKwDiY+iucoJvNDQpU+N0jjD5suBOcpHwsbq1jt5Mk
         NAlw==
X-Gm-Message-State: AOAM531LOvUZK+QMf9JfNlwsHY0TYoUYlxXyiQJ4F/vX5ZHIF27P/6fd
        zmGaIEpJQUZxuEgWrgMRFgQ=
X-Google-Smtp-Source: ABdhPJzBiSiO1OFTfb8ncPAgubknwm6a4rAa1zMYzUajGilaHKacgpxpKY5LA35Y1+AhtpGLBgKYnw==
X-Received: by 2002:a17:90a:7d02:: with SMTP id g2mr7902256pjl.153.1619064577536;
        Wed, 21 Apr 2021 21:09:37 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:36 -0700 (PDT)
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
Subject: [PATCH net-next 00/14] mtk_eth_soc: fixes and performance improvements
Date:   Wed, 21 Apr 2021 21:09:00 -0700
Message-Id: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
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

Source: 770-*.patch at https://git.openwrt.org/?p=openwrt/openwrt.git;a=tree;f=target/linux/generic/pending-5.10;hb=HEAD

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

Ilya Lipnitskiy (2):
  net: ethernet: mtk_eth_soc: fix build_skb cleanup
  net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init

 drivers/net/ethernet/mediatek/Kconfig       |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 228 ++++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  52 ++++-
 3 files changed, 199 insertions(+), 82 deletions(-)

-- 
2.31.1

