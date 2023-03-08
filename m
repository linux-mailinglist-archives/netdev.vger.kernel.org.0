Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12C06B06AC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCHMM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjCHMM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:12:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F2813E;
        Wed,  8 Mar 2023 04:12:53 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288E0jD010450;
        Wed, 8 Mar 2023 12:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2LMCjlrOiHSQ8cpccmwUN24eftvWendtL3BoctyPPb4=;
 b=uStN8U7fX+GacBwFghvipZMQThsQ3cJPdYBxvXakFRQ+eUXmo6ma7ABxkaQLwY08ut7u
 ONcxsSbXYcrsdV/gPhLhFuiWAnCayXkLrTf9JXivviJC5ppZ5IErt3bhn1WKDIfxak2c
 M7xmz+3ULkqTOfnerx1goupku3Rkwjzlq/ve27O+W5reMoMFvNt9Cn8YIsHy2z27qJnb
 P/YYEyXNg4GmeO/2A2QPI/r33wkf84TBc+F718Ni9RXvMOnOyCP55YGWIg+npwQxMvxp
 WNqVomcsbEkGXcRyDnmltNs1cWXMMSzrTVyDHY3ZReb63OFIwRacKOCaTjqKHCqRaqaW 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417cfxbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 12:12:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328BGU8R036498;
        Wed, 8 Mar 2023 12:12:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g45cjdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 12:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYMLvaw5d5rZFnaSOYMv2It9DTGZ40W0N/elM/KDPM7lITe1Sr4w6JdcS2Y6bj/j7qs3idwDsqB4l1K74ScF2zFlayuuI1pVcvlZJ/KfEhJuOnS1Mr8JqZaLNI40iA3vIv5YGgPoHMRSciB48T+iP299YSiJOOXeBqfsbOW5M0O1LJhP43p5Yje447Y+vtP3NkE1B3IVe2LBFuX81P4BVUjt54Lpv2uVMDOLzxkzwEqhm1NC08b5O/lihogpS70nmlyxx9NCCmXEIy44pdmFcUjOMxK53JwgSBWBg7EFrBtTXNYJ7mxTBJn0Do0JgGGSt2uWchTgVuDDiQDK3Nb7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LMCjlrOiHSQ8cpccmwUN24eftvWendtL3BoctyPPb4=;
 b=DfJse/HUwIuAlWQpIY5s6wVXYcqQejKtG+6hqe+eozsub3nsqR+CmOF4eGXwiQvxACoPOXVqxnxQ8k7FsHkuAF24vZCh6TvXooYU8TSLh7XKzlHr4Fef2R5dVAyRArT2erKSJc3mD0TjFEc+7+p+gNiVQdu3QSRKa8pqbo8W3T8jW49ndPRyXApQnLwIBLeZLyt/mvOgIClnD/AITOZ53q7IpDd8CtfjFwY8485abKBjnFkrdeNWOoTjYNGpzAB5OQJB1CCZ/uKyHj7Vn0g/PhoKHWjZHKzhD6Ejomza+aeakV7pnz0mOqJT9dz3LarRMHyPynbMx2tjNpIguB1Cog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LMCjlrOiHSQ8cpccmwUN24eftvWendtL3BoctyPPb4=;
 b=gTfVgJcYv6pi7RfMuITzTbCCOWhzOQCKMU+wJA6A3kc1aTGn6zkm9dp30+0iAkaVzf2OSSvHtwMjj8/A9Gkd5drm5+5nXp7fxiRp4cGymraSs7n4HTr2Vv59nXBiQkvmsNtXv3ryPswfiafwCJ75bA3KYcuz5AE+pH3SIf/a+Vo=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 12:12:45 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760%4]) with mapi id 15.20.6156.027; Wed, 8 Mar 2023
 12:12:44 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     netdev@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] lib: packing: remove MODULE_LICENSE in non-modules
Date:   Wed,  8 Mar 2023 12:12:29 +0000
Message-Id: <20230308121230.5354-1-nick.alcock@oracle.com>
X-Mailer: git-send-email 2.39.1.268.g9de2f9a303
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0195.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::20) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d18426d-0cf3-4d3b-76ea-08db1fce6c71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9BAYMaaYgmoO/tokTw5b9IZHLbFi/w2xkUywXC0NzBGwWA7Erb2JH2r8MFAiBC8BixowdaACEcoZ6AoSjrkkc0c0LvNhjPX5mdSZ2pn/ADYEleF/Nvob/2W95cA6RxhFlT4+6q8M8P1ZJPX1XA3oXrBcON0fIdVYkJjiv4HbNwT6erOFJNFWGvwxnjunQDvdFP0ljkrNYDIn7rAusLEgA3Ex9XuKAFknYV578ZpN/wcBsX+L91gBpL0x11ynvMr5rq/seayKXKrJs+B0Fbr69Hrtb1EumVK78ToYCIyLrR9TxJ/+YscrMyHQgg1C5JfOIP9XDsRe8zyBTccd3tzFOAZlmkfcObFLTF/Z3s5NLG0VweDvzU60JZV5dJIagVrYjfIaCs6vr+ocazKppKnSu0c46a06hnK+ZcyJJ1oS93IjZbCGdPOiVeZYTgMSNF23yIJ5amW0L0vNxLdZX9TpGQWo4gGj0fp4Ta1gaEqR6bACoyHm/kZwY4hU09lhkPZAPC/0BjnCybbwuaKmuPfYKE42xrGTl0kJWCMJqCdMkSjuQ5X12cGf4Acr55xpnaDzAtgOa1BcLPikX66t3DEHDOOtY1t7cc1Czk/UiItebtjBHrOLkxx+Ulrr9uyhc1UG6OF74LJud/a5+I3jVEALA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199018)(6506007)(1076003)(6512007)(6486002)(36756003)(6666004)(86362001)(83380400001)(38100700002)(186003)(2616005)(41300700001)(66946007)(2906002)(66556008)(4326008)(6916009)(8676002)(66476007)(44832011)(8936002)(5660300002)(316002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3cx2XSBTPs2Y7MNpO6xpqV67F8SN6gtUlaMHFdLyVhYMvYg3I+Cwey6VHrY?=
 =?us-ascii?Q?+PcnvNOL+wh0nn4IIAKzWmsiRr4yc9WrLDSP6JsjVZXc+vk7QNdE8N0Ym4bE?=
 =?us-ascii?Q?339Z8VtpM8GEv0xjNfaggxamZH4TVb+E8kpN5nhJWMYw/dVkrFx7bfqyLQPs?=
 =?us-ascii?Q?ovfT2iEscWN34EawAb9W3DLXPUsGDhpGUrhSeqrnT9JYv4kIXG+I4UcGzTwn?=
 =?us-ascii?Q?zUkf9Y1LPaEN6d2K70exeDFaC0YJsSYUavsQfDzl5eBMaGgtIBH3BOlUf2sD?=
 =?us-ascii?Q?/1Tt/V6H1V3UiAorh4O9Qrmi1WnXssHTvlVxjwaHhRgS6GLClK2gNQS9Dy63?=
 =?us-ascii?Q?od3edTcqXYjorue7Cr4ilPxNxoObJctWhlUKriMFCvH++1L4tiAPKi3SWoeu?=
 =?us-ascii?Q?fTJ5XHxXte3ixJGU7+MuyB8kY9JZUMcxtfWcpv8mRMNhuI3yD8xVM/vt5UdJ?=
 =?us-ascii?Q?sXON8yjA/IPM2pNpJgd0XQnmI58tP0eE7WXnDxxCOYU/YGT37rmd4EWqCgGz?=
 =?us-ascii?Q?90KPQY3TGAP9JUmVovJA7lkIkjC1rOqruJimqRSGjFGYJI+5sGkbxX3isq4M?=
 =?us-ascii?Q?j45tM3Q78xFP9P6F3l216itBWOLVLzpMKkAClK/vDS4ZK73G5manSRi5FWVP?=
 =?us-ascii?Q?DKJJF0c9C3gbVMn4DJF+vEg2SqSbYKx6NQd517y/x0wPDU7uE64WGB8jEA3v?=
 =?us-ascii?Q?umArnFjJsFIPkqOyWfJX7QbaL/5/BoOs+4dMM1HdLE8htZZr7P5Ygy8uuVfJ?=
 =?us-ascii?Q?TkY81tZ2+T7qbjaniFqrV9m2PVb1V2ZMki87mA7o6AnG2qlR2lx5vP1aZmVQ?=
 =?us-ascii?Q?fSMumt2tv52XQ5hmKy8hNp0Jm8Q2tR0aWf0atZgKVnIPwJml7oaT2GUKLJZs?=
 =?us-ascii?Q?s44+HB1pNWUWzKLvKbXRWAfLoAPEVa4u1pSlNGcXi6G8Ly8htCzohqI8kUUT?=
 =?us-ascii?Q?yblOlZTZjkh9xpK1EWkhhlENoFBBQA/qZS2aEJSEIXcmUwkSevvt8R4uCUiw?=
 =?us-ascii?Q?STYEcihHa7lAYwvy2sFk8c0Xa8ebeCD7m+amFylyae4WhvLae3BoACplvsju?=
 =?us-ascii?Q?uoQznBHVaPampVv5d8PxK172TvrqM35YC64hu4uchVNxz8/9eGClbxvdPwDn?=
 =?us-ascii?Q?KltVaFD7FBx4xb3PXPygOKJGJevJD86fdTjEXRix1gzE7N8AheRHPmMXY0WU?=
 =?us-ascii?Q?my5HbxDSRkn0f2HrndPHvQHl7J0FV9MdhqcR6GyF3sGJF2b1qyKDNfBStUnu?=
 =?us-ascii?Q?zyHxWY1FNr0aASxhGsLYJGt0w8Jzi+WJgkL6rCWnTMTgbOiHGUKMI25ys+cm?=
 =?us-ascii?Q?0LMwLY9OPilNdnv9wp8sg+0nPCnZMK5rqbPdq+8j157/ajuP5hDuEOnWS6rB?=
 =?us-ascii?Q?eHXIdrZVHY2w8yo8hlV1YNyT4XEtheVoUj++oZj8MlEX+gjRGl2gdbPI7/C8?=
 =?us-ascii?Q?71k9y+mDnKXYhyHi7/qwU4FGmMMBuGhg1147JBYAnvl/lRMeRxWXybQsWVmo?=
 =?us-ascii?Q?kT7/0SLhQzvBavORv8ZmphEYNH/lVHU2oJJilxKhyYzrk6Qdl7XZ7HRyx4rz?=
 =?us-ascii?Q?cq/SxLmEwSg59AyqHOGUjcYeRwQNk/QbjMOM8JtQbD/fI304coW/SxIaxMBy?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D2RU3/tzERqnh6cGHwS5qI0N129Le/XiaQYTtyh7tQfsyfzlhRMr7zL/T4LPQ23aB1OfkUS8a3Qymn8l9g2vnkjKkTix5Xbfwect+Fhz6WAc+1fCTdwTvOmiLANCkXCQMZmT+4vZ/NpzxtZpY6ByRDxVzlfsvHde8a807G2R5dJZB0AuKJxpRdfSKOxy3eaH2M8I5301A7PZLNAcx3jtKLqKFyvx92vtf17cB0aoOGv2j9G749uQxOvCTxhkcTfbvgSlxa/WKIj64lPEQmDmA/9vgu+jQD0dn76HRFR8W4gz3NzAgIxYeCDoJ5Q3MgBnYtA75TD+1p5jPjmCJh8gwMTRQhbBuAYEi4hBiTfNJe/QW4WC/aaV2gsUmCJXGkKnKCcUSTGDwThefCdB95zW/8crdLaFovU/mqrwK6WWZw8ALwKxwLlv+xPLydc/Z7xkQ2xV9w0/oxJw+03j/Jdbs+4LcEq0a1IgbQ4Jr+rI/lFGsU9J8g664OJ8j0gQTR/UK+bWJkb/Ns5KDZ2YxBhcpkyJiJrKpVw3P6R415j08wOJo74dYTXwEWggoE6o/veAQN/MrU2mggmdEdVEiCn51vjgfjUw6cUQj/zyhb6KeUsuLgD5flBoTRvTjh/0h0lkcNW35gbSkG/Lakrzy2DvR0XiRAeIJjwopbOO0WdtZpJ8rGXEoARzxv6lYpQHFQ/jMqF49zl39ZxqEAYYBptfvBvTQ6oHH+HKVMQOsZNHsVaece1vPNyRGc8Gtwcawclszz3f0RLjwoSlurgCQC6/+gNwY0DN5fP4dylMAxP8lfhmo14RiaoA3w+PN/AF/GnlQkpx9xh2qa0S4Il1Mt1NnOkN8clt/mEbo9GBrs+vgaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d18426d-0cf3-4d3b-76ea-08db1fce6c71
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 12:12:44.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1HbIegGnAj/zszpJmg5cHUv1v/oxp9k3kEATY5uZ1ROg/WrPWbYlAZnRPtaAWtyJ68xjBzZgYsvrHxPb0wIKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_07,2023-03-08_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080106
X-Proofpoint-GUID: htjO1vbAoNVTICM41Ohtk1vOBeljZT_F
X-Proofpoint-ORIG-GUID: htjO1vbAoNVTICM41Ohtk1vOBeljZT_F
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8b41fc4454e ("kbuild: create modules.builtin without
Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
are used to identify modules. As a consequence, uses of the macro
in non-modules will cause modprobe to misidentify their containing
object file as a module when it is not (false positives), and modprobe
might succeed rather than failing with a suitable error message.

So remove it in the files in this commit, none of which can be built as
modules.

Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org
---
 lib/packing.c | 1 -
 1 file changed, 1 deletion(-)

(reposted to netdev as requested.)

diff --git a/lib/packing.c b/lib/packing.c
index a96169237ae66..3f656167c17e0 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -198,5 +198,4 @@ int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
 }
 EXPORT_SYMBOL(packing);
 
-MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Generic bitfield packing and unpacking");
-- 
2.39.1.268.g9de2f9a303

