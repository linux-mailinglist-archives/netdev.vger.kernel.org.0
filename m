Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091522EBBE8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAFJxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbhAFJxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:53:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1654C06135C;
        Wed,  6 Jan 2021 01:52:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i24so3828390edj.8;
        Wed, 06 Jan 2021 01:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yF3rnLTyQNwA21TyP52ciWlNhWGg2itKNaVkTO2/cDA=;
        b=V6RtY4DS+UNCW6fua0p/m79afdROsP11C0PquKtYRn2kbdiNrCrgy7y6M/h+MXGVQP
         q4Dx+GPHMSamQ4qCkjtNGolJEYlY0fDQCEF36qoySnoe2UrtWpBQ5QdSydtSI68Clx5b
         hMaGW05NJvB+f6iNIPZHZensNo0ntRUM4JNk9DZ9tz19cbBEQnvu0LMdFh4ehjOQ/k41
         hMmY4DRE8QMJDh4eErCfywL82gw7kC31uiT/Px/XwK2JW6QK9oHLrwS+UcnrCUmdNSSL
         A4oCXrvEQ4Rukl7UDY3nSBiHsmUGqghaca8EQuWNG08bIwGktNOLZ4kllyQfgJjPQDOT
         L9oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yF3rnLTyQNwA21TyP52ciWlNhWGg2itKNaVkTO2/cDA=;
        b=fWpsPj1stTxhqJVxsufNqv3fc1Ao6ZTFzDhBeaLRk1mJV4rh988TYoMBTKJSUqqkFF
         kzYntQU/Srv/M+OIm+KPDRPxGHCSlHH1O9moEpE415YXfN+Eb6VdXcHxf1AaTBSYGDAX
         Zyl+Wby9XTdkLUjwQkgsnP2jGHK791xXp/AmrBwTmjfIqoEg8J/Tobz6eVr44tJeKXzQ
         2l7reWH/enev2b/9DO+xqq1BvsdoUMpmKCFuZgwKSv8XxZW2AOjJxxJopj1/p0vNfwA1
         NWeAQ+Oz7O3W7/aHRoOcOtezmiShlkOI4dgq4lkVjFr9WJJ7y3k21h2pe6O4Ke6rovNz
         U2ig==
X-Gm-Message-State: AOAM530J4izFZ++J20e8B6ad01qOa+3lNwg/iY1ecosE0LIcVDVNnA61
        yl1fQYBf0kH2Zd5jGs4yd2kDJ1N0GjU=
X-Google-Smtp-Source: ABdhPJzTQaqy8VXeMTSaAYqUwxQFJr8Tf4SYo0dqaCd3QeTpmzC07iD46TQwKp0I0Q6h+rvjDTaAcA==
X-Received: by 2002:a50:f1c7:: with SMTP id y7mr3495727edl.184.1609926733626;
        Wed, 06 Jan 2021 01:52:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 5/7] net: dsa: exit early in dsa_slave_switchdev_event if we can't program the FDB
Date:   Wed,  6 Jan 2021 11:51:34 +0200
Message-Id: <20210106095136.224739-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
References: <20210106095136.224739-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Right now, the following would happen for a switch driver that does not
implement .port_fdb_add or .port_fdb_del.

dsa_slave_switchdev_event returns NOTIFY_OK and schedules:
-> dsa_slave_switchdev_event_work
   -> dsa_port_fdb_add
      -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
         -> dsa_switch_fdb_add
            -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
   -> an error is printed with dev_dbg, and
      dsa_fdb_offload_notify(switchdev_work) is not called.

We can avoid scheduling the worker for nothing and say NOTIFY_DONE.
Because we don't call dsa_fdb_offload_notify, the static FDB entry will
remain just in the software bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
None.

Changes in v3:
s/NOTIFY_OK/NOTIFY_DONE/ in commit description.

Changes in v2:
Patch is new.

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 42ec18a4c7ba..37dffe5bc46f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2132,6 +2132,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 		dp = dsa_slave_to_port(dev);
 
+		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+			return NOTIFY_DONE;
+
 		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 		if (!switchdev_work)
 			return NOTIFY_BAD;
-- 
2.25.1

