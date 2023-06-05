Return-Path: <netdev+bounces-8153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B15722EA7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBBE21C20D13
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C82D23D44;
	Mon,  5 Jun 2023 18:22:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399AE2108D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:22:56 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAB49C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685989374; x=1717525374;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7M2sAipfNbLnpCnG6Rq2kTiCk1SZwOucMGeysZ+nKIg=;
  b=aYqACtlCKIpAWvj0oitrwd4ZR3/LIIY7URTzA5bUPftThOPkQQjY3kQh
   lCAZNnEA8lpg1xjKM67BqkS2QVN/+YAFEcONlnDEkDO2uQ8Bb8YUlOf/Q
   P2Nl56RqUX9RDD0vvseU/T5BSYueeLS0bLOxO5ErXmwA569m+R2/IDV7l
   7i6jtFcZwZVATbsAq02k/CKigMJMChREHoPP2Yg7V2vVbR/Xhbj1lc3Gq
   3E0Kw9395kFrAWH1F4okRfxDAyUgPoFN53GbcB/0jZphs28fSBW2yc/5v
   pFFlfFNWVoyWam9thixM1CRCLff1xWyfKuzA/sEUZtWZySJ2ZZFTGMN2A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336065746"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336065746"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:22:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="741824942"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="741824942"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 05 Jun 2023 11:22:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 11:22:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 11:22:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 11:22:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrnTMi1N6f7E7TpJRVdWHa5VxAvoIA17r6TJ2Itip8sQHpGCr6LKrXpkLHg7IuxywLe/bYWba1Pj5zc2ugaEO4O/NotQYB/3YGIKCxDV96akqzhB5ICcEYNAgD6Wzqf0784Az54Gx/cd/ep3MRsshGZpyhCjQeZ6sp2dNWjO3xOmtDoE22W9+5BKjLg5szRy+nCiHkeaUNBJvJbs4zvV1gaKuGoZ6lVMhPhwledczSYaGZJx2UMsvhE/mk950tFUJYb8XLGyllE8mc+MdMFXFWJcAWXqxNISR7YvolOpwnxV4CXGV4FduoMMtntQ9vYhm+oRAy34aPzI0/yGKSGAsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rSRUHwDbysBwhnobZ3QwU2HByGr1MOLPsA2sEfgSu0=;
 b=W9WwbA+A6ZXUzvF6x7mOC58IslsV+h4H2YBDg7bLy1xV/I2aWNMSkhWxPO3Ljh7SuBnf2t9lqo+MFiUwVT6HLjBQeShzS12k9YEejYYKFC5PiLBJxuXFfhWlopZZJ4wVk4qT3DaEa78RsTDOC0LoNt+ssIGN4xODN+CEwRUUUyTeCNhxyJDa/5yzs2O/5frUnGlZC6lWC4UWLL7FOf3pv3kMneka1OPM5A3H6Px5jjnO1AGMw9QqifiZWohBXcnIPdUxMqDB4qBeCKngsS5w/YW702+OnLQ95A34fgYwBUWT5YqiCwVG2XRRaI8HNB6dmUOnrBp2GpqRmh5jwoCXNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW5PR11MB5762.namprd11.prod.outlook.com (2603:10b6:303:196::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 18:22:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 18:22:51 +0000
Date: Mon, 5 Jun 2023 20:22:38 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <horms@kernel.org>
CC: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Jiawen
 Wu" <jiawenwu@trustnetic.com>, Mengyuan Lou <mengyuanlou@net-swift.com>, "Dan
 Carpenter" <dan.carpenter@linaro.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
Message-ID: <ZH4n7vOXVh9KGExD@boxer>
References: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
X-ClientProxiedBy: FR0P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW5PR11MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d2364a-f0b5-4b1a-8591-08db65f1df57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnFapRABqeULTjXeE72Rd9B8ASKn7v9pxHI0aNTAC5TtVCgKa6HCcgcEbRkrUZajG2oMsZ1d/8rBvK4G3Y5fJjwVvqTe2hEOvpR2N1/e8rauA+6eFpXs4RuEkEpy/VRGxpmB8Ur0/aQdTKNSSR7prtK96oPw5CTB5Y3bFEpH4WaoH37U4HzL/D45Aa1h5/uuGiuzqSQQvN9c8sw7x5F88b5Jih3GJ/qMtmp8NN8mDsMoimnszTcvyxDPHv5WVsWwT3fOJy014kW4Z35oTvbu617zSzPLfYVun2rN0Zbc6VHb4J7yevHyOWneIfqAAs0aQZlgkDTlkHfDFB9k90h3uEYSkuowaf8n8b/akH8/2Jua/KoIOEDD2v/98NU9Qh/OPP6PGukGfRu1kRgrRUCEG4xPMnAeP8PnIYxMOwUtnfOgWGrg/trfu4tQ35eOi7FDakRfu0+YqC/glnglD916LgfyO9dGMwc+qJhW1VkzRilSTlmELOChrgMRFGzSwAABHK7ipSzjvSTUtCdz3evvUq9bHZQeUr6lYQq+UJxxz92G8YXMWgnTz0NNkuF9GWMK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199021)(66476007)(66946007)(2906002)(478600001)(316002)(6916009)(4326008)(8936002)(8676002)(41300700001)(54906003)(44832011)(66556008)(6666004)(5660300002)(6486002)(6512007)(6506007)(26005)(9686003)(38100700002)(82960400001)(33716001)(186003)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CpYiRZCiZr9B48XWlSmVCo5lgmwxaeXWIG+Ko4SSqfW0GmtdYyZZePu/itu/?=
 =?us-ascii?Q?HnV3YMKpiomtWutWz9efg+QlkljTHym7/JlIqI9xjzevS/U4kqXwYFPY7NxK?=
 =?us-ascii?Q?1MwkIgTvpgmXsBV0e317+GBmWPw0buNGuWEU/qLjf0nJ5P/Qb66+LVBkb6i5?=
 =?us-ascii?Q?TupmcRLf6TipRT0GU5GmwbTcx+NcHOP064Qh/Rq92rfh33HZc8x8/zWRmrci?=
 =?us-ascii?Q?2/cPN4RDXrDv9Fx/jkA2IqbLbJOkAgSBzp+OfYiwGfUysv8HpSzP7dnt29qC?=
 =?us-ascii?Q?OQ4Cd9VmOu3lZxLI2DMfI9lq4aAIH2gRwsFAaFsunqqnt/h+acmucUe8GCfM?=
 =?us-ascii?Q?XlDmTBS/3W7ZcvVQxf0TIDeZz7jnVs03kd1of9J28qsY3WADl/fEuTXmyRGc?=
 =?us-ascii?Q?/JHfMEGTOJTKALIkTquotDLl5sPh4oRMGkTZsDBPs/sTjlVRynFacI+ThqIz?=
 =?us-ascii?Q?X+3QXyypJyjRJTngMIUnGxfHfG/V4pgVn+5vujGNiTnTOygJZ8BbeHEjt1lg?=
 =?us-ascii?Q?HtDHSF00KffyA2R4HTuUbaC3qvLMSt+uKOlOgz1ySY42vBPBIxn7TVfDc8ha?=
 =?us-ascii?Q?JUmRYC+6rCT/8QoVxPt/5auFQWmeg/40XABAB+t0Ot+27ww/uPTyrUFtEAUr?=
 =?us-ascii?Q?u/g1Io3cwOalC0bYy/zI/bY8Ooztu8BGrnsHcguj9VPSD4d9SL79kt9HaBqE?=
 =?us-ascii?Q?2LZNNgFprBg9uhlQS38drN6UzFcdRdbRSC+DFXfb7pMtwOrgYe7EpOnU6Te1?=
 =?us-ascii?Q?L0pSGkCH4WlE4x4tmohx//0wg6CimOqtW33RRx5wISlCwT9Icb4Mj0Q2c7El?=
 =?us-ascii?Q?XA0Cp46fsL40Fr3sx8hkl7q9SAH+GJkIm6st52C09NSKOSmkZoI4XH4Mv248?=
 =?us-ascii?Q?lTbw2GkHjdDB8Cl7SErrvmeT1j5qjleL7Qs3v4GgIC0WhcOJ8qS0AAEHrSEw?=
 =?us-ascii?Q?ZN5j9GIbUa5GB0vvRh7S7MhA7VMWvRjD9OMRzIAOowENqiY0nedkAfomIU4K?=
 =?us-ascii?Q?2ocF1njS7qaXFnLkasR/dAhBYl6qIdqWUtc8/hD4GI5kicdC7zxO+grtuiON?=
 =?us-ascii?Q?gJ4r84CPy2LmkuS5yXVL5iVIr6fglspE9BaEln2T50w1lWBAzQUoHVkfRbff?=
 =?us-ascii?Q?VyPf5Tv6PpBY1aUC/uPeFtlebYhfT/IEvAKbscXGJ04d8rP96B1JSAVLSX8e?=
 =?us-ascii?Q?tPj51C9IVpeheM38JjjWANJGzQ3jEJlhcUUwOaJORInBcRlouEWsBKN7Mruc?=
 =?us-ascii?Q?iJUd/1vDvuCgL2TRc5Aen90ZsqetyUfr6c5RbbFrKtPpNrqIlp6K4LJSDI4s?=
 =?us-ascii?Q?JKaxMbj232SGVKUNb91f+Pt9wYxSWXSRkKXpRtWC16J0c+ZSDr0kv1LngxZ+?=
 =?us-ascii?Q?JFarQne+JVYNlKAgv1KjV2nKhUcTPJW1KLWs3u4bSpwRTIjXa9dx5j+43Gs3?=
 =?us-ascii?Q?z9eXBN/MLIWujfZM3eFoNQP2nUhR2qKw6RP3dMUMnHme0aRomDjzOzbd1Yzm?=
 =?us-ascii?Q?B862fX4bNrt4yCkKoVlHUTt3wgF6TyfrhxOlx0DXTUBT7AKeqa5kjfg5fV/u?=
 =?us-ascii?Q?ljZhN6MxLw9DfXVSjPpAke1uK4zfic6Jijk86SUn9TWaySIHX2It6IUvfr7u?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d2364a-f0b5-4b1a-8591-08db65f1df57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 18:22:51.3176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mROJGdfoAUxemrUvbZT5zMR+h5PGzQftVRR3aHYeh10LNwT0bOrMVhNC5RLY/16lrvx/PMA3+7byp1HcJs8iVMTjE+dKOsa2RD2C6H3MXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5762
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:20:28PM +0200, Simon Horman wrote:

Hey Simon,

> txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
> wake by passing it by reference. However, txgbe_dev_shutdown()
> doesn't use this parameter at all.
> 
> wake is then passed uninitialised by txgbe_dev_shutdown()
> to pci_wake_from_d3().
> 
> Resolve this problem by:
> * Removing the unused parameter from txgbe_dev_shutdown()
> * Removing the uninitialised variable wake from txgbe_dev_shutdown()
> * Passing false to pci_wake_from_d3() - this assumes that
>   although uninitialised wake was in practice false (0).
> 
> I'm not sure that this counts as a bug, as I'm not sure that
> it manifests in any unwanted behaviour. But in any case, the issue
> was introduced by:
> 
>   bbd22f34b47c ("net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()")

wait, you are pointing to your own commit here?

this supposed to be:
3ce7547e5b71 net: txgbe: Add build support for txgbe

no?

> 
> Flagged by Smatch as:
> 
>   .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.
> 
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index 0f0d9fa1cde1..cfe47f3d2503 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -457,7 +457,7 @@ static int txgbe_close(struct net_device *netdev)
>  	return 0;
>  }
>  
> -static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
> +static void txgbe_dev_shutdown(struct pci_dev *pdev)
>  {
>  	struct wx *wx = pci_get_drvdata(pdev);
>  	struct net_device *netdev;
> @@ -477,12 +477,10 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
>  
>  static void txgbe_shutdown(struct pci_dev *pdev)
>  {
> -	bool wake;
> -
> -	txgbe_dev_shutdown(pdev, &wake);
> +	txgbe_dev_shutdown(pdev);
>  
>  	if (system_state == SYSTEM_POWER_OFF) {
> -		pci_wake_from_d3(pdev, wake);
> +		pci_wake_from_d3(pdev, false);
>  		pci_set_power_state(pdev, PCI_D3hot);
>  	}
>  }
> 
> 

