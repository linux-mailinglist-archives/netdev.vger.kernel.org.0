Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA944BC92
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhKJIKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:10:17 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26658 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhKJIKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:10:15 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA77MJV027729;
        Wed, 10 Nov 2021 08:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=K/rrh1pI2KP16j05OFIYr6Iu9LlXsKGjL95wzmQCfK0=;
 b=xRaHW+fvNL5LLYQgIDrzrtN0irMGeSU9yi09EVHPy4oQ9n3UMIWJGq3u+XLUrOPzmN1J
 OEzShpjN7Q4rb6bXQQ+B4GRS63T9XbXX1v+teaLKeJqGaiES/9NuUs/Du1OLwggrEbdg
 Cd5Z0xJ+wOij1oNG8pbeAL7T2YDdD8dDqWSGtKEK7MM2ReCKnwOnF2vu/9r22MKQwmWf
 EpJ2SNP0ofxnkLvRxvzPK3R/cA32xK6kY/t4i7KEo/I2tjvbJSH0DF/OHN0W7FsrFXlq
 72hFlFhb6apDfFaafmAFxcWqxL8kywqnzIrguvOt71sXuS5imEeeCWTgvOpzAL68lOxg Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c880rrpcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:07:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA823w5125681;
        Wed, 10 Nov 2021 08:07:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 3c5frf8kk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 08:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTmCJ5V8+biXPqiwK3JXI+MIjp9geIZOkBcvJ9TfzHQmPO6Nq0wzXR5jF5YN5LrmC3grueL6Az0tLItzvbB085yxb9A+ohnqpsR4QXhI9zj+AxebTdsFkcB1zOldtxouCtrrcHvUskg8ZWwGHIv5evRS7qmbKe+oxmQlJjalqJ+os/uhCyPmZu0cDj5JJgiMRD3eGiKCYgPGoyRBIl526P4LoPEMBjpBOSMtO97k+v3ZvI3ud6CS/14LSDHgD6br1Rj9gJEFYWCpgS79cs6omvPvPemVPwC5lfb6G8EkVhtj89FFNBG5AscKSd0R1hBQoWO6Jz/97QV2wNXi3J2C8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/rrh1pI2KP16j05OFIYr6Iu9LlXsKGjL95wzmQCfK0=;
 b=lwTI8/fWdNHgK0ilJyMnOhm9aHN+UK8wXbKZ0sgJRsVtidvNkZZibeny76PKLyQ2xB9HHHFf8guPq/lAJR9UbFqM9Y2gtbK6cFxjvvz6Yj+VjRDRPBVWrhQ4hqOessIg1Jh2Fx4CXBO9IwLyRE8BWbBcqu2wO6F0eE22kH6o5syTDw0+LfY9eHKVVuzbGmxpETrzIf5eDum1LYMW8r6tTWo+m3tBuAqB8Mp4GpuenrM/bPoCB1s0eol7XWs1JO07ljKBnin1TT2hwKj5FGYHeV4TbRqic0r6fTXC2zcZKk7MPgmLYX7N8P3dBFNarZNVtaifSO6z1NOTSB9gICjQ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/rrh1pI2KP16j05OFIYr6Iu9LlXsKGjL95wzmQCfK0=;
 b=trKcu9kf12QuvgyuDIVbov3Uu4RO2NvXPAlW6e85JlhdapIktUKZnYaZpOtlBTBcufG1XgqGKZSrQjH6Ii2U9KdLfy0jfP3hh13pjA2yk6prLhatm9+OgtBdp6ynIZ7kHHtKsoF9SwvA190DMdTRxTF5d8pH4MgFqxUZBalhAIo=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1950.namprd10.prod.outlook.com
 (2603:10b6:300:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Wed, 10 Nov
 2021 08:07:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 08:07:19 +0000
Date:   Wed, 10 Nov 2021 11:07:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/mlx5: Lag, fix a potential Oops with
 mlx5_lag_create_definer()
Message-ID: <20211110080706.GD5176@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0009.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 10 Nov 2021 08:07:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fccb9fb-2669-4f53-88f6-08d9a4211e18
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-Microsoft-Antispam-PRVS: <MWHPR10MB195021E88846D0CDC2AFEB318E939@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YrT4GfyMQ6GDwXOcPRx2TBeU5Wn8eXM5I7lEydD7zoF5DGEromdzReAsR2c7j7oYeYs4eCzMMZAxCu+hlmvnjqQeQy95Zbtzlct8KKIl0otePszBJjsvaPv2TCThqu8SygN+MbUrlOdmskT29aSJ5NxT34s+EiJlA7z3Es5osoWR+eAMfLbjPMEeNqD6E0Dhw4C+pq46qwV28PUKlUNtuMHKFED47fdwpDftILoMxTxkWTemwKh6NElbGgXBia5wXy5eg97qCyzxL9m3JmKi1PrdoXtT4B8wR7uyjZZ8nx6yemxgAmpdLIy9UR2sfWBBTY9aPt/hElCI7c9Z23jXA5ERrvK05eA8PuWQrmYnfbQhLB6jDXVAzC0IGDWG56+BS22L102uWoif6m6CjHUzAeXMy/ix0oDDZV6sodnLh6h3iCyXmgtOD1y9cN57v0IKIfp2Ec2rUxxrqAayn0+tyqiwmEknFGBAWxCnfTNH7yhTahTM7jw+gR/+yAgzi6a5norffPMeXu0z7uUI5tHJP5E5dzVXIXj8vOJWFm98h5K6A7DyrvUtjzqCQhuWbwLZcGft9R/O7WQwxktTqSc9diVkZR9vMVzjPS2rBWKb6Ba5pJyG/ARR2We8PiBo4/0R4Y0854M+E2+sVtGfiCO5yd1vkwLIAQF8nhZpEE2srK2jRnuA1l4dhp7423INXOSc0n3xd9D7qEuHLqyaX7phqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(186003)(38100700002)(4744005)(8676002)(6666004)(2906002)(33656002)(66556008)(1076003)(86362001)(110136005)(4326008)(66946007)(5660300002)(66476007)(33716001)(54906003)(9576002)(508600001)(956004)(55016002)(26005)(83380400001)(52116002)(6496006)(9686003)(8936002)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yOS1LpByePVBzrLscrj7vq7EKSSTYXD8lHt+2xjfxg/TUQmb33mWk7YyJKbv?=
 =?us-ascii?Q?bNQKgKnRDvDFDj4b20inpyuVs6Q8axCIo3nJYfWgO/+fdyk63swsUAHrIaEc?=
 =?us-ascii?Q?/6Z1yZyJtt3Jcg1wNCg8APJWcb0M95QWwMo3k8HgU7Rixe0RHHgLsiOFFmpy?=
 =?us-ascii?Q?+qivE1oncErBKQ54D0Wd4sv1NUBkhStg4v3/tSneiyqef1k88KHa4ErO0eqN?=
 =?us-ascii?Q?DB7JSOCz4LfFmPml+HTnwovlAYTyki1s9zP5ZLig67ZG1AUnwCYAjEnjyb7Y?=
 =?us-ascii?Q?SSdKMNV/aMwDgWnMRSJxLNSGHIfygJ+N83nLgHRnfWFL+1bIJRdsruaorX9r?=
 =?us-ascii?Q?uj/cyq4PVnRN/DMUDLD77CDxYTGzjSu09mRkbUzj1wivq9Mcdk7kAjiqQm/m?=
 =?us-ascii?Q?jVlHhdH/qpa7UBmJbujQJil3+7uji0ksvYJ4Y1EV01Rmo0Zi+0Cy1TryY3Oq?=
 =?us-ascii?Q?ywWZjoovN8IwZ7HUGKXe3wIOKtUC7Us7bdbcqowdjHOl6yoHzzl6SD3QnXoy?=
 =?us-ascii?Q?dz64iu2/CP6M8RrhWx7JERoSliCGpBIhj4VnCfYsfTDYUSfEB7El6XTMaYak?=
 =?us-ascii?Q?4U+i+mFwEVMNe/sTpSs9erxHRJ4Krvv6IbvxrG/dZlI2uw1F8HbEvVTQje4y?=
 =?us-ascii?Q?4ujMRZr8WW91uO2y75J4NdPOreovAcvA+dj9ooRDbeTLWmyAzJMUnLwOYB0o?=
 =?us-ascii?Q?5GwQnWHlJgvQFsShhObqlqgirJTCGYD1kEk2yJVvYNXFHWhCGRWrLAyUcyYM?=
 =?us-ascii?Q?S6U/V1scHD9vu94dAsF44AfrhG0RqCjps/BsFwdDmufRpjFbET1nWrtzCs56?=
 =?us-ascii?Q?77PY2gEYzaEMxv6YuFwwrneZfws0lXBBaUCcmyCHGi9lIe3VZHdnTjdBeKT6?=
 =?us-ascii?Q?svkUT17a+Lk/Yv+uubOlUYKW6AMBMiHE0BXhg3bCv2pGo4pASj7BCwzd0h1l?=
 =?us-ascii?Q?CjtwXKIZqdqVSiGA5RD5IEp3WAcGnYSwNFWAAzPSzM90buwdQHfCA7/Ld8+I?=
 =?us-ascii?Q?cadXtahAso+zdEQlofRnJSQYYaC9peK2oVqIPleWO6GLBB+KZmZv/2Uh3TAA?=
 =?us-ascii?Q?414qZrsE6JuD3pb1QUlUDAsSmZUwCSGWGpPZ230r3pgkDtkCdRDWx7qXa0KU?=
 =?us-ascii?Q?uFpeHNz0h/4CfIds8YcNpAKgRRFk0zYkPQOF36KZCs2nGoHD5x6loVlIqsk6?=
 =?us-ascii?Q?RrKPCo4/V3CEEUa2rh6hOyp1ZfIY0w2eb3/KL2ohNyuzdh7ZDmp7xVScGDMr?=
 =?us-ascii?Q?NpNnm+zgQfVDnaNW6WOg59gYIf3W3l8sYZpVwMs+g+iDSaB5r3X2285a/dry?=
 =?us-ascii?Q?YrvSO/MtshqAKLSvPwIUbOrWAlyzSZciPIcoovw6ytBmw0qy8Waykw0w8KFO?=
 =?us-ascii?Q?Ei+AXkBSqrSIDge9kgDsKDdgy5cZ23TRYz9uplFFFH+3yIVtHevnHRo3WGmn?=
 =?us-ascii?Q?R1r2YWF9EL1l0RWDc1eNRiLzomt0towyvBKQTBuARZykbgMJR3ouwAq30CJI?=
 =?us-ascii?Q?WyXxLafNmKkfPlzawTh51Cv7UuB+3eC6JDnSsS60TAWqml0XJeOJTSp41s6o?=
 =?us-ascii?Q?1tETtzYOd3Nxfgvqe1pmc5hcJvpaC5zH0HD899+6EPAEFTvjh6ELPsPKMHq7?=
 =?us-ascii?Q?7UPhe6AUkPpMkzFzl4mWQzDgxZ+q9Mf3B/C6dmZ7ORdiT5/sipWOl1GSD950?=
 =?us-ascii?Q?sFw2I7IAgIel28m7qbrjSRSDR4o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fccb9fb-2669-4f53-88f6-08d9a4211e18
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 08:07:19.6675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cW5eePr0LkFQwknRlgZ4BtlISFxnsEpZkMBjnsj7juCFiolu5xOLm8O0hECYQWVw3rKQrfQE4EwJouFMoXNgtWQC66tkbVOtJr+Wr4+s6bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100043
X-Proofpoint-GUID: SYMojhX0BXwiWaexLkrpJmFDYbIXE-fF
X-Proofpoint-ORIG-GUID: SYMojhX0BXwiWaexLkrpJmFDYbIXE-fF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a minus character missing from ERR_PTR(ENOMEM) so if this
allocation fails it will lead to an Oops in the caller.

Fixes: dc48516ec7d3 ("net/mlx5: Lag, add support to create definers for LAG")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index adc836b3d857..ad63dd45c8fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -289,7 +289,7 @@ mlx5_lag_create_definer(struct mlx5_lag *ldev, enum netdev_lag_hash hash,
 
 	lag_definer = kzalloc(sizeof(*lag_definer), GFP_KERNEL);
 	if (!lag_definer)
-		return ERR_PTR(ENOMEM);
+		return ERR_PTR(-ENOMEM);
 
 	match_definer_mask = kvzalloc(MLX5_FLD_SZ_BYTES(match_definer,
 							match_mask),
-- 
2.20.1

