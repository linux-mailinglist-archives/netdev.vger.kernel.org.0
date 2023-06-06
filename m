Return-Path: <netdev+bounces-8574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE1F7249B8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4614F280DF4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D58B1ED3C;
	Tue,  6 Jun 2023 17:04:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257C4174D4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:04:26 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4096E10C2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686071065; x=1717607065;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=uBP6JnZkNniyaPjp8XUOjGbSF97sf3plAlhtl4/M2UE=;
  b=BncA48TJT9rIheH7uY4IybdBA4BVgWBWEvV7E2vCAmr8bGMAqkrgNyo7
   9ycVI+lpX8hRxDIy+si8wYdemKd5N0rukcKBWMOfv4W3VFo6ohV9NhNwP
   4l15AmFgZyP73fKt8OZKBrsPbZTgXh7i14jZYU+kWgcuPDaLWvlTYHtp5
   RhuygbEcFrtOlvCBzWt7rHW3DQKQXMeB1P8fD2tqarXEcixkY23tfV0fs
   9tdb5BvuBAfXcJOPADzw6blT1J1nkXLvcTD06eLYRgCs46xOMNa5GbGgq
   OAPFFysnqb24/8ruBRe3OZD97KYVPDF/hPtlpwLp2ZXlT1se8Tu2YGK0D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385054069"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="385054069"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:03:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="798938882"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="798938882"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 10:03:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:03:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:03:41 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:03:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6qcsXc6407TO1393nRmL6Itjw284h8EdtDsIm4kY1Ha8ISNhmw3ZC3Me1uSVAly5d3CUCD/H3zVDhSNtL1Efgs9oZh/5EkyE69hdyyfRE2Y9nFbJOevJWX+TmoTClJ43pKPltABUU5fWNO6Lm6hKM609zZ+VAAHO9Hi3Oy2aTaN2lBM7HRHYe1ELz85mPFwAj1mTcC7uNlFk83AWDsvUuug2gIB3l40AZhp/Ol5XFFkwebEQChQpJTTvbEvkkS8KVUFHWrvkDpofx/7J1DxSzcakp5fKYUSZE62O+3RBlwSj86sEAubcBhy6IbxPCXdtZKiuOkkZu2YDfTsLdgXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP699NiAXAXByH+lp4FGB22NwYHadb6HAr+V+UsyRVs=;
 b=EjUcV6/UKgUqERczQy7Z4q8HbKXmhPbc8yh7Wdt5vtHa5nMJD/FaRCqsqpn4tsTkkVMKMl6F9E2gwh5pRD9li3dREZu73WUoe5icXcQCIce5LVO8BOUQVA36BHPtOnIN3Ivm9aUUT2XgOEIN3VQwsDCYfjOkjmRuk/PwIMTHDWrlnVTwMpBFmpYt56ZOhd7F5jvTDTVBLBYYeALA2UHlG3fLeSjfTNYHByZb2kYydNoLgH2ZNFItWW0I39PEJkTI+hzDI9OC0R8mOoO1TG4ABxjk7ZLbc4ZRAElAO1P+GG/i3mpM0W3AkkA4B7If5WSUShuUq0uG9ZcJ6H0zZeZP9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 17:03:37 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 17:03:37 +0000
Date: Tue, 6 Jun 2023 19:03:31 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
CC: Madalin Bucur <madalin.bucur@nxp.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Russell King
	<linux@armlinux.org.uk>, <netdev@vger.kernel.org>, <kernel@pengutronix.de>,
	Madalin Bucur <madalin.bucur@oss.nxp.com>, Michal Kubiak
	<michal.kubiak@intel.com>
Subject: Re: [PATCH net-next v2 1/8] net: dpaa: Improve error reporting
Message-ID: <ZH9m4wFPTWsXXBAD@boxer>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-2-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-2-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: FR0P281CA0231.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5525:EE_
X-MS-Office365-Filtering-Correlation-Id: 941eca08-e180-44ca-eac0-08db66aff858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNbM+/bF9/amy1y+x6dU0rD29Kx4VT5kM5FWTg58saZd+kYpb9kl3rBNhPG1rHFd+QEoVEiPxngU7WruLxcqB8UTEYHYIJVGusCxOq7zTpt7sLeUeMQ6Bk7Tp4DlQpZKEje0rPBoJ2s5pmVU9xVkf00I/cKA/4XipZRBCjDHoCSau64omQEzNWUwlkeOGsC71fk/kqoLkLEiCOdwsBDZOK2EizLEGsG35a85OxF0LWUf2vgKK59iQoCi+/DCSeZplnx/s6xV75jgSka4h5I4htTr4XjJ0EcNOxMnHgLg+CIl8KdcP0s3iDtro2PEmIVTtrHsRexB2yyf+3Y82NzpoOR749EDsmxhJkDCU5Pb/WDrBByjTQQAKBFMMvd/OVtB/vbsaY4vKQ9rC2NulKDU0HeRrRcf0xCaDj1bLCS6Ml0PAhFo40gyEX65u1xnXqx4V9QtkvQPna7dCvSi4qU70ebQbkzbnC30gIAVQZLlOi+nJ7AS/tR4hvmH96xBiyKJxbd6uRZ2mDvXfflZaY+d98p8L7rJxpQqzN9oKeZ0pB/crGhcRaN/g6bBYO39Rca8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(107886003)(33716001)(186003)(6506007)(9686003)(26005)(6512007)(83380400001)(66574015)(86362001)(7416002)(6486002)(6666004)(82960400001)(2906002)(8676002)(8936002)(44832011)(478600001)(38100700002)(6916009)(5660300002)(4326008)(54906003)(316002)(41300700001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?UhcD1BctX2icz4RuI3BjCq6G6QlQVupeIB7vJa9uB1cFF17T+8L/QbvMW/?=
 =?iso-8859-1?Q?neFAqJc5JHnpiYOt9iexw8MWWNQVyOFFe777I+shicgh7bfVXjWB/fB+Oh?=
 =?iso-8859-1?Q?44W+UqCt06b+XwCGEw6Yg8pE7KeHGwaQJCurF86L83uAD+VFYtGC+99XFv?=
 =?iso-8859-1?Q?asluBlFRoPuy3QOO1YxZAfe98P43eb9qcoA226B1FtgF7wG3fdrcCaIq/U?=
 =?iso-8859-1?Q?hWp6IWqzQ3ZIrKjgnnYtwEcLgYmaa6aO47E3O8tBRd/RXj3EK4knHWm1DL?=
 =?iso-8859-1?Q?tazaMkp96UAqPXvK69VC5CIOpPPIehFpe02YxuxwFOk4/RlUJbcj8piBBv?=
 =?iso-8859-1?Q?nRTr1ug8oWMTXekFdmzHnCLEAsnDJR+IZK6azRSJl8Kl1xweD2eK4jHfZf?=
 =?iso-8859-1?Q?3ai5+4QGfpmN6q9cj7E/iv0Cmo46sdGpBUzZebHnaf8dATawfTD6QTpIuN?=
 =?iso-8859-1?Q?t6nvMojdKTh9ngQkjom2HBGm7F70w8igQW6OufrGF/k3JHmX+IvLNrciVH?=
 =?iso-8859-1?Q?xkqZzdsqwaA6peyhwJxjJmZ7eNb75b8Mmb/F79yjgHJ5t5c2TzOBLRau3v?=
 =?iso-8859-1?Q?d0ITtdWk7nm58DfTNzBaKUKAAn245MPCtiW8WwNHeJ6VGDqFoLja6xb+lw?=
 =?iso-8859-1?Q?aBOKuV2D+ABjQQFxvXIaib/vSQX2VFS4UdaVo8FKglrnRDuj/+I1zG4T31?=
 =?iso-8859-1?Q?/AcAl6r/dIctxn4mFjMA9CHPGedvk1QKbFcxDlz+fjSf5jVCZJlZk2VCDQ?=
 =?iso-8859-1?Q?XHmjCbruaOFFs85DTk2k+RuR5sXHyEOqdUNwpKCQspBZ3Nw5DYM2R2vsY9?=
 =?iso-8859-1?Q?FcI/+VzCGFoTZz2XywbThaH4P1b2Qm5X39QGG0S/P34BfZx6/3HYP9NqpY?=
 =?iso-8859-1?Q?+vfHRY3171Kbn2395oDmXcDZWImpjCoCXX3smmRP/kHaSmn5dfsMuuZlcl?=
 =?iso-8859-1?Q?LPPZMpO7prbrsfIK+GhnS1/eNN0/zBe7fjIfE6yQzbPBUyxlZWFR3wXnnH?=
 =?iso-8859-1?Q?L3ZYz6mrRRbJzAX0QBYu+ZlHmUsgLq+eQ7g5M0Pogyq+O50cGjbFExekV1?=
 =?iso-8859-1?Q?JeHb0Fd5Qm/cbDmdY83Nd6MNe19KZ1xzPZG6QRH1YhTbuQ65ErSY7yce3L?=
 =?iso-8859-1?Q?So70DZyFjnIOmroL2MPI0STY09WB+R1oluoba5/rTNZuidWYHtjsgwwWfa?=
 =?iso-8859-1?Q?X4L2ypSz+MN5VfGW5n391EClWPRdOCApcplTlqDQUyKTMnyBI2+9d0m1xk?=
 =?iso-8859-1?Q?zys1h2EWSay7/gsB+nmu5O3V91RwskgfwFmiPigQ7ByYoHr3Mhcs6SkDPt?=
 =?iso-8859-1?Q?+/tWexZWxCM63GsZ4lTImwKpI5uRPjEWVn9pJHod2Aq6E7akhXvb2mCtOj?=
 =?iso-8859-1?Q?Hqp31kqhm8BrZ4HeUOz04kTsUTItpnzppnG2rI+UaMsVEVYKvfEOmxUBFm?=
 =?iso-8859-1?Q?2/Ptdq5P4uNkkK3W2cpyjmbhuuloZxGzXPxoEmZAAUEx19ZqQ57VEl7cWN?=
 =?iso-8859-1?Q?NgQZ+cxucJmvxMf7p5IFSX0rTaFV3fdHxciQjUFyVWQrcDcy6VZ5rbUz/i?=
 =?iso-8859-1?Q?JRUPGxMk8+cBiRXmfjp5ZojhETC3pAlsQ3yTPIkKoQiNpaS8wtTXgkN0Nr?=
 =?iso-8859-1?Q?AKwVQxsod5+e+VeoZFNDqhjLwaDP3SogrguC1Uw91GqFaZ5qmLVDWKFqmp?=
 =?iso-8859-1?Q?e38lpZlbh8bP5cRjpOA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 941eca08-e180-44ca-eac0-08db66aff858
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:03:37.6262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hsydl2IQMZ6ZfN0BCx7y+RLRlZHxrGJDNDxADLmCOsc7F90uYEN5yyAvUzAQx67A+IRouE+a3hUOwXkpQqKb63S0T9bb+zVNNm/bI0jE3o4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5525
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:22PM +0200, Uwe Kleine-König wrote:
> Instead of the generic error message emitted by the driver core when a
> remove callback returns an error code ("remove callback returned a
> non-zero value. This will be ignored."), emit a message describing the
> actual problem and return zero to suppress the generic message.
> 
> Note that apart from suppressing the generic error message there are no
> side effects by changing the return value to zero. This prepares
> changing the remove callback to return void.
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 431f8917dc39..6226c03cfca0 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -3516,6 +3516,8 @@ static int dpaa_remove(struct platform_device *pdev)
>  	phylink_destroy(priv->mac_dev->phylink);
>  
>  	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
> +	if (err)
> +		dev_err(dev, "Failed to free FQs on remove\n");

so 'err' is now redundant - if you don't have any value in printing this
out then you could remove this variable altogether.

>  
>  	qman_delete_cgr_safe(&priv->ingress_cgr);
>  	qman_release_cgrid(priv->ingress_cgr.cgrid);
> @@ -3528,7 +3530,7 @@ static int dpaa_remove(struct platform_device *pdev)
>  
>  	free_netdev(net_dev);
>  
> -	return err;
> +	return 0;
>  }
>  
>  static const struct platform_device_id dpaa_devtype[] = {
> -- 
> 2.39.2
> 
> 

