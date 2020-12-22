Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19F2E085F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgLVJ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLVJ5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 04:57:52 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B195CC0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id g7so1023833pji.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=+PiUI/UiQbF9tJBJK96eDrL17o++1KL7PgCvTzmBZ1Q=;
        b=QQjknT1yjaO8Ymz4i+nIS5U0T3OGO0/+li5Uo8TJHOLmFqz9x/rml1jTFWKk97S+QX
         SB26zAyDGVnU7xIot3GvK1ohUPvYvpWHYp1K2+27qgDPXIGW4j7vhDOWv66xTK8kJL1l
         WeOFlCKQ8ByKIxwEGoj6mAV4d4EwgunHXeSDhkx/TUFCCmmuEMh+6F10NbkNmrd8nRmt
         XTnco/etbS2WTr5wQUdvMWk2Rorh0DiqJU/mfCByvRpkocGJKHc92hYOqVS4aYcmlZ/M
         UrTbp4Qda1MX5vUwbJqnR37bS5dyiPiYw+FyvhkapsfI1ff3CE7Tn2zoBHzybzKW4VhR
         NAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=+PiUI/UiQbF9tJBJK96eDrL17o++1KL7PgCvTzmBZ1Q=;
        b=n3CBkMFveKBwrRn0e3NLNQFn3SBRL1WYYeR9nkv5kAr5Y7WLzbkYe65HbH1hORX4Tg
         avQu8Jodwyxq4XCD6ZGTmVdtgRw02BEpfrFm3phJeb1LU+/bNYvHN8UvDlUSmsDPnx3u
         fKokm2nFmiFRmK6T16NnfoOtzi20UHcbbbOkcRVdDPREzFW+idP/6weo9zAm9oXvqLF4
         IAIIVoQvRdkqbclIE8lHd1Lqr17/pCTFmgyq+YzF639PsD4UoUED1dQHQ05X3bdwqv3N
         dyMebX4oj3UxYyTjtfsVYvFr1v7gxXMcVJNf//9x3rQpDzxr+O5KMglQuZ0kUGDBMWHH
         SPYw==
X-Gm-Message-State: AOAM532Ghj3YsScZ017RZZYFC3I4Hf8OLN/ua1JSLj2ykuKKmOvfqOuz
        +YCjbfSREC6FCRd2SEY8TeUXSVWXXe3I
X-Google-Smtp-Source: ABdhPJy6YIKBoUzqa4dj0Di/jQjquvSWfkFIN7aG4+FTabLpWfmGkZfVvAmwYn8V+3/aKyd7lJRAIvoQm7VR
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:a17:90a:1706:: with SMTP id
 z6mr3077627pjd.0.1608631031794; Tue, 22 Dec 2020 01:57:11 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:57:01 +0800
Message-Id: <20201222095706.948827-1-apusaka@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v4 0/5] MSFT offloading support for advertisement monitor
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

Archie Pusaka (5):
  Bluetooth: advmon offload MSFT add rssi support
  Bluetooth: advmon offload MSFT add monitor
  Bluetooth: advmon offload MSFT remove monitor
  Bluetooth: advmon offload MSFT handle controller reset
  Bluetooth: advmon offload MSFT handle filter enablement

 include/net/bluetooth/hci_core.h |  34 ++-
 include/net/bluetooth/mgmt.h     |  16 ++
 net/bluetooth/hci_core.c         | 174 +++++++++---
 net/bluetooth/mgmt.c             | 391 +++++++++++++++++++-------
 net/bluetooth/msft.c             | 456 ++++++++++++++++++++++++++++++-
 net/bluetooth/msft.h             |  27 ++
 6 files changed, 966 insertions(+), 132 deletions(-)

-- 
2.29.2.729.g45daf8777d-goog

