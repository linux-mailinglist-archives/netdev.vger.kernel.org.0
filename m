Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB0DF5E6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfJUTVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:21:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35899 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUTVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:21:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id w18so14736060wrt.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jEImIYBaJ/ojWpXslDKs7XjM98LgNqmmSeww7LbGanM=;
        b=dLY1nlyYuuJeBcxWJ3HcqxDIwszDqqammh16rufMlDvKQgdalTMpbI1TZs6PDNc7sA
         DMjskNclDdFmlZMuYaqgFnxzMbDG4Tza+VaCqCm+Y7Tn6/ZXUZ6P8kjB/FH7ixpaXxeY
         gqYlKArL6rCb3RKK6de/4y6xVxDymVDu4jrjLY1Wb3hKJ+MVkqXSmmTCns7yGmafY/Vr
         wAciJgw9yLgrKOIXc7Z+T7iY2YeEXh92NZwcQ+eq9O2+QcoF/QWKYpqC9bBVLp7C1xHQ
         R65JWbgHF5D0ryahmpTBZdIhYV2Wl+cEmb5bGYkrfs1wy5xYjMFfJ99F8Ga0IBUKdogF
         HfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jEImIYBaJ/ojWpXslDKs7XjM98LgNqmmSeww7LbGanM=;
        b=m50VBIVnRwx1zFeVspL9mosHKGYnv/+RqDURa5Snzeav1KWku8W9OdKovchfJrdJUy
         QiR34mjiXv+RiLXxkM5FDDp4/fRlTNIGLTuqhj+Ct2BJKh8w0lywoSK1Ae2Eom4DkEOZ
         VIM36t2n9s/34RNXsjiK8Qc087Jdh+I3LylSQUG9te8wkmJ3YUD2aog1Iw8YhfjOxle8
         eaQGuDOhEdVa+B+Wevy+xJAa/Zx09+LqSjJs7xZjIbNhtcL2TeNNEZ9O5hwoU47+Ayu/
         UTeY85vTR+dxFWZ8Bp+uHToWObmXUGT4OIbXrenokF6KKvlV/6GZr0MhdFZqH+ynpuvp
         Swzg==
X-Gm-Message-State: APjAAAVv7GP61lsIwXCLz6iNhNItOrV2bVTx12UamraBpnAp5NI7xhoK
        +UwhsEE9IhQmr5YeqzYJ1TGO8KAB
X-Google-Smtp-Source: APXvYqwExOuI8gonbWa0sdiW6x/i+b/1pAAPpp/8IpP2/6+oV6x/oUdmKjB/P+brGW23ki7XrbrIhA==
X-Received: by 2002:adf:9381:: with SMTP id 1mr5678066wrp.10.1571685694701;
        Mon, 21 Oct 2019 12:21:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1cea:5bb:1373:bc70? (p200300EA8F2664001CEA05BB1373BC70.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1cea:5bb:1373:bc70])
        by smtp.googlemail.com with ESMTPSA id a71sm14895218wme.11.2019.10.21.12.21.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 12:21:34 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: remove fiddling with the PCIe max read
 request size
Message-ID: <c4f2e4fc-9cbe-2ba1-b0b2-1e734032b550@gmail.com>
Date:   Mon, 21 Oct 2019 21:21:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The attempt to improve performance by changing the PCIe max read request
size was added in the vendor driver more than 10 years back and copied
to r8169 driver. In the vendor driver this has been removed long ago.
Obviously it had no effect, also in my tests I didn't see any
difference. Typically the max payload size is less than 512 bytes
anyway, and the PCI core takes care that the maximum supported value
is set. So let's remove fiddling with PCIe max read request size from
r8169 too. This change allows to simplify the driver in the subsequent
three patches of this series.

Heiner Kallweit (4):
  r8169: remove fiddling with the PCIe max read request size
  r8169: simplify setting PCI_EXP_DEVCTL_NOSNOOP_EN
  r8169: remove rtl_hw_start_8168dp
  r8169: remove rtl_hw_start_8168bef

 drivers/net/ethernet/realtek/r8169_main.c | 90 ++++-------------------
 1 file changed, 15 insertions(+), 75 deletions(-)

-- 
2.23.0

