Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CC1520577
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbiEITva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiEITv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:51:27 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5444124978
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:47:32 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249IsZbN001708;
        Mon, 9 May 2022 15:47:02 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2173.outbound.protection.outlook.com [104.47.75.173])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fwkvvsh8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 15:47:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uswu5J2YxLj0Q9c94FFk3Sc60HTE6k/vleHOXRkbNauRdt0Xgw2fnFjmxPRlnVNBV++TTvwd7+R5F0CuYoJLhg/0hVIx6M46stuozHaJKR10UrsLpnqfu44cWSlKeilfkyUwN5YY5k3R5+FfAiltAUDaMq+81BqQy6CI5FlV9SWAOavpOICJRaLc5+5tWRBgb/E0n0CvIOs463o0TTF0/HZTYqwOi7Xvm3zPoQfzwyYxupmjA8X7vdY0uVQwUB/M2D4nU+QRXBIahcjVH0ECWN718My5vGxAWrFlu7Gvp15onXRgZfAnhnDAHKTXmUn5BSaTCQDeE/Ar3wul+UEUzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiYTmAQ6PRCv7q9L4+iVJD/WRBOkRqbvQom8zxoHFTI=;
 b=oJmkieipuFbH2F1DStagrQEoxHU8bej4YilftKnZnbdZjeDvb+kFlfKBd+kqLMIqMhINsEpDsZ0dLhb726442zsXAzNrKhP8l/t8Pe2/jB6659ipscJ9LBNax2xkRfeevBMwXWNMavLoTWuMWCjpUdSNbtwg/H+HDRsHeSSN/+lo3wf+ynfFiCmNT4XOmgDUB/+CmPKnRFE7p47splu8hYZgvsHZqtXFWmj69A01Vw7sSaKhLwj7v076LUIkQvjRcXl9e8XFOzpCLc1XEfSPAws4EhKZQl5NMpKHpSx/sEBkBMieBz9gWdSwIv9CldjL2Auhf9KrlzChJayTJBZg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiYTmAQ6PRCv7q9L4+iVJD/WRBOkRqbvQom8zxoHFTI=;
 b=XZWbrj4oR07YFDuphFegGuATa+Tim7wa1EsArjQnPWtr+ZPxHBwKPb7D6tO3eJEEJ02lTn5jTnlrbzByH6szGxr0w+yBgSryPIjMT5IG+JfTFF3ALrKljlSsi1fnbipSKPtwOTVOsL0rtHd2qagnLRefTHeujP4ZGBA6jKh7SjE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 19:47:00 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:47:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, tomas.melin@vaisala.com,
        harinik@xilinx.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/2] MACB NAPI improvements
Date:   Mon,  9 May 2022 13:46:33 -0600
Message-Id: <20220509194635.3094080-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbc9df47-925a-484a-20ae-08da31f4aefa
X-MS-TrafficTypeDiagnostic: YT2PR01MB5904:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB590483F105D9845FABDFE646ECC69@YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMONFzA9Czm9RxlmH21HdIzVObziJC8kY8lsmyaQ3rlD0CpixAvAUUtAg8KGxilwf+c81wU71j743B0hIJ6nllopI0VLHQC8Rs/KTdeHwYhcxtItZ3kN6fjsWRAwl1mCPN2oF3YsLx6oIm7kqg3iKGyCY7XdA3zO2OPK7CuoU4Xd0oA0PO4KmJiOFM62j/EaCLThPw3Zthu1oJ9uv8fuRDfTxlCAMSXRtEf9NEGmzLpW7gfvjseN7Bpk+KkEb+s0SLsS4oOGlFmGJ+LSU18dNE+OLnrQD5nLPPFU70rc42QC8rqH8zQ83n2UCFiYcvS6MFZvmRCJOZ3xC2C756tVuSqLu7an0NHywApninRXGTKzHikV8oSBinA+uOORtBllrl3xJVbdhDFj843RUaxNbaMe8gMptjJHoqBL9OGbk7zwB1m4mC2mQfB72fZqvjzBda1BWnkFgCUPVfb6ehM0HqmJcGimC1YiarIRsi+7+2zfQY8BOTvPLNYgCAzPQfHC4/wG/OqdvJUFD8B+90NEue2TO7wzQRE9D+ibMNHbgPktucn/Jw/Z7WJoAF7rHYLxvyMOuC5V2ZSpc2P9rI/F9epFqOuIqlG/24VjIk8hIg9gW5lld57ZbbdXhIE4q0ctyzRFhfqPre3nLDxcpEZoVRqxooZW/gPF5uJfA0CdECrcOjJosABG6WdEIWqvmL1HbAbj3C3/uYGvW1ZQeNZAlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(38350700002)(6506007)(6916009)(86362001)(316002)(6486002)(2906002)(6666004)(38100700002)(186003)(66946007)(36756003)(26005)(83380400001)(2616005)(5660300002)(6512007)(107886003)(1076003)(7416002)(4744005)(8676002)(4326008)(44832011)(66556008)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OaHIciLt1tYb0w7ImPQAQb9JEvcNVgUqQ9xbwSOffm56TgqRaMyx2TNVnTNj?=
 =?us-ascii?Q?7HlOPf1quqMC3BiU/1BT+uCXNO8cGALbGWBNShXwGvgCjuiXbIje5QHO23Hm?=
 =?us-ascii?Q?+UDg0feg+meLxHxlfOUUPVtez2M8UDbG7Pdk7AEujclSTcSu5PxDKsyeLIgJ?=
 =?us-ascii?Q?ykkF2AXeniXlBG7xsTCkVZLqUQZqQC+oGW3+am/hBgGiWvw+4dE+gOjdH1HW?=
 =?us-ascii?Q?rsvL5pQHiXPopJrKII+FakrT+ShLTSM8+C5AL2eYijAqc7f7DjfNE8fuRi9r?=
 =?us-ascii?Q?lKmIEDxID4oXl/SBFdsUL1VyehhGlxQlQ0bPC23P0hZQfGhwDuHStdOagicm?=
 =?us-ascii?Q?vQtUDeyKOvyBiHqUkWmGKQOD25ILN4V8MhhybqHWM8Ftb+YjD/Z9rZV4lP7Y?=
 =?us-ascii?Q?vOve9+Ed3Pnsa5h/BWCoiVZ9dsfhyQgsUoS38x+M2xaBsmrENjKwJo5paF83?=
 =?us-ascii?Q?fGGRMg1tDwJBBnwL8y42sT2vMvMFhydkh0NyJY6uUkXGZP7TJdYaXE2f3Rwn?=
 =?us-ascii?Q?ZBZLIQG36KV4hz97pKjQT/e67kc9mkj1N1mficekKORQUo1Vi9om3ndS5U7D?=
 =?us-ascii?Q?ksrIMokqw22RdHj/NZZOZ3Ndn0RJ6PpDq6QUzFGzWDYB2dno2v433+fXYsSt?=
 =?us-ascii?Q?GamHZN0t1zcBVxbUQYZfmcazdhvkAfLZZJ7Rdc18Xo0URb4uxrDDNbsKa8IZ?=
 =?us-ascii?Q?5GmdmAtPXckB1Q1OwdcPiiDEeQrzOlJmndoKVkTOF9yPOveWFdrJFwVWdXPZ?=
 =?us-ascii?Q?iT0E8VPx+e0oxWtVUpqRL9CmTG1196FP10ER954GILFQsT+RC4UkMkOrfRqk?=
 =?us-ascii?Q?+3nHkv3n1jq9dIZf5YYuAfuSsyGVLLuvmOCTH1e+2DzSr14955mVxUF8MO84?=
 =?us-ascii?Q?JrZS36S97CWi5yFk7OGNIupO6e2YkRpEgkXy4ZpjbJNa3JwP0u3d6OEEXQlW?=
 =?us-ascii?Q?37gOX8fiiKpMv2bE1VO6WkJV750HLEJP++Si9AQh9juyVw+xUereqT3zmmaB?=
 =?us-ascii?Q?bxWiLY1XpoMNEW7Lt7DRqDVuGSKlATX4aoASypTr8CaKZSLY2A7gzLQuD713?=
 =?us-ascii?Q?Cpyk6m1FhbZxCfClBhc8qBVjbyMWasLsM5faGgXFHXvO4rUpi0+LXAqRBSto?=
 =?us-ascii?Q?NHZ0lwBzyQ2iLwmLYCg2EVtNSSVwayDnA2lZH4zLECNhaT95J9a2Hba669FU?=
 =?us-ascii?Q?QsBs1q0FkOqzINI+5X9u9sOO43c8FeH0rmVJwKGVcrm6+OJmFw3lHY2kQV/U?=
 =?us-ascii?Q?zSwleQoTBar4NsZ/ImJRKjyZiP1vAm4EU9s8y7NRKA1DilgRznGe193BOPD2?=
 =?us-ascii?Q?dUiaNWk4h+eGSliCHwC9qujXrHWIaPQRYuefGwE0Fc57flBsAjN3lfj1JUER?=
 =?us-ascii?Q?icIfNyZTiGet+jd496B0SZeOH/IarCrAnOXTsABHWvuUDu4LUYKzpNknS+jt?=
 =?us-ascii?Q?EEXpLat88EZyGl7JYeWv7B6QUwpMT0qECGbO2DysXBpFkfXlurYT/0gpfRQb?=
 =?us-ascii?Q?r8umJqpXZk3Zv2VcUo76stOBHInkqTWS3hghBHaNR4H+1cmFDtRoiSfKJ4vr?=
 =?us-ascii?Q?B0sZbY6B0x6oO2xnAHmAxbxUaEKyr57qYfbit/sctYn/vMDyFp9805enlgEV?=
 =?us-ascii?Q?HHLgD3UDeDwr6IG2cb3m7n/Sa19HzOMj02ohdADNKsmjqlOELiLxfHZs0Gun?=
 =?us-ascii?Q?LWh43h9h8Q66CdrlNb4B2BXrUmsCAkXIz7ge/BCSaLPMPF/8qR5RjHJbSmi2?=
 =?us-ascii?Q?WVh4guluOR1yqbDRZSyQm0Gs2gecA4s=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc9df47-925a-484a-20ae-08da31f4aefa
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 19:47:00.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77230qmS1INsAR9AWDm7mux5dsznlE/j+zXhDPwWUbSQ/3R9QaLMfu0q7u2FpgG9kMu5VcGdftTtuMStNRzl/E+a/5CD3etGC0Y7+x+y9HQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5904
X-Proofpoint-GUID: nyAEMIUN-HhM9PKVupN0rY8grSuUZugZ
X-Proofpoint-ORIG-GUID: nyAEMIUN-HhM9PKVupN0rY8grSuUZugZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 priorityscore=1501
 mlxlogscore=192 impostorscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=1 clxscore=1015 spamscore=1
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205090102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the logic in the Cadence MACB/GEM driver for determining
when to reschedule NAPI processing, and update it to use NAPI for the
TX path as well as the RX path.

Changes since v1: Changed to use separate TX and RX NAPI instances and
poll functions to avoid unnecessary checks of the other ring (TX/RX)
states during polling and to use budget handling for both RX and TX.
Fixed locking to protect against concurrent access to TX ring on
TX transmit and TX poll paths.

Robert Hancock (2):
  net: macb: simplify/cleanup NAPI reschedule checking
  net: macb: use NAPI for TX completion path

 drivers/net/ethernet/cadence/macb.h      |   6 +-
 drivers/net/ethernet/cadence/macb_main.c | 291 +++++++++++++++--------
 2 files changed, 191 insertions(+), 106 deletions(-)

-- 
2.31.1

