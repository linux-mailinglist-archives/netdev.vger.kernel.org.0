Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A87372FCD
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhEDSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:35:06 -0400
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:59880 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhEDSfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:35:05 -0400
Received: from pps.filterd (m0220294.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144I9rmH024148;
        Tue, 4 May 2021 13:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pps1;
 bh=NevxT241im1sompXtnoojFuHhyOb8qL5q3yVwdaLpKw=;
 b=jt1UrfMrCaoiZYxrll0NBrtsXHQMCijieZi1/+1EH3UyPRAyBTpOrLL7X9KLBgidk3Jg
 pKHuKZrx6szm5UfyG2LflIbUxzZ9iAd858n1fI8hXr667ZWggQ6ZqEFDWPF9ydsUAVNr
 hu/1G9CP6/PQeR56W9OA553OJb6hJCK+c+2asdNOSDiSbvQfyAaJzCVYUZLDV4/rKvbl
 fqBCGtsV7w4yGh9hzxohjh8swQCcDboLM1bseaefbjDs6iyeYigLxAEToeUoyt3qwAhk
 aNN6aS4CRpSz5Nxk38HslWOqkE2ySNt4t6afIWYrK0eL94P0bzNBsFB9locarXGh8EbC nA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-000eb902.pphosted.com with ESMTP id 38awtsha9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 13:23:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/I08P8FX/ivmeoTl9OWlLOjgGk6hWZ6VGgOuws06Urt45FUVVfd+hL+xCNLUZtKAfcjHqgrNVzU1y8P2I329rfg+1gSQZafM8Q72YR+8OXSuj2NV8PkB7Kkgrfa7Z7LQLthE5C5v4ySxG8B2lt6Nuk72l0LUuaQJ8QRKii49f90HYIootM5mzbX3YpDrlhr9cL86Ugf5QPXZ501g3htcBosxChkneslhApALS2L2DIqlEFw3RW5+UnZp2jCEoz3jfA7xk+9kDPglhRlMXxibcjtVbsMFE3F6eIwigTOVqyEjgdycTEe5wcxW/tC97jK0cd+RKcRgVUTC2Mct8scug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NevxT241im1sompXtnoojFuHhyOb8qL5q3yVwdaLpKw=;
 b=BjYSkct6N5HJfvT53NAy31o77SMn6Z3cpcZJlTvYE3J4Dq6D4JsqvxIE2b1G5NdKGbxMKoYush9vPS6EIQ93lBkUIH/YXFRkDuhPfWBzfuSgpALiPyQyMBbWwSFSAFI4idTkuZUMQMMrQPhC8fADB9xp1tkQhSsLGBq7tD5Cx4I9VDBUBiU5R4ZdUOKysKPlhwnMVoi3u42fZq0g4O/LOV2Nho4mvcjtACGnWlsIiiCC3QOxEmWw7kqmpIvFIxEvkPwRK6KSp9gA4h/CGPSKAZlIVzxapeeX3e45GEZZyqtQBU1YengotO4h97BNy3blodyjbUC2qxna+b9tOpZqLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NevxT241im1sompXtnoojFuHhyOb8qL5q3yVwdaLpKw=;
 b=Aa9PF6ml7wwVuEi21SFpiybOtLwOeyI0q5XNF5QN1vJ9s7k7KTQEtK+HJn+StMd4uRIbWbZit/gQteNoPvFqVFAJHGn5LrTnRI+ojDItI6Rx2Z0YcVaWB22WEul+X6kMzwQbQvBUxsiFPcwwLzYdW+AuY+InkkrWJoFqYsv2DtvO80Iq6yR27+7h1vYM/9fAb1qDQz8DsNKVkr09cTE01nJXjzjJSPJTRzvVfLZ9MO//yhgHhcRTLj3mB62jYYw6R6FiqZsaOO0UIOOO+fHX3Pdny4S6eJnji/nKqQaoGkyRgDIvyVoDc5KwTALgQZNRw708oUvbOToAb4Dk0TK46Q==
Received: from MW3PR06CA0012.namprd06.prod.outlook.com (2603:10b6:303:2a::17)
 by MW4PR04MB7396.namprd04.prod.outlook.com (2603:10b6:303:73::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Tue, 4 May
 2021 18:23:26 +0000
Received: from MW2NAM10FT031.eop-nam10.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::2d) by MW3PR06CA0012.outlook.office365.com
 (2603:10b6:303:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Tue, 4 May 2021 18:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT031.mail.protection.outlook.com (10.13.155.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 18:23:26 +0000
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 13:23:20 -0500
Received: from huangjoseph-vm1.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 13:23:24 -0500
From:   Joseph Huang <Joseph.Huang@garmin.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Joseph Huang <Joseph.Huang@garmin.com>
Subject: [PATCH 4/6] bridge: Force mcast_flooding for mrouter ports
Date:   Tue, 4 May 2021 14:22:57 -0400
Message-ID: <20210504182259.5042-5-Joseph.Huang@garmin.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210504182259.5042-1-Joseph.Huang@garmin.com>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) To
 OLAWPA-EXMB4.ad.garmin.com (10.5.144.25)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0e880f-b301-4d5f-da55-08d90f29b576
X-MS-TrafficTypeDiagnostic: MW4PR04MB7396:
X-Microsoft-Antispam-PRVS: <MW4PR04MB73969C87E77266EEB38412B1FB5A9@MW4PR04MB7396.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3y9WVvgli4tX85BhpW2raQcZrjvvPJMXVcFjzxSqnMn7Gymnnkyw1YB6vsyxv+CAGtY9p9buKmDXLZ+0aIP5InEHfoEdtLqlsQmc2stfFRgw5h8P2vq5vmXSmWeQFNp+AGypKuokgvlqG7kqel8SGlUZAeEh66XRFvpHv59NCXqyhiV+jX/tDqqZ/2EHuoIkhHkNDgoYB9NJEjjyWyMYuRg/tnfHIF5h6jEmeSBvKkgoB1G32CcNh4Xaw1cjY11Kbp93Zu57NVFPRKqChUE1hSr6LdU0t+F79fSVqVHszEvo7hqkS1rcr6OvAs5E+sJ9NJjZpWJvcmYYEtlFwc71xri2u6rvWm/EWcINzALRsRrIFppAdfonUiy+Pd7UGaJR0asmkFUwFYGDvH73x2aYcYeHy3zyNaDPp3DRyX6ATBLS+KXk1Tr7lINKaa55+2QPLzuTj+hRZE9K19UCeJmDWxBmugftDohH2JOPTushaA5lfpjzIKgebt5lvedgoS5nQZSgUbmrr/iERBbOKVZTpqHlbRz5x1+L3ZG0MbHUXiJFORtcfBMG/msdsYmLa1yWKTrYGv6umbdy3AB8Yau5m1L3wC3FPsC7mfqd4WhEDegEvTl5uD/yyGkeu1rANwT/0ssDuiizdrgAGgKY/OzIvg==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(376002)(46966006)(36840700001)(110136005)(47076005)(8936002)(7696005)(2616005)(356005)(82740400003)(1076003)(7636003)(82310400003)(316002)(478600001)(107886003)(6666004)(36860700001)(5660300002)(26005)(70586007)(66574015)(36756003)(186003)(83380400001)(4326008)(2906002)(70206006)(426003)(86362001)(8676002)(336012);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 18:23:26.0787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0e880f-b301-4d5f-da55-08d90f29b576
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT031.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7396
X-Proofpoint-GUID: IkUx2qSk45jIPxvdFIwvni-r5qIR79eb
X-Proofpoint-ORIG-GUID: IkUx2qSk45jIPxvdFIwvni-r5qIR79eb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port turns into an mrouter port, enable multicast flooding
on that port even if mcast_flood is disabled by user config. This
is necessary so that in a distributed system, the multicast packets
can be fowarded to the Querier when the multicast source is attached
to a Non-Querier bridge.

Consider the following scenario:

                 +--------------------+
                 |                    |
                 |      Snooping      |    +------------+
                 |      Bridge 1      |----| Listener 1 |
                 |     (Querier)      |    +------------+
                 |                    |
                 +--------------------+
                           |
                           |
                 +--------------------+
                 |    | mrouter |     |
+-----------+    |    +---------+     |
| MC Source |----|      Snooping      |
+-----------|    |      Bridge 2      |
                 |    (Non-Querier)   |
                 +--------------------+

In this scenario, Listener 1 will never receive multicast traffic
from MC Source if mcast_flood is disabled on the mrouter port on
Snooping Bridge 2.

Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
---
 net/bridge/br_multicast.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index d7fbe1f3af18..719ded3204a0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2680,6 +2680,21 @@ static void br_port_mc_router_state_change(struct net_bridge_port *port,
 
 	switchdev_port_attr_set(port->dev, &attr, NULL);
 
+	/* Force mcast_flood if mrouter port
+	 * this does not prevent netlink from changing it again
+	 */
+	if (is_mc_router && !(port->flags & BR_MCAST_FLOOD)) {
+		attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
+		attr.u.brport_flags.val = BR_MCAST_FLOOD;
+		attr.u.brport_flags.mask = BR_MCAST_FLOOD;
+		switchdev_port_attr_set(port->dev, &attr, NULL);
+	} else if (!is_mc_router) {
+		attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
+		attr.u.brport_flags.val = port->flags & BR_MCAST_FLOOD;
+		attr.u.brport_flags.mask = BR_MCAST_FLOOD;
+		switchdev_port_attr_set(port->dev, &attr, NULL);
+	}
+
 	/* Add/delete the router port to/from all multicast group
 	 * called whle br->multicast_lock is held
 	 */
-- 
2.17.1

