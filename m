Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8FC29D95E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389667AbgJ1Www (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389661AbgJ1WwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:52:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CDAC0613CF;
        Wed, 28 Oct 2020 15:52:18 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b3so704591pfo.2;
        Wed, 28 Oct 2020 15:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9z7nf3iE3DVZP0WPzpkB3Zwoy/sQUmA3X8ME/pi67sI=;
        b=ppteg6JKr0pjKgONQssRt0HAQWyJw2bu7oSNHpWMOkZsh7dEmlcSlq19UAnf/sq7N+
         coLyCYQVlq4MVyevXYh1VeiOGTphkrORLJJLCBiUOQ7ph0L9wfZ7B+l+89XFA/P2ZfZ5
         huvtLBO7e6JjrfZIJwcd3hxaGDAz5Y3f6NTiql0JGAkLpwlVPDA6dPJPcwXSrxPK6C/h
         urg3GXTkvUiPRO03ZlQnLFzciQONMjZ+wFbn2izXzP2X3Wp4CKBztotkScO9L5iIR6vm
         lEAXaMAyhSSgqeeQHg2sSjX8BAXA3ugqUTLl4HjAtngdUDktCeHXSNWiKoEjVlZ+lLAA
         /IbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9z7nf3iE3DVZP0WPzpkB3Zwoy/sQUmA3X8ME/pi67sI=;
        b=IUsyP5d21rpPv2Dilw3YMrIulQ01RvAw7VYhwslqDbattOpv3VLlEKgui3/5yqV0aS
         WvJ4h9eKx8DK24sNXs7fh1eXcNSjlOs1dkl3dNfg2SqY+TctJT5fIpKQInLokPy2/U5y
         tQJOc09idQwP17Y28cbzod7XShJxPrJhwKDHrV5CR3hA3mCNLn6Abh6Ox80soejWHZPW
         +gPiqQFKUzzghmwaQ5EnC38psBvIcec/DUU/Z5mGgZKqNvOV2QSutuU35GJE63dBSjM+
         ZciK7aGsmfrNlaLyOT52ZzEznK5DGZ1+92MZD7j+iNKk66Ti4f+UXfsOY08jNIzIFekb
         JjjA==
X-Gm-Message-State: AOAM533YS2aKCBdyG+SO68huYmvcgAI7+LxyQfImffbRQSyBJyNtC5mW
        kfnPdezsOOxGVKyXmw/64d5z+gveCMVme/iZ
X-Google-Smtp-Source: ABdhPJwJjxAgXIoa0STM/ctwl7XKN2S3gD84U7QhhkcFnwc7CDFwCV4T2G8m0Y5UdmU11KUiKrLc0w==
X-Received: by 2002:a63:6647:: with SMTP id a68mr6577284pgc.7.1603895298860;
        Wed, 28 Oct 2020 07:28:18 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g67sm6581754pfb.9.2020.10.28.07.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:28:18 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [RFC PATCH 0/3] mwifiex: add fw reset quirks for Microsoft Surface
Date:   Wed, 28 Oct 2020 23:27:50 +0900
Message-Id: <20201028142753.18855-1-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

This series adds firmware reset quirks for Microsoft Surface devices
(PCIe-88W8897). Surface devices somehow requires quirks to reset the
firmware. Otherwise, current mwifiex driver can reset only software level.
This is not enough to recover from a bad state.

To do so, in the first patch, I added a DMI-based quirk implementation
for Surface devices that use mwifiex chip.

The required quirk is different by generation. Surface gen3 devices
(Surface 3 and Surface Pro 3) require a quirk that calls _DSM method
(the third patch).
Note that Surface Pro 3 is not yet supported because of the difference
between Surface 3. On Surface 3, the wifi card will be immediately
removed/reprobed after the _DSM call. On the other hand, Surface Pro 3
doesn't. Need to remove/reprobe wifi card ourselves. This behavior makes
the support difficult.

Surface gen4+ devices (Surface Pro 4 and later) require a quirk that
puts wifi into D3cold before FLR.

While here, created new files for quirks (mwifiex/pcie_quirks.c and
mwifiex/pcie_quirks.h) because the changes are a little bit too big to
add into pcie.c.

Thanks,
Tsuchiya Yuto

Tsuchiya Yuto (3):
  mwifiex: pcie: add DMI-based quirk impl for Surface devices
  mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices
  mwifiex: pcie: add reset_wsid quirk for Surface 3

 drivers/net/wireless/marvell/mwifiex/Makefile |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  21 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h   |   2 +
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 246 ++++++++++++++++++
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  17 ++
 5 files changed, 287 insertions(+)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/pcie_quirks.h

-- 
2.29.1

