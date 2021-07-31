Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922EC3DC7DB
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhGaTKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 15:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhGaTKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 15:10:41 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B1DC06175F;
        Sat, 31 Jul 2021 12:10:34 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k3so12820596ilu.2;
        Sat, 31 Jul 2021 12:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v7/TaYm/UF25Rhll7uHhh9B/mqiJ7+iZYI4BORoPII4=;
        b=nWpLOBq79CReWCkzfPSmWtyO1gGGTgw2IFheOv4pryVY/ew1eNQFhc6mhNh1x+Vunk
         /kLpUNDR/RsvGBtpULidFsf1YGwWl/5LntEvp9k6Ls/AyA4qGeD07pVh7gqTfsER7fp6
         M4Hkl9WJnHFWjWouhNC/Q85XCjuAF5WNy8MhUHPxfEZRNtgd4j+OHOytHP1kdfEm4OMA
         OwGBwLCuPSn+XdN4ckEv7+bvls+VSdnEcuNgOlM1yCAN0ysH09JxALVqhAwJPUoPw/cM
         m9WDiF5Xw769oPkXgpRkaC2BPHnGiXZFRE3fwQpV3JptRtyMXIKy/PFKEYK330Jylym8
         t2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v7/TaYm/UF25Rhll7uHhh9B/mqiJ7+iZYI4BORoPII4=;
        b=SfQTFLeV1HcOJLyu+IVLaYmagk3GEjtZqctDIZeXjcWSvV1FZ2BTgS8y5z6jPIQw78
         D8RV0JCiQV2dTNBWheOvzmgCn4LdAVVCWkTvvzxEr1rbL9mWDkyxHB4xeCNPEET+ltqY
         hA6TV7tdCrZUrQYyMqCqyChfXPvDRfkT2JoZrkbPmY6dg+hzVMrPbVkMSuEeBjtorh0q
         i5OiA+7BU9OM1zudMPdZADE60gayq/uIXfcjg9h6DFfG7lcp4RWKVmVyWYuYPgI847Xa
         pJZUg2YLLNuDj9FPIZ6+SWGhx2ZkTDByrCjuBNE1t8nLgK+rXg4mn7kSofVfKO/2lQs1
         ADJQ==
X-Gm-Message-State: AOAM530ysy3NnsTcQi3ezfLq7UahIWXnD5TxPeQxEqsfp+XxzwryNjVp
        JIdFVb8fOy3ih9TbcTyZDLc=
X-Google-Smtp-Source: ABdhPJwKeP8kac45tmmqAQD/bbEi8A11l0vaH2d34nx7mjExz7NP+udqtBb2bTC9n/AQmV6ruzrYXQ==
X-Received: by 2002:a92:d44b:: with SMTP id r11mr2337590ilm.217.1627758633355;
        Sat, 31 Jul 2021 12:10:33 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g1sm2837991ilq.13.2021.07.31.12.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 12:10:32 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [RFC net-next v2 0/4] mt7530 software fallback bridging fix
Date:   Sun,  1 Aug 2021 03:10:18 +0800
Message-Id: <20210731191023.1329446-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA core has gained software fallback support since commit 2f5dc00f7a3e,
but it does not work properly on mt7530. This patch series fixes the
issues.

DENG Qingfang (4):
  net: dsa: mt7530: enable assisted learning on CPU port
  net: dsa: mt7530: use independent VLAN learning on VLAN-unaware
    bridges
  net: dsa: mt7530: set STP state also on filter ID 1
  Revert "mt7530 mt7530_fdb_write only set ivl bit vid larger than 1"

 drivers/net/dsa/mt7530.c | 86 +++++++++++++++++++++++++++-------------
 drivers/net/dsa/mt7530.h |  6 ++-
 2 files changed, 63 insertions(+), 29 deletions(-)

-- 
2.25.1

