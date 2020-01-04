Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E012C12FFB0
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 01:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgADAhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 19:37:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39870 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbgADAhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 19:37:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id 20so9983310wmj.4
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 16:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SOsAZalITvFAxZNqziY/vX4tGkH13Bi0d82iGbIiYRc=;
        b=IUojLsD9Dwk8U3HAP09O63aeZsaMouybmLIYYshAOTY2/o47aND0zBIMlQdI5+qsph
         ghyQHs/CoKJTbr/VM3zNmAFVDTdc2StvD1PQvnDRlWozhylOYMvDWQbss9X/pcAEXFaT
         WRhiS+rreH7cbzzNReJ5dFFqBTMlQ3NNl0my8GCC0U7nFx8tH5s7Skr7pg+m65aMxzze
         /7pktTi+ddw1hzpiVRk86zS0J2AA2nf4Sn3xs0fPda70PGbvFXp8wY60EgF35DniYoWz
         VN4TnoGgE5Kh8vvcEHcM4kLi298q4NI7bZdN62Se1kA3H10D0N0jO/5mOJvqaVVZ6Jzz
         imCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SOsAZalITvFAxZNqziY/vX4tGkH13Bi0d82iGbIiYRc=;
        b=VYoroBt0THh0lmYb4H4ZGqRAwQiqS0pVGkw0eTzF3KuPgDigUVk8qMc+xkumIPggeN
         0NcnfYN3LiNiOac9l+cG8A3EChDK6a8hRvVzzz8jczzmFq4bNWlGtO2IrSeWXpYjvwPd
         +HBYrbt0cUXfS8prBBa3N1XDC3jsODygETlCE3ybyHjJ4+IcsVRxeRN3RWwOzO7Hh4+z
         LDRNeP/JBT/Mj5MyEERFnYyDuhqwnuluyskf/+iQSYxa+FXvFBtGQx5zIf9dCFZgrMbs
         Gpq8dDFwub95g70Qfu5gV8qIZubYcVkLRPj87aHZotwCGmHkC8vC8u1SpSl/6OJ11333
         NdMQ==
X-Gm-Message-State: APjAAAXaJtBzwoBO+UGXvuuUkF9lYM/FDQgJknGy4oFVsfJNtDpSdVYs
        nvvMI1kK9kaI4BsDQlmYAEY=
X-Google-Smtp-Source: APXvYqye0Ni5w+cxRX5EH+h14GxN3qXqkjUyhr0Raqz2YPWCLbmAMhciD6vlktr4cyrlBpZD1LbijQ==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr15897166wmp.30.1578098237813;
        Fri, 03 Jan 2020 16:37:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x10sm59644167wrv.60.2020.01.03.16.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 16:37:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 3/3] net: dsa: tag_sja1105: Slightly improve the Xmas tree in sja1105_xmit
Date:   Sat,  4 Jan 2020 02:37:11 +0200
Message-Id: <20200104003711.18366-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200104003711.18366-1-olteanv@gmail.com>
References: <20200104003711.18366-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that makes the dp, tx_vid, queue_mapping and
pcp local variable definitions a bit closer in length, so they don't
look like an eyesore as much.

The 'ds' variable is not used otherwise, except for ds->dp.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Patch is new.

 net/dsa/tag_sja1105.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 7c2b84393cc6..5366ea430349 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -100,8 +100,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	struct dsa_switch *ds = dp->ds;
-	u16 tx_vid = dsa_8021q_tx_vid(ds, dp->index);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
 
-- 
2.17.1

