Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FBF523CC9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 20:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbiEKSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 14:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiEKSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 14:45:17 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5FF6129C
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 11:45:16 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BBKUFE030957;
        Wed, 11 May 2022 14:44:55 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02p2rnjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 14:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9ziqoq2rHAAv8MRtPwGkDpKlnZa5k8/Mjyx2Hc52QKJRvPptl9m0NFchrW8TThqWUj0TWekYmmyCsAx7ATP6k1bqntWDQ7VZoCxdDTZHCBDhdtPrSJwcrO/WRSsfZS6PU88sZuWw6OHf8UhT+RuBzmO+7eRREPrDmOyMayAs5mFmMj53/GoYeoO5WNhvSJTWtqLOzIJZuhYg2MM/esMluFPN1kdHkx7gmD1Ae9VpKhSJ7OwI38UHNsviH56cKl1eDQGzPSqsPMrnms3A47febpvttdM4c4CpwM6YTvrQPzcDH/ISxmWhzgUxFg9aVTNR6CJ+xNEG2A6NRrmGv0fmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP5ECFm02p4WJJCd4NcLSW8Fj5E/ohUbhyArFNgxQr4=;
 b=AGLdR7jw87RD1OUFg6SYEifsKdLpewc0TNnp7Jsklm16xLDCHvWkANOHSe1+PddkWWqDLZqn6G/xZjg348rgdQ/8SfdFLX2e/Rhsqdd5VN5dYkZAu+60SFLf8cWYUx2O89PITKs3/Rq3mQq2884FvVbuARnAedATlfbJucxbT3mBZIeXqhKpHktNJ0QJH/BibdwDNjrsWC1yZFY1HjJcmms9G+zPhHkorMFmjHOFqgRZCIKIZE1tOJOoOE1jAAMgpFnGlRQZtIX8f31RfKqSu5Un+jl0XUfYkG/PnXDfNhW4WVRT/xYPHUgMBJfFpW+5W9XtKleHeohFfbiA+51FIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP5ECFm02p4WJJCd4NcLSW8Fj5E/ohUbhyArFNgxQr4=;
 b=IssfQjf3x8b8neS2/97T4PUqNgSdVP/cvK1XDI8B6AIRFZK8f81RwqIdkSoZf3SIjJ8D3bnO4Gc+whEP7m02FpssdGb9KpTSg3H0AwxNWQ/gQY2H6dJxfn6cGbKPGNtOPZ/70d4HGgarlHVq16EIPOc1MxBCyKiodbsWh3JgTa0=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:52::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 18:44:53 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:44:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v6 0/2] axienet NAPI improvements
Date:   Wed, 11 May 2022 12:44:30 -0600
Message-Id: <20220511184432.1131256-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::18) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57608bef-1240-4258-360e-08da337e55fe
X-MS-TrafficTypeDiagnostic: YT2PR01MB5427:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB5427044C03DC030B72335387ECC89@YT2PR01MB5427.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJWBQ2vMhWLn76cw4MpFGkFtRdsUtcwW/IVbJntkJbt79kPzHEoKuoHLeFzposoebnvGkU9TGQ6MBti2x06E8T1bJ1gi+GyUNQYoj/1LG+nqBCgpcqPOYa2MCWwjA3HYFr5xCwoTlS3Ph3Wuidovx7UgzX4bC7npRaFyWwK1jFwjPy9VF4u23jdzbSwEhorospnkHuZksLZU3+yYUq2zvjMm1rxqnfz6j4uxCt1Zu8maU3T8FDnX343sZbHdcFrmUq7+jC6NzQFbHj1zrt3uhRK8Uc2qAg7rrd2YrnPleaISfHZBHZB2/vR+hsXYtd10N4uQ0nj6SskNJDvp0JUlhttjGihvF4feYE6JbNjHDqtvMnhvxF3XWvjzvXrlmVyM1U/jYEMtrsSOewb+7a237qKTykpG4G54tnhlcJt8rfdB1GP5Mz/PvtqiXYNCfrrfo2O+ceabFRH3sb/wc5TkujlhDUA7MPK22cVZEPD3xAmLnE3JEzJZtiNLIkMLFEmU6Y0f+6Ojy5wYSYVKU0YAh5PXWGFEyP5a2y+EWyGLM4d59b4hUpp3Xt4qIlDJyTvXkqGx9ByHygqXn1in8I1s97dJWWUEaVsg/pKrI6Y3L81zhbnZfHIQeHCh0DGwVw5DSvQnuJLbzvhOeM1cGbghI82CJWTgrjFjpTRGqDHUjt6XlcGEqzwNzBKGN0M61+gmhrzafbWYu1Pu+0T3+ci6wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(44832011)(36756003)(8936002)(2616005)(66476007)(6916009)(8676002)(66946007)(4326008)(66556008)(38350700002)(38100700002)(26005)(107886003)(6512007)(6486002)(316002)(508600001)(2906002)(5660300002)(186003)(6666004)(52116002)(1076003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jSgmS14MgrzVndG8mGFI7iaLShrKUnKigvurvADQK1GQK9UKhgqXkm3VKidK?=
 =?us-ascii?Q?Hn6cCSHChq3bvIVIawkeG4Ot+HB0kxqqFAxKZa6WA01zc3I55eq1J8OcVtLp?=
 =?us-ascii?Q?ZnQGbUCPGqR/Q77mVKBT1J7V2jPQW9hJDvT69QrjCCbmBY7Y0PYLoagI9SVi?=
 =?us-ascii?Q?Q3h969cYx9dVx2DR22tnQPkDHpkiPTDudvzoXS9SFTVD51HVdhYc11ZQWvcT?=
 =?us-ascii?Q?rq7ySz8W9pt4LdWlHKDqyFoijF+9Cj7XhRPcSnv+0A4cXrwHi3ipe/aqAmtI?=
 =?us-ascii?Q?BC5IzRkkG+1Wx1LKSHh7I638/knjd2EwmJj7yHAEFc7XPWBYU7z8WuljBGAv?=
 =?us-ascii?Q?wWC52vU+tZ37eIIBv1fy+vQSkSVjUsqiMZLN4+88+GGKY0M5kLgIGzvWn797?=
 =?us-ascii?Q?NCtMp8GrcETDkHu7egRk6vfNS3PcLopNvGKWc8UZbndaSnjf/Vc+GLuBPbqs?=
 =?us-ascii?Q?6JDOYJGw6rgoM3hFaNhsSEcYjxRnTncn7tlETYMSYKrGcra33fuNlPIetWun?=
 =?us-ascii?Q?1mDaxXSFyOIzYNl8vU0X+jmiMD8JviR4U6+U3Gyg4RqsDyza989us+RmDdOp?=
 =?us-ascii?Q?d+m2pCyJvsg37nj2+4PBfjU6UCvZJ1Yzz7CKO4fp8orkCpZSouK3Zl9t5VI3?=
 =?us-ascii?Q?Fjp4kM6Lp7eb+OnlcE0fQUa42jDSgizTHavrdVISdVcf2d73UH9lMb+DKVbL?=
 =?us-ascii?Q?qOjzxAlPt6jrNbikkV6foZm08H+arTE7JULUns4PUi/xeuyK9QQU65616wQP?=
 =?us-ascii?Q?9jmobjUj8yalq/XMDsvhNAyFtUnCS9hMWWx2T6J8d1nQAtPPbulGmQRF5DxZ?=
 =?us-ascii?Q?/C/YLDbIGoZ6e9GOHaQVLpWHy9G5lGeLfN2Z+gGFVcIl2flcYjFMjDKOA1dh?=
 =?us-ascii?Q?PKkXMVLeZwAHOOnu1P8qh2QHyPYC5dPbn1cpu+kwRGrj+u+tr8nKOs+DppkW?=
 =?us-ascii?Q?HKguKVA2GyVOyiTKfcuPa8aDBg9N6BaSD9vGQ5v7eC50WvpsYsRE1V9qvJGo?=
 =?us-ascii?Q?mS/jwqLuhUsCUheNkpehAxw9QV7KlmQQtfBuI9B6k3IgiPekIIRf57GzFj4m?=
 =?us-ascii?Q?IHyb928hICNHfucuESOQXX8+oMSccJKf/dicO5t2j9lIV0b1AP/R0exVG53T?=
 =?us-ascii?Q?bkDeWgCyWM0H/k2/q/Y0fbjY+gnbpu46Ar9GxeyPTDylIKB56gKpuZsfWHzx?=
 =?us-ascii?Q?TJzI2wPUW45z8AGiBWIQ6dZoBLsKjDNLQnXUkZoB99XYvHUC/+kqQi/dAhSc?=
 =?us-ascii?Q?DK5km8hQarv+WDw69eGRxqWcJf41e48qS8aPTDXsj/JGRLdkjf8d7bbappFF?=
 =?us-ascii?Q?HBQY3m+R/guy+EB31SzUeaTq7GpJxQX4ndgkUjd2I8KBw1G188Rz7xhoQc/p?=
 =?us-ascii?Q?KhinjE3n0FSg9K2W8yqXWWOCauVp9w8mnzTfpPBVuX16qyJVI4/YWki+Ii9h?=
 =?us-ascii?Q?Yv/rvorZEymWJjE54XuloN1LJJcNJW7t3a2TGWpBNY/rmzToj5DUrodPyjSO?=
 =?us-ascii?Q?HExLFzUHHy6Gu0kz+OwJWHQj3Qn5cuBwM9Vg42eMtpa+3CVzAXrpdRWZq8CC?=
 =?us-ascii?Q?9FAGxOLkPdlwHgsAuUs/ZEt9loa8yHpQl3hfhin95vesESP80f15tsgbWONt?=
 =?us-ascii?Q?H0a22t/5DeK5NTyOvw64i9zrOtqqF5Mre1X6igG7e6IZ8F5y2+3Zqkn+brEa?=
 =?us-ascii?Q?w/ouzHaUDjAzfx2lwXbIBfUzZdVRKnSejLmeZT/WC8nBC7tsbX/J3Fiv2nWO?=
 =?us-ascii?Q?ApgyerA5Lju/wZ3cRlSOdqtmShF/gug=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57608bef-1240-4258-360e-08da337e55fe
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 18:44:52.9684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFdGAumK2STDkU6IfHmsT9/yeMQ8daNacIA+fSCQEm5SE3nGLedPSBTOZ0/q6Tv8XCvmzicx/x7Rx7b8ADBZj4yEGJ8B+/ZB/i3mMqMdPdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5427
X-Proofpoint-ORIG-GUID: -KMm1tidzzZQeEj5a4sbC5Tqn-bbaG21
X-Proofpoint-GUID: -KMm1tidzzZQeEj5a4sbC5Tqn-bbaG21
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=26 mlxlogscore=46
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=26 spamscore=26 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to support TX NAPI in the axienet driver, as well as fixing
a potential concurrency issue in the TX ring pointer handling.

Supersedes v5 of the individual patch
"net: axienet: Use NAPI for TX completion path".

Changed since v5: Replaced spinlock with fixes to the way the TX ring
tail pointer is updated, and broke those changes into a separate patch.

Changed since v4: Added locking to protect TX ring tail pointer against
concurrent access by TX transmit and TX poll paths.

Changed since v3: Fixed references to renamed function in comments

Changed since v2: Use separate TX and RX NAPI poll handlers to keep
completion handling on same CPU as TX/RX IRQ. Added hard/soft IRQ
benchmark information to commit message.

Changed since v1: Added benchmark information to commit message, no
code changes.

Robert Hancock (2):
  net: axienet: Be more careful about updating tx_bd_tail
  net: axienet: Use NAPI for TX completion path

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  54 +++---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 165 ++++++++++--------
 2 files changed, 124 insertions(+), 95 deletions(-)

-- 
2.31.1

