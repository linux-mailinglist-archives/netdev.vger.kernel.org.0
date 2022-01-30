Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A449D4A3601
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 12:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354673AbiA3LiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 06:38:13 -0500
Received: from mail-bn8nam08on2051.outbound.protection.outlook.com ([40.107.100.51]:9629
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346954AbiA3LiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 06:38:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYLs6AYcuCwlLBjnk663aqyNKQ4tUQPFCZbV8+v9j064Wb/0TzQz0geH71OQrebkvWoVL9ypA5Opn3SJOTUZNFLvTJC1TDTCauSHsARGlxrwp1v5zfHk9MXA9gmxb43/InPlyVEh2CFiQhS3a43rgWg+d6hF4W76YU4gLFeQ0I+aspaPfI3H3vDi9VDD8z24LpOjKhNrgMc+JTwahJ4BhPB5gvzxvt/jrP8IeE5zLBmnAkJMZ2nOyxUIc1IFoMCKPnRxFpdaWXjj2F1uFa7mIHwx17XeEO9rQx0aEsXT1RCRFYRwWylPYKyviGv9ZntPNRCAPlGyvNzhW2rJu2hIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwuxi38BGKCYgFVkoZ+8c+Fyh8ysPg4mFl/zFWqdZk8=;
 b=jkPwYJMcl1a4hpePRcYAeT03b3fE7VA72h79LWbR3eeTqVeFGi3tT07cN/rV74aKuDRaZFFhf4/izs8pDplfxtnDdJzXFGJT//jnZS986k4WXQRrFO7CL0wzPSs0xbYFb/CnX9sG50dbn//X8XIjAc4St184yaUwxi7c9qCXx+84g/3GbfRR9g2sKdxbMBTBmGMwHNsHQmIbnIm8Vrg5GUdewRPo7xxFAcIQIowXiCHSEDUl9STzqnSmLyj/qbxYt2Hk4UAyh1iBMNvGo9rJzsNkY14U03uEKgb6yHMeKWuRJbJ3tnaAYW138NzkuiFrZrUa9+SXdNJIdhbaioj1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwuxi38BGKCYgFVkoZ+8c+Fyh8ysPg4mFl/zFWqdZk8=;
 b=ADW2uOa8wqzC4/3JII/DcDs8gu026kh7egI+ucpYplTLtHp30KplJOI1KL+yuemh1cr6rH6WDTWvau0bufIlAUcibyrOD3YFn+lkgC+bRaBCE6RYbI3hkrMH/ZsbKdBqTdHNPDN4ihbaTKK30kxxAHAcBESOYOn0haEozYwn5IBfTO8qQZil0hefg7bM+rptqtsk+zUR2F/afJdIP3lGwwcuMOjMQ6vwUrbt8Bps69wxojM0IG/iKthK82D7iQBhBa0GhEtxm8/L4UiEhrgZHk7JPP2Om7p7/Hj4C/XBOdrn5Fm77Ppdqx8F78dLuItkm4fA0mBYu8OXXubng6LQ3A==
Received: from BN6PR13CA0070.namprd13.prod.outlook.com (2603:10b6:404:11::32)
 by BY5PR12MB3985.namprd12.prod.outlook.com (2603:10b6:a03:196::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Sun, 30 Jan
 2022 11:38:07 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::b2) by BN6PR13CA0070.outlook.office365.com
 (2603:10b6:404:11::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.10 via Frontend
 Transport; Sun, 30 Jan 2022 11:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 11:38:06 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 11:38:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 03:38:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 03:38:00 -0800
From:   Raed Salem <raeds@nvidia.com>
To:     <sd@queasysnail.net>, <kuba@kernel.org>,
        <hannes@stressinduktion.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>,
        "Raed Salem" <raeds@nvidia.com>
Subject: [PATCH net] net: macsec: Verify that send_sci is on when setting Tx sci explicitly
Date:   Sun, 30 Jan 2022 13:37:52 +0200
Message-ID: <1643542672-29403-1-git-send-email-raeds@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 756f4293-81d6-484c-a651-08d9e3e4fbc1
X-MS-TrafficTypeDiagnostic: BY5PR12MB3985:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3985AEDEB954087E7E9EC727C9249@BY5PR12MB3985.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lw216mjhhXzXRnEdaRvpd1xjy2LGb8bl1aqQJZNvhMZFQYeE5YovpG7ZcdwLYieKfvfbmeiF1jF3tJL+H1n7/xWc2/q4oZDhciVl2KcRNPcxl7lIGrWdDK6790uCnXBD+a33V/mNMA3cYNUbtx+GC5mzJFpAXmQD1n+8z2PorUMtU9HuHTD2O+7eFC9G3Egnq2i0qTv2RukNkhNIOERc2ARroiRsW/wiiU5XDtEMs6IMxxoOMtVU36w3HsmcgJxpVBTL7kWgZgBoZcjhZtGJzPvSGa2KTtRZwDIeQjDgl0yfFV+CLregpEZpbG3J8owOLq9xGLjHgJOYONvSpBSFwgaRIQD3OVPGlYjzunvPktvBKu8YFPW2KXEuYlj4RGeB6MJcc4RpIWN30Y0SzvYIgGPoZJNE8wob9ZTobdq5e0sV+fK6GWT0X+XZ4GAv+w/JaptfCfWQat6MYl1Gje2xAf9l6l39SKL5lMTgJf7CxnN9ZvTIYyZcdzkMHFoh2TUYGy93ez2RIC50q/qylTiV0rjVvwzfTx4EzZZxd1y6w+e4z4DPL5AY5CDgg0lQWtak/yVXHg0644M7jZVJ5vsl4XPFma7ymb4d5etQa7oy4QqnCMq3QqCC4HCtgX4Wt/nALMRjlFJWRUxk6eLR4Xzwi6byofp+OWH0XvkW9qmk9ZAJzB6qyMpQsn23bCOMkuNy8GGsSVm2qZuHtObVrCVM+7JzMislUfDc6B+UUpnzvWJtWTG9UbknSCp4U1wTTwGQ
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8676002)(8936002)(2906002)(508600001)(4326008)(356005)(81166007)(316002)(54906003)(110136005)(6666004)(7696005)(107886003)(2616005)(36860700001)(86362001)(26005)(186003)(336012)(426003)(47076005)(5660300002)(36756003)(70586007)(70206006)(82310400004)(40460700003)(36900700001)(309714004)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 11:38:06.3738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 756f4293-81d6-484c-a651-08d9e3e4fbc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3985
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

When setting Tx sci explicit, the Rx side is expected to use this
sci and not recalculate it from the packet.However, in case of Tx sci
is explicit and send_sci is off, the receiver is wrongly recalculate
the sci from the source MAC address which most likely be different
than the explicit sci.

Fix by preventing such configuration when macsec newlink is established
and return EINVAL error code on such cases.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
---
 drivers/net/macsec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 33ff33c..3d08743 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4018,6 +4018,15 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	    !macsec_check_offload(macsec->offload, macsec))
 		return -EOPNOTSUPP;
 
+	/* send_sci must be set to true when transmit sci explicitly is set */
+	if ((data && data[IFLA_MACSEC_SCI]) &&
+	    (data && data[IFLA_MACSEC_INC_SCI])) {
+		u8 send_sci = !!nla_get_u8(data[IFLA_MACSEC_INC_SCI]);
+
+		if (!send_sci)
+			return -EINVAL;
+	}
+
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
 	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
-- 
1.8.3.1

