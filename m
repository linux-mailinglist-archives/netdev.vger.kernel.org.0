Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8440335B5C9
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhDKPE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbhDKPEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:04:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BADAC061574;
        Sun, 11 Apr 2021 08:04:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id sd23so7413567ejb.12;
        Sun, 11 Apr 2021 08:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TP//p5Hq9CM2Hfznxk5ShC9ChhuREDW41Rf2hAiWGJA=;
        b=BgCqO4QD2MZmWZ0fb8HPEh+aRox+eA1s2DYR/aYkwtx9LeOZz1WWHDdgqAZYOEApZ2
         cWoZF3LAhNvYwQb8/m6hwa436iFHeue1Jih7ZmJsXpZiJ57gDtxt7wPjon2YkSgu7NmH
         BxZuRoMgK6i8z1SYAqiibj7wLdTGaw4dLWz7vkOwentg25Q13CWk95BCQioR3b72nn/Y
         T8YgmlAifEEXDgkcgLJ3MPsPxTN/L76agvFbb/hpC9Qn0zoEPZ89SCC8m50U+wz+mVkI
         Htegc4kZRoprWoXuAu4A2WYcevIg0/CXQAIE6MTzqDzdxKpuuzspGcGfeK/YYwiMFSpR
         j6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TP//p5Hq9CM2Hfznxk5ShC9ChhuREDW41Rf2hAiWGJA=;
        b=At8MViSnrWzAPwkdcGkpfSNomprcvnN0gXxMXajNFyNHHnXL0RKQ45xyFliTcwIyic
         62ZARqdrXAEHteaDs5jc82sfHwKL6TF+PASwfgQW+PZzsHeuRuet8rE0XsJxO+RkWx0+
         j0hGWkifTy1qobUzuBQUaUz2ML5vKyu17GHAQoMFI46+JHVrB664e1ygNrbeoBujLr3m
         QFPHhaCBA9ZA/D5B+TPV33qokMDxcJ/T6kdzblBlIl/vtfQwQ6jenBYUbdi7Z8vNcmaV
         JBEtadXSTm8w5gT5oMdIh087UnJhlx5f6mPnwNPbUdfm35JzpUeJ+Eil91Va71LIel5g
         Mblw==
X-Gm-Message-State: AOAM531bwqprfxfyudQcDIondtYDrn509c8hwvdq7YB7AoIcHMNI78cu
        WCO/A8+xc/gRWWvP319YK1umhKJCn6i9dQ==
X-Google-Smtp-Source: ABdhPJyr6FTeSN04PU7jiIvYcmU7cl2nWMUaeMYMcBq0zzEilG8lpLyXWo72bNfqyZszvNtXFVEyyQ==
X-Received: by 2002:a17:906:a0d4:: with SMTP id bh20mr23722082ejb.348.1618153447836;
        Sun, 11 Apr 2021 08:04:07 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.googlemail.com with ESMTPSA id l15sm4736146edb.48.2021.04.11.08.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:04:07 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        zhang kai <zhangkaiheb@126.com>, Di Zhu <zhudi21@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC net-next 3/3] net: dsa: implement ndo_set_netlink for chaning port's CPU port
Date:   Sat, 10 Apr 2021 15:34:49 +0200
Message-Id: <20210410133454.4768-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210410133454.4768-1-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement ndo_set_iflink for DSA slave device. In multi-CPU port setup
this should be used to change to which CPU destination port a given port
should be connected. On CPU port change, the mac address is updated with
the new value, if not set to a custom value.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/slave.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..c68dbd3ab21a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -63,6 +63,36 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
 	return dsa_slave_to_master(dev)->ifindex;
 }
 
+static int dsa_slave_set_iflink(struct net_device *dev, int iflink)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct net_device *cpu_dev;
+	struct dsa_port *cpu_dp;
+
+	cpu_dev = dev_get_by_index(dev_net(dev), iflink);
+	if (!cpu_dev)
+		return -ENODEV;
+
+	cpu_dp = cpu_dev->dsa_ptr;
+	if (!cpu_dp)
+		return -EINVAL;
+
+	/* new CPU port has to be on the same switch tree */
+	if (cpu_dp->dst != dp->cpu_dp->dst)
+		return -EINVAL;
+
+	if (ether_addr_equal(dev->dev_addr, master->dev_addr))
+		eth_hw_addr_inherit(dev, cpu_dev);
+
+	/* should this be done atomically? */
+	dp->cpu_dp = cpu_dp;
+	p->xmit = cpu_dp->tag_ops->xmit;
+
+	return 0;
+}
+
 static int dsa_slave_open(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -1666,6 +1696,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_fdb_dump		= dsa_slave_fdb_dump,
 	.ndo_do_ioctl		= dsa_slave_ioctl,
 	.ndo_get_iflink		= dsa_slave_get_iflink,
+	.ndo_set_iflink		= dsa_slave_set_iflink,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_netpoll_setup	= dsa_slave_netpoll_setup,
 	.ndo_netpoll_cleanup	= dsa_slave_netpoll_cleanup,
-- 
2.30.2

