Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABC83DF209
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhHCQE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhHCQE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:04:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D42C061757;
        Tue,  3 Aug 2021 09:04:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u2so16011301plg.10;
        Tue, 03 Aug 2021 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Q+M9bdfzC5vw78BK6KF6b7X1yy5cTQ6a22GkGLbvW8=;
        b=EL6GO19w/yJX4+hYApVgoQg03d4gp72M5TckCBpAxCoSwFnzcgS9agnQbNQiPTTIvR
         53OlXPv7BPOh7DjH9xOt9GPMFo+Wf/V+ASVsEPeFMio9dH/SDGa1NrUCa/xQa56E5FQt
         BzeiVT4VzatMocLdr+hQlIgdTGNfhhHzAjI9T8yjHeHTN/+p82zKejs93QvgtfSRoORa
         EMNwTkwbOi7VFoseVVpFY7MY4wDFc/mdXFXfxD0dhWrCA6JGMPf/1THayV9WBdq4BXv/
         I66X4qJft2+Dsr6VVIhsU8H9HePaiKhD4+ciIZEUSE2gaNdVU2xs5XErXpLw7wRV68Pk
         b72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Q+M9bdfzC5vw78BK6KF6b7X1yy5cTQ6a22GkGLbvW8=;
        b=a8ouHAaSyXlF5KrKCgbqTYVNblkC1XAMXAYKX2St/jlk2xCPCo+li9RF2Tg1EYIvwe
         SHmZZGfjupYlHHWOr/zvfOuvcHfqRSs9ouk23JdR6MD+gDOHG/hAiFMLOLmiQFW5FFNu
         lj+J1d48ohjl4MtFJVoi061uoYQ2nF++zdcCCTcNjX0U7FrbzQBrdPNwOVi68q9/tyCs
         ju8FiO/KJ7IWO6m2nmAawRm1HXeyUly0LG6FJRMVe47NVQMS9EUHOVvJ+ZkIWtvV8Kk4
         asY5YY0Wko+/boWFCcMz4DmGNblHorEukoEm+AxhQy7ScK262+KwK3UsLh0cRyFUH2YO
         kPOA==
X-Gm-Message-State: AOAM532orCCYndeI/kAfM224AKTyv4Y5/nxc2z1tWRNNKt8kzkChIpjL
        ZZlyMw700NY4I/GpxVbhqN0=
X-Google-Smtp-Source: ABdhPJxe1Q/tx1mCHBBgNfuGn0U0PA6NgtEr/CiQbM+pLNCCSAHZbz6U3WIyTP0ViiUweMKXBNDoaQ==
X-Received: by 2002:a17:90a:c912:: with SMTP id v18mr23181709pjt.135.1628006656475;
        Tue, 03 Aug 2021 09:04:16 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y6sm14390653pjr.48.2021.08.03.09.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:04:15 -0700 (PDT)
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
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 0/4] mt7530 software fallback bridging fix
Date:   Wed,  4 Aug 2021 00:04:00 +0800
Message-Id: <20210803160405.3025624-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA core has gained software fallback support since commit 2f5dc00f7a3e
("net: bridge: switchdev: let drivers inform which bridge ports are
offloaded"), but it does not work properly on mt7530. This patch series
fixes the issues.

DENG Qingfang (4):
  net: dsa: mt7530: enable assisted learning on CPU port
  net: dsa: mt7530: use independent VLAN learning on VLAN-unaware
    bridges
  net: dsa: mt7530: set STP state on filter ID 1
  net: dsa: mt7530: always install FDB entries with IVL and FID 1

 drivers/net/dsa/mt7530.c | 88 ++++++++++++++++++++++++++++------------
 drivers/net/dsa/mt7530.h | 14 +++++--
 2 files changed, 72 insertions(+), 30 deletions(-)

-- 
2.25.1

