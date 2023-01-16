Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F1A66D381
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjAPX7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbjAPX65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:58:57 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05732C671;
        Mon, 16 Jan 2023 15:57:19 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id az20so52440504ejc.1;
        Mon, 16 Jan 2023 15:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mn+TZUXea4ISuZCwWMz5SSZVUJSxpv6JVqPqn/L6G5M=;
        b=U97bLxJThXvIz9tGZ+qMWg8UXddRRY1eBK0/0IWmL0sXDyDEjS5p6dr0kCSg/gKySQ
         x4JZnqgHpZStIp/H8TOg5Mae2JHIp5gCyTh0J0jIZOGcm2inJOL7Qc/+VH9WG95l5lGH
         L0eKkporSCTYBabLopH2cgnG13pmjhCCOwerlF53q1FwrpDwrw63KWv3qi+6xZcLYSle
         10COldlck6Kean6mHn6Nrxo2nsQ3o0aoqW+hzxUc+G91Jf+3aOG604ncC5OVA59glMhB
         esx7b5WSymKRdgIzhqwbR+d9xf1up7kvIELcN0RKq+mPhAH8aVVkXkrhBnsMwZRJFbds
         RqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mn+TZUXea4ISuZCwWMz5SSZVUJSxpv6JVqPqn/L6G5M=;
        b=pNLLai2ngzUOXPws/GzbdHWVWWcswhFtEDXs8MCtKGRRExzOpYaIEwcJwbEPQ95Lf+
         gPpyUKpPujR4LmrWrLLFuImqDNB/yQ1OzWyzBgTzfaN5a7OGYL62Fhso9lERjZA8l2rS
         4hIT2d6EgfDxeRsQMfJgPwxdvp1WdvRZeN8b7RTHwGkyYwisM/+pzEEUYLO+GfSwuEgV
         /z5Tmofm+Jxe0tRHLJtTCPoaoPCUsypyqXdYdV5nI8ZLldq5DLh5KG+Y5uHJZzLRbafw
         Risvk1f71KYSoCLiofHSzjUApL5p/ZVyTKeireN9hoD3EEW+uvTAj6nSbHcMKheWVqU4
         aACQ==
X-Gm-Message-State: AFqh2kpSbJSM5HFp5IaRKUI5J4kF2IHK5ZNVjdWzxsVfpcfhZTKcpETr
        dUP/SVw5XE2EkPtxS0V2qoE=
X-Google-Smtp-Source: AMrXdXtV6tBOAXyQOr2MEm/mdNgG5OctwB/I+nbsufizNM1KwTgiunat/WxOnNXiFt3Q0eNoulaalw==
X-Received: by 2002:a17:906:2403:b0:84d:3e5b:7c02 with SMTP id z3-20020a170906240300b0084d3e5b7c02mr13239483eja.22.1673913438279;
        Mon, 16 Jan 2023 15:57:18 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id lb21-20020a170907785500b0084c4657120fsm12455873ejc.55.2023.01.16.15.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 15:57:17 -0800 (PST)
Date:   Tue, 17 Jan 2023 00:57:19 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH net-next 1/1] ethtool/plca: fix potential NULL pointer access
Message-ID: <6bb97c2304d9ab499c2831855f6bf3f6ee2b8676.1673913385.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix problem found by syzbot dereferencing a device pointer.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Reported-by: syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com
Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
---
 net/ethtool/plca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index be7404dc9ef2..bc3d31f99998 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -155,6 +155,8 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 
 	dev = req_info.dev;
+	if(!dev)
+		return -ENODEV;
 
 	rtnl_lock();
 
-- 
2.37.4

