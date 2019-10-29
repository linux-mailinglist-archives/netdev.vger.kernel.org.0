Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6093BE9214
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 22:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfJ2Vc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 17:32:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39885 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfJ2Vc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 17:32:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so22359wra.6
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 14:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=v15BYYuClTGl12XK91aICrUb3FYJTXLKNHXeKtYe/c0=;
        b=RVxYmP2mffkT9lDSU7KOlqHPuHpWOUOtPoSYT9CM/63ZoF1/aYS++Sc2OJhM4Eog9z
         oYffCGb1rn+zsq6ZNV9xMMbJeOuMkmF7eTJeSR7KA1XTN4yLBA7f8PT3GxJPMAgH5vHA
         37uvvidC0LqDXsup94a0x8zWgLGmkov0UqLV2ZQY80xiYjf9UG3DMDswYf1pGdC81I+Q
         yKGddObve/Kga/XWOz1esDRnNqbLT+f9EySyjlj6eR3adoJvMnru4AHKXLjrWL3uy8eX
         9azdUlu0ZI65P36B6m8LvMBcR7H3rA39XH4zfB/w+uhRY2KT2FxjF/N9XZ4+TDhAXWrQ
         ys8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=v15BYYuClTGl12XK91aICrUb3FYJTXLKNHXeKtYe/c0=;
        b=WjENEtULVgt4yu4dS8MEhVMGedlUYk8cEr6vGVFTYt/2PVc+cJlCNVXJp3sO5hdohB
         HIT22cyr25obUnJLLUDJXCERC4sCIZDO0b+ywD06mgqJR7O6KTdh3VBdx0HM7cg2KqM5
         dU81QTT84af72pH0EdrOw0IUhLYtFNjP9tmNYLFuNsXNMwWn+rgfyNi3JKV3K/TCFx8H
         ugqEQiQj6UwnYVi/E2ZPfXE4YTb++W0GKIWIX26tKWYSaHl7vOApLC4nX/c2PE7CS4fn
         O0+57l/KmdPUd1JnYy+dEQqyCAby6aOrPX42K93VURdcpf5eCJoJe5J1i4LPZCHOsFPJ
         zQcQ==
X-Gm-Message-State: APjAAAUPsOFdPj1vpCJ+Ut7nSrs3UFC6tX8w8TTi2AEYqk5ViXxU/pTO
        /yDB1HTFKBvhwWPoO2fJ8pEXh86y
X-Google-Smtp-Source: APXvYqw+ULibTCYHmwbD1s0c85zBKQ12FSSv3dw4997pXIaah3gL8FsFQWJzAEPyNa5FA9wh2kfVHw==
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr22692755wro.378.1572384772584;
        Tue, 29 Oct 2019 14:32:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:ccde:2c29:a00c:dbef? (p200300EA8F176E00CCDE2C29A00CDBEF.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:ccde:2c29:a00c:dbef])
        by smtp.googlemail.com with ESMTPSA id t24sm394950wra.55.2019.10.29.14.32.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 14:32:51 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: dsa: add ethtool pause configuration support
Message-ID: <eb248743-4407-93a6-2e80-e84b7510ca49@gmail.com>
Date:   Tue, 29 Oct 2019 22:32:48 +0100
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

This patch adds glue logic to make pause settings per port
configurable vie ethtool.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/dsa/slave.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 028e65f4b..d18761649 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -789,6 +789,22 @@ static int dsa_slave_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(dp->pl, cmd);
 }
 
+static void dsa_slave_get_pauseparam(struct net_device *dev,
+				     struct ethtool_pauseparam *pause)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	phylink_ethtool_get_pauseparam(dp->pl, pause);
+}
+
+static int dsa_slave_set_pauseparam(struct net_device *dev,
+				    struct ethtool_pauseparam *pause)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	return phylink_ethtool_set_pauseparam(dp->pl, pause);
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static int dsa_slave_netpoll_setup(struct net_device *dev,
 				   struct netpoll_info *ni)
@@ -1192,6 +1208,8 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_eee		= dsa_slave_get_eee,
 	.get_link_ksettings	= dsa_slave_get_link_ksettings,
 	.set_link_ksettings	= dsa_slave_set_link_ksettings,
+	.get_pauseparam		= dsa_slave_get_pauseparam,
+	.set_pauseparam		= dsa_slave_set_pauseparam,
 	.get_rxnfc		= dsa_slave_get_rxnfc,
 	.set_rxnfc		= dsa_slave_set_rxnfc,
 	.get_ts_info		= dsa_slave_get_ts_info,
-- 
2.23.0

