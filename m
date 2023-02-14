Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993F3696774
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjBNO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjBNO6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:58:32 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3672594B;
        Tue, 14 Feb 2023 06:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676386708; x=1707922708;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rTkRcetsoRizY5NB8ornQxR92nLsaAQGziGfcaBPzR0=;
  b=Mu27fX34riELhWiaK31COMPNqMQdcUacw9EE7L8M88HksYjMnnLSTk14
   GkNob94tV7TdKtghfBbQmJsjY9y5Sg/3+ED277rkzQeTrgfDZCToyyyBt
   VPZAIHd8/X0N5vdzRJl2swYII/RWhG1dokEJgYB9HKieai7ixFcoAI0rS
   /QAHL7cZYc823JI8YuJW6yGpmcblVLHZL1HDVZtKqWvNjVgMBPG335CdQ
   UKN+A7bs5CC5J8+3RtRV9+gu1pLRt6v3Z+tMs775zFaZyH0ljqnBwpR9L
   LC1T3DL3fvK8EqYPe1wavmodZzNZhBN7O2axpkj63QhFOQtAdO3OLX2pA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="314822026"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314822026"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 06:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701674106"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="701674106"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 14 Feb 2023 06:58:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 06:58:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 06:58:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 06:58:23 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 06:58:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpSQ3WdOATEE9Kd5DTwkUfWPB5jlGtFhYyC2bnzyHgO2nYmgBk44cdJjIlDZjQDTa4FumtlIgxeCwQNM1jAsPI6DTEPm89oENQlEMYdtPYufQacIF5mDIFwq+pjE/cwg4FCthVacraiethqK6+TB45FGz0iud/cCXECXWQZqMentXJ/4m8MOwA+KyZNGgXfi4wiDzZYq6Nzu53StQS89r6rzZ2HKhLc86UAUyjti3vuwuliLo7qCZJWAoffQLkJzJw8ZktMcGi/VuZbD4/y6WfYjX7waqc1k1PuziaupEiTrcSfz3Q33NuyOKuHOu12qERYKGmvS6FL983fGvPCnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1omp8CXL2XDN/WJRlb4SAbupFXDMJwXsuURfc/kM4pI=;
 b=RTjqiXanQniOefUOPiLV8qXJL5HLXO0F0P7W8XFhaCUqP+AkwHYrEFIyJSIuebPi3roe81uN3ph60eK/XanZbAQDx5G38Wudly3WQQHiQxGurHnEyeZ8XCQtU3WxRdVTunlD4H9a7vn9KpD02N5QemMP+kBiaiorN75/qXUcIcsVHofRpLrASH70ATlC6pA22tzaclnl/Pj8jJzzW4XPE+z5t6YoYWL0vrR7MlR3HCJEP2XfrWpzvzM6FPRAb91LlQKKby6ysZ27zy+X2BP1/a2aULrho4EqyOOAVvAexIK4ud9qddCZEqR9T0Ttz15e2RO6bDgANBUPe3ustm1OIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA2PR11MB5034.namprd11.prod.outlook.com (2603:10b6:806:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 14:58:00 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 14:58:00 +0000
Message-ID: <a5a43d44-277a-1222-a700-ddade69d6243@intel.com>
Date:   Tue, 14 Feb 2023 15:56:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-2-gavinl@nvidia.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214134137.225999-2-gavinl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0225.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA2PR11MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: f258f2cd-a9df-43c4-65d9-08db0e9bdd62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Di5JTwWSVsmhDkuFAxyORqWq5/AxK/H71gOxrokCZh55RuEm4SfA2Vbb1CvJg6PW5zihCVXgPXcNHmvrdGxBlffRP6Ba1hgY0fMMM9cZjpYh79TjEDuOREybFH1MtZ9Pa5gGxYCHWd6emrbF7DDDZrD2CCTuEbaUVscx9u1JxwUgeMOfQVaO37c6ZUKUtDb62iFxXsHIyfO/Q3XghdV+8PPgGIO4p/rzYuoJ83Ojxco+EWSugWHVNQXTCKIhiKERL7uaniWQ8Y4bYmXEt/iygtc/ZzeumORTthB1yIEUwFnt/drSpiWqBRD62GvVKRFklgPlyJGj6vW3r9jn3qmF+Wnk5uCz8Ie6HIx6iH9qqbF9gru2hnEOiNN/4ppIrSbZksSJkT0+4gl3ZfeFL9AtmBJHEm9ere2rWLsSGeT7NDcAr1p1JHwHRWoD9Fhg9xZgTqHWgWKyJmkHRD+ApK2XsG1fpzSpoFRSL/E+efIWlBB7ciy35O9IiSl5/AAHeYuN7ZM9po/yWf9KgOShsK2DmjcQb6QOzz9fkkGBdmD16ZgeRh9jnbEZNvZX9wobVa2qKeQFFK7u/PfvWxdP9WzOosuL6JNu5o+4GHQ6V6DNdQv5ayvQJIHhnLehWcP38wtn7jNVSA3SxLBK4Ac9rqnyhzD79mf4Jndf5O8dT/7HcrjSoPMmDA97zE7pV3KESRIL+FzcXhSEnpJ7snM4XkYD0AvWCNxMUq+SyLNMkXqnRwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199018)(186003)(6512007)(31686004)(4326008)(8676002)(66946007)(54906003)(316002)(31696002)(86362001)(36756003)(2616005)(26005)(6506007)(66556008)(83380400001)(38100700002)(478600001)(6916009)(41300700001)(66476007)(6486002)(6666004)(2906002)(7416002)(82960400001)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUthNGVhRHowTVJrbjZtTS8wWWFBUjNMcnNGUi9MajZvSjRaQnlEY3RseWJS?=
 =?utf-8?B?L1lLSkVDemsxRERBOGZ0NmR6bE9mUVFGYkdRYWhJN3NZaE9rWlZST2daNW1R?=
 =?utf-8?B?UTJnK2xkaG92SG5PSmdTRTU5MHRMSEh5c0lEMUNhL3BoZEtpd1kxbjZiZ3Fu?=
 =?utf-8?B?cEtyZGVoM1ZjR0VUelN3R2lRSitIRFArTjUxUDhnR1hjOTJWd2VmSHVxSXlB?=
 =?utf-8?B?cFdROFBVU0RoaDFtaElBNE9UdHQxME5ZZmZQQlhaQ1ZIMGdJOFRnTCtZT0pp?=
 =?utf-8?B?aEZycTY0T1gzdGttQmFhMkFuaXEzRkxXc3luNHZmVzNyeHh2SmNLZTJqSnFR?=
 =?utf-8?B?aGtpWkJZRm9tU3JlQnVGak9kcU9ZUng1YkhWSGRPTWJ5QWlRTGRYUW50OFJp?=
 =?utf-8?B?a0FxYm5UTTNvVmh5NjMwQ1A2b0hXd0dDeFhaaXRlRm92UTJ1ajVKcmN6T2Z3?=
 =?utf-8?B?Z2FaaGpYNXVjelg5Q0hBYkJJS0NNKzRobm5kekM2QzZJVi9rWWdzcFZQdSsx?=
 =?utf-8?B?RkloMkE3S3ZqMUQ1bG9ibnJqOEZCaGlQK2FzVmJiMzBGcVdkMVZrSGJBZkpi?=
 =?utf-8?B?bVZDWFQwclMyTVJ1QWdNbU1QSHltdXhOV3Q5Ym5BUUtKUTAxQ2RIOG0vSFR0?=
 =?utf-8?B?WTVXVkt2NFYzencwOGRmYmdRUm9FZEhOdlhEeE5wNWY0RTM4cXYrOFh1MW1R?=
 =?utf-8?B?R1Q1aWxVbnE2Zk1uV3d0eVlJcTJmSDM2cllBT3dyYThRVTBnYmVKaWhieThw?=
 =?utf-8?B?S2g3QnR5TWdhKy91N3h5TWFRSFdoWmpDeDBUMXRnU1NxSy9KdE9haEJIZGFn?=
 =?utf-8?B?TWpOenIvbDBNQTkwUE5jYkJ4R1RTNDVkUkxPTUljK1dsZXdZZzJnWnBOTVpZ?=
 =?utf-8?B?VCtVYXFVWFE2SVJScHNWd01kOTZqSlVheCtsMGpiZDIzVW1rdmROWWJvS1lw?=
 =?utf-8?B?aHNvdGFLZWFQQjg2cFdQdjhZNUhQK0llZ1Z0YUc0bkZwMWJOZlk5N2FUNWpY?=
 =?utf-8?B?VmFMVXl1OUFyd1FzaFd4OUdHa0FwSnVXeHpHV3hhbDFJemhZc3NJelYwc2x4?=
 =?utf-8?B?dGVJYXgvMU1oYWt1bUFFaW04U2lxYmZueHhZaG0rSjJjY1p5L0RkUHN2UnFT?=
 =?utf-8?B?NDBUcUpKQytPVTFUS2hHWGpnRnAvRGcra21URXAwamhka0M4VlplaXFtVnNs?=
 =?utf-8?B?ME5oeEdIbVBUR01WWWI1YStnNkJxNEFKS2Z4SG4xTXdmSlVwWjJSc2ZMOWVs?=
 =?utf-8?B?NElSWjlWVk1FcHV0SFhuWGNwbzY0QVVHRFRUZkhpeVBYdTBEZnYxTUdES2dB?=
 =?utf-8?B?SWVlalFyY1FKVkZrVUVvU21LUTVnZzZzdGVXa1VOK3BFMmFhMFBDei9pR1ZM?=
 =?utf-8?B?RlQvaXNvaEZTRkZBUVNiVDFmKy9QV3JhWlNiM3ZpWnRWendvQlZSdkNwNERh?=
 =?utf-8?B?bHZzOU1KMGs1K0xGN0JpL29kcUtpMHFLSWRXbDlMRkkwSWJaNnpZWlVsb3l6?=
 =?utf-8?B?Vlo1alFDbTRxTHcxQTUxV0ttRkRRcVVJOFRYRzMvQ2g3bFAvOW5rTkh2T3VL?=
 =?utf-8?B?ZnVzSThRMm82NlZyb09OSWVINWtLLzJRRDQyUEVNbUprekZ3VU9aRGtZeEUy?=
 =?utf-8?B?K1RpWlFkY1ZIQTh6ZlhZeU1nT1gxbTc0eFkwTUVrcDlmZHU5ZUhoZUNiVHdu?=
 =?utf-8?B?MVNJUUpSQXdhallmb0xMb2k0OUI3N29HM2ZTalprSHRyTlhlOCthdTIvMFdD?=
 =?utf-8?B?aXF6VW94TkNua3k3V0ljbEJBSjFsMGtJZGZNc1RidG5zSDN4NUNjME9Xak5C?=
 =?utf-8?B?OC9ZMlBaU01lV1ltNzJ2MW8wK1Z0eVM1WXh2TXpLMHkyRmU4YjdDdHVJbHpX?=
 =?utf-8?B?M0dpOEJqSUw5MlkrSW8zWEtFZzFaaEkxNFl3Q3BTUU1JWjJyQXdxQk1GNFdo?=
 =?utf-8?B?c2Y0aUpxNGtlZDl0UHdYRHJ0OXRacmdnMytxRmcxUS9OT0JPOSthZ21rNVpw?=
 =?utf-8?B?ZGFtV3FzeWdWTG1JNkFMNysxN0lkaTZEdE5QRlNIRzRsR3JnWW84TmFHQlpB?=
 =?utf-8?B?TkJ4RzI1TEdzWU80V0M4ekdKS3NVRjdZeFIyVXBpYktRaEtvSytjSSsxUUVk?=
 =?utf-8?B?T2hGazNiQ1V1TmV5RXNrRGRDSFF1a252SzJweVZuK3BoLzN4ZzFlVkFXaTU0?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f258f2cd-a9df-43c4-65d9-08db0e9bdd62
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 14:58:00.1552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uazZxuOzcA//xbrqZhiEaZhnjxHjfXH2TRtbq+eiW0zL4yk8oetJbb1BwdLT40VhDIuyjz+uTOoNadlbPe0kfpz9NChjuNkQXtDWP3EHME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5034
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Tue, 14 Feb 2023 15:41:35 +0200

> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
> vxlan header according to gbp flags.

(not sure if it's okay to write abbreviations with non-capital)

> 
> Change-Id: I10d8dd31d6048e1fcd08cd76ee3bcd3029053552
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>

Besides the nit above:

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> ---
>  drivers/net/vxlan/vxlan_core.c | 20 --------------------
>  include/net/vxlan.h            | 20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index b1b179effe2a..bd44467a5a39 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>  	return false;
>  }
>  
> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
> -				struct vxlan_metadata *md)
> -{
> -	struct vxlanhdr_gbp *gbp;
> -
> -	if (!md->gbp)
> -		return;
> -
> -	gbp = (struct vxlanhdr_gbp *)vxh;
> -	vxh->vx_flags |= VXLAN_HF_GBP;
> -
> -	if (md->gbp & VXLAN_GBP_DONT_LEARN)
> -		gbp->dont_learn = 1;
> -
> -	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> -		gbp->policy_applied = 1;
> -
> -	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> -}
> -
>  static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
>  			       __be16 protocol)
>  {
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index bca5b01af247..08bc762a7e94 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>  	return true;
>  }
>  
> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
> +				       struct vxlan_metadata *md)
> +{
> +	struct vxlanhdr_gbp *gbp;
> +
> +	if (!md->gbp)
> +		return;
> +
> +	gbp = (struct vxlanhdr_gbp *)vxh;
> +	vxh->vx_flags |= VXLAN_HF_GBP;
> +
> +	if (md->gbp & VXLAN_GBP_DONT_LEARN)
> +		gbp->dont_learn = 1;
> +
> +	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> +		gbp->policy_applied = 1;
> +
> +	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> +}
> +
>  #endif

Thanks,
Olek
