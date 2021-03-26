Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDD5349D3E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhCZAFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:05:36 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:38603 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhCZAFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:05:15 -0400
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q02rd6016009;
        Thu, 25 Mar 2021 20:05:09 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com with ESMTP id 37h14kg2rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 20:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WO0doAHQZhFzyV5Q2wWYM2YPiIvKA4MCDCOjv+mn5yxCyxTo30D9JBuNReQWIp0AuAWRxNGdXu4C1u+cx1jcIX3mixbB3s3GHbAUTx4wT19UG+nuwYXCOMp8y9RnwEQKISABWN4gtGYuHsx1joRPDHr7BV23ETlibh2oiOrZtj4/wxNkw7WyEFJctNkZX35YGi5VhYucJ6kep/QTLWzTueT41yUbsoyeTru71o6o2kkLPPiL+eo6yIwrlpziDiahas7r/02SmPR/VmZUPeGVTF/52DQg0sjuaXRJTjImcC+wCMFSTmOJuU1xz/Ria5Yz1LaMUHssfS5s+bPNJSvqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLEo/1w/5Ow3lY4JmBl6+DgdD5UBYDuQS92ytvHjB40=;
 b=bnTCmIsX3MoG8DCPL/c1P/D867mTAH3VASMLYkXAsVS9wmD+WTxYutXh7LEze8TNNExK1dIdQGX4M7a2qj4B0x7vHKMNEsxwETQG/MYBX8dosWFY12GbA899tUnAsX4iiOFDVE2lLFn5XNxeAW8lEtd79wEHzGDK4Ld0198w3kWUgpDkugP1664D59WibL/iOOxWzgkXT7F29FnkqnRt78/6WgzHh6QlgJr0M6rcyk1HBdFiXgUt6xueWefhls47LVmdyuJgzaFpgu2luvBrO8LQ60DvAubV/WHKfepZTwu//OCVqiUABOv6l1H9rKAaIvedC/2QxkAHYcoRkkS28w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLEo/1w/5Ow3lY4JmBl6+DgdD5UBYDuQS92ytvHjB40=;
 b=KpJWTICgXM9X7g0O4mcoFW4wZaD4ja40QoehL5KZz0b5o5tbCGGgpJ9meL+8tW74+3nFpTnBObB9cq5y/WZBN5bGfZ4rS982ASdSF0/b3YtGtClBKphDxxJEz2LhLdd/pinvcIuOyhaFfzmMb863yk30BT5/vN4ThmblgDxilU4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:35::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 26 Mar
 2021 00:05:08 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 00:05:07 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 0/2] axienet clock additions
Date:   Thu, 25 Mar 2021 18:04:36 -0600
Message-Id: <20210326000438.2292548-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DS7PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::15) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DS7PR03CA0070.namprd03.prod.outlook.com (2603:10b6:5:3bb::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 00:05:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89aa2221-ea3a-4b24-833d-08d8efead0b2
X-MS-TrafficTypeDiagnostic: YT2PR01MB4302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB430298F68277758BFDEF1941EC619@YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eqbbi3M5Cfngl0u58v6TG1OZw2aEtLSKHcYDdW4sxG/FqYPNyrIhwgropLWTGJiJwU7cbGeQJL3coobU1DR7sMDFUkgGJoz8MOmdBAeuDSksgRT27tKpuVW/0pTqtUqKYbLDSsSgWeK97LxHMxRf5tmxjQby0Z4vuiZtwTJPs/iJ0EQd0Ofr2GgCg/CyoudN5N/Pmt12a9NOHHAS5vuAXYJEHMuhCThnkNU/VmkgFEHevlAPNh3PR3o1xe0do6+KCaGrbmMtqbaAxYabSB0bH//ZsXR9M9WVtoMv0Tuv6FSOfOGKVZLA5PTCG7/VMQW2DrzDQQYtoed2+oC19hMgRKVVe9V6qOAffKZra8dvFcfB/8Cc1gzKrRUgz6rol6I+Y0OOvCeH+igTrpDKvo9Q8t5FEN8PDM76pMv6tXE0/HDmxucxOUa/9cU1b3zf29zXaHgnGAbMFip9SUydXIGRnwyF88MDdm9BKDKWxxeadlNpG9t5X6TjOIXDHQCj9EHlVh1fDPWPZUKV9UMym+vUwe7DUqrwPB12r+qIq0lv5vNXu7JY/NVrESiP8okUkrEAqw+MtOZV0MScNZbWZhRRpNaG7cekNfQy4FUV9VuIhNxPTIZ1TwdyiHpVVUeCLcHqUwJ9qk7Bx3L5zTitP4+zk7ZzDj2RIdW2qafXQrKGd+qFxQ9v9vS1d4v58vgc2Y+M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(396003)(136003)(366004)(6506007)(6666004)(316002)(66946007)(52116002)(107886003)(38100700001)(86362001)(36756003)(1076003)(956004)(6512007)(5660300002)(2906002)(44832011)(186003)(83380400001)(16526019)(69590400012)(4744005)(2616005)(66556008)(66476007)(8676002)(4326008)(478600001)(26005)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KFZtl0gCqoCdTEDV4n78OGLtkuJV/tY7fehPtHkg4T5yVdrNyfewtjE16NCH?=
 =?us-ascii?Q?q1/cZni2WscrLu4N+oAuHZtUXpoXD27oVD48wlwK17a9amiYZ8ITBvtldrwA?=
 =?us-ascii?Q?1UTdish8yo35JfmB0oSPYBeYPNkwayDtV3xsCtJHMVstZhNjHDbh89L1Ta/X?=
 =?us-ascii?Q?+dB1HzmECCFBXvhMPEDAF3d5JcBA2R77R1lp2HPqouhp/TJ/1SqdKl1S9WSc?=
 =?us-ascii?Q?8jhH3u3F6IkEDizoCSawwYuh50a9IY6D1SoYqqoMWwC+aYSyKMNbjDSHkOZ4?=
 =?us-ascii?Q?r7qws0Hl/WunY4jG3wzRSdDgRo+tlDJj3fSFv1thQ3Ra5VD3FmfKtSWjvYIp?=
 =?us-ascii?Q?LcETWPK34qmk+TiBawht7B7dXG9FCkMEl6b60TdTeA5RijF8Nt2+lvCa3jsO?=
 =?us-ascii?Q?sQfxWCAtaYW9QMvpuO2ycKFu/xWIbxZfYcAQ7oHkFCN13zsJ93lWqazdolHN?=
 =?us-ascii?Q?FhhOXeoRIlwE30HwDejgS7HwCm8W2K8KaPSYtfToRXCkG9UPIqTiDbmtL5yg?=
 =?us-ascii?Q?hpb5B+ClgOGssrx4qpDolWbr50HI+O1dIhwiI6TxXa9DRaKMhk+VWacyDIWZ?=
 =?us-ascii?Q?BgU0zSa0oDiX9Lydf0er/6RtvTWVPGGLNx66baWEYo16hHpNQDP2FTGBGtZt?=
 =?us-ascii?Q?GCEfZ09P6pngZi1ukQXuAopiH07EHecv/psF26IyxovV8nREMtB7SISK0kHv?=
 =?us-ascii?Q?VfUPwPF1NGiss9VpRyXjp8Hl/834BuDQBAz3xIsIIwE/mnSY2+IVEKNataPy?=
 =?us-ascii?Q?d6WPBytYmxZbaFUUom7f3mM5Rt4QYyWJkFaCbyr674fQVMpDj4dEbV+c8hjB?=
 =?us-ascii?Q?icWv95VzP1X9RNtNUlvhxs87YUmDhmqP7ucJEXCntIs+IMqNoaA00ZyvU91+?=
 =?us-ascii?Q?JZwqNPpUWvl+btsTDmoug78KUdo9qcbOBAS48JjYLHWm6f2WYDLW9uuBeny+?=
 =?us-ascii?Q?G6GJhib8QrW0kJ/wVLH59hdncgXdgMZFl0MFjVmmrYc8BOsogNyFMLkvorXq?=
 =?us-ascii?Q?vsR0j6LMFMIlDQngja2WOTqVn9xWD2LXO7TF7vQTLpHcRC8i0HD/QxnK60c7?=
 =?us-ascii?Q?YwZEwalAIzO22TsWlV8jqm1lqrNGi8/vLsly6mDsck/mPY4FDqx5LByZ/tXk?=
 =?us-ascii?Q?iciTAhu2hFlOaKlwnOf99qJ74t+e0YPFek2TTY9u3CdPQc6J/yrAwsl3wENe?=
 =?us-ascii?Q?kQ3v11SQYu/ZmwdWF2+gXPTgc+FYx+MkFWv5jY4Lg1CLRKnCrgMj8Iu5BcLB?=
 =?us-ascii?Q?zq1lOd3VT7THbeJjILNdtuWexNt1y1UZ4dTHom0Vp6bMOPpzqELsgn+PXo8a?=
 =?us-ascii?Q?R6hudiMb22s/E6eYzIy7bHxW?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89aa2221-ea3a-4b24-833d-08d8efead0b2
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:05:07.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pDCfaJlEjv6SUp6JKtmIh9ECSOjIKeeToV9+2gJrCDLLNcVlADiQ2mynPt4rB482th+/zQuGJIAB61syQGQMZY+1eLff3uEcIea6fqerJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4302
X-Proofpoint-ORIG-GUID: QBK8KW7wN3B0Fa5Xg8wKUt91uaUFxJ1q
X-Proofpoint-GUID: QBK8KW7wN3B0Fa5Xg8wKUt91uaUFxJ1q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103250179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the axienet driver for controlling all of the clocks that
the logic core may utilize.

Changed since v3:
-Added Acked-by to patch 1
-Now applies to net-next tree after earlier patches merged in - code
unchanged from v3

Changed since v2:
-Additional clock description clarification

Changed since v1:
-Clarified clock usages in documentation and code comments

Robert Hancock (2):
  dt-bindings: net: xilinx_axienet: Document additional clocks
  net: axienet: Enable more clocks

 .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 4 files changed, 54 insertions(+), 17 deletions(-)

-- 
2.27.0

