Return-Path: <netdev+bounces-10728-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 108C872FFF4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4230A1C20CEB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A9DAD44;
	Wed, 14 Jun 2023 13:25:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D97944B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:25:25 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA614172A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686749124; x=1718285124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MVsnI3Hf3ybfjL3sC7aL2oVVazz73Br22TmApq4pP5Y=;
  b=kNSR229hzvxjMbvqBGDzuqTcJg6H+fe1h5HhRJ2jtIzFiawfjPcCiGim
   rIYW8dovfvBNhO3kf5Ynyu40TqjI7hvD0UakfCHJ4zEZmgm2yPNY6LimV
   c4TalBgSP1S5ok8B8GVEbTdJlyVA4F0/bIlwmcec8GW3GMAkefcdCz4wY
   pnOZF70R2bf7+ytWen7Lvugy5QgKirNVgmkOH44DCuEtSxluItYqf2pgp
   PQQgURD7pQe0upeaH2hbLFASYo81AMhAa5P7dQdyW7bZs6I7xWwXWyc5X
   BDnYOpsTx+zYElrmvMbYwcPjRhOBMlJVX0Tr0/ranZwS2Rt5x8Go6yTK3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="424493217"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="424493217"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 06:25:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="662401018"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="662401018"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2023 06:25:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 06:25:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 06:25:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 06:25:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 06:25:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeFb0PCfPp7/mo0JJwYhxl7CKmZapdN2JCA7diFA3mnmwEasO3tJN+U6wcAS+35kBIyxE/INsFmfejZDGJ5dHtGbJ+7WNwJwI5TyWZ+Kaky0LZDwxk4aOzPEXdXLFWnk0goMGCwq2Pt50t5gw+swTU+g4tMnRRbO3SvKI5vZoYGOySe7QE42NPAHfeO6eUfrDYuAsadK8l1C3xQGYzDbQoMurbNrxva/7c8ldY8hhiauqLr4yZak5/P5wOAZN3+FDNX5dD7uXKKhCG4ufGlR+NfXv87qkbriv+X3ibPBV/9fTZQbnLkTBmdZFd+w/slr+hbbjNAb1FdK2nFxkVHV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZEaEjhN5CwD4xgogIK9/Fy8m69IU+iYP+AH29NxoSo=;
 b=WM/Z/hAdPORVtDbgBWoCgPOYd65c2hozTZJHeldVGllhSbfrosBo9vraXtwWfwwUycx3tfu2HYL52oeUuAv/jk2aNpBEiVZN4eKZvOHFEgHhwn+Xa/AJFj41Rft8SVgxi6/WiLmiqVD6GdK564lP199+9vLsjByx1moRH0ykhu3vUL7otw/ddH1bHsvfEAACcrhBC6MGf+55AzBDG8HLemXZYKek7R/fChrHAxkZjrxU7SGQyBWy4RwEgGlTBnSJqwDSNYQaBl0fChsFCsLbD769WqsOB7eu/dEBk3GEhWYTy6PbcxVL+woamfGygHyAvWXnG/EPlCsT5NdQMcJcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5282.namprd11.prod.outlook.com (2603:10b6:610:bd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 13:25:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 13:25:20 +0000
Message-ID: <b3f96eb9-25c7-eeaf-3e0d-7c055939168b@intel.com>
Date: Wed, 14 Jun 2023 15:25:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
	<netdev@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <magnus.karlsson@intel.com>,
	<fred@cloudflare.com>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com> <ZIiJOVMs4qK+PDsp@boxer>
 <874jnbxmye.fsf@toke.dk> <16f10691-3339-0a18-402a-dc54df5a2e21@intel.com>
 <ZIm3lHaa3Rjl2xRe@boxer>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZIm3lHaa3Rjl2xRe@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0297.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::21) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5282:EE_
X-MS-Office365-Filtering-Correlation-Id: a35e0a3c-31c0-4df1-a63d-08db6cdacd21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylAI2jE+91EjuPK2xjaynxX2UALiUFKe31F3/9BoqNEkbqhmq2yMMgT6UychXCGKz5A0Jil86rE2ZT4I6wFY3KCV5v2GPlfzmVEQN+GqxD/pFDIYnvDTTBT5BPRfpLca5Z9McAsHysl//7NBzjv0DqNETGstynK5RZBpvabDWv4uBrVmn+n8f+ITxf8LzbPzC9wYvSclRtgskbJ4/F8nLkfI+2J3CnDJLccIvgaMyPsuYhye3cer9xNKKTY+ZedwHnKUN29apUbQisMhexqWFNmMXhC7Iblx4ctUCup35OUYcljczXvysTW46UX51mLcIhOYTl96Pu+XT4qKj2g0GTHtc27QVhEyAjC0u9qpZ/TQevk2+d+/Un0l8o922RRMaAqFOY+iQg3Lcek8UbcGW/4n6mIu3Q1GfgHf4i1+WSa71XKWiFEXfKpy5ncg8k2tNm1LWebmaU7pgGebWgOCLRyAppJB8gRBnDrgV2rGNt4X2PINCMfJHL5HIOW9f71ZRDD02isRXr7JpuUCRnDFnkjNCT+GTjCUA4pHyvxmm6TrzAbmFxerSq076NnO3kRC6bm3LUglKD1b1jWiDIt7HHwsxk7rZxlUb+wEm3GHxIpyeC96LQuFAJa9wfGTfqOtJmZ82Fp8Gl4sGQLxd+7cRSb0Di+wcaBeXuVen/0NDFOxe3jTajF1hJjwqlOEQ6wI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(83380400001)(66574015)(31686004)(6636002)(4326008)(66946007)(36756003)(316002)(5660300002)(37006003)(6862004)(66476007)(6512007)(26005)(41300700001)(8676002)(8936002)(6506007)(86362001)(31696002)(38100700002)(2906002)(82960400001)(66556008)(6666004)(478600001)(2616005)(186003)(966005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1FBVVhpRktNd3REMURRZUhVOC9zRklqUjNjSFFuTFUweWF1Zlo4VGgwZXdP?=
 =?utf-8?B?YWZNUmVxQVBJMHhKNE8yZUxzRmtOdzIwRTJQVUZkbEdwTEFUeC9oRlhpV2RX?=
 =?utf-8?B?a3RsZW5OMmU4eEFWLy9FRFZOakE1WTVYSGs1cU54b2pDOWpyVHhjS1NVeWpy?=
 =?utf-8?B?THpKdVMzdDZFcDZWdnpXbHhFdVlXTUtyMXFUT1JhMEUyTWVIeXhmNENncTcr?=
 =?utf-8?B?RmJwejVVZGNSSkd6MnFTWEFzdWdqTFlTVTBFcTFWTGwvUzRYeW50Mk1LUUxL?=
 =?utf-8?B?aGM5U3JTSVJYTVU0MndkLzI2bUI4cGZ5c2djejhNNVEyRGtabWZDODdVRDdO?=
 =?utf-8?B?SVl0Kzlzd1AwY3E4eUVhMDB6R0pwY0MrUWlkUDRsZDkzbUYxRjBKVDg2VXFL?=
 =?utf-8?B?WUxUQUNhc21FbklROWtoZkhtWmtzRzYrREpXU21PZjdWbUlPT1pOUnhoTkpY?=
 =?utf-8?B?Z1QwT0NsbzFMWUc3aCs4WVdVTEloTHlINnJhZGFQSGdUWXk4Kyt6OStmbFhJ?=
 =?utf-8?B?R0dFMjlCVVpBZTdpYzBldGhhS05IdFFteC9tMkJkbEIxVjQySnZ5NHorcTJa?=
 =?utf-8?B?STRzOEE5dDI2QXNlMTFsZ0tPUXFPYWlSa1ZIek5zMnZYQmx0bXRMY2RDOXZo?=
 =?utf-8?B?anlnVXpRZDQwaURDd3NEYWhpMEFHVHkyYXV1a2k4K1QxeHF5d0JTendmTkxx?=
 =?utf-8?B?SlRKRHRhL0xhcXJCV0J0QnM0ZWlBU2NZVHBNdVhZejZQUVJ6eUEyMWVPc0Zv?=
 =?utf-8?B?SlJXOURyMnpKME9va3JGcVVEdUdKNkJMUEpHdlc0ZyszMHhKdjNoVlhKQU5h?=
 =?utf-8?B?QVcrQ25WWE1oZE9MY3V5dGsydk1aWE9mVndnUW40ZnNnRTlzWGx0OE92eStv?=
 =?utf-8?B?RUVjY2lPTmNidkF3NVhFNzU5M0lBWDNNaHlONWR1cHJFeFpGTFJUU1N4aTJH?=
 =?utf-8?B?L2oraHFFY2MzWk5xOHF0RE9oN21WNEN0clJ0Tk9MZDNCdnp6Z0ZFWU1RalA0?=
 =?utf-8?B?RGxES08xWlRxNXIwaVlJZzVUb3BqUURJNUdZL0NEM3hLbTE5SlM4bjhLQ0lx?=
 =?utf-8?B?L3hrQWJCVllVSFA3Qkx2SWkzTEF3YlVKZ2t6YmJJYjRqSWEwaFdDU3BzaXgx?=
 =?utf-8?B?UVlPSTRUTmNtTDk4RjkvZE1lcDU1VitWSEZYU3VHeEpXTTg5RFNiaDlteXBS?=
 =?utf-8?B?QVdsY2FOaHBPYjNGTUZSQmNLSU56TklYek9uaUI4cE04VjYyQytiSWk5NlZ1?=
 =?utf-8?B?WTdEUDFrQmlraTZpRFI4OGF4eWJjZ3h6MjQ4Vk02WW15bFJpbER4Rkd2eFdJ?=
 =?utf-8?B?U0hiUmU5U1IzUzhvTjhpVTlLcTk1a2pnc0NlQnJrOWkrQWt0K1RhU1d3R1ky?=
 =?utf-8?B?dEU2OG1ZWXhZYUxLc3NiMFMzQ00xczJTSGM4V1gyeTN4ZWxaZ1FWcmVCYTFE?=
 =?utf-8?B?ODhWYmIwd0FkUFFBQkFDdzI1SDRUTVhXSWF4NXkxSVFFSjA0d2J4Rmcwdm1I?=
 =?utf-8?B?KzZWamJmYWNSOVRDSy9uRTVnTWQ3NXBTOXUvMlROSmROdW53NTV2RXVxUXBE?=
 =?utf-8?B?dE1ZZkVyMFNCczlQWHM5SXI4NHU0YXA0SEdKdlRWc04yamd2Q04wNmVTR05C?=
 =?utf-8?B?SUZ3ZVd3a00rTERqRDlKRXlKenVFaWt3RXRuSjZaaGV2YVo5TitDS214SG1G?=
 =?utf-8?B?Nm1jZWlsRTEyMmFmZVJsYlJRTlpENUNaS1RUTUhmQm13SVpOVFR2MHJuRWtv?=
 =?utf-8?B?NnFHOXRIVHE2Y1ExQUFVK1pKaXd2UEpHamJxKzdTRTB5ZktZdE9sYUdtbTRr?=
 =?utf-8?B?L1AxTkQ2aHRLWmZocFVSa0dOekJsUUpXUEI1K2NwbkRHRklMb0ZFenNUbTRC?=
 =?utf-8?B?SXZWSGlBMi80S3dxN0R2NHd4cmhYeC9yTS96WE0rakt0Yk1yMURLVVdVdlVv?=
 =?utf-8?B?SkszeXpudEhGd1JMdXNiSk1JZkxaZzFGMGlaMjRKYmlRemxRbmhmeStGT1Yr?=
 =?utf-8?B?OG1PTUtjZlg4UWt6bmZ2R0ZsMzFCT1Z0azV2b091SzVSYjZjcFRCY1NDYU9p?=
 =?utf-8?B?STdCS2MvMTU0aDJkSDdMNjJ6RldyVTVPMTZ3OUdDWlhXZlNDWGRCU0FQSVBX?=
 =?utf-8?B?VWt5S0o5V0pOclRUTytneUgrWC92d2NuYVQ2a045K0pHWWhqUWs1VzBSeis4?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a35e0a3c-31c0-4df1-a63d-08db6cdacd21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:25:20.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDxXJH+rtp05BW6jJoh6VO1du5p49qEX92Hw180LivsGUgiZ52n1yI5+FiG3QgT5+bXBZXTRH+NBqnH2sPJtcZqE49hChq/Okp5WiSE5e1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5282
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Wed, 14 Jun 2023 14:50:28 +0200

> On Wed, Jun 14, 2023 at 02:40:07PM +0200, Alexander Lobakin wrote:
>> From: Toke Høiland-Jørgensen <toke@kernel.org>
>> Date: Tue, 13 Jun 2023 19:59:37 +0200

[...]

>> What if a NAPI polling cycle is being run on one core while at the very
>> same moment I'm replacing the XDP prog on another core? Not in terms of
>> pointer tearing, I see now that this is handled correctly, but in terms
>> of refcounts? Can't bpf_prog_put() free it while the polling is still
>> active?
> 
> Hmm you mean we should do bpf_prog_put() *after* we update bpf_prog on
> ice_rx_ring? I think this is a fair point as we don't bump the refcount
> per each Rx ring that holds the ptr to bpf_prog, we just rely on the main
> one from VSI.

Not even after we update it there. I believe we should synchronize NAPI
cycles with BPF prog update (have synchronize_rcu() before put or so to
make the config path wait until there's no polling and onstack pointers,
would that be enough?).

NAPI polling starts
|<--- XDP prog pointer is placed on the stack and used from there
|
|  <--- here you do xchg() and bpf_prog_put()
|  <--- here you update XDP progs on the rings
|
|<--- polling loop is still using the [now invalid] onstack pointer
|
NAPI polling ends

> 
>>
>>>
>>> It *would* be nice to add an __rcu annotation to ice_vsi->xdp_prog and
>>> ice_rx_ring->xdp_prog (and move to using rcu_dereference(),
>>> rcu_assign_pointer() etc), but this is more a documentation/static
>>> checker thing than it's a "correctness of the generated code" thing :)
> 
> Agree but I would rather address the rest of Intel drivers in the series.
> 
>>>
>>> -Toke
>>
>> [0]
>> https://elixir.bootlin.com/linux/v6.4-rc6/source/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c#L141
>> [1]
>> https://github.com/alobakin/linux/commit/9c25a22dfb00270372224721fed646965420323a
>>
>> Thanks,
>> Olek

Thanks,
Olek

