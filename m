Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1922D3FB632
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhH3Mid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbhH3Mia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:38:30 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BEEC06175F;
        Mon, 30 Aug 2021 05:37:36 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GyqbL1XCbzQkHL;
        Mon, 30 Aug 2021 14:37:34 +0200 (CEST)
Received: from spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125])
        by smtp202.mailbox.org (Postfix) with ESMTP id 279A2271;
        Mon, 30 Aug 2021 14:37:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp202.mailbox.org ([80.241.60.245])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id wikO-nnhKAt4; Mon, 30 Aug 2021 14:37:31 +0200 (CEST)
Received: from suagaze.. (unknown [46.183.103.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp202.mailbox.org (Postfix) with ESMTPSA id 4CEE626F;
        Mon, 30 Aug 2021 14:37:25 +0200 (CEST)
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
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 0/2] mwifiex: Work around firmware bugs on 88W8897 chip
Date:   Mon, 30 Aug 2021 14:37:02 +0200
Message-Id: <20210830123704.221494-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 279A2271
X-Rspamd-UID: 3d0be0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two patches which should fix all the random resets of the Marvell 88W8897 PCIe chip.
The first one works around a bug in the firmware that causes it to crash, the second
one makes us try harder to wake up the firmware before we consider it non-responsive.
More explanations in the commit messages.

Jonas Dreßler (2):
  mwifiex: Use non-posted PCI register writes
  mwifiex: Try waking the firmware until we get an interrupt

 drivers/net/wireless/marvell/mwifiex/pcie.c | 35 +++++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

-- 
2.31.1

