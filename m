Return-Path: <netdev+bounces-8408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CE9723F3B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D3E72815ED
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27A52A716;
	Tue,  6 Jun 2023 10:21:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC228C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:21:24 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26AEE42
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686046883; x=1717582883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BTfj9XU++KFrH4yszmkbLP8/gEaozGPyuIxhyISsUB0=;
  b=no66lKdFb3W/KcC4KTwe96q/5n0z9QeW/FV4kowkwyIwWbSEtPWgHrNs
   qyS9Byu6zQdnXXbKmil+xzMmdn7c1j7SyWdpe7puCb8YIdyZwGbGg2CTj
   DLSzccwhv1dn2IvQSQYmOXlUtXaOhMSWC+xbVH+Bo5wXKHr+1VFjmzn7U
   j5IC6gj1xKPFqN/6PAH6zJByNrPlRudA+eE6FLKZqpcib7SU90iAEc871
   3/dK0lqDKgd1lR33jktUKZHPWj0jwXTvDls6p9XINS/p2t0FzFw6N7iSy
   UnfkOP/8QEQ0jYAeImxaAn87kkOwWuFmb95ZrQ3V9IX+OWwVPLgNVOIo9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346224974"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="346224974"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 03:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="853359909"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="853359909"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 06 Jun 2023 03:21:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 03:21:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 03:21:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 03:21:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 03:21:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBB+AqUzSG3hDc6PD/6/1M8nXa6tbduT6clmQo+fdeExON+soUpn0cLDGlPw2kY0H/JFKw0o+OVNIFFv+IsRv7TbqjF4p49dRdrIuSFrUOH26XLAor9Lq+V7TfEoffsoa5nQcdsFvAI5SBJjRdj1H09kjDc2Qj0RmIKBZDxMXakxknBcT9omASFEHbXQGfGXue65Yq/rQCS1jl33nzHTOtS9DZWAajNR/nScPCAHLWKo6lND6rkV5isqPVjDgd6q+gZZe51h+AcO0Ackw4LV4qiV74ZCiXJIdcGTQXOxqxM5zNUPZ+6kawUm7cY1tApzrHVvFIBgu/pnpasp/yC8Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wO2GOxxZx4kdrul7nxlHP4KSukuJ+qgeBXiEqg5C+lg=;
 b=P280LZLSf6UuvdBQQeRKEd41DJJLVfHTlxnHYhQODmJYhTHmGY44/ykd3KpSTJuAk0ugXkBd6CX/vyOXFY5+W+4nnGW1c3VJ8DakiXyUWEUYX4kp/LqWt1DvL+rIIkGja1HeibEoafF/3RUIdH0hxlrqu1RaMBVcs1M8BR16VB+JK3shxE7vbq1TGWfFgc9ctF85gzyoD0Cf0i7WixhLwlCavxds1S3iLS/wLzx9jCtO/yT7/jqZvZVLTTRW78m5J/Fm7rKNoHFEJTayZWF3K+VTz58kzoLp3iTmJXN+gMBkwEXH+YbVpzRhgSEDXAlS46h3ZV953U74EZZo6ZuQBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB6221.namprd11.prod.outlook.com (2603:10b6:8:9a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 6 Jun 2023 10:21:15 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 10:21:14 +0000
Date: Tue, 6 Jun 2023 12:21:07 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <ZH8Ik3XyOzd28ao2@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com>
 <ZH4xXCGWI31FB/pD@boxer>
 <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
X-ClientProxiedBy: FR0P281CA0205.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB6221:EE_
X-MS-Office365-Filtering-Correlation-Id: f7293885-0b70-49b3-9fba-08db6677c1c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0ypiYMFQRJKteMoeHLLMyL65rcCQ55x7ftxLE6yBIvq551r6a4lDQJ58YXCa+NI5b/8ToUibre48kRkgymZvI5zabiK0qfBLk/GrjyKeJDKs0MftzcfANVKuO+M0z9xIcmjgZVpvOHXjT9Z1ju2TMan19nsqDCXMnruF9Y7aTruqYG089DBkMwgnTpdK0qk5E5E9TmkjFTALgQi9mHgNd2xTusWZBjP0xmM58bAaYIf9Bgvc6FCcCOpueyIAYT77KBSDNF0ZviYwX57xiEzx7QzoLXAMEIfxlYabs1eGxjpMZmfdBVHydVa5BaXROt4pPk7TrGgmkuHxAlatg2gV3gsvNZ6P1Q62W9yb0GHd/KMasIaWrNO1gMjFiW+lAImblMQ4mDX1uZ5W4psWPNr4r/gw4pyjGLtp9uzP7hsn9NAiZcndgwVX12o049aywUVP0zFzUqbCGKhnYKjuA9dbn+aJYiRn+9kHaYhucesqcJN9oXdAlecpd8K0Bfg1nVDxKenbcLIzrfMynDAv0zLoH5oACpu9JFUFBHhRmvEc6R67Z33sEZ+xynMqZQONVZs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(83380400001)(38100700002)(86362001)(33716001)(82960400001)(478600001)(41300700001)(6666004)(6486002)(54906003)(5660300002)(8676002)(6862004)(44832011)(66946007)(66476007)(4326008)(8936002)(66556008)(6636002)(2906002)(316002)(26005)(6512007)(53546011)(6506007)(9686003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eEUVTJ42ejFOBVUcZPTQuIkwl/kscuSDWUnze2uYhelshedIWMvM1m0AlClL?=
 =?us-ascii?Q?8TWTEzpFxYRsDSm1m3a4EWvtBftu5/bkC+tOppJnWSXPNM5fDnzE1bbhZ90+?=
 =?us-ascii?Q?+GRatXToNgFckTH61xkmLqDAIrKiNDWVr7FJCx6EQrmQV8h8SoUDiRHId7Nu?=
 =?us-ascii?Q?cTRgsij/WTSSvGr8xLvLNutbK1VTL2ndOyJqejdvuXPNqlXk0B8Iy2aFMkUB?=
 =?us-ascii?Q?mtIiOq2gEEnvnCIhI4OBKLkF/RHVfXoWPfRNirmI3d/iVvA+RbtES9qqPvI3?=
 =?us-ascii?Q?z+B2gLkCXdgOjorRJ8ItCkICSYwnABxbiqx5FLk466ZNOBDXG46Zvwa0rCkM?=
 =?us-ascii?Q?RFFahRcSy7wdKyVdcr2nweFhfFVDSgUzwy5zPYF9h+SGSF81NazIgttD7iG3?=
 =?us-ascii?Q?Ofcfk4TIrO1vd6XQ59sYYVDxuvZ/gNpSA1ScGeCWqStnZU3n+L1e8Ok/34QP?=
 =?us-ascii?Q?Zo/NryvYX8GAVfQjd1hKCH6wIVY6xzQNZReE0JYniOcimNooXAGmgbtvWVGr?=
 =?us-ascii?Q?I4K9dI/OuH+BPCdGInu9jd9hCckgZ8koicv8aTOCh4LWWRQb5wAMH17qrVjl?=
 =?us-ascii?Q?22En990gK85eLVPvVSbatmVqHdpwk16LYTalBNE758Z69O6mruzcv7YNtNsU?=
 =?us-ascii?Q?qHo4pJ0snV/CToNf5mUS+7tfQU1KOuK+drZgwWAkYLJzAlypsCDd3vppe7Bh?=
 =?us-ascii?Q?YDuEwXzkk5VbQJafeiSCMawap68FO2aL5oO8GsGWDtKgCmUCCn6m0YeFHqQk?=
 =?us-ascii?Q?7DMaxO3ahmhSTVn6eyYA5UdDsL6f+R0uQ7UX6pd5xhz2SaX4LcB4/X/hPe0M?=
 =?us-ascii?Q?xujF2cN3F8GO4zY8HsBVQR4o0JPkXlZIMzqSdje/KW0XEMzTaez/rMYzpuD8?=
 =?us-ascii?Q?9oPF5vrRECEWRR9c4XjF8WXGVMChdV38uQKUXsSzESwqfMYnhxAjNTc9Creh?=
 =?us-ascii?Q?Pn11YjgAD/36LrnmCt76eyL97395iSj2meoXq7yNVXCaluN6UjQVg6TbiJjW?=
 =?us-ascii?Q?NnhZzkB+iWgp8bk1JG7++b4+KpefkaVSIMIfDy5+lNWPALtpom65G579HzuL?=
 =?us-ascii?Q?hbnw46Jef0m6SJdSa0WjnJ0SknoTX6r5O0hsglfSEUCjT+lEP87jp8oyup+s?=
 =?us-ascii?Q?fBhBZh8m6w70OP+aWtrE4qaLW5zRXxJTYVa8h9jaK1rHkbbegvvu+ZYphx0N?=
 =?us-ascii?Q?XC5idJcutVrZ+wljVJkiulDYJzevYtX1wC4DSWtukPkgqRfw/IK9qiFuQQzm?=
 =?us-ascii?Q?5D6pIuS0atyE7+tObxH5FXFXQzxRcSTITO8MnM0KWy3YfOl4dpQv710Gv3QG?=
 =?us-ascii?Q?spbPhi73F+OI45AQAsYGeSI1pjOTC1BnVGX1e1/rQqLpPvsmpFYcJtiTyZuS?=
 =?us-ascii?Q?3zRNiBSBZv47XHOG+3XOn8RxrccceZ9nainPoAG+teUOGdZk3/UixHiC1HVP?=
 =?us-ascii?Q?EdtSFzuSz8ykXZgWhq0roRj/PeQNhUGATi1gLfR9qw6gAZVuYZ2G7zOtnNOy?=
 =?us-ascii?Q?OJVfzX8pJ6VZLEdLBN9stQvBg9z3LGi+ut6z+Toier19sofEmBktXIgKv/r+?=
 =?us-ascii?Q?ROieQImb/3ZOoyzmepJoTSAsw0t5r9Qaxi+OUn2nVN+Dj5xNvFv2TniKC09R?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7293885-0b70-49b3-9fba-08db6677c1c9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:21:14.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lW2NnYRHEK71GXAhRw1GuYsEb45quiAo3EDc46p5fqLdD2YHGYmSA/5pfy8BeGr/4ljKWgKlPw3vhWPTH0EKWHu9W05jCBOWUs8eVhETMh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6221
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:22:55AM +0200, Piotr Gardocki wrote:
> On 05.06.2023 21:02, Maciej Fijalkowski wrote:
> > On Fri, Jun 02, 2023 at 10:13:00AM -0700, Tony Nguyen wrote:
> >> From: Piotr Gardocki <piotrx.gardocki@intel.com>
> >>
> >> In some cases it is possible for kernel to come with request
> >> to change primary MAC address to the address that is actually
> >> already set on the given interface.
> >>
> >> If the old and new MAC addresses are equal there is no need
> >> for going through entire routine, including AdminQ and
> >> waitqueue.
> >>
> >> This patch adds proper check to return fast from the function
> >> in these cases. The same check can also be found in i40e and
> >> ice drivers.
> > 
> > couldn't this be checked the layer above then? and pulled out of drivers?
> > 
> 
> Probably it could, but I can't tell for all drivers if such request should
> always be ignored. I'm not aware of all possible use cases for this callback
> to be called and I can imagine designs where such request should be
> always handled.

if you can imagine a case where such request should be handled then i'm
all ears. it feels like this is in an optimization where everyone could
benefit from (no expert in this scope though), but yeah this callback went
into the wild and it's implemented all over the place.

> 
> >>
> >> An example of such case is adding an interface to bonding
> >> channel in balance-alb mode:
> >> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> >> ip link set bond0 up
> >> ifenslave bond0 <eth>
> >>
> >> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> >> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> >> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> >> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >> ---
> >>  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> >> index 2de4baff4c20..420aaca548a0 100644
> >> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> >> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> >> @@ -1088,6 +1088,12 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
> >>  	if (!is_valid_ether_addr(addr->sa_data))
> >>  		return -EADDRNOTAVAIL;
> >>  
> >> +	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
> >> +		netdev_dbg(netdev, "already using mac address %pM\n",
> >> +			   addr->sa_data);
> > 
> > i am not sure if this is helpful message, you end up with an address that
> > you requested, why would you care that it was already same us you wanted?
> > 
> 
> You can find similar message in i40e and ice drivers. Please note that this
> is a debug message, so it won't print by default. I would leave it this way,
> it might be useful in a future for debugging.

hmm fair enough :) :
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

CC: Olek
do you think libie could implement common ndo callbacks?

> 
> >> +		return 0;
> >> +	}
> >> +
> >>  	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
> >>  
> >>  	if (ret)
> >> -- 
> >> 2.38.1
> >>
> >>
> 
> Regards,
> Piotr

