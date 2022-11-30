Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A032063DC30
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiK3Riq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiK3Rin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:38:43 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4262337207;
        Wed, 30 Nov 2022 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669829922; x=1701365922;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hmwz5akWMC2x42ux3R2ETYxKHnrPXJ+jhV9pZmT0OJ4=;
  b=aBr6yoRJp+/bnOGiHaifLXF/xX9zNl+tDIas7mBdi9Qmo9pIFm/eYvqk
   rnciEwc+Am91f4OSle1LZcNKjBbbf6yunY/K5/KXRaplRCpvqv+Gu5ABw
   wFH73avGFy99EEW3h4OaRam2GGNa82x9wHLKj0jZftI1RzjSSMqoatNYI
   hNbD/f+92Eug/Cfi9jt4wsBYEdRdPqmd6URKPQPNNR8sDMGNa/eB4bEEL
   RHncN+1b/pSqpwofSHDkXwseZGI6rGCmMBwbnfsGHYxe5FMSJlPlOl9oK
   2aUMl9MSFwJX/uZEf0sKae0tjseVx9yfl8tiKnTj+uoBn3ecL1nLPhOG/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313087450"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313087450"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 09:38:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="768913900"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="768913900"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 30 Nov 2022 09:38:17 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 09:38:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 09:38:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 09:38:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMgDDK6iFdX8lYmDvnF+lnCjHVEMvyvpREWCieiW18S3Pe7kcpJqtlOpguJfjzVc0bOuWUqyNTu60lwhZ7uzLcZGTaqnJsU8gJVz3dG69a82ftYh++Yh7EqtAKoYfruGA2z8v4Ohl6PPybmuzT9xjtgo7vE+zdfs6KCOxiVZoOCFYNzuATMyOoUdiWsNsbFXY5gmEzLkIxpW7BMjLePeHJnlisZEluUt9uo1cn9zkAR25Ns0Ur6LzM5Xch/em52OQkeuKKSG+go/wF5x0QtCfS3L3AE7Hr3k8GNJrbcDEaBKQde3FTBGy+W38qeEr0YI1NQ2nQ3Rmipr6CXTT0tU4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvIUD633A5l8p1uaDby9oEZKIVTyqNoAvIOL27Uu2sw=;
 b=X+XqJyJxGXmp1iTAkWjGhILnHU/julDL0tLUYLd/88CpWNxuSyOwRik+ARoQixncwuHp7gSnd7Wqp1vqUq9r9z2yfJwZKRqcjuYOqFEJ9dixyrCgZJyGcB3yK1eq+sYGndm63nom81eFP2Cnf37jZTipvK7M3kR94YgUW9R1UMvHM/HI/nHEeaOiglXnB27uyMk19fcJDXMdhfkMkmWTcdQRIj/T2ExbKpZzE19UbhX+idiycE/qumEZ3ka+EMf4gvYC40MIljjxaFJ/u3B4jwTOB0EnZk+V1C9xlhDuylJH2AV/ImyjipiQxKRel4Og5akfoCf9dxl66jBDB0Nn1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by BL3PR11MB6506.namprd11.prod.outlook.com (2603:10b6:208:38d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 17:38:12 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7da:c60:52de:f58a]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7da:c60:52de:f58a%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 17:38:12 +0000
Date:   Wed, 30 Nov 2022 18:24:04 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
Message-ID: <Y4eRtJOPWBOCKe1Q@lincoln>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221121182552.2152891-3-sdf@google.com>
X-ClientProxiedBy: FR2P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::26) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|BL3PR11MB6506:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a8862fc-ef89-485d-8c8a-08dad2f9a72e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vntM5MeqHnmrg4A0xNIDGBR5LpuQrW85vjOaPT6WEhdyKypJK8ZSGiyDZ8L/0NKkD+4RR43On7iyD0hP3lr412TeppHc9zjbHGMFZ6Ds+cA8wiF6lZ3i1aFpaQayLjCRUB4QC57rFtt3m48abcv2fKfD4iZNb+hjaHkbVUY2XfYOpc0QsbGRBhswJYw9beL1Fk6PsQ/HCrtycKxpnj3takecHFlgIm8wIHr4fSi7UYgn5fmqyARb2gXHC1P1kbdMBftofGnie/IHt6/lbOCV/YX/iqlVZzJB6L0hs0nUuh43KYPbMAgAIrxszXTADzrFtyuTZ91iEMkrTB44LT/yJFSJvqiOCuinwdUvbua2Q/BuJqQ14+K8GxU7v4H4KdO7O+7rDE6f99XJADYwe4qNEHL44TUQTNTzIkIQu31nj0zu3UiK5TPwriWM2AC3zc7YilzpI3mS9Pfs0DBH+DjgN3O3EJZNlUyimhm+/x8zaTXuF/IPoyty2PsYDAFhB58qkquHULs/HVKAPGztTA6tgJYOkz2yC0fWVS+C9dSYDcL/+q1zeWTTDcelKFJgPypbDed28TBJqEXQQ5QABWoPQpknAjjhYcyiuLSGIYOTnx393sXPuLbc9mYTDrlvIjGjzmWd67C19NZGCRPoAhtxNUJoCCg45rhRGlRcehSy590=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(83380400001)(86362001)(54906003)(8936002)(82960400001)(44832011)(7416002)(66946007)(38100700002)(2906002)(8676002)(41300700001)(33716001)(26005)(5660300002)(66476007)(186003)(4326008)(6506007)(6666004)(9686003)(6512007)(316002)(6916009)(6486002)(966005)(66556008)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uJaty/hHKikyKWuwEINzhRour+JG7+2KJ+lCDW0rsSxsQ/czkENRIGN8BLvC?=
 =?us-ascii?Q?4WYJyV9WymdF3Sr2UPVqvi84HP/ThrKXXBhasEZtq3/JCeAEC0C7gMIm5o8O?=
 =?us-ascii?Q?jvk4P4dvKsySGSSkclOPaocmQx4xLbyyTVRBZhtfYmDKYAJ1+pIUwFz7nc3L?=
 =?us-ascii?Q?DDC/Xi53gZIQ8kS4eU7viGA6cidqdPnDwC9yjqtI+vQvNk8/BC0RruF5PRRP?=
 =?us-ascii?Q?ur1FLaN8FpcRgOu4jLPJAFvO1kw8Slbx+C53BaROgFhM5q90w1AZrunI/q9p?=
 =?us-ascii?Q?4L4N+Oel2O9SVJFu32X2oe1uCECq7YOrYuZ4XelrujIKRWdKPfh6sInGxbvk?=
 =?us-ascii?Q?ix2k8SBEF7HRPWWhbyQwk5QW5hikyE29tr0SZEQVur2+2BZyRMCsryeOiqj7?=
 =?us-ascii?Q?+8yNIE4rkdQu4Jwy9lEnftNiPBUfcle8Y5D/1/53J2TTR/VTE3hyqe1Shu2I?=
 =?us-ascii?Q?lkdB5KGu2Qab3r1tjRokwbo2JWL4VGRT+2k77YyABzL3zUJeIQgJ41lhvSY9?=
 =?us-ascii?Q?Pn5uUTDfpCkxKwBwW8nq4qXwbvowLv3EZ/YoPVTwLaAYQ1Gr3WiKcOEWze76?=
 =?us-ascii?Q?bHYupkwX5P/EVyj54MBnatqOdnk029E3Z2iyCYdH65NkP4GltHr69wogzxoe?=
 =?us-ascii?Q?XoT+7e+e3I3/ZdAunfeE/+fgEIvYLAV5iiJb0yrou2ruRIzSx24rILvtCrm9?=
 =?us-ascii?Q?Khuy6B2gNj4GbAId6+L4Uk4KCMTfib72JMDjo1ZpaWldBgge7J0svqGvJTEQ?=
 =?us-ascii?Q?PAOOiV06xQuLAdzmZU9cZGm2loXjeEw24ibsT+qP/XRq94cQjnzM31qOQhQ4?=
 =?us-ascii?Q?9CqgPPsrRolJ1y4FoabjzMvpgnt10QR6Frpngh76a508ZwPpv9hVyLQTIOBT?=
 =?us-ascii?Q?vBzDgNZj8sqhagIWllLVPBwyGjIstXZQOHQTp3tSOP5R+PvX23oIJWYLYpYc?=
 =?us-ascii?Q?LiJEvKOp/ok3/TWc2+TGQCxBI5/NyrXJGYtizPfgyEX8giJy1mcfEW9OfKQo?=
 =?us-ascii?Q?Oeq3TZR//ooBDveLPHd13pKVjvuuNiO8rMyflXcOsEfIhGTi1hUwtE41Wi1o?=
 =?us-ascii?Q?VF30k7a131OUSzGvVpt+ZyogR5YG5rvfhMT5lUkD8Xcppq3nTqfPT7KvAKMI?=
 =?us-ascii?Q?06NLhxi5oplYA1Ao9J8YbRAXkcTl+b8w1nnA9JBurVSLCnL/tqSd43iF8IpJ?=
 =?us-ascii?Q?gPIQIyxT0Dh95vC/NaRb0jzT2BarnF6I8lT2S56l9esbOvMq4Y4B+QiuuqIT?=
 =?us-ascii?Q?mD9W/A0VLENILaCUO9Gl9UkOjmS/Ts9m1MGbIITmou4eFEurGNPFQxUJX3uO?=
 =?us-ascii?Q?OX/xTkA10bWMzaLjo8RAky2n7ewN9FoZOgqcK2pOK3gGW2GWbET3eF8gzAiL?=
 =?us-ascii?Q?97Cs6ahvFOgFRZ+OUk5xHeL9cSPbp9LHaUfEqmJUSpKbhN4Fz6v2MjO/bBrG?=
 =?us-ascii?Q?9Wqrd1OoczqDgpXOYKE3QEzTtf0GmwaQQDVcaxilLlJ/qAnPzDvtvFF5+KTU?=
 =?us-ascii?Q?fIadeVj/z6XROAkrT9K0cf2RNFl+ZCGMZdcXPbVgjghngWjnlEHp3d9xCme8?=
 =?us-ascii?Q?Ylg59BQXBpdlqr8SPQe/IHQoP+iSeM2CsYVdAw4RZG8qL8WeY1VUUzqBde2h?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8862fc-ef89-485d-8c8a-08dad2f9a72e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 17:38:12.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1HqmZCASyk0Vphlli3ErI5LgxbMeLrJwq8G4bzhkTX1huWh0L61m54ePQ4lfoerpLicnzscUEJeEfoC2qy+Xlq4kVSAqeP0K62JWptTxlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6506
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:25:46AM -0800, Stanislav Fomichev wrote:

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 9528a066cfa5..315876fa9d30 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15171,6 +15171,25 @@ static int fixup_call_args(struct bpf_verifier_env *env)
>  	return err;
>  }
>  
> +static int fixup_xdp_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
> +{
> +	struct bpf_prog_aux *aux = env->prog->aux;
> +	void *resolved = NULL;

First I would like to say I really like the kfunc hints impementation.

I am currently trying to test possible performace benefits of the unrolled
version in the ice driver. I was working on top of the RFC v2,
when I noticed a problem that also persists in this newer version.

For debugging purposes, I have put the following logs in this place in code.

printk(KERN_ERR "func_id=%u\n", func_id);
printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=%u\n",
       xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED));
printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP=%u\n",
       xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP));
printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=%u\n",
       xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED));
printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH=%u\n",
       xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH));

Loading the program, which uses bpf_xdp_metadata_rx_timestamp_supported()
and bpf_xdp_metadata_rx_timestamp(), has resulted in such messages:

[  412.611888] func_id=108131
[  412.611891] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
[  412.611892] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
[  412.611892] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
[  412.611893] XDP_METADATA_KFUNC_RX_HASH=108131
[  412.611894] func_id=108130
[  412.611894] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
[  412.611895] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
[  412.611895] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
[  412.611895] XDP_METADATA_KFUNC_RX_HASH=108131

As you can see, I've got 108131 and 108130 IDs in program,
while 108126 and 108128 would be more reasonable.
It's hard to proceed with the implementation, when IDs cannot be sustainably
compared.

Furthermore, dumped vmlinux BTF shows the IDs is in the exactly reversed 
order:

[108126] FUNC 'bpf_xdp_metadata_rx_hash' type_id=108125 linkage=static
[108128] FUNC 'bpf_xdp_metadata_rx_hash_supported' type_id=108127 linkage=static
[108130] FUNC 'bpf_xdp_metadata_rx_timestamp' type_id=108129 linkage=static
[108131] FUNC 'bpf_xdp_metadata_rx_timestamp_supported' type_id=108127 linkage=static

> +
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
> +		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp_supported;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> +		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
> +		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash_supported;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> +		resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash;
> +
> +	if (resolved)
> +		return BPF_CALL_IMM(resolved);
> +	return 0;
> +}
> +

My working tree (based on this version) is available on github [0]. Situation
is also described in the last commit message.
I would be great, if you could check, whether this behaviour can be reproduced
on your setup.

[0] https://github.com/walking-machine/linux/tree/hints-v2
