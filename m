Return-Path: <netdev+bounces-8466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEA6724354
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 020A61C20DBD
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BA737B94;
	Tue,  6 Jun 2023 12:56:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EBE37B90
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:56:35 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7A1720
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686056175; x=1717592175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dudv/+q/u24xCBIX0cxG2F99kMbC8Ev+tUg736bj3Mo=;
  b=Nfz4x1jyLBwFvmoHQwHPcqzP1DCShEeZhHQL8meudfWfoM5m8oxMNLmf
   cDBRiMWjn8nnl3dkVkinhYE5sTuvafY4NeEgqHbyHkjlkwKiUEu6Ac57B
   uSlf3zTw/8wcriOUWVMBQGNVDXtCNaTfbe3TeYZTxEh/BY/pllcuLA/NJ
   qSD5nNOwYgTbmy8qqwCGaYkpNMdUJhxkDP+NwqI0DMqjLolAaivl85PfW
   vU09HauuKMXEZsxiugukau1D9b4hLGABf/7nrC7n/eGKAPWeIyfy5L1FA
   8oXvjcIUO0+Sx2+0lWTDyKf5VyhItcpPQEl/08S0Q2QOHKQwn/ERHG1h+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="346259078"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="346259078"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:56:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883331785"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="883331785"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2023 05:56:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:56:13 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:56:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 05:56:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 05:56:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVl2itQizjn8BFjeuO7APg0J4amJTedEBWrl5LaoSAfV83p+xfwX4+5IpoPBBZxlE57S+CFKBO+OL2HF9BWbzs5f/ORHhCPo3lqtXYZ/KPTiL5Z/lCKGbQRqjNYGcPKMwtpIaxr64BSiFrU/40xxUlY4v89ntSpeqJPTIraZYdzsY7OBU2lDLcKdy271CAtlkgNyN6EmTyepHJQmHfIAsmKFMRZf+1TZK+Uwob7HLQEbpGwH1Iu7GpuSmr+IUpMNjYFL4IXv1vCn3S9Dc84dRJxVjc9s+WTF7RDAqMMryptDgPbRjeZPuXWdsjqkKiXc4QtUcm4W3ui2dBJkfpaXJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmwq7d1cSUzDJ6zKY7N6WLx1w5b30hVUetc2+JdF+qo=;
 b=TAyneSvHs/rXSJd4IG9LsSvt2g6ww2lWBrRvYwG2v5AGPVDGsY0hcOOl6yYmeAJfoy0laLNBTUGJiz5n9VqmUmxzWRVy9s8ymEpYckch8P+Fj/dru3rXVq6anFFtX12phNHgXOJI6tLkR53VlgVDgHXEkIeniLeVIYWePrYcQakj59qDv3bmgxclkgfru1wiRLyxxslHPXg5Jr7dRBLD8ONy2NOq4LTvR2KKN/edFkqrc+HczHpLaDjKFtOfNC95i4HNRITue3Z/f3uXTVZAytOzO4p5dpXk2dVVFRUkdw5D7p6tieK8S39wp0PxcYR4aCXG7DugZLk1CTDL4xoa6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 12:56:10 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 12:56:10 +0000
Message-ID: <a1566629-5235-1344-8f78-0f9184bb086e@intel.com>
Date: Tue, 6 Jun 2023 14:54:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Piotr Gardocki
	<piotrx.gardocki@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com> <ZH4xXCGWI31FB/pD@boxer>
 <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com> <ZH8Ik3XyOzd28ao2@boxer>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZH8Ik3XyOzd28ao2@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::21) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|IA1PR11MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 760ccce1-306c-4d9f-d8fb-08db668d664c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4bc3Os3joTJMMzWhkEraHzh8wbZgsBWVdeaEm3oCF2B7u4njog7LTVngg1nm40iVRw69SBMGGYgHxefFhJuarUWcHBOM8dcrm5NNILC6Sj1V2c/i5AwPEjB7cKcWEUZDLHfrmaHYqysDmSbyf660mAjgX0mGQ9/uWyqDvpNzE1f2v/BG47+fSEpJiLrZmIhoDX/sxtXdGE5Ko+QB49mTyM4s1sjTuaiqVRDCzHOqCynUXHI4elOcdXKS4OxEt4PnbS66tAKQGr3XsfNT/2cRmIpJRVEK8GCczsnpUSQKyjuDnw39DdMCWol8hNcsMuAu2tNq7nTSrrQZ1LNtFqttFOUxWqAG/MLJudt0xcsCwoKvB2MGnhVJwB5ED++QCe0PUfuA7sqEw/LAydx0FVzQGXaLs+xszVcgoAOqizd4BYc2lamiH28JAB4iZSu9uNl4Mo8D3oNceSfXxVK+w/0T0mavszOYys0LeFFs+kkV+TfVfyrAppRQBXrq688ycz20A8gcu5QAZKpYB4k+WUbEpKEV57p/fFSyjH0mX22BjwS91fzqdFNH5w4S22wNhFkWCu+a0xQvmXjCms6tFebS89LJSUJJ1lWKKttjXx7JAi4Md7764921S9HgvX/8hQr/XHcTt6u77LMVG6gjIXuQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(186003)(31686004)(6486002)(6666004)(26005)(83380400001)(478600001)(110136005)(54906003)(82960400001)(4326008)(66476007)(66556008)(6636002)(66946007)(316002)(5660300002)(8676002)(8936002)(31696002)(2906002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWlmRm9veWJHVEhZa28rb1dSbnMyTWFOT09Vc3VkQTlscE4zbC92cEJUYXl4?=
 =?utf-8?B?Y2RUSUpxUm5XN2VPQ2ZaWFVUYnRUZ2UrdVhpeGRhUnhpZitOL21WK0pQV1ZO?=
 =?utf-8?B?SlR4T20rQ0UyNlMvdTB1V1l6aVVVYkdFS002U0E4VDN1UVQrcEkwejNFT1pW?=
 =?utf-8?B?MGx4VWFHTU5Ta2pOZkdkanNXbUs3cCszVlBORUV2SjBwdi9rYWs5SEtuRlNK?=
 =?utf-8?B?VzFZaXg1ZDhTZy84L2c3NnBXbTFXNEpDV3JQMk9sK2tlU05EbXJlb3BoczN5?=
 =?utf-8?B?c2hTTGxWOHZ0bHVoeUVTYS9Dc3M0bXhvY1hnQXRKNHdRNnRNZTlBS0VabW1w?=
 =?utf-8?B?b0R3UU5CamxaU1ZZM1NZNE9tZHhhVXJ6SEhacTJtNGZCWEdlN09wMWVsS21i?=
 =?utf-8?B?UkRkdS9ISlVVR0hFTXBEeEp4MW9rNjhrbWVBdjdwMXlsTHVGTjZBMWNHM21E?=
 =?utf-8?B?MWxZOTdIeituMzRFckx3SUZLOU5BRlJxZ3huSXhnTlV0R0piVkx5bFdaVUVW?=
 =?utf-8?B?QWwyaUZ1eEhDb1EyS29XdDBXdG9WSTBKbWNKQTJya2ZjbXVqT3FsYjVGU0RJ?=
 =?utf-8?B?TThaLzV1OUFDbktZZkFYbGlFR1k5My9DYjEzK1Rrb3hCN1cxN0d1WFlWRzVK?=
 =?utf-8?B?aVo3M2N1M002cGJrOU45VGJWTXZKa0NRdmVXaDAzamlGcDFlTFZ6aEw3Mkh6?=
 =?utf-8?B?OUowQ09aZFgxYnJkUGtxWHhnSnJaamtCWkxZZ1JsaloyQkVvTkJvRThaTUVM?=
 =?utf-8?B?YTBSVmZEcjRVbzBZN1BLL0JZZktRdmdldVlXa0JKMXpCR2hMb0hpNTY2NUQ1?=
 =?utf-8?B?WEFXSDlPL1psUmhDNGF2NldPUmoxZit3WlZyWS9FTjYyd2oxeG4wZVo2bmph?=
 =?utf-8?B?S0NSeFEya1dXN0p3aHd6dnlPVFdOaUNucmxIODhDRnp3eTVXNlRWVWFMOGh1?=
 =?utf-8?B?R2owaS9Wbi8waVVOcFZ2RWRhRUVwZ3pNZ0lFTm15QlVxemRYV0hCVFNiR2Fm?=
 =?utf-8?B?SEI4dTZ1eWszZEY2MlN6bHdrNTVDcG1hQlZwdktFM0hCMWxITlBYREhIR2l4?=
 =?utf-8?B?d3ZrSENncThKcEhGTnZiTUVvck1NWGZBdG9aQUQ2NXlhSzFZMUR5YTZEZ2U4?=
 =?utf-8?B?UVA1WUlWSkVUQnJDVFF1c28zTkpSVDB3VFhkM2FpK1k5Mkt4ZDB0Q2V2Rm9L?=
 =?utf-8?B?QXJUNmRzdVdDZGdxUFA0OXBzSThjaHo3My9qWVN4aUpzb2pPOENYR0lQWVBW?=
 =?utf-8?B?cjlWWFd3Q2t6MzdCMlRHeGxMMlJ5cjBKT0NiUGhPVnhnU1FKcFJMSjdSTEEr?=
 =?utf-8?B?OE5YUGk2LzJOeGpOYklSVVFBbWl0ZkhEVGtTMlRPeThmZS90RDFuVEI2OXFy?=
 =?utf-8?B?Z3dDZ2RQdW9WRXpoZEhqSVRDRjNaVVVjUnNlOEJmY2RaaXhUTWtmYlpJRTVh?=
 =?utf-8?B?enRUd2EzTFQ3R2ZURmh1dklKUkl2ODBpc0pMMVpHRWF3M1Y2YjRMNU03MzJz?=
 =?utf-8?B?K3NGc3N3VUhtUHNYNFM2UDhCS1lTTWtCc2NwQ05YbEdzb0NZMjZVOSt1U3lj?=
 =?utf-8?B?N1B5RGhJYlc1OVRNZG1jMFpiVUZnTkhERFZFTkhqRDdJQ1dqZDRCY3lzZnVu?=
 =?utf-8?B?SGI2N2lJdXp4V2oxREZlUUVBOWVoTFBJQjRrMFlBNjJCZDM0ckdRY3JJWENG?=
 =?utf-8?B?SkxKWm1XVndmenlncW9CMGIxMmEzSk1rMjFGTXFoaG1BNUM4SUR2YlV5SDNj?=
 =?utf-8?B?dHpuenNlYWpSMXhzdkE3TnZCd0JxK0NRM3JRdU12aDNvQm5kN29DdnFWR09h?=
 =?utf-8?B?Z0U1R1Y4a1NGUDd3MGZ4TkxlOTRnUjNLOExLdHNVcjk0QkRoM0xnQTNJbmVY?=
 =?utf-8?B?MUM2QmlRQUxleXRtN3dHOEh1NDNNOHQzbmIxSFpEcVN1S1ZGK1lmb0I4VlRP?=
 =?utf-8?B?dVQ0RCtYbm56Z3FwZFEyR2tmSWplaldEbk8yb1dUTER3VCtCcm5oYk5YcEds?=
 =?utf-8?B?a1J1azFMWGJrdW1TMWpUMXA5UDhhdXA3L1ErR1FRbS9GdHBnRk8xdGg2V3Bw?=
 =?utf-8?B?V1R4ZEdxemk3TmV4T096cHlzRGk1MFU4NEJJazZIc3NLWFp5K0JlSjlvN0x0?=
 =?utf-8?B?c2R1czkrNHdFb2hkS3kzandmNGVVajRQOThoZ0Z2VFgrbUxvdE9MVGY4TVZ2?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 760ccce1-306c-4d9f-d8fb-08db668d664c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 12:56:10.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiu50MiOR5fhPwXa9RgHuJGHBs9AH7ZfskIfmGJuaSEXDN1t7d40nM7r+vTo0kuqipHtfR0iniZsUo80oLMbYYOwWGOKhtaluksxhl4Mn70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Tue, 6 Jun 2023 12:21:07 +0200

[...]

>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> index 2de4baff4c20..420aaca548a0 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> @@ -1088,6 +1088,12 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
>>>>  	if (!is_valid_ether_addr(addr->sa_data))
>>>>  		return -EADDRNOTAVAIL;
>>>>  
>>>> +	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
>>>> +		netdev_dbg(netdev, "already using mac address %pM\n",
>>>> +			   addr->sa_data);
>>>
>>> i am not sure if this is helpful message, you end up with an address that
>>> you requested, why would you care that it was already same us you wanted?
>>>
>>
>> You can find similar message in i40e and ice drivers. Please note that this
>> is a debug message, so it won't print by default. I would leave it this way,
>> it might be useful in a future for debugging.

I'm not a fan of neither this debug print nor the argument that it's
already present in driver A :D When we're developing things, we always
add a bunch of "useful for debugging" stuff to the code.
I also don't really get what this message can help with.

> 
> hmm fair enough :) :
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> CC: Olek
> do you think libie could implement common ndo callbacks?

For sure it will. OTOH .ndo_set_mac_address() have a piece of
HW-specific code per each our driver. Configuration path is more
difficult to merge/share than hotpath in general, but will see later.

> 
>>
>>>> +		return 0;
>>>> +	}
>>>> +
>>>>  	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
>>>>  
>>>>  	if (ret)
>>>> -- 
>>>> 2.38.1
>>>>
>>>>
>>
>> Regards,
>> Piotr

Thanks,
Olek

