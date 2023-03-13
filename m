Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA186B81AD
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCMTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjCMTW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:22:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CB856159;
        Mon, 13 Mar 2023 12:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678735324; x=1710271324;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aBBfYIjf5xuI3nCWXMBBruZFCKrcyRZtZeLLpSGgtp4=;
  b=OMIirt6E0GlEyRfHN2msuPgOd4XreP5QwvnHfJ5MXgBQHz6S+G4zasbe
   mgTeOOrlS9j0buo4zYWHhv6DQCaRoE1Mn7gSWBu1J/NnX9bc2K8PvhASA
   fcDA3SH6WUtXmIZWyrds9JjIiBbp6k+S6Ww5NwBzn0gLr53sSXwDu3wN6
   RIQbynuZon+2t0lZ081JoSRi2SqV25+0A4ilAE8dA645XKnlVEVKKjK8e
   LbLOH+EBWFKbYOEinuvXYrfvUGGgDgKR3Y5wGLU3Mqa5KtwjwbG62rkky
   K7twEkjfozKWOd15PTdjk4tygYBbWe8JoxH1hdNRfhXselIwP8SqpuhZt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="423511058"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="423511058"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 12:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747719106"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="747719106"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 12:21:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 12:21:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 12:21:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 12:21:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgJZZnDGeIOVBmlpVl9eY+bUIUyrHSwnEVZLdNa98hk61NmSh/GXLY0fe50PVLqoU3ph8fTbLBlK/ZXXpiNpcQwoz0P0Qn+J1VzkQEDSSsoBGfdmPNY/NSt9KcRETo/m2jYSOxxmu0fR8WXNfRF4RkzLEg5IyZAbA16/m/9/fJKbmYRvENCdMccZmIdIMzyYnrzINWLDd18H1y1LL1esS9s6GAOu+KYMRsmGztq9icthZRjdBdkdenLE3XDXb9S+xGlY6TVJWh3q0+n4ae9DKAu8UgJa31gVdFb0Os24Npt8JMVHmw7aXGgNC4Bp+GtmVlriamAOnNR7V4nCnUdiOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lYi10k1hHS6pdon0JQ351HjonQoIoSEA97PSkqan1c=;
 b=KhLQ43H5NO47VBVWIa4cDJDYkVFPODAvjKeuatm8Ai+plr2UAF4fqZSEhLm51868mh6D3dFHz4fppxCAPeZCzBb6SW/P+vOyBvAa5geyfiXmensHvqRmmxPG/hwdNpn9ktx5MKOwol3GRk1e/ZmZKK72vSoA+L43+fqngpNZ0Kx+lOa4whIyT1Wqp1TkgfV2Mm5yUbMpteDZ6Au1oB8pU+VZG7znJtWyxh9yOdujgknM7Z5JDlnTc7x/q7WFpgn6iw0Vwbxb96aQEV3sw1clDIniJY0wtiNKzDyGO+hrR+FZxRzBUX7INDdDgylj1PvwDcNohlqW1bqGaC8iT4KlYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 DM4PR11MB8092.namprd11.prod.outlook.com (2603:10b6:8:184::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 19:21:18 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 19:21:17 +0000
Date:   Mon, 13 Mar 2023 20:21:02 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 3/5] mac80211_hwsim: add PMSR request support via
 virtio
Message-ID: <ZA93nupR04173j+h@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-4-jaewan@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313075326.3594869-4-jaewan@google.com>
X-ClientProxiedBy: LO2P265CA0429.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::33) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|DM4PR11MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: f98dcb4c-cc42-4978-87b8-08db23f81e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXgqCd6XwfiVg47Xy8WqXifNnJnHTp7EiJsjBgCdoRRgsCDxMXMmIX0+Fi7ABy0+qF+NBNNE54qRr+lx1xWRpiwYaiCsN9obN3gyN0w3H8xfCI+B1kQA7vYfshVMAOy2xEHvZ6Q7wfCM62KGR9PDSwieeq6iFDHG+EkTT0HxAh+tws5sZQBAejIR04enKKiS5W8YzbnWH/5H7QnFMPKJ1+eWh4iqrJHyugEhQhyBh3i4kcffKHvDSj0pRDBjQDG12laLvjAvLHmnnbuBcwLojG9kKQUIFaVQdMNfuo8fn3b57mkV5EvJ4uPTBr2VNf7MqGK9DpCZ6AVo9aFy/XfX/gTm4g52EvXr+y+96j3UATRo3suSWamn8dRR2lybDKki5vNjDRXPmGHpO+E/bI7GZJMF5wswH2yPuuuV85IOsLpfVIodnxmR02nK+15Y4B0w/v+uAlZGVySieXgcIXYjO5YR+r5ZilsKYsiUHkzoEnNPGaz1JcyDnbnNbkjigvuTK3u4PabFy46uGZqqw8dgJiesZ/+HDkmr7tYmPLwFUtJ6HKxlSDUucAmWMv44CfODeGf8aUYjNSXN71YcjTGlrSMcD4XvVDJ45MSiSpJIQjliibgr/daoc2tIdt/Jf07pXY4rVGXBGBTIFK0z0xozXjbFChX9Hth3EBjZLQj0/W84GEXaQB6ECy8tKYEIGcIf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199018)(86362001)(38100700002)(82960400001)(66556008)(66476007)(8676002)(66946007)(6916009)(4326008)(41300700001)(8936002)(478600001)(316002)(30864003)(5660300002)(2906002)(44832011)(6486002)(83380400001)(186003)(6666004)(9686003)(6512007)(26005)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggg4vYW4n405iClUpX8ks04AVzx9kbxhl2EtMNNpZ7mGTK+WHc4sp8mbvTNl?=
 =?us-ascii?Q?twDAk3VNYTLMfGSNZWsgE+WFoC4rdjvRKHuL36VeZVairBCHO4bp+C6jyVUp?=
 =?us-ascii?Q?jYfUfkSv5bk2SCJYje/k8iiMUcQmNO9ntoO4pslu1RnasDvVdIvRfShenCwJ?=
 =?us-ascii?Q?7QGaiyNCFSNhtIsumDSErwZCOu5IOVawOxiPqCyy/Kt+KSEAlx9oNt4w8ciI?=
 =?us-ascii?Q?NxJa04f972FVrHJacYTdzsdpYtOcvnrXF330yEwXAjkehz4VhF7y60fhiBpz?=
 =?us-ascii?Q?Vz3xkqsNzV5M2civ43PE1bNpxx3AUuPKjkE5zJQvPRrpibr2YlbPeq3dVb7i?=
 =?us-ascii?Q?fV1CI4JjPL01xt13nymNnhHgOVCwaXTGDl2T2I5+xHQMZFPnt2GtEawUhnxZ?=
 =?us-ascii?Q?5qDt17Eww2E/0IC7sY+w+N/MPuuzrqD4ikDhL3c1rz4/1H31LBcQ2wgFCyBb?=
 =?us-ascii?Q?TBjTqm5rbJux0mpZUSpKjW6Jtpw+MfheEmxpssMF+VlnXIMCbuAeQRr6vQR0?=
 =?us-ascii?Q?YUBKLstDMa1j5lqh2KXyaEn74Bjjf0jZicaTDwZB3ZKRsl3NL7QxCWPjvs8P?=
 =?us-ascii?Q?RYxtuS2EIi/9Bh3IFgm/7QXFMqB/p7bjwIzyJB2uAzpDK7sHGgQFH/HkI/xM?=
 =?us-ascii?Q?Ivu6yohg3dsuav7iTv2i3jsOYW3iT1a7HBkHh9LU0iWa6A7Qobs9mDbeGjnE?=
 =?us-ascii?Q?ezUBSESRjnTcLu9DpT4d6duR0uJtHFEJmBsIEd+pV4UFlsWgRFAQMtVs3ZMY?=
 =?us-ascii?Q?7JFA+8mWdkj84545HJ3KJ7DI18KMhNWAP7AIehaIgdmSyy2qXvzSkOUGTD/y?=
 =?us-ascii?Q?Ebcuh5gj12Oay2t78bczvM8/gmvPUxLT3fc6DgwHb5rQq7KC45yJjzZ1w+cp?=
 =?us-ascii?Q?orbX0xxq6F8xhb/QuyVmteQLMoFC72OvozIFeayRd7C9j1C8ENqg32ibelPd?=
 =?us-ascii?Q?XEQMc8QM+YSCexd2PuHCedmqdJY1HJFGtusn1H0m+BGYqCj2421g6h+nrN2+?=
 =?us-ascii?Q?SL1+1wC44Ez4nGVuna7z6HbGvWhV9Z6KLpQAm40RQ8l32bmtvKnsjkG1cvpU?=
 =?us-ascii?Q?Klfktnnv27KIhzpbr10eJdRaLN/tBvqanxLgB4FKUOv6vWDQ3Nv8eerWtCvx?=
 =?us-ascii?Q?UzH0qMjfPM3qfhv77eUcr7uBVKxAAzwAdXuKQOGWf7urpQfTMQ5h9uvtYIgY?=
 =?us-ascii?Q?bM0/1oyLHN5B1yVYq9mkFHikzgGL9yV/GQOqzPBI9kjoqNynmbWy/qcKluJg?=
 =?us-ascii?Q?cIxanIdLXg1cDw/jPMPrntRvjHbv0un8CyoosbiLIV+LFdX6oJje1LpxlRnK?=
 =?us-ascii?Q?5ysGw9aBdfRnjUuWCyNFk/F1A3AymRCXFlb+FlM/umH3uWCuSQZj56+JAHV2?=
 =?us-ascii?Q?7vweJHpPspYOO6irCZz9BwK4NtTnSYV9VoQaimmdhasTnETnQJMk0D8cm3K6?=
 =?us-ascii?Q?T3rXRewbWwpbtzAW96Y23bvaopROvVtx8+BwW++fMTbx6InKE2FMMGWwGKlh?=
 =?us-ascii?Q?jq9lnxlxNjGrb/Ltzom2Xv4dToaW69/N7vt+XJSk1ojKnlffdr1FOSJjd1Mj?=
 =?us-ascii?Q?eYD9pPq/820Tin3e7m1r2OsDBo6DGIp1kOsta6gLKm+TjI9vk+qV51yWQ0+c?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f98dcb4c-cc42-4978-87b8-08db23f81e9e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 19:21:17.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlATQRO4pasq7HDtCcVBlFIvwg0cbT5EaD684i2MOiX6L64c4KO8gEAy/6uIjeJ2iX8xyxb81WLzk5PNzmEITg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8092
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:53:24AM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> time measurement) is the one and only measurement. FTM is measured by
> RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> 
> Add necessary functionalities for mac80211_hwsim to start PMSR request by
> passthrough the request to wmediumd via virtio. mac80211_hwsim can't
> measure RTT for real because mac80211_hwsim the software simulator and
> packets are sent almost immediately for real. This change expect wmediumd
> to have all the location information of devices, so passthrough requests
> to wmediumd.
> 
> In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> mac80211_hwsim receives the PMSR start request via
> ieee80211_ops.start_pmsr, the received cfg80211_pmsr_request is resent to
> the wmediumd with command HWSIM_CMD_START_PMSR and attribute
> HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> nl80211_pmsr_start() expects.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V7 -> V8: Exported nl80211_send_chandef directly instead of creating
>           wrapper.
> V7: Initial commit (split from previously large patch)
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
>  drivers/net/wireless/mac80211_hwsim.h |   6 +
>  2 files changed, 212 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 65868f28a00f..a692d9c95566 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
>  
>  	/* only used when pmsr capability is supplied */
>  	struct cfg80211_pmsr_capabilities pmsr_capa;
> +	struct cfg80211_pmsr_request *pmsr_request;
> +	struct wireless_dev *pmsr_request_wdev;
>  
>  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
>  };
> @@ -3139,6 +3141,208 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	return 0;
>  }
>  
> +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
> +						     struct cfg80211_pmsr_ftm_request_peer *request)
> +{
> +	struct nlattr *ftm;
> +
> +	if (!request->requested)
> +		return -EINVAL;
> +
> +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> +	if (!ftm)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->preamble))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD, request->burst_period))
> +		return -ENOBUFS;
> +
> +	if (request->asap && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_ASAP))
> +		return -ENOBUFS;
> +
> +	if (request->request_lci && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI))
> +		return -ENOBUFS;
> +
> +	if (request->request_civicloc &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC))
> +		return -ENOBUFS;
> +
> +	if (request->trigger_based && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED))
> +		return -ENOBUFS;
> +
> +	if (request->non_trigger_based &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED))
> +		return -ENOBUFS;
> +
> +	if (request->lmr_feedback && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP, request->num_bursts_exp))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, request->burst_duration))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST, request->ftms_per_burst))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES, request->ftmr_retries))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION, request->burst_duration))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR, request->bss_color))
> +		return -ENOBUFS;
> +
> +	nla_nest_end(msg, ftm);
> +
> +	return 0;
> +}

Lenght of lines in the function above exceeds 80 characters.

> +
> +static int mac80211_hwsim_send_pmsr_request_peer(struct sk_buff *msg,
> +						 struct cfg80211_pmsr_request_peer *request)
> +{
> +	struct nlattr *peer, *chandef, *req, *data;
> +	int err;
> +
> +	peer = nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
> +	if (!peer)
> +		return -ENOBUFS;
> +
> +	if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN,
> +		    request->addr))
> +		return -ENOBUFS;
> +
> +	chandef = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> +	if (!chandef)
> +		return -ENOBUFS;
> +
> +	err = nl80211_send_chandef(msg, &request->chandef);
> +	if (err)
> +		return err;
> +
> +	nla_nest_end(msg, chandef);
> +
> +	req = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_REQ);

Don't you need to check "if (!req)" as you have done for other pointers
returned by "nla_put_flag()"?
Is it by mistake or intentional?

> +	if (request->report_ap_tsf && nla_put_flag(msg, NL80211_PMSR_REQ_ATTR_GET_AP_TSF))

Line length above 80 chars.

> +		return -ENOBUFS;
> +
> +	data = nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
> +	if (!data)
> +		return -ENOBUFS;
> +
> +	err = mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->ftm);
> +	if (err)
> +		return err;
> +
> +	nla_nest_end(msg, data);
> +	nla_nest_end(msg, req);
> +	nla_nest_end(msg, peer);
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> +					    struct cfg80211_pmsr_request *request)
> +{
> +	int err;
> +	struct nlattr *pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);

Please follow the RCT principle.
Also, I would suggest to split declaration of "pmsr" and assignment because
"nla_nest_start() is a call that is more in the action part of the code
than the declaration part.

> +
> +	if (!pmsr)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> +		return -ENOBUFS;
> +
> +	if (!is_zero_ether_addr(request->mac_addr)) {
> +		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac_addr))
> +			return -ENOBUFS;
> +		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN, request->mac_addr_mask))
> +			return -ENOBUFS;
> +	}
> +
> +	for (int i = 0; i < request->n_peers; i++) {
> +		err = mac80211_hwsim_send_pmsr_request_peer(msg, &request->peers[i]);
> +		if (err)
> +			return err;
> +	}
> +
> +	nla_nest_end(msg, pmsr);
> +
> +	return 0;
> +}
> +
> +static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     struct cfg80211_pmsr_request *request)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	u32 _portid = READ_ONCE(data->wmediumd);
> +	int err = 0;
> +	struct sk_buff *skb = NULL;
> +	void *msg_head;
> +	struct nlattr *pmsr;

Please use RCT.

> +
> +	if (!_portid && !hwsim_virtio_enabled)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&data->mutex);
> +
> +	if (data->pmsr_request) {
> +		err = -EBUSY;
> +		goto out_err;
> +	}
> +
> +	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +
> +	if (!skb) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> +			       HWSIM_CMD_START_PMSR);
> +
> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
> +		    ETH_ALEN, data->addresses[1].addr)) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
> +	if (!pmsr) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	err = mac80211_hwsim_send_pmsr_request(skb, request);
> +	if (err)
> +		goto out_err;
> +
> +	nla_nest_end(skb, pmsr);
> +
> +	genlmsg_end(skb, msg_head);
> +	if (hwsim_virtio_enabled)
> +		hwsim_tx_virtio(data, skb);
> +	else
> +		hwsim_unicast_netgroup(data, skb, _portid);
> +
> +out_err:
> +	if (err && skb)
> +		nlmsg_free(skb);
> +
> +	if (!err) {
> +		data->pmsr_request = request;
> +		data->pmsr_request_wdev = ieee80211_vif_to_wdev(vif);
> +	}

It looks confusing to have such a check under "out_err" label.
I would expect error handling only under "out_err".
Please improve both checks above:
 - handle normal cases e.g. "ieee80211_vif_to_wdev()" above the eror
   label.
 - try to avoid checking if error occured if you are already in the
   error path.

> +
> +	mutex_unlock(&data->mutex);
> +	return err;
> +}
> +
>  #define HWSIM_COMMON_OPS					\
>  	.tx = mac80211_hwsim_tx,				\
>  	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
> @@ -3161,7 +3365,8 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
>  	.flush = mac80211_hwsim_flush,				\
>  	.get_et_sset_count = mac80211_hwsim_get_et_sset_count,	\
>  	.get_et_stats = mac80211_hwsim_get_et_stats,		\
> -	.get_et_strings = mac80211_hwsim_get_et_strings,
> +	.get_et_strings = mac80211_hwsim_get_et_strings,	\
> +	.start_pmsr = mac80211_hwsim_start_pmsr,		\
>  
>  #define HWSIM_NON_MLO_OPS					\
>  	.sta_add = mac80211_hwsim_sta_add,			\
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> index d10fa7f4853b..98e586a56582 100644
> --- a/drivers/net/wireless/mac80211_hwsim.h
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -81,6 +81,8 @@ enum hwsim_tx_control_flags {
>   *	to this receiver address for a given station.
>   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
>   *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> + * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> + *	%HWSIM_ATTR_PMSR_REQUEST.
>   * @__HWSIM_CMD_MAX: enum limit
>   */
>  enum {
> @@ -93,6 +95,7 @@ enum {
>  	HWSIM_CMD_GET_RADIO,
>  	HWSIM_CMD_ADD_MAC_ADDR,
>  	HWSIM_CMD_DEL_MAC_ADDR,
> +	HWSIM_CMD_START_PMSR,
>  	__HWSIM_CMD_MAX,
>  };
>  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> @@ -144,6 +147,8 @@ enum {
>   *	the new radio
>   * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CREATE_RADIO
>   *	to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
> + * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_START_PMSR
> + *	to provide details about peer measurement request (nl80211_peer_measurement_attrs)
>   * @__HWSIM_ATTR_MAX: enum limit
>   */
>  
> @@ -176,6 +181,7 @@ enum {
>  	HWSIM_ATTR_CIPHER_SUPPORT,
>  	HWSIM_ATTR_MLO_SUPPORT,
>  	HWSIM_ATTR_PMSR_SUPPORT,
> +	HWSIM_ATTR_PMSR_REQUEST,
>  	__HWSIM_ATTR_MAX,
>  };
>  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
