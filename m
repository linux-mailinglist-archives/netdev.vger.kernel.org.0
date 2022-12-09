Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302D86480B8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiLIKNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLIKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:13:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F8B3056E
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 02:13:26 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so3336645pfu.8
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 02:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dvj5nqno/VZBpHkgx99lJTs/RMXmDHM2ly4VNPratRM=;
        b=FA9zDBB9i5uOhNrW6g8OiXDUdSCT5bKdMLR83mdvq7wmMqKIrzKMuuU8pvyR2LUiNU
         xmTZ0gaG/DmyRGjJeylmZVOj7tke6ibsdHhAlQ+xy4kQ86ezlj8xktoXrUWRxAg1ccfL
         pbdXnVnI8HyXnn4V/mByQGrrCk0R9A87Te1FDNfswjNUWG1bZJkmTU9xlJ0Ttx0SUyCW
         XqxqXUsoa51pDr2HYI/W5SSnjISn6K7KKanYkT4jwq7u+aHRyH8bz6bD5K+P1UF3Eml5
         x3gQ4f+XjqvPPFujDKA8NH2fmrT4MBHHDS+vjJaGxfO6Ymhz/Z05yBSTeyWLyuMxED30
         hWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dvj5nqno/VZBpHkgx99lJTs/RMXmDHM2ly4VNPratRM=;
        b=hX7I63WHP1JJzFMbGQbqO0QZnm4y98y9+6ynLq/2iaywQV7eK4dY4jEnKtWRxHOrpI
         uHAGwPzKWac+oI/GK+iw9OVZ+gEG1u4F+9jec6EhbauMjYuHGRB/kjroDaTYfcTreLmc
         3GWYWvUL64LbdcCPcq8ksBbk0H1DfzBAMtkuBa0n/aaU5Ok2iauL1zs4Md2jKwZVRLL/
         bqEwilhkAC8bAE/Cl9N3gkJr8cIYm8U56pjCaJZ9dyaZYploa7rI4/E1w1IK8Rq1GLmS
         WuP7i6hMLnh9ifR9nPCoukawr3VZEGtFt10pGWZwOZYXDaPMjrXffkBKtgghiq/DtNWn
         ddGg==
X-Gm-Message-State: ANoB5pmVJ7hI1Yq22SoRlwxPOMfQlSnxADbQ71VPmdSu4oTQgwneRSs3
        y2rrqtEbhEcF88seHbNTvnJQ7g0zlbJbqsdv
X-Google-Smtp-Source: AA0mqf7iVWdUDhuOyHAlI0GIspKXcLensalGSfBCuT+iLHSo3DzN5wmjMBS7p0OnwRU5tLwLPJWTaA==
X-Received: by 2002:aa7:9297:0:b0:573:f869:2115 with SMTP id j23-20020aa79297000000b00573f8692115mr4150700pfa.9.1670580805305;
        Fri, 09 Dec 2022 02:13:25 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g204-20020a6252d5000000b00561d79f1064sm936677pfb.57.2022.12.09.02.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 02:13:24 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/3] bonding: do failover when high prio link up
Date:   Fri,  9 Dec 2022 18:13:04 +0800
Message-Id: <20221209101305.713073-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209101305.713073-1-liuhangbin@gmail.com>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a high prio link enslaved, or when current link down,
the high prio port could be selected. But when high prio link up, the
new active slave reselection is not triggered. Fix it by checking link's
prio when getting up.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 0a2ff7cc8ad4 ("Bonding: add per-port priority for failover re-selection")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2b6cc4dbb70e..dc6af790ff1e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2689,7 +2689,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
+			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary ||
+			    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
 				goto do_failover;
 
 			continue;
@@ -3550,7 +3551,8 @@ static void bond_ab_arp_commit(struct bonding *bond)
 				slave_info(bond->dev, slave->dev, "link status definitely up\n");
 
 				if (!rtnl_dereference(bond->curr_active_slave) ||
-				    slave == rtnl_dereference(bond->primary_slave))
+				    slave == rtnl_dereference(bond->primary_slave) ||
+				    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
 					goto do_failover;
 
 			}
-- 
2.38.1

