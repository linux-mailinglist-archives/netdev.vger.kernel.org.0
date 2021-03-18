Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536F33410E9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhCRXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhCRXTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4EDC06174A;
        Thu, 18 Mar 2021 16:19:07 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id dm8so8717578edb.2;
        Thu, 18 Mar 2021 16:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rvRvsfvBDHpsmjNEjVCg3MOXgysHWNruaanlbS6bjkU=;
        b=TCj4DU97pcIqkEiYKCUx52mlILcs58xq5znQHckOJ9H1MQNG/6N1jFkiU6tqCUmeKd
         8XLl+AfSWsIxSoAhvAJFxgZqwUZXhv8Lq5Y5Y7DTP60cCpSiGF32hwXSfe+9eaFmrRoF
         IRuAxJQ0+NiQ6vL1e0a79ZuHiH/jQ45MZ+nhi1KiVsugqJi3ZbwZj2Z/S8Wuf6KDjRdd
         sn/6gouk8YL4+lCUjfapCX0VHo6YsKA375cMMC4JslIDJbR/0P9FMJWpWsGY3mT3Wz0/
         R4mGDT1T35/qGUJlSEhJQrJKMf2vczW6+tyI88v4CEE41NMrx8s/uwE1YFJjVnUUlR2q
         Z5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rvRvsfvBDHpsmjNEjVCg3MOXgysHWNruaanlbS6bjkU=;
        b=mMWCA+Q/8bh1JfsgIZoR2i0za2wt2+zinZpEG97UbyLhezkJdbfyYXrbU/y3i14Ovp
         l876rW+acSUZk2oZ0k5oMXguWCrKvV3ae939CTuLTp/HhdROF4GN2kCVcuCHcjWqnoOO
         RuLL6KEiJeeRv+SKPzmivRsO5njDMT+p+5XVRfk4RnOK/bFB2OwsURkClpkQKmVvulwS
         vfLJbiuUeQZavMIArzEO9rhIAD3XAob4QU8e8A0nYlmU1IQfpX/+xwQO6cwZtA3UQ72v
         5aioFcBUbCioOj01TCSJqqUyPNfnlvKZEQJpHvvXxoHwdbRi+rDfohXuv2KGewvm2IpX
         b7QQ==
X-Gm-Message-State: AOAM533+aDrIHvJt9tT8Creq6DgAVoWbY+5EgRCOZc3ebeCgmX6sfeR3
        q/bSXiKFSthvHmpsdy/puMM=
X-Google-Smtp-Source: ABdhPJytYbqHecnVZT/dcdYnDN02NMvULNoCRmXmjj537J2Yny33215vZPPOdYWd8ijSPBHkxqmSLg==
X-Received: by 2002:a05:6402:42d1:: with SMTP id i17mr6280050edc.131.1616109545846;
        Thu, 18 Mar 2021 16:19:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:19:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 15/16] net: dsa: return -EOPNOTSUPP when driver does not implement .port_lag_join
Date:   Fri, 19 Mar 2021 01:18:28 +0200
Message-Id: <20210318231829.3892920-16-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The DSA core has a layered structure, and even though we end up
returning 0 (success) to user space when setting a bonding/team upper
that can't be offloaded, some parts of the framework actually need to
know that we couldn't offload that.

For example, if dsa_switch_lag_join returns 0 as it currently does,
dsa_port_lag_join has no way to tell a successful offload from a
software fallback, and it will call dsa_port_bridge_join afterwards.
Then we'll think we're offloading the bridge master of the LAG, when in
fact we're not even offloading the LAG. In turn, this will make us set
skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
like it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4b5da89dc27a..162bbb2f5cec 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -213,7 +213,7 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 						   info->port, info->lag,
 						   info->info);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static int dsa_switch_lag_leave(struct dsa_switch *ds,
@@ -226,7 +226,7 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
 						    info->port, info->lag);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
-- 
2.25.1

