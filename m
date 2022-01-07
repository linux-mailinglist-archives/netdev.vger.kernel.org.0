Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C484873D3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345281AbiAGICd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:02:33 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2694 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345196AbiAGIC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:02:29 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2072SkDo011025;
        Fri, 7 Jan 2022 08:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=9O+Od/YsfSP0SAmst2i11b79NPmYkYJa/B7qWJ62WCQ=;
 b=gMEXWcvdJsXVBXFllyFSu9kN3+eqr1z4+rkWgzXY8Q4ststCR6HyxASu7M5K85434GlH
 6rlv5iPESVlH9EqQvM74llfVpu863oNihkDtfxa6ORPbO5aPEXcYhaaQYnGbkMqHBzJn
 jTHo3X8WZZ8U9n51wTtKWnMRraL+uvO+IyyLYVM2YSM0S3/FdtSeUkzT9G+2gTes/FVr
 SLSjr3sPNE6VTvCFLaHwBzVwQK7q5FfgFcztZJoD/oh8JsccVic8/ipfq0v1gMBWZ33X
 MYseWjA705DHmpGleSaEriOtXqRwruobnR6O0SKiBXdGM0DwjKnkwohwt0RZLcS0EGn6 hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vb9c7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 08:02:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20781NgM032965;
        Fri, 7 Jan 2022 08:02:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3020.oracle.com with ESMTP id 3de4vn97nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 08:02:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ie8dvIWx7Z4OxrItR4EKji3fkTF3q5VGuQZRr/YCKFRNrC6krr6m2MK4yh9PuBRKHOPo+WKvVSUMH9RbdI9vJXET24inhgVGTZKG5lNC73NIiXfkKACGWwDqY/rTZXGOyMWQkRnz5cWal8YyY2F2iOrsattyJZoGHLY8SOWQatQ/MkAQk9LcG5xkCYjfqSaGq+CTWPXoqdoFrnqIPX1tFAE5ydltLM+MaEAb+kkoe4fpm/Z1Oj/IpbmcJ2S8sQoSFBeSIg5IFvx4H1rVeIFfOKudTs15v3vbQowYJ6URjQUc2sm/oBfTSYo0HRFiz/buP55NfIJR9xNLGXoAeNJTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9O+Od/YsfSP0SAmst2i11b79NPmYkYJa/B7qWJ62WCQ=;
 b=gyGmk6oO331AmjldBihmR4pzzXOKsyronuHOzq0yftic8YA+zUgtp83lHQx05SiExsrbsFBVe8e6Rk9BsYvN8jE0ZT//ZI6joO2TQ4HQ6aux31eNXrr1qrLYUsN2TiK344h85RPX5kbUG05PGm3LgY+qWothRw2nwtf1S9w3pLPzi4dr/lRhoSuAajZxIL0fSgcHODRnYG2YzT1ApRBttmHTI05l1+thhdf75Au9KP/Bv4+2HRmFGrkqIadUFPEYvv+ppLZK1/NH9MuPXxhlxrtmzqp0gOuJoUibhJF/QWkUYorEEEwp/JsJxFuj8ztcc/gLMKqLR19TRoNNeAZGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9O+Od/YsfSP0SAmst2i11b79NPmYkYJa/B7qWJ62WCQ=;
 b=E48J/m1fP1TCQG54XduGmvUUzGYSXQwKYRtv3uEpJO/IRX46j5hr7FytQKLr+MQ8tVKtZoyYH1wBdbv01YKsblSNv6JW3zed6mEL3+waUITu1laLLo1zETvEbtAH5ycMAkCPqJ5TkOTsgo1kgB3In+O/O5MDNLAllawTKVtHDZY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1902.namprd10.prod.outlook.com
 (2603:10b6:300:10d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 08:02:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 08:02:19 +0000
Date:   Fri, 7 Jan 2022 11:02:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Evan Swanson <evan.swanson@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ice: fix an error code in ice_cfg_phy_fec()
Message-ID: <20220107080206.GI22086@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::17) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 760dca25-6903-45ae-4d02-08d9d1b406b7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1902:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1902B7B1283B89B5527A92BB8E4D9@MWHPR10MB1902.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AxVY1msOiuN/BAlVQGQOYhqU1exEw/yxJZdh0nKcJZOKTOdF20a5S/h/gGiGqBaMlwWeZSox1rHB1hu0XQ76ZudfE6DYWZ0Mtnf7d6llijr+63ElNbv0F19JteCr6rWMO21temVz0MEcFwtl+RCHGPBpWRsEjOmz8ksNxNDctZYz96y20cQ5zsTkGcq3nVQ4rZebeWU5j4FnyGqIFOuWudmPhQTQJUyDZ0gkWSO6YeIGe+Lr4uXaL9oUP6a8OX59H3CloIi3dT28Mt5tdo9p9bj5KugzomdHTjOkpuK+klKLrZNGqVGUKhdiNuDhIYKKqhJJlWiWPleBldIv5T6ADtskXzhSwTBiE7YLwfw4j/NcHXESSxGyIrSgD8i8oTK0Gg5d2ORQVYnk1L3MeTKvZ+cO74s6/Kh0BrG7TriinImpdx/o5LJ5/r242eVtQ9dGYfe+F9J1cGt19vhyIIqw3YCnPcjuV22d9MJo/s1JqEa9w479hxkVv7O6TB6WdLw3qo9zXO2f0S0DRaR+zMClQrPcF+fnJgzfAsEGhPx4mVKVuSkvHbPx2/LzyJDqT2ygsRLeNbSAXOjSIFajj02+GLoLxeRGxxJz+FMjK+j0QYSH8AVkyWSjUQi1EaOWUAO9G874YX9JowxvHZSi1i/nT3O5j9025Wp3qOIyeeW8dMf6vF/FlmcinoX6ZGVtRzwIzcmHgD7dglYzFBJsT10X7k0ORV3u8HclViKBBf9NyzS8mmgpi1Yiad2BnKkBKZw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(54906003)(6486002)(52116002)(4326008)(6916009)(6666004)(1076003)(4744005)(2906002)(33716001)(66476007)(66556008)(66946007)(5660300002)(83380400001)(33656002)(44832011)(9686003)(186003)(6512007)(8676002)(6506007)(38350700002)(8936002)(86362001)(38100700002)(26005)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qhiahdm8haF2x7nKp+A8jtQOGOxaHKtie2iNDlP6rZpZWwDmQxo+GEZWK1Dj?=
 =?us-ascii?Q?cRJFywCNJGUykx8Z8T7+ZFXtW1KlIEgWe7P8pR82PdX9VcU26419b06ynDAZ?=
 =?us-ascii?Q?7fuqZCNlB3uPpvFjjf5TPfOEOic9lT2tIozad10iTaPYtqvXnGsrQzmCQb3Q?=
 =?us-ascii?Q?l+sfQxuxfXdncRCRwc6FOGy++bodrwx29D5SrjdqJeq7LBISMia3nxaZPT47?=
 =?us-ascii?Q?cqV9FkYwy6zl5DcIErWgIlyXsh7h0wBMtGYyZ9acmBvgSAF2DYxj37nOa77B?=
 =?us-ascii?Q?VoCGOQO9TaQ/EooevZxV7fepiPQqhvdBOt3psdcFOkCMl/AeMsUFnF/jn/c7?=
 =?us-ascii?Q?jh3utBadzQIi5fRHLcwrgDjwdG3oEp7Vrp8jZzkgLNymu2A5agUR+KooKPYx?=
 =?us-ascii?Q?AKynmkYzuXHe+LJp1hDOGKpoi6TT5duzmkRAPQx4Y54wDrAgISGR+CoL4fyO?=
 =?us-ascii?Q?R1jrgzPmqTDsB9AtLiGveMxWKl0s2XmDWQAfQpL+lxTi9Cw03dfWJ3v1lgGw?=
 =?us-ascii?Q?zAxT/M6wqfZyEiUW8YQokma3xEt3sGNQKn6Ay9MJQVi8ZMguAB1+p2Zi1LAU?=
 =?us-ascii?Q?f6swlOod8qerlm2iTFp8mkW4karUv5b5jtOBSvcKgdqkzQsX2YG8AC5kVz0N?=
 =?us-ascii?Q?gMD9/g3dNl1baBUAfZVcUA4zBza0aMgRH0RvkvkT87EMRChySBsp63uCgKOT?=
 =?us-ascii?Q?xFcdyyQ4p4qid9pJLQWZiwUQlBN2AakihWysfaWuThda5vcQvJi5TJ7a3aCF?=
 =?us-ascii?Q?RTXBhyLp9RviJpy0AZuORqMsSYPxUXoOWRmTgwY0bNZCy9mLborpOFmz8S9S?=
 =?us-ascii?Q?Ekzs3B7Z6CgkCW3B3yHcFrw5Dwt1HXZhB5QxN8pTGxoURNZOU5mbVjJP0DfS?=
 =?us-ascii?Q?Qewz2fHaquiO3yt4tfBXFS8SWAA3JZpY6BtCrMhDRL4auD9zKv5Hgz8neg+3?=
 =?us-ascii?Q?2f5lldTqlMj2vrjX8TvyDD+7oVDcJqPy/9IHvvEQjnFrdGisukXcmMa4KHIw?=
 =?us-ascii?Q?CB/DDxslMoY15GIngG8DWJ060dPuje4UsTf2xQxV4gWWgfYSAC0A4me4JaC8?=
 =?us-ascii?Q?QX8Mu4rHCt2Swa/kaGFuINUBDWsreat0pUY8ENsjrZ0nOX6wTjDqsIPVLTBl?=
 =?us-ascii?Q?pyuQCvAjuR/CNL/pp+Pi2M1N2s67fXCeEdX/nBS4McEYiqQEsgzDjm+Afd6D?=
 =?us-ascii?Q?syXgZrnX2O1/6Y4Ya5f2MJqWFRnEK/2IRgN/sqXPdYeuluDisWb9KT7Gu7o3?=
 =?us-ascii?Q?puPjV9r3KC9N8BY3GmGLUMc56yOyOl1QkkW2EbgIn5kFGNqgniIWZwOHjOEB?=
 =?us-ascii?Q?f3meAnWLDg/AKEBLvvqWD5gkT1Z4IFcbzHEmlA3joJ31SadexWojxBCR7k0w?=
 =?us-ascii?Q?bXctXw5tTcjKm6KII+Ys6CkeGNLanxKV4DLLkvzVty/r3CcNMvyRAgmOMwgX?=
 =?us-ascii?Q?sA3BfBke4p50L+x/NTMoq1rdMQGclfXc1rWwDU6Fg+5gJsODiTpyeezj164f?=
 =?us-ascii?Q?Nh60GVav+lrl8tFkO3fCYGlQj+DUIxXFAlUZmBhBD7LtSdVc9kmng5yLPcSb?=
 =?us-ascii?Q?3fu2KCILVS9Q+pqXvb44pvhNxVReTYxToLHohzZ6xqemNlTtuIbrCwIcYDQU?=
 =?us-ascii?Q?dzuWm2dKv7mbZfvVnPSFS3X5H4/3eq60b6RGSs2+uKXj9G0NxqxK063QgC1k?=
 =?us-ascii?Q?8ojDDMqHSDdPgh5pAyF5tqzyDdQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760dca25-6903-45ae-4d02-08d9d1b406b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 08:02:18.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNh3S7PAaDMo/9JPrEnK5S1kvHtoJVVd+p3dgm3lJAqLOZixaN9A4KXM3hWOfVs65B7xBdinjtM514DxMshD5Vcj5LLuPYJfNm2wbgK7iZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1902
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070057
X-Proofpoint-ORIG-GUID: z7PjxBhySSx1udwik4kCgVQOY2kIbIL3
X-Proofpoint-GUID: z7PjxBhySSx1udwik4kCgVQOY2kIbIL3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate the error code from ice_get_link_default_override() instead
of returning success.

Fixes: ea78ce4dab05 ("ice: add link lenient and default override support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
From static analysis.  Not tested!

 drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2a1ee60e85f4..67343a1a43d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3321,7 +3321,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	    !ice_fw_supports_report_dflt_cfg(hw)) {
 		struct ice_link_default_override_tlv tlv;
 
-		if (ice_get_link_default_override(&tlv, pi))
+		status = ice_get_link_default_override(&tlv, pi);
+		if (status)
 			goto out;
 
 		if (!(tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE) &&
-- 
2.20.1

