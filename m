Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71DB3DA820
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhG2P6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:58:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64822 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238275AbhG2P5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:57:30 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TFpnqI032373;
        Thu, 29 Jul 2021 15:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hIWtzIdSrpnSeodM86aINMqI8kOwsllmBdRjYh/meX8=;
 b=xFoMcZy4ouHX22mV+mT455CkM4aVVFgFRsZuPln7ml2k5ZR5AacSRPTLUB/C4+ePtIST
 zQVApgjhEDh+Hbg1w4XRCf8poooCiHSDL3Acm12OTFTQXmgWultP7InBrtNWWSxjfw9q
 JFuCCeyc9No9gtZ36UoHEAtpjnUTer2FhxeNYdi/WlXiGKThDmfWlmlSyCup1wBoah39
 c+eKmrF0G21K/EVmznLuGsJvuzui2+3kyix/6naQvEXx9Rzckp87kAk/Kh0OFuDVuGrl
 1OAPR76LgT4LzEiPvKGzxvX/Mntsm9bkaOTnlGO0d7RJKIzevtJtWw6b/a7Z32Po8eEk JA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hIWtzIdSrpnSeodM86aINMqI8kOwsllmBdRjYh/meX8=;
 b=Oc0Wcrh4/iw5wl/r3RcbkjK2vLqDXBXFO3UfsfAGFOV8ujntmSOsYV5VUOJQVdFsxHRF
 /XvbwgpRPjxZ8o+7X3WuhnD6HGYZPT9HsglNZV09vjsQzAWaNgEFOuGc/71iAjCL9fE8
 WeJF/4wzXj0nKh3XF/ib5r//6DuUM0ae3Z1byWHS0vmrAFoJohDaQBC2niWJjWrj7SgZ
 7notKmgna21kpInhT7PBEb+ARYM5Pyw6fCJu/wXRNonhnBUhbtPWF5Y299wvAWy8rhDT
 owlJwkmq619tBYBKiwlQEzIt/snlzFrnpZZPs90xVmN8bKqXt7zlR6e98lc3SXM1d+bk Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfduc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 15:57:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TFthWj174055;
        Thu, 29 Jul 2021 15:57:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by aserp3020.oracle.com with ESMTP id 3a234cgef8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 15:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGWZKyP6sYnsI9z4vSbzRYJRt6xsS3RXF60DA12zcpI617Nubv+wqqHl3CiPrvduBCv9hj2q8/cbRZsTrBpR705QT+ZsX5O6iqbD38rtM0+8hofVUD6S/vkYCLaFM05looi06zYzV579qSl19jyo8pLpEb6BHJV8MdlgJ9kVLO4AVXGOyFynPK8bv6mQjq0Kr2nAui2LtI01m3TIGMxPVUqelp6AC5mQvJXvAQJAbQ34PZcPyuKMDCr6POtIVjW/6lxEgpk1tE850JtCoG8/ASEpLlv2PWoLnchslYQSADSo6OyJwn8EFz4l0/rRCp13FxyA366Z1J5E5Oc8/F8+5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIWtzIdSrpnSeodM86aINMqI8kOwsllmBdRjYh/meX8=;
 b=FclaKnmQGeFfe8ukfFc/umpkIrnwPCKilnDHtGl2J/jrp/YcsUF++FEIfayWpHIyqT84d24pSIegsw2OgS2T5k8CEWuKCuDqoEDhgjXFjECrf9j6D7mZCsJWuVUNlwPZbxQ1I+LVvy/3VVdMvLYfgKANlPrSAc/TAYafp7Npb3S8DiuZxoKldb1pTI8dG9VHJ2lWp09l3hNsOAoYChkRvDuQGf6TlABPW/n5oWfblLCGWE6V5nP072CtYJLpUKJJWR0LZlgfaUIwvEkHINMPOwVWv03EXeOWg7tl3/Pj5eykHI2QS7meXSrPeP4b9g9tY9+A6m7Nhpq7Nzunrv6CFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIWtzIdSrpnSeodM86aINMqI8kOwsllmBdRjYh/meX8=;
 b=mynbzFXgg0MoKalOMN2voYeaPDDAcvL7qRT0QisOrpfqByZvjCAoBjf1czoN0iyFz9u7nQKsh5FhRa+NSF9kYPe2stUqqzbHBImA9fKg3xXMiaacr3YDUe8AgW90msaAC3nUix+EMOtwxxC2K18rjtbvO3MDYSA0guSm2492OKs=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN8PR10MB3507.namprd10.prod.outlook.com (2603:10b6:408:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Thu, 29 Jul
 2021 15:57:22 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::55d:e2da:4f66:754d]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::55d:e2da:4f66:754d%4]) with mapi id 15.20.4373.023; Thu, 29 Jul 2021
 15:57:22 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, stable@vger.kernel.org,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org
Subject: [PATCH 5.4.y 1/1] net_sched: check error pointer in tcf_dump_walker()
Date:   Thu, 29 Jul 2021 10:57:34 -0500
Message-Id: <1627574254-23665-2-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
In-Reply-To: <1627574254-23665-1-git-send-email-george.kennedy@oracle.com>
References: <1627574254-23665-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:d3::22) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.40) by SA0PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:d3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 15:57:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21473613-8515-4641-9df7-08d952a98d44
X-MS-TrafficTypeDiagnostic: BN8PR10MB3507:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR10MB35077040F3D34AD72EDB0508E6EB9@BN8PR10MB3507.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsOUBp5+L3RAW5/BV7LF40XkDoYCz1WLwTLCwWMkaWIoeCsVKlzMNVu/VZCOvbPwrrd4Jr3tFeClZcS0wEkbfD1qOpyqvxrTwNIpyZ50D6KRTYVKHfs8gUF5OhaS9O2sqq/MePMSP7BWT89zrv2QJC8X2sOQinwlnIafQvhGdJkWa+tucxN2lRhxBHYkG4mgKd4iMrNlAWcP77v0URyHRzgD3xDafOnj0gt3aZTQLlAPuEb88WhoFucy0mgZPrIAJFXPD+3TYyyD3EkvT+nJvWln69VrPz6ngWqNKSf7/pzLqmHIKy82WLElHFpmXIo+0vEZUdEHwZoRvvuwkGGEtDawwDQcaICg/jSxcJV+jPW8WiJX9I3IVEWv+Qb5R/igYZJ1rERxRAvjg/+FA0VRSaGeiBx7PV8LA0dU86pAWBoAGNypbL6bNNp3l3y0FI5HKEjttDgCT1fAuonPeg9M+pmeh7ETVGCcFg6GexVjrAQaVOhOm9u6nIwzHonV2vgeDpd7Xniwlrg1M6v12rhHK9rRK9Jc48WrarWSFveql41jq7+1tKAJ8N5bgH4Ub2OX1i86QYd/quBSe6/6eqVI1yvG+It6X9sJSRixfaGwtm46zApMMpMrhXQqbHkP9c/s5MQ/JZy6dh2lmD+DgWibRv/PWsusuJROYHAj/JjXT+O9rdWaMsyjYSyctk6q8lVaRT0vRD5OQXfPyhHbgl3F4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(44832011)(38100700002)(2906002)(6486002)(38350700002)(2616005)(6512007)(6666004)(956004)(186003)(26005)(478600001)(316002)(86362001)(52116002)(8936002)(6506007)(83380400001)(5660300002)(36756003)(8676002)(66946007)(4326008)(66556008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7nXWfwr+BEl7v6UQyJrKf47aEf6SoF3z3B39fzCWO/CD5KRQ5+iq6ulQNUUk?=
 =?us-ascii?Q?yJ3Msz+bQL8CSClx4SPtVvy0jfr7DngLm3i3flTI18379rxHiGK8fG2dJWUv?=
 =?us-ascii?Q?Xm+cF1DOKYI+1m/zYiLdoiCS14B3pEui4upVhET4OL0Hi2DpwhsGUS7swC1s?=
 =?us-ascii?Q?5Poz3afT96Uz24SBM1ZolVDMjW80tPq9VxliLFhilIsVTTHPzJ5QcodriaJy?=
 =?us-ascii?Q?1saOUbJ5Lyn01CL7ezfyz8eHB+C4XSHufT7/M3xjSr2QwBv/x32SBDqoB4Ns?=
 =?us-ascii?Q?VLK3ye2mGbgGA6ojJl/n5k82+jBcXZcnJVupvdD2w+cCOHLkForw+h2C5LZN?=
 =?us-ascii?Q?hBMbX9SmvJqYY9Pg9r10JngXQZ05WbAI0MWQDJtygkXO3olr5Io80qRgQMht?=
 =?us-ascii?Q?V/WjqNXd1TtqmSxwCiYWPpDSdZbKDrBD2JHjWDaLVAlc5/+qoGeTWVg8C74J?=
 =?us-ascii?Q?F0A9WPgcDIgrCu0mRhx2ojaDuh1S8m+wsXfsb+3XH45N3c0QgKk47hkvgEaW?=
 =?us-ascii?Q?QK9B0yC8K4SxDPBbEeJrGxnoJUl8VYsOT/3CQ0rlUU5Mlqb617ZFMRJDKSLO?=
 =?us-ascii?Q?4osEKEioHbz7n3H9uuVJDo3bcL1JeRayEyLWcqP9g/qmVs+Yuwg8pgFgjuPL?=
 =?us-ascii?Q?V8cwBHVyi0LQ/bAkvXxoJ9YvwwLtkZkR+NKTf8SZwOl/bj0/HpDtliNIcQ9O?=
 =?us-ascii?Q?km4u4OcCQBfeSqxc58O+XGQgZW7L+Rf67C6oatU7Dp3wKo3pVGyilFGv3ATG?=
 =?us-ascii?Q?g3l4waL/C7CgGEli7oNlwryeXVdaOvPk5XvKv0UBAxuNlf5WwH/u8h53XtZd?=
 =?us-ascii?Q?O03RAL49WbzFc0Sl3Dp1olVFYM63G0mirBp8fAATlO5uWuQ012rXpMwIcId8?=
 =?us-ascii?Q?6vGk9wHROxJsmgTpQg9ZGbCnVNGUjdpjiupKfkrYWifdrPlACvkDCYHpQKB+?=
 =?us-ascii?Q?UzIfSoq7Zwh4Kfl08t1zvM6LBSDJ9YsiXdWBqzL713RboeDALChceXyg9OfC?=
 =?us-ascii?Q?Dd23dg5k7zdr2AjyOVeg9RQ9Jo1K4wGHXaMNRN5Z5QiabXXbx913FwKA+/Tw?=
 =?us-ascii?Q?ZU4xcexo6qU+XgGTJ+Z/c3GJKwDLsOu8v/M7w3Lpy96wgTAfzk0mHS75ua5U?=
 =?us-ascii?Q?3gOrYvHb6RTFCn+iEnQKRIaUekUR6X6t2XNepjtVeO2frb4ldkTX/9YFHrNB?=
 =?us-ascii?Q?wxAW1wkQKNuEy0AXJAQOusoBZ/X5k1jQXLhPWf9h6N10FBgZSO7Ezp9SV+sP?=
 =?us-ascii?Q?SEQmqrSFvm1n+CozkPXo5qyjtDN3AkHYYyd2y4DHoI0ZvE506s4JvohwxE49?=
 =?us-ascii?Q?PtdAWv+IYX9e2UN2BckOmrEo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21473613-8515-4641-9df7-08d952a98d44
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:57:22.4303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjzSv7ND38Cu/m+C+16FiZ4xmGyIK0xXXeH1Y4yf69EIIZu5fnB9h2L3lZu8qmtiks8EcTu1jDqPThElJUy7o3ZRw4hoDog/6LdoYLFDDcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3507
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290100
X-Proofpoint-GUID: RYQHL5RbnqikS3KdT_2maJszl-tfOm0d
X-Proofpoint-ORIG-GUID: RYQHL5RbnqikS3KdT_2maJszl-tfOm0d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

Although we take RTNL on dump path, it is possible to
skip RTNL on insertion path. So the following race condition
is possible:

rtnl_lock()		// no rtnl lock
			mutex_lock(&idrinfo->lock);
			// insert ERR_PTR(-EBUSY)
			mutex_unlock(&idrinfo->lock);
tc_dump_action()
rtnl_unlock()

So we have to skip those temporary -EBUSY entries on dump path
too.

Reported-and-tested-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
Fixes: 0fedc63fadf0 ("net_sched: commit action insertions together")
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 580e4273d7a883ececfefa692c1f96bdbacb99b5)
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 17e5cd9..75132d0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -231,6 +231,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 		index++;
 		if (index < s_i)
 			continue;
+		if (IS_ERR(p))
+			continue;
 
 		if (jiffy_since &&
 		    time_after(jiffy_since,
-- 
1.8.3.1

