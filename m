Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711FC4F9DEE
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiDHUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiDHUHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:05 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1318430F9D9
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:05:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKIEtHfSeLKY7dokDBHtzYrG31MFLJPDQIQyWSC0wMjgbHmUXHaT6DaEcv+68Oj5rvx1PODUUCn/GFYIpLAKAgZ2uU/LXppDc8pYsqmCNBCNbTarzD4TVfzlYwaM0bub8YRJBb89OGeNq37zrMtWy1GWs3JgYZ2QHXBSQViHt3ka6EOgn6lAr94lTjBTnpqeLLHJX78IcBB+1i1aMllrMDYFgGOExzwP/wrWaaDK+DG0vyPJbaSXwK3R91E4T2WSmXR5pnoG+LUUNtQAlXtFUYtAiw8BOjN+MO6JvctFvKip3Q1F6SUIdttkLsweiRxYlSaykRJHTqNnNqgFkQxvAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8XJs2HctDnAcY9uW3RgK2Bxe/yK2I+S5Jb9xusMG18=;
 b=m0KSkP30BmD8ilbmDLuCDjlN8Gw9CHWh8AJLkCumfmC8TkVyi/Swldb3lSchIS7AAnbwSWqlLGYhVpu5iH0oWGPR/NpHtdkGTgIR018K9vQquRiLCCQGXrzRWl+CDNYJn/1fAkDCpNLDYqE+ki6I9Tu8rU1JowPXjmOwxV/LPgs/Tsdzrzi78cuDGM81GxeDBVNTKHiDLJW0tvOINAQ3ZgetKoFiPtQQQhzqDZogLIKRXNXXUCN5qU9hBbpwX4ntpA60IDOzDLKFBxXuVebXTXBbaxK/tcp2UIkD2mlUSk59N0qt6vgIrSC7Fd9jTYKaehvKPu6suhkW3IBOnaKQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8XJs2HctDnAcY9uW3RgK2Bxe/yK2I+S5Jb9xusMG18=;
 b=D0Pfyiq0oagZ4DiHJc/azfr0TF0v73mN+M6FSA+emcLazRvI57G373/Fgf+WzBBmghZ1rsy736dcL27gHS7zK1VFqRC1TjuLRLJDhr2qRrdHCqenIkSDW4ZaoL278RVcq/Ce0rsz3Z2czF6I0RCpM7pIVzU3tKnhn6RK0X0urig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:04:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:04:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 2/6] net: emit NETDEV_CHANGE for changes to IFF_PROMISC | IFF_ALLMULTI
Date:   Fri,  8 Apr 2022 23:03:33 +0300
Message-Id: <20220408200337.718067-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6073d333-634f-43be-7ded-08da199b0e5b
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4275BB1FE5A2FCEF095E3A55E0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /8+xr94eKVBMVkZRbRag1CznsFWpaZgX+fVih/UjTOWhWocEAgVchlEdED8LspoUcITgmSlO0N/m6cOzPVf++WN6oqPXTHAtrBrJ01NF10xu6tsTsH/R9Eci3v62Xpno4YB42pgo7mL+IOH2FXTZdiKixz96RYNTJG8gxXL5nDFuHk7TCwkOS7WzAS2c5Kzi75gGLhh1e0fMXVv6kUnn9IcATV8n0OWrhFrcNSX0/+i5g/d1v2JWTC6K1dSdcVEuNqkCpyaHekCrGfjnXp4PiNqOVJmzsE/Gyl9foTwDo+heIhGb/DS8DHcYIjhh/cnjsdfBHyrzDJpKbvX0G03xBX8cDYzTATnal/kv9JBaknvCNR1TVvFhp4hq+eL5Pu5yy7hpRS1lLVltvsYPdg68QXMxREBPw8cFjdW25FKy9vfM0T9mei3JhsBEAOL/Ai2CKAV7g+POy3FiuC+SjeiszTCHcLOpi9ihlavlyb6BYkPGo0hkl0ugeFj9S2fOm5GAAqk82f0xm2grnUSnlBccYDYIYzNoALxIbN05CFO9K9QNm0R92yOEeSFUfnm2K7L9scqwRRJrfcitJZjw6FgJOOyw4IdTRS3hy88RbVLvYrYym7TtEXq114pitu1iEoKtVWrHOmU2I6mUOtmoQ0d+P9xcCxYwMPhm6B2NnVuFtF0Fzb6zQM97TXoJUKOxa+GdEWB4Fo/p57R3eTxbCvuJYhinXsZvzxBpPyTXCfYDEb5vOJq2kuBzPkLpVCUm7D+ps6NH3ifFrdxl/+KnIclJiHwcGySyAn9Rohh6QozQoGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(966005)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fzD2hCxXKM0HG0Lk4NjhSjl7+lWKK4EFzVN4JuqjHFiQsWyUDgvCVAnnJ+ZI?=
 =?us-ascii?Q?9ef7K9x5QgKWu/zphrNdwrnnTB4g1f+tUTTR4JiQECDR6WcaZCKvrEEGjSnH?=
 =?us-ascii?Q?HQQVC/99lCi/HJvg0z6UOmr8lJRSUKLBjeanVachjw7w0gHyTgZ09MbaqhQa?=
 =?us-ascii?Q?rC/xJDW7+mkrD+wQ3jhu7/h7Zp+XtmIEj1hSvf1sCeC3fCHcSyZBcEUoaQ0k?=
 =?us-ascii?Q?Cipv4p2tCc0tmkqJUfCQm2SLjCPH5TA2tALbqx+oJdIRuX9bUhzm2rhFwkNa?=
 =?us-ascii?Q?AeZUewAsfLzUj/eVuLWg7kqbwSetkqUyLOgH5T9QGsMVB4zOaR0R06hpnHrs?=
 =?us-ascii?Q?PJ7NE1T1gMXiMi7sH07HXZRuWBrX6DXIYcEJh8go9fSC5BOmMa7o7mg3I2Ga?=
 =?us-ascii?Q?7B1CZTNhdOpy9lXt4V8jOuALZAW28g03qhQAGhx9vGwracuC/M9VtMbxyX4O?=
 =?us-ascii?Q?ZCDBwp/DuDpGJQzgD8A76mMKFVZ4MROEexGNTZcobHnOttYVuoG8pwricXRZ?=
 =?us-ascii?Q?pGpbxb3Qhn+dVEKpMHDUfmMhpWW263Yn5oXqip+0h7Lv5Kx65knbb6of49Xn?=
 =?us-ascii?Q?MiYU+vQ2lKaWZmW88VfMBOEDakrSOehj2qZrhxKS3bGDOx9X3XpB4vokJ0uG?=
 =?us-ascii?Q?bJb8XQk/N1j8H4Zn8i4xxbdfBAt+TsAoC0K323yCG4FVYgiGhAPIaQHV2b81?=
 =?us-ascii?Q?CU7cx708+MHD6htNSxnNB7Zbobw05vd/njjzy9CEpezRmFgXQQwJEGn9n5rg?=
 =?us-ascii?Q?sAFETQLSKDnOERHE0xt0MUCDADk6jZ/CAnCzpOAINPfXo1u37C77c68qjk4S?=
 =?us-ascii?Q?mmpAeMJtQP9p9btrQm8X1SD1S4MN8wpIiGDb5ZMIaDNuz4F7DdelPUW+S4Lr?=
 =?us-ascii?Q?THTbEcaCrFEBIDzxzB7CYDpt743zgUyp3ZUqAxwKIH3TD22HGsRxttRb3nNb?=
 =?us-ascii?Q?N7e27BZnubI0/yTIvHddC1N7ENnD7KESWO26UQnsSnEjPbGCCIMN3umoKniv?=
 =?us-ascii?Q?+y2yGRsqGG6tjwfPPY4vEbp3ytRCDgR6etXSJM/bSlKJViKm5lGLUUDRaU8E?=
 =?us-ascii?Q?CIlIoNw//nx8N3qjBJEMkoaSl7s2tkx3PmATCL6nkyAKCkBi8tUZTDVTkzwO?=
 =?us-ascii?Q?dE+MR9yb4Xnou8U6ZpNLhhl8g3BNFDFEbkSnMzOSVL2Jxfj+3WlTbTk7jZE9?=
 =?us-ascii?Q?6qZ/KgR21uU7P/rYVtaNrgrkvaVWaneq1XwUSbsronPKwGe27wtrWl+OUVNa?=
 =?us-ascii?Q?bhTQ+GsCbsyxZxH/rgk2MPey0oiKc4CM2JdDmr0qX7/WxfrpAcsDYjg9ueUO?=
 =?us-ascii?Q?Cw0oAXhPvrJc7DE4LdHPIOm5N+Q+hSYrtIru8w5mYmtNUNHot/HAPCmwvJcN?=
 =?us-ascii?Q?UwP9GBA5ojxqExZIYuzrRkylzTD3clRg2wS0p56KKEAO5pgGYdgK9n+qeT6T?=
 =?us-ascii?Q?K0sD83N33OQ5cV6SedZ/4elDCR06FzEFHnPo+qkuLOdQZTolu2fEoHypGWAm?=
 =?us-ascii?Q?gUxnPXSW29l1AUeXrdpv6OSt6yyQpuTTdG6svZ9kK1vcNu4liqndpivTrZF/?=
 =?us-ascii?Q?H5dxgN5UPPKyOozH7HOWPY8crYu1bg5Wo2Ih8EOET4J3rTAqsoZaozbELTJa?=
 =?us-ascii?Q?blpWRBoYUMfmoQnqg6uTcq3XNJPxrM/WLI6S2MwTaRoNZMBdrdecPewdm552?=
 =?us-ascii?Q?nm6kYyS/zLC/8+KntM6sR2Zy38E4OPVOnopN23/58/dw0RZ0UGw0hPalAcTe?=
 =?us-ascii?Q?b66GW/ToWXA989atgtgVlCEKGGpQW4Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6073d333-634f-43be-7ded-08da199b0e5b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:04:57.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gram3neIl9EhT9ZhD7tquLPx0heyqPbRppR+ZHGXaJl28ZSlIlS6IREki6m8CIRYxKXOBJ++RXcwC4XSrSlf4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers may be interested in the change in promiscuity on other
devices, like for example switchdev drivers may be interested in a
promiscuity change on the bridge. In fact this was also suggested as a
valid thing to do a while ago by Jiri Pirko:
https://lore.kernel.org/all/20190829182957.GA17530@lunn.ch/t/#m6de7937f694ab1375723bab7c53a7fb2d3595332

yet it doesn't work. This is because, for probably legacy reasons,
__dev_notify_flags() omits changes to IFF_PROMISC | IFF_ALLMULTI
(RX flags), as well as a bunch of other flags (maybe simply because it
wasn't needed, maybe because of other reasons).

It may be tempting to hook this into (actually remove the restriction
from) __dev_notify_flags(), but that is an unreliable place to put it,
since __dev_set_promiscuity() may be called with "notify=false" and we'd
still like to emit the NETDEV_CHANGE anyway.

So put the netdev notifier call right next to the dev_change_rx_flags()
call, for both IFF_PROMISC and IFF_ALLMULTI.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 433f006a796b..2fc754018a2e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8252,6 +8252,7 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 		}
 
 		dev_change_rx_flags(dev, IFF_PROMISC);
+		__netdev_state_change(dev, IFF_PROMISC);
 	}
 	if (notify)
 		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
@@ -8306,6 +8307,7 @@ static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
 	}
 	if (dev->flags ^ old_flags) {
 		dev_change_rx_flags(dev, IFF_ALLMULTI);
+		__netdev_state_change(dev, IFF_ALLMULTI);
 		dev_set_rx_mode(dev);
 		if (notify)
 			__dev_notify_flags(dev, old_flags,
-- 
2.25.1

