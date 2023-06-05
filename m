Return-Path: <netdev+bounces-7935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF75F72229D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 290D11C20B98
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC770134D6;
	Mon,  5 Jun 2023 09:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D871549C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:51:28 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2129.outbound.protection.outlook.com [40.107.96.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCCFD2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+nzAKnvFeWw4+Auk6VOCmIa8h5tnBRS/y3m+lxyX4dnvFOssXTaOqfM0y5OTuicXnrUocO4Km/U6m4ogZWX8slqJHK4fjhR1hgvQQRXDdxRrLnxArIPs9FxqXcQSTCTZkU7HpPdA2NNPbq6gBA0FsAWO6eFwwONRNSzxenRu4LPSsYFn94wDLv5pQnvE85CvvzEQB94aENBw1mKhobq3lLr7jXUoy5cKQixAEFWdI84cJt8fQdc8Ec2FxqhndRB2jSdkjESup5AIL/FlPXakfHgjq23x7Qw9j5RWH23a9MmXEcx/1G6YWOmygXEWlr/Qlua4geNG27tvcOKq/LVEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCqrsPpXXSWUlzDaG34ei5ef2S+WYpXFR+/niPFzmH8=;
 b=Zu2WLFWrOGqffJqbHZYBuRdANymWmhzg4/MOX57wWdk9xcge7ttzeIm0kjPxPGlQWgbOLU63NofX8XLYfph9pyKn4EUFLcPJ7gkFE7RURyTDLrXyFohP4jT0Kkhp2tlIfhXfJXAoMa1khlBxjZ3KnQhSGIllh4O1E6lhVSzId2MVl15442IImgqKj7OP89P4Otw80kJytgt3YQWRBhJIsIEibb9qQH7Q19EsEaQ/bePjy7KoCdiKtMuoXaSkMX0isXmTii+ySQQbdsd2wi6j06ERbvoqy3CRLXpDXE67cgP7Exg0btuQ7DhTnCKan3BNlGhuUPKWk6PhG5DfmgcR5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCqrsPpXXSWUlzDaG34ei5ef2S+WYpXFR+/niPFzmH8=;
 b=hoUWlZkEEt7faV0liZT/PkFoD2brtfPjJn+vVQrGSom8eT4FpYFwr30OAAaDZhFTOsKFAEthiK2/FUA5aq/gJyHhZJ2qlq/4SR4CiQSvJEvJp4P6/119QqqSUFv4aPbpV7/Eq8NyNvGvX8JQohUhKTmqFS69/y8VHmYzJE5XU4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5081.namprd13.prod.outlook.com (2603:10b6:610:ec::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Mon, 5 Jun
 2023 09:51:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:51:23 +0000
Date: Mon, 5 Jun 2023 11:51:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com,
	anjali.singhai@intel.com, namrata.limaye@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com,
	tomasz.osinski@intel.com, jiri@resnulli.us,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com,
	khalidm@nvidia.com, toke@redhat.com,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH RFC v2 net-next 04/28] net/sched: act_api: add init_ops
 to struct tc_action_op
Message-ID: <ZH2wEocXqLEjiaqc@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-4-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110232.29349-4-jhs@mojatatu.com>
X-ClientProxiedBy: AM0PR05CA0089.eurprd05.prod.outlook.com
 (2603:10a6:208:136::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5081:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dbdb53c-f20f-48b7-5ff8-08db65aa6bca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OXDJjz8ErrkvPhbJu7816ph2dw2SgtyzNikIJooF25vYKBQXyfndW/zRaxNBuAoyj/5+1gYokNlDCdh+rkwJFEHTNUxPOJgmNv+2HNrjeVEASqGpTY19OmE66PZhTFLicqafF5vPrELajjg78TdziXqz9D8FbjRzrASsSUTOgivmWRFMhdZnVYB4EzG7Y+Dv6OY60LRE1zXKeVjl0KqAXYUZzWpwtqfezXeAZD9xiq3B6k90Imc/Jg80/nXDV6BrEGSganqmIUaJhnqA1on9pkrjEDoPRG/QlMtO5Gsf5UkiyEpQ7+Bun68Vf+yr0XxTjOaxlYqkxK/b6wOccn1YwMxV2es7xIX6vq/kOfNza1zPcYU8ftKiEaQyEfe5IDHkhgx1+5tJBTOq9Wg4swdHo+a1RPfu8GzdHU4gJ3IGUjNfuBnYS/hQiqr//eO3xsSphakXbRXLXl1zYlBaBXxTIlpYna5n7OYLtO7w+gD6nxvTAFdIAQOh/qLJA7IH2jeIvDqgWfJM9SviwHaS1kGwXYNZ2pSbH70fgcoUexeSRuU+HXujChKlVYqc2RI3OsPB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(136003)(39840400004)(451199021)(5660300002)(41300700001)(6486002)(38100700002)(6666004)(7416002)(44832011)(86362001)(6512007)(6506007)(316002)(36756003)(2906002)(83380400001)(4326008)(6916009)(478600001)(66946007)(8676002)(8936002)(66476007)(66556008)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XCtNbLYahaetoLfExPwPpsp3Ght7prvNTG/C0Q1Mdq2+ZrttZMEKM8l5xmRC?=
 =?us-ascii?Q?wGZ4dOeaSy3zPWwM+aViEPTg9eeMCPHQa7vGG52YmNKnXZe2wxDim2ywJpfS?=
 =?us-ascii?Q?b+bXas7P1b0Md5KC8yhB1tAQiDpk1spPRMha5kdrBzDsu1038TPFopEQfNOg?=
 =?us-ascii?Q?hUEBPm2Dbs+ivsTU5zXqtBrBIZFfuTvprfvlhSCKDjJYRe2ufaNlG0CZGhj+?=
 =?us-ascii?Q?ZTIl3dsZo/guKhyQw0QSXk6N7i7ONrKnmoCXYo0qSS4gH2iBRTo7cqYxRMrV?=
 =?us-ascii?Q?Wb4GF6geaHV9OBeaAFUy0VrUrsieIlGgH28XHSsaAFDhKbhzsqSHNKyvb1KQ?=
 =?us-ascii?Q?yJ9ILX5DSuqqzyrg1Jec3BZGj3CpnIZt0VDVVFVgNBjD9ucS7XDAIGtEks90?=
 =?us-ascii?Q?5nCRPJBikfeXMRwHAnnVqltpWz3t1EJNT3YYcGY981xpQrSkTv3dUq8AvNt0?=
 =?us-ascii?Q?w7sd8rJQOGAIWQfPONoVnaXPpBGRoPoC7zW/LboJmrkluiow7kESq6MgfjKs?=
 =?us-ascii?Q?cNEOr/6NiSgDbAregd3HqhV2IKdY3LzSZI59BgoUx0ElE5970WtoHC/OM5iy?=
 =?us-ascii?Q?VBJPuwqZeuErhQ2OTaMup6GO/2z6FlOt97cCNzQJwjwWRWfITqt8uJURn9wC?=
 =?us-ascii?Q?7UHQjZZ22GUikyJ8Jh29sy4UZwOJ6k8WUGypajE8LmobNvJUiKl8XNvj3Dmp?=
 =?us-ascii?Q?CqcDd97NEcBKkM/n3pNCyBRdkbrDJjOWSoIXGf2jVlg73dw6+ijX79+kuz6y?=
 =?us-ascii?Q?iKz1fS7N4GK/QxIprJ8VRVFUCAUYhIqZBo7JyKPawcQHf4T4iEz7oNT6ZDPM?=
 =?us-ascii?Q?KdX7ruH4jxSosJtePxca/5YGBVdKDMsTQ0m9BnwaF4M01yMTwa4YKZ/RW0zD?=
 =?us-ascii?Q?jRCczzauBq3TBJYFMTWX8FKs52d7LzuFUCOdCF1D6ngEcLuMLrtdWJ556/EC?=
 =?us-ascii?Q?kqiq3Wl85UrQIOQEK0k8hvu40WujzGCc/of5Cma7dIIgDhLtGOcT4Gu6hfbI?=
 =?us-ascii?Q?shvJcPbWjc9of5N+tb6KSsmd6H6KzRY/9I9tUt/nyNi34hyHTAw4z8zzyx2r?=
 =?us-ascii?Q?VPPG5yiGNX/gvx9Ani9YrQ9IRAjUHwj7qql5dGjsWXWCMKmCSLF0frJebP6o?=
 =?us-ascii?Q?vAv/0q39D3L2E51s1A1dz89D6ShJ8+DBaQwR7Neb+yWhkfYUXjssHSwyX31s?=
 =?us-ascii?Q?rF3sUvOEHy+VVOPlOA3dJkIndEMjX2KPNXxK9AjLY58CoIw9uwSFmgqm25L6?=
 =?us-ascii?Q?NwGzOB6ZShA+VfhcaLKt/ZNIfQHwtNz3ulE4WlX2JVWfuQ6h92h6CIXEqvIW?=
 =?us-ascii?Q?wqq0S+KpQiCSu94qhcNoiK8tkPZH5CAv81/Zo8gqE7g8E55Pl7QORfqbhmD8?=
 =?us-ascii?Q?ZufZyspuEH38Ax5fKqWOkoKSu5lCVaWLWtX6CUWZgKp3MX4yq5PIge+aCZas?=
 =?us-ascii?Q?CnPfVyO6DiDDehFvT0ER7FeNz4KrdjrSQgbgZU5sAJqGsFPx7ciCUq49bJfH?=
 =?us-ascii?Q?JTQ+pgD36mp8xLHqslRF1nE2V8juYM0Bzy5EhwqfFqZsQLbpCHcnhdh6P65Q?=
 =?us-ascii?Q?8ECtYkQEYARdcxmLUQhJ5ZWQoHs4sY1lTvBIzd6bjbk2da0D2jNNLJ9fbnfi?=
 =?us-ascii?Q?wliq4g6Qsuq81SIGOAysIQAQroLq/PK7bsIdA7wHA0xB9RuXwqA2IcO5/L9/?=
 =?us-ascii?Q?L95Yew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbdb53c-f20f-48b7-5ff8-08db65aa6bca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:51:23.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCjmCjRRATf64hYmTi1PCNQethrEUYmRvEdOkWbNh7BVZkrwxZT5qUojynN932jHiTR0uRlqm2TbmzQ1TQM0NJvFMi/2R9n40TH6CCmqFUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5081
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

CC: Dan Carpenter

On Wed, May 17, 2023 at 07:02:08AM -0400, Jamal Hadi Salim wrote:
> The initialisation of P4TC action instances require access to a struct p4tc_act
> (which appears in later patches) to help us to retrieve information like the
> dynamic action parameters etc. In order to retrieve struct p4tc_act we need the
> pipeline name or id and the action name or id. Also recall that P4TC
> action IDs are dynamic and  are net namespace specific. The init callback from
> tc_action_ops parameters had no way of supplying us that information. To solve
> this issue, we decided to create a new tc_action_ops callback (init_ops), that
> provides us with the tc_action_ops struct which then provides us with the
> pipeline and action name. In addition we add a new refcount to struct
> tc_action_ops called dyn_ref, which accounts for how many action instances we
> have of a specific dynamic action.
> 
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

Hi Jamal, Victor and Pedro,

> index bc4e178873e4..0ba5a4b5db6f 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1006,7 +1006,7 @@ int tcf_register_action(struct tc_action_ops *act,
>  	struct tc_action_ops *a;
>  	int ret;
>  
> -	if (!act->act || !act->dump || !act->init)
> +	if (!act->act || !act->dump || (!act->init && !act->init_ops))
>  		return -EINVAL;
>  
>  	/* We have to register pernet ops before making the action ops visible,
> @@ -1494,8 +1494,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  			}
>  		}
>  
> -		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> -				userflags.value | flags, extack);
> +		if (a_o->init)
> +			err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
> +					userflags.value | flags, extack);
> +		else if (a_o->init_ops)
> +			err = a_o->init_ops(net, tb[TCA_ACT_OPTIONS], est, &a,
> +					    tp, a_o, userflags.value | flags,
> +					    extack);

By my reading the initialisation of a occurs here.
Which is now conditional.

>  	} else {
>  		err = a_o->init(net, nla, est, &a, tp, userflags.value | flags,
>  				extack);

A bit further down, outside of the else clause above, the code looks like
this.

        if (!police && tb[TCA_ACT_COOKIE])
                tcf_set_action_cookie(&a->user_cookie, user_cookie);

        if (!police)
                a->hw_stats = hw_stats;

Which causes Smatch to complain that a may be used uninitialised.
Is this the case?


