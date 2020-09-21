Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1061E2718E8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIUBJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIUBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCE0C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:19 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mm21so6523774pjb.4
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=n+Oe6sScDUie4jnpgTlgThyR9EmhYEy4r0sUjo6BJMY=;
        b=GOAwujVL+LGE/elsY0+ln1txdALx7Iv0I8RPXCiH45PLAe/TDQwBJHymnAUwHvJfX2
         kIGgsbPtTo5frxJ5e9n/XaRaS3NBJjIMdqp94FAz9eipmHvUgTRtr6Br0lH/VlH5nPnD
         n7Wn4rvFQpgk4MbLZTVUhBcMiYtG5ItDUCcCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n+Oe6sScDUie4jnpgTlgThyR9EmhYEy4r0sUjo6BJMY=;
        b=nVM1rTo05g39bbVONDFdmlr9ODKw9RxM6ClB+MxD3Ab4NmwFK8J4yME9CynwN0kmif
         ASvepMQAv8wJV+X6SOw6k3VuvtT5LhfCVWbZ0obUVTgY3+osnc/Kdo7jNBMRgiqwet6B
         3OGMbuRak7ESMgdEL+iPImKd6TSPs6xKgAzLMFrK+I+Ax1TEnzqCFq12iCJgB4+rZqJH
         3AVKTzVn8t51Mc1VG8PBvUdWuHVBUgzwtSsHo2+S9Uqvuuiom+K3ZA5n+mi0gG11BHKa
         K1OIPThgxZSC/KwRXX4XVTkXKZkfDFrPKc3Fd6lN65LX1bkYb9oqUgmRlqZrwCX+TZcv
         iprg==
X-Gm-Message-State: AOAM532I/h/59/Pcmf5UvKal15rJRrJ56vToBOLi2EaTEWgbbPOmT08x
        G6fdqwj8RCT3jJTco3OjZLn5Aw==
X-Google-Smtp-Source: ABdhPJyhxisT1KP05kVGCxHZhnlu7YQRwIvjW1UPJTii1pZK68xcTD0P00HeAeM27rP576jDmxUQcw==
X-Received: by 2002:a17:90b:1050:: with SMTP id gq16mr23612887pjb.234.1600650558921;
        Sun, 20 Sep 2020 18:09:18 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/6] bnxt_en: Bug fixes.
Date:   Sun, 20 Sep 2020 21:08:53 -0400
Message-Id: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A series of small driver fixes covering VPD length logic,
ethtool_get_regs on VF, hwmon temperature error handling,
mutex locking for EEE and pause ethtool settings, and
parameters for statistics related firmware calls.

Please queue patches 1, 2, and 3 for -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: return proper error codes in bnxt_show_temp

Michael Chan (3):
  bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.
  bnxt_en: Fix HWRM_FUNC_QSTATS_EXT firmware call.
  bnxt_en: Fix wrong flag value passed to HWRM_PORT_QSTATS_EXT fw call.

Vasundhara Volam (2):
  bnxt_en: Use memcpy to copy VPD field info.
  bnxt_en: Return -EOPNOTSUPP for ETHTOOL_GREGS on VFs.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 30 +++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 34 +++++++++++++++--------
 2 files changed, 43 insertions(+), 21 deletions(-)

-- 
1.8.3.1
