Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372DA40ACC6
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhINLuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhINLtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:49:55 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79889C061574;
        Tue, 14 Sep 2021 04:48:37 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4H81nv4nfSzQlRK;
        Tue, 14 Sep 2021 13:48:35 +0200 (CEST)
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
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 0/2] mwifiex: Work around firmware bugs on 88W8897 chip
Date:   Tue, 14 Sep 2021 13:48:11 +0200
Message-Id: <20210914114813.15404-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C163426B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second revision of the patch, the first one is here:
https://lore.kernel.org/linux-wireless/20210830123704.221494-1-verdre@v0yd.nl/

Changes between v1 and v2:
 - Only read-back the register write to the TX ring write pointer, not all writes
 - Mention firmware version in commit message+code comment for future reference
 - Use -EIO return value in second patch
 - Use definitions for waiting intervals in second patch

Jonas Dreßler (2):
  mwifiex: Use non-posted PCI write when setting TX ring write pointer
  mwifiex: Try waking the firmware until we get an interrupt

 drivers/net/wireless/marvell/mwifiex/pcie.c | 59 +++++++++++++++++----
 1 file changed, 50 insertions(+), 9 deletions(-)

-- 
2.31.1

