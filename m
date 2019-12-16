Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBAA1216F9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbfLPSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:33:00 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41080 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfLPSc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:32:59 -0500
Received: by mail-pg1-f169.google.com with SMTP id x8so4185542pgk.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AE2V3ALFgXnuM4KH/ZGtq5/DYxigrAH1uDhREjWEoI8=;
        b=ga7HUHAX1h4QE3PP6mqth/a/7nM8xOS7P58LS+Vr6bsAetaqL0FSKJtf28oL6P4Fl1
         hq7A3CV5a12ogublSXIppg0lWBlBJvSexXtbKO7E5bxl1mn1kWbq5IWm7gwqd1aSHe22
         ZZABhwTOBJ9xx3xL6Eui5eVxu6NEvPVaIpIan6fmDKk5L72eYrHRc/G2oiZn65F91xVn
         5n68sKMxnFxL/L6d0oriN/oQ8foRY2oZDaKcDYTwx5Tp1NjB1J7h1A/Oy7ZHa2mLJp9x
         2WSUEu6FahP6US6GQ0hAUGCaFceEG7ECWJ+vJni75wenv6V5x+EmtpwOHDsvACSTFYKO
         U/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AE2V3ALFgXnuM4KH/ZGtq5/DYxigrAH1uDhREjWEoI8=;
        b=ex+hf8R0d1iyfsBLWMgc+ZshwpOpenTqZbLT0NwwtNPB6X+MrofYVuS/DB0pv4YL5N
         uYLkYajuWBW0vf65rOlB7b63NTpqxiRetm0fI+f/2Zt7y1NKKAGZbadV5q1Jcz7i3mBY
         0DUWQtIbdwexoFsAeZtLn/Y8YzC6oVPVYNmKYDa99HxoEHdZJmSHYMikSaxg0Zby+d39
         V1x8Z4ciP2Pz7qJh9LltjZj1fdooHcgATAUjcrYwbZ9MWELtOG0CFv9RY/xRPA11QAhO
         tHVbKUS+4Zu2tb1i3Xn8LmssOvFQFkw6wnc5ckthr9U3DHWW3fHeQmZyeEkFvMzM7Nc4
         rMJg==
X-Gm-Message-State: APjAAAUslIW9NOdy0Q+1VFL1Ob6AR+59XWYy+KJIPwOOEFLGvPqlkzzp
        65CcmjWpSWbmclopqdmw37Y3kXDC
X-Google-Smtp-Source: APXvYqzpm1tO/KgYTN/EtAsqiBpvTyeVLZuhDUZVaWNPrNhULgxQYSeE4m5xdH5y7ceHy+W7yGStFg==
X-Received: by 2002:a63:7705:: with SMTP id s5mr19621109pgc.379.1576521178970;
        Mon, 16 Dec 2019 10:32:58 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d65sm23400738pfa.159.2019.12.16.10.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:32:58 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 0/3] net: axienet: Fix random driver issues.
Date:   Mon, 16 Dec 2019 10:32:53 -0800
Message-Id: <cover.1576520432.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on the PTP P2P 1-step series, my hardware under test
just happened to be connected with an axienet MAC.  This series
address three unrelated issues in the driver.

Thanks,
Richard

Richard Cochran (3):
  net: axienet: Propagate registration errors during probe.
  net: axienet: Support software transmit time stamping.
  net: axienet: Pass ioctls to the phy.

 .../net/ethernet/xilinx/xilinx_axienet_main.c | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

-- 
2.20.1

