Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4522F46E58E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhLIJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:15 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236165AbhLIJcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFjcYGBNp5KHDK2Fk3T7FplW+Zll+BbMgZOraBSL2xJNaAdEDgMeLWNf/1TW3+7j55vvUuka0rS9sbY+NAUzf6axGcnLBi342QPiLOQJGIYYnnqYhI8v7mARj+UamCISPmkK/313w7RyexGfVPZe9Bj0fi0dYbWcnC+q+UXmqpHAHR1L2LOH1ZHw10AJ4eZNj5OfHnWkRn+h2SobS0eQlh5QwlIGTTkH25x2h3T/3pkDLwsHajRyTASYTez0EB0GdgSc3CAXVJ6NjGBigaMehMvHaFQgKr+Pb+h3odWmAjhZG6WElRmQEWluqY/dDjvtFqgsSQApxqb/JDpDWg/DSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qGuUV7Fn2LtfbftPKlaN1D3mNogN4NqNv0+Wsw7CRI=;
 b=JC8zztihb7ZHYRwO1FXsDCgf+mBKyEU3/ht7PGFgJA34AiBvNd9wNjc2bqbMAvEOBmgtF+MQPl8tgggIXkNVsdRi9dgDA9zvUetyAA9Zh6+Ii9W6orJ8nahSp1aMoaN4jupsKAMzG40gyMBOpx8/DU7WVgh+LODJw6U5UUUZ8yOzBXHyv2rv7zyo5ZzSj5ijDCqpbXS8AoQT6J+zLfSXa7GZap/7ywV4FDF5slMD38pUr1bLevTV41LeHJWLUC1tf98k76yo/KDP6dWJ1yQabso/jmNLzEm52tm5k79eRKxMeufuPtjZZf9g/BuIU1SmPJo1Oep5uNVXYVsguz3wOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qGuUV7Fn2LtfbftPKlaN1D3mNogN4NqNv0+Wsw7CRI=;
 b=oqvd0ENkvRlbT4b0o323URjY7hDnMsd7GVmDsmdPO+fd7KqoR3ZqK66NHYatOTqZRM24Vj2lIulfuBbv5z558qEaS4HQ0LitW609FZdqCUn6cJlUMQ6h38w9JvqUWMUsGiUQU3l7Pxrftpt29mpVxHqp7TrNFkAMNud9HOY6vck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 04/12] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
Date:   Thu,  9 Dec 2021 10:27:58 +0100
Message-Id: <20211209092806.12336-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89a5cbbd-8dd3-4979-2254-08d9baf646d5
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494D4E824D8207A733F6C6EE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zGRNwgdr4tgluo/4oVcbZi4u3Nv2CI/oVg5Q5xZeunXeuQOeGt3ANOwp/zC/aR7uWRfVLqysnjNxdtXCrKeSj8JZxzO4aPvo9755Ozzp29y+bkyUjvvQFGDtUeN/Siku+DTzbrDaD+n0FECUfh1kYIqzKAOcXa+mLRMR2510cvg2+TYDFojkqrYHOu02qKAQMq3U8QJ3LCJ+Qzg0uuWiZuptJDgrws0X0M2y0CeY37onwECbkABFrMz48/ZHOEkNIwAEAtvReSSkTkTA8SMBoB3zsgOed3jWdFGVngAJgBaWaYvOB6Am+I+f70+K03wdE+aOwb/gNr3MEYkYkKSjVayJTge3qSDxVeICgPv7lSsFwBdG4LNvINM3MINL6qaSs+lxkOfACiM6GvC+O4Q3yKjM/180o/bnHCxBs7fOISj+RkfmIJ9wzMtOZTh2Bev7jnED4ewZLVtXqyb/IacmGWtsxqvzZFOuxgDJT27T3Q9b1P3MhdXnkxIGp08CTkBBJddX2eQshVIvPzGfU8/aLjfqiBAK0/SyHX0c1iLTbbKEU/rvnQoG1jDj+T/EpjFWomIfO3IUGHUQ1mam55diB22asisHStjPW+F3KHswa4eLkKOR/FPOGD2pbPk94/0jN2k6TsaqKT4A9sNZsehHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(4744005)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4jtHtEI3rqMYAUpm/2atJ0DgJzF/u0NhGoP72gQMKp/2K1UrSNfUy6lYTgm8?=
 =?us-ascii?Q?lBsIb9V/nLvzfnIeqd+C2EsOGmljGgFDDKwaDWXGgG4x0gPu3Esy3zx08RH9?=
 =?us-ascii?Q?UH7TsLRuCtlUyGCP/X90icygLb0d3k9qOfAqhsKZ6S51y5Vy4WSa+0BOPp3o?=
 =?us-ascii?Q?poyrzDrIREDon+cR9M7y4h66IMDe5GdqhepMDVQherdeAdxep+lALyLb5Rao?=
 =?us-ascii?Q?quPFiw9zxhGys+F1JnPPcWvl7fbceJir2lIKS3bDd8SckyrlMweclIVFfvxq?=
 =?us-ascii?Q?GloGpp6U+kwneb3HuivRKRIn6h5ZzlitMogPOo7hunXVRN05M2odYpcOhI1J?=
 =?us-ascii?Q?hhKkRdGF9sVQ/NW3sqhl7+mW2cE/42U8lncOuGTqKL3O7oY+wvrVHt7F9X0F?=
 =?us-ascii?Q?RWZPiKsPAHX/JGItVY5NrCo7go0gih67MknOFodoyM5Zkv5WJwi7ODPliIeo?=
 =?us-ascii?Q?YG7fSnIY7EaAZZTNwdwFk7Qj+ZKF1eiefiYXi3dj2dzqPIuSiXetzXr8ZwkU?=
 =?us-ascii?Q?Fgwn9iSSVMyX2+TN2N/s56xkXLJ4WojQgde1TZo5rMsgtF+3o5l4Y9YdOaHN?=
 =?us-ascii?Q?cAxm/29BQYIlvG2QF8Nf22Ie4SUGCDkISu0uwsk9N3xWoVwO73SaPWtAvC/L?=
 =?us-ascii?Q?IggHSRBrMn/tyybF1rkpEZVTALtalqm1KKtAuIxnnSWlL6jgwezNIsIbls5D?=
 =?us-ascii?Q?QciHZMG9O6KlPeh+00H1mIi49E9YxpgaGcz/JVhAh4V9aKgBZybCsbDKB/vE?=
 =?us-ascii?Q?imXarUXCjYxAHDs9fIBdb3+ZlQ2Ea/cN4sksJJLWPcAO/VvlzlzZ88Qw/vop?=
 =?us-ascii?Q?O74TTuLKj0759xN6IWnieiLMpvbqudz56x08MJYRdg/hIthv5xTsscUg+pKz?=
 =?us-ascii?Q?W/Ea5l7knVHS4TlmsP6QB6+tA12vnk1HMVdtoB/HcWykzpVQY5pyyzbycPNj?=
 =?us-ascii?Q?oqyZ8evbtdwxhlL4h0L61L8xPXRTq66esNi+7nl43QQNepdZDvVMXQSZMPzI?=
 =?us-ascii?Q?uNenhQZZ4H+ip3u2N5rQdbySc17RS4WlU1rRjYStT3dzqw2fiKlnNEk2qmwO?=
 =?us-ascii?Q?f7wPsRHVJHTy4qMbEOUxkTUM+c/gz45fWXGw8lmiAr/zEiKmufZRryAphe0U?=
 =?us-ascii?Q?VE4HYaNM+X84DbusHgFrDXmqVIYCokk9uW+4kYZtfVWWRrNnmHEbQnoyeNUa?=
 =?us-ascii?Q?3BTwDd42Y2yXEn8OUUCrr+2MJ+NSN8DHo5S1oHzsqDxJC4kJdpupV15jZwr/?=
 =?us-ascii?Q?KEXv6/kAZe20846gTwoYyhaBJJI8hQaOCUDVvU3tO+wun28t1wzk+dAgxTAs?=
 =?us-ascii?Q?POm8SKhXMOH3NuyhgFlE5rf5lsI6Ye7ue1YBDuBz3TZVeVqLYIqqadX3D1R3?=
 =?us-ascii?Q?2QINp4piywrnMW4xgbAque4BptLVWL3JyTceWa9v9fskF3vwpP+uZoM3r2m0?=
 =?us-ascii?Q?Jy6qCrIThb3BcDDLtQ2LDzN5WO3ic+tDvyXAm9ZdS1iAT4h0ikSWS1eMByIB?=
 =?us-ascii?Q?kQHKcjP0gbwuF9fr04bmMvsNWZ5mEdOdYsoLFslNHowgsxK77BcpODlEdpkG?=
 =?us-ascii?Q?CHTvQpfXFKYYXsg7QI+QxGZrry7isrILGMJinM36AFoY+QenN1OjQo9DguwC?=
 =?us-ascii?Q?+rxJ6ENOumn/F1TxEKDuGJp4rvCJ/5u2u8t7+76OGcGMsFnlswYRNr77U3AW?=
 =?us-ascii?Q?IAIj2bs7vYi1ZU51Rjzax4YpY0s+4SF6BJs0+AsanzN1vYRU1wSJ3kCNlcah?=
 =?us-ascii?Q?WXdkusrx4NgJWqNMmYWW19Kck1t8UBg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a5cbbd-8dd3-4979-2254-08d9baf646d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:36.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ikKMmd3t1ub5ye2+S0bHlBif0PCoY0lhAegtxDJBVGCPCOLg9G1ziztuFQ93HQXFQnhY5ye7D1UaOCJ4Kb0ZdAAy/Mhybx4aamSwXRHLq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We need to return EOPNOTSUPP for the unsupported mpls action type when
setup the flow action.

In the original implement, we will return 0 for the unsupported mpls
action type, actually we do not setup it and the following actions
to the flow action entry.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d9d6ff0bf361..7a680cae0bae 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3687,6 +3687,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
-- 
2.20.1

