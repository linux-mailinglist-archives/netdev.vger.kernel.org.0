Return-Path: <netdev+bounces-4791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CA070E477
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A707280FD2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5B8521CD3;
	Tue, 23 May 2023 18:19:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C552098A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 18:19:23 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D268F;
	Tue, 23 May 2023 11:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684865962; x=1716401962;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YN2oqm4vDXc2dsUwuxgTzwyqTppYwP3163PDicxcj7I=;
  b=A8f6w9TAejyoCI2VemCWZxUmUqAijxs+vIjsv4L8LDmCtfTuhhXDcFLf
   umX0vGYzK68Js4UacL4Z1sogiyZoSHL6vN45LvrdbI0pU+JDRJclhyiVu
   ApvxSWncIo7kLkvFLEPuW+0kQZoRHmRwaVDadKs+pG5v9l/6U6bqezYRB
   ZhVUYqPneG+6VGNqdEcWRORIp5NHapjEOVrAZCuaZWW6b5Ik8cCnv2DUD
   rsiJPJC3PBjHctJUQ9kF9k6IYjPa0ykLi0K/HRTWq86ytpw0SHnEdjowJ
   +w/nVjoGdxbqcVvMvhw+Yy/evA8tboFajTau6+Kt/G1Uyc68PRXvlSQBK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="342784935"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="342784935"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 11:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="736972570"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="736972570"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 23 May 2023 11:19:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 23 May 2023 11:19:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 23 May 2023 11:19:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 23 May 2023 11:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqBjVZ8v0VnZlYJGKRroR6jTg41M3N9AQQj0c0qrG4ZlhIIoUEvBa8QQ7hX9WPC5xXonDIOIOfKRs71rt4YKa9eF72ep0lwsxcmZEBDJw044iKzZPJp6xZqcqATeedMZEVn4oNOszAKRrfxIO9R28P7DiNKHf+lYIhP3hh4HdzrZVwCeNDBlQuyQrOk+z4FAZ0Anyyz6TKKA8G3RPvZksNsHlY99idlKoeD3huctfvoyTE1lyRmEfy5HL5ghdqBNJrZ4ZySkEBr0sriY4aftq1vZfcPot2xgahJUM4I5iDDU5l1vMp/+fDVuJ6xhjyvrp+dVIFarAhlPI/nxpciDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQkeHBGU0PIvfvhlX8EIqYQOv0HWpCs+wYX2d2mnzK0=;
 b=OKYKF8hIKj1UabTghrTyMVxE1j5g6yVGiUOu2rw1AUPX5uVMXdrSD5g/75wyD+6k2Lovf5CKWKSz+JNMq+pkb7hFAqfNkmfjQ1wxxdAyntbF4aCN43rp8s7WLPQycaznwBKGUq+8QeuCah2xhVAH7ct5Oo3y2Y14RIozLHjjd24rS9nxewNAw8XdjgNv0b+bH2GNmel6LizdcDHN5o3PjSvwkgFHLe8jlPTuKlj/jW0pSiXnjDPZT34WOKZ+HxajvgdytFRSHIEUykRNdodzRccgSH721JANUlqI2Z6urGUMGUaAfpPh1HK2znWib9EF2gER6MEU6y0gDooD40HRNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA1PR11MB6991.namprd11.prod.outlook.com (2603:10b6:806:2b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 18:19:04 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 18:19:03 +0000
Message-ID: <692650e7-c006-4f89-3b11-dd2f193f510c@intel.com>
Date: Tue, 23 May 2023 11:19:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH][next] iavf: Replace one-element array with flexible-array
 member
Content-Language: en-US
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <keescook@chromium.org>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>, "Keller,
 Jacob E" <jacob.e.keller@intel.com>
References: <ZGLR3H1OTgJfOdFP@work>
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <ZGLR3H1OTgJfOdFP@work>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SA1PR11MB6991:EE_
X-MS-Office365-Filtering-Correlation-Id: fccd2d6e-e2c8-4525-1449-08db5bba305e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxuLLC7kLlUXjTsrv5txBuompI9Zc91XRGjQHsVSzrguJAIMuOFsAOgZJRsm+i5gnBtRdkJCdXYgWlT8VHvnqQPeQhzzLqoXazaE105LClH2X5NCRmOYtEHx4TMvdLOAwAmnVr0vzW8iHOLE/jp89Bz/2yLfVnoX1plAjk+l9gEBFF/6D5Z0obl9MD1T2gK+RSRjo5cTxU7ZlzVx2VyHPrmxKfvDkEUHMACRaJTjjjLKLnnKVjDJ+CUFw9Z5vaYgXNRfGzrIVsIXrCqaz2/Jx5kohgDRXr9kXfE1i0AGgDSaqO/riIZsawLfZDKSGNKw4NIB7ZSThvivMHc4p7i6m954z4fWUpvWC8vrpbyzcaxlF+fosm/SY9y/XgYlqyPA6HvmKWDVPd2KQNrPDtTTnJp0nIfwtIrt/7UA088IFR21BTOlXM/8Nw++v5dIpsShrellQ3IAKBs2KmRPwycuTgsfZi0JpKpSZMQWmB9U1c7loSO8jQ4cVyw7tPe2Iu4CtFBziMqfs2KpRq3RNEvKnvUtWB6pXGFPxy3PX78ySSyZxUgtxtqcj0pN6pPof7URd3Buf50M+Df7BdrYMndXetL7mFq635gwsdPq+HxtY9ujye+U0kDi3ZtCNaOOjBuGywENvhJvAnwvvP1M+UxykLkUUvH7Huv1NQ8n6nEa+obpWi3j2r8eg0cRhIdTy7bY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(316002)(31686004)(38100700002)(110136005)(66946007)(66556008)(66476007)(4326008)(82960400001)(478600001)(41300700001)(6486002)(966005)(31696002)(8676002)(5660300002)(86362001)(8936002)(186003)(7416002)(107886003)(53546011)(6506007)(26005)(6512007)(2906002)(2616005)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlNjYWFIMWg1MEgxYVdZNU5xT3RZZDJqLzE2dTZlVVRYazZtQngyVUtRR1lO?=
 =?utf-8?B?M1JxT3hRTXNncmE2d1E4MzY3aHdrUE9MR1JyQ3p6aHZqSTlSamRhWkJMNVR2?=
 =?utf-8?B?OTc4ZDRPYU1Fc1pGeGNQclhNY0huSmxSZVZURjNZRCtQM2VienVzZTVvTkdL?=
 =?utf-8?B?bTFqb1JKOG9RMkRBZ1BqSlAzSTk5ZFNpd2pMSDNObXByQ0phMzFSYkswSXFQ?=
 =?utf-8?B?Tnd2Vjk0M210NVhBWWxySVNucXZDZ2t0UzYyZGJFUW9DNk8wcTVWd0tVWU8w?=
 =?utf-8?B?eWpYT1NjbmYvMHRIZ3dPU3ZXaUw5TmFFOFZPcCtKMjNVWHV6MFo3YXFtSFJK?=
 =?utf-8?B?NkIrR0ZwbUlVVTJWeDZWUzEwZDg2Tm4wVDJqcnVSbTVPanA4NEdKQWVnekFM?=
 =?utf-8?B?MEU4RGt5WHZxRmxjb2J0amQ4UDFPdVRuZWtiQlhSVkkrZURESGJjNDRQMVht?=
 =?utf-8?B?dXF4a215Uzh6aFhuTWtiZ1lnVDQwMWJ5aHJtaHNCWTN2SnBHeXpTZUpYVGR2?=
 =?utf-8?B?amcrUFh5RzRzSlMwMVVpNGxyYTBONEJYMG16YlR6TnN6clNyVkxRdkNkQkNw?=
 =?utf-8?B?YmRubUJWNTBlTEtLZ0pVQWhxUTMrcW0xYWJLdWRWTVRzYnFLR0hRUldLWlZl?=
 =?utf-8?B?bTJTVmUwS1ZoR0xvTXB4K1YzeitSSWpPWXVtaGFlb00rWnpIYXVQTDRTYlgy?=
 =?utf-8?B?bW1MZjBFalQyT2t2VSs0N1JSOG1yS1VDRFJYWmFCNHYxejZzeW44OUFYaHpE?=
 =?utf-8?B?MnVKbVBkTEtvUUkrZmVZRlNPMjdxVzBRNnVTcHhmMy9WQVBodFpTY1BnSmpN?=
 =?utf-8?B?ekcyWnJzYXFId0lyUHZPOHZsb3BPRjc0andWZU1kNEpjUHdBcTNxNWFFa2o2?=
 =?utf-8?B?VEVaVjVNYngxZ3BNS25KY2RCdUdCMytlUGtKMEROMmFiNU9GVGhHeFhFNy8v?=
 =?utf-8?B?d3JtU2ZPdDBLVUZtMHRJSkpWRXNaU2ZCbkJpdkxsa3JJdHc4SC9iUWdyYm9Y?=
 =?utf-8?B?K3I0S2h2OCs4UGNIa0F3cysweHVYdkNiV0gySEFIRWVUYk1mSDIzZlpoNkFp?=
 =?utf-8?B?Z3JWL0syeE50RHIvcGtGcXBYSU1UaGI3Z3diSTcrdUYvcHliYWVXclhWYytW?=
 =?utf-8?B?UXpvZ1d0S1dIYTRySEtRRHVzbTRzczJnTDlVSFZzdG9WT2dwQ2hrMm1XNTBh?=
 =?utf-8?B?R0ptSUVUd28wQW1zZ0REWlA5d1BvY2hzb0s3dFFralVxVXpUSDFmTWxmRWl5?=
 =?utf-8?B?RnpLKytVcmFhVXA0ZTQ5eU15cy9BZmlEajVna2FvNGFtZlpOR0ZDa3pKdXRS?=
 =?utf-8?B?ZTkwdmN3SXA5YngwN2toNFhWeStzaFRkeUg1Q0RoYWhjUjFHT2picCtOSkJQ?=
 =?utf-8?B?MkRSSWUyN0F6bDlpU1paSzlOVXFLVmY3RmZnSno3bzJkZ1VhYjViMWIzY3pw?=
 =?utf-8?B?eU5uQ25qdHpkK2NzWW5WU29qcE9oUWR2LzhvMFh4YWhXZzlkcDJnQnNtbXZ6?=
 =?utf-8?B?SW92Z29aa0NoWlRqd0cvb2VZQlVDaEJXL2dxeExRdzJVR3diVUcyVSs0TE1Z?=
 =?utf-8?B?RERSWCtISkRFZ0FRTlFQQVVlMktHMDkvTUlFelJ2THpORG1MdDdEWDAwRk0r?=
 =?utf-8?B?c2krRVF3NjFzTTJ3bGVBSE1uTnBWQ05uejdKYXBSZmxONkpMV2JGYXVSdXRj?=
 =?utf-8?B?NU12dFVWWE9QbWNMRW5Ud2pEbjVaRmNYc3BFRTJsaXUycFBuZ3VYTjVBQlZO?=
 =?utf-8?B?MDJDd0JSdGV1MnRFZTZQci8xVU9LdENhME1YV21QWlZSNUhaRDVyTm5SUWc1?=
 =?utf-8?B?MEhaLzd2a3hMbjNHekhFM05Hb3c4NHgzcjhFUW80T0lJMUcya3VSVmNKczJ1?=
 =?utf-8?B?MmFJZkl5SzBXRk91Wi8yMDlKS1RQWnArS3RhVGt5VzZTcW95STMycHpQY05Z?=
 =?utf-8?B?Q25FRXFtMHlLOEhKcHFlK3J4eTZNM3RlNWpZUWhCSXFQQk9ZWjVHb3UwSm5q?=
 =?utf-8?B?cFRvZDZJMnFSSWp1bThRZDBNcW5JSGs4QitLSTRRUmNtZ2FldG80M2pYcUR6?=
 =?utf-8?B?bnZoT1FpdEQvdnJIcGpRaFBQQlN5SHZoRkx0YmRRL2ovcjZ4clZ1dXIzUWZM?=
 =?utf-8?B?eXJQQWZ5NEM1OG14R0p2SkswMEVvNEltYXQreG5RUjVVUkxXdEhqbHhmQjhN?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fccd2d6e-e2c8-4525-1449-08db5bba305e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 18:19:03.8349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQ2hKXLZSLlCLKlD/urhnh4KJWisfzDIXonyNRMA25TJ2GUx5/DEhmQpAvPxvuk4AB5olFfSEi9fMlPNVziRLlIFBtkdM84HDfG3wpi6NUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6991
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/2023 5:44 PM, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct iavf_qvlist_info, and refactor the rest of the code,
> accordingly.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/289
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/intel/iavf/iavf_client.c | 2 +-
>   drivers/net/ethernet/intel/iavf/iavf_client.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
> index 93c903c02c64..782384b3aa38 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_client.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
> @@ -470,7 +470,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
>   
>   	v_qvlist_info = (struct virtchnl_rdma_qvlist_info *)qvlist_info;
>   	msg_size = struct_size(v_qvlist_info, qv_info,
> -			       v_qvlist_info->num_vectors - 1);
> +			       v_qvlist_info->num_vectors);

The problem is this mirrors the virtchnl struct 
(virtchnl_rdma_qvlist_info) so that structure needs to change as well... 
However, this goes back to the interface that virtchnl provides between 
PF and VF [1].

I think removing the iavf structure and directly using the virtchnl one 
would make sense. We'd need to adjust virtchnl and follow Kees' 
suggestion [2].

>   	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_RDMA_IRQ_MAP);
>   	err = iavf_aq_send_msg_to_pf(&adapter->hw,
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.h b/drivers/net/ethernet/intel/iavf/iavf_client.h
> index c5d51d7dc7cc..500269bc0f5b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_client.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_client.h
> @@ -53,7 +53,7 @@ struct iavf_qv_info {
>   
>   struct iavf_qvlist_info {
>   	u32 num_vectors;
> -	struct iavf_qv_info qv_info[1];
> +	struct iavf_qv_info qv_info[];
>   };
>   
>   #define IAVF_CLIENT_MSIX_ALL 0xFFFFFFFF

[1] 
https://lore.kernel.org/intel-wired-lan/f3674339c0390ced22b365101f2d3e3a2bf26845.camel@intel.com/
[2] https://lore.kernel.org/intel-wired-lan/202106091424.37E833794@keescook/

