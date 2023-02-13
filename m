Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECB9694B27
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBMP3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBMP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:29:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8276C40DE
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676302130; x=1707838130;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GpiIsIOv3nE7uOr5WdTRDk7B3rZ+upHP/gUsq5wOrW4=;
  b=kRkO+Kz9aFnldl4TiJVFpswh1WYfZyp3ek8XDM1DL1RBXTl05ulPzgSV
   p+BxSQIzyFvxZ4+E48lZmEhWWSqEb37RXOO2YCfY9deEbXqQ6A/OXLUpG
   6dL6HGh7iRj06hcX+aprimylEmw+BXDNzZ8jVjMvDP93O7yYrbxsZ5HIw
   kFvtfa+oPUNjAUM0CnOTxPxj7Ei1o0tvPnjUox6XzydXgbhC8JI0bEVZ1
   yKcggHTRvAEdkP5qeqpF/wfrVAEQksqTQNLR6OdKIdWCci/zLRah9ZtAd
   UfMVl99xm6yoA7w2m9EFo7Bfo7uRRlKpbh1Lo0wA1QSuZBRhpn4zi+M6O
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="333049751"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="333049751"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:28:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="699197504"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="699197504"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2023 07:28:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 07:28:47 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 07:28:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 07:28:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 07:28:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Px9rGKeJCxXv27QouGm53mY1CsiDXYH+9wQKeOz7E5Zd7//jJG6rBbwFhElCYhVpEUb45KHYr2CJeGcdl24JmRleczDINSm6Bw1FE1lCa5S7W54yAv55erL5EjtY1QR3W6zcIbWChFgadV+3YDTR1eA1NtvIUCJyFRJxFRgtNN1dWgvquzjQo3kU1NcXKxQyXYio3smp6pZzLW6ph7O7vOQwhSmWzzqEEY3qjUgWQ1GvHiKPPuDmBTuDqXXI9QAokuHQQgZyiV3bnlxUET87JChIW90ifFmTrgkO9F9esA/5BQFrpvVWlP5CTy8ZuJ0tQuySmdplMa0CH47PYnFKOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/L8RlsRIqB4MMkwJ8h3h2lsL+f3NlhozC8m4zVna7w=;
 b=I+8WtDbPK4fSAqwuosYg4+DM1bTr8T1wr9+b/TrC+oFeVQMT5g1j6u2cOJ3GcXOW2iPkTychYVry4bSGf5f1Bu8XCncmTp3WfarGgJ2ckkJFjbiU7ZjCaJS0MZ4LEvZyE9kWLEJPdHdWoMt6bVsOQexqxXI6Hrrj2eZDsVTTGGLWLnVpOmxbb1fyU27QuO/f50aaYbqCdSS83KzJ2z6IMz+cvu4JyFOpTNwXI8bW83GqLTD/wbaY0Is4xqA6hU9GrDtNye73ZVBWo4q/qldpbmRAbXvKA7TmxJbqW+5prB3wEllE2NDg3qdqgNE33GBjPi6lreDhl3jTeu/pWLzllA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by DS0PR11MB7213.namprd11.prod.outlook.com (2603:10b6:8:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 15:28:44 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%8]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 15:28:44 +0000
Date:   Mon, 13 Feb 2023 16:10:47 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ldir@darbyshire-bryant.me.uk>,
        <toke@redhat.com>
Subject: Re: [PATCH net] net/sched: act_ctinfo: use percpu stats
Message-ID: <Y+pS94Zw93k/cs6V@lincoln>
References: <20230210200824.444856-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230210200824.444856-1-pctammela@mojatatu.com>
X-ClientProxiedBy: FR2P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::21) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|DS0PR11MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 60515a6e-9325-4e2c-d67d-08db0dd6fe2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/M4w/NPiXN6Sc33LNeJ/5uKeHavrsn0T1kO3/WtXwKoaqWPrxDw7rtERpOFonSEGpNMn0TEk4tn8vOKM9XgezmUPd2et17NjNdD+DyukcbHhjBGWSNLxp6MMZ/hEgrAw+3KszsyQkT8jPzmmdPofH09ZGAAnCCdhVAPmtfPzCsY3WLRHctP2FbBNYqB2USJk/8PZhK4Sf5WyQ8ul1p9GztnlYbIbc+lRg/b0y9jf9+SMiMlqRK6Lin4faYxnC2Tn8ULC0jnBvdtoc5Zy/EtJ+aqLZrohnGZ25WIW04AfoByZbds//yrFNpFRgsVZX5HGn6FTjGeQDiQEYshhys9JMliVkR5U5XSdkhT5F+xvcXj+0tH4GoBqdjMC1X8TsxeDJUjMd8626kGnnsHFvOFr/5rEiB2h3rRm854BjFJ25aDlGVr23W3uJE58cPk+VmwQKKFYT25ccE90yQbXnmECGTI2rOjgp9iFezaMAD+qfIT2emEnO79lAFGfFn4Fngwthfr4vxLW/X/vKpUuzb4Ji6PIaJT5xR8jFXx72uwJ636TChYa05eSNdOf+wHS9fDuKZHvzujlqCs3fNu3RykDX4WDcQkAC/gTS+J7cIcubP7XF2pr93Xh3GsqgsF2vYUsJP24Ze+Ztso71RzYF5IJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199018)(38100700002)(83380400001)(82960400001)(2906002)(86362001)(5660300002)(44832011)(41300700001)(7416002)(8936002)(33716001)(4326008)(9686003)(6916009)(6512007)(186003)(26005)(8676002)(6506007)(316002)(66476007)(478600001)(6486002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kWT9flK/Ng0xGm7SzMIBeXkDGrTTYqEK3pVT5P3NAct8sqSTwZz0rktxdKDP?=
 =?us-ascii?Q?UQaY93iL7qynfl7Wv0ScU1ZtRO1XWYlBokKyG4zhlijDe6n3C/TKupPN2KO5?=
 =?us-ascii?Q?J4PjGsPPGZLJfz0WGKIpZJ295QgBH9eR8CJEexO8kQkwRRAsrDpJ/7pwEnBR?=
 =?us-ascii?Q?38ia60smEvxG/Jcw/kknyXcV+99TN1vjhp/+8V0K4agnCKIlu+m5ezPX/3qc?=
 =?us-ascii?Q?y1neeN+ady3U3NiE8nseYRP8Qn2heK/OisOTTV9bNakwSe0Iu7uzA4q3bKAQ?=
 =?us-ascii?Q?IBnJw0CLXml1qNfFRJPrKPXPcP0k9NlRpaL+BRvL+Z3EffIoKRr6KgbCp9Vb?=
 =?us-ascii?Q?ceVeBpfu0fw8uE1SyfD+uYmjnsHBbow4P4fESoiUW9BNOY8hf/q6JALKuZXu?=
 =?us-ascii?Q?CqSgCiM8wYRnoXWKx3xW+vj7hPjx/F3X32aClRLA4F5Q+r1Ksxevvs1YKOOg?=
 =?us-ascii?Q?PVppxLuWAmRIr7sF1IVr2lSm41dHDxaFuh9IwHqsvM7IJYyYxA/oIr57aa0P?=
 =?us-ascii?Q?5D88eFpQlPWZPE3dk4AlSNLHKRLcQjkTbJXMbWMLbhfdzPgOH+ANEcgFWZ9O?=
 =?us-ascii?Q?temaPkEaoxEKNpqenEuxDx22lqQvh7/nZ3Ey+BW7CcsOnQA1MXwDP8Embou8?=
 =?us-ascii?Q?1JehzHsqVfYtneofJAuXwuRpoGFEGQiwVo5/oSDjogj6wKtPE06Oo0Odb7Bs?=
 =?us-ascii?Q?V8wfqwInz3742zAoEAWBLc0LdPIlm0+/By+32juF9G6dcV5eEjMI7f0ctNjU?=
 =?us-ascii?Q?Uo3AjpX3f+sh9b3Po4nfgxW+M8rxGQGhZp0KgeKI0lau8/mz1ejtAKq7qFqK?=
 =?us-ascii?Q?LTGleOykGoFApZTq7TN4Hwry4ue8i9MyfHRM9Fb17DSyBlkgKP5UmbxmJFI8?=
 =?us-ascii?Q?zFGXOK3d2mU2vhNMXldX9R8q22FBCBczVi/CX7Fe/SbXMZnukIUVjtudoJFS?=
 =?us-ascii?Q?wuCRwbQMJhBrEoPUCsI7x1431dLrraEsdLLVs4i0tL1czA8VgFNvgSeWxvQt?=
 =?us-ascii?Q?MYisgDZuGqsv+m/aV1dVTQzq7+Ff7DJNtzoTL9n5fjDvrvPJN3ue2elEcZqH?=
 =?us-ascii?Q?ONFUo5YUA//eFI4D67nBO6mxkIEml3Fkg+6pAlgStau6gGWnJGxPoTbsehs1?=
 =?us-ascii?Q?Qvp1WvEnWjC07gjyMHk7iaAlDIDSHtaRXWD+8y3+0nvBybup3h1CzcINOaoy?=
 =?us-ascii?Q?GGw4wzzx0cSHFn8HQaiu/T6v8SiUKGQVeqFLFPE8wHtz3tqYCxB9PWFPq2wB?=
 =?us-ascii?Q?BbvKZ0dRQ515j6Y0gEaydbE7hdcytVjYdsTEr1Kbqz5GGDUjk4fX3kMHAHkl?=
 =?us-ascii?Q?cAKvoDmPoARVVhohTTCtS8NzLw9rP5au60/sIPSzuziFeVVLws0+iLCsLn04?=
 =?us-ascii?Q?MGuybZpQ/fh8EaZzhxYdQ6CUOutxNQSBcxRMA8y1YNv/imOxUE0xQGqDvMGt?=
 =?us-ascii?Q?Px8aFuo6Rd6C2Hv7iLNGfXI19x9oISbJF2JaZqdXbs2IJUo43kj5f0VgOOdv?=
 =?us-ascii?Q?6PWIBLxauii1YgmNCFzQyuouiYf0WImG51dfymL7byxl6iSRN3kkpRbpDBOH?=
 =?us-ascii?Q?WAjsQj44qG6idRaBKu60xw6+HfoFv3kpX/nhGZq/ayxL5Z5e6OJz0tbscz3F?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60515a6e-9325-4e2c-d67d-08db0dd6fe2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 15:28:44.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np9aSon2PORfzQ5YhvPTCkv7w9q5uPAeXd7nGJq06xMGAfV8EpnWTU5LGoEFS22uYaLPqpMiEennZM3N8WxLuIaikwvRjOH+6AItAInmuJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 05:08:25PM -0300, Pedro Tammela wrote:
> The tc action act_ctinfo was using shared stats, fix it to use percpu stats
> since bstats_update() must be called with locks or with a percpu pointer argument.
> 
> tdc results:
> 1..12
> ok 1 c826 - Add ctinfo action with default setting
> ok 2 0286 - Add ctinfo action with dscp
> ok 3 4938 - Add ctinfo action with valid cpmark and zone
> ok 4 7593 - Add ctinfo action with drop control
> ok 5 2961 - Replace ctinfo action zone and action control
> ok 6 e567 - Delete ctinfo action with valid index
> ok 7 6a91 - Delete ctinfo action with invalid index
> ok 8 5232 - List ctinfo actions
> ok 9 7702 - Flush ctinfo actions
> ok 10 3201 - Add ctinfo action with duplicate index
> ok 11 8295 - Add ctinfo action with invalid index
> ok 12 3964 - Replace ctinfo action with invalid goto_chain control
> 
> Fixes: 24ec483cec98 ("net: sched: Introduce act_ctinfo action")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> ---
>  net/sched/act_ctinfo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
> index 4b1b59da5..4d15b6a61 100644
> --- a/net/sched/act_ctinfo.c
> +++ b/net/sched/act_ctinfo.c
> @@ -93,7 +93,7 @@ TC_INDIRECT_SCOPE int tcf_ctinfo_act(struct sk_buff *skb,
>  	cp = rcu_dereference_bh(ca->params);
>  
>  	tcf_lastuse_update(&ca->tcf_tm);
> -	bstats_update(&ca->tcf_bstats, skb);
> +	tcf_action_update_bstats(&ca->common, skb);
>  	action = READ_ONCE(ca->tcf_action);
>  
>  	wlen = skb_network_offset(skb);
> @@ -212,8 +212,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>  	index = actparm->index;
>  	err = tcf_idr_check_alloc(tn, &index, a, bind);
>  	if (!err) {
> -		ret = tcf_idr_create(tn, index, est, a,
> -				     &act_ctinfo_ops, bind, false, flags);
> +		ret = tcf_idr_create_from_flags(tn, index, est, a,
> +						&act_ctinfo_ops, bind, flags);
>  		if (ret) {
>  			tcf_idr_cleanup(tn, index);
>  			return ret;
> -- 
> 2.34.1
> 
