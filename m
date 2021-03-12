Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D7E338B3A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhCLLJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhCLLJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:09:15 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97188C061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:14 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 61so1543975wrm.12
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvwdVooEhL1UHLjF9fJJHmRKq3X0NEaOuxkxsIXRcL0=;
        b=ZU/RXORBTEmPN+MuEjxLxYId14OaO3lgdjNHiyjDVQsdw/lmsZ94Yok4/MH5Unh2L8
         5L7KZxhMxSqYANxvLALuwxLhj/vtMRM4xONYfIhoJLSg3Yz2Vo/7NcvnRgeI8GfNG9Kx
         c99h7KkdqflEg7LKwi9rBHTfTaSA14BNAJkE7BxgPYT9asP54im4qJPT8G6X2LYsUZKO
         gxMeet3YcSS4O8AlDkuWyFmwSg4uHjlgw1OSbS5UW7GdCTe5IUw20xQYnY7so2I40Sss
         b71tYF0jJwLJcJMG1PQ7UAR2UvHbO+ppxSLhl3qJAzRDzF5VPI12/LC+owgNIp59Cdr/
         nBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvwdVooEhL1UHLjF9fJJHmRKq3X0NEaOuxkxsIXRcL0=;
        b=OY5IikuaVnXSmpzkiCfk3yMKBDsL0zGogM1Pyr2qcnPG5VpnqoPq0vbgYy691Txt06
         7RzGtcWyvXqtCq71OER3CP8agp6zvldU5PnhRSEEsX+1TwqycTgTpUMpS6PHv46/1mTR
         QK8+iuUJwZQvZlttl+rt+oh6OWbsKfzzU5ULYjhAtoBICza7tMXo91Gg16AdC5QGE1/P
         tfSvzCj+XC3mjEP5Jc+SfP9Mxrmcavasa9PNhda8+S7XHdnslCudPHv20npiIOCwhUEA
         tVDKpbc1BoKy5aWZ8/Zr9xI0CP9+zP0xvugxqZOXzRPMmXmYKisgvcNHGabqVkvku+6X
         aA7A==
X-Gm-Message-State: AOAM531PhWubuNwEuVpoWXBFYZdqPuM6ZvfBFIHUwHR5Q+bDsY6HLXvD
        0+P1jU8WgyErqPIJiNCbtMLEAQ==
X-Google-Smtp-Source: ABdhPJwbDaKFp5e5X0V/bXRF8AiYHu0FEYzo16BK/BKoEPMy/ZL6g02phJIi2GgcTBu0ot/o633wpA==
X-Received: by 2002:adf:cf11:: with SMTP id o17mr13441880wrj.391.1615547353347;
        Fri, 12 Mar 2021 03:09:13 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id b65sm1833255wmh.4.2021.03.12.03.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 03:09:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        IDT-support-1588@lm.renesas.com, Jakub Kicinski <kuba@kernel.org>,
        LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>,
        netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 0/4] Rid W=1 warnings from PTP
Date:   Fri, 12 Mar 2021 11:09:06 +0000
Message-Id: <20210312110910.2221265-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (4):
  ptp_pch: Remove unused function 'pch_ch_control_read()'
  ptp_pch: Move 'pch_*()' prototypes to shared header
  ptp: ptp_clockmatrix: Demote non-kernel-doc header to standard comment
  ptp: ptp_p: Demote non-conformant kernel-doc headers and supply a
    param description

 .../net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |  9 --------
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  1 +
 drivers/ptp/ptp_clockmatrix.c                 |  4 ++--
 drivers/ptp/ptp_pch.c                         | 21 ++++++------------
 include/linux/ptp_pch.h                       | 22 +++++++++++++++++++
 5 files changed, 32 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/ptp_pch.h

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Flavio Suligoi <f.suligoi@asem.it>
Cc: IDT-support-1588@lm.renesas.com
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>
Cc: netdev@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com> (maintainer:PTP HARDWARE CLOCK SUPPORT)
-- 
2.27.0

