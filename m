Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04F73CBF9C
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 01:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhGPXMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 19:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbhGPXMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 19:12:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E59FC06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 16:09:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l11-20020a056902072bb029055ab4873f4cso14614347ybt.22
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 16:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MtUgzD2/WYvbSaEharU0rB1o+hrog1m/ATn3TqgC1ws=;
        b=AlC0VsCh+EpGFGPi9Tarv0CaBJyPbSXdGdyB1MiYbQIq+6cS5vXgd3PArOllCOoLdx
         ZCatZgAGtBHYYWJFG+jurTDk6yK5LUtc8uX0vI+DjnbX1haNtXS2JJtu2bEL/pLrqC+2
         rUm1haD0Kh+HufU0jO0cFyWSdrGAUY+ytqncxiWs6C/awGrouyYfDCutKQ3Gy/Cp73fZ
         0oqGQtxCCr9EIV4cLB1b/rOVadWu3naMBGufZzAnA3Q7R4QAsrycg3jhMvtpLi/GAufv
         MlM/47SrEkcv8C9g9qHtVGQQ1bqW7wZEUhP5iu72ByUcqZcKsZWlslwRqFpdqZCHsNx8
         RYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MtUgzD2/WYvbSaEharU0rB1o+hrog1m/ATn3TqgC1ws=;
        b=dphh3OBXhM4mNpRvQwHeQCRjkMZN6PTJEXKYNBtQMysCBG38+ABSJ80hweTlR3YwAF
         zaMI2znMe7aP3MpDsDd1fiQCcGBIXTbo49sD5upYlu/BlhYBtEPQI4ZPeII8C+jQRMjw
         o/h4iiCI6WzpvS60eIpi59N0HRI1SSidkKRyE7mb/BTWaghg2TFRHQH3Le6S0BPCNdc+
         r5/MDnItJ3YbmFFYhdNRMNuMhnBjJ0HbXserWwS1CgwblWh8edoUHb8nYYTtJkOgOtGv
         RoDHHa678iTzWnZicf6fCQUmmin9qBFdiGvTCV5zjLNobEzSEWiOpXwQA7rQ9ZfFcmWB
         3S6g==
X-Gm-Message-State: AOAM531026fNWovrgaXvbyVFOUR6SQLFBL5SNlOXUjdSae4f90bM03m+
        BZJfnADCMqApPp25t/q7VHCHWtCgMLLdhtj60vUS8MoBY3R/u+WrAoMWfP0VXtLqOl636Op71eh
        RQxfYWeOw1B+cF4OfTGr/PSC+jz9mtknOlLf5TUP1lVzjS7kxhkFeN3NXoS7zaIJe
X-Google-Smtp-Source: ABdhPJzlva3SnO8WtpEbeoHp3RQx5ayzhV9BBXcPP3SQsGDGtv9/1MGpp2+INP+vwD0DtLenR8IErGW/NHNX
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:b8a5:3f7a:3a1d:f67b])
 (user=maheshb job=sendgmr) by 2002:a25:b3c9:: with SMTP id
 x9mr15825742ybf.514.1626476991924; Fri, 16 Jul 2021 16:09:51 -0700 (PDT)
Date:   Fri, 16 Jul 2021 16:09:41 -0700
Message-Id: <20210716230941.2502248-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH next] bonding: fix build issue
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 9a5605505d9c (" bonding: Add struct bond_ipesc to manage SA") is causing
following build error when XFRM is not selected in kernel config.

lld: error: undefined symbol: xfrm_dev_state_flush
>>> referenced by bond_main.c:3453 (drivers/net/bonding/bond_main.c:3453)
>>>               net/bonding/bond_main.o:(bond_netdev_event) in archive drivers/built-in.a

Fixes: 9a5605505d9c (" bonding: Add struct bond_ipesc to manage SA")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
CC: Taehee Yoo <ap420073@gmail.com>
CC: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d22d78303311..31730efa7538 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3450,7 +3450,9 @@ static int bond_master_netdev_event(unsigned long event,
 		return bond_event_changename(event_bond);
 	case NETDEV_UNREGISTER:
 		bond_remove_proc_entry(event_bond);
+#ifdef CONFIG_XFRM_OFFLOAD
 		xfrm_dev_state_flush(dev_net(bond_dev), bond_dev, true);
+#endif /* CONFIG_XFRM_OFFLOAD */
 		break;
 	case NETDEV_REGISTER:
 		bond_create_proc_entry(event_bond);
-- 
2.32.0.402.g57bb445576-goog

