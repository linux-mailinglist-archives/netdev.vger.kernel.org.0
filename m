Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A988B30AB2B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhBAOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBAOtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:49:09 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FDAC061573;
        Mon,  1 Feb 2021 06:48:28 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q7so16835511wre.13;
        Mon, 01 Feb 2021 06:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fSV7S9ysbDArO0wVVJ/L760qy0ZKMMYY7qKcJ4bXASg=;
        b=NMvcKn0HEUeWuO2Nh2T7bN7oCnier3HlOyQxmX36gFISzy5A1hRISoFXxhXG41Glwz
         nyCKOBnDkR/mPI175ayTk63SU888fHS+9zenhHLf9iV+uahAdXpHWzxgESgy7vqPMhzL
         YxmHXLM81vZU3VUE5Lz2vH+3tam0swjq0grD7pvTJsbwTHkemMYgtegr9/4OgjRDnWGk
         JMER9IGs59uhO/vO8V5rdfy31M/dt8koyEtbVu6eH6Fm8tcWixwKml3VMUu0HwC6ZCPu
         hvBPdZtOIkCoHxzUc0qDi2mGldn9WNlG6vBtnirG9x3l42VgB1n0H3ZISnk48sE4ydKO
         RfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fSV7S9ysbDArO0wVVJ/L760qy0ZKMMYY7qKcJ4bXASg=;
        b=Sv8ASsCZDnYbGFhtd7ivfiSqENOk391q9L4Y7WuCiJzwKnKDejgdgapkqcjxYrttr8
         ryDfdbhz+FHAN/BBUvqxEFBMk/TUuR+0T+q6IS6YIyUYN3ADR+83fTKbw2Jgh59d+YGF
         0pr0n/qEdww2BnGBwc+xwGZtepAFQi1+BQXyWcKGEGmyrZpzMoe1vhi3cxjgqwEbgD5v
         FYQ2RfeLP/d8MA4wuNl5yUvQ/T/dfV25gLgZ4wNeE7Ueq2Cxa+HGnI4UO61mOebkdUQ6
         6nsQhG0oJgX1Wuevk4357FlGGUTbGV5zUBm4Jl2rKWNtRMQoUi79z4raFfVysQrBf5wy
         /kwQ==
X-Gm-Message-State: AOAM532pFy7chxXUQ/sKHPG5aGKM65oiszu6ekGGRTxV+lBmjKz4ic6/
        e3oqqwGZsPdKhIODfmKYbLa7CPmFgsRLuX2a
X-Google-Smtp-Source: ABdhPJx91o0WVXygRT9hqeASG5hpzwa30lxI8TeTAWkWjP16VONVs2pQEdbMQCfL/Hk+iqzlMCIvaA==
X-Received: by 2002:a05:6000:104:: with SMTP id o4mr18406472wrx.419.1612190906860;
        Mon, 01 Feb 2021 06:48:26 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id c11sm26106591wrs.28.2021.02.01.06.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:48:26 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 hyperv-next 0/4] Drivers: hv: vmbus: Restrict devices and configurations on 'isolated' guests
Date:   Mon,  1 Feb 2021 15:48:10 +0100
Message-Id: <20210201144814.2701-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v2 [1]:
  - improve/add logging (Michael Kelley)
  - rename 'hypercalls_features' to 'features_b' (Michael Kelley)
  - move VMBus and NVSC version checks after 'for' loop (Michael Kelley)
  - remove/inline helper functions (Michael Kelley)
  - other minor changes (Michael Kelley)

Changes since v1 [2]:
  - improve/add logging (Haiyang Zhang)
  - move NVSC version check after version negotiation (Haiyang Zhang)

[1] https://lkml.kernel.org/r/20210126115641.2527-1-parri.andrea@gmail.com
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

 arch/x86/hyperv/hv_init.c          | 15 ++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h | 15 ++++++++++++
 arch/x86/kernel/cpu/mshyperv.c     |  9 +++++++
 drivers/hv/channel_mgmt.c          | 38 ++++++++++++++++++++++++++++++
 drivers/hv/connection.c            |  7 ++++++
 drivers/net/hyperv/netvsc.c        | 18 ++++++++++++--
 include/asm-generic/hyperv-tlfs.h  |  1 +
 include/asm-generic/mshyperv.h     |  5 ++++
 include/linux/hyperv.h             |  1 +
 9 files changed, 107 insertions(+), 2 deletions(-)

-- 
2.25.1

