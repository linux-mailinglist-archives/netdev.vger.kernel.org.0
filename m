Return-Path: <netdev+bounces-8174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35F7722F9A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C296281409
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921372413C;
	Mon,  5 Jun 2023 19:18:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845A9DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:18:43 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC98170A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685992693; x=1717528693;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A3bIyBFC6QJeMbxusZ+E/fEzCeIAJph9hezqtqU2hKk=;
  b=lu6Ly2ElTrX3yE0h3TQfJ+ZWRW+SkLMgyPOuAmqB9ZBVbcZaM6bm1vzS
   UuoTaPRPTCExYT/L+P04OtHjDvPwLtNlHtmQDNuFJAI9Ybk+QhSt0b02B
   Uq9oAEfMyHG8OZACTKjHigMmCTe/pUtnSC0FIgFafw/QaaOdzztS193Qu
   ATmOP+ELbSr7idJGlhMZio9ICFriM3eImUpqCAYGG5bsskjX0tzL/XAU4
   c2XPXob0o4nrp+QL/xBh4hhhUi+26ZykQKnqegyb292MhjmNbVXOyMqJ5
   xRoePpzjEDsDaX+b2J7/KkOAz/5O0AZ1yK+cfym9XbS6xVgVP+PBLMvSC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422284512"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="422284512"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:17:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="711919666"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="711919666"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jun 2023 12:17:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:17:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:17:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 12:17:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 12:17:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3k7MP5DVK9thFrTqGiHslzKcuWGAGqPDWOS1VD4eUt6tvVHAv4bZ+SkYnAOT3xeO3gUtpe32KQT7fMKdjypHiyUmeboHg5b8ZGMjvDTPyJ1DmI43GbCSOnFekcncmdZCKLonXb2pTX8XIm0Rfd0JAc1MHEQTaRwu9KNHFG2RZEUkMq8ulT/ozq1WJyFlFJLTiF5OqqIPfiPT4YFQTHZ1EGhC+HZIlx06yQEQ2zA0u3QT4ROENZg0PzG/qQ2D7JwnG5LDujKFs+xvw7O/wVjcJrCmtiN7FI1EJEt7FuNr30+2dMLdNU2AeQQy81TJGnII6gKVfBkH9C1PYUzUYkpMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+HXb2RqQ2o6hJKjryV34BVNAIIgc07+iIjRjn7CA0Q=;
 b=iuDE4bxSJaCfQYTCpZ55qDPVklgrixXR9mE0+ZRpnYc1RWAjDFyoALVJ6LfQwYTOyzqL8dQgXqaVQQtDdYeXhQDEo/zzaA5aUkISFfNDuO26NMrvhiUEl2KUISpKAoHUg7i/ORtbpVA6ozvYAB1MClrc67+g11CW0Y2ne3NHd+qZZU72A8NHHMwW0n84lfT5VQz4SA6AObAC3U0QzKNeBLmpipeUaZ90Pvx1PQfgZGF0LfldQb+WKZ3vNangjLDqpMBEn9svkVYeA7oCUE/gDi49T9db6LJa8qRGdUhHg0Vqfpo8AEzi+lW/t/06mr9e0lbcWdUELtDHgpTXTdKvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:17:39 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 19:17:39 +0000
Date: Mon, 5 Jun 2023 21:17:28 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>, Piotr Gardocki <piotrx.gardocki@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Message-ID: <ZH40yOEyy4DLkOYt@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-3-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR2P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN2PR11MB4760:EE_
X-MS-Office365-Filtering-Correlation-Id: 5789d557-a25c-4206-d0e6-08db65f986f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFFiuEhzT+5H4+PyB2B2lbIEvxQ2rcZ+cd9BsLbMKiP92dTT+vB8czKzkv04K3x8206LjuqGjQciYi/01M7KQ4JZNvXqcq2jVHD/l+kcEtkxH5sTiVc70u4b82bRtdezJL6DwqXMshbQzM4c21e4OijulPpcxoyy50exkC5yogQ1+GHlBuhzKK5ve+IZSvvtN7svFMlaPadWWtx/JmjEDyKmSFUHOH+UZRchqTVVBemrBnSAMs8Zzjr7m8AYDKNVC648kMV8xymglkBPQSIauQG0jOa2LRSz39yLmXeeizm15MJDtKihABtBz3Z2JBnZJpfZbiXPREnBpfSDxTRAIJjiZoGq+X3eo6xER+OInIIoAx7ESPd0piUtc+XagBlpEztatMwgVLPKUS7E6ULefo6jvcehZVjlKAwHvkB3Cb6fUV9gPFkKASDL/3b/pSErkMzl/CQ+wACSZ+mBnfdcNmFjf7n9Ha+8ftHCS9IN95KaaK9mL5TkQ1TtA+JyzLs+9hZ4yQQu7DKr5oguqVUV89NEEIok9T6He2oWMTcPuKbmFvjA0o5gsaiHtS6Y5HI9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(83380400001)(82960400001)(54906003)(6636002)(4326008)(66556008)(66946007)(66476007)(38100700002)(6666004)(6486002)(478600001)(186003)(2906002)(33716001)(6862004)(8936002)(8676002)(41300700001)(316002)(5660300002)(86362001)(44832011)(26005)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?531f4RDZJZMJXpRHkVT4Z4j4u1t5Ly5qBR/i3D0eLZdcIpP6Oc9ry3ewq9sK?=
 =?us-ascii?Q?nH0xv6To0UkgfBe+A8t3fY3k5hOv8j/On/uMO5jvZNgXUafdmXRa2Hg4f1up?=
 =?us-ascii?Q?KoSVCWKvaUjWSmnImZqMuM/GO5uci92h2SdBEfrXKbOt+5msBQCgg70qqk/Z?=
 =?us-ascii?Q?Ccy0J7dPILquRrNmL41nFP8mDto1nRvx0Ano6meODHQv84Sl4Z1RKYhIpsUP?=
 =?us-ascii?Q?UDLsNRI/5VR9Xu8dMZwFHFDxig72MOLU+Po0XIV4GRdiik8QOAID1ulzsXr7?=
 =?us-ascii?Q?tV8OMWMS2gns7naRVJYnx3fnUIjjVsMvwAd0FhxxcUhJ9/EbACplGx1b6URw?=
 =?us-ascii?Q?/R2TuM6AEfN0s6QPkZ95Sp00ume2mtzXkleSZ9knNK1MxmCCD6J9MGnfhg9+?=
 =?us-ascii?Q?djjv9RiEl1EJUmrnk3EELcZEuF/rbOKcuVAI7DNSG/nOpJSQUPRI+Go9qinL?=
 =?us-ascii?Q?u53uHyr0SCzESanTXnZCT01nU9zXPEPoxfGZPy4s1bKI+4WM5bPDq9JtJlBI?=
 =?us-ascii?Q?e8AXmq6dpCu2YHLZ2KuXRthjGi0L7ujW+YJgzE7ZPnHgEk3AAN+Swcdb0Nmj?=
 =?us-ascii?Q?jLLTL05tjCzF0jFVokjovMnGmRk+MzjvmiFyVv1SjRVfIFlFMWvMh2W5vr/S?=
 =?us-ascii?Q?5WrpCOYofvJJYmXlbhYPZSPR8LHqmXas3zHjvIYHIKu4E/SFfN4AhHv6LC/C?=
 =?us-ascii?Q?rF5yF+iu1JfKhiLDtNK+8oBUUkIomDD15uLy8MUmABk+RFFRyiuPZI4ImvwM?=
 =?us-ascii?Q?d5g5skZ9EhkiRG7B8m4A4Lj1R8k1EY7XtNGEYfBFTeW5q2TuZ34PRvNg3IjM?=
 =?us-ascii?Q?v6zXBqeVC2NdIFqtg5Cz5X5sp6oYKsS/vadqcp7aizVoWWfd2p8+ARnFK1mw?=
 =?us-ascii?Q?w7jrUZWSyiwlZYBKsFU1HToTvoC6hq5UcK1QWiLosneX41makmpoKOqRpgMR?=
 =?us-ascii?Q?AHvTQ1xqF1EdnlPvmcd0nMTUVJSAP0fbulRs6nD5zTC0kne70NyNiGtB9dER?=
 =?us-ascii?Q?gagCX/s+PvjcRR6nN4qIuTFe+4gMq6H7Ejo7PeeSdJBAvhBPpzyMc6FQLcg9?=
 =?us-ascii?Q?ih5Mk/dmMUuUeqanhXASrT4C1sIPr0nKBv0HhoJEZ3FHGCqA9OXhFtfuo8Sy?=
 =?us-ascii?Q?hdvjmkEDebEJ0ioB93ODfp2OL/km1m36MhCQhuOiTBYcnPcJjjpx7sDwfdaJ?=
 =?us-ascii?Q?WDsU73KJpX1OlVXFjmC6w8mA0WwtWhj/IFcBqlvxeXa8OBbVSgkdOr4UEBJ8?=
 =?us-ascii?Q?rR8sd6IAzxgVPkVmJahRet3De3zERue/J77+Gu6qyEwtALYhYStkuUbUV8NP?=
 =?us-ascii?Q?T9LLFe6t6U+sA626XYHjlDBc7g9tXoJq1GK4RK5nRa95DV5yHYendNu9k64y?=
 =?us-ascii?Q?I+WKb3I+3h5arsRfOwCZCLF/1nMBVB6bWIUoON+iRfp7ozEqq5ByL3VVDYEL?=
 =?us-ascii?Q?rNFK2O9L5dnb6gUO6a8OjXhWUJlwWjp5VrrNMMZDW2WFua8o5uKRdc8ebqJ5?=
 =?us-ascii?Q?9CR9i1f+wyIRTY+G6bqaS1pKxHxVHaQZtNlUGtvSnK60mABE63YXeN1+ZWbB?=
 =?us-ascii?Q?pDRYc34c8OS+jWgnHcut/j+bEMFLhZO7B6Q5JzHwFc+56M9SsDStffBP6RGL?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5789d557-a25c-4206-d0e6-08db65f986f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:17:38.9708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wp0I1BlRqNz4OPfDftmqUiNWZLog+MqB6A9tk3wcYo9iikOcSlJzMq1P18dVr/huV/HHUh/PTueTcF6LsYQ7jvgXlaCOnIAeadBMzBq8rKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> Defer removal of current primary MAC until a replacement is successfully added.
> Previous implementation would left filter list with no primary MAC.

and this opens up for what kind of issues? do you mean that
iavf_add_filter() could break and existing primary filter has been marked
for removal?

> This was found while reading the code.
> 
> The patch takes advantage of the fact that there can only be a single primary
> MAC filter at any time.
> 
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 42 ++++++++++-----------
>  1 file changed, 19 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 420aaca548a0..3a78f86ba4f9 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1010,40 +1010,36 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,

from what i'm looking at, iavf_replace_primary_mac() could be scoped only
to iavf_main.c and become static func.

>  			     const u8 *new_mac)
>  {
>  	struct iavf_hw *hw = &adapter->hw;
> -	struct iavf_mac_filter *f;
> +	struct iavf_mac_filter *new_f;
> +	struct iavf_mac_filter *old_f;
>  
>  	spin_lock_bh(&adapter->mac_vlan_list_lock);
>  
> -	list_for_each_entry(f, &adapter->mac_filter_list, list) {
> -		f->is_primary = false;
> +	new_f = iavf_add_filter(adapter, new_mac);
> +	if (!new_f) {
> +		spin_unlock_bh(&adapter->mac_vlan_list_lock);
> +		return -ENOMEM;
>  	}
>  
> -	f = iavf_find_filter(adapter, hw->mac.addr);
> -	if (f) {
> -		f->remove = true;
> +	old_f = iavf_find_filter(adapter, hw->mac.addr);
> +	if (old_f) {
> +		old_f->is_primary = false;
> +		old_f->remove = true;
>  		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
>  	}
> -
> -	f = iavf_add_filter(adapter, new_mac);
> -
> -	if (f) {
> -		/* Always send the request to add if changing primary MAC
> -		 * even if filter is already present on the list
> -		 */
> -		f->is_primary = true;
> -		f->add = true;
> -		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
> -		ether_addr_copy(hw->mac.addr, new_mac);
> -	}
> +	/* Always send the request to add if changing primary MAC,
> +	 * even if filter is already present on the list
> +	 */
> +	new_f->is_primary = true;
> +	new_f->add = true;
> +	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
> +	ether_addr_copy(hw->mac.addr, new_mac);
>  
>  	spin_unlock_bh(&adapter->mac_vlan_list_lock);
>  
>  	/* schedule the watchdog task to immediately process the request */
> -	if (f) {
> -		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
> -		return 0;
> -	}
> -	return -ENOMEM;
> +	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.38.1
> 
> 

