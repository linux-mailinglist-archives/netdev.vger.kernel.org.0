Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAA44FBD66
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346597AbiDKNlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343598AbiDKNlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EB21E15
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:56 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z17so2182729lfj.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=15O42YcTjpmDhDPvSQqOizS3ABZbH38ENN7jhBTnn4Q=;
        b=IaBb4jkSWIxICG3VJbssykTGz95G7zDiifz0RBjL7GZ0tpIylTl8B5PNRmMO5lYyW9
         u4I8tQzRMFBFmViPiEgTzX9uNrJ0bvNsnj9b6BxHtlJnbk6D/3daKgMX+7/zPJ9688lV
         UXkLUnEF2gFdok5cQjofcP4nnSwFnnoI+P+WEUmEjDG2/byd8dBjrlFJjcKhvr32ZbY5
         KB3pT6TLB8YBzk/xlcdHO/I0xOZtmpYImmemgxjl48DHu5Sk7WeWYbpTz/1IQiKiimzG
         mSROXfhet++r3kzANHZrmtF51DKjmziKgj1dg8TOPZeE8u7wm/G65hAMbS7VVbMX3uGv
         E3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=15O42YcTjpmDhDPvSQqOizS3ABZbH38ENN7jhBTnn4Q=;
        b=4711b+JTvhC5nkqv+sFSOGIjdtA2XCSUJfNJyxEhP6EI50nSApSy9xdJO57anCQPRW
         1FLb26Kmo2+BBCUmC6s1CuRFu4I5Hp9gZ0UIN+3BgVIVmhLFXGlgiMU4HSIpqz7xZW3c
         25XWPxXXhVfRI5jwN/f52mD/4y74FjqhUkHi8uoG8clYesBW27HOnJGniyVVs8DXecO7
         BwI/Ex/PTJWYN8LkRJDm8ArK6Qw8zYPAweRYVdqm2PfNdrHHFXWUhis2afLrNWvdidxb
         ZrRSQWDVnao1RlHChD7fkdvE3pz1Rn7B5JdbS6fuff7y6XVva67dZEgFUwaXRGb3pMcO
         aM3g==
X-Gm-Message-State: AOAM530CCaYz9vUyusIg2mUQk+z4bdIiGKVEgUC/+yT9MPoU3p60alT7
        bZtIjZjRj725bpujA7pwtis=
X-Google-Smtp-Source: ABdhPJwVX0p4K8mGxFlbxBh0ugRbtpmk0aqkD7A7QNIJgZPtnwRRD6Kal5WfasVud0lNUC7kiIzQ2g==
X-Received: by 2002:a05:6512:3402:b0:448:c29:ce8a with SMTP id i2-20020a056512340200b004480c29ce8amr22242644lfr.633.1649684335092;
        Mon, 11 Apr 2022 06:38:55 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:54 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 03/13] net: bridge: minor refactor of br_setlink() for readability
Date:   Mon, 11 Apr 2022 15:38:27 +0200
Message-Id: <20220411133837.318876-4-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411133837.318876-1-troglobit@gmail.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The br_setlink() function extracts the struct net_bridge pointer a bit
sloppy.  It's easy to interpret the code wrong.  This patch attempts to
clear things up a bit.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 net/bridge/br_netlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7fca8ff13ec7..8f4297287b32 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1040,6 +1040,8 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 		return 0;
 
 	p = br_port_get_rtnl(dev);
+	if (p)
+		br = p->br;
 	/* We want to accept dev as bridge itself if the AF_SPEC
 	 * is set to see if someone is setting vlan info on the bridge
 	 */
@@ -1055,17 +1057,17 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 			if (err)
 				return err;
 
-			spin_lock_bh(&p->br->lock);
+			spin_lock_bh(&br->lock);
 			err = br_setport(p, tb, extack);
-			spin_unlock_bh(&p->br->lock);
+			spin_unlock_bh(&br->lock);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
 				return -EINVAL;
 
-			spin_lock_bh(&p->br->lock);
+			spin_lock_bh(&br->lock);
 			err = br_set_port_state(p, nla_get_u8(protinfo));
-			spin_unlock_bh(&p->br->lock);
+			spin_unlock_bh(&br->lock);
 		}
 		if (err)
 			goto out;
-- 
2.25.1

