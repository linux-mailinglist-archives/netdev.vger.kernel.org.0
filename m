Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280E96B9865
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjCNO6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjCNO6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:58:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6583E9027
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678805909; x=1710341909;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Nv+JKkk7Jy16sUZvsYgeKTwlmHXiEVjqbt5TjB/YFEs=;
  b=V1WjPn+nJDQuSKLkb31Ju35qIgkagjIKWhx/xUgxzGq1F6AbX5KzJK+N
   SjO/NsGAzlH6dKQa3+CCfPeH5xPU/Rw2Gs/TNQl72OIeDv9svR/ZLrixE
   gqeJgmuIfjkOqwbbKR8NW9Xyr7x/1Wvyh8yQ0UK+A773sa0YZavEN0GpX
   Zjai1cRQCxvfvBSSjguAz8zvuLkmC8rUneOl6CMTAO3WOtSltvlUU/i3N
   VfU3U4gsl/RvV4/WyCUn3S+l7mL2T8W0Sft+TE70TxXCP97/M/W33W+Gx
   ZQti+uWjjeR2vb3u5XdNaaIfo/kxBs9ehXjCLN/fBO9NzfOrzBurr9KXO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339809385"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="339809385"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 07:58:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="711543761"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="711543761"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Mar 2023 07:58:28 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 07:58:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 07:58:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 07:58:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE2XdB6lizTvQjcT3moK1x6z8Ic0XA+utRJT6N3qISuz08U90rTnF4lLfkTJWVrSLvDovEAq66QcCfGX0kqJISClQgzcmnbWVeeILMOkky/3CCIRmjm0XydrhQZDEi2SI4ZM921K7wLuLIweKIS2WRTOmmZlWEOxGdJ62hlfmvpnC6ktWmLMiAPq3nJ1c0BZW5JrpEULiOzuqZjW2desAFQcTvZ8RS28xdQbZF106lmGz7bz6rbAE1n5II69XAjcPWJImCQ+hNtGuVdp5LaKYrXbo8jligvBahTFL3YAd2uSIjtwjH1y1Hx6sIkSapcvGNMhBWBdda3p0UHDrxj5JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg5l/IN5nk8rmtgELHznaugioMBlAOQDv/Dv7gcmEvQ=;
 b=foYImN6rnsFz4r/CML3JFP+twXbFhmOvgYo04Y6y4fsnjluYIBvyO/k1Gc8YUQAfUg2WkV6H1CEdUAF1tJpJ74fRuLtGQdhRvaTxVH44bKf9vmu7Aqkarz6V/I72fV0AJywjzPvirZ7BrkFczrM8l+lsyJDDVjQNFyyzn5UWc1MghYlCgjfgn+KERKUgJt4NGvItxTORHIQHhhQxPrFRCCRDf/2ynngeeWPpTLznddKpscQSznDVCR2O03ywy4Y+Nr4PptcUdqvu8cw7vHnrzX8agaTkMjtLq87diTvoK8XI81bduWkAdiRufRpfOo+wJwJUSsGVSWWHcb1OWSpBaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 CO1PR11MB5073.namprd11.prod.outlook.com (2603:10b6:303:92::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 14:58:18 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 14:58:18 +0000
Date:   Tue, 14 Mar 2023 15:58:06 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <monis@voltaire.com>,
        <syoshida@redhat.com>, <j.vosburgh@gmail.com>,
        <andy@greyhouse.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Message-ID: <ZBCLfr2qvgz5Vwos@localhost.localdomain>
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-2-razor@blackwall.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314111426.1254998-2-razor@blackwall.org>
X-ClientProxiedBy: DB8P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::30) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|CO1PR11MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: de67cd81-9dff-4c97-3624-08db249c8bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8jC7aLf+OGjbwuGrs1Ul6F/8YxCcukXi1cZzG1dK/k/7oH/KN2hJd5GJDzceAAw2Wgv6G8wnoAAun+o0pxclpnDWv4z1YPzrJW5kGglh0RbDtAAn2G8HjwFMJ05BPHvdcu3+NACmd2ivIjiY7ejV68ublivtrXNavJ5kBIoUr4Uu2eqN7xuhZR2Kxh54zKXTIxzbKawWWbz2tbabXhSopUYwuv8Fjq5tZ0VkzvadDJNBOoJzexYw3RwGWhVNswUSmlfOSq1OIebXThrHztpD9OI0Jl2B4cvv0wmwmdQYKcouetEqmOMvUiZXY+QGTDdRXm8z1nBSgvdbkcnu47ltBSBQHR+Sk5Qetly5KGjNjLVrPV1OZb0hmSq+5GCHYInpmyYa5dzcCwNXUvmHqHwE0rtJ0Lj1fGneTRpIVN3KrinPa9csnHE7Eo0E1t0VHOkt1dIiMOBgAhLkK4kCGx92GJDbziUkp2Z32egW3hH6NOrX2VO989oQmFFYoSYVj59Mx4jSwQkICifm7IPEiiUY8J17Ur+vkP11rarOJeASkmsm65Uox/wtubvfGjakaZ4R6an+WgdZAihc9MGpLSPCb8ZpDnyHO5FR0LYGgPJwv8/L+nQzt4XI1SeHguNun8s4ZJ1B15cAwOcoVXMuztghA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199018)(83380400001)(6666004)(478600001)(26005)(6506007)(38100700002)(6486002)(9686003)(6512007)(316002)(186003)(66946007)(66476007)(66556008)(8676002)(6916009)(4326008)(86362001)(8936002)(44832011)(7416002)(5660300002)(41300700001)(2906002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5TUVmv5FXefCl2a+RgIoTkT1yAqWrrlO/4ndi0T38/8IgfC/koq1xo6VcZO?=
 =?us-ascii?Q?ox35wSQUPHS8WirZmWv6PdXk3kGmL0XOCW2oxy/kVEc9J2DjsM3OEQHh4G3e?=
 =?us-ascii?Q?2CumQ+sxxRtlZY4bDVJWVMnNHBIpGyb0XUpOxHlnLaiEpaKjY4uOt8Vfbxc2?=
 =?us-ascii?Q?tZrXhBHjd/Xr8/UV/i2eABg/2pP15loy7JU674S1GkgcQK6W9nF2SRnelwuQ?=
 =?us-ascii?Q?mdRarN9xBHGxsI7570Eyy+J3qALLeO8r+BKXwXfBMuKbJMoz5MoSuFdF69SC?=
 =?us-ascii?Q?ZFVJVVDmXlAC0XI+Q0GNBPQafftuzNnb951HTYfapMyYCTLg0PmoTGExhRfc?=
 =?us-ascii?Q?KsxId9lPWNmZ6gKjz3SeY5Ho5NygpUHoBiGAMx8P0Z8Lt5g9d8iMI358DWcC?=
 =?us-ascii?Q?MFHP2nbLwyt6VY6ZB8HggRcfw6EJqT9arOpN44W4b6j7T3MPLRYbQLHgxd4Y?=
 =?us-ascii?Q?CXnjMzgltySr3yY5aB+AhOZOGDTTd6/i87OKTpuub1VMckma5z4Hu8IzWy/3?=
 =?us-ascii?Q?Bs6GNK04BUdAgw/i1d9BNS7L5RP5VHqiWh8EUaIexnqiaru+OhoLgK1osWlB?=
 =?us-ascii?Q?PmZgOXZEaMi4PvNEoYKstbRmyF13/a6OEZzr7Ms32AQsiWoSEG0qpc75SESP?=
 =?us-ascii?Q?kGS3rpBv4krrrgnMWa5ESuA7pCWs6dFjNkYxoDddAqDYq0/nPTF4vyksH98I?=
 =?us-ascii?Q?+O+4A+hcZTE3jNN1GFgA06RVn4ot4jOhVU9c4zGbF/Ovkqadb+PoC28lhjK8?=
 =?us-ascii?Q?MexKL/EkOBwM+eiyJFroHQvtgqa6psvouy+9kEZ4CB5CQzXilXSIN/PbPGSf?=
 =?us-ascii?Q?CQTkJJnQBqVkW45u/gaWL7fVdpiVnefJNC6ibbBYxyn0VpsjUL1yxU1pzpeu?=
 =?us-ascii?Q?orsv3+56m70r45Ot0qU3ZYkI5aWpBPLA0omhbcLPuZTeP7GHQLaja1bLlubH?=
 =?us-ascii?Q?TsQb8MnzRwQymg12g68NsOdCIWa9KSwvB6nunem+xSvHsxArmUmG/PgDP1LX?=
 =?us-ascii?Q?VCFB2eVGN+n0ie2Db02buCrzjFEohwRSbltF6g0Vxwh70fcFdehYiv7pE2e2?=
 =?us-ascii?Q?fRM116klNS9HlVaniolWTJHTMsI+KnoTFdp6U2Ugp5OETl/e69baYGmOsEoN?=
 =?us-ascii?Q?gTyyHERp3jmWvBmljBhhgpFTsqVyCv76y12fxWSJPmslleZMkauySrg96wPd?=
 =?us-ascii?Q?8LHZG1UmrrdUL+D6I0oYjt4lTeI1IvJamaFFKlSznM7D2mwmhDtttsHfRPv5?=
 =?us-ascii?Q?uy1mas7rfB4g0N8pHq/rJwHGYUwmeJDGhrnLVtkRNlkMQly/dBjBYIEjkEya?=
 =?us-ascii?Q?g0gxIVUroxvSV7LCV22cbQvcO2rE9qlInrQOmUgf0wjmgqURG84rM6wbZdkJ?=
 =?us-ascii?Q?aATGvjUJmuMC8t4DrESvEEdKor9n1HV+N+XOfIirow8VMfPkEIFIeWPVyuG2?=
 =?us-ascii?Q?qE39m2WIKpJ0QUxulpLttWKEVoaJ4tjqTV0ffHiFwzxU1maxxowjub3vUst6?=
 =?us-ascii?Q?rbFW9gj0M12/NLnZgmcGS1s1O3UvKF9ynb35vU+ykRXEnqZD5FCW7Iqy+L8x?=
 =?us-ascii?Q?LYzowvDaf4CDkf0QRcnhoqPYsYvZyisey0NUb8D2yr8nrLxhjFxXABS5APld?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de67cd81-9dff-4c97-3624-08db249c8bbd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 14:58:18.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1dRoa3zVC6kgMKDSDP6mcLTXX2yZbsXnyduST1L0shJlJWk9WeV2bA5pcjQcUD//zo0ACWMgb6mmO5XMrn/ULQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:14:23PM +0200, Nikolay Aleksandrov wrote:
> Add bond_ether_setup helper which will be used in the following patches
> to fix all ether_setup() calls in the bonding driver. It takes care of both
> IFF_MASTER and IFF_SLAVE flags, the former is always restored and the
> latter only if it was set.
> 
> Fixes: e36b9d16c6a6d ("bonding: clean muticast addresses when device changes type")
> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  drivers/net/bonding/bond_main.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 00646aa315c3..d41024ad2c18 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1775,6 +1775,18 @@ void bond_lower_state_changed(struct slave *slave)
>  		slave_err(bond_dev, slave_dev, "Error: %s\n", errmsg);	\
>  } while (0)
>  
> +/* ether_setup() resets bond_dev's flags so we always have to restore
> + * IFF_MASTER, and only restore IFF_SLAVE if it was set
> + */

I would suggest using the kernel pattern for function documentation.
At first glance, the name "ether_setup" at the beginning is easy to be
confused with the function name (bond_ether_setup).

> +static void bond_ether_setup(struct net_device *bond_dev)
> +{
> +	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
> +
> +	ether_setup(bond_dev);
> +	bond_dev->flags |= IFF_MASTER | slave_flag;
> +	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
> +}
> +
>  /* enslave device <slave> to bond device <master> */
>  int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  		 struct netlink_ext_ack *extack)

It seems you never call this newly added helper in the current patch. I
think it creates a compilation warning ("defined but not used").
Please add your function in the patch where you actually use it.

> -- 
> 2.39.2
> 


Thanks,
Michal
