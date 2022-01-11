Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE09E48BA3F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiAKVzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:55:55 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:15924 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231146AbiAKVzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:55:53 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBn7j9012445;
        Tue, 11 Jan 2022 16:55:30 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs98t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:55:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOMFG/mvRju7qJa5+uFHdb+Qjm+SgdaGTCtz0f0PBYn3CYuhNdxtjddGOcCA8XQf0bfLdxm/wcQZBQWD/LgJw3yamH1q/tof0rICNMBLOvMEJkz+vQE0zgRqwy3MhOEoFpZWSDTWJUHH6OZRNpvot1ZBWc49YZXt8y6yuLu+SBzTOzGdqNJirws0U5eH5xqc//sPnDhQ0aS2aZ5QjJLXVir5kuVHL66uuICIzxVCSKaJ/Ij4jY1jjpB8T6/7KgPIwX0+W+igagt+fJfSO9HDB5X+u85m3jupHky1+bgxajn9WNbp5ltJLis3fA6fWpeKH0Wm0w5zsYeC/tkbMuJnJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2IJ6rfTfH7jDMMo1tEtHkTLUpwfD4XpBQAeUPEJr1c=;
 b=CR/LEZneXC1621mbtbHD1O3yfX8TfrjCKRPc5Fg7GN3tVWNX31BAXps02d/ePVFIM20kyUwG/b8r/8+8Hk+hOjeZcs76dY7uXnZS+K9jVkPjMqymykrf2ZNy9SwFtgqWIXosSjSsme34E+jFfgwm+FRyB1qWv3qwSGRdC409CH/8P/o1PHhLwjXcnh1zqV91azZuFM1qikTv5ivuZd9yMBcyi+5gS2wac5ed+WnOWYhpMXdrh7jGVE48YZWCs23AfjMRQdEhyFzHQeUkc/Cb09wikOCdU3hhoPhZTBdweOuF72PQMv2RFufH0ZYvQcFNFzVPCi89WkxaSPFjLK7bBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2IJ6rfTfH7jDMMo1tEtHkTLUpwfD4XpBQAeUPEJr1c=;
 b=ojtb7ZZn7PWzadVj2IvCE54nZy0BLPxpmbdq+LgRPRUnY4jDGnrf3kLoPv6vkYH16juieGfguJORzX4SeC0tVxUWUeA6Aq5/7T/LWts2ikCpIv0WO5Y4fdsaQ8LMCAlnR3vrlbuXlOBIgo1ody03/qudAUEarBR2Hi+g9PuFvCw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:24::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 21:55:29 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:55:29 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/3] at803x fiber/SFP support
Date:   Tue, 11 Jan 2022 15:55:01 -0600
Message-Id: <20220111215504.2714643-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:610:76::26) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4eb1a14-711d-407b-8a45-08d9d54d14d2
X-MS-TrafficTypeDiagnostic: YTOPR0101MB0860:EE_
X-Microsoft-Antispam-PRVS: <YTOPR0101MB08602E0454935DD0F66F81B5EC519@YTOPR0101MB0860.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYkOxDRPMqxjdsRuJhqwRF9dfn4m1twkC9Nc7J7A8mMNhZqRsZPqx33qa035BJnjaNcw6UK5ApzTazK7YYLZKrywFTJdv9iRfQzXGf6Ky8X6SgnDMKjnVHMrLdLGZTZr8hZgf3+RZG1NELdPGV7kpHsN3rglbCDXNtV75GYLi560TVIpVyOnD0isbANtyV2ADgVFCbAj+QtQoCmv2IjH+oEE7wG3jBBuhoiCXvMcYWP3UsUX09eBdC54ghJpwXUUJIHxxyPKF+bV3hHv83Oq3eQfo+yQQgWlfX2bB3AlHYZh5d/aEOH1DMwgGTR80H4+5lwKT/VWjo3yi4ag9gEP0NK+wm7vkTVOV4ZiPsOIAW/r0V7U1dERiC22BpWMsjQk8X+s98Lg0Uh+KNSt4Ra4YiM6/M22AqjECli737g9bv3wmk0pHH+i1YDQvhP/O6k8keqD+t93klNWwbxzK+hRnu9O75MAaRjLkAFk85TF7phTU4hpdZowybGvHaoFRwxe97TKjp4rq07LDA2EaN+Dm3gBN6XG8f0tvPOPhMRHW+gskH5Oh0Nzio5q2ghHZRY4TjPc8eqcB9FrhPGpcmmTa+IV9SVS0vNjXkFZejt3bvhB4XTrrpn5X+PaNW0APeHjPJEQ5H76epCjDYdF9iTbzqY9BZ7rA0m663xNKvEHJQE2yPbdOvXLMDn7yLrr6TSSto156SUYMQC8560c8iUWBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(52116002)(36756003)(186003)(6506007)(8936002)(38100700002)(6666004)(44832011)(38350700002)(6512007)(2616005)(316002)(66476007)(508600001)(83380400001)(107886003)(8676002)(86362001)(5660300002)(6916009)(66556008)(2906002)(4744005)(66946007)(4326008)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNgj89mNxIKkPRpHG8Axse7kR9htyqNUWzsmHGwWV5MLN19052DFG/FzGeiY?=
 =?us-ascii?Q?X0LCi5IHlSVNFj6Ov0c65IQtJ+yCP5XU3t1bWHsqStNVg3rVcI2qpwDSMa8R?=
 =?us-ascii?Q?Up2z2PyixU4mRj/GlTtVy2l0YmlHsFcJoABDDdZTRbq67++GSFDr3hvfv1Kd?=
 =?us-ascii?Q?qUJsPAfN7zyOjw219B0BdXp9sOcXxopTMPqxDMMgO6Nox9EiouDmS5pQpNAY?=
 =?us-ascii?Q?NRa7sY4FIr0rZYfMwPPOQkgcQnO1I7YoLo7RaxR/3DuPyv7H3k7pL6G5uGgG?=
 =?us-ascii?Q?Pp33GxlMlGqeri86Knr/vYiUb2TPKL/Q0p32BLxRNwAWxZ5IDJMfs3NMslDK?=
 =?us-ascii?Q?G2ZEtTFz+hf+4kA0p07GrRrM98MLrAieVMxS4NYZw8EbfwDmognrZ+hHA+p9?=
 =?us-ascii?Q?eWtsjNMXstP4QZ/PWrUOPekD0bFV5XCAYIzdDTQJAR0e5PzhBgBMEHD2QfdR?=
 =?us-ascii?Q?dkwJUkkL7600U+dnqpM+iEUHsPOZY9akKHhwUTbp0Z7QRmqjQILPnLajdhrr?=
 =?us-ascii?Q?3vlSkpm9JCVChdQ2vZmzN9/yflFVc+9WGY+AJ84P9JJctrO2F2sCLBpCITK3?=
 =?us-ascii?Q?/GQtt7lGToieHFyoMl9AwVfHtbgJPDjK4uhh6YhS2RRwlvh69PoTAmc3GCml?=
 =?us-ascii?Q?o5CWl2aLS9AJlCih2dLof0j0XR9hoS4Hf4KtsV/YjYzrW9t3rJu8iGTj7OYj?=
 =?us-ascii?Q?XO08B3j2MPhWKUIZfophrpcYwNz3NyhcbYfuqoqYK05KHHy2V+9xXcGiU+0M?=
 =?us-ascii?Q?aCe0n5BKzakiB9wJVx9iwle2FtHUNKe5m0Mxvynb3v5uYtVue4CXkSdWkB0b?=
 =?us-ascii?Q?VzUNnNws0KEgUUHEQFyMdls2rHb7L6/V9dkK8FxccoKKwFjlw/t9objNziPg?=
 =?us-ascii?Q?pwyaBmAwYddTXavqJd9rYTe9qcZP+xVusHqU2qJZvu58zX5uZIIxD5HuK+qD?=
 =?us-ascii?Q?v0Y7npViFcgoPbsExrt1QMV1k6aMBa7ZlVlhhxibQQZIYKuQgbZ8GSoaLz9i?=
 =?us-ascii?Q?KygAwL8YPKeTnb9yM4vAX6aq1vlCGeWhivEPQu+j6cwpArmyHhKTVCvUJCYX?=
 =?us-ascii?Q?oM5kCO9V8iI5JlX3gkRB+hNFwlZf4oKiIFDTh1Ixkgi3b2dKvB68kSEKX5VU?=
 =?us-ascii?Q?oAASozDFBjXljd0JKGRrDg5fwtq19z66DqFEGmvL7k5vb5OIm6XdrM+NXdJD?=
 =?us-ascii?Q?eGeSuxs6wBZ/51sEt/T6v4ont1zGaivKQ0zA3BISyeHmuYeWQA2F+dnqn0N2?=
 =?us-ascii?Q?Mt9oa1w+15K+eu0NgV6lvyHCwAJFBZV2Vzxvmqm+r6p49s1mLlByOZ2SH7Bq?=
 =?us-ascii?Q?pg/2G+Vq+FfIboNUmgyfmoNhY+sw95HyFAskJfAskpzMfiHxjh0eXxUKhee2?=
 =?us-ascii?Q?zaZYxu+rpjH+YiWIqv+AzdPyqQb9lEgjcwUfJhhkdTwDTLz4418Z0wIbt+q9?=
 =?us-ascii?Q?IV+CxcjyHz/X0wBl9H9N5gmUNQmFQpRiZCn4GqX2vN3DhrINbJBWAz0L6+Uv?=
 =?us-ascii?Q?D/6f2o0VpdPam7JncrZgc3Y5ZphjxceKbArc0hMu/oduGWQTN8AqCSOHn3JH?=
 =?us-ascii?Q?A6INsVpTsFB/CR+qG2m0moT6dDECeFi3Dl9T1h+rVw+tAIREkV2gdywzLefa?=
 =?us-ascii?Q?4Pc6weq3/PT2I0eAKjFgLZ60Ji6NVQ9zaE0xTV0j3hom8qNIN7Fh8wsspjBA?=
 =?us-ascii?Q?JuqaMtjJFEbmnYYIK7guntDPHd4=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4eb1a14-711d-407b-8a45-08d9d54d14d2
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:55:28.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6zs3fv5zNw6vAuULtgNdOHzhMHaJtva+BA7oRLq0xFdqi9VBGu6LlrDDDwx3rRKj6oUv6E+WXrfIMsR3YHZwYPKu3XyUqvOTI38fquB5yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB0860
X-Proofpoint-ORIG-GUID: CpdWpK8RSn-31imleHAsXkwv4bD_J9JT
X-Proofpoint-GUID: CpdWpK8RSn-31imleHAsXkwv4bD_J9JT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1011 phishscore=0
 mlxlogscore=755 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1000Base-X fiber modes to the at803x PHY driver, as
well as support for connecting a downstream SFP cage.

Changes since v1:
-moved page selection to config_init so it is handled properly
after suspend/resume
-added explicit check for empty sfp_support bitmask

Robert Hancock (3):
  net: phy: at803x: move page selection fix to config_init
  net: phy: at803x: add fiber support
  net: phy: at803x: Support downstream SFP cage

 drivers/net/phy/at803x.c | 146 +++++++++++++++++++++++++++++++++------
 1 file changed, 126 insertions(+), 20 deletions(-)

-- 
2.31.1

