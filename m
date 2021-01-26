Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F16B303C4D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405344AbhAZL6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405079AbhAZL5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:57:54 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7BAC06174A;
        Tue, 26 Jan 2021 03:57:06 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i9so2517477wmq.1;
        Tue, 26 Jan 2021 03:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bC1xZCmdZ+IRgftlF79fVLCQMAhOapBGa0B/um1CcO8=;
        b=NvLuiFaNEsDhP1ZT0XPyH0ZKdRAsqatHGT5unjbajWjdArRkVDJVOK62L8+MNYZaqW
         ldu05rKhXRBtGlL4Az5POr82yGwm34tbWZ9UHGXmTB3bC6AzbbLIlqiZ4/L54/6+4fUX
         IYC9WPWKNOyCffsVRWDF3A5tN8acJt6m1pTsS47ER1JX6kCgHeUHHIKyhoOR1XVSVMZc
         siTtM4OBn+or7zkXn4pT2u+vMXAwsC7viaHq9bYco+ytZ5lCW9+fnLY7KZZPVZMDu75C
         JY5jT3Xb+jfFmG6AsueC050KJxcZv63tj6ufNyjUkKrffTPpQM6i5iEJJvhh6M7nbEfu
         yXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bC1xZCmdZ+IRgftlF79fVLCQMAhOapBGa0B/um1CcO8=;
        b=TUJM54xfwBIQXRQKqpULdZCZsfEfxk61604TBzdguf1OXR71bXHCHJD9hto5//zpMu
         MEN1+F4JKqBTk38TPckrK+vsjpHHylI+J+upQdv4bc1Sd76KdhutkLBVzGGcFXs+K1Mq
         BqBxBIR9M0i1IMsMXIx7kKLmAwy8kH6pdg7ndmn033DJ4lJaNpKMEyzPlNYDVpok9yCG
         ZQXHBkhWDvBwmmLuUdne05RkcybWclIdQE5AKMzTFBvvrt9ookhwFCO5VC9j8xoJJ6U6
         jQum9jXKB6VhpFps8kXtZ5XOj7mWyXe4ydg5ca+D0FaY5qS9CEF8rSPcn/UC0+BrQbVb
         WbDQ==
X-Gm-Message-State: AOAM533lReK9EzcVTH5CjYSYP4EgA+d5UJVHXt9ay+jgJbuBOfmdiI8r
        aunldcwyJ0XHsGcOeaVJxRpwx2okq9Slo+dc
X-Google-Smtp-Source: ABdhPJxAGmp/2Q5U5eZgPzQBNLYgAVOsmF0XfLf4kQKtFcTGrEYhjftqslWZDJ2Pry78yUQ6ZA5CXw==
X-Received: by 2002:a1c:4984:: with SMTP id w126mr4262426wma.139.1611662224976;
        Tue, 26 Jan 2021 03:57:04 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id z185sm3330283wmb.0.2021.01.26.03.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:57:04 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/4] Drivers: hv: vmbus: Restrict devices and configurations on 'isolated' guests
Date:   Tue, 26 Jan 2021 12:56:37 +0100
Message-Id: <20210126115641.2527-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1 [1]:
  - improve/add logging (Haiyang Zhang)
  - move NVSC version check after version negotiation (Haiyang Zhang)

[1] https://lkml.kernel.org/r/20210119175841.22248-1-parri.andrea@gmail.com

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: x86@kernel.org
Cc: linux-arch@vger.kernel.org
Cc: netdev@vger.kernel.org

Andrea Parri (Microsoft) (4):
  x86/hyperv: Load/save the Isolation Configuration leaf
  Drivers: hv: vmbus: Restrict vmbus_devices on isolated guests
  Drivers: hv: vmbus: Enforce 'VMBus version >= 5.2' on isolated guests
  hv_netvsc: Restrict configurations on isolated guests

 arch/x86/hyperv/hv_init.c          | 15 +++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h | 15 +++++++++++++
 arch/x86/kernel/cpu/mshyperv.c     |  9 ++++++++
 drivers/hv/channel_mgmt.c          | 36 ++++++++++++++++++++++++++++++
 drivers/hv/connection.c            | 13 +++++++++++
 drivers/net/hyperv/netvsc.c        | 27 +++++++++++++++++++---
 include/asm-generic/hyperv-tlfs.h  |  1 +
 include/asm-generic/mshyperv.h     |  5 +++++
 include/linux/hyperv.h             |  1 +
 9 files changed, 119 insertions(+), 3 deletions(-)

-- 
2.25.1

