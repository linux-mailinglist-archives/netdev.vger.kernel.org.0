Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A22196444
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgC1Hqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:46:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46882 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgC1Hqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 03:46:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id q3so5708062pff.13
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 00:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsG3mjoVQ6835V+LXB4rVT3ot36vnEeHGFhncinMhdA=;
        b=VjQ0CshLJQbW1OwcdZX1NZjvxFeSQzXrsvpZQFFM1VP2dKDuGT+DzfnfXO6u4TBurn
         KaIP/vnOgPQiFZTXXXA5ILxpLx/dzbLpUuJggfqUMrJBv7YlQnSbilQutT9tkPde73qJ
         zt+1ax0md7zdT5GoXQWDPU0bpriRHY6/NCZL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qsG3mjoVQ6835V+LXB4rVT3ot36vnEeHGFhncinMhdA=;
        b=GZRraN8l0XNtmztuPfVKTgR0So+1dA/WMFifRGw3WoacvzW5NGMJzdtHnmDQJ/wEFG
         PU3LJjhYi67UgLYpucf1QsYR7wFgFtdaLUJJFdAQmUL9kbzk9h50uKS4uHcbd03t3TcJ
         /3Y2tU+G714J/XlK0K+rLPIho03hR7Dor3zDPSGoqo2sFStm7DhdwQsn45GB+NkLnQjr
         WhhlxGKW0S/p/tKR5A2J3Jas79yiaE3N5IxGm2gswDDSS//W6mF64sGPvnq9Sx80f+ld
         29d78IY71uvKi0SIcFbvLURYM0SBUF7mC9CB3OUlfbTGOIN0SvsMiHjAM7kdV/AfPyQE
         /ypQ==
X-Gm-Message-State: ANhLgQ3cCCoCY9bH+igAZB1VkzSoGvAdIHzMqCtqowBrrrdJE8aKzxQT
        kZ4ksPlOcOUt0Os4IqPA1bz9cg==
X-Google-Smtp-Source: ADFU+vtoIu3hHGgwa06Ycafmb1nm7HZG845zxuGysiu+6cukyK5HWsT0OpxxANr6d98B8iKt2h05yQ==
X-Received: by 2002:a63:7451:: with SMTP id e17mr3165418pgn.234.1585381600923;
        Sat, 28 Mar 2020 00:46:40 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id r59sm5273063pjb.45.2020.03.28.00.46.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 00:46:39 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 0/2] btusb: Introduce the use of vendor extension(s)
Date:   Sat, 28 Mar 2020 00:46:30 -0700
Message-Id: <20200328074632.21907-1-mcchou@chromium.org>
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

Changes in v4:
- Introduce CONFIG_BT_MSFTEXT as a starting point of providing a
framework to use Microsoft extension
- Create include/net/bluetooth/msft.h and net/bluetooth/msft.c to
facilitate functions of Microsoft extension.
- Move MSFT's do_open() and do_close() from net/bluetooth/hci_core.c to
net/bluetooth/msft.c.
- Other than msft opcode, define struct msft_data to host the rest of
information of Microsoft extension and leave a void* pointing to a
msft_data in struct hci_dev.

Changes in v3:
- Create net/bluetooth/msft.c with struct msft_vnd_ext defined internally
and change the hdev->msft_ext field to void*.
- Define and expose msft_vnd_ext_set_opcode() for btusb use.
- Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev().
- Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().

Changes in v2:
- Define struct msft_vnd_ext and add a field of this type to struct
hci_dev to facilitate the support of Microsoft vendor extension.
- Issue a HCI_VS_MSFT_Read_Supported_Features command with
__hci_cmd_sync() instead of constructing a request.

Miao-chen Chou (2):
  Bluetooth: btusb: Indicate Microsoft vendor extension for Intel
    9460/9560 and 9160/9260
  Bluetooth: btusb: Read the supported features of Microsoft vendor
    extension

 drivers/bluetooth/btusb.c        |  11 ++-
 include/net/bluetooth/hci_core.h |   5 ++
 net/bluetooth/Kconfig            |   9 +-
 net/bluetooth/Makefile           |   1 +
 net/bluetooth/hci_core.c         |   5 ++
 net/bluetooth/hci_event.c        |   5 ++
 net/bluetooth/msft.c             | 142 +++++++++++++++++++++++++++++++
 net/bluetooth/msft.h             |  29 +++++++
 8 files changed, 204 insertions(+), 3 deletions(-)
 create mode 100644 net/bluetooth/msft.c
 create mode 100644 net/bluetooth/msft.h

-- 
2.24.1

