Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316928863A
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfHIWuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43551 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfHIWuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id w17so16777504qto.10
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCcnNL+FTFxq+gGN3wMsZF6efKCQJKPmsrlE4tC5xvI=;
        b=JubBPvtpE6k1iEMWkzsyOgch7q+ymZaXe2TX452wIHQvxk5LOuzmHG3WsH5uywx+Ml
         9QNHcwH9IECP/HwLcIy2mKxQj46b5AHmAvSSn2kU8dZONHzsdDmy9L67/ZfH0dNuntSe
         kG5btqmc80197iE/NBiunNwnAGj2vBY4Q973A8Hftva8bvJu8teWQfhjHd3X21wg6FjG
         b+PybtSU+gdcMMuAZkF0h+/k/8WdXQqS4L5/WP7TTGP6vl/6qoW3Fy8N95jG//J4QZkA
         5QWthNHv+p1rdq1W7kYG6ktdssP7zA5BhpjILWIDKLN4cU/MgMc/nNGIZVN9e9hW2osB
         gsOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SCcnNL+FTFxq+gGN3wMsZF6efKCQJKPmsrlE4tC5xvI=;
        b=mqyS42QL6qFio+MpFn2xdaBsG9gtKjfhFo0T+SW2O4UyfFYQZlKuM9wO0dulXzWPYi
         Lgo8/Ni34DAh75fAQBAjVaKNL5gbL+7wpMVZl/o9FxkrTBT58STnwc+U7Jr0DXmPxOY1
         SyPWGtPDFHk8JFEojINn808mAfvi5aWAmZo0LE9aVQiABOE9sMAkE2lLs7nr7LyesLva
         zq3MIkV8K8E+lVLTwRtu4tIMcn5fCRXCWPaOmWNy27UZKfHaD0x71sKCjXDkAAci5jDx
         DtIUxID1mFzFVj+BZ54AvGGbPYOQJx4GJ9yzawS+yRU/0hQuK1ouoyhRRaeveAsqAv5U
         FDdg==
X-Gm-Message-State: APjAAAXDtRewWdHdPo5F3Wl0AG/yaSnX5NkpQCKBAvIiHEJh76KGneob
        /Pg169s36SQAG7B9wzJoIVlxXaKo
X-Google-Smtp-Source: APXvYqzjbx8FA7OVSnx0wmG+5tn4UMp2IxR25eeC1sZ+gwY7lENk0S4r6Zz5Kv0U1cMUWgv9w0fkQQ==
X-Received: by 2002:ac8:538b:: with SMTP id x11mr5011353qtp.137.1565391019708;
        Fri, 09 Aug 2019 15:50:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k33sm49753265qte.69.2019.08.09.15.50.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:18 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/7] net: dsa: mv88e6xxx: prepare Wait Bit operation
Date:   Fri,  9 Aug 2019 18:47:52 -0400
Message-Id: <20190809224759.5743-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Remote Management Interface has its own implementation of a Wait
Bit operation, which requires a bit number and a value to wait for.

In order to prepare the introduction of this implementation, rework the
code waiting for bits and masks in mv88e6xxx to match this signature.

This has the benefit to unify the implementation of wait routines while
removing obsolete wait and update functions and also reducing the code.

Vivien Didelot (7):
  net: dsa: mv88e6xxx: wait for 88E6185 PPU disabled
  net: dsa: mv88e6xxx: introduce wait mask routine
  net: dsa: mv88e6xxx: introduce wait bit routine
  net: dsa: mv88e6xxx: wait for AVB Busy bit
  net: dsa: mv88e6xxx: remove wait and update routines
  net: dsa: mv88e6xxx: fix SMI bit checking
  net: dsa: mv88e6xxx: add delay in direct SMI wait

 drivers/net/dsa/mv88e6xxx/chip.c            | 76 ++++++++---------
 drivers/net/dsa/mv88e6xxx/chip.h            |  7 +-
 drivers/net/dsa/mv88e6xxx/global1.c         | 95 ++++++---------------
 drivers/net/dsa/mv88e6xxx/global1.h         |  5 +-
 drivers/net/dsa/mv88e6xxx/global1_atu.c     |  7 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c     |  6 +-
 drivers/net/dsa/mv88e6xxx/global2.c         | 72 +++++++++-------
 drivers/net/dsa/mv88e6xxx/global2.h         | 12 +--
 drivers/net/dsa/mv88e6xxx/global2_avb.c     | 29 ++++++-
 drivers/net/dsa/mv88e6xxx/global2_scratch.c |  3 +-
 drivers/net/dsa/mv88e6xxx/smi.c             |  4 +-
 11 files changed, 155 insertions(+), 161 deletions(-)

-- 
2.22.0

