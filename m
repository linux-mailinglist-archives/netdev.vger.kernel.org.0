Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45A92FBF70
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 19:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbhASStL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391743AbhASR7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:59:39 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DE6C061573;
        Tue, 19 Jan 2021 09:58:59 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e15so581563wme.0;
        Tue, 19 Jan 2021 09:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ud39rUOwi9a+eDdinAxLAEakzSkS3TdE+RD/bhNorzQ=;
        b=VXR7vmWGIj2jjxYIWeOws2Wl7U9SiEVahWjLU/e+0eN82PYKaoRniIiDIRK7msShQ0
         TBfAjeteW6riRRxAoQrjol1Z6EUC/OjkammyFdgHunOCrZtHA2/S6gDYFPSGopFWjlWD
         glIrEMHhg+sYx/tZy/MByl3pxJr2XDyca5U6qecQ1fxzE4VbsVInnwY68Cy3NeeBetN/
         9o4sKysDN9draRqQv1uBTFPEB8XXm+9dllwXobePv0iuIlgVkSFYjY6Ds/ssTN7xfL/U
         58ts6kr6GPaC4gKFgM5/Li01b/rMBs7Fkqrpp0/rQojH4NAGkbMsjrn9ZPgWSxc4g3yd
         Rrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ud39rUOwi9a+eDdinAxLAEakzSkS3TdE+RD/bhNorzQ=;
        b=BW9amq7I1zUq+i6ZaJzxa6EtekYENN5TFsyYHbsvB0w3VeXHNKvqhBDIVBot9GfGzK
         6WBwyCVxS6YcBFwsbolgry4SQuy9KUXhguTCFOCc6CeTZu1IoWhKzc4hfSDueNDyMgBH
         wcaQQ/2mB2W3jdy6FdNnRqDSGGEDE47hgZulMBKz2thOsQg6RHoU5deDILyyW+1Rj5G8
         22pgJ3Azj7EB28P0qyHoBZ17j3otdiZi8raA4YCuk7/c9cH8TJa4tURNVqAWFNvaksc7
         9TjzzdKQPXBdY4ljmB9IcBR68duI0xdnXNyqKIeUXIT99W95VwYLE2iUmD1m8HiGP8ai
         KZcA==
X-Gm-Message-State: AOAM5336rHo/LXhbzlFLETMeW98zj5bkG1XO5Yxef33EeudffoavmtBn
        0HYhHFTr36FMhdJtMZNte5hC6VIFA/OTPnva
X-Google-Smtp-Source: ABdhPJxJX9Y5y3EIyEHi9aNLRaU90KBI2X7LlLhhRsr/PehD6xzCuAqiAzYfgdq2RgPg9LZ6ZsBpSg==
X-Received: by 2002:a05:600c:3548:: with SMTP id i8mr747653wmq.104.1611079137762;
        Tue, 19 Jan 2021 09:58:57 -0800 (PST)
Received: from anparri.mshome.net (host-79-50-177-118.retail.telecomitalia.it. [79.50.177.118])
        by smtp.gmail.com with ESMTPSA id h125sm5899312wmh.16.2021.01.19.09.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 09:58:57 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] Drivers: hv: vmbus: Restrict devices and configurations on 'isolated' guests
Date:   Tue, 19 Jan 2021 18:58:37 +0100
Message-Id: <20210119175841.22248-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

To reduce the footprint of the code that will be exercised, and hence
the exposure to bugs and vulnerabilities, restrict configurations and
devices on 'isolated' VMs.

Specs of the Isolation Configuration leaf (cf. patch #1) were derived
from internal discussions with the Hyper-V team and, AFAICT, they are
not publicly available yet.

The series has some minor/naming conflict with on-going work aimed at
enabling SNP VMs on Hyper-V[1]; such conflicts can be addressed later
at the right time.

Applies to hyperv-next.

Thanks,
  Andrea

[1] https://github.com/lantianyu/linux # cvm

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
 drivers/net/hyperv/netvsc.c        | 21 ++++++++++++++---
 include/asm-generic/hyperv-tlfs.h  |  1 +
 include/asm-generic/mshyperv.h     |  5 +++++
 include/linux/hyperv.h             |  1 +
 9 files changed, 113 insertions(+), 3 deletions(-)

-- 
2.25.1

