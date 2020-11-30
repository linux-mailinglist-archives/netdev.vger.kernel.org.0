Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39DD2C7C15
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgK3AW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK3AW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:22:29 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64502C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x24so9300395pfn.6
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHE3MnGYM/Sus2I6XXyDiRr3ihXDgZYgaHWOCaOo/OM=;
        b=TYwlO6Vbra4A8HhbLv/FiheDJG0jM6QVCMLhMB13KTwCUIRa0bdUsv0ydkAvECOtJD
         ieD7iCOf//QyaHw7s6f4WIdhNkkcgwtQav+/rXHuh859iRDKlZyOcpkFVgbp508WYENk
         iXydlBDTsxijGN0O62gwnljrAAQ8mUfO1n6TwqZypI5Q2XcOZbVBeG1zly6FNPuPMgCE
         4sCg9GirA9RuxebXLcgAO3fgdO2Ja9Hu2h1wu5uIANfD23Xx1be0FYTlsfw18njZ2kwa
         +oX8VBU6Ms/lA0pmv90/J2m8HeUCtvwPzMeuNtIiKbxQrK3DgygNJoG6sfAlVOxXhQzJ
         gdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yHE3MnGYM/Sus2I6XXyDiRr3ihXDgZYgaHWOCaOo/OM=;
        b=VTy+xXnKfT7bSDaaSZwnpcADaq+M6WVyVLtaO5LULrM+eNT1X/pknaDGUhBMKEUlXE
         bcvzZJfgri6PuNXJ6e36uwi7/hzwz0l3Lt3XEcsP6W8DyJM0+kpA83MlP93lDvVcMW6O
         JqLyl6OXZLj4HzWP481lzWWQcdLQqPTJX/K1FqBh6j74laY6YKGI0fMtht0BVy3VjMFy
         3fO3zVaR2uiZgGeqE1BH5BMCSS9XCTWuPV/V8q8nc+rV3jZKlT9AV4nImd3TMKg1OpNv
         DQQBGeWzPi2OrDaUo8kyXsZhfUTVKM6tD2nRbm7y7EuU9rDYxZedg6IFVh/Ne3a6Rz3D
         BodQ==
X-Gm-Message-State: AOAM530f4iCDJFcxMNY2lWnDcAQbClRfmRNDTUQ536kl9uY2gWPPtZTX
        dnvMnTiRiGyuWGLujaQ14wuvgX9YzHp5FZ08
X-Google-Smtp-Source: ABdhPJzsgibIYRnWlA+YWcevBE263UcAjCOqrFALRoafna04bwk6MP9vFRIDr6Pe4a5Fei8DipwnSg==
X-Received: by 2002:aa7:9798:0:b029:197:e5a1:9202 with SMTP id o24-20020aa797980000b0290197e5a19202mr16105279pfp.16.1606695708307;
        Sun, 29 Nov 2020 16:21:48 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d3sm20746129pji.26.2020.11.29.16.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 16:21:47 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 0/5] Fix compiler warnings from GCC-10
Date:   Sun, 29 Nov 2020 16:21:30 -0800
Message-Id: <20201130002135.6537-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to GCC-10 and it starts warning about some new things.

Stephen Hemminger (5):
  devlink: fix uninitialized warning
  bridge: fix string length warning
  tc: fix compiler warnings in ip6 pedit
  misc: fix compiler warning in ifstat and nstat
  f_u32: fix compiler gcc-10 compiler warning

 devlink/devlink.c  | 2 +-
 ip/iplink_bridge.c | 2 +-
 misc/ifstat.c      | 2 +-
 misc/nstat.c       | 3 +--
 tc/f_u32.c         | 2 +-
 tc/p_ip6.c         | 2 +-
 6 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.29.2

