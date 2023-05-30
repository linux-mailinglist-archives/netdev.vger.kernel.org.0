Return-Path: <netdev+bounces-6341-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB09715D57
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB4E281001
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3520617AD6;
	Tue, 30 May 2023 11:37:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FF913ACA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:37:13 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2119.outbound.protection.outlook.com [40.107.92.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852C1106;
	Tue, 30 May 2023 04:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrcshF1UZxJ6wQtYS3XCblvTSWtLQmjwHLnVVR3gVMHf56056tWFywDexSHlEKB4ADRTvLdY+2ZEptoiKcDgAeq0Do1kdx4t4du0RPuSNwld6hRMaJkFk2FA77dA+ux8M2duuYCllkKlcDu9ovVgEj6uFpoqasZbr/t3ker/P8A2hZxG3jLmaGzz5OK2OENezaGfToaKEoRLiKw7w8G9ffAojF0ICtWRXtPtRNPbd/UxmqPJJpsEws0Pzfe5+zR7A6w+nIgnfJ+2OvUiU5WS5Co7HTYMcjJJ4kSukLE2TNDGyrJ8LD5+5X//EAHP0N8cqKe0MUlm8rxeZWrNEMy93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHyq1pXZuelDWThSWRfLOszLF2oU308k65IQz1pq4jM=;
 b=XgT+5vF0s7T/KLu6dwOlQ2q1vv1yV4L9tGSRQ4GVX/ict+hmKNrgigXXYodboTnITlv9w8G9ZBl004SlmFbgj4W6CU+abFj/wNGZwmqZsKPNjbiWbJ+p80FONNaEMFk7cjEdFNsRKhnfpJ+aj7MGu9k8UD5py1qNWyoP9MX1i0A6L+3+FFztIIIs5oUn7HR/Z1r11vKO9eZUU8TqFrBf/NKhn0mmNym67cQobHIwmGeGLNcS6/lfvu48IaIv0aS/rk5wTOklqJ2WMlMh4NL9M11AW/zTzkxPDRLKlGRTAfRkfaPtf0WLfYYS4G7ZH1UWEIXNTvqAydjsmCGF8M1tGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHyq1pXZuelDWThSWRfLOszLF2oU308k65IQz1pq4jM=;
 b=TH00mTHEfia6rpFWluM0rMHAZ0uaLXSUsiAQVeqmkK0hWBDnsq9etU2XifF+K+1SAzs5NvsRtUhBCtwWNqQQFhz57Vw5jLC4KwQyrND6UhowO/7OjLL5uADkEoz+Id7sRx1aVGNLNcdJfB/xzxOqEhJ616ylTPS/uKFr3UgDT6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5711.namprd13.prod.outlook.com (2603:10b6:806:1ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:37:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:37:06 +0000
Date: Tue, 30 May 2023 13:36:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, simon.horman@netronome.com,
	pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Message-ID: <ZHXf29es/yh3r6jq@corigine.com>
References: <20230529043615.4761-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529043615.4761-1-hbh25y@gmail.com>
X-ClientProxiedBy: AM3PR07CA0060.eurprd07.prod.outlook.com
 (2603:10a6:207:4::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d22713-aaa8-4fcd-0557-08db610231e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pPJWww7eoA55k+Tt1PX33yCc4whNwrRIvoaCr4vZX8Z+8nnehNArbofUJORf5E1CzF5Xr7jgIrag5yYJuM/0CjynMVQL6qGE1oOGbVHEP10MKnYMGog+NgQSNvpxLtn9r9C5ojVsyvDTzHEDckScpB98QWWYQh0UY19AL/K38EbIcoR7MYaTenC5emnmU97fWbFiDtmoGMO4K71yS64WXf48ee1trJSJoqRq1yn4eD5cLzrjEHxA5POp4UNWlPhBlAnwEjpY3mTljPT6S00fXECUDkphVb6SKwjYo0ilp3I/nvEWcdmx6hHZLRXc/BKgzs1Vx+j0wkPvu4zsdUj8YWCwUP+EJcaId21Z1LHeP8pYjbx7wLYGiQWXqFdwBcTIP3iClNrShRLBUuADU7APEDIGis3DbzIuhTcJCFIgO5Y39KoJlCJKe6OgAk1obQT4Pt6LvqBpCYJjp7kfYBTeCv3TKInsujm4PGL/qDlwwvCYGH6sgxIJil4V1lOLe2TOPQLfFccJfM9slg1pboeq4EOOtL0zF4/9VmJUptlXbK4hE755dNzLhK7cy8zc2x44
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(366004)(346002)(136003)(451199021)(2906002)(186003)(6512007)(6506007)(2616005)(5660300002)(8936002)(8676002)(478600001)(83380400001)(38100700002)(6486002)(44832011)(86362001)(41300700001)(316002)(6666004)(36756003)(7416002)(66946007)(66476007)(66556008)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DTZ9mKnAjhBQmVSQAcxCtr/RDeoqLXKnKSKuAPUN8LU1vK8BDsjMhmdoHFX1?=
 =?us-ascii?Q?nkK/kG5/Ujjt9dR20q0PvDR2dnMxXX+rynHt7vXs8hEiHWftUp4Qju0xm6kM?=
 =?us-ascii?Q?odxPcJFW+N/RhMCYShLAe8uiV+Ye22upSJDr/gOUxVWpawb8YhLVzxvyTKiR?=
 =?us-ascii?Q?RbK1P5yRa9EwLH8ZkAca0jK2IK/GpFi2ZaFgKLzg55QsBrVe/0yznNv843ug?=
 =?us-ascii?Q?7SDHIjFbDxHAjQRvQ09vayKfdS7xnWxP57GPa5TOFJtHux0G58kj1IyhBJoY?=
 =?us-ascii?Q?5bESdfjCIxCd27IEU1qiSdwbS/wVonhoOa+YTRpni576gMxvD3RHXfLBlAIR?=
 =?us-ascii?Q?95m5trwnYkbTz5HaIw6r7ap3Dc+5H71q++33Y/eqFOwHxvtuvvH/RJGdwPtW?=
 =?us-ascii?Q?+3i9mgBgGBj3RZBqfuLEaBwYG8UsMM3e1ATKz2/Uu4DB/QN5p+KtTfvaDszF?=
 =?us-ascii?Q?1IF9C7PDtM8pv/Q3mUnYRYughYfeicl3hR5357kuA63UfTx2J1etSo+57+Nx?=
 =?us-ascii?Q?mkyWZ2pEUpugtmbYh0SITCE5MQ4PDbw0vA0HDnzMaxBrT3zGM8pb+uohyEL/?=
 =?us-ascii?Q?k3xenjP7uZBL1R/GIBW4XdwiXniaODBTkxtCi7CtHmdTOxG+Q/rMRdkPjFgz?=
 =?us-ascii?Q?7R/KdY8ysKLYOBhP4ors0EzJMTelhsHwgiTYOXanW0/+EQuRgGzYQjrl6OG5?=
 =?us-ascii?Q?kdn7aHuE1PkTs64Oe+oDRAVmYKFl8KFHg/2adXY84S+g+1DY4rW8R+CR+B6p?=
 =?us-ascii?Q?5V4NlT7qKXS3clIJLVNl7FLJ0VHsnKBDiL+SSfKmldPtgwefVQ88c/zuzSSX?=
 =?us-ascii?Q?a0qF7EdQiOd4JAny0666P6PB33ybD27UA9rptVDBLD1j8PRvlL+rlV+7s8qC?=
 =?us-ascii?Q?5H7/Ng2ALNZr5djV3bhjWvDCi1lWsXpofjnGECe73TzWfmyatQ8GKIbdcS55?=
 =?us-ascii?Q?omniqFV5efd/d/g2arubcb9V6cn3HfHJM9k38yBrrhmsgcEoYeKSLRkQVwDK?=
 =?us-ascii?Q?ABUnWbnZfwAke3tgIYUr1AsKaM1mfiBePOGaYAMnOccdbzxVJkdoolasRpvj?=
 =?us-ascii?Q?28hWhSDLuyNvaRvIgubra6glZcYvuqhB6c1foCZZ0v+EmzcGd3P9knDzDMMH?=
 =?us-ascii?Q?jJV7P7wQcKVPAoWLb1XeyOVvr47fYNTvraTp0sHteymcCzk83V2e/K3Wextz?=
 =?us-ascii?Q?L12y8yZxOiI12NVJBUp2sD+jTlFL6wq51MOJ0w1LUFZiBKwV3lAQcOdlHeLu?=
 =?us-ascii?Q?HRGAzmIhTat5559IBRVWbDzNFg7TwLlSk7bOFRjUCMXj4kh2eCP9UVL+DyTx?=
 =?us-ascii?Q?UK+ba0ArMwJoPjeDx1z1E/AdWuPlqmBPBzlCiqxjndKt42IpnRkqeIGkYjHu?=
 =?us-ascii?Q?pVPWonMMtS0/eZc0fVdFUm1zSk1m4A2WV5MxlrEb8X/9IkkVSE4CvXwFoQT9?=
 =?us-ascii?Q?QODXlNJhSZYEW/zvVYeCpiaBwGM/4hswg1QQuui1iqD403uZ8WM07WlXWjEt?=
 =?us-ascii?Q?hDAHwa29ikUFx/eQYA9+CCktXQOiRwoN7Q+tS1tPtP9Fak8ONOAJ5Dn9EFEM?=
 =?us-ascii?Q?tf8VceluEI25Q++SBmCZRrxhn5oGhSadsml86GAmS+SqCZklJkx6queE1F4N?=
 =?us-ascii?Q?ERc31vA1M8DevK+WOxO0cepoYbreVrJIg2MZxxdhxjwyeoSCGZPbaIEgwqT0?=
 =?us-ascii?Q?QEaJyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d22713-aaa8-4fcd-0557-08db610231e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:37:06.3087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DD8mbsCJ/FeUP/LBnWxQeRohf39i90AybplzDaYv99aQF/4eT/0+POlY4eD5CEAI0u4giCyisjTvmvd4PVrTxpnmOlVpq7OmaGV+6w53Vow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5711
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[Updated Pieter's email address, dropped old email address of mine]

On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> size is 252 bytes(key->enc_opts.len = 252) then
> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> bypasses the next bounds check and results in an out-of-bounds.
> 
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Hi Hangyu Hua,

Thanks. I think I see the problem too.
But I do wonder, is this more general than Geneve options?
That is, can this occur with any sequence of options, that
consume space in enc_opts (configured in fl_set_key()) that
in total are more than 256 bytes?

> ---
>  net/sched/cls_flower.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index e960a46b0520..a326fbfe4339 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1153,6 +1153,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
>  	if (option_len > sizeof(struct geneve_opt))
>  		data_len = option_len - sizeof(struct geneve_opt);
>  
> +	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
> +		return -ERANGE;
> +
>  	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
>  	memset(opt, 0xff, option_len);
>  	opt->length = data_len / 4;
> -- 
> 2.34.1
> 
> 

