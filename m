Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B75456860
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhKSC6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:58:16 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:60244 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234210AbhKSC6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:58:07 -0500
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJ2jTNp030689;
        Thu, 18 Nov 2021 18:54:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=O3U/KbFH01M5yGKtvHyRzqs2TK0gLKxj/6NEBQqeOsg=;
 b=MGhGHoTckxzV8T6xFx+lJb2ZWbcTDe80gB8lqgxJfqeUHVVnyLZxFmCZJopyqJwsBrNy
 VbaRi0iTjKX4UBohv6wUK9OiPzrDPnPtb56KdDYb/XSMoWD6EzUYDJ9PfIp8bDx+D7t+
 OiuA/9TPBPSbNhEzmk8NFprXFBLvK+MWpPNHR1S4pIFVnCiUzoGtvDfOqKxJxILgQaX7
 txXpkfqhvBVtKz4YRpEpfBZJ4qQKUS67NZQ8oGR1PI3fpsH8XD3OUe8Z702exiZne+8Z
 KuEoKsvYidwRFjfnP9aQi/1XAgui7U7C4n/eZJDlDaPIIBX72WBDu71vAa0+QDJPtoAH ZA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ce02h84em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 18:54:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiHhq1BnssGO7ulzSdr1AgfdhudWa4qhpq5yA1k5/gr86BYSluXqHuJzDpg5Ifr8HzJzLHtcl0suD3ifjlOTUj9FxxIcWzSMNWhmOBOO+2ZEcDCcDPYAOytafTX72oqgSmGPpZen2fAo7ASd8LjXeddmvTnCMLmPyCd1wXB2FmBCUIi3WQgHGPYFGxl8zcOeaMYf5KupmeCWivCAsLaXiHOIdV0k9OzDWuBlJfkfpAo1E4wbB5n0tX0pfaeINd+k6eO0p/FOf3JzqcniA+sCgXJQVxJpGi7VTgRNJeok+vWO7yxNwUDlK16YjKDQ//x0t1Uq5EnAZ2r4ddHbunJf0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3U/KbFH01M5yGKtvHyRzqs2TK0gLKxj/6NEBQqeOsg=;
 b=JS7qFfq7xivGSmK+Lzqspz1LTzTmoWioPVFhUZJIRxDwC6pxa0u2Gk9sHBYScZWxtBGCl5vXj5eO/jnTYnZCYWCB726PvbeFHKS/PKR0XGJQX9IESIaZyO4v8g84HF0e/HbrzA94b8YgNXsEC/8UhAxbIVx1x6mABULNutHAn7/DmYwKVSj6sXhd0qX6ErhANpAtlomqsRSecgOzn4tsm3mrIy//xjHlndoWp9BSnqW6jF5/quAm5UB4YsMTunly0N7sZBNpB5hZp9hNeO9TCbBk36SCev/Msq9byKJjS+YtAFshfehT96H/xQff+QPW/s7Il3xdE/k0Utu/1zApqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 02:54:33 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 02:54:32 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH 4/6] net: stmmac: fix system hang if change mac address after interface ifdown
Date:   Fri, 19 Nov 2021 10:53:57 +0800
Message-Id: <20211119025359.30815-5-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0017.apcprd04.prod.outlook.com
 (2603:1096:202:2::27) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR0401CA0017.apcprd04.prod.outlook.com (2603:1096:202:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cccf9d27-450b-4862-7ecb-08d9ab07e9e2
X-MS-TrafficTypeDiagnostic: PH0PR11MB4951:
X-Microsoft-Antispam-PRVS: <PH0PR11MB495197932BC0A6DEC1003DB4F19C9@PH0PR11MB4951.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpovmzPQNc8GH6jq4U74Q/UGrBuWsEyh2UXpMBkThlfnCqXqlHCHGALcR/0npicWnrpua7SZpn9UwfAf0i4P2VIoEnI5fkHxlNkE9vNoDooX1slQeBGjEG9y4H4lLb1m6sFtnmWf90jwSD2VGTqiEMb4cGNga6HkRA78a/uUNbcpMcaP9rUCx2Ng6tKBVir5PRLruStbE6psfinQEisRHkymQ98u12tTstpvliAdHQb/J9ecfjr3RMgz2Uu7Vdjy+40W2JDDLd8z6OYFRpYKx7sc60uNnSPFIbu+7ck9/UZzKK63BEWxcsGFfd+oCOda3uyJ0NKUaKM8vvNIRt+w7hMPYLN7amdd5mTZqUvpPQcwItdxENAQI5YD3fEmQj1Z2+zYOwLO4YsET3Im1ZWf1NK8cwBHjwEqK6eUBg/Tc/fDCSMAMnV68rEURrxykcyqP3NSmeamV4ykwjuDTIJgIn10ODl1Ov7bhQS7LHkIt7cehzhwvNgidWIyjerWrcusnGp+U2Wl9JZB6udhqhygtuIUeJcdkMcaLhyu444eQRfbppkdDsgRbl1MIEN7WeQuEWajkBDHPKvB0Rr1HiDS8yMLF7wqwaLBDfsccq9dj5qLmjI/dkjOmXwZm4K1+qaepeYmuWfW1SYcIXCQ/zjJm4h1Y0xjVI6WHeulU9/aS2YvUb60r14kIcVGK2TpSxDBAX8UAxzC9cC+7UVDIe9OaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(83380400001)(5660300002)(186003)(107886003)(6512007)(4326008)(38350700002)(38100700002)(2616005)(508600001)(8936002)(1076003)(36756003)(956004)(52116002)(66946007)(66476007)(6486002)(2906002)(316002)(26005)(86362001)(66556008)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lGEfT4+AHl9awIZh2oi5Ql09lY/8Qg4kRPuzMmdXvX3WTSWglQFtK8uSrZ+u?=
 =?us-ascii?Q?nlMdICqiaTeriEJtReN7gqSG3NHvBC33zvoh5WRBhnSY8N0tqSiJLHAb6QoL?=
 =?us-ascii?Q?Nz+k/RfOGLJAanYVcuPkjBWySYt42Hxvqt/Tbt70lpLFjuw3QznbJBuK8C+y?=
 =?us-ascii?Q?aNKjr+c++QeAXrSAsv3AnOT9pxaDE/C1Qi6rn6SE/anNSYe0tr6DtQ8HYYle?=
 =?us-ascii?Q?4OW+kJZB9ZnbUGpc2cJ2g+fFeyqpKlEWa+e+MXJTTSliue8NjRImwf/yOMcO?=
 =?us-ascii?Q?YGhAG2QsI3Sb1HX83OEiiDlVH1LwNUm15oQxA4dTaA9fvLewtDAdi86rRnSZ?=
 =?us-ascii?Q?4mhKnMAEliumPi+bvgcKp2pZ/MIXsdpjKADKN2jGYq6335TUUnpjit0iZHZM?=
 =?us-ascii?Q?A69wocwzp/qjAuqYXpFG9x/xzv1qQa0lf5cijZZpdV70P6Xtw+WgX8NhCdNX?=
 =?us-ascii?Q?xlXQB4Iqcdwg5eHhDQhoGn4sja7z2Pco8x0epo3LJziDd5I3KRKWHZgGgXBM?=
 =?us-ascii?Q?aUTtCx7NjwxeCHc26u8yV1PbqPt6LZhCSL+7lDX/VTBKrtd7L4wfjuk0ysk/?=
 =?us-ascii?Q?4eQMjO9BBFkirnznMfuNYj3blmG6pmyLXawQmbsQ2uBTEnV38bE64iu6ELQ/?=
 =?us-ascii?Q?lT26RNI4VSgqCZIAx81dm5JmeXP7nLeTCxA7wlluOkC/DpH91xjNpZ/WBIJa?=
 =?us-ascii?Q?kco4iO6eCUHwRPCAMmrVg9bhgT8nGS7ZIjNbujXwInWo0ZFDlowb51B7nLOi?=
 =?us-ascii?Q?Jxdb+4/Te297CFRho68Omrmn+NwFZwlBKOvkIB/O6r+pdIo/pPffFiDyqZT4?=
 =?us-ascii?Q?9wNNUvsn1FNk568NdHP3kDLHx8E8WED4OYpeoGb0lRJ5att0O8GS1uSY+Ba1?=
 =?us-ascii?Q?GmYQqb03mffvlrfT+S+ZmDSv9xldZB2wJM6wKd2vzlVgWEIRj9QqGpJe+Iiz?=
 =?us-ascii?Q?ecgNJnSS90GBl7Mw0ucOxMWe53Ok0HbEiuTKJLdetKDKS3gzWSsYlJo20XiE?=
 =?us-ascii?Q?Gdymqxy0r42RPanC9b7f7IU6mrPxDPNZT/sGpB/EsvevkLkktIsEdQn7J+tP?=
 =?us-ascii?Q?I8VQy0O8T4LxRaI/JGbevTKAWZF7Oq875V0W+TBJgBDHNuL14g6m0gsSjtm+?=
 =?us-ascii?Q?NYxV3zdiYXEN3/wOtmx4RB58CUro8nUZIHQFjgNWWIwi9JHFwD6j7IcVpN/V?=
 =?us-ascii?Q?EgMgcVqTeC6Lytv9waK9WYNgpPXKCJ6qiNysx6BnhXY/WDqlybbXXxBA6fSa?=
 =?us-ascii?Q?X29ALUn1O4q/Bh5pQdbyczlMPh3hZRdGj7pnA4t6aH9gjrrLbxsavxmMf+Cm?=
 =?us-ascii?Q?TPP+9wdRR2P+4bnmMVbv7bR0BV5/5Yy7V0z6Ji5we4ovIVvwIXgTC5I3tmVn?=
 =?us-ascii?Q?u3AduyZ5KqZMI2VTjR4BBd+HOzJfW1T35dJFZf+yQSMYZwk9wwBIhpW7KCL6?=
 =?us-ascii?Q?hrubEqJivjH8bAxC1XeEw9sGPaYXzb/1tRVCf4RHbgp7dalAMFTXUND1Reeg?=
 =?us-ascii?Q?hFKjc7f3lxfN/eA0DHNqCVGnBqgrMwFtKCiXOcjVstXr9q+5tX04ec8Oevbx?=
 =?us-ascii?Q?I6cmXJZ/LWMIVqQu9XmFwz+/d4KO5BXM0saw3izN5haOuItBaCz4XJ2dTtBj?=
 =?us-ascii?Q?QYPusOGMVEvxtX/iLOExOms=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccf9d27-450b-4862-7ecb-08d9ab07e9e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:54:32.8085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qG139Tp22FZu4cfCXDmKxdhawdRjFq+7BqXZAE6PP4vQaHSP3DOwVqjk0kxRpxmilJsHE+H0MVMMpqXQfvSRfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-Proofpoint-GUID: A5ohj3qpsnnwWgpyYC-mt3LYXTejlJi7
X-Proofpoint-ORIG-GUID: A5ohj3qpsnnwWgpyYC-mt3LYXTejlJi7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=832 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 4691ffb18ac908609aab07d13af7995b6b89d33c upstream.

Fix system hang with below sequences:
~# ifconfig ethx down
~# ifconfig ethx hw ether xx:xx:xx:xx:xx:xx

After ethx down, stmmac all clocks gated off and then register access causes
system hang.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 51626edc6a4c..cccf98f66ff4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4324,12 +4324,21 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	int ret = 0;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	ret = eth_mac_addr(ndev, addr);
 	if (ret)
-		return ret;
+		goto set_mac_error;
 
 	stmmac_set_umac_addr(priv, priv->hw, ndev->dev_addr, 0);
 
+set_mac_error:
+	pm_runtime_put(priv->device);
+
 	return ret;
 }
 
-- 
2.17.1

