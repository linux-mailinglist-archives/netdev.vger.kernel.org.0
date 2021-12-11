Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2620D471052
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345726AbhLKCGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345705AbhLKCF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:05:56 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EBBC061746;
        Fri, 10 Dec 2021 18:02:20 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so34877285edd.0;
        Fri, 10 Dec 2021 18:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VYf84s46pYHk14Zd0Id645e0E3gaY9WmXyIhkduppg=;
        b=IYtTe+3rfxnjQYDRMDEySRlLkiysEIVCcNgz6lY3vu+7J7gF3WlA9iPdP+8WNloKyK
         Js/GhxuNeaXI3SdORRtRVdY14fMySh5pJrg7NbAaebKbHKoeoDexDxK6BzdqOsT7dh9v
         ncVJsb3EKMOLDW5xph+xAFTVYflDzLYSIZwYr8Hww0gNPnPd5YDlFhkctOmms5L5zzT9
         djyaDd+DfM1FYo5ovqIaKGiJilstQVCRUf3XYn6ajJOwfD8yiQbSh9C4zZ5DaYprA1/1
         DG0Hx8GhXkCJxsxHi7YXbO/hjxgFk4SU+JAX2l9TUNg4qvakhkpxC0GcI4/cQIRVysYZ
         pIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VYf84s46pYHk14Zd0Id645e0E3gaY9WmXyIhkduppg=;
        b=3iku2ke5zbFCIjPyb3XxltWVrc9oMj2CqWIynLakBnuupaQsR5IJyvu0b6huY+oYTL
         QLsR5OYJ3wzYT/Lu1OsUw2N4C/CZ8BTTNEcSs82dTC4jHr6pyCA6kpJkY6FS9ty5TXDD
         5X2dhZkIVPNY6WjzpCRYuaubb5dO1VO1i8aYPN26gxUDI+RdaLK5EENw2KanC1S9h6pZ
         49qrv06Kvpuna8S7OdZtpODF7Wzgs05Fxy8HIq8vuupeGxkSCPsoYVpGjKYHuyLzOs9/
         dfNVqGLYiNyCiqAGKP3OWzIO8421eqC4twvNLF9R3Tmafu3UfjGyJ0rMJKwKdNVvvqdT
         zxlA==
X-Gm-Message-State: AOAM533j2baLsSVOfh50+C6FRgqGOpsGc2+2B0vjdETlZ9sI06PXNtZ9
        CDNfIK3wVWeB1MgWaxFn2Ps=
X-Google-Smtp-Source: ABdhPJwormjlTbJTDfjAHLoGnY1MDqBRgO4tS6pDuWpQT6oEGfiu+QBWUMHyQek/WvgJkjVaXdrwrw==
X-Received: by 2002:a17:906:8c3:: with SMTP id o3mr28388996eje.10.1639188138894;
        Fri, 10 Dec 2021 18:02:18 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:18 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [net-next RFC PATCH v3 02/15] net: dsa: stop updating master MTU from master.c
Date:   Sat, 11 Dec 2021 03:01:34 +0100
Message-Id: <20211211020155.10114-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. This function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..f4efb244f91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,28 +330,13 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_reset_mtu(struct net_device *dev)
-{
-	int err;
-
-	rtnl_lock();
-	err = dev_set_mtu(dev, ETH_DATA_LEN);
-	if (err)
-		netdev_dbg(dev,
-			   "Unable to reset MTU to exclude DSA overheads\n");
-	rtnl_unlock();
-}
-
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int mtu, ret;
-
-	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
+	int ret;
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -361,13 +346,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
-	rtnl_lock();
-	ret = dev_set_mtu(dev, mtu);
-	rtnl_unlock();
-	if (ret)
-		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
-			    ret, mtu);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -405,7 +383,6 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
-	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.32.0

