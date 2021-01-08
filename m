Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C396C2EEF1E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbhAHJIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbhAHJIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:16 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C37C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:36 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ga15so13610475ejb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YL4YCdrsbVg9U6vex4bJpmYpCCAMI88PiSV3NwIsGew=;
        b=mjmlE2qKc1SM7q1HpUuVoTYuO+eH4qk8kI6YofgpFu4OQYw/12kVWhO9ZN2HDjNisX
         EH82Q1BmEZBGe3m3Agtg+oOwjjXuZAAI6qqNZ3dGXXWHzf4F0d4wuDt+mqzmtTxrQeiD
         DQ/cqVb1L2AEIiCD9rmvunlasBb23AvyfULAjpxL4nYV5CN15eYwklHwxcdZ7b+D/Cjv
         XT1j+YkApDXLk4mX0UqhrG2Ox9y4rCMZFkf6ME+uYVtplv03Rona+eF7AA3fnV2uoSLl
         THBerG+SqVMf0VkbRykgxckfrTkua6ixZUi2iTqVHHMSv1SAmjbOeWzFNCmbG7OdRjWG
         WKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YL4YCdrsbVg9U6vex4bJpmYpCCAMI88PiSV3NwIsGew=;
        b=JR5ASQrCzKL2q+hq2ieK1XvOH++KKpynBrzVUctEErWoNoetz0NfNadh+RRSoykrQS
         wLJekgB/+/odQlOGdL3bJ/0GnYsV0Vw0rpB4g2rQvSqWdPfS0P1+03P+XH9mMZ2kY126
         L8HLc0M6acOHzFq+mA4/DzpGqqEcUDbaTqtOzK7bSD3cgOM1uLQg9Mck36mbUwC5ZaGY
         gnTGNPc7VIO5CjejaGlkdM5rF4c+nxAJ2T1/lW6xjNx9x+DF38cB6EGi+wSnGfWWptLa
         XmoCZjCtDq9xexvEDYOLnkRXymVJaSU6zosst82nW1qqjoZWcL0Lo5ICCE97NUUnLKA3
         MurQ==
X-Gm-Message-State: AOAM531hsjdWddd5QLl0U1x/mPMrR4R4S89r2hWQGycCTJxoSqkrHXKh
        8KEjT7I8ONM2NU+CEWxJ228uZZw0UPB2eQ==
X-Google-Smtp-Source: ABdhPJy2fzuWkuvs85/lXfCWic87fEU42QRoD8uZWDxsXeZxA6riTWyS6sIiumO745C1as62C2ItSA==
X-Received: by 2002:a17:907:7251:: with SMTP id ds17mr2081120ejc.448.1610096854985;
        Fri, 08 Jan 2021 01:07:34 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:34 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ciorneiioana@gmail.com>
Subject: [PATCH net-next v2 0/6] dpaa2-mac: various updates
Date:   Fri,  8 Jan 2021 11:07:21 +0200
Message-Id: <20210108090727.866283-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first two patches of this series extends the MAC statistics support
to also work for network interfaces which have their link status handled
by firmware (TYPE_FIXED).

The next two patches are fixing a sporadic problem which happens when
the connected DPMAC object is not yet discovered by the fsl-mc bus, thus
the dpaa2-eth is not able to get a reference to it. A referred probe
will be requested in this case.

Finally, the last two patches make some cosmetic changes, mostly
removing comments and unnecessary checks.

Changes in v2:
 - replaced IS_ERR_OR_NULL() by IS_ERR() in patch 4/6
 - reworded the commit message of patch 6/6

Ioana Ciornei (6):
  dpaa2-mac: split up initializing the MAC object from connecting to it
  dpaa2-mac: export MAC counters even when in TYPE_FIXED
  bus: fsl-mc: return -EPROBE_DEFER when a device is not yet discovered
  dpaa2-eth: retry the probe when the MAC is not yet discovered on the
    bus
  dpaa2-mac: remove an unnecessary check
  dpaa2-mac: remove a comment regarding pause settings

 drivers/bus/fsl-mc/fsl-mc-bus.c               |   9 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  53 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  13 ++
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  16 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 135 ++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   5 +
 6 files changed, 126 insertions(+), 105 deletions(-)

-- 
2.29.2

