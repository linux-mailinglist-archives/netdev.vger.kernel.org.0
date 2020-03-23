Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCF218F03E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgCWH2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:28:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42081 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgCWH2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:28:33 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so6750162pgs.9
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 00:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NFyWVs+kduv2j1R2/60e64VqrdzsP1HRwFGN/XYNDZo=;
        b=LILNAYyQ8szwFEkmyAgot0buT6BbWuPaMeqDEzmHEOA82yWb/7h8Q1ltu1+n4qIVYR
         O2Syb3UEtgrn7LHNXVqQ8SQP+A6KGKhI/dmNJPdCV3I9w9RtZ+Kwtt4abirzJXyz0Kxg
         i5i1XGp0OXMn/kN8stG1yga7zw/nZMIFMjc5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NFyWVs+kduv2j1R2/60e64VqrdzsP1HRwFGN/XYNDZo=;
        b=ezrq0bCmqOR86XUGbffQ90ugb1uVFT0Mu5AtaUYwN+fOlj/gNH6oxLmUI4T6cdUd8z
         tQohsx+pSTjinXaOcsOmY9ZOCSnh8o0o9ElP45hRk1Dea0sZdpWAnArqPyblXE/23GR1
         Dx9TSLJruxE00tJYOLK0rLAykc1VvtS5niVo5ko1gema/1XSlzA+WCqxP0W+00c2FoTv
         1i0+rV2RGbms5niVftCDW7Fb+K6jRAeDRB6YLqTQuMRFbIMM3Rxow2efTSLVXbjc6OzD
         HMWo2r/s9MueUiqCW6KkCg+rLRxp9DnHTZxyg0qpvhD+m6vzv7xMh8pd17mvFaETZCCH
         nh5Q==
X-Gm-Message-State: ANhLgQ02q9EWnquII3XRmgxxLXEvhOgLWoHGY65ZThkZ8lNcg6AtstqC
        TM8V7ExKH3OJSzRcq+e2pW/1nQ==
X-Google-Smtp-Source: ADFU+vvfZ+qhit8yI7fVEav4nHdqfpAwVAeCiMKsf3LZMu/WqYHyCiYaU+G01pALbh0CUrK9KNHGHw==
X-Received: by 2002:a63:3d48:: with SMTP id k69mr19784007pga.395.1584948511935;
        Mon, 23 Mar 2020 00:28:31 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id z16sm12645399pfr.138.2020.03.23.00.28.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Mar 2020 00:28:31 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 0/2] btusb: Introduce the use of vendor extension(s)
Date:   Mon, 23 Mar 2020 00:28:22 -0700
Message-Id: <20200323072824.254495-1-mcchou@chromium.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel and Luiz,

The standard HCI does not provide commands/events regarding to
advertisement monitoring with content filter while there are few vendors
providing this feature. Chrome OS BT would like to introduce the use of
vendor specific features where Microsoft vendor extension is targeted at
this moment.

Chrome OS BT would like to utilize Microsoft vendor extension's
advertisement monitoring feature which is not yet a part of standard
Bluetooth specification. This series introduces the driver information for
Microsoft vendor extension, and this was verified with kernel 4.4 on Atlas
Chromebook.

Thanks
Miao

Changes in v1:
- Add a bit mask of driver_info for Microsoft vendor extension.
- Indicates the support of Microsoft vendor extension for Intel
9460/9560 and 9160/9260.
- Add fields to struct hci_dev to facilitate the support of Microsoft
vendor extension.
- Add vendor_hci.h to facilitate opcodes and packet structures of vendor
extension(s).
- Add opcode for the HCI_VS_MSFT_Read_Supported_Features command from
Microsoft vendor extension.
- Issue a HCI_VS_MSFT_Read_Supported_Features command upon
hci_dev_do_open and save the return values.

Miao-chen Chou (2):
  Bluetooth: btusb: Indicate Microsoft vendor extension for Intel
    9460/9560 and 9160/9260
  Bluetooth: btusb: Read the supported features of Microsoft vendor
    extension

 drivers/bluetooth/btusb.c          | 18 +++++++++--
 include/net/bluetooth/hci.h        |  2 ++
 include/net/bluetooth/hci_core.h   |  5 +++
 include/net/bluetooth/vendor_hci.h | 51 ++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c           | 30 ++++++++++++++++++
 net/bluetooth/hci_event.c          | 49 +++++++++++++++++++++++++++-
 6 files changed, 152 insertions(+), 3 deletions(-)
 create mode 100644 include/net/bluetooth/vendor_hci.h

-- 
2.24.1

