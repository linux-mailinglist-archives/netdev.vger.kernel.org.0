Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEF4452AB4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhKPG2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:28:41 -0500
Received: from mail-bn8nam12on2092.outbound.protection.outlook.com ([40.107.237.92]:48451
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230347AbhKPG1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ada02No2Bl14pUcezpmePNI7FVrCriF82l+iFi7ahMFq0+qVccH2/fo187drZutaZ3/L/xWiowZSCEzTKL6qb65/HlLfRZ2NhnB1OuZCrsakHxRzT52DFJ6WOCCVR0eis1RmcxjZ0ho1e2eBSy1wc09yTlo7M+oGWRrr5DnxSItJhbIbyuY8etLgEcMR6VH0S18AoNRqGKgfq10I5YFbF0CXjSofwWLPeOlN32CZOscnKQfB+algAEh+wKX7ejgj9yYEfnX/PCjjWBU3t6LVSfFg9hgwgLU2sxvcAYC8nI3YVQKu+KZ7yKhoCsOpljQpo2HyIY3EtKB7l00P864JIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsQvCcoN1ya9H9lyAdQq4tD5YpOPIRUXipAnY7zRVYA=;
 b=B7QO0NeWMYy7+x+M24omIE0wr5jUZ/yMv0HcDqAc/Z7hA6JXp40R/ieT8p25NxYueG2s2MNjZ99obQJlow60aXBJE2zIIJoqxzVFD27tslnkn8uNpIMkqPIrrKF5840wxocs6+rZu3X/A1dPg5D7ySO1S6O75y87AEjIbtvmb7mXjEqaQRKqMhGfTucFsOYPhafC0pr+Rr5+/34b3yAHhDdKEmUC8NiNIA+QmFh/P7g/7vF8WeFiVbqH3z93rv85oeEtpOIGZMs3frzuqhsxkPWhlTFd6vn8QNMcpGhrXpvFTRaCha0uAcdId/6kaEVryQFWRyrHxB/uCob84WQ3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsQvCcoN1ya9H9lyAdQq4tD5YpOPIRUXipAnY7zRVYA=;
 b=GH4dSUwE3MHWsZE9vzoo3J6N0zL6743pLAhfInt182KEjc8Fc3upyr80LvQh8acGqclvEUcZ0JQcv7Cv2tdfyASL1AKCpuYAJFhnYfRp+V9fj+BFEXfE9ReGdDNSSZ/MzNZUqQoHz89Me0fCuNycgcYyoTNtavNEmzDU2CgunWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1501.namprd10.prod.outlook.com
 (2603:10b6:300:24::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:59 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 21/23] net: ethernet: enetc: name change for clarity from pcs to mdio_device
Date:   Mon, 15 Nov 2021 22:23:26 -0800
Message-Id: <20211116062328.1949151-22-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e916da9a-195c-41fb-264e-08d9a8c9ac9d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1501:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1501E39A02E59CF3A8BB8E32A4999@MWHPR10MB1501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWLnwdr2GCIiayFpDcW6MqHJRfFg/Non6mNJqklBwUX+plxfjoepDyZ3NnMqvcnORy+sJHz7Wm6EYV8t0f2u17Vt8ArpBCWCr3+ey2NwPRTM7Ftel9JZ/0KBumkeaW4GauSMHJ9n9mQK9fy24MrmrYbBQOMapRD3hRA0JIzhfjB7jc1B5BSQQ59jWVa2rA8huPSdPHCPczR4/nBzyZ626uRfYW+ebl6NmLHJaxUweUgWkRPMEDpwxGMuN0/F/o+YFdPpvtE/9figMrUgpHpfUl1GoHHyzEbV+uhwFL45174LgTbuzow1rNXxzkDTCFyj0Np6NVitkS+G6Wv5u+BJUwiv/IUDb8K/kMg8Q3zq3WwGdRVgYstoLr82yFmpBkV9e/61dKXQ1QkbEaePgNXmgFxRD8VlOtNg6lw/eYkWPRfZ8rMuv3mEwloNyQZoplnA7sjlkU4XTyjObw8dGHUSaeJEfgzg6KVkUIsM1W8GPFtTsmLu48LR3E/+6Tu3rC27BikwNbO1tLYWSfXiVSo/M/NtdhOeuX+wvslvDLTRZzdAor+94K4w4LfK86a33g1lHTvrDZfYDsHBXfWIgykUtPJmp+Z3SelwjCgtee+By66rIkEUVpV+1ZyJBXeAnp+vFSct/5s0nwwvYPeUIlgO9wUbOZfcJvRy1jj96nd20vI9JNd9/bwygLDeRtkoQ1qG93aqqn8FfVQnLPIoGNXJhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(39840400004)(346002)(4326008)(2616005)(956004)(186003)(44832011)(7416002)(6506007)(1076003)(26005)(86362001)(6486002)(38350700002)(66946007)(54906003)(36756003)(38100700002)(316002)(6512007)(5660300002)(2906002)(508600001)(66556008)(8676002)(66476007)(6666004)(8936002)(83380400001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68OxWCR6wt3ZjsRnutmBZheoW2+qvrobTZraqTNII4M1tKP+F6dXU59MaABa?=
 =?us-ascii?Q?JEQWSVEDYLSvLfzblj8/qg0x9nTsGomye/iXGYRqqFvvtztEwotMsCmFJKDc?=
 =?us-ascii?Q?9UcG4myfnhUSVzCiIrhgHFk2URDy841C6g6pLjuCVBa+H9EWWtcs1HlgymoP?=
 =?us-ascii?Q?2X0TtEENBX5oWXXMcROXhgEf+Uea/Yul4luriQhB26b0GAjZJRlgjgIGs0Bc?=
 =?us-ascii?Q?HLn/s6MqaXmv6k/p7csyLvqLFBnRJvpD4sIgxlYoJwrnXmAOk9nyl0ZCLKr6?=
 =?us-ascii?Q?MuFDeaKQ+VgVCnfk7h8TGYJpUR6xGmZd2FvPhFP77E92EyJM5ORHSmlDqPEI?=
 =?us-ascii?Q?mG2jMOvXXY1EBayReUj+NpAkx6aqggcMKZOgnE/6+R+wxL9/x7/lf1bVtrjG?=
 =?us-ascii?Q?Q9asAcCmx9vJGhxC2EfpHtYiyHSDc5jQE9B/0/Uw7RgQo7F1EPfoueukAOS+?=
 =?us-ascii?Q?sAGum1KT2E33iM6zpprTypZjv8KjRcY3CnFxUPqfh5A0pTd7YzqsqiuUocxr?=
 =?us-ascii?Q?rDwDrHEUMPM4RxZdeORlW3h5jwt6N4s1WNo+9w/cjoTkfq0VB+8JhfeqDmCt?=
 =?us-ascii?Q?6/VJRYe6ParhA0+Zt2WcvNkJJzvUOICUZ9YBPnTwk8HPZhnDDnF44GsvJoxD?=
 =?us-ascii?Q?8P3u9GU0xebJOVgSZf3Qd+VR7wsIBvKAC39EKdQ4wCPqCljd5DHAfnIER/ez?=
 =?us-ascii?Q?ANob6MrcwtaJYoGvuG/+yGf0i4fTKxb4/xp3obvPj0RDHxeQhi6zI5lV4QyS?=
 =?us-ascii?Q?azEZEVHfCzfnwQB+17M+ps8aiiqUEwcQFQmW6aPMceMAZMPM0tXAabJOTWBM?=
 =?us-ascii?Q?Eu2oni09xTjD+PY/2bMTKZ2OtgD7EWZ6eswiQ7T0NDwtGizX/Xt3RRKSP6tn?=
 =?us-ascii?Q?WrWV7aRE2LWtvoUTAwTtTM383lnKsz98mvJDa9341LbZzBGmLcX05fx0xfMZ?=
 =?us-ascii?Q?jMQADtYxiRUDAqyeAClmvK0hzz6JDXGDn7oELp5Vil+b9wEr/SZ2vo4iOUxX?=
 =?us-ascii?Q?MvI2P9ITxwCeTI1BGmF+zqa1spYC45S3+XU+Y9WmE2db36kiyicWUEM+w9o7?=
 =?us-ascii?Q?wvNuT7fW6UPSplMVfE+6fDJ4l+6Wzcbqfd9Ok/N7EuC0GyBKjcVOyPGNSDyr?=
 =?us-ascii?Q?BzL0ap5/NWIBjrslgh8pQakouEt7N5qfXAA57Rb4ZihN91qhjRfHO49o9JH5?=
 =?us-ascii?Q?u0MJQFDXifKYIA6qBBqLmvRLFw1/u3gAI62Yp2Scx//DS88lTdqx3mTYbCyx?=
 =?us-ascii?Q?b7qFZaq8KuuUFFd5EXOZCDMiU77F9ZHKemKiXN3puftAldzX/VzXrNvj18J+?=
 =?us-ascii?Q?YwEHakENVTX6LXM/V3dkM8jki7VQw8Ua6a3a4DcCs3RmwBJquBaNa+O7hKbZ?=
 =?us-ascii?Q?aeegREV+TT06Yu7Tm41V98ctzm8y6yEHXDzTuZVxanhm/ualeRSJP4UE4ttY?=
 =?us-ascii?Q?rbTk26iG7jzIsRhpkZLEt092U+B2DVQQq5dBtU3IWkqwv8NgpPKMSFMC3TTb?=
 =?us-ascii?Q?pQ0bweq3+qcCoeIqUFd2Q8CwVj3W2Y8cjUEzXIo9UZi19ZQqBkWRzN1BQIQX?=
 =?us-ascii?Q?zYU9OFpPn5rsMF4wO+hV4yIqhz/DCm/CQj5AlxxXT4NxLOCD+6T0JHtRev/q?=
 =?us-ascii?Q?PaoaNCW9dGcMXTVd7AL4O1Mt7hr2PDMk8LfLUeIKeCmzUeYIw4ke9j8oiRHR?=
 =?us-ascii?Q?38vGmxVDwdyOF2A4OHLp+NpQg/Q=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e916da9a-195c-41fb-264e-08d9a8c9ac9d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:58.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7GkHt8hVjG44/FuFgaBSKkL0T4sM9gjlkeepuukjQUPJeHN+A3DsB+2Vmout5K8rVg9IBzKDKvSUd/+UcVGV3Vn/uofZ8XLKQ7yoI37EuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple variable update from "pcs" to "mdio_device" for the mdio device
will make things a little cleaner.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 125a539b0654..3d93ac1376c6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -829,7 +829,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *pcs;
+	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -853,16 +853,16 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	pcs = mdio_device_create(bus, 0);
-	if (IS_ERR(pcs)) {
-		err = PTR_ERR(pcs);
-		dev_err(dev, "cannot create pcs (%d)\n", err);
+	mdio_device = mdio_device_create(bus, 0);
+	if (IS_ERR(mdio_device)) {
+		err = PTR_ERR(mdio_device);
+		dev_err(dev, "cannot create mdio device (%d)\n", err);
 		goto unregister_mdiobus;
 	}
 
-	phylink_pcs = lynx_pcs_create(pcs);
+	phylink_pcs = lynx_pcs_create(mdio_device);
 	if (!phylink_pcs) {
-		mdio_device_free(pcs);
+		mdio_device_free(mdio_device);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
-- 
2.25.1

