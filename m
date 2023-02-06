Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A530368BAC5
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjBFKth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBFKtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:49:36 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2129.outbound.protection.outlook.com [40.107.93.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDE655A9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:49:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFl3gnPta6lg1cEOyOYrONTFXJU+6uqd5Bpt0KsLUX+SSO0XhPfjOOrk6H+ezA0/09JheTCE2uEKdnwH0Ef0ytU02AQ77EC49UnGhUQ5n8dBVjZ9Dk2r9EujtfXqRGtxb6xa3DFNpGtKLXdHx1ZEXK1yf62YWxzyAEF3QrewdFXtYjjtxsSYN3Bn25Hr/ei6Wpf47+nLkceG5RpZCVUCDJn7hNifg1mHCyah8kQ/v6+r6RYyHo4wPG/NpFXgWIPFBc0BFzl2HkWIBBwT4t6StJPvxb4h+S88XqzWp2dILkVsa8EvVUNj6wvkKD788Vm4zUjKbWv40/ZKBv+CuGrLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrJzfqSPIUqB8xGH14rwSTAcDHMIsgXs39Tx4nMSBGw=;
 b=Z+Ux3+LpT3ue4F6U8FSPp8g7yGPLfygt2SmTBhictCAXcJ0sJkk3gadF5tvysLM3HdGXUHL7n6oGzOxQkh2tm73Yr7P2XWkAKRZgKU2/7RMjhWefepP524ogyGqE9F72v7IbtY2U/Uf9fKGYIieZs2akinvFsqg+SMWGMUd6MT2Xwp2MwlS5f38fOd3YHl2Cr14RprfmXx5a9ErWcwmmoVDSEnFENLw0SOZZoDh3f9J5NMKGKYGQJ1S1CcjSml2X/9e2o/+TT/l+9KAcHBaH2jWuiYdeFUEPRToss9JZQb8m73ahVA6ObLHOkX6k1r6L9pa/0ySbfGs2Z1r56GI9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrJzfqSPIUqB8xGH14rwSTAcDHMIsgXs39Tx4nMSBGw=;
 b=HedX1jTCq7AAIUGI91jMCESFI7PmSKJ/bArqFjgmbwzFmCqzaXudA5OLFO0rau7frpAo6Q5PSwNJlR/pRASp5RGfWP7TudDro9Ok033RNxzwckxWZObOHfSPzdXjdoL/aY9/6NYofLg1dlZtfyUOYZMVo5O/a6cD5xVvl6I9kqE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3751.namprd13.prod.outlook.com (2603:10b6:610:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:49:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:49:31 +0000
Date:   Mon, 6 Feb 2023 11:49:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v2 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Message-ID: <Y+DbNFogMZWPPhNB@corigine.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
 <20230205135525.27760-3-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205135525.27760-3-ozsh@nvidia.com>
X-ClientProxiedBy: AM4PR0902CA0003.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3751:EE_
X-MS-Office365-Filtering-Correlation-Id: c21c5177-a6ef-43b5-375c-08db082fd3d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9JN+gQZk4APtMjgpmXhTWV8yHPYAZd5Q0vE15Gq9RqzzBqJueI+RY8FvfZsXgtFgHxzzkyVC6zfZ3Sg/o4U91LZh3Q5fIpbHyzbpiH36A/z8vsBh6gxsOFg9CG+sDjK6q++7X2E7CaA2hOGzzSR9Ag994mFQ+TPAHU3+QMOQHBhBYFSeYoBVxe4fg+xGTdrzPSz8qKjZG1vOkOEqq+rm7v6nFoOSLUAh+uRPmV8WFa8NzP9Hgd/8vTjQO8vkjGpMy4I+sM86A8cG5UPqTI+Y30sC59EVmP5AN+/bzK1wGFm8eTxUZf4BQrM5idWbhUUcX4CsscwZvavLg0mD8ZTiZZwCP8xob7DcxElZR5OmcKnMiVoK2iY5IpvOxUNnztTJoPTlnG/itW+E1bfJhWFV6j/wZ0PkF04ycBtscgxZxPM8jbgQV0vFt99LQHsyQfv54nKhvf+T1aphDtS5ck0csBWBGlKAaNRVuBMPKoJovyPJmB2bDGRK47GpNiZVOSc46DUfVu5RfA1I9xTzQSent0ILBufAcXBii80E0uF1Pr/GrpzEo7aglGTcoLOjQ2NBDfnNiJbQKu+7SgRCe3VbhTO/cYLoU08q/An55UensKPWaynkM9DWynSvsyYX7bhhcHGpsxGblzyJQLawCJ8okk5qXaAACXc1Od9fCxAxSIixTj9qoLb9NEDvkHlAQ9y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39840400004)(396003)(366004)(451199018)(36756003)(38100700002)(86362001)(2616005)(186003)(6512007)(83380400001)(6486002)(478600001)(6506007)(54906003)(8676002)(316002)(6666004)(44832011)(66946007)(4326008)(41300700001)(8936002)(6916009)(5660300002)(66556008)(2906002)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7KzQkKDGlBJdutp8KdOGcBnpUCSOnSQ84SNJ8g2uA0j6yANcDpcjEdvqpTRV?=
 =?us-ascii?Q?9Q9DMlFeOynwOuzXIDNGLW378paPJBzXy3zBNVhx+p9iGaDoE6mNJD6IaRhf?=
 =?us-ascii?Q?+pj9iL4qv9X/OEy2eJlFNtKqP/zBneQ2Nc/7YBYaVr3yekYHQi90D9nUosA7?=
 =?us-ascii?Q?Tm49CxN/Td6/feSqHObGjyq52PeTNYaR/6YWlY/mi/Nsfubg9K3HfTgq5CWH?=
 =?us-ascii?Q?xx05WAmbPxynnf/OLoB3dttDYmJuZyI4fvlvbAa8iLyV9qK80MhQaK27uMfN?=
 =?us-ascii?Q?9szo4c5Z0b5jGPnrAvifoTnzphqe/GlXO0gC/5Y2HJc/arf4WcZFl977kaUh?=
 =?us-ascii?Q?oz+lc43kqOOhBoaDRkggDqI2Zxj331CH0fCwWeAYSUiBjIoXcuM1313dLJWx?=
 =?us-ascii?Q?ipeGzn3tBMawR91fXGfmTFWxfE2FqjiLX/vUxGTNM85nZpxB4cNIWewHr629?=
 =?us-ascii?Q?pRoAcxyzAl9r7dVN42TGGctbFICdDMJcwkB6u2aevjocZUqbEIarJvh8y6ty?=
 =?us-ascii?Q?2b9L5VA6+UG4YmBeALworKN4p1fWu5F1glvwkVkxXOnqhCN/NVEWeDD8EB1V?=
 =?us-ascii?Q?CN1ZEh0z+0z3cbKQ7iNwKN2Le93PHiSB0N5TzTjXSuWPcm2/9oZUC41RYsTt?=
 =?us-ascii?Q?bvfQCRQntb6Vm02Gk+N1LfQuUloshXFbF1M0jX124IQXbwO0GL1ja4qqER6E?=
 =?us-ascii?Q?yFXFvdoAy2mn5yiUR6HQ+qIP9jx+puqrfZSB08J/n/OqED0fbP9UoNsj36EO?=
 =?us-ascii?Q?Vwr7erseKYFLbN15cZEu9g9pChvWuO+bYaI8TkfLOxhDg05F/7wzK+sHwOJY?=
 =?us-ascii?Q?vPFBemk+FRKWPCh+NNJP4F+zGEgDvPgRzb5YS+cVoRPmbTKisWZgAyqrDNBl?=
 =?us-ascii?Q?7w/RalLzthPY65ZovfDaBv8arqNwO4YWdEHubmCzldt4Tcfb37aIK/C5SFJz?=
 =?us-ascii?Q?A/ImgHFEHCWBaaWEUlDPcyUVLy0+aNnMtnCKQjZRbiDhQiGhvtuZjfuvINOB?=
 =?us-ascii?Q?dHwl3locAhPX8jSvTzGzZzJhI/hnHXVpcFXp9L10yJ2aWkYX4TlrC1AvC6Il?=
 =?us-ascii?Q?LioLhUOMdgDqb/YqM3jAXzOfekTHK8GsgYfj4X6MI94ht987E3gCzi/C72ow?=
 =?us-ascii?Q?XMQddLZhI5GCcGxs96wpgDGVMyCQLKSmlx116QSxZ+pGSEZchOQCZUspNNpo?=
 =?us-ascii?Q?AqEiUmRMo0e2Ai9ai0sIoer0gO+4HVp5icuH1k4QwvSGeYu9LMksJeM38QjX?=
 =?us-ascii?Q?fTBlwsfYaEgKPXqwBotA5qq2+5cdeL3F2VusK9KQ06dKrEPzWO8hCM5aVplb?=
 =?us-ascii?Q?0RCdbBF8UmyOeP5RgmayTenQRTe+taHQlItoqrC9BRxlJt3XHPphoMM4biJf?=
 =?us-ascii?Q?BnUjGlO7LB9RUn8xp4VLLV9nmRwR3XlyQUWKDdavBSEgqRq9vuhZryl71zg/?=
 =?us-ascii?Q?2iBzj7hWRE4WbOD8LneXgcz6PO4blxXekiJYpTaHgv+fZbG6EET4WAys5DuA?=
 =?us-ascii?Q?i6V0wWtGFajWa6mLbAfJYZBSkFCeoKd6uQMrDMXUUIKYWCHcF+DaeipIodS1?=
 =?us-ascii?Q?DkGdFTJSj3ehaZcAn0EBN+1cw29fCxQ1SYvTCDKZ1wHL3LT1/2oDhjzwug/j?=
 =?us-ascii?Q?d5copk66l9Fl+KikHKnrEnEZebAA3R4ONgFhPb9cVncDkgThsBQq8oHj6Qe+?=
 =?us-ascii?Q?QDKyRg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21c5177-a6ef-43b5-375c-08db082fd3d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:49:31.5121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GhUtCtY2hfuMny/mo96Nqwq7WIxyCknrQYYOR4UuPM8qYO06lkv2/aQUKSxV5Bo0t9uQlKg017tiQjOqCDe7ucX01p2CMYRufGd7NKi2Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3751
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 03:55:18PM +0200, Oz Shlomo wrote:
> A single tc pedit action may be translated to multiple flow_offload
> actions.
> Offload only actions that translate to a single pedit command value.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> 
> ---
> Change log:
> 
> V1 -> V2:
>     - Add extack message on error
>     - Assign the flow action id outside the for loop.
>       Ensure the rest of the pedit actions follow the assigned id.
> ---
>  net/sched/act_pedit.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index c42fcc47dd6d..dae88e205cb1 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -545,7 +545,33 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
>  		}
>  		*index_inc = k;
>  	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +		u32 cmd = tcf_pedit_cmd(act, 0);
> +		u32 last_cmd;
> +		int k;
> +
> +		switch (cmd) {
> +		case TCA_PEDIT_KEY_EX_CMD_SET:
> +			fl_action->id = FLOW_ACTION_MANGLE;
> +			break;
> +		case TCA_PEDIT_KEY_EX_CMD_ADD:
> +			fl_action->id = FLOW_ACTION_ADD;
> +			break;
> +		default:
> +			NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> +			cmd = tcf_pedit_cmd(act, k);
> +
> +			if (cmd != last_cmd) {

Hi Oz,

Is last_cmd initialised for the first iteration of this loop?

> +				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +				return -EOPNOTSUPP;
> +			}
> +
> +			last_cmd = cmd;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 1.8.3.1
> 
