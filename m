Return-Path: <netdev+bounces-8169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C29D6722F1C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AACB1C20D61
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11FA23D62;
	Mon,  5 Jun 2023 19:03:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA7FDDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:03:27 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C522EF2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685991804; x=1717527804;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Mr807uXtDbWOqDLWewvOPD3ZoNi8h9K+Z6o63xyTMS0=;
  b=am3P1PNYbFSh0pudk7CqyP+70Nz4IDWGtS4rYU28pExBRL4CrfX/9DOg
   OPiYOxjxV3MTwldAYNtHFKK5v73u9Bol8KIVJ2OfqIQushEhA0y0cntvp
   4PXNdSI9AfaVH5hrrCIMMhZLUkt0ntrfhvdohFXNzi0TqBLxUivd9hfu/
   z0UppXPwWvtK0Wewj50muSfnabBO+W3GuDCJXH1g9YZ49aOXkiM1e106z
   KjMSmjWrLCzmbBMCt/Jrv+JUJR0+urt2kexEmleNCBzX0ie6Uw+Bck0Sf
   DjgqFM3k+uk5+2Vj11qxxbjstLyIJ9xiKHc32JkliE/nHLe/97FWRiUw2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359767894"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359767894"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:03:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="738456910"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="738456910"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2023 12:03:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 12:03:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 12:03:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 12:03:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7opvedzxn0IelchSZLorK/UtDlGnDCV8LwUwyW2qRsmf3MHxSwRi4iu7jrDBgcWYW0l9YvcjempRvmP9DwBjgmytKukYXWoHN80LFffbxfPvyXrR/J8Z0qSiuNEUlwt6xjt0aiBFJgThGPrMiWekAzTsxrcBmDWCU6/8EXsYf7QHSvLtdWm0vN0ZmwFJMbaAlsfl2ijwdKZOSEuImSzfwk/3k4oCplvkHKvxpCfJ5pnTck9tANW9+YD5dFAdDJC4bJR5Wl5aYD1pIS8TxKUwB0Pqe7ES2RZt5Of6WVj444bqzzRb39zBs6ZJVxCOkXcWI9wB2ydDUYUio4W8pKn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDo/1UGun/M7n+Wa5CsfU9cGEFW9b7vYx+fqhF7LsLI=;
 b=UnruHQ7DA92w7FyTXjzZGWq8kLFfVKI5vDnTYJv4dI5qnLrrB47rtn6j1/bJRPjYW9ft9n1CFC0avDI+CCcfsuhxNell4Z2lOfz/JWDk1e/E5pwLOKYSEUoZCK1TohegQoVU9eI3eSU+gv5Qls09nGitVCrjQJ2hm4lQTSy+Ji4FTnSQjkVaiEhQjcI+WBC+Y7XMnW5mM3kiMkrRoh1/HC2M+wCCB/yntHWUQB/GRVJQ08XJLc8U1kcqDu4i8QWFi8VW49RdwHkxKqVcSrzIvZApv4Y1xzHPM/fKQT5LZOVw6/J5+mYqU+g9wyaIGECzASW1wemD+9cSDHZKf9bw9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB6575.namprd11.prod.outlook.com (2603:10b6:a03:477::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Mon, 5 Jun 2023 19:03:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 19:03:03 +0000
Date: Mon, 5 Jun 2023 21:02:52 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Piotr Gardocki
	<piotrx.gardocki@intel.com>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <ZH4xXCGWI31FB/pD@boxer>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-2-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: FR2P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB6575:EE_
X-MS-Office365-Filtering-Correlation-Id: 46af7b17-ee2c-4284-61e4-08db65f77d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGAmU4leblwanPbRK69xJLJqweww6EwK0BGxvIsQkHvZw1EpAdhOuCNguLvF9lpbhyVl99y64oyNXYjM03SL1oHv976hwdM42y7tJ/+De+hifjrcEgy4cnLfhW3x5bY1M5MJhIIX0v5dtiE2ZkW9F0k1sv1m5//w52xyhnu9VdG/FOq67+U9vXzOjbKaPuRFLzfyFqoeQi2j7Is6xNvhD9YEm/Tz9YDznqLzNk8bKT2+a038YkNEAMuNsj5YK45vUFivpfd5eQB+nTHTAho9JWYHPRXEzJ5+QKRGc/9HNOPFGslQAd44nAcSzdWQ7+BVaoiPPRToAc0HNjOwGqQY7u+Ein6iqLTHetK6qAgcsv4g8PDxKfKr/5fQ//4VWGp2hZW/jz+Ehp6TN+j+jVFpgLDnvH92MX7e9qEGuC+kwwbPUGkAlthdqBoHoVP+5mTpf5LqsJkTZnSIflgpYd2NjkRMvUnEUmr9XDKYVD7sTz6nUpN46/vnZudB8MgKANmCCHXuIM6o2sZy1h/FvD0XucHCDkbY/lKi6zIc77VFUXch0VIp7UtQMQEjYyCAOJ9+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(54906003)(478600001)(6862004)(8936002)(8676002)(5660300002)(44832011)(2906002)(33716001)(86362001)(66946007)(4326008)(6636002)(66476007)(66556008)(316002)(82960400001)(6506007)(38100700002)(41300700001)(9686003)(6512007)(26005)(186003)(83380400001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4eqcSgmfJ2d0T1j7KGjRtbUHysbPQkRcY93KgF63+lzpl2Ccfp/WXMY7NZL?=
 =?us-ascii?Q?dpNFvPRf1TYZYAanygb2f3njhzUUrjIIdGw50U9Ur9xwgCILe1N5iBd+nXJd?=
 =?us-ascii?Q?kJ0m27mklcuXNEdTHb/oG7xB+rW50ZW5r6vazPmZXL20BpjeQLiL0dZ18f7D?=
 =?us-ascii?Q?Tj4OBG8M+hD8Ud0KiH/JgY95cNbvl1mH5s3XpKlpbizpvtpqtckFwWC7P+R8?=
 =?us-ascii?Q?Nnc6MXTnuIs/3edYzT+/nBp9Oq5YN7suzpKbA9tAIo9wRXoFNE4CXD/FlIKR?=
 =?us-ascii?Q?7cAFUquBHjpTB3qwxHt2b+3iV/Ar4Y6y8bRHTQe0xMnm5+l/7a56/rapq9JR?=
 =?us-ascii?Q?ykcz+zkaro1nryHOomZGphhr7CLiPu/S/N5WNZOxUX7W2q01D4TEOtpb7aTa?=
 =?us-ascii?Q?w5gk8nvT69zcyRr79BdVx9T0oTD2a6ciF0RQ2a3rrq0YmMn2XrPMw0i91sut?=
 =?us-ascii?Q?Hd5M7PgbqgrSd3ZvHWZ/r9GyNcSWTQcuan2k7j59ien1YsvkXCBeP0kQ000S?=
 =?us-ascii?Q?y5Gzx7W6OviwbuP6g+OgwPkOtmX4K/2+/LmzTlhFhYdnGcu0oSFpYg+qL3SE?=
 =?us-ascii?Q?lYZPI9+dEl4dSmmtoUC4T2xpskwjNXy/Hi9R+L6vF1PKuDI144G8ukPYlkds?=
 =?us-ascii?Q?1b53zda8MMCDUaX9i+L7ftXDhtiOIci1E+A75roRRhfYCjIogaPevYdbz3h2?=
 =?us-ascii?Q?ucW/O/jEyG0pn4WSzuuqYMkTsraOYvyRVj7G9YoO0pF6Fcs+HhRJsITvIn2i?=
 =?us-ascii?Q?9d7sebG1e4pJAW0/Xr6ZfClqLLlUSj4r6kEZNfdpw8OK7x75b5U2hHg0KEuC?=
 =?us-ascii?Q?EH2sJp+f55sNOWcEOzXwIfHPuz8cJ14eyzWh9NdHEMGQwuMfUbJiQ3rBQYk8?=
 =?us-ascii?Q?o1WugasZyQ8r5vgj27KrWeAH3R0VTZlx02IL+chaYoqAQQLS23v5GGuWATEl?=
 =?us-ascii?Q?IDcg6KH3WlYSzeJtWLioSIGhJCHBAiX8uK9FgL0hrrmJ0PY7kEuD2Rzrs0AX?=
 =?us-ascii?Q?Tu6Al0KHrANwQj/M5HAzuqUuM2e1taN0kDCAL5LCxbjrE08tlR+vH1MCjPmd?=
 =?us-ascii?Q?Qc7Ofa9m+B0Klp+HMQCyyrz4N+86pDLNePoVwS3PWtafymPjLWpSgFZY8A61?=
 =?us-ascii?Q?S0Dr4U0KPWuYK0MMHlpPwUf8CAhTcdgkDJySVPO3wyXseLq8JSBQxUiCv3Py?=
 =?us-ascii?Q?0yq3KSwPTqNSSixA/tz2vICPHY38slDNDDrVy8snmrlmTpbaoubXMRttM4HF?=
 =?us-ascii?Q?543Ir86c4emiviVfIP0eBwx7iTXeL8plQqgJ9XJln8L6qALRsQTNNCORC1rc?=
 =?us-ascii?Q?E1xQpFxl+Bt6b4ESCqt8Z1CHrVW8WoAI4TJ7L1atydc4IjtvHiPuhQppxVGw?=
 =?us-ascii?Q?RAX9EnH3B+jR37wEqwsQ0mrkcRFN3ATvJ/IA1NUJ49Z5t6dVapBqqkCoz+t3?=
 =?us-ascii?Q?XqIvgLlIAKJPFOCPrW8TAkGrHsP7tSzf3G66f01y9eY+zZwh7I6a4N4LFatu?=
 =?us-ascii?Q?jhJFGG9OVcDUw9xXYonyOwBQSPBdGDNelv/NEgUGd5Zgm8m6PkZhBRoY+a1A?=
 =?us-ascii?Q?2r2GH131442kE4PoJES24/jTwFignKeLL2a8qS4iJtfjVdHiIfaSwY4+4b6A?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46af7b17-ee2c-4284-61e4-08db65f77d3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:03:03.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTBbR4rh5O9OThQjA8DOFsSf7lLyigQyMXJ/EERMNw/22d+kBm/11mWv9qOlw4be5552x3GVBsJqjS8X6xA8wePBfbw7/ab3vWzCzEnpaXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:00AM -0700, Tony Nguyen wrote:
> From: Piotr Gardocki <piotrx.gardocki@intel.com>
> 
> In some cases it is possible for kernel to come with request
> to change primary MAC address to the address that is actually
> already set on the given interface.
> 
> If the old and new MAC addresses are equal there is no need
> for going through entire routine, including AdminQ and
> waitqueue.
> 
> This patch adds proper check to return fast from the function
> in these cases. The same check can also be found in i40e and
> ice drivers.

couldn't this be checked the layer above then? and pulled out of drivers?

> 
> An example of such case is adding an interface to bonding
> channel in balance-alb mode:
> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> ip link set bond0 up
> ifenslave bond0 <eth>
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 2de4baff4c20..420aaca548a0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1088,6 +1088,12 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
>  	if (!is_valid_ether_addr(addr->sa_data))
>  		return -EADDRNOTAVAIL;
>  
> +	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
> +		netdev_dbg(netdev, "already using mac address %pM\n",
> +			   addr->sa_data);

i am not sure if this is helpful message, you end up with an address that
you requested, why would you care that it was already same us you wanted?

> +		return 0;
> +	}
> +
>  	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
>  
>  	if (ret)
> -- 
> 2.38.1
> 
> 

