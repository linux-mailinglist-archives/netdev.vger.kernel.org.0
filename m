Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19B588C1
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfF0RjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:39:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37153 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0RjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:39:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so1588586pfa.4;
        Thu, 27 Jun 2019 10:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=auhF84ioTrGwSpXvPc/29XrrTlTYdcPUHf41o0X+QVA=;
        b=W/NkPAncjOCMCPyC6MpjNe7fQ/ULUM1JcGoACJN9zrqBIzha/iP+HStc8z8VSrNVnF
         u64rwkD8FO1iIEEbzKEyWRMiMl0Ia/efR1Dy05vTDnPZq0fN5Cxr4N5cc+Il6Qu/XSrk
         qJvhBeUS7wHWet+AZr5Bj1epRN7yeLC1EPZ+V2gNn762NErQFQxXJ7XQHDQ6YHHmt1QH
         gmgkJSw5XoeayLKHutVdvjK9bu7kH8S4rPyskNFEJ1oJj+gJB4sUvPjsiZzKxfZhT1Li
         DA9GdokDyRYkRlPTZiWLijy9KlqwT76r4A6uvEeDsXpw4ES86vQBk1sLakayP3NRCeqQ
         UZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=auhF84ioTrGwSpXvPc/29XrrTlTYdcPUHf41o0X+QVA=;
        b=sntYSSqvjwboKYSv+AkPAuut2ocbInODUAaFjBSzHl/2TvRWYDsdzevIywHAP02IG3
         HuLtykGFO9FZaeus1TJ/TXeBuyx+0YBytB7uqin4nW9S2jxmjOxNnBWAJpiWMqC727Yq
         pb1hvMj+kGqAlKTjMMJgkHlScdf4ZpXJkUfclmTlSwiAwoHXtd+88omz7kXMOl4VKiuD
         RVbujhLGvlkO49K1gxWmZcdYzWuX09DInin4SVLxJMgO+OU8egq63PnGBJ+xLzQtBrF+
         qFaOlBDQqISo+BLzcQ4iN8ay42jQ1mV8AYp+In7w+TGHmClVIiZrXfWt/O2pJIl3+Cuv
         0C1Q==
X-Gm-Message-State: APjAAAU7jAZqWDe/dV/V8XoXZ2+rFhY6VQ4PU9vHk8VOAcciwIXpaYOC
        MZMhZziVHNST5kQpuVfmZy4=
X-Google-Smtp-Source: APXvYqxq2x55to6zcMrwiyt0+tQ5rLXtq0cpx2NGlrkySpS86CLSlx7SB6xi/XXqarqsYg7gsTwzcQ==
X-Received: by 2002:a63:c006:: with SMTP id h6mr4725873pgg.285.1561657161470;
        Thu, 27 Jun 2019 10:39:21 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id m20sm5758388pjn.16.2019.06.27.10.39.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:39:21 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 36/87] net: eql.c: replace kmalloc and memset with kzalloc
Date:   Fri, 28 Jun 2019 01:39:14 +0800
Message-Id: <20190627173916.3729-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmalloc + memset(0) -> kzalloc

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/eql.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 74263f8efe1a..2f101a6036e6 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -419,14 +419,13 @@ static int eql_enslave(struct net_device *master_dev, slaving_request_t __user *
 	if ((master_dev->flags & IFF_UP) == IFF_UP) {
 		/* slave is not a master & not already a slave: */
 		if (!eql_is_master(slave_dev) && !eql_is_slave(slave_dev)) {
-			slave_t *s = kmalloc(sizeof(*s), GFP_KERNEL);
+			slave_t *s = kzalloc(sizeof(*s), GFP_KERNEL);
 			equalizer_t *eql = netdev_priv(master_dev);
 			int ret;
 
 			if (!s)
 				return -ENOMEM;
 
-			memset(s, 0, sizeof(*s));
 			s->dev = slave_dev;
 			s->priority = srq.priority;
 			s->priority_bps = srq.priority;
-- 
2.11.0

