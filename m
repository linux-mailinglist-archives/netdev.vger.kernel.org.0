Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5661EF61D
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgFELGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 07:06:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgFELGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 07:06:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055B2AtD151356;
        Fri, 5 Jun 2020 11:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=nWl+y+0wUhQoIBqwp6wGjPeAe8E7npemEWVmDlHdQYI=;
 b=BvSNvoCGgYwdTHuUKGZvrMSZhQjFdHEs4prRA/Kc48QX+FMiqYJl5ltRDvvP/pcUroO1
 HKaq5mf9OPQrGeIuq0exUBfgvalthF1pJvIypWcXX2TH4Nem4yk5bo54qfEMDs9SEAWx
 CNNoXbdd+Fupaljh1oc8BlksG6WEyOxu5MEHhh99TuKWPD2fGgKi6m2Q8Bys/MhOUcXo
 cvPh+agHw17yBk+SizpIzqFO2dYiH+Rt1EGpRGaapjQLgPHz5k5Nen6kIQrRI+poeYs4
 ri7T06rEpI+GY2sCbMd0qK32F88UQshim7JN0du7eTidv7PaXRtqvhGiSVWJKcDV8ZXt wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31f9242asx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 11:06:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055B4BCh137758;
        Fri, 5 Jun 2020 11:04:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31f9272v0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 11:04:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055B4Mip031238;
        Fri, 5 Jun 2020 11:04:23 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 04:04:21 -0700
Date:   Fri, 5 Jun 2020 14:04:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ethtool: linkinfo: remove an unnecessary NULL check
Message-ID: <20200605110413.GF978434@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 bulkscore=0
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050085
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code generates a Smatch warning:

    net/ethtool/linkinfo.c:143 ethnl_set_linkinfo()
    warn: variable dereferenced before check 'info' (see line 119)

Fortunately, the "info" pointer is never NULL so the check can be
removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/ethtool/linkinfo.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 677068deb68c0..5eaf173eaaca5 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -140,8 +140,7 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 
 	ret = __ethtool_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
-		if (info)
-			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out_ops;
 	}
 	lsettings = &ksettings.base;
-- 
2.26.2

