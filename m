Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6050F428DFE
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhJKNew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235280AbhJKNev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:34:51 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE351C061570;
        Mon, 11 Oct 2021 06:32:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HSfqf6rPMzQkFS;
        Mon, 11 Oct 2021 15:32:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH v3 0/2] mwifiex: Work around firmware bugs on 88W8897 chip
Date:   Mon, 11 Oct 2021 15:32:22 +0200
Message-Id: <20211011133224.15561-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E32518B7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third revision of this patch, here's v1 and v2:
v1: https://lore.kernel.org/linux-wireless/20210830123704.221494-1-verdre@v0yd.nl/
v2: https://lore.kernel.org/linux-wireless/20210914114813.15404-1-verdre@v0yd.nl/

Changes between v2 and v3:
 - Use consistent terminology (PCIe, USB)
 - Read a generic register (PCI_VENDOR_ID) in the first patch since it's not 
 the actual readback that fixes the crash. I decided against using usleep()
 because reading a register has proven to work on lots of devices for a few 
 months now, and usleep() only appears to work when a certain duration is used.
 - Use read_poll_timeout() for wakeup patch

Jonas Dreßler (2):
  mwifiex: Read a PCI register after writing the TX ring write pointer
  mwifiex: Try waking the firmware until we get an interrupt

 drivers/net/wireless/marvell/mwifiex/pcie.c | 36 ++++++++++++++++++---
 1 file changed, 31 insertions(+), 5 deletions(-)

-- 
2.31.1

