Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE5820D508
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgF2TOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbgF2TNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69011C008742;
        Mon, 29 Jun 2020 01:29:40 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u9so3209957pls.13;
        Mon, 29 Jun 2020 01:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j855cYiSGakl5HlD4KvWXf0FO1kVCBOsIjwxuw77YFY=;
        b=Qt7NBYtjMoTWLro+TnOOtAF4Xut4Vos3hIQ6uZCvtttqOvjE/15HTV1Qy1EOTFeq93
         S+V+eT7ed2ISAJHkug/YDQk6V00THDRnJhoP1B2JuD1Mq++HszZRGphCZAmchWsKyPrH
         +oTUXsOjLHsc4Xeb5gI57u8hju/lB2UWjt/F3+alaVcZ5+7N4cctz+aXXrcH5DRLub8Y
         7aaB/IV8A9oTT9hECIHuCDUuAXAgXqNfHrHq3m8ExHcMM1AMT/jSY9DAAL0AxT1fIALP
         azFzpZZoB+ctyf0c4R18B5TmXmacNW43LW5RA16OnX627iSH+NPPdh8QcVpTk9LYxQxU
         BhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j855cYiSGakl5HlD4KvWXf0FO1kVCBOsIjwxuw77YFY=;
        b=dLxN3EkaUT2DFvTH0HuZlLy8E0LeFGxDFx+BjLyCFQcE3+/mP3MND3OhcVc7/myDOL
         jZnZFzq+oQclrTEF8Qw+D0X8IumZpsXkO+Tf+XdS56fr1mfqKi+cIFxOuua3xr7VT/jt
         CrkeFCYZPRAYd4qtRZRcSjphjtVDJmckancXFz/XDyRtJPB3QIyZtgOR0+EzGCNZiOZq
         aIuI1KVRwJMqA0kHtroxEUYUc3z9Ifm2Q2b676Q/6jFgHMq+nbfyIqp39g4/0GiGRmhk
         ezPbERmKsGhls4en0h7254U5sWZwc+SRpccLKR9H4E6RpTIm1nf0jWoUJpL2vgGNqnyX
         kQ0Q==
X-Gm-Message-State: AOAM532kTqBLlsMCVOGxbFalCsQ/C97Cft32ffs8n9c3ng7sFl7urQzT
        e+Mo1InHYlKp6i49tOWzW6Q=
X-Google-Smtp-Source: ABdhPJwm9mW0Fufp4shSPDWzVwPHl0w3nrVEErBgiMOkUomzsXXC/S8WUFdAwiXgffxdnBn4BOzsyQ==
X-Received: by 2002:a17:902:8342:: with SMTP id z2mr12605998pln.300.1593419379930;
        Mon, 29 Jun 2020 01:29:39 -0700 (PDT)
Received: from varodek.localdomain ([106.210.40.90])
        by smtp.gmail.com with ESMTPSA id 202sm9133790pfw.84.2020.06.29.01.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 01:29:39 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/4] drivers/staging: use generic power management
Date:   Mon, 29 Jun 2020 13:58:15 +0530
Message-Id: <20200629082819.216405-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from amd ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (4):
  qlge/qlge_main.c: use genric power management
  staging/rtl8192e: use generic power management
  rts5208/rtsx.c: use generic power management
  vt6655/device_main.c: use generic power management

 drivers/staging/qlge/qlge_main.c             | 36 +++++---------------
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |  5 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.c   | 26 ++++----------
 drivers/staging/rtl8192e/rtl8192e/rtl_pm.h   |  4 +--
 drivers/staging/rts5208/rtsx.c               | 30 +++++-----------
 drivers/staging/vt6655/device_main.c         | 25 ++++----------
 6 files changed, 36 insertions(+), 90 deletions(-)

-- 
2.27.0

