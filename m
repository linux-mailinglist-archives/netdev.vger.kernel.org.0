Return-Path: <netdev+bounces-9627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E52B72A0C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7751C20CED
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2361B914;
	Fri,  9 Jun 2023 17:00:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05010171B4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:00:38 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FACF3A8C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686330037; x=1717866037;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EqKAcJWA7uXrUont4PtUcwMYSKK4YVCZqIvsLiJCtO4=;
  b=Zhr/xOAc3DosV/Dh3ESqc23pXxh4fLyD0Kc/ZZAAkJPtXZmn4Y9Cxn56
   Bi+3oI8wF0Gmt37W7u07ZPRBKnPA+rRH0bjgA3hSqHM1Oc+NTgDrwMVIR
   sJt3dFYifqyTd+aUjpIGmnIEe4M6ObI61tBD4fCkjI+yGoPMSyJolJ+9L
   tyslLBDo5lzeV3JrKn+qp+oAai2t3Mzhlcqbqsb8QiH0cWrJmPBM++L2e
   u42LxKOme5InSsd3YvwRT9CJBOwVXvHOfnlR2qv0i6IAUxUgLHAvIF5lY
   KCaPZw28Y6lvdi8S9KOrjd4KygJB6HvQjzYEq/YwxIpWGU9xmCAdJfhLJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337279022"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337279022"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 10:00:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="834695852"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="834695852"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2023 10:00:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 10:00:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 10:00:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 10:00:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 10:00:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmQplQuqgr3RP/ujHsNSKPZY0yEpWYN2DCgt8SmRHF67R1MZJl9W4FzL+y+PuynrC/T0jtn+td4nfbcsBCnWwtiqa4Y2ogq48hmqcil2kiH5N1Nfmp1a28k+7WcB4yUnz8Vta7xhe9XDm9DtBQEt8fJoMaB2EaBl+7JCzQbHZ7thWSLVbBBqJX4/eybq8vm2wSsDMJC2G5zz5Q7o/jLivjurI9gdotwWrHmAT6DCkl7T2ZhnN+ZyoCVfWJOAvVdrGbgZyy5IF5DKkvGwTbxdl1WTn1jUHDp6nuvIImLyZu47N6WaIbnJlz8gI4RcDtcA/0iSl2852BGTUoxkwQmdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2t7TNVYPGxkeUfidgR4CPTOMATLSwPeRjnk9JIe2Lek=;
 b=Ir88+BAaIQ/B4ZgWhlxvM2aPVLqyXTAQ0bYuU8vQ7QSaPa5ry5NhIyeO4DS9zsYu0rJqZQAlmWz/aGDXWgPSIAkRX29RlJqY+Z0Ya6wMdnHG9mkDILwf4w65zoBzSez+e/3UHoNahk8jFsXGw1TNmTnKdAowMJ6Q///50M829KJ7SDO83bZW3WWRE7hzgnUdYrBVwF17PHiPJ46S/Q49bMKggX3uAjbHymYcBwgl0h0Qi9O8i3cPV+Y8TQafnXAg/dXaYJEOp4u76uXH8zhKSfmqxkwRyZgA4218gaAim9xx+qzRMBuxR4PfR0kcCVQpfYwR9gnFNLpZukV2a50X8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 17:00:26 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Fri, 9 Jun 2023
 17:00:26 +0000
Date: Fri, 9 Jun 2023 19:00:11 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: <netdev@vger.kernel.org>, <przemyslaw.kitszel@intel.com>,
	<michal.swiatkowski@linux.intel.com>, <pmenzel@molgen.mpg.de>,
	<kuba@kernel.org>, <anthony.l.nguyen@intel.com>, <simon.horman@corigine.com>,
	<aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Message-ID: <ZINam0Qlz47WFafH@boxer>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609165241.827338-1-piotrx.gardocki@intel.com>
X-ClientProxiedBy: LO4P123CA0266.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f81ea80-e21a-49bc-0214-08db690b0572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xi9nMEoPutrYhmhrTGRDQLa0KBUNbrC8AkHkUI2SvGXEPIxHbl0X1/rhOtufwl897xHmCpxOUZqSTgnIJHSEi/T88McvbREDlBEIjIFmUxmFAPa6N99VYQimYfnP/3UaPAo7Y7waTpCddVrDC34PAt+K5yuEN24Xsxx/Jzst/Dm0SaaFfTK42rwhluyFgT9OkJwD3Ww9+2mnweSHj9/SCCSg2n0h6HIa3toFVpTBAfCisiygqf3p4rjOdIuypmmE8QeEegpjhrPjfL4Qf60QTUVT26qf0ugRrcFhtWpbwv7F5hfEqqDnUFgt1/s7kP7NgYTMJzKsiCHrxTdGyXrc1VLwQUKXyiK/HbzNI2vRA9LqbseE1hXuJ79dflxkCJG3P0z1KEY2GYf81zpg8fIFwha+6R6VWKxkFjHoh9QKH2/C7FPlevuFo8iPJMRBuBOmTFI5IMuQTgnNkfLMIqDPhjWXV+u5XE6gSr0CkLRu/zCY5jN6Vs8+AzgaiQYxxVZfhaPrbBsvQyWNU8ZKZmXtAlUPJ2ctXnvAsunVDCn14A4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(6512007)(6506007)(26005)(9686003)(38100700002)(83380400001)(41300700001)(6666004)(6486002)(186003)(66476007)(478600001)(66556008)(316002)(4326008)(82960400001)(66946007)(8676002)(44832011)(5660300002)(6636002)(6862004)(86362001)(2906002)(33716001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wu7A9DKCv9lsnmdXpX9oY7gq0yXPCUr6zi/qF0v325gDwqWpLTHqIiCje00x?=
 =?us-ascii?Q?JoSiUpZ2EoFLUY3Mjwc5B1LuZLdBfPQQqMU/TRHyKXNHqZl6YZdWRc3KDE07?=
 =?us-ascii?Q?ImSQ8MKgixR6QjiuvLGlhnC5qKDk73I+T1Jd2WTVV7xTO0uioRX8Iq1XA8PC?=
 =?us-ascii?Q?mvS4BJfDE1QZyBUvCkEMMuR2QFaR4ghSxbbbtSh+InXPNRx7OmPhWC/qfwQj?=
 =?us-ascii?Q?kDBtFiTjtLmnTpPSTLZobeWSq2DDqoxBT8v8u/NGMZnuZSn/6WHy5Od3UqKh?=
 =?us-ascii?Q?MH4PXTc1dknqVL5yDKpEQtg7Fdqn+ICySRB7bwnoaEii3NaTXDImPNAKqArX?=
 =?us-ascii?Q?xgGBcTxuuFUT/D0epPTIwnjh0nosMVUhyIylu2E8++cd3ByqYY3PN3r0ykfO?=
 =?us-ascii?Q?qT4lYkUv0Dtw4umIXRumCNI92LsGQ+DhQlBteLWi1CTJLH587GWTWS/MDyit?=
 =?us-ascii?Q?YtRQSZ+cvj/wWAu7SLgdiF9P8X5QAj5GN+eec/CE4O4bu/7ThtrVdtDfCGEu?=
 =?us-ascii?Q?LSueQGtpZ+mxydrpHUmqqizpv+CNc8OyiM8SHBE2X9tlqY8VzTTAC58CvVAv?=
 =?us-ascii?Q?VqXQG1YyaKJtFQybZa+/+ap2Bzwg7Cu4FlD1hAzp36cSXJsRX9f6xQKzhPRB?=
 =?us-ascii?Q?Zm/yQRtYvDqggPHiqhV2fPFN8lyZs7M8/Jy0geWk5mQLlTo9IwBLQ+V8JMvc?=
 =?us-ascii?Q?RJe+gIK2Md+9CXs98Q0vHvutFaORHeICCWh93oUMZqVVdIw8cuaG5/Xjdnvy?=
 =?us-ascii?Q?BNj4twzwNVxUMMba7c9T+Pg+QmP/oC6jCs7TKb5jW8EOTNr9fvWp4s29dGJI?=
 =?us-ascii?Q?PaBHiFtz8+3X3iJuls4P+VdSHeN2gsno2o5+dY5lnrw3OAV4dzERIUesar7j?=
 =?us-ascii?Q?L4jHADX3Gm1DwkFn+NfZBUH+H/0/T0Ak6JeMvxvWfhrAMXUUjdAguCJmDh2x?=
 =?us-ascii?Q?BST2Ro9TuKvIry8a6lHRJdgx1Sjb+FT3srkze619jvh5KJ2xDAj++aZ91aRD?=
 =?us-ascii?Q?qB6vl7NgZqetdv5kyVNwhIfAT/2Tk+FvBctaGJsdqIu07tG0YZGy1D36GRs2?=
 =?us-ascii?Q?EFVsXvwYop7NlRfp0YC38a0UVStN5QRf/lDN6zU61xUOc7/ac9nRA+JiKA0H?=
 =?us-ascii?Q?CY+Rdqfv7WDqHhONa2KLVQpTROPfbo9llK0GK8unicbEnE0dkCrdZzXC4YcR?=
 =?us-ascii?Q?9aQo4IR8wEKiOS5lNgwV8kEl+ejneqvgRmufpiSzirpvucBFUAmYmTa4wb95?=
 =?us-ascii?Q?S+QykwepdxmiGKwlqnW/yOTebvxvqJdEp9grFG1bqSUD7Dq0Ai4TDpMP1EZi?=
 =?us-ascii?Q?tfehnTN3Wu/4u+Y35FmJl42um6i9Uvb0f9i1SNa/UMfe8toKLrEs2YNIWMjG?=
 =?us-ascii?Q?VgZq35D72K6IVJXVvipOnwfzzWEMzdKDxcYgxzY6Qia810gsg6d2DZdaIs5/?=
 =?us-ascii?Q?MgpZyVl+MNSYB2TSkJvD+/W4rRH1c9IossWtQlLG8gFQgdS5EvdH/kwxddnS?=
 =?us-ascii?Q?yMGzEpnWcT1kB3rHdYYd058aQEnoY1ejYvGSGeXDcfuS2L2ItRdK3zpfnyMh?=
 =?us-ascii?Q?ElyA/WIzwj6VTnl8DRfgoRR8D43uhUlAhsAjMecAkTA881g+AZs+PtqtVL3+?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f81ea80-e21a-49bc-0214-08db690b0572
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:00:26.2091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1p5TWKJWhhcrr8uIxtDXn02Ve3xygAchiYRaunUr0HJ9QyYVTPkz9P7cer8DpxAVytxixggXSeUIXnN+UuFmHt6W/yRfsEGKGVJ9TKifbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 06:52:41PM +0200, Piotr Gardocki wrote:

Hey Piotr,

> In some cases it is possible for kernel to come with request
> to change primary MAC address to the address that is already
> set on the given interface.
> 
> This patch adds proper check to return fast from the function
> in these cases.
> 
> An example of such case is adding an interface to bonding
> channel in balance-alb mode:
> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> ip link set bond0 up
> ifenslave bond0 <eth>
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 99d99b247bc9..c2c3ec61397b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8820,6 +8820,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>  		return -EINVAL;
>  	if (!netif_device_present(dev))
>  		return -ENODEV;
> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
> +		return 0;

Now this check being in makes calls to ether_addr_equal() within driver's
ndo callbacks redundant.

I would rather see this as patchset send directly to netdev where you have
this patch followed by addressing driver's callbacks.

Moar commitz == moar glory ;)

>  	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
>  	if (err)
>  		return err;
> -- 
> 2.34.1
> 

