Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98A749E7E5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbiA0Qoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:44:30 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:20224 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244027AbiA0Qo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:44:27 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCIlU4006794;
        Thu, 27 Jan 2022 11:44:13 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:44:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5u6SGfmMZycJFpo/kMLEHMMQufO3QY1SdRS45GxRE8ME+fPToa21aYFQM6chBR5QaqjuaBsHmOp8H9wSfjXbT2vSG0RVPUi5MZPNOVAJfzwQpPONQbsa2n/w7KJBHhtjuI9WZItoRgLUYKuRm53/KMVoGWzysz4hX2RcsgoQglOWsXFM28twYqrKDjSLYekdPl4LBx5bW15GwRNbR6BQOC5g9vZxNBtgNMM/E0ADdfFyG0t2Q3uOkixXB31fBbUJZTW3IpDOXG46noJFW8mppwhbyBxvIM9LJ0Gh9QYPWLep/WzSqS8bNTxAXFXmGx7ytgaiII3v/HvcTbBThmjAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6IuWdR4zoLZTV8E521T3lfnqGecYDrBFFU62zPkXg0=;
 b=E1QwyTFd5M3GKmoICXUSgzMZWnC7pOfFbjiJsmVCZ4XCPs0M/0XTQSO+gpXS9/ViX6kfE5Z1ggA17EC55QDVR+SvGiLK+NWMhWtT2w7/iJP8zDQYA4+Y8BicsHwFO1HbDQE/1ftLhaDgBQmcLeGQJsS/tfdiSIaSQwDPBUditbcA5zdhX90AOZR849WDuD2Yc1g2Z2+mFJl2WTKFx7imHiDyRgyLYcsNl2HBS6FHYRe+ZgO+eZx+MLOeIthVnpSNZLbQLA8XRmnZeC7wWJq+zI7jNn1KknH8UVUcRX0ykwo6wlzlYvlvy3J31g6bBOuJDeekHOFxtEncdj+8qwC3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6IuWdR4zoLZTV8E521T3lfnqGecYDrBFFU62zPkXg0=;
 b=ppkLDfQmuMLWmbP0Exz8Zi69NSSGLLo33J6XK52DG7nliezxec6xMkzk1eyygQTPatzBx8Hx4UWnQC4EBs1Piug1vzYma0dLzJnlOt+ji7/e0wzgDbJwvxLYXwoEj+0RvVLCeYG62eifCWn6EGrsl/TGdTNjpL8rKhO7thHn5Jk=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB2775.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:42::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 16:44:11 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:44:11 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 0/2] Allow disabling KSZ switch refclock
Date:   Thu, 27 Jan 2022 10:41:54 -0600
Message-Id: <20220127164156.3677856-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:610:e7::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d75faad2-aea1-4218-891b-08d9e1b43e78
X-MS-TrafficTypeDiagnostic: YQXPR01MB2775:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB27752D676646127AFC6DA85FEC219@YQXPR01MB2775.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JvJir2Gco/M0Xd1HoJCDuz059ppCbFmD3iYOzCG+BuyCSglrfkNwyyLar/phgREeC95PxgWtCK/zzjalaR53vYPKoLwhb0OPLlerIo0sz5lOOoP1zfX8+RFndilUtSLsKKTlYodzAwFTvxwmw6+lgMDxRd27X045/z/4Novxa4C7dvvsZX5d+GrlmmBm+GtOVvMPgfVnOVGv+bdGCsaN3g+FiSKkLnZBELJEUtox6mh3bTkSorZyGBHsotQ0OWy+QufeN7rAmYaKcVOTpJeLEh+JZwQbzHYNWVLtKDmHM/HW0H+wq2NJY0pwu+ytf80q7a5EA8kc9+UVPrXxJY2nBqPqsoEBkgsKYaR3hBmCT7kKcBTplEVavo4cQ9M+7zDGuF4Oq21U1ybccAm105FAJcAOFoNX4WuPEuUVYWinSzkVMz8eb/mQz4U7GgJPH3Ap1WRhYb2Ok8scl920DLeLtks6QN7QVKUSfjJ/uV7eTMH2GW/hT/46TIRVz5ncuv9Liv/Q4yxIrvnijxgzcYATW0H9RATA9+0EAtds6DGeK+ODVVHru45SJWPWauuN5Cf1j3YSPXU3ajoBzM/JUUkKjUGGv11iYl/AiyJnYmfA4uryrgNBO0+763Ob6mcLBnS8VD2yCNN8/P11xGZdBpv/Z+TNKXXspWQ0HvJKMUBikAusev2xuCUpHMHGOr5EMj45J/2ipz7LroiveJfrrDx5tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(7416002)(36756003)(83380400001)(4326008)(6916009)(26005)(107886003)(6666004)(38100700002)(38350700002)(186003)(8936002)(6506007)(2906002)(86362001)(4744005)(316002)(508600001)(66476007)(5660300002)(66946007)(6512007)(6486002)(66556008)(44832011)(52116002)(8676002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qDWEO9YLkVp9TrhLuQfXZBdV+cH817KXfkErHHcc0FEY05ggTRJ9UCQjOEmC?=
 =?us-ascii?Q?Ih4wEqowMo/isN+I+J+jvVsvWL+B2hqMNf25ExF8rrjDB+j/AY8CkdcScpu4?=
 =?us-ascii?Q?FkxpoyKq0UI4tgRw2wBma0d81iQif03R1EaH+O5miP0LJNfDwo9vM2yqg8u6?=
 =?us-ascii?Q?2oFkOL+TB6zRLy7q2F+tDpj7BQ9EPAHTd5mHwronLnGCM0KNPw9glrOS/BGT?=
 =?us-ascii?Q?lM8iA9GTsoKz51UtEy2PEe9ffPOJUqGmcMeiVONIFBMJSRxla14ED7Q5ZDLi?=
 =?us-ascii?Q?DQICHk0fAuF02Z7sHfBLJ0B2iugeoiQuQcVIMhronxGjHdv23PoiZYL3W/c/?=
 =?us-ascii?Q?XLaBdqvafVD7MC24RQLSkSe8hqShtu1dbBJlkQPyheG4udAvhWaxjREN2RWP?=
 =?us-ascii?Q?LElBuQBoV0c81d4BieAFnKLdwgZ5rw2ZKBMIVvSFR5a+FWtIV/Fhg8J+ka3l?=
 =?us-ascii?Q?vtytUZMdUuCbiCc58jSEMR4I1XV1QPc6cXQtR9jpUP7E8hMLI3FIFgsGrhBE?=
 =?us-ascii?Q?6eU68FeuFlENZvMAEBjItIrf0Vxqk5z9hFVkIAcwXYsaYtkedk/ZN9vYwFDb?=
 =?us-ascii?Q?xQ2DF23NLJNa/QCBYAPf6/wv0heGko8uS+/A0Bm8AUZr1b3V6WzuUKQeuYsg?=
 =?us-ascii?Q?rInZfDQ9h3F26Hp2G/Gpyv5SjVTtk86WpfOaYWfJZBw+rGRwWzHdEsI1FBYs?=
 =?us-ascii?Q?nRergtn+I1G73fluBFfiEJZA0UK3ujuuDeDLGawdr/8c5cNBvvAr5u9pUkVE?=
 =?us-ascii?Q?otstpFaGKtegMbWhfJJpXJsUptIlwMgKpYSgDVL5SWbCMQfDeqD7GxoVPmR0?=
 =?us-ascii?Q?qIcbT7qmyJ1u8fEmcWIPOIsFjVrQkPDRxPRd7ApV0+jwHt1pynpxkY+QZhrA?=
 =?us-ascii?Q?EaK2vB8JDNZXg3tCqohp4B5qlI3z9wnsXjxibIsm18ZEm5wLBXvbY8gXSo5x?=
 =?us-ascii?Q?HE97L/NMgdLJO649C8463kuWhQZwg9i95vusF2CbyS4jFND8udWahCBb9TDC?=
 =?us-ascii?Q?mHNLdoBVButy5UBnd+98tbqZpKYQyW/MTHcZ+p7mOcBEKXgwoeWSUO8sxcum?=
 =?us-ascii?Q?S1h9G8XGzCI/mvz/TsYxYuR0G4LK2+Ap54paq40IISKi3ffpBcn5Pk/nituK?=
 =?us-ascii?Q?xoutqWiSIV3kqlj1L/mS+73sI/A1r9NZXPv6zFhTWZ6RbrCZxAx3sSfI2FkU?=
 =?us-ascii?Q?AjI+4U7KNYn5dUSuUMCs13mxpfNpyd8Tmb2jFsbNZr6x29fJpuyPzfgofAW7?=
 =?us-ascii?Q?rr0I3plvHdzak3z87Wri4WcjLIO6yIZvUf/1vXewVrB+MRV5j+UIf6Zud4/W?=
 =?us-ascii?Q?fLp2JEaK5UXEu7m3Mfi4xw5K+Ha4P4WxEZ16qKtQInnuGtM6mlRBEhDC9U5x?=
 =?us-ascii?Q?VbhF/w5KlSR/ZkZS6UeiW+dHJwouPw7KJWrPz5W2OybKyS0cfk72R+8GHwwa?=
 =?us-ascii?Q?n1U4y2CHQ2kFAqZvdE8nA2r/AthQkpjYIAXOwGtQGOXwnf1USBZEBUBXpzas?=
 =?us-ascii?Q?3lAav/tkiOcviLUP0o/b8ZH3Hi9P+47bbBT4Fmrza6HptW7ERUbddVsECMwZ?=
 =?us-ascii?Q?u5IN4I6pop/XLxLZXEzq16cQdKWss0heLIxTHIM/XCM41UVa5uqXIfRbpijg?=
 =?us-ascii?Q?3UFE5sE3NTNffzxZALbuZ7JKQmDw0cBik/NUF0cNNXOsmx4YwjYn+XtH/Hr4?=
 =?us-ascii?Q?qlixk/XuTXvmH12TbpdV6ouWu78=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75faad2-aea1-4218-891b-08d9e1b43e78
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:44:10.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlexqHMFLRscufFrLCgdKmCONUXCVLy+oMwu7Sm6hGjjtjfEZ/DQUlEAoZIs/JdNpdFHuL09xOSrJlLdMTNMkkgd2diijYgJJZem6KchgYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB2775
X-Proofpoint-GUID: qUvvMLrtoKxqXQGpFnRU3iw7jxlolFH_
X-Proofpoint-ORIG-GUID: qUvvMLrtoKxqXQGpFnRU3iw7jxlolFH_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=801 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference clock output from the KSZ9477 and related Microchip
switch devices is not required on all board designs. Add a device
tree property to disable it for power and EMI reasons.

Changes since v3:
-rework some code for simplicity

Changes since v2:
-check for conflicting options in DT, added note in bindings doc

Changes since v1:
-added Acked-by on patch 1, rebase to net-next

Robert Hancock (2):
  net: dsa: microchip: Document property to disable reference clock
  net: dsa: microchip: Add property to disable reference clock

 .../devicetree/bindings/net/dsa/microchip,ksz.yaml       | 6 ++++++
 drivers/net/dsa/microchip/ksz9477.c                      | 9 ++++++---
 drivers/net/dsa/microchip/ksz_common.c                   | 6 ++++++
 drivers/net/dsa/microchip/ksz_common.h                   | 1 +
 4 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.31.1

