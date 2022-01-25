Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AE149B9E4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381320AbiAYROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:14:31 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:11557 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1392182AbiAYRMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:12:23 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBvDA0004742;
        Tue, 25 Jan 2022 12:12:11 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0y7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:12:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHsBxg5RW5QeBQZraky7B4C4ia+P5hH/D2bFY7jorqEj5vDip7tDOR9n5qceWaEC6/Y++7zAniI66GfZVyVM7vuNA1R9S4trnNcjcJc8tu02/leUvP6nk0QZH0WmHvwBSX6U2CvnT/heX0AsRbj3bFABYsUZVRO+mw0xrxX940SjhnpT0Ne0+R95twIOw9sHrqKttco++anM0ps3odObh8s9UOQ3xQSA1Ocmy/0sv+jrCMXTlSfWGoCqGnjFxzfSB+lrLYKf8oK86IYL9fWevlKytQl8Z3N4nEicI6BGbD8aCWxNXEzwh0DHzLQO3EaLy33QV3G+iKl4oXRx8dccxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcg329DL2Nfk/YbSd8kLr5YjWlnL4qcBO7yCk1Xjulo=;
 b=FQroiAW3xcM9UZohkVDMYKkNUUsXrMFUR5OBjKsRczcFGI5WRLF8g3QeeIQlW4TmDrVQd7Z6wfOsuzpM7d3sibpNeI6Tuh6i3YmqptncH6/gvoyMeZkRrBc2dT5Gr0rszXmKaP+Cu7PIaXFST3IPMkspR1Hh6Juh4uFLaFDw77pjvjHMvFLtnIylWgnzd5WsloisN6dAsaANkII59rhZWqiW8Zp8hnzIFHw0FObt3qNw9dlsLoLQD+uWAd80UkOcIvSn+U2rNIwXG4G0vPZ7prmUFGy0cMN9L6XuYcGa63vAdfFt508FCeIXUqG4uuzPsIhvJg84SuWSxaM7LYYZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcg329DL2Nfk/YbSd8kLr5YjWlnL4qcBO7yCk1Xjulo=;
 b=4xiJjHeUClgSBlma9CCAduw3DfnG6wlziNs63I5q1G/o4KE5ttF3IzoMxBfKAnFy3FPkMnwaYBGrmH2TBzDptxJTI2OonhbhKRnD8iiQ9RotTJt3oj6nioBl7rxArICMAdrorajFVpANG7WyKSy8+GYBhhnnx5GWS6zXv6V+ZV8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR0101MB1992.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.13; Tue, 25 Jan
 2022 17:12:09 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 17:12:09 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/2] net: dsa: microchip: Add property to disable reference clock
Date:   Tue, 25 Jan 2022 11:11:40 -0600
Message-Id: <20220125171140.258190-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125171140.258190-1-robert.hancock@calian.com>
References: <20220125171140.258190-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0020.namprd12.prod.outlook.com
 (2603:10b6:301:4a::30) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5643a01a-6443-4220-f987-08d9e025d212
X-MS-TrafficTypeDiagnostic: YQXPR0101MB1992:EE_
X-Microsoft-Antispam-PRVS: <YQXPR0101MB19921D93C92FE70201C32E53EC5F9@YQXPR0101MB1992.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YF2bfDLM/kMNps7dU0yhvIevSXfRn2ja0wCl+3JXXbi/g7/uiQ/FfVZr0Wp52rccfL3ZiVEknGv95t1ymumhpwMzos0y89hx0se85+xcdStf3o5VJBY6ZfULKbjbZTnMbwp+CkgnMW/tBgR6WTXu+Gq/jTdIoqCKfd/NCAmJ30mnT6Lg+IFUtyVLJENktfYq4lW/vGzw5tRKCz9wZGIpjsj8smwbsms75UrUD+wCNrBCfunzjvI3qes73F5RBG94BD0corjSAQDjuC1xfJJBQGi/odVwQRjAYh9a7wY8WnlG4D8huQqfCmBjSy5qLb3kIomXMwec3Mm43cMQfpehQobj8sDn3xmgRtz3LTymqVlg2npBDxSJWGU7fbSLGfuSMtYGglNTC1h2m0NJhNBu6mMD1GZV/+TcCgA1Ge1U+lTtBi8L7GY1cYpEn+RQZGaMrtzFo+K4eY2Rw/IyNdvfxMC6UWS3vwc1+c+8StUjODqHr2JA5JDUME93j4hcxs1I8bT6/TFc2QWtfee9nSdfkdjDZ41pPFTKa/prXCVc4Yu1AANN8ECyMRSKR1efDTu7/1o6N6gvrMgmvO+DwyKB9CR233yfDwf12YZq8Jkl8/6IjS05ixGA7owxk4TF12T23tgAOGN70++Yk7o3BwXZ4DJYryFwUhT/LAEBoHuvTPG5UkE9xNDaJ/2dXb4g80dewuRJJ94I9mp/kE83m3Q1aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(186003)(66946007)(44832011)(8676002)(36756003)(8936002)(66556008)(26005)(5660300002)(86362001)(4326008)(107886003)(6916009)(7416002)(38350700002)(1076003)(83380400001)(38100700002)(66476007)(2616005)(52116002)(6506007)(6666004)(6512007)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ge8j9oz+qXc9sugkeu4RHCp4mazgZvH2CbWCQXq0kg2RLTlCs+5XmTJDOXzj?=
 =?us-ascii?Q?9kbHLnmDuxYn28Jj0+gixiZd3iqnNB4g4H7IZf8kqv92zbG1bO6YOA7L7Ezy?=
 =?us-ascii?Q?NEBx1XLu/RaB4NbWb0Pz6gGZoxrFSq7GxsTgX8oZIhojfBNmQZ1ehSTvsP0x?=
 =?us-ascii?Q?FtDPYNniu2Fq6qcEP0XMJYWuiE6vD/KJi7k+v2gq1Ksbc9S9VhquusjpRPmp?=
 =?us-ascii?Q?WfGkaF/8x0s65zYG4EHP4mqneR4hD6Ayzx2qMGZNauzLZuPTs6RRNxEkkM3K?=
 =?us-ascii?Q?OvZtVUX6mZIXK5VmnSP+xIYaj1xXmkwhAWrr9ogG6XOtWN+BGZe+LXmsHk9k?=
 =?us-ascii?Q?zwxlSA9DIYrUrryuQchXuGvTvVainnN2tr1N9Y1NeFsYvW8ojrnD7COBW62H?=
 =?us-ascii?Q?jBk3dJln2SKEGUx6R6uZcb/n2P/V0kVg7GWDaRVbYx9fJI/S/ubiCpZo/+T2?=
 =?us-ascii?Q?SekO5/iJRxxjnIbplyd49hLyN9gFSNF6jMPUYU57LPo6Rb2TWboZVB2/ZuY/?=
 =?us-ascii?Q?MR8ecmUrJOfvRqob7XuR1jTwkZWdMBPEYLUOeARR3KeArRCdQ5GfXtjfJXOx?=
 =?us-ascii?Q?29Xgb6OXTc5xgTFZ/LPwvStpZBk+D3XRkTF8mMNEE/E2NmelZFasrawIpATR?=
 =?us-ascii?Q?DcPrNzY0x0JvdA8pL50nfsYti67m7WDgd0GaASFqDZrGxWN8jh5pjtZrpMaG?=
 =?us-ascii?Q?qtJORhLx2R5chlsxPBY/IrsAuSppcmXDigW6yQCSk6a28xvonf5gsTbRxM2v?=
 =?us-ascii?Q?nqAr/DtcBv3Id7hQRivV7NgGHhE9suumgN1+9ILugVllW4nPWkQHbV4tQHCL?=
 =?us-ascii?Q?tiMvAIUztPObMhRFucfW5aOX4yGQAO1tLNygGV0BUEPAeQRMUADHn3qFtJwI?=
 =?us-ascii?Q?X8xbLf94zxDWEJka1YXruZwbo/xJwwH9U8t2POAkZaH0clVdgDHW1J+RzQV2?=
 =?us-ascii?Q?OPmH0o+8wYuxFT2l39TT8OmnzDxwlMoCwZ7U/1ZGtfUR2UtmliiqzmOjfSt3?=
 =?us-ascii?Q?XDCFYodvX+zu6qdUUqyESAI+Pq2cdqnVBLFVgiyv8p4ZVRBUH4RooGPOYWfT?=
 =?us-ascii?Q?QNKFJ6OKBEqe4/BdNryahw6bTCvzvOPBuk0IM/VbSXj4oZTqfAiCTvKevgps?=
 =?us-ascii?Q?Sb3rKx+/QfN0cDJ5YJArH0US8fCnA6X96qqmbvKxyVijkiQxfuq0DN2k1PtG?=
 =?us-ascii?Q?jxAZUFZvQ452Sf5ua1zYzpXD7EDlw9yPB1Z6+VTnsb0Ls7nOEQMAlUwdyRJf?=
 =?us-ascii?Q?7hFWigM7+Nq8XyRLY5QegYOu2FNgKC2palBGsvaycN/AYTYdybSYTcWLhjxK?=
 =?us-ascii?Q?rT85ZVKpwiLxNDaQcDBw/e6nDlXqLZJmGeSi5cju8qtAD3KKnsifg7fTSYJy?=
 =?us-ascii?Q?Tp8zdJMlbnJIXgf8RkZ/skzB/XwJJCsZM41oH3iMN8nUUc2qsc+E4mHgubs+?=
 =?us-ascii?Q?gRjbYW4tGT7v0wwHRMPPcuKChHRXXHlRhMcZ1i2wb7OesOUlTQ184+lbV5qx?=
 =?us-ascii?Q?3+NQcFIIncvBzgypvPVU1FkQYdec6pNRP8G5brUlM6X0B5DPU5WKHD725yGF?=
 =?us-ascii?Q?7495x+GDmOot0rXmEarZdzidHH0ytyoCUVwPnU4xJPwRkglt887ahn7JDp72?=
 =?us-ascii?Q?utd9rImIMIXu4sZh0KnB22pstFFzUW6d6clXTY+AqvqWURL55qA8Pr1U6w8c?=
 =?us-ascii?Q?JeaDudnWwgTBZSqlzuE3JHZ8uDM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5643a01a-6443-4220-f987-08d9e025d212
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 17:12:09.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgQFLZxiGhfzbYkj7BhsuSMMbwWEPOezUSk/Om7Dn3zhufoUzVtnrmF9o7O6ErE27Xmr4Hi4Z7qPicdDO1en+XZj8mhoIPMq/ZcVuNKL74E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB1992
X-Proofpoint-ORIG-GUID: DqmbLuKDlCQjesR0Djkla31m3I7OH8sX
X-Proofpoint-GUID: DqmbLuKDlCQjesR0Djkla31m3I7OH8sX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=695
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new microchip,synclko-disable property which can be specified
to disable the reference clock output from the device if not required
by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c | 2 ++
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 353b5f981740..33d52050cd68 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -222,9 +222,14 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	if (dev->synclko_125)
+	if (dev->synclko_disable)
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, 0);
+	else if (dev->synclko_125)
 		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
 			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
+	else
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+			   SW_ENABLE_REFCLKO);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55dbda04ea62..0a524f1f227a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -434,6 +434,8 @@ int ksz_switch_register(struct ksz_device *dev,
 			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
+		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
+							     "microchip,synclko-disable");
 	}
 
 	ret = dsa_register_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df8ae59c8525..3db63f62f0a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -75,6 +75,7 @@ struct ksz_device {
 	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
+	bool synclko_disable;
 
 	struct vlan_table *vlan_cache;
 
-- 
2.31.1

