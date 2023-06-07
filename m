Return-Path: <netdev+bounces-9039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF22726B33
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D1BE281496
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1773AE48;
	Wed,  7 Jun 2023 20:23:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5962F3AE43
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:23:44 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF52719
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686169406; x=1717705406;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UNnoJKiRUAkFt+SWmN1lpd4skPutw426a4KJIrGK2HM=;
  b=HzTmK+cepMqV64NxxWrGafK7uAvQzgsV2MVK+bdVb8LHcfh5AugVlTfj
   Oe2zicGIfqYJTFf0+7goG5TigOYJP55PRxYNGtXblQU6bXnbEeBUp/QUs
   +tbNxloXnHKW7nCa7H3X02SEsnSiqTMPVEISlYRuWOzk4gAlaZU9Omax4
   oOqNgW3iZguR9ejLIYFnjdryBcK1pZVhPTNDkI4/TNI3s/d/8oDc4RApU
   GmoNePhRvvdS+XpEKc0tfi67dMQ5+2Q4QEFxfn7724foPtJ99cUWHhl8/
   0gcteYI0xsKjqisu2dbQh7SiHn3qsD5mQIHsuGEUm1WWTeRhNdIxFBlBP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="385431346"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="385431346"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 13:22:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="956437034"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="956437034"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jun 2023 13:22:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 13:22:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 13:22:36 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 13:22:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+caExfTbSrOgmvdWlVDS1NJVne6n4c51bPYCzLLUQYJ2OvfKz+F1H5a0gcAOuvy+AZQKrAHpccDiKqVAOj7AY5P9VKn9PvO3077KMvk4frHCefOuae6nVVhEDU6HAXtSkUXsziuQiLkR4t2UXTdiLHE4QEhzp6JExQTYh4dpv3K+hR4CkARy4jnXOuyGu0w7zvUlJB9HOlFzgtjxZX/sdUrSAEwovJlV7TFntnhH87FxptMa7Eq38lXrzkx0IBsbrbwqHBic9cAKnWxf7WbC43NAo22LhyMZ7uxJ1QhhxQx4q33Dsku6ZaEfOAy2bKy/gr2XXctLi77ke2HHjAuFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wNzN1ePjdliyKU1tPJ7j8+JLGlAeliy9zi+i3T+gcY=;
 b=hMrSOMfuMC6Qz3NoAeyJjHoHfNutswY6a1PZxexim+zJL1BMVbbwsdfIkmOAGqRQxQuxY3NKGE2TIWRMVzr0CWDEKAhaj9gFsR0bqgmuAzVuVcijo/azuu3cK5QHdqzbMPm68Unejx/VfMeHRnCYbcSA82pNO7rvu3Q5bCPonTomrQulr/ifPPMPMOgdvfORNyO84HLgSqQF6K/SyJXJGqsru0SLGfHaCagP0S0Hoe0R3iedOZHYXQPVaTCQB5c5ywh03D76xFMDyadjtqUTqi1t3XCYdVnVPgRTljhd86U5LuBkGTAKJRWP+uOgfYlbd3dbF7iHjs0OBM00QrJprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB6801.namprd11.prod.outlook.com (2603:10b6:510:1c9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Wed, 7 Jun 2023 20:22:34 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 20:22:34 +0000
Date: Wed, 7 Jun 2023 22:22:19 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Piotr Gardocki <piotrx.gardocki@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <ZIDm+wu21ybDCFty@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com>
 <ZH4xXCGWI31FB/pD@boxer>
 <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
 <ZH8Ik3XyOzd28ao2@boxer>
 <20230606102430.294dee2f@kernel.org>
 <b7b63c6b-7bfb-6bd7-e361-298da38011a4@intel.com>
 <20230607093810.36b03b55@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607093810.36b03b55@kernel.org>
X-ClientProxiedBy: FR0P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB6801:EE_
X-MS-Office365-Filtering-Correlation-Id: 806c6ae7-142d-462d-f1df-08db6794ed5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FyNvG/nW/PwImxoS3D2R203itoSlcs9iDyPkEgDg1Ynh2q5hhBVJOdoWy/CQMYFrKqo3oSlaA6cD89lrUrvWeKSouXIupTwBNJCA8ueN5Fo1HeRNmQ7QgYmBN9XA87PccMrMJVZv8sPrgXNV0HsxAS2LxHRGfZwAjodqMBtn/ZfHoYPnVwkwCSKonDi6f7B3Yp3LwB4TGivGhOsXjTPQ9zV9b72tSvWi9GIOLpHYr27IBimT5L/i5H2bpr8HvXJbYOUqO+pvYb7IXLGCTbRoa25+fLWo4C3kj3E4wwYkLHknvyzH0GiHsqUTnqSIGzw1eMkQAv9DNSUIA7TxuFal3HVDysIAjUT1vVFr9m8KmaiLqXkvlfnos7lTvjyXIWCmt5qrT4eYiYubTnatPMOTZlcdA1zq+eC3rApM2QepdHiIFPbZwzjm28h390g6rqBcqc8EJeocIuJ1kfOIDVw6iMNlDv6EC5Ffp+bmmF1gQV8nEOYW66rX1X/S8jOhm2u9TBFZcY1nCh4QhPTD/DbanuYEZrroJAvZrMw5XWZLCG4DCh/2qfogimMvSbuwxbby9ej10YBh/RPlR25doV809ld2BgSHvKSN7DF3pLzanks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(9686003)(6512007)(6506007)(26005)(86362001)(186003)(82960400001)(33716001)(38100700002)(8676002)(41300700001)(44832011)(54906003)(478600001)(6916009)(66946007)(4326008)(66476007)(2906002)(316002)(8936002)(5660300002)(6486002)(66556008)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F//Rj+NrMJlp/fjqP8H03DEnQyH1rnCamiO5V2D78pMCKBd2CXjnVa0D+IH8?=
 =?us-ascii?Q?DvDFtBftVJ7BUKNOutx3WveJdOhXbAvZH98aUm0rKcRi5K8tKsuP+qBEO/Vy?=
 =?us-ascii?Q?Vs9MDqIK0xqnul14xLPfdHPgk4kWQV6ENpw8b9gw2xWQq5TblBjmmhdve3XT?=
 =?us-ascii?Q?mZJIe6J2gV500qp9/S8el7jRsufr83ZbN/wDqblK6UAvqZAp68VgKyIN1kMP?=
 =?us-ascii?Q?lVdg0WVBqGSwy6BtWoftr5WCVCAeEUERujNJkShu9CB7G7DaSF/RWvbp/k+T?=
 =?us-ascii?Q?S5Pq+nQtx8+lAK8nocj2cdq3U/dSyz7oKePbHD3IdadFNstar4rS7//vKZBY?=
 =?us-ascii?Q?V2p+AK9/KMlQYw6y1qs9TQ3uRhYSUZiTc2GHCNVDKOKeOEE1eJ99pYuGqE08?=
 =?us-ascii?Q?iMHQ1nBcI4105hnk8g6Ts9SsV9U5iyhU8TNtyjVTAwNSM/c0gCettEr42Jkt?=
 =?us-ascii?Q?/23v+Bcgqq0T0zJp4PPxImzJwsDipOz5HoIkrhiaDOxnfc5z/XI0Ko4L0Gei?=
 =?us-ascii?Q?FLMF6MN3xjmS+/VM0BXYnAA4r4bGTFYRZ+r5HUa2sC49TOrQRibEH71zkgJc?=
 =?us-ascii?Q?KkAHHraaAozx//MQlOkd4zSNU1qAk7H3DCfypaIn3Clnmbdai5eZVdwb4IrH?=
 =?us-ascii?Q?Y7ZpR4Y+gbWpABv4vXAnp8iVYg4LnNQXwrOIR6R//1B/F0d6VkGBRv07Y8L7?=
 =?us-ascii?Q?7wQhcFrisOvDX4vDFgThSQlxqXvPiquXrMUht0WEqNbhvl0S+/sLHgEW++HY?=
 =?us-ascii?Q?mi0PLQgRMXCKmceyBlIVc9gwlUPj7MDcEc2uQB80aHSgLQQsnOJ/c7hD2w/c?=
 =?us-ascii?Q?LKaJrvnkR46FfUYK9Z97FLPmfMYx4W2BEEvL8/bJqKkBmMbrz42iQcXJlufh?=
 =?us-ascii?Q?XevNmI0VO8MJ6y+5D4c4YIHOMwRdDOKRVdVEr1Fo+OP4HdIicebjHIW0WlBp?=
 =?us-ascii?Q?BTUShQeGYMi7OCwO6uwBv6n5kT4krYV1FsN/bwB9GQAcF/znCYSL9CUNQZsh?=
 =?us-ascii?Q?sOExnlkKUcfOd3ttHVpowCk+uutuYxcrxnaNl0gdOCMh7+jQZnjUwCiS4FsM?=
 =?us-ascii?Q?itMwRlwnJOiUKRYPjTd9vX8yfBCaFAP+X4emqGkEoLGSUh43pbK6ulaMD81v?=
 =?us-ascii?Q?nVf9O9K2XHKfqwUPK9JtVqbGN0ZyJqo+vAnnq3+s1JO1DnT8MqR9HEi1g3gy?=
 =?us-ascii?Q?eGFciUlB7fLUt9/fumQxgRRfXZQL3lXfl7F+rMFKN1beN8HUjf+PISpYjvwf?=
 =?us-ascii?Q?XhyyOwTGoohMhCr2+jFL06k+ju4Np9OKx0a9MY6HpEdWJIZi3qC+gCr/JG71?=
 =?us-ascii?Q?a2n7NS+XFNVD0dH4ROPrUEuv7M+5GhJzl9lpHHDOWwMO6tJAw9fcyiJt1DJj?=
 =?us-ascii?Q?NvZ8A4z1NrOblnazHwQmPSzSk4JQml0rKk7beLwz1XVlVPpwv/ypOjNxi/e3?=
 =?us-ascii?Q?EQ3EXGnNlwOVoMagg8l6/4DQP1UDQuvMZmzuj25+bfTJ+38VTCNMomfUdZCm?=
 =?us-ascii?Q?aRvEKH7adhkaA278NKoZ2DSb478f2+CEeeQb02ToQafVDSzZqKSO+21m4309?=
 =?us-ascii?Q?PicTajtSGO9FTjmxdXcZoRMKNQnrs64T4DPcGKLNdrVhkePdaJac+hF9phvJ?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 806c6ae7-142d-462d-f1df-08db6794ed5c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 20:22:34.0167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZuJGawplJTINIFBhQeaI3ieb6q7nEoV8Z6lFZV6MKn9YWCAWlGyWc5fuoMnk7k3avscYAiEEH3yfxS9lb3V1v3hu5XJEwq73IHuUXAoXhqU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6801
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:38:10AM -0700, Jakub Kicinski wrote:
> On Wed, 7 Jun 2023 12:29:36 +0200 Piotr Gardocki wrote:
> > I need a piece of advice though:
> > 1) Should I fix it in this patch set, or treat it as a separate thread?
> 
> Separate is probably better, you can post such a change directly 
> to netdev, without going via the Intel tree.

That's what we like:D

> 
> > 2) I suppose the change is required only in dev_set_mac_address function, but
> > am I right assuming we should do it before call to dev_pre_changeaddr_notify
> > and return from function early? What about call to add_device_randomness?
> 
> I'd add the check right after the netif_device_present() check and not
> worry about notifier or randomness. The address isn't changing so
> nothing to notify about and no real randomness to be gained.

I find this as positive side effect - why would i want to notify anyone
that my addr has changed if it was not in fact changed? This is happening
in the current approach where you exit with success code from
ndo_set_mac_address().

