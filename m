Return-Path: <netdev+bounces-8569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E7DD72499D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E53801C20AEF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466C91ED32;
	Tue,  6 Jun 2023 16:57:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE9419915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:57:36 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E0AE6B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686070653; x=1717606653;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y32aCitovG+dh1NeZ9bJsD2I5rY1P5XZqFPQI6LiLP4=;
  b=ena8+8M5gARRgULHR1qmhj5gJs+fzxQxrSlpitSWHqITAYs4Apoup4rs
   uFFKa2cYVMG4wawNFd9/CcNt8NkNuSgHbZZeqxqwFn5ldXP5A+R81rxii
   NypJFU+VvwKyFgnAx/EuasDfUm8d9K2vGsKArXUet2wLK6jpBekGTEa2G
   /CtPzp58uBQlyHzoYvm0G9gG9IUK1MBWDpn/9znal5nNRr7niwdafHoG2
   V7lXGlIykHN4JGAayKZxdwIbtEfyoGJVfiQkCYGHsiPiQQ2QZlVQixvJ+
   +AGoV0+OnjLgyRcrLoYZZ9HDg0e7vQe3dR3IOAPDyMfeyqzff74xYt28N
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="355592745"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355592745"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 09:57:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686612889"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="686612889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2023 09:57:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 09:57:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 09:57:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 09:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4CcGfcAOJxhAn7qIgTXcGj+HSLXceT7JzN7X9u7ZV1wqlMPHKJuPARvPPtBFyKCCwowqlaEgJeeU6Q/ZJ7/+yZJ3riTQm78RTEQUntVozDqnBR8TrpZ4Zayo/t6BZ/ap5K+oMCxV6DtDK4l4gZJNetrjI+XXfYK8y2sEmwAi/jvW12ZtBmbIhi2HSBqGMPZqsZLCGF2kWV4NL3V28oWs3mTeDw0My1r34fWZep6JDNacchY3KgYPsM02HpCsCoR5MYu5/SFRtWinYkmAxKnheFA3NDp6Nn24TQZJ4fcEHL3Ke3c84VpvDub0eMB/sy5nVocFUKtVgcenijr24KjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rewBhHfgCRiY4mLH+iD9hU62f6nIZ65sb5f+9zRddDI=;
 b=R2BaAO2JRLXNx+vmvnbOc1RJlTYck2SmtGhXQ1Q2GR/kHhs6tz2xcuNaA6xQA5lHgGC2tRF7+kjWOtbYVQ8kRpCK/mCI4MrQqYPwC/fSZCreAS/lbjZw8R+0d/zaVWYb45z3UPDhdf3bjJAckCjaJWv+KgknP14RGYm8p96Q2UE/hwX1NjyHhY40lResACNpy7ZzbAggi/SZI9+aLghnAoyKhEsdONl0xnNTjRs6ZCO5H/odar7TZa3d5mD8TeAj/g31Z5TTonRD2AGa/1k7dhl30iRdt4sDtUZUIY/zstLlsA17/FomfYvHM5lpJYkHuttQnMFL0u6/lKekRaK9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB7952.namprd11.prod.outlook.com (2603:10b6:8:eb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 16:57:28 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Tue, 6 Jun 2023
 16:57:28 +0000
Date: Tue, 6 Jun 2023 18:57:21 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <horms@kernel.org>
CC: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Jiawen
 Wu" <jiawenwu@trustnetic.com>, Mengyuan Lou <mengyuanlou@net-swift.com>, "Dan
 Carpenter" <dan.carpenter@linaro.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: txgbe: Avoid passing uninitialised
 parameter to pci_wake_from_d3()
Message-ID: <ZH9lcWlEdVSd42yh@boxer>
References: <20230605-txgbe-wake-v2-1-82e1f0441c72@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605-txgbe-wake-v2-1-82e1f0441c72@kernel.org>
X-ClientProxiedBy: FR2P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB7952:EE_
X-MS-Office365-Filtering-Correlation-Id: f9cc9b14-ecd3-48b4-a75c-08db66af1b88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skJTPV2xlmbM1MvkjEkkahgGciwegx4ImsjBuVbaNJsFgvXxaB/ya5jU8ztcEbomr/hz6dql2iEjFzHJiwWh+iLcYZt7JHsbeyOKEqwNyUIwkrX5RQEdjtGpjtz6QX5f43WqGm7QPoF7E1Fyw86PBGJI7nYJp83pwQmtrvavapYGmSAnOkc5UKCBoKtW4IbRqJcqeoXS1SZ49afn0LgqNrAkBJO2dwGajK7vQ3JFpNq2dYjjS+rbQC+ol8NWwphWhbGUErKxDPoWGsIKA/mat8VOFlcpaPRtxxSoQkrRQr9JA6P5QZsdK1VR/Q9kR6TdJqayisMAiy/6Z0SeY+i5zqMgkJASqVM4UdZNKdHNKGejgWr/hmGY4LCbEOwaNlbtLsyUIJvVz+WbLLVpDUxzziVwY+j3OJip4Tz8+Matp7kk+KOa3D5BWOHjLNq8XJKDzBAX+ROfCiT3nYETYxliYpKAwdCvnfICfkcQnYEzj5ViLu4J8LTWIoUXtctaFkkhZTFy5nijXDq2O+srOZAE9+J/NV+qlo58LwgPazRUGkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199021)(41300700001)(316002)(54906003)(44832011)(33716001)(82960400001)(5660300002)(2906002)(6916009)(66946007)(4326008)(66476007)(66556008)(8936002)(8676002)(478600001)(6666004)(6486002)(966005)(86362001)(186003)(38100700002)(26005)(9686003)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZmHv0gerdUPPi7cPQRYNzu4SI79WTOqngOziqFXRFI/IokL6qyAAA+C6zjXa?=
 =?us-ascii?Q?ysqTV9w5Mw25nT6ePA7UnzzEuw0/5OnhlXOsN7g9MTET6uC7JFDDHM7msHID?=
 =?us-ascii?Q?+FSNX9Sfr6QC1wQBo7NMnRUGVusOZANEns/9EEAU36TunITSkcuH7PP8VJcb?=
 =?us-ascii?Q?hOfvN3851p1xkVWL4A/Lh1mDeoTqwlMRxzemqMfr0CcqZWC31GJJ+TZdz1lm?=
 =?us-ascii?Q?2rCvVjRsSoWQLYO3j1pHgdWgDol9vMnlne8wvPh0sp1vT+sMFWpaYqDGus4N?=
 =?us-ascii?Q?biCuoTap0pUUgyA31I9M5It82TQn4bdk354J/hJCQyi8f97CI/qfVJ0djvSK?=
 =?us-ascii?Q?5Z6qpHbievF/RCodS3TYmRFTM2NKHnFy1hQZ+lcXrbQeRMiwbN+Wo7hmiD1a?=
 =?us-ascii?Q?tz2Iwwd8jHgnx6yZpOLMWEQ1b8ZLaFipQ91J5QzbZIuR9KPGfT1ZaIxoanf0?=
 =?us-ascii?Q?a7XrQZvM5Cc6h7VWu5adl5V72HF3Dcy/gITcUgApW95HQgKa2CvjuYYoWyiU?=
 =?us-ascii?Q?pPJrVykP30ZBTgK3DYCyT9/4i0sSZRF3tU0MHvixlgT+QT3PUz7rIuf3VZ3P?=
 =?us-ascii?Q?Mqu3zWXV0QRDbqSnDRVLYSyVfjQWvomrsExAkT51aA7G+A7lJlPLrZBoNbXi?=
 =?us-ascii?Q?HAtoo2o8hk/X7wujWYqlDg1lOpBQ5jUCS/Dt/grBlMCWEBjIKFfo0kqVh3C5?=
 =?us-ascii?Q?wZOp3yaSL+k7ChqbxuQXwQU5Wtsjbiy6p7jUgapMppnzCN9kBTZ0h0oFxgur?=
 =?us-ascii?Q?oJuLjSy/L8ObtmLAF0lVJKcxYvey1iTDwEa63iz+s8b+GkJ047/+N2EfJb4h?=
 =?us-ascii?Q?C9RyjqZ/jeSEdXNpUEQ86HLsrE0eKt6H+4FgUT+Brzl4E6rl+qNqZhkoVFOo?=
 =?us-ascii?Q?yfqGLU654ngpc+O4P/eSaiNRa7oyoIS5UuR/G4Zm4xewECunei4YPm1B/bkS?=
 =?us-ascii?Q?m/2MoJa0MURPBCXI9al2BCzyn2NcUYrWK1wedpPmteNnNCrYY/R4NlYEgb1r?=
 =?us-ascii?Q?ZrUA5muEpto/NXMNacbUNCjhkQufzkDO6/rq38iiQ/MuqWyGMsk5aTzEOvrk?=
 =?us-ascii?Q?eQLeqGSRFKCZGiwoiPhFHH6O5Vlzganyk+rJzNvf9LS2b8grjLhDOOU6oTGq?=
 =?us-ascii?Q?kMnpIDVmYF1kr71ZFgnxd+pUsn96w9eXahYTQAAUEc4DyOEBDQj5dZDUpqCs?=
 =?us-ascii?Q?+nNlBO4dzYN8fPS0dMjrTAPZC8iFRXYJuu7LrQtMPa5w3z/OedUl187hwaB/?=
 =?us-ascii?Q?UmHYpGWRMwoMSzO+lpHE4Ow3p8azc75r77ID2H7soLWoTzNnVe3n4clxUnUM?=
 =?us-ascii?Q?14pc1DbovnS8CnGG4OH7DxGUG0sazynyrkwwgyPppJd6BDa4ZUBOOL/zEYb4?=
 =?us-ascii?Q?P/IwqfUPZRKSgGa/s4LZU2hAw42YgBHHPaPZqVAqpsbZkBr0v9mZF+gCQHWD?=
 =?us-ascii?Q?b/AeMpwxrJxidghO/ArcTwm/sOJTt7HInKGzrHdDYUCifvBg+CI+673ys/PG?=
 =?us-ascii?Q?/0z1BchcQyHkGj/3xxPGzavTl4ck+Mr8Iwrn87KNd8UJbtdSrWH/abJRLAt0?=
 =?us-ascii?Q?/66WZsK1VdXJo/kk7F/uhPeg14MXvZIhAo+sjcis/2jQkfw2mcZRua8iwJoF?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cc9b14-ecd3-48b4-a75c-08db66af1b88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 16:57:27.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKd5r9S9GDw1zlBlvmzJ0WYOn2MmnUwbRAxNWYfs+htlWfwLo7oT0W+efDxxnciIUsvvcg2M+E0owWGoISTnqm/2ierO1ibtgJ4kTjcn7zU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7952
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 03:49:45PM +0200, Simon Horman wrote:
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
>   3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
> 
> Flagged by Smatch as:
> 
>   .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.
> 
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
> Changes in v2:
> - Correct referenced commit: it self referential in v1
> - Add added Reviewed-by tag from Jiawen Wu
> - Link to v1: https://lore.kernel.org/r/20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org
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

