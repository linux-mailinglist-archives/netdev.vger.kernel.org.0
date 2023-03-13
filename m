Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC80B6B81D6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCMTpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCMTpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:45:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4A1838AF;
        Mon, 13 Mar 2023 12:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678736743; x=1710272743;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fN5Chzb8FnAtH4KzGN4wwWTtdzSM6pQ/yGXVLgtj/4U=;
  b=Gi7bcj4P0Z1JQ/+zf0pNCQ0T92qNzeJ6V9Wsy7VZzIRVogWp0QOUUT6j
   5dBQpyl6Pfb+seTypaTk49J0PyB7xq9t9rlhkd/blM5N8rLutRtEHIX0n
   Vt8wgJck9vbLP302Xd5xWFrAIJ2fJOYo6YKV2/UR7fabzEyIKS6iNrASw
   bmhpEDkMFugO9SaOY1aTfIN8SSncDsR/nMv6mOELnim5SY3IVWdsbP5kt
   CDncy4uhz5YvCuhdvWv3QtaqYPlmypSAxCHehbEmvucO37C3JhU/9UfD6
   XDxaArQib9vxs3gVtSnUl7277hE+a5qLGqCdfCVZMoP45OcDaAyJenfVg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337268369"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="337268369"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 12:45:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="743015510"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="743015510"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 13 Mar 2023 12:45:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 12:45:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 12:45:42 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 12:45:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O60fN7363BGxC0wYOSNiMWvYMR018JNN5m+fu9GWvEabCkctZPLmsM4xoD5bUtvtvYpHqkSkzZVyrmRdjATjf7SzkXXxRX0jyEMhnOCrQd/h0q9eWyyRVtJUSizy4reZp8kl1fgApZjILg6gh70Z0TZ8nnwZlT1QaMuGzYSWMo4KGss+8tZTtXHN7zKFYuAtL6T5vaJAa7EgU0x0b8zb/7MpKhX6hUNwf81xdwKvkfjJXwpS6Nj3rGb1r2b0dazfpKwWjZgZSOKrquu7SjUDMyaoIOuqatVN+3G/hVYqbQD1Rz2ySMTUJoX9qQAp0RfxEOcfoYmZQBGBw3DdgFC7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uu+VuwFVd/BwYOx7LSpEMdV2LZ5/MIUiln+GpOVQ9N0=;
 b=QdYfTeG1xSVu+J3mn3ckoamtpOiGJEo4T29Gk8NGcyO7V8oOqN67KyCEP0+O14MhBulJJCqcf2eC8mDbsbGwrhCPYaTGnFHw4m75wh8Dm+UjySq2FVUHO/SG45GpDLgf9T6oHFOE/OmiGREnJ5EE7Iy6VtYElrPfWVlf3ab5D0kF4jiIlM3t2sKm7oabuVPTzaZFgjdRL5WYWNomJYsqGv6AkP+7yuphpCNDg3AxZCKEXB8phFwaGiMv9Ps0xHzy3MkiOp4w1cnx9IQc4RoqV/dC9r/V6n2oZTdjVid1RJrevN4GoCSIYz01FJrIX/OEaPlcPavpy9DtFbn8XfEgJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA2PR11MB5065.namprd11.prod.outlook.com (2603:10b6:806:115::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 19:45:40 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 19:45:40 +0000
Date:   Mon, 13 Mar 2023 20:45:23 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 4/5] mac80211_hwsim: add PMSR abort support via virtio
Message-ID: <ZA99U1TMrUfZhk4G@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-5-jaewan@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313075326.3594869-5-jaewan@google.com>
X-ClientProxiedBy: DB8PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:10:be::26) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA2PR11MB5065:EE_
X-MS-Office365-Filtering-Correlation-Id: ee721a88-8de2-4150-1bbf-08db23fb85e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPJGe6zgr6lwaZzcA1rJTAMZYfABA7ojl5qofdBC1NBgYutZ2HceAqEDyp9j4tkS1Xq5tXPauFg2snhh1uQES87WQAWgU+4gUON+ez7qHlWW6RlVQAQGhJ9M2qDa3yW5SkkY23b3+zXn9V6S6LesjsFjDzzzN4+VS4d682Q/T5tjHO5ic4wgEUoW+5QYc6UzNVK7XL5mxmUM1sYaYineP3cwWoaUPT+1QPrxeTB7+Ky79G3q9zG9Qt/7qS9Fi1bgPQzdCraDYPhZEmyK57ErBk7QJk60FZS9iqJSOtBINahMLSeG6WyvEPq1tQWxwol5uK3Yr3v7MC7Tv+O9oXvrEkUn71u1PJj+tNAsDetkIMNs+lc0w9D+1gahribojtvaoA/ET5DHWT7w8WnVvPMIrJMJjByo0Yp5s1/Xihv6QV2/L28K/mGIN+XvuexMRYEMUxhEAYMAFu8toGnNDf0TsL7qHYveXgXfIUi95z35TprVZuHoB0L5cO5mUJc150OYh0Y4y+5u0qPWzkVf5fsxEQWeX53/t2EdbqcN5mgCSXGGpCMavvMreVdPHpFY8YaSbopnp2K+vOLizXrn4cPeNZ9KaczeUxZtQ0SN4JqTI1+AT3ytbYZWP0f1OcHgMhUYztZfoLiD0yew37mAu80oOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(8936002)(41300700001)(478600001)(4326008)(66946007)(8676002)(66556008)(66476007)(6916009)(86362001)(38100700002)(82960400001)(6506007)(6512007)(186003)(6486002)(6666004)(9686003)(26005)(5660300002)(44832011)(2906002)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xwF+Isk7PJIPrdIKX+KRdv7w3e7wSHueHF5AWoqey0SQu225ErjuDbYIgu0K?=
 =?us-ascii?Q?G5vnQCZYkddesvvlMp2XrLAcCA9sfGwat8s2S08yCbourDTV9ElMjCXrN5Bu?=
 =?us-ascii?Q?/zUpUcrVl1Sh6RGNfqUK1+fEGyLttL5w9ds2O3AwlIaZ3V5cwDpo+UsZbH9O?=
 =?us-ascii?Q?4SpgT5EvuHB4yr5a68g0wIUmf+4/w0TlJDR3yYD3tVFlZP+0QkZMZ9oIBcNh?=
 =?us-ascii?Q?PY1gceYQ5vSSJKaVUT0e9vEj1tCqT7D8/nuKcjW8o1wHoTU27DDwLtEoEVdn?=
 =?us-ascii?Q?9FEHtMXyJb8h6OOUH6cEEWRRhPF4q+ht00bPyZTVm037giOkUowtyfnPG5lV?=
 =?us-ascii?Q?BC0JmLo4ZhU2WFm/A1gJL1Z0E1/4M34b7223pukU2QsI7MjxQ/aSBMQlopxh?=
 =?us-ascii?Q?Tuc5GUrfGZYGtWiRRReiPmDdMgyXbVWh92LNnzRnRsGRU7fOXQ0q4pFAXFzn?=
 =?us-ascii?Q?OVI+mZta69Fem+AN4723dN9dDn6aFn/rQRzL1+/s7SFEMpJDSuvrIuoy2Utx?=
 =?us-ascii?Q?5v/oI9ArvnorTs5ds0PyY2XrRdJlTuQLija13ZpKIl9I6s47j4M47TrnPFmL?=
 =?us-ascii?Q?Es4mF+C5eQAbXEubSz1w1J8p5hBPPakdDjAoOFofAkIeQFhtr98c6Ffk5+7y?=
 =?us-ascii?Q?weO3ebtc+QTnnmYWQRv9ftmms3yx4HySLMCFHdM9m70PNSApQwljIgqeQkFU?=
 =?us-ascii?Q?SrqQ2cHtSoWOHOKnygQKQR237PWlOWNVRRurq5L8KXSULE07HaSRxr7LiK9S?=
 =?us-ascii?Q?qqBq3J0aPonDB2w/64o7BvNVVINSHueyNqCW54BXgX7FHNCXiCxo1owHyxWh?=
 =?us-ascii?Q?Y3HqlZCNd283jiK0rBJfiyF+y6wuLabPkMdAcYOD6sBsIx4bnuFF9Zk75Ke5?=
 =?us-ascii?Q?hM5k41nKdkxZARUBQcfljBdQDPblnYSUOhUleG4al3CaVaXbJyzoRmoDw94H?=
 =?us-ascii?Q?vVsafu7gLNtuR4Dr7oNXmBggM4M7Iyrtl5BJBXxg+invtTXEYexxsGQJyhZ3?=
 =?us-ascii?Q?t/WsFSspjMNPzwbs+PY3g61wVsRj3nkOaEv/GnaR9c9t2SGxp83dz7xUTUZ1?=
 =?us-ascii?Q?w5OUT3OdHE49VPDt6+cAlGujgPKqExfwvPyXX/eCauLqSguqXJ2weB4oEaOt?=
 =?us-ascii?Q?8DMu9NZvhMVM9OElq6kbTf4KZDvj0B3R3LX/7/0XCHgsMTCLdOj/DbNHU+TJ?=
 =?us-ascii?Q?rGPUoUXCuMoues5U2C8nIccyH7gLrEprrdeDFDwgD28d2a5UgfhCL647lTcB?=
 =?us-ascii?Q?esOyfZBLOV9cv5fb4lalL+FrV7PnbejRbblPMbg4oMnTD62OhA8ZOdmJ+oKw?=
 =?us-ascii?Q?Wob+gngSv29p/JoCLkv6vpViEEwN7i024vI/BxodzR37XYFCnVqOdE9zLjwz?=
 =?us-ascii?Q?xPWVS8jbR7HOiZ81/8lhKRNrEE78EkhqIY1CQLfPYVBoUlP1Og8HkvdCQ6L6?=
 =?us-ascii?Q?U3Iuv3oPAWI1BFO7Ik9Rr/dJ6YiixCgU8vAN/GF1WyQGz2C64FEejQyLEPU+?=
 =?us-ascii?Q?v8LV1804lTYfg+VSnPcyz0XUTkcpiTVerAqyy4VMoLLrujOhux2m+ROS99AH?=
 =?us-ascii?Q?QeNuFvtZiX1mdcykNZWCOGiKcbwdLh7mrBDtyIOvzxIpEEBGFbUFXXXniCS/?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee721a88-8de2-4150-1bbf-08db23fb85e0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 19:45:39.9283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTw+nzcjizTueldMwE0Uz6mi/Lenkeex20VqhOIPKXZ4LTA5Nhn0hOaghj1b/rZRIwi0eqbjBgP8Lfyd/XAHvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5065
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 07:53:25AM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> devices with Wi-Fi support. And currently FTM (a.k.a. fine time
> measurement or flight time measurement) is the one and only measurement.
> 
> Add necessary functionalities for mac80211_hwsim to abort previous PMSR
> request. The abortion request is sent to the wmedium where the PMSR request
> is actually handled.
> 
> In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> mac80211_hwsim receives the PMSR abortion request via
> ieee80211_ops.abort_pmsr, the received cfg80211_pmsr_request is resent to
> the wmediumd with command HWSIM_CMD_ABORT_PMSR and attribute
> HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> nl80211_pmsr_start() expects.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>
> ---
> V7 -> V8: Rewrote commit msg
> V7: Initial commit (split from previously large patch)
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
>  drivers/net/wireless/mac80211_hwsim.h |  2 +
>  2 files changed, 63 insertions(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index a692d9c95566..8f699dfab77a 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3343,6 +3343,66 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
>  	return err;
>  }
>  
> +static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
> +				      struct ieee80211_vif *vif,
> +				      struct cfg80211_pmsr_request *request)
> +{
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	u32 _portid = READ_ONCE(data->wmediumd);
> +	struct sk_buff *skb = NULL;
> +	int err = 0;
> +	void *msg_head;
> +	struct nlattr *pmsr;

Please use RCT style.

> +
> +	if (!_portid && !hwsim_virtio_enabled)
> +		return;
> +
> +	mutex_lock(&data->mutex);
> +
> +	if (data->pmsr_request != request) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	if (err)
> +		return;

Redundant code - err is always zero in this place, isn't it?

> +
> +	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		return;

Return from the function while the mutex is still locked.
I guess 'goto' should be used here like for other checks in this
function.

> +
> +	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_CMD_ABORT_PMSR);
> +
> +	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, data->addresses[1].addr))
> +		goto out_err;
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
> +	err = nla_nest_end(skb, pmsr);
> +	if (err)
> +		goto out_err;
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

I suggest to reorganize that code (or at least rename the label "out_err"
to "out" maybe?) to separate error path and normal path more clearly.

> +
> +	mutex_unlock(&data->mutex);
> +}
> +
>  #define HWSIM_COMMON_OPS					\
>  	.tx = mac80211_hwsim_tx,				\
>  	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
> @@ -3367,6 +3427,7 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
>  	.get_et_stats = mac80211_hwsim_get_et_stats,		\
>  	.get_et_strings = mac80211_hwsim_get_et_strings,	\
>  	.start_pmsr = mac80211_hwsim_start_pmsr,		\
> +	.abort_pmsr = mac80211_hwsim_abort_pmsr,
>  
>  #define HWSIM_NON_MLO_OPS					\
>  	.sta_add = mac80211_hwsim_sta_add,			\
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> index 98e586a56582..383f3e39c911 100644
> --- a/drivers/net/wireless/mac80211_hwsim.h
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -83,6 +83,7 @@ enum hwsim_tx_control_flags {
>   *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
>   * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
>   *	%HWSIM_ATTR_PMSR_REQUEST.
> + * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
>   * @__HWSIM_CMD_MAX: enum limit
>   */
>  enum {
> @@ -96,6 +97,7 @@ enum {
>  	HWSIM_CMD_ADD_MAC_ADDR,
>  	HWSIM_CMD_DEL_MAC_ADDR,
>  	HWSIM_CMD_START_PMSR,
> +	HWSIM_CMD_ABORT_PMSR,
>  	__HWSIM_CMD_MAX,
>  };
>  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
