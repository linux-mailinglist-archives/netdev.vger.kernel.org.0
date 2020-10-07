Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB80C285CE9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgJGKdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgJGKdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:33:19 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2DBC061755;
        Wed,  7 Oct 2020 03:33:19 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x5so784821plo.6;
        Wed, 07 Oct 2020 03:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M3tlMfmcucV1zILBhUWjczI44sbzhxfScjMFqTyVtfk=;
        b=V+EdZXdh3WXACskuSFWkEslHjaSHeOyHbk5urn/r6LtXMAVWt5lHUfWDAQ0zytZZbh
         3L7WJljVGd0/Xc+DeHhhuG+lUm9HOp2CdIAZjGFbuXdagsdgN34Eao261w6gGsvBu8j6
         ZwM3ZRljE7XLwIFk+omAq5veIGzMBmavDBlsPbRlHk3vWZhnWwYtIhEPGXvLqI1Fd4sf
         oylEgrJZx9gxKaHRrEziQZvP6UNQT0mQL24Y7TeflKMD4n8EmfG8B6bMJBgqo8TTfMdN
         Tx9V1brSvAgnn+Fkzpf5ncgS+bygkG0p8Sbasn/yXIiu5rWlGl/cjocgjZM1MFXDexWc
         33rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M3tlMfmcucV1zILBhUWjczI44sbzhxfScjMFqTyVtfk=;
        b=BcWcaj5PAHGnK2E+7sf8qA48R/jq7OsRKwKuBbGYKyrLhjZQxNymuAf2G0ttQDLAJV
         lr3w5NCLus2uyfjtWIrEKQgZHj1H6D+caM48z4nlabRIrtlv56W6gz5YJEnQuQZRklAb
         uv710G3YJfCeL2zgOnhD8xFyQFYLC5OWCRxPPwEYKWiH7LxKhv5u8zQFDs8ukmMOcXJU
         WcycAsD1cUrUFfCiupj3d5AC2Q47DdMOFFX51dDKm5LJA4BhV5pUM2gquefal6JVdhct
         qOUYLneRmBen4mOQHUD3VXmlQViquiDM8jaltDP5Zt1wkiI0mqZaSLd7ujUtaSMLa0VM
         PkwQ==
X-Gm-Message-State: AOAM533NO/eMo5RHTmYdLb/DduTq/eYr3GxjxBCyCejAwfXJXZFxP7//
        S82Yh9t6nLXHwC/0vokkwK4=
X-Google-Smtp-Source: ABdhPJwE6r0kuIjeK1ca92N4FWqvoEAr6NMSoJPQLDSm8giSzgJoYOAMJSkBaHhQlUB4kpvEe4HyqA==
X-Received: by 2002:a17:902:74c6:b029:d3:b3bd:22c3 with SMTP id f6-20020a17090274c6b02900d3b3bd22c3mr2370640plt.52.1602066798863;
        Wed, 07 Oct 2020 03:33:18 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id v129sm2705327pfc.76.2020.10.07.03.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:33:17 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kuba@kernel.org, matthias.bgg@gmail.com,
        ath11k@lists.infradead.org, linux-mediatek@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>
Subject: [PATCH v2 0/3] wireless: convert tasklets to use new
Date:   Wed,  7 Oct 2020 16:03:06 +0530
Message-Id: <20201007103309.363737-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

This series converts the remaining drivers to use new
tasklet_setup() API.

The patches are based on wireless-drivers-next (c2568c8c9e63)

v2:
  Split mt76 and mt7601u

Allen Pais (3):
  wireless: mt76: convert tasklets to use new tasklet_setup() API
  wireless: mt7601u: convert tasklets to use new tasklet_setup() API
  ath11k: convert tasklets to use new tasklet_setup() API

 drivers/net/wireless/ath/ath11k/pci.c              |  7 +++----
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  7 +++----
 drivers/net/wireless/mediatek/mt76/usb.c           |  6 +++---
 drivers/net/wireless/mediatek/mt7601u/dma.c        | 12 ++++++------
 9 files changed, 27 insertions(+), 30 deletions(-)

-- 
2.25.1

