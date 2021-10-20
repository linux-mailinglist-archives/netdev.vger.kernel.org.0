Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5C4344A5
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhJTF0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:26:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhJTF0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 01:26:52 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K1S76V010669;
        Tue, 19 Oct 2021 22:24:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=IBtSEZTaji2sLOBjIUOcVNGqIVELZYTcFrfRpOe/fKQ=;
 b=QEGEVL4tMgo1WrebvpGIqRZsOoWT3uusF8txOSSrBLiiRr1Ic6toaBkkwNAEKMFo9brH
 5AYhYdh9GWWzKI14f5oEmWVZQE96n4y5+/++bYXVkdD6fiVS7K2QN+dbBnhEXiVlvkFT
 4WlCSo15wyiv/2s01Ya7PS9T4WOEax8pWVs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt9fch0k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Oct 2021 22:24:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 19 Oct 2021 22:24:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPGG8SWfsi8lKoyZ6ct69B8j29bUmPs6sxs/G372qhTLPbaE8rV2bwhW+9uZz61ETipxCe8zNXmRDO/NxmEouU2ht6mY3X9BqxcL3K0wCRJNu3f+kNbAhf5paJ1grUT8WN5eord3yOpmrJf3POFlGUuOFGQylrvcDuhuxs+Qm7uot/aJqYSy5wFT3H055eEOyasffmJEBr7mEhfv1a7cRI+y5pTMeTexSLC/BajkomlEJ4RhM21hW9/3su3fXBo+qcQsnb7YGtnaL/q6ttYGNWL0qBN3zFF8i7IFU5hQq2E3IlL0B2EAnCHWYd8SfsAaQkArssQ0AfDYEWM5wzuzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBtSEZTaji2sLOBjIUOcVNGqIVELZYTcFrfRpOe/fKQ=;
 b=j1/I9f2ywmFdrpRAt6uXMJJoR0NqZi/4FeFdxePK+20Ia8SihzT9NOon0EdJ6c/z1VhLkerR8BQRAM335e/DdmFmqJQ2d8jLs2KK3Fx8dCsmsts666hCwvXjvHhhlX+Hwoz7OXaIKsUsX5hYSp7MLMFB2aCJFneBk6yckF+n/BW6buvbBn/BKtDqJqTlXQpAect47uGJq9/7hzU0XWwCsMinJEE8jlsq3Hc5vji2IWrnTXNlHQlucVorQP9W22Y9jJ0VM/L4kiPU2D64FRFKA9A6RAhScbkvW3RO+9M1ShxsJrbAWRfJMgPxCo8PBiIqHKUp3pOmI4vAlDr0WI6Y7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2463.namprd15.prod.outlook.com (2603:10b6:805:18::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 05:24:17 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 05:24:17 +0000
Date:   Tue, 19 Oct 2021 22:24:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: hook .test_run for struct_ops
 program
Message-ID: <20211020052412.zmzb4w3pipem6obj@kafai-mbp.dhcp.thefacebook.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
 <20211016124806.1547989-5-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211016124806.1547989-5-houtao1@huawei.com>
X-ClientProxiedBy: CO2PR18CA0051.namprd18.prod.outlook.com
 (2603:10b6:104:2::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:aa06) by CO2PR18CA0051.namprd18.prod.outlook.com (2603:10b6:104:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 05:24:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 537075d8-fe10-4215-156a-08d99389dc8e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24633AF3CCEAB58F4F130D61D5BE9@SN6PR15MB2463.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MT4PR1fDtuN+RNLkmcYulqu0D/Sj+ZckiJWEGW3kSigbmy5L2n2MK49IOcHBvqNrDF1JRUJQZ+ynvgn/Yu0emCn2PU2L0AvzwUJAvNozrlPLrHjBaDfyvZUnR54zrBEN0ji9THf7prUsD/3ZQs+S6KfshYvuvNh6FhnYdS4UL8TKndwcQ83el5H8SzvihqhyEbMjlzeiKUC6C06VqZS7ncHcnybtxKHbrLXzd8Qq/KrA7PjgCfoC9BP2oHN8IsaHJVNIbLacBuGnj0nU3prYGpirD67fBIcdzkszUM8WpIwUjUzHNo1EsA/enFJy7oVUw+I2WXf80/KSVd1GAFzJKfCvOCSS17BCaNcwZ/UNkJoXjtYx+j4eoYWhUjynq8nIaP2J8ZOr5/KDRhMGCDAlVbHJRfUbh5j33CpycYjV5KxLG2nPKn87flO56zOEkCJa1OIE3Gmha+b/1m4EziMvlHhujX6O+pLSSmcZXvNFo1eqbVR8W4BuFSILk5l9ldFGeVkwfwtQfp6NoN/fcv0pPnf23PMmUfT7kaQptj1NNgUAEiKOXxb3UgA8M3BF142ZCkuGRo5eg1+DKyodXfjVZoERJijtPyDt2ILxf2gYa5eYM0MOZ+AcOsSKqf2n7ZS0y4PJNAFMkUD4caA5ySKXY4Fv3dqQ3XAH7fUxzH5WhVwwc9M7TJunhSH8f2SXr4sshm8PU4tVsufJpRXMge9Ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6916009)(6666004)(38100700002)(66476007)(54906003)(9686003)(186003)(8676002)(6506007)(86362001)(8936002)(1076003)(7696005)(52116002)(66556008)(4326008)(316002)(2906002)(55016002)(5660300002)(508600001)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtBZW5honWs/HXDQb4WAC3xQVniC7+IHhcGSvJmdM63IIUkj2JPLpwY0l8Yp?=
 =?us-ascii?Q?r9kZIp82Ifd/OfXs2tfbmWpam8yOI8C+efmLmIeTeu/pkxwjLIzCu1YEQon5?=
 =?us-ascii?Q?EuKN1v+NYHKmTI3b/x9O7M9gxb5RdmaaXKCoyfDTDBftM2Y3Dg37FzZy72sM?=
 =?us-ascii?Q?9Ve4fCFhS1XGXxC+HM97xIq3f8WInSL6KEUCr2ZRLM22/GDjFijR7ntcKMX3?=
 =?us-ascii?Q?Z+GeBGypxq0+tZmZCtqGLYXc3xnEsr9HeTq0o79KivvI9TMxYgLPnvbCoaw5?=
 =?us-ascii?Q?0C+ZLNh5Ieszo8rZAp1INgiVVnfY9osRpHx++8GEdxCYAjyTbFXA0ZkileNI?=
 =?us-ascii?Q?XLcA1cGtUmhhmGkuu1kSAHACDcwxY74oYPhMp55WLivPtc7+PviBqaxcNPdb?=
 =?us-ascii?Q?qKjbhAUbbkRc3Ej8kyx/Q/4cx3cXwM8F9Ft482L5eOvkPRURJIN2Vg7Mi1sG?=
 =?us-ascii?Q?tz0Aey8QYgv6CcpgAXu8p0Tjte8bFD4SWKJe6VlFlNfGeT3BFNEVWLIzweHT?=
 =?us-ascii?Q?3p5i/G9AX/mwn+fYWb/S/NGeJeIpXI40bDiHL8xbFiGTaSNC03zzVXYy7aAk?=
 =?us-ascii?Q?/qTYZu75yu5kPIdLUufKl9Qjb83nU9Me0yNqyT+hH91P7d067yhI90n+Dd2L?=
 =?us-ascii?Q?GT+mQYKt8DalI2+WIqMS42RVS2GxwSYoKBUiuAETv/37djo492WKG3ubW9x3?=
 =?us-ascii?Q?u8vpIeP/QdCEnimKLAgb7XLfgyjC2BQn6gJuuG21do3Yb6EcgPPdoiGU2I/R?=
 =?us-ascii?Q?UcoXsLZD1ikK6MdGnl3blFOi8Ys27341EAFFgv3etS7juSA4Ro881YBb1u4M?=
 =?us-ascii?Q?oCPiIwxsK0gGyvHOsx160vncc30mFlTGzSNmE6V7gfxROxoReklczYh9qlWX?=
 =?us-ascii?Q?N6JDaqlxPkqDbidetwCGR5ufXlNJ34h6dC+VPhgPKkp2dltSNC36Po2q7idJ?=
 =?us-ascii?Q?cB2F/azqnJ9Fo4DRxae2w9ElvFMAMagYrC+Lp0djcjre6nvptLTNaKvTFwSC?=
 =?us-ascii?Q?mnyUgkQw9LXfw9dMrHXY5szLgHhYI0DbY0wh8lmWZw1ze/SEFG/jmAS1DCBz?=
 =?us-ascii?Q?JaIw7cvz2VuIpncRgKqVhDe43TpjRs2f7UJ/DiEy50OXVnP20n8sOOUI/dKe?=
 =?us-ascii?Q?/hHsrmn2BtnAmbCKbyjOF2pMU6ZwJ9cUTJmXcx02ex7FTJYLKnbGdtFAS6xr?=
 =?us-ascii?Q?GYSRIxNYgWzh2fJfmCajxVM1yCjA5m8O0EuU9IRIcQUT7m6/UQExpMVeKNHE?=
 =?us-ascii?Q?rLmIWryd7j342czpahI1TsG4MxQfcZPXLHqpstPvKdOpTlft3Zq2b7Hmli3f?=
 =?us-ascii?Q?5waAMQwkR7QR+uQtjyhhe+6DWmpQqVARq7CKlRQaVYRiGxuvAnI9vo8rwuHF?=
 =?us-ascii?Q?FDe2f3A=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 537075d8-fe10-4215-156a-08d99389dc8e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 05:24:17.2415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2463
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3as6Xzn1f08om_9fQK5QeMw1bx0OEUS-
X-Proofpoint-ORIG-GUID: 3as6Xzn1f08om_9fQK5QeMw1bx0OEUS-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110200027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 16, 2021 at 08:48:05PM +0800, Hou Tao wrote:
> bpf_struct_ops_test_run() will be used to run struct_ops program
> from bpf_dummy_ops and now its main purpose is to test the handling
> of return value and multiple arguments.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  kernel/bpf/bpf_struct_ops.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> index 44be101f2562..ceedc9f0f786 100644
> --- a/kernel/bpf/bpf_struct_ops.c
> +++ b/kernel/bpf/bpf_struct_ops.c
> @@ -11,6 +11,9 @@
>  #include <linux/refcount.h>
>  #include <linux/mutex.h>
>  
> +static int bpf_struct_ops_test_run(struct bpf_prog *prog,
> +				   const union bpf_attr *kattr,
> +				   union bpf_attr __user *uattr);
>  enum bpf_struct_ops_state {
>  	BPF_STRUCT_OPS_STATE_INIT,
>  	BPF_STRUCT_OPS_STATE_INUSE,
> @@ -93,6 +96,7 @@ const struct bpf_verifier_ops bpf_struct_ops_verifier_ops = {
>  };
>  
>  const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
> +	.test_run = bpf_struct_ops_test_run,
>  };
>  
>  static const struct btf_type *module_type;
> @@ -667,3 +671,16 @@ void bpf_struct_ops_put(const void *kdata)
>  		call_rcu(&st_map->rcu, bpf_struct_ops_put_rcu);
>  	}
>  }
> +
> +static int bpf_struct_ops_test_run(struct bpf_prog *prog,
> +				   const union bpf_attr *kattr,
> +				   union bpf_attr __user *uattr)
> +{
> +	const struct bpf_struct_ops *st_ops;
> +
> +	st_ops = bpf_struct_ops_find(prog->aux->attach_btf_id);
Checking bpf_bpf_dummy_ops.type_id == prog->aux->attach_btf_id is as good?
then the bpf_struct_ops_find() should not be needed.

> +	if (st_ops != &bpf_bpf_dummy_ops)
> +		return -EOPNOTSUPP;
> +
> +	return bpf_dummy_struct_ops_test_run(prog, kattr, uattr);
The function bpf_dummy_struct_ops_test_run() is available under
CONFIG_NET.

How about checking the attach_btf_id in bpf_dummy_struct_ops_test_run().
and then rename s/bpf_dummy_struct_ops_test_run/bpf_struct_ops_test_run/.

and do this in bpf_struct_ops_prog_ops:

const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
#ifdef CONFIG_NET
	.test_run = bpf_struct_ops_test_run,
#endif
};

Take a look at some test_run in bpf_trace.c as examples.
