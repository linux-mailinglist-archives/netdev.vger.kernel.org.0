Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA13000DF
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbhAVJ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbhAVIhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:37:07 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBFC061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:36:26 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l11so2698476plt.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=9yWriwK7EWvY1B0DADj/z9t5RV53wrD6EZpi2cHGNNk=;
        b=kkLoVzDxbBO0oRerAnstdXZ9ifM0A7K8Yrbztb1MatyqH5aoA9KF97HBBEMlBsCArf
         rl1y3LW7Lr26HvVJN8+PhVUmy6afckppcI3+R2z5BXvv8kYWs+dlxVDOtucbTBie2QeP
         U4Fu1CX8/b5zgUZKm2Y+redJG9YFKJKsttjuvJU+M7Tm4dad0g7bWBlV9V1MhV5ZnIWS
         gWKhYSmESRfTk+aJU+LI/vqsS0q6yrcXvWCozMD7DD5oGSjPXONOijx52c27nVgk9Rhg
         hC5cfbTaY9IHd2kVyCA8ryG2dSVxbHQXzkDRC1gLWFeIT18Kr9jvsfctat8fkwCaoCB7
         QMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=9yWriwK7EWvY1B0DADj/z9t5RV53wrD6EZpi2cHGNNk=;
        b=NrlCxR98lIEzjDzOxdzV/bvzNR5VXJxwWieLDw7jQi+2gN2YEF8B3KBcx8bPEwOLc3
         xyfeSV4oVZwo3VcBUy8DhLSfrsmAbDmMoyYEIYIxyqUiVFwvta/ef1XWqEtvfjeM29oe
         Xd2fzzKUNTuZbO4IkJsyNh6M6TgbmHBvHqk404+sHWMz9bH3M5XF9C3LFTBnf1Mnr8r5
         TMdKYGiWO2Sy4qNEY/xKMRyMl5NejZ4w1jqo+9Nrc1wEhqBcCwMRpAspBzR8moAq19CH
         lY9ieJaNk9BY23Gs7fBFylybIE1brf+ovUfrzWazFUll5PB9c1taKhO0fX7/FAEdOVRX
         +kvQ==
X-Gm-Message-State: AOAM532a+TD/bBaY0c2sOaaZv48GAmAEISG0Hm/SKkLxo8y7r55L+c0W
        NSoH9Z0VzgjCPM2hvuUMv5y8tn4fFBIZ
X-Google-Smtp-Source: ABdhPJzrZ8CueWCmlvWFpkaEt7xQ4Y9Krhax6KJBN/wa9NyGEVUmuBDZXCDa7rev4GsucMwnUo5X9yb4p4GT
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:f693:9fff:fef4:2347])
 (user=apusaka job=sendgmr) by 2002:a17:902:ed83:b029:de:84d2:9ce6 with SMTP
 id e3-20020a170902ed83b02900de84d29ce6mr3570976plj.4.1611304586351; Fri, 22
 Jan 2021 00:36:26 -0800 (PST)
Date:   Fri, 22 Jan 2021 16:36:10 +0800
Message-Id: <20210122083617.3163489-1-apusaka@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v6 0/7] MSFT offloading support for advertisement monitor
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

Changes in v6:
* New patch "advmon offload MSFT interleave scanning integration"
* New patch "disable advertisement filters during suspend"

Changes in v5:
* Discard struct flags on msft_data and use it's members directly

Changes in v4:
* Change the logic of merging add_adv_patterns_monitor with rssi
* Aligning variable declaration on mgmt.h
* Replacing the usage of BT_DBG with bt_dev_dbg

Changes in v3:
* Flips the order of rssi and pattern_count on mgmt struct
* Fix return type of msft_remove_monitor

Changes in v2:
* Add a new opcode instead of modifying an existing one
* Also implement the new MGMT opcode and merge the functionality with
  the old one.

Archie Pusaka (6):
  Bluetooth: advmon offload MSFT add rssi support
  Bluetooth: advmon offload MSFT add monitor
  Bluetooth: advmon offload MSFT remove monitor
  Bluetooth: advmon offload MSFT handle controller reset
  Bluetooth: advmon offload MSFT handle filter enablement
  Bluetooth: advmon offload MSFT interleave scanning integration

Howard Chung (1):
  Bluetooth: disable advertisement filters during suspend

 include/net/bluetooth/hci_core.h |  36 ++-
 include/net/bluetooth/mgmt.h     |  16 ++
 net/bluetooth/hci_core.c         | 174 +++++++++---
 net/bluetooth/hci_request.c      |  49 +++-
 net/bluetooth/mgmt.c             | 391 +++++++++++++++++++-------
 net/bluetooth/msft.c             | 460 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.h             |  30 ++
 7 files changed, 1015 insertions(+), 141 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

