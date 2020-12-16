Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E42DBA14
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 05:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgLPEeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 23:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPEeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 23:34:21 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831BCC06179C
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 20:33:41 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id u8so11868117qvm.5
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 20:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=6HUv5xBPfwv697/YWNrZvCYxuhXudwcF4fT9FoZkAj4=;
        b=GmyxLUYdRz9+qga62iB6VIcK1jnoR5/TAbHFy9VUjQtjHaJx/uUyS5DMypsnLs/cBX
         dzdEt4JLhaZ8fccclYkvDInRiBrG+OIQqEA8LRQPu+1b5MKPfeEMOICrIGRT9rS0qIEG
         tPBb3rdkfEbpdHA/ptKfMD/M8jBz1UD6/40/P3Kbd5Iv5mRkSY3ao9nRwxfYr0B1p241
         J365D4IKT2W5gaqmXpDQudeLgd0BJSgy9+RtAseAR/GHdYhjXmCj4f9KElkUO5fKbmTq
         uTXkgzsHBkQ1vhiWYdEHzMRNWyk/HdhmUwG3NxdLzzQtgEPhGQuefCV1HRkHwdoqeAhE
         oO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=6HUv5xBPfwv697/YWNrZvCYxuhXudwcF4fT9FoZkAj4=;
        b=KNJgzp9Nii1d2trgTzM+UeWGM3E3SU+eFp8Pb77t0j0iysGdI6zSPXAOKe1n65UQJA
         p3Ivj+/ppl4zNyLAX4/W5hsslRV524FwBm1YLNEeWIq2oQR1F0dpa6pOxMztZq73mqt9
         YL2Hze4/1YTk8WO6KiLihEFfQkT57cJ5q2TeWeq2h9U5yCsMKeD4zyZZaRaYb7TNnIZX
         Rp9ppE5L46SwbN1fHtEOZIPCSNQZyQQcrZotvPAQsDQJlU9G0wbr4VAQDzNloRAjhhZg
         qdE8yy5uWNl4cXOl1qJapI53J1ewxFjz983JF4Vug038yXlG7FDo6vS1nXG9pJKEQsac
         D9qw==
X-Gm-Message-State: AOAM530hmpGquqB5RTKICfE+7JOdUkd+yvHPYv5lWRH68eyeb+4bmSMi
        +DijE16sf4MP6GxS6p9om93ArODgzFty
X-Google-Smtp-Source: ABdhPJzrIlUctDldqUAWGAIaZEe64YkVK+9nRfWWqMetOJ/7CR7627hcwImixzIAnRQZrAjKfSSoAVt26J0K
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a0c:f38a:: with SMTP id
 i10mr41879713qvk.32.1608093220706; Tue, 15 Dec 2020 20:33:40 -0800 (PST)
Date:   Wed, 16 Dec 2020 12:33:30 +0800
Message-Id: <20201216043335.2185278-1-apusaka@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH v3 0/5] MSFT offloading support for advertisement monitor
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>


Hi linux-bluetooth,

This series of patches manages the hardware offloading part of MSFT
extension API. The full documentation can be accessed by this link:
https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/microsoft-defined-bluetooth-hci-commands-and-events

Only four of the HCI commands are planned to be implemented:
HCI_VS_MSFT_Read_Supported_Features (implemented in previous patch),
HCI_VS_MSFT_LE_Monitor_Advertisement,
HCI_VS_MSFT_LE_Cancel_Monitor_Advertisement, and
HCI_VS_MSFT_LE_Set_Advertisement_Filter_Enable.
These are the commands which would be used for advertisement monitor
feature. Only if the controller supports the MSFT extension would
these commands be sent. Otherwise, software-based monitoring would be
performed in the user space instead.

Thanks in advance for your feedback!

Archie

Changes in v3:
* Flips the order of rssi and pattern_count on mgmt struct
* Fix return type of msft_remove_monitor

Changes in v2:
* Add a new opcode instead of modifying an existing one
* Also implement the new MGMT opcode and merge the functionality with
  the old one.

Archie Pusaka (5):
  Bluetooth: advmon offload MSFT add rssi support
  Bluetooth: advmon offload MSFT add monitor
  Bluetooth: advmon offload MSFT remove monitor
  Bluetooth: advmon offload MSFT handle controller reset
  Bluetooth: advmon offload MSFT handle filter enablement

 include/net/bluetooth/hci_core.h |  34 ++-
 include/net/bluetooth/mgmt.h     |  16 ++
 net/bluetooth/hci_core.c         | 173 +++++++++---
 net/bluetooth/mgmt.c             | 333 ++++++++++++++++------
 net/bluetooth/msft.c             | 456 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.h             |  27 ++
 6 files changed, 919 insertions(+), 120 deletions(-)

-- 
2.29.2.684.gfbc64c5ab5-goog

