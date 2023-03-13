Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7946B82A5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMU02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCMU00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:26:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D898898F1;
        Mon, 13 Mar 2023 13:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678739182; x=1710275182;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yyPB362FvpeUUrqjJ0+3iU79NuJ/LifLci+ljMb64mo=;
  b=m2CvAsCS0XZruplGuI52rtdTDZimEgR1Taj4Mpi0wCpeYxQAQ+fmmbZP
   TbTlRrvjP95w3qjgLXiPx+xm2TAuReDXr7PV6/KYiOiL6o+ZHOnvXiO8y
   5U3LKC6NsvYN8lBg/3RTh5k+K3HW2Z7nTzOXLJvBBhH+1equ41X0vrpzT
   ui4Tpm7F9VCy6nufDtafMFZ8CGls+bD8e4D+qw8FSdqIEKGPXSTsoLgmS
   kXlS4i971lBLXgcp1MYns7oMADVC2AyQhmgJt8KHojZS7wSqx+cB8fkLp
   AHDmfO18X+X7y1F+m8Q/GfWtRsq7GmJ11Vk44edxlKi9ttzAtHd7+U01f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364911259"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="364911259"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:26:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="672043087"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="672043087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 13 Mar 2023 13:26:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 13:26:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 13:26:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 13:26:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 13:26:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc4dqPDzFqcQxXatYBbocK6jPQj1VRDSXLAekF+pW4NwbHEg9hJAjgK7EyvrVplptYN0dRaVYPkuaESwVJPqZprycA83hdZ/J8MfaeCvp0yxITh92W1cVGetsIKGkRFwhIEM4xdjI4Nk5dg8TjBElFEgF4HWQd1vNSQjTKMSXnx0VSfdxH/h5H6sD/94bFAWMBoAb0nm0nIRlLUyKYQ3PFQ8I6Hx5AvPyg4WDSsXaTyJvuoeYr/r+L7sGQQ4aP3ioUcco1Os4+aLf29NH3G7MIUT4XPmiUlOMTgukvXcZhtrUQFh1Ij+PU6Qi562vUd9W63jWZtV8Z5HDC1wguGizA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN09vXJyO3k73miutn2IxGY87IhsyzPT6bN9rOHwOI4=;
 b=cE0KelybmEadh2T3SNtR6LW/8G+d2qBBR0YFppyFR2/g5jHVHOwvs7BMLdOpNOggjJOHXEVBf5ySoLNTKfS6oYsu9eqsTZxwgbiqzp67w+F4kJHygKeI6oO+NSb7+OSJ88n+HCoR5Uvf+jGfHmB89vqShWximIYjmACnZ2bAcc8YPceaURXWq8gxw/lyhIwPyphvcOW0GAIIW0YzQ1cJDXE+pRaOYb9p1kSaTfctF/65uJDTc8OifLKaBBf2sg/OfAFuvLBwQJ1LmAn82yifZsQ4f3x6qY/NcxBENiSfxK89aOxzyeblAnDcdhYvfV0sSouWLtpaEJ2Gu6Lw6K7u0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 MW3PR11MB4666.namprd11.prod.outlook.com (2603:10b6:303:56::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 20:26:18 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 20:26:18 +0000
Date:   Mon, 13 Mar 2023 21:26:05 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 5/5] mac80211_hwsim: add PMSR report support via virtio
Message-ID: <ZA+G3Rr+ibEL+2cX@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-6-jaewan@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313075326.3594869-6-jaewan@google.com>
X-ClientProxiedBy: FR2P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::16) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|MW3PR11MB4666:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b8e1aca-175f-450b-b677-08db24013380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 81gvz9Vz4WHYdIDHquREGjkyMWf5gG+JFC8M44/IIxds9YUYTZpjPZgmVcL95gbcOsg6RF0jxhWp8tRBJNTasigXkoTKlW0pw8dVbc5EVdKEVXeRvmZe7MR9tu9bQ16yu/JV+7GuH/YMfit+mtvR4Dam/JN8fGzf1XGxJed0Sb/nl+0YLxjUetzxl1qRQuM/HBpGqlr1qhMd9Tl836YAzyGsH9illOjojclm88Z7Be4p1l2Xb8moQ+MR9L4vNZnvg/BPIt0ERUZXRA+vVANvgL5uEIKVVNLv0ecvikH/TsKgcirCvgq9NYsGGTjGWAs8mRIHYZxLFXLlsV/o+NIVOGYb25vZkv/YtqmygkGCm+vX8dtK4ZCgVdwJpdt14JXV3AN+vzru1/yKqd6S2CQ3SGgi6gQc5ROtSQU5zlMUX336j3tQdaTIdduQcjJb4IeQ0pIOkBWfnFjGaLXxJQ+74fDEH3u6FzQcY7nMaSldFDZ3N7GXbKEmS/yJbCfoQaUgwC4zG1Y5GrcTejQWZsSN46R6f+x8JXmZzgEGx+el4ShFnJU7pJfWOjhKORFvnNt8RPWaFk6PnB+ZlF1eexZScM69X3S+S8dZE8hFQhfCsFilq6lr2g+bspXuDerHhZuYp6qQAb5yuU4bpe2pkfGWjfsvX49T1GnprBwv79ZFm/NnBFGbJWt5Uw0W8owJ2uqn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199018)(30864003)(5660300002)(44832011)(83380400001)(186003)(478600001)(26005)(6666004)(6512007)(6506007)(6486002)(9686003)(8676002)(66556008)(4326008)(66476007)(8936002)(316002)(66946007)(6916009)(41300700001)(86362001)(38100700002)(82960400001)(2906002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bKKgTbWwYKthzZrXhSPXsPVqKtk8A3r8kRuGrU9F5zO2HmiiiLgOLeTY3dSY?=
 =?us-ascii?Q?f9DjkefWVu3Ae8RvkXVU9Z7oJ+wZygzM1//CA4UIbURBnKajZhshPeLO3+s6?=
 =?us-ascii?Q?WhkzpbcKnyabkXGtGa+AWVTPH7OaHKvcElqUYKnJHmeIGOAZPgIlBTcR0H2Y?=
 =?us-ascii?Q?yEGu4kd7tP7fRW8gzqBl9j8CaEmtm7BPKjW/ws2p1bZk4ycFs/mygRwvCZ9G?=
 =?us-ascii?Q?qLGsEqH249g6zYBFkhmUNlm579BVGcXJwcQ52x+MJtsxV+W2aKdfVTCxb+nU?=
 =?us-ascii?Q?aYgbRmtu5yv99rRwz4/GGFkujV6oXtyUiX2MKSlbC5P9QfnOfrGrGejxjdei?=
 =?us-ascii?Q?PjWI/fTf1bPxHCAVef28BzosmczIv/AfelcPTU2KyfVea9glAJDdBdU42e7D?=
 =?us-ascii?Q?ISP6vIR3LDCbutTlrpc+sW+i2KiVVQzQ3/ev6cepK8TdmhHLo5NNtnNveRoG?=
 =?us-ascii?Q?RUTTJPAkf00y5qli/d77t7rCQDLAS+q05hEM2+jpJSMix/m5KjLV4agSNY45?=
 =?us-ascii?Q?KeK1iqnNnl9eJTLwzy0PYHfk6r+nlgU5ej+GIPQfaIwtj8zNZqTGBjujQR6u?=
 =?us-ascii?Q?3KOaAgw05OAqUNm4orZPzmETmeDHMNmOvcbJ6Ex+2EdG079M9SIHXCNye1Ml?=
 =?us-ascii?Q?DTBE1A78G7nFiLjLes1/LhEdAM0I4SW2VqoqpFkdMt/GspcBJ1y+RzqAgqgz?=
 =?us-ascii?Q?Qt4yc+g9pB6mdR6Uv7khLRH5uSdoRqoUwyFdiIPCG1pJS/m0JVEBFO1b2qCk?=
 =?us-ascii?Q?+wpkv8w2CDaS6Ku1NbinBTmZmCnUBnm+Fzuik+NWvP94gPszQvBFcB4ACcsw?=
 =?us-ascii?Q?HK/yedaVmB9FSGxp0GTqPzq/+Q/9A5jrRqOc8B0JGjw58kpXCUxwBFbZ0A/1?=
 =?us-ascii?Q?NOmsi4Q0+i20fR4TeeKTqg/Wurb4yVRqZBbQfCBzC1Ja6KLo9e8WmN/jMU1N?=
 =?us-ascii?Q?WXtdTnnA3FeohpZfEZQWhJbSaHd5ajE2VDBphZxAr+Bm5yX3PwYIkEuyStUs?=
 =?us-ascii?Q?kknRRdW9ZHIrzn4OnWmNvM6AQ9Cz/PyAIwyPmSZ4b9j75yxw3EzOovxSwf2X?=
 =?us-ascii?Q?N7bRJP6Lzq5fRTg1RTrFb5pUfRC0nqzpTU4Rket8kWL1NtQ/8Tic5WV1FI93?=
 =?us-ascii?Q?2Tmxjuvjx308SH3h++FDbHxCC5s2BMg7nSqOJCOnAgC9oEpGe5dHOz/jeLsO?=
 =?us-ascii?Q?4mydDUv/TqBv0CiWN43ChFZyIV6Z+O5PaEjoquAc1ZOj/Sgd+4g6rjJhrfts?=
 =?us-ascii?Q?dGq3u8m1qP/sN/x+bnQ9IUzNzQ0GQBwcMZ9aCaLVHqvlcCZM6iW3BYLn4LUk?=
 =?us-ascii?Q?c7uPkNa+G8GcCRlz3Ewy7HpnELEpgaYDcCjB9AtwmExXIdrYa7cIvOKjAYqY?=
 =?us-ascii?Q?q62WsLeWYd21h8swpWMWE6vBuRTn5wYJDFEEFaUuny04usVLdSKV+BpQCXvE?=
 =?us-ascii?Q?zuk9WMSXzCUzNMh3arTlvTkjoCdjfkhsd6n71P2wkRQmA/jYnFQrSyOvLTv7?=
 =?us-ascii?Q?HTi4gwQNApNupi0w/hNqXb1QDXRWhsKAFPSxvgdmY24gnpOv6T0oq5fLE0pz?=
 =?us-ascii?Q?pndAmuNxOglKVSOGUcNq2NuBvhurCm5kJ48+PNkjjTm4MMUKPcTz2itZNi4T?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8e1aca-175f-450b-b677-08db24013380
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 20:26:18.6478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKk7iB16+AorRzVcHtW3lr6MlaeOOcOo3DH37ZzN+gE/pGKHmKobGR9+u+RGf6S3ayVANX1yoGgL+MZn7VIMzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4666
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:53:26AM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> devices with Wi-Fi support. And currently FTM (a.k.a. fine time measurement
> or flight time measurement) is the one and only measurement.
> 
> Add the necessary functionality to allow mac80211_hwsim to report PMSR
> result. The result would come from the wmediumd, where other Wi-Fi
> devices' information are kept. mac80211_hwsim only need to deliver the
> result to the userspace.
> 
> In detail, add new mac80211_hwsim attributes HWSIM_CMD_REPORT_PMSR, and
> HWSIM_ATTR_PMSR_RESULT. When mac80211_hwsim receives the PMSR result with
> command HWSIM_CMD_REPORT_PMSR and detail with attribute
> HWSIM_ATTR_PMSR_RESULT, received data is parsed to cfg80211_pmsr_result and
> resent to the userspace by cfg80211_pmsr_report().
> 
> To help receive the details of PMSR result, hwsim_rate_info_attributes is
> added to receive rate_info without complex bitrate calculation. (i.e. send
> rate_info without adding inverse of nl80211_put_sta_rate()).
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V7 -> V8: Changed to specify calculated last HWSIM_CMD for resv_start_op
>           instead of __HWSIM_CMD_MAX for adding new CMD more explicit.
> V7: Initial commit (split from previously large patch)
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 379 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |  51 +++-
>  2 files changed, 420 insertions(+), 10 deletions(-)
>

General comment: there are many lines exceeding 80 characters (the limit
for net).
The rest of my comments - inline.

Thanks,
Michal

> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 8f699dfab77a..d1218c1efba4 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -752,6 +752,11 @@ struct hwsim_radiotap_ack_hdr {
>  	__le16 rt_chbitmask;
>  } __packed;
>  
> +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
> +{
> +	return rhashtable_lookup_fast(&hwsim_radios_rht, addr, hwsim_rht_params);
> +}
> +
>  /* MAC80211_HWSIM netlink family */
>  static struct genl_family hwsim_genl_family;
>  
> @@ -765,6 +770,76 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
>  
>  /* MAC80211_HWSIM netlink policy */
>  
> +static const struct nla_policy
> +hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] = {
> +	[HWSIM_RATE_INFO_ATTR_FLAGS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_MCS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_LEGACY] = { .type = NLA_U16 },
> +	[HWSIM_RATE_INFO_ATTR_NSS] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_BW] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_GI] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_DCM] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_EHT_GI] = { .type = NLA_U8 },
> +	[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] = { .type = NLA_U8 },
> +};
> +
> +static const struct nla_policy
> +hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] = { .type = NLA_U16 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] = NLA_POLICY_NESTED(hwsim_rate_info_policy),
> +	[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] = NLA_POLICY_NESTED(hwsim_rate_info_policy),
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] = { .type = NLA_U64 },
> +	[NL80211_PMSR_FTM_RESP_ATTR_LCI] = { .type = NLA_STRING },
> +	[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] = { .type = NLA_STRING },
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +	[NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_result_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_RESP_ATTR_STATUS] = { .type = NLA_U32 },
> +	[NL80211_PMSR_RESP_ATTR_HOST_TIME] = { .type = NLA_U64 },
> +	[NL80211_PMSR_RESP_ATTR_AP_TSF] = { .type = NLA_U64 },
> +	[NL80211_PMSR_RESP_ATTR_FINAL] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_RESP_ATTR_DATA] = NLA_POLICY_NESTED(hwsim_pmsr_resp_type_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR_COMPAT,
> +	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_PEER_ATTR_REQ] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_PEER_ATTR_RESP] = NLA_POLICY_NESTED(hwsim_pmsr_resp_policy),
> +};
> +
> +static const struct nla_policy
> +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_PEERS] = NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_peer_result_policy),
> +};
> +
>  static const struct nla_policy
>  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
>  	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> @@ -822,6 +897,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
>  	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
>  	[HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
>  	[HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
> +	[HWSIM_ATTR_PMSR_RESULT] = NLA_POLICY_NESTED(hwsim_pmsr_peers_result_policy),
>  };
>  
>  #if IS_REACHABLE(CONFIG_VIRTIO)
> @@ -3403,6 +3479,292 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
>  	mutex_unlock(&data->mutex);
>  }
>  
> +static int mac80211_hwsim_parse_rate_info(struct nlattr *rateattr,
> +					  struct rate_info *rate_info,
> +					  struct genl_info *info)
> +{
> +	struct nlattr *tb[HWSIM_RATE_INFO_ATTR_MAX + 1];
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, HWSIM_RATE_INFO_ATTR_MAX,
> +			       rateattr, hwsim_rate_info_policy, info->extack);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_FLAGS])
> +		rate_info->flags = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_FLAGS]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_MCS])
> +		rate_info->mcs = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_MCS]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_LEGACY])
> +		rate_info->legacy = nla_get_u16(tb[HWSIM_RATE_INFO_ATTR_LEGACY]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_NSS])
> +		rate_info->nss = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_NSS]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_BW])
> +		rate_info->bw = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_BW]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_HE_GI])
> +		rate_info->he_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_GI]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_HE_DCM])
> +		rate_info->he_dcm = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_DCM]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC])
> +		rate_info->he_ru_alloc =
> +			nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH])
> +		rate_info->n_bonded_ch = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_EHT_GI])
> +		rate_info->eht_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_GI]);
> +
> +	if (tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC])
> +		rate_info->eht_ru_alloc = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC]);
> +
> +	return 0;
> +}

Lines in the function above often exceed 80 chars.

> +
> +static int mac80211_hwsim_parse_ftm_result(struct nlattr *ftm,
> +					   struct cfg80211_pmsr_ftm_result *result,
> +					   struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1];
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, NL80211_PMSR_FTM_RESP_ATTR_MAX,
> +			       ftm, hwsim_ftm_result_policy, info->extack);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON])
> +		result->failure_reason = nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX])
> +		result->burst_index = nla_get_u16(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]) {
> +		result->num_ftmr_attempts_valid = 1;
> +		result->num_ftmr_attempts =
> +			nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]);
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]) {
> +		result->num_ftmr_successes_valid = 1;
> +		result->num_ftmr_successes =
> +			nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]);
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME])
> +		result->busy_retry_time =
> +			nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP])
> +		result->num_bursts_exp = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION])
> +		result->burst_duration = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST])
> +		result->ftms_per_burst = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST]);
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]) {
> +		result->rssi_avg_valid = 1;
> +		result->rssi_avg = nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]) {
> +		result->rssi_spread_valid = 1;
> +		result->rssi_spread =
> +			nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]);
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE]) {
> +		result->tx_rate_valid = 1;
> +		ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE],
> +						     &result->tx_rate, info);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE]) {
> +		result->rx_rate_valid = 1;
> +		ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE],
> +						     &result->rx_rate, info);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]) {
> +		result->rtt_avg_valid = 1;
> +		result->rtt_avg =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]) {
> +		result->rtt_variance_valid = 1;
> +		result->rtt_variance =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]) {
> +		result->rtt_spread_valid = 1;
> +		result->rtt_spread =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]) {
> +		result->dist_avg_valid = 1;
> +		result->dist_avg =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]) {
> +		result->dist_variance_valid = 1;
> +		result->dist_variance =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]);
> +	}
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]) {
> +		result->dist_spread_valid = 1;
> +		result->dist_spread =
> +			nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]);
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]) {
> +		result->lci = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
> +		result->lci_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
> +	}
> +
> +	if (tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]) {
> +		result->civicloc = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
> +		result->civicloc_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
> +	}
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_parse_pmsr_resp(struct nlattr *resp,
> +					  struct cfg80211_pmsr_result *result,
> +					  struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_RESP_ATTR_MAX + 1];
> +	struct nlattr *pmsr;
> +	int rem;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, NL80211_PMSR_RESP_ATTR_MAX, resp,
> +			       hwsim_pmsr_resp_policy, info->extack);

You are assigning the value to "ret" variable but you are never using
it. Is the check for "ret" missing?

> +
> +	if (tb[NL80211_PMSR_RESP_ATTR_STATUS])
> +		result->status = nla_get_u32(tb[NL80211_PMSR_RESP_ATTR_STATUS]);
> +
> +	if (tb[NL80211_PMSR_RESP_ATTR_HOST_TIME])
> +		result->host_time = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_HOST_TIME]);
> +
> +	if (tb[NL80211_PMSR_RESP_ATTR_AP_TSF]) {
> +		result->ap_tsf_valid = 1;
> +		result->ap_tsf = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_AP_TSF]);
> +	}
> +
> +	result->final = !!tb[NL80211_PMSR_RESP_ATTR_FINAL];
> +
> +	if (tb[NL80211_PMSR_RESP_ATTR_DATA]) {

How about using a negative logic in here to decrease indentation?
For example:

	if (!tb[NL80211_PMSR_RESP_ATTR_DATA])
		return ret;

> +		nla_for_each_nested(pmsr, tb[NL80211_PMSR_RESP_ATTR_DATA], rem) {
> +			switch (nla_type(pmsr)) {
> +			case NL80211_PMSR_TYPE_FTM:
> +				result->type = NL80211_PMSR_TYPE_FTM;
> +				ret = mac80211_hwsim_parse_ftm_result(pmsr, &result->ftm, info);
> +				if (ret)
> +					return ret;
> +				break;
> +			default:
> +				NL_SET_ERR_MSG_ATTR(info->extack, pmsr, "Unknown pmsr resp type");
> +				return -EINVAL;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_parse_pmsr_result(struct nlattr *peer,
> +					    struct cfg80211_pmsr_result *result,
> +					    struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
> +	int ret;
> +
> +	if (!peer)
> +		return -EINVAL;
> +
> +	ret = nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer,
> +			       hwsim_pmsr_peer_result_policy, info->extack);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[NL80211_PMSR_PEER_ATTR_ADDR])
> +		memcpy(result->addr, nla_data(tb[NL80211_PMSR_PEER_ATTR_ADDR]),
> +		       ETH_ALEN);
> +
> +	if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
> +		ret = mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMSR_PEER_ATTR_RESP], result, info);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +};
> +
> +static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
> +{
> +	struct nlattr *reqattr;
> +	const u8 *src;
> +	int err, rem;
> +	struct nlattr *peers, *peer;
> +	struct mac80211_hwsim_data *data;

Please use RCT formatting.

> +
> +	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> +	data = get_hwsim_data_ref_from_addr(src);
> +	if (!data)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->mutex);
> +	if (!data->pmsr_request) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	reqattr = info->attrs[HWSIM_ATTR_PMSR_RESULT];
> +	if (!reqattr) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	peers = nla_find_nested(reqattr, NL80211_PMSR_ATTR_PEERS);
> +	if (!peers) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	nla_for_each_nested(peer, peers, rem) {
> +		struct cfg80211_pmsr_result result;
> +
> +		err = mac80211_hwsim_parse_pmsr_result(peer, &result, info);
> +		if (err)
> +			goto out_err;
> +
> +		cfg80211_pmsr_report(data->pmsr_request_wdev,
> +				     data->pmsr_request, &result, GFP_KERNEL);
> +	}
> +
> +	cfg80211_pmsr_complete(data->pmsr_request_wdev, data->pmsr_request, GFP_KERNEL);
> +
> +out_err:

How about renaming this label to "out" or "exit"?
The code below is used for error path as well as for a normal path.

> +	data->pmsr_request = NULL;
> +	data->pmsr_request_wdev = NULL;
> +
> +	mutex_unlock(&data->mutex);
> +	return err;
> +}
> +
>  #define HWSIM_COMMON_OPS					\
>  	.tx = mac80211_hwsim_tx,				\
>  	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
> @@ -5072,13 +5434,6 @@ static void hwsim_mon_setup(struct net_device *dev)
>  	eth_hw_addr_set(dev, addr);
>  }
>  
> -static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
> -{
> -	return rhashtable_lookup_fast(&hwsim_radios_rht,
> -				      addr,
> -				      hwsim_rht_params);
> -}
> -
>  static void hwsim_register_wmediumd(struct net *net, u32 portid)
>  {
>  	struct mac80211_hwsim_data *data;
> @@ -5746,6 +6101,11 @@ static const struct genl_small_ops hwsim_ops[] = {
>  		.doit = hwsim_get_radio_nl,
>  		.dumpit = hwsim_dump_radio_nl,
>  	},
> +	{
> +		.cmd = HWSIM_CMD_REPORT_PMSR,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit = hwsim_pmsr_report_nl,
> +	},
>  };
>  
>  static struct genl_family hwsim_genl_family __ro_after_init = {
> @@ -5757,7 +6117,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
>  	.module = THIS_MODULE,
>  	.small_ops = hwsim_ops,
>  	.n_small_ops = ARRAY_SIZE(hwsim_ops),
> -	.resv_start_op = HWSIM_CMD_DEL_MAC_ADDR + 1,
> +	.resv_start_op = HWSIM_CMD_REPORT_PMSR + 1, // match with __HWSIM_CMD_MAX


>  	.mcgrps = hwsim_mcgrps,
>  	.n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
>  };
> @@ -5926,6 +6286,9 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
>  	case HWSIM_CMD_TX_INFO_FRAME:
>  		hwsim_tx_info_frame_received_nl(skb, &info);
>  		break;
> +	case HWSIM_CMD_REPORT_PMSR:
> +		hwsim_pmsr_report_nl(skb, &info);
> +		break;
>  	default:
>  		pr_err_ratelimited("hwsim: invalid cmd: %d\n", gnlh->cmd);
>  		return -EPROTO;
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> index 383f3e39c911..92126f02c58f 100644
> --- a/drivers/net/wireless/mac80211_hwsim.h
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -82,8 +82,8 @@ enum hwsim_tx_control_flags {
>   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
>   *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
>   * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> - *	%HWSIM_ATTR_PMSR_REQUEST.
> - * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
> + *	%HWSIM_ATTR_PMSR_REQUEST. Result will be sent back asynchronously
> + *	with %HWSIM_CMD_REPORT_PMSR.
>   * @__HWSIM_CMD_MAX: enum limit
>   */
>  enum {
> @@ -98,6 +98,7 @@ enum {
>  	HWSIM_CMD_DEL_MAC_ADDR,
>  	HWSIM_CMD_START_PMSR,
>  	HWSIM_CMD_ABORT_PMSR,
> +	HWSIM_CMD_REPORT_PMSR,
>  	__HWSIM_CMD_MAX,
>  };
>  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> @@ -151,6 +152,8 @@ enum {
>   *	to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
>   * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_START_PMSR
>   *	to provide details about peer measurement request (nl80211_peer_measurement_attrs)
> + * @HWSIM_ATTR_PMSR_RESULT: nested attributed used with %HWSIM_CMD_REPORT_PMSR
> + *	to provide peer measurement result (nl80211_peer_measurement_attrs)
>   * @__HWSIM_ATTR_MAX: enum limit
>   */
>  
> @@ -184,6 +187,7 @@ enum {
>  	HWSIM_ATTR_MLO_SUPPORT,
>  	HWSIM_ATTR_PMSR_SUPPORT,
>  	HWSIM_ATTR_PMSR_REQUEST,
> +	HWSIM_ATTR_PMSR_RESULT,
>  	__HWSIM_ATTR_MAX,
>  };
>  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> @@ -288,4 +292,47 @@ enum {
>  	HWSIM_VQ_RX,
>  	HWSIM_NUM_VQS,
>  };
> +
> +/**
> + * enum hwsim_rate_info -- bitrate information.
> + *
> + * Information about a receiving or transmitting bitrate
> + * that can be mapped to struct rate_info
> + *
> + * @HWSIM_RATE_INFO_ATTR_FLAGS: bitflag of flags from &enum rate_info_flags
> + * @HWSIM_RATE_INFO_ATTR_MCS: mcs index if struct describes an HT/VHT/HE rate
> + * @HWSIM_RATE_INFO_ATTR_LEGACY: bitrate in 100kbit/s for 802.11abg
> + * @HWSIM_RATE_INFO_ATTR_NSS: number of streams (VHT & HE only)
> + * @HWSIM_RATE_INFO_ATTR_BW: bandwidth (from &enum rate_info_bw)
> + * @HWSIM_RATE_INFO_ATTR_HE_GI: HE guard interval (from &enum nl80211_he_gi)
> + * @HWSIM_RATE_INFO_ATTR_HE_DCM: HE DCM value
> + * @HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC:  HE RU allocation (from &enum nl80211_he_ru_alloc,
> + *	only valid if bw is %RATE_INFO_BW_HE_RU)
> + * @HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH: In case of EDMG the number of bonded channels (1-4)
> + * @HWSIM_RATE_INFO_ATTR_EHT_GI: EHT guard interval (from &enum nl80211_eht_gi)
> + * @HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC: EHT RU allocation (from &enum nl80211_eht_ru_alloc,
> + *	only valid if bw is %RATE_INFO_BW_EHT_RU)
> + * @NUM_HWSIM_RATE_INFO_ATTRS: internal
> + * @HWSIM_RATE_INFO_ATTR_MAX: highest attribute number
> + */
> +enum hwsim_rate_info_attributes {
> +	__HWSIM_RATE_INFO_ATTR_INVALID,
> +
> +	HWSIM_RATE_INFO_ATTR_FLAGS,
> +	HWSIM_RATE_INFO_ATTR_MCS,
> +	HWSIM_RATE_INFO_ATTR_LEGACY,
> +	HWSIM_RATE_INFO_ATTR_NSS,
> +	HWSIM_RATE_INFO_ATTR_BW,
> +	HWSIM_RATE_INFO_ATTR_HE_GI,
> +	HWSIM_RATE_INFO_ATTR_HE_DCM,
> +	HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC,
> +	HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH,
> +	HWSIM_RATE_INFO_ATTR_EHT_GI,
> +	HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC,
> +
> +	/* keep last */
> +	NUM_HWSIM_RATE_INFO_ATTRS,
> +	HWSIM_RATE_INFO_ATTR_MAX = NUM_HWSIM_RATE_INFO_ATTRS - 1
> +};
> +
>  #endif /* __MAC80211_HWSIM_H */
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
