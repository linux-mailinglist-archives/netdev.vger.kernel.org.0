Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206D06B7E2C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCMQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCMQws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:52:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1097C1C58B;
        Mon, 13 Mar 2023 09:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678726354; x=1710262354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JPVToeD0QWPYOZyFEHp6imOeqwVHG1N2r0d+U7SRbAw=;
  b=cj1QFU/bgKKI44kMJXi+waYutHds3OOGlIY04buu+MG7h8H2PGwOzKjB
   0AmaaUxU29O6A+jSYQNpKnK4bJR+hkyqphVJDzgUVyBXIBVKf1o6MsWzj
   isJt7IkPKUJMtWNGVdNwlclBrDZ1msG18BbjmpdLhUeF8bGBubYsLIVPy
   5yuJ9FQBVsxkGId+O9WXofUsNsX8Q5ODsGGg6wxtOpjF+4THrrI9Pgh7g
   lGGg4BVw8VyZvfExooWCIgMmfrEhUuALTM3mruVyGGtz8SBQ0ey05JTDz
   pXm8ybradK8OnYp4dC16WDVtf4z4GsBjePqqUmzc14tltUXyUqzRyY4Es
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="339567748"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="339567748"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 09:52:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="711203610"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="711203610"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 13 Mar 2023 09:52:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 09:52:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 09:52:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 09:52:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4+hHKbktJLhf+HbxcJDOmYpghM2ysZgapRV3D6XtujCnw6xWCSVHVa/TxxgHx+vq2YItC3f2cdoprlULqEv5duyp8ACM8+d7XCHNIm+6T4/mh8fQ1pzcrAEBi6VsztVpMbUUpcSkgSGGubIsINpGb4Kn0f63pMiZ30I2UHbCcZBNi/PSp0YFuLkPbu9R9ci/dHJQRsSjY336mCpNd5NgRy+YbIwoBHwk8XdPtjT3TPArbIB8tZ2IzQ7IKwlGA0ocoj5kpGxngjWlXgrxrxN2rEkgIt+C/o2RXyLYJeJyDb/JKGvrP6z221UYAvNy38kCZH/FxXPhlRpRjUV1Uq4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LvY3GOo8REH1EG+HeOGL4zWFC1tKuB5QPIfyozGD3Y=;
 b=JLXeToUR5HlxKt7Hh1y9GUaF9TlORv52c7OzXgG5R8BCVr80c1MtAl6ttSzzcUICRlTzJOc0sAEQ2+fB4OdawQIqAHMUxbrqC4EKOGtng8zHlhikWvo0sPBDv/1xenkuQRIL5Lqw5UVnpgyYByZ+jWPRC0okRAJ21df4HzbUKS62MRj4Cwh3d1ALUBO5WmTMxT1Vi1J3boVgtcjXKj9FUYJ0hlj1UVvtiguixj+zO4BOyDZxi+zw9DwTXmKFeDG3oWMYof1pL5UTaWrOF1bmsnwftwYMMKwhjpAquN+CxzUPSrkUo6g2MbMccqpkKhxRU3lkU6z6mjbmur+oqAs1fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 16:52:10 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:52:10 +0000
Date:   Mon, 13 Mar 2023 17:51:57 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 1/5] mac80211_hwsim: add PMSR capability support
Message-ID: <ZA9UrX1I6XXOfnYV@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-2-jaewan@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313075326.3594869-2-jaewan@google.com>
X-ClientProxiedBy: DU2P251CA0005.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:230::34) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM6PR11MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: 12dc1891-5793-46ce-fe99-08db23e3494e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECwJWbwU0o5DfSUlx8BtCwi7xujg2ucC45anjf9Af4oM0Z4WQh86X4jvRNJsRq7zri3YcdImVW4VigUQuXpZqGH8ZDADKlro9/28dhzoaOKkchKNtdmSo4HklgB/I7cYmgib25SMOn/37RU6qNGgZOHOtL6jqcpKBBBYJze9S4ECnAFQ0/I8/CmaT0kRa6u3TiY7OpCsiGCsy2ndDXO06mfJ+cF5+ysPXWbnGzq3LqcKFFR5NtYGbcvwOXT3QCToajtRz0U1REdpWLJJh1PI2+EjVOeu3KAxseo2oe5xs+zkAH5n+uc1JpR8gNBqk60Ny+plY9KkuOxb68jXVll+zB8dGePS+5XbfX5jcTmpXyXntcyMn1IzqPUWqXrW4RmBqisf/mO7LvDTDuwj8dCqhnxPXGgWdrCOfRX5g2nuVjGY+KhDBUkvbZNHMPxZ7taL9y3N3NiE/lsxhcEXGTxGMsHuAmxhSNKzVPNsyIf0x9DuQA0l7YO/EDkEyRZvVEYZ0DJErwx43wWzd16y/sxCFmwapeJdbImWxMezPU3HNouXtqkEXu2S9XnFBGalJt0yzIQxG+NCPsyHc9OlPxa5VnkALuQzochLcJwH/9vQXWbk6OxaU7ZUSn6o3XrzGbe55aNmc2vdaq2YKoWC1Dx9ZIoA+bDJWumYVKtAj3hLtpKcFMqMQWyO5K5OOFBxrjgE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199018)(86362001)(186003)(41300700001)(26005)(6512007)(6506007)(5660300002)(4326008)(8936002)(6916009)(316002)(478600001)(8676002)(66946007)(6666004)(66556008)(30864003)(66476007)(6486002)(38100700002)(82960400001)(2906002)(44832011)(83380400001)(9686003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pr7rcOuuI8+fru7oS3zDS1vbjxU/gGCYGp3N8kMhLae8DVNMiwv48gvK4j1A?=
 =?us-ascii?Q?fdb2WKLdfkcAdoAGbklzxUy3h+qURIaAXOnq/V4lMOmtFDDqTYrNUK4qrbrh?=
 =?us-ascii?Q?xDGJKca9G2rd+KlJxX8KlPMlmwfTuOx6KLV8kUbAG7rB/bVw5ZT/Xw7Z/0w5?=
 =?us-ascii?Q?yMWXOF/iN23tBZn8w7oXvCp+fcNaSsBBTYpVnMC7W7o2tB4gC4TdPG/ZLq8J?=
 =?us-ascii?Q?GmrCzsGYtlIw4HvrqO8QHWQpX9RzgWm+eXzHa3CIUsv2JLbEVd5xZSYDFrNB?=
 =?us-ascii?Q?nojhrxX9z8ZZoT0z4WgCkPm/Q/w/enOGSSmQE4QOKKUCnmbzreHMPUoCuYeV?=
 =?us-ascii?Q?lcEXnez905zc949d7FLoWN8RWhWHxnD6KecYJd3QvbguZOco8mQI7sV2wdgI?=
 =?us-ascii?Q?55b+gpIM/0FHQ++QLqZUcsvPQaIFZZX0TzRSseXrZswUuGCOYcyeJUyhRtTr?=
 =?us-ascii?Q?Ks477Obhedn20osyivom7vbpbIJ2/QdWebTlxn2qVMGTetCZPqFOLuxUPTRm?=
 =?us-ascii?Q?iGP+DTdQnZjaKjXwDGGQ8dmYu/Qf7QUi8ju03r+b0ZaEBzCPm3y/PGYjYgBD?=
 =?us-ascii?Q?K3sFB9swFOKTi2qFfyI+HW15A4wQ/68kplR/m8jh16uEJEozZqMPZj/v24qG?=
 =?us-ascii?Q?LG0pfEj88YziJOX3UoT4IQhQFAe6UGMtlucODXzXiv8gofcbWKGCeIRmZmyQ?=
 =?us-ascii?Q?yod2zxn35q9KEpr7MJu/QmHm56WWn4+MpxEzRaSZUEmX5yfLS3fR7PcnOvbZ?=
 =?us-ascii?Q?iDEV0BLPfVoFhzc8MxfihxqKTfVmOB1urExl5hkwz691o2k4Uy0OAL7FtQFS?=
 =?us-ascii?Q?2Up8wTszEtGyalNq/mU1GnYQm+OTvCy186z40IlDYj7dzxhZiTpCZJAbw/gq?=
 =?us-ascii?Q?XWs9+T5Lb/yC0QREL84ActwlQQFvDOoOtnvPy/vSBD1ju7Vq+WUr2SJAJQdk?=
 =?us-ascii?Q?BwdQCWByyECFmynfVTAXCZmHtuboSrZBe36mVbSHq6NrRPdiTdcCOrfCBr8h?=
 =?us-ascii?Q?09z+tjziPNedVpA6/FFYhB7VCOKKc5CNgyIyGwvwySovepJvWaKf0l9rdsMM?=
 =?us-ascii?Q?p3F654XEzogldXwB+h8ByA5niDGNOj9JrTcAsIl1vnXulwtmFKSy82rJlSmY?=
 =?us-ascii?Q?mMbU2Jh4GVJMden+kk1qO/0Ovp9fIILYhnCM5eBZokV4oekTh1+Fb1WWmIPU?=
 =?us-ascii?Q?9P8wxw2SXq8PH4hK3Hs9h82GIoyRyH2KwDWPSE03+QECzlcFN5TdIc5Bm+Ec?=
 =?us-ascii?Q?G5GGhN9xQEbzGnVDvovjIwa0lP18s4/GN0VYD1mD7Qmhucv9BryC/5BUVI3U?=
 =?us-ascii?Q?jVFJn7O0aCozfS90H7LkQ7WNJ8Oi1ooofyWtzdbPHa3DpSoT4lfrdrksDrDQ?=
 =?us-ascii?Q?HoyU+twoxYee/USwcMUZEUkZTz60gU0RWBZ+sylhJROqyYIUNN8j33AOpBbf?=
 =?us-ascii?Q?s32NTMxqThPOP3O9IcERW+KNcCyKzJ5qU3pdx9EaRdYVwh8XHtFDSDyzv+V3?=
 =?us-ascii?Q?V9J+3b0vmiyhESLqnXfvoCmcYDVrI9NKII51/Izy+4rEb3NAMLNmKEB5no/U?=
 =?us-ascii?Q?HL7sYZtpwkXdF6/wGnG3CNnY8ZGaaa65mTLPGgOzwkoUHaGFHZRF4NJf3xOL?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12dc1891-5793-46ce-fe99-08db23e3494e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:52:10.0487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYPC6R8hElmQqQlmW9dR0Iw0AvgWjJs5WNNlgsYLqnjUKVXGvLRCwXsD31rNiPCs0xYb33Rmg3aIzGvW6nrPtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:53:22AM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> time measurement) is the one and only measurement. FTM is measured by
> RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> 
> Add necessary functionality to allow mac80211_hwsim to be configured with
> PMSR capability. The capability is mandatory to accept incoming PMSR
> request because nl80211_pmsr_start() ignores incoming the request without
> the PMSR capability.
> 
> In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT.
> HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creating a new
> radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT can have
> nested PMSR capability attributes defined in the nl80211.h. Data format is
> the same as cfg80211_pmsr_capabilities.
> 
> If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>

Hi,

Just a few style comments and suggestions.

Thanks,
Michal

> ---
> V8 -> V9: Changed to consider unknown PMSR type as error.
> V7 -> V8: Changed not to send pmsr_capa when adding new radio to limit
>           exporting cfg80211 function to driver.
> V6 -> V7: Added terms definitions. Removed pr_*() uses.
> V5 -> V6: Added per change patch history.
> V4 -> V5: Fixed style for commit messages.
> V3 -> V4: Added change details for new attribute, and fixed memory leak.
> V1 -> V3: Initial commit (includes resends).
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 129 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |   3 +
>  2 files changed, 131 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 4cc4eaf80b14..65868f28a00f 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
>  	/* RSSI in rx status of the receiver */
>  	int rx_rssi;
>  
> +	/* only used when pmsr capability is supplied */
> +	struct cfg80211_pmsr_capabilities pmsr_capa;
> +
>  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
>  };
>  
> @@ -760,6 +763,34 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
>  
>  /* MAC80211_HWSIM netlink policy */
>  
> +static const struct nla_policy
> +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] = NLA_POLICY_MAX(NLA_U8, 15),
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] = NLA_POLICY_MAX(NLA_U8, 31),
> +	[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_capa_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_ATTR_TYPE_CAPA] = NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
> +	[NL80211_PMSR_ATTR_PEERS] = { .type = NLA_REJECT }, // only for request.
> +};
> +
>  static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_ADDR_RECEIVER] = NLA_POLICY_ETH_ADDR_COMPAT,
>  	[HWSIM_ATTR_ADDR_TRANSMITTER] = NLA_POLICY_ETH_ADDR_COMPAT,
> @@ -788,6 +819,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
>  	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
>  	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
> +	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
>  };
>  
>  #if IS_REACHABLE(CONFIG_VIRTIO)
> @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
>  	u32 *ciphers;
>  	u8 n_ciphers;
>  	bool mlo;
> +	const struct cfg80211_pmsr_capabilities *pmsr_capa;
>  };
>  
>  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> @@ -3260,7 +3293,7 @@ static int append_radio_msg(struct sk_buff *skb, int id,
>  			return ret;
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static void hwsim_mcast_new_radio(int id, struct genl_info *info,
> @@ -4445,6 +4478,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  			      NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
>  	wiphy_ext_feature_set(hw->wiphy,
>  			      NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> +	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
>  
>  	hw->wiphy->interface_modes = param->iftypes;
>  
> @@ -4606,6 +4640,11 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
>  				    data->debugfs,
>  				    data, &hwsim_simulate_radar);
>  
> +	if (param->pmsr_capa) {
> +		data->pmsr_capa = *param->pmsr_capa;
> +		hw->wiphy->pmsr_capa = &data->pmsr_capa;
> +	}
> +
>  	spin_lock_bh(&hwsim_radio_lock);
>  	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
>  				     hwsim_rht_params);
> @@ -4715,6 +4754,7 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
>  	param.regd = data->regd;
>  	param.channels = data->channels;
>  	param.hwname = wiphy_name(data->hw->wiphy);
> +	param.pmsr_capa = &data->pmsr_capa;
>  
>  	res = append_radio_msg(skb, data->idx, &param);
>  	if (res < 0)
> @@ -5053,6 +5093,77 @@ static bool hwsim_known_ciphers(const u32 *ciphers, int n_ciphers)
>  	return true;
>  }
>  
> +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211_pmsr_capabilities *out,
> +			  struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> +	int ret = nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> +				   ftm_capa, hwsim_ftm_capa_policy, NULL);

I would suggest to split declaration and assignment here. It breaks the
RCT principle and it is more likely to overlook "nla_parse_nested" call.
I think it would improve the readability when we know that the parsing
function can return an error.

> +
> +	if (ret) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malformed FTM capability");
> +		return -EINVAL;
> +	}
> +
> +	out->ftm.supported = 1;
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
> +		out->ftm.preambles = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
> +		out->ftm.bandwidths = nla_get_u32(tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
> +		out->ftm.max_bursts_exponent =
> +			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT]);
> +	if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
> +		out->ftm.max_ftms_per_burst =
> +			nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST]);
> +	out->ftm.asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
> +	out->ftm.non_asap = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
> +	out->ftm.request_lci = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI];
> +	out->ftm.request_civicloc = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC];
> +	out->ftm.trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED];
> +	out->ftm.non_trigger_based = !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED];
> +
> +	return 0;
> +}
> +
> +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg80211_pmsr_capabilities *out,
> +			   struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> +	struct nlattr *nla;
> +	int size;
> +	int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
> +				   hwsim_pmsr_capa_policy, NULL);

Ditto.

> +
> +	if (ret) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed PMSR capability");
> +		return -EINVAL;
> +	}
> +
> +	if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> +		out->max_peers = nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
> +	out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> +	out->randomize_mac_addr = !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
> +
> +	if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_TYPE_CAPA],
> +				    "malformed PMSR type");
> +		return -EINVAL;
> +	}
> +
> +	nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
> +		switch (nla_type(nla)) {
> +		case NL80211_PMSR_TYPE_FTM:
> +			parse_ftm_capa(nla, out, info);
> +			break;
> +		default:
> +			NL_SET_ERR_MSG_ATTR(info->extack, nla, "unsupported measurement type");
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  {
>  	struct hwsim_new_radio_params param = { 0 };
> @@ -5173,8 +5284,24 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  		param.hwname = hwname;
>  	}
>  
> +	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> +		struct cfg80211_pmsr_capabilities *pmsr_capa =
> +			kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);

Missing empty line after variable definition.
BTW, would it not be better to split "pmsr_capa" declaration and
"kmalloc"? For example:

		struct cfg80211_pmsr_capabilities *pmsr_capa;

		pmsr_capa = kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
		if (!pmsr_capa) {

I think it would be more readable and you would not have to break the
line. Also, in the current version it seems more likely that the memory
allocation will be overlooked.

> +		if (!pmsr_capa) {
> +			ret = -ENOMEM;
> +			goto out_free;
> +		}
> +		ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT], pmsr_capa, info);
> +		if (ret)
> +			goto out_free;
> +		param.pmsr_capa = pmsr_capa;
> +	}
> +
>  	ret = mac80211_hwsim_new_radio(info, &param);
> +
> +out_free:
>  	kfree(hwname);
> +	kfree(param.pmsr_capa);
>  	return ret;
>  }
>  
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> index 527799b2de0f..d10fa7f4853b 100644
> --- a/drivers/net/wireless/mac80211_hwsim.h
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -142,6 +142,8 @@ enum {
>   * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
>   * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) for
>   *	the new radio
> + * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CREATE_RADIO
> + *	to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
>   * @__HWSIM_ATTR_MAX: enum limit
>   */
>  
> @@ -173,6 +175,7 @@ enum {
>  	HWSIM_ATTR_IFTYPE_SUPPORT,
>  	HWSIM_ATTR_CIPHER_SUPPORT,
>  	HWSIM_ATTR_MLO_SUPPORT,
> +	HWSIM_ATTR_PMSR_SUPPORT,
>  	__HWSIM_ATTR_MAX,
>  };
>  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
