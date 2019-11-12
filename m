Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0653F9C2E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKLVYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:24:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51282 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbfKLVXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:23:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id q70so4848439wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=S1Noa1Cd+h42BlDqlSNu1VAvjW0x+zDljww87qOk7nI=;
        b=Y4dzJ161A6y0kfP3HujCwegByTDMv/o9cB4301YT4ntxK9pgsYYaDu+acHgq0IyUEJ
         eOx5uSqDA+2XjgwX9BP3vaa8F5ntUEhObUW5WgC83Bl6AhPwHKSSxv1dpNIxRpb7vh7K
         CqxFp/NKta8KB4RGz9Zw/94su+ngz98kLbC92/eqR8HmFViCj2leCDm9icbIFdQjMli6
         E6yBYZUssTM/ZOjvSfT5YZbFH5TkbkoxFtPg4RcQsy0mC+VKC235N5uUt1g1J3tVGVum
         nKpN+yfc4o9OsOQmm00YyXFbH6wRNgEt38DGlMxevKwEhlSye19N+N42nFBq/2nZrwsd
         oZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=S1Noa1Cd+h42BlDqlSNu1VAvjW0x+zDljww87qOk7nI=;
        b=Rn+CGAV6i5v9Je8bvrhaEt+fIG2uwBwu+jVNe476KdtgcBqQ61wvS3Kk1gN8TeDG0N
         AKI6wt93Az9ATjJzmQMM3BB/N5IXUtoEE8TPMEtXQRx7xfzmq0cWJhJxXnaYQFNAgBPa
         PuOTGUIdcCjGziQesuXymsR2b2f7kYf50Ij8VqNnrv/BPFL/1FD7YA5trDZgEUfXUN0/
         fkkLtrGY8mQANSzqE+NKf096Ql9dD9Ijd1E1A4AADuCJEFO4+ET/tA2CPxtj4k3kZltq
         m9M+XEO9NUvP1C05LvvePdy4mnZ3kwPngsy6rIesYvxeaL6HLzVLGStmrZP4QYt/eCCJ
         XcFQ==
X-Gm-Message-State: APjAAAUJ9L7p+Ay5KMZQvgh5ts9exu3+E7oxQq9+pgMT+WEOBNwJEaI/
        nNMFCveAleQV8nNwbdUINnoDeX1I
X-Google-Smtp-Source: APXvYqzqfpOUuLHs0Ol6KROyvetrdb6NzwXBBM3pdMTrpkb8+JxMiDmckKnwEZYDnLJXeQlHzE30Zw==
X-Received: by 2002:a1c:113:: with SMTP id 19mr6280932wmb.42.1573593785904;
        Tue, 12 Nov 2019 13:23:05 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:7:bfb7:2ee9:e19? (p200300EA8F2D7D000007BFB72EE90E19.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:7:bfb7:2ee9:e19])
        by smtp.googlemail.com with ESMTPSA id t185sm6952386wmf.45.2019.11.12.13.23.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:23:05 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] r8169: use rtl821x_modify_extpage exported from
 Realtek PHY driver
Message-ID: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Date:   Tue, 12 Nov 2019 22:22:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain Realtek PHY's support a proprietary "extended page" access mode
that is used in the Realtek PHY driver and in r8169 network driver.
Let's implement it properly in the Realtek PHY driver and export it for
use in other drivers like r8169.

Heiner Kallweit (3):
  net: phy: realtek: export rtl821x_modify_extpage
  r8169: use rtl821x_modify_extpage
  r8169: consider new hard dependency on REALTEK_PHY

 drivers/net/ethernet/realtek/Kconfig      |  3 +-
 drivers/net/ethernet/realtek/r8169_main.c | 41 +++++++++--------------
 drivers/net/phy/realtek.c                 | 36 ++++++++++++--------
 include/linux/realtek_phy.h               |  8 +++++
 4 files changed, 46 insertions(+), 42 deletions(-)
 create mode 100644 include/linux/realtek_phy.h

-- 
2.24.0

