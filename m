Return-Path: <netdev+bounces-10363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F2F72E1DD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 891C6281207
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C013F2A6E7;
	Tue, 13 Jun 2023 11:43:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E553C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:43:14 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13D4F1
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686656592; x=1718192592;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PF7ZU05tnLzCXVZcfBfUr+ZsifqCAoZchSotGYWzxfA=;
  b=nN/k1bJig/F/f4USZaVkOGbmxMhhFkBxu2Imh0NlkGlrM2FhwJIwrVkw
   lRBozsHMKAAmgyzEE5/YFh9deMB+FKuwVQfo515/7Fx6NgNMx18XcUc8Q
   ybaZX3IG7RPfD1JhRZ2D1Sf71lZ5seGMw4TXHyuRSj/k4Vl3K7Xm8gkYd
   4wB7dh6QOf1ITIh4B0r8s/A/aCKiIR8fiA93E8M9srU0DF+0cs2zFjtGj
   Qh2zOAx0zBGyWjZEHctcmS1TSYor3i0dcG3KVIenYqsaxfkMMrCpEgJp4
   SEwzmTmzKbjaITK2Km6Tjl6qGr8pMSMjXWWY2R413ymGkI0PtOKQTvAP7
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="361676838"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361676838"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 04:43:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="1041740693"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="1041740693"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 04:43:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 04:43:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 04:43:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 04:43:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 04:43:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZpRln3y9Qt92A9hySY9Mi64yV7vkI2dJoSvs6tm8u0EYqfp7OofIfiJDL5eGDhpIYzo7CK7cq+YMu5NCX0RZCmAmMaTpR8QmY9e+1AdHpw7XZLwRrI2Ukto1mKPVLkIBihn4YcwvwZsPhITiHG5rV/E5VVMC2+okfqocnDc6NRpAUqHgP3Rx9UPB1GPVRsLUIoSCINW4B/o+2hOYuPIG7bU8fIUujkCEGlyEAmd9cJ2Zhlyi/UyQEH4K2Hq436Xa6DvqSScRY9wyB/cKO34NvhD1XL14mtrvhvte6oOoFvEUd92yj48RxnpJs8gnH0NqMCHjS/Lul95bqgd21wnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5GvvOnxM6tCKOITylFDwSyBAsiAVE4npp8TxJPnl9U=;
 b=LH3rjpfYhr1nSu9pG9/+GBwYaPQ8NSnuqKDQ+lQAirvYkeRLz6d+E2We0ahv5JjMZoENXY/E39jahbDOGBWIrs+GZDcmrNTJ9+GQZIEpOzkALtmnow5PBsSPCeUZmtj6srC3j/p7vy2RLWgazti7UTVmymkvjJGtY2VIdiEIeB2sWUaQJt3mjhZXrekpDlPF99XDywqQ1YqSLTSvMTFtGEg8htBiB7cDuhD3rbUympUc5hbY68xlpLS4CA0r8N/80tv4GEpP1dD9r9fNr9LIB+Ry4nrV/a8qMS9dtgerR5/O7CvoaX8EmpnzCd17bN8NuzUIN3Z+lvkMms4HXchVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by CH3PR11MB8137.namprd11.prod.outlook.com (2603:10b6:610:15c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 11:43:00 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 11:43:00 +0000
Message-ID: <28e4be5a-66b3-a132-464b-40815d7c0e2c@intel.com>
Date: Tue, 13 Jun 2023 13:42:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 iwl-next] ice: use ice_down_up() where applicable
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	<intel-wired-lan@lists.osuosl.org>
CC: <netdev@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<magnus.karlsson@intel.com>
References: <20230613113552.336520-1-maciej.fijalkowski@intel.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <20230613113552.336520-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR2P278CA0027.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:46::19) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|CH3PR11MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: e8987473-31f6-457b-cbf7-08db6c0356e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4InAL7kffz64VmVubabc6Fpo2iKP4dPmzE9E1dq5sMCZX5St7LB5faeCtoayDUfVIULCWxT6Xlvr1E0TnU3TdqvsrqBNeSzT4I90V5y/PwBec8gELRWLtQWWH8U2AbiPYzuYsJ3R5lTrEa0WE4zflFUnCSuFg0bJV76oIdXdvRGOad97I0fRw9EaFOuCAhz+yZHBGpfGUR3v4YVXARukb/P+6GNLBYZ6aYQvSfbUxBV2v/Ug0oPH8haniLEvTebLsZvOsqMYt9WvSXBAwKBo0AnoOa8cDSE4xYkSdOTW2LtGPBARkt69/zzCpooOawaVvzJB2cFqjK2wFIVjY5WbIiusIs/sXckb7LhSOLedjzqRW6MVkZizdDuga6XYX3d8PsrgHrWd4aBXvpdVT+mhfk1Gs9mCGDeP4oKYFZ/RGND4yvgmwmdfTkP6Cdke0oowgt55nlvqI0HSbA5Bfkd+FRR+xSPngAR1n2U7Tmtl5veudFaDuZrat7cui/nG1+EFTkuaEgpxItwucMofIAC7+CIVROB4toqs+diNqThLei0OBv5/8OpNU7nkdnmmlSJGwIBbVTrM5uM8tIg8O5JlwYDxx+EG9dvtLs+9iH6JkH63WrUMQFO2dAL70ldGL68yiXShgunXxecwfSBoBzkBaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199021)(4326008)(478600001)(82960400001)(66556008)(36756003)(66946007)(66476007)(5660300002)(8936002)(8676002)(86362001)(31696002)(2906002)(4744005)(316002)(41300700001)(38100700002)(83380400001)(2616005)(26005)(6512007)(6506007)(107886003)(53546011)(31686004)(186003)(6486002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGpVYklmRG5pVDBQN21FMHY4TE53SW8wMkd5RUdRQ09oVldnQ1o3aE5nTitS?=
 =?utf-8?B?Wi9qcDJ4ZjcvdUUvcWtIWFVwTk5xeEJBRVpvK3YzMng0bVdWVXZyVi9FTUI2?=
 =?utf-8?B?eXo2ZTVieDlGUTQzQ0J1YSt0VTZRYmYrMXNvdWYzZWtkRTBPeVZ3L2dOOG9C?=
 =?utf-8?B?MFMzcUdrS3pJNHExSktPcE1uRW92NTZ1dlUvZXYyY3F0Y0pxRXRBVlZHQW53?=
 =?utf-8?B?UVF0R3ZYV2lIYWFqdkIrWlJqWDBDejFrUDU5djBqRUFDMld6RU96bkRvbHha?=
 =?utf-8?B?NENQSG5hVXRLSHpwWUUzMDc5UFJ3L1FLdnVEZGR6OGR3NzNXTnZlSmRFaitG?=
 =?utf-8?B?OExzVnE5alZySHlKVkhSVWY0MHQ5Y2wwRFBhZkgvQktUNGNSZ3VGNHAwZitX?=
 =?utf-8?B?VXNYVTBLSmM0djlaOGFDKzZ1VjhVcGd3SytiQ2JvOWk3aWVnb2xHRjJiMXNs?=
 =?utf-8?B?UlNwcU83OW40Tk1KTDBCWi8xOGZUV0ltaE54RVU3T1VhSlZSK1Jsb2drUzAz?=
 =?utf-8?B?aE85bkFCQ0RMMHE4dEUreUY4LzgvbExtUXNkNzhFRGhibEV2UlhNRGxGb1hv?=
 =?utf-8?B?d1lSbG5sQkR2QmQvdUZMNkFBcG9nTHl1V1l1MU91V2V3ekVBa011OHFYNmdO?=
 =?utf-8?B?MldaUWIrMUNoS2lXcFhZWlpPb1hTL2dMdUZ6bll1UWJyM0o4ZnBwbFlGTkFq?=
 =?utf-8?B?NmJGQS9OYU9jV0Q0ZHpMc2xKWnVjZWozSG9HdFE5ci9laVhDY0sxZ3FkaEg4?=
 =?utf-8?B?UVVPS3hsWWVxd0lNQUNVb1BrVDU1ejBla0NnVytHZk5rMzh2c0Vpa3Z3Yklq?=
 =?utf-8?B?bzgzWGRZbGVpcm1WS25BKys4TWg0Rk02RmdrYXgvTU9VaFNOMFpqM21tV2Vl?=
 =?utf-8?B?YWd1VXNmQjFTaHpDQWZjWjhSdjVjK1R1QzdOZ0hpaTN3U3JSL2laaFh2NFRl?=
 =?utf-8?B?dG52TnlXL3hMRjhyazlSdVZlSU5vZ2l0ZXBOblBrY0lYM0xNZFhIblZ3RlpO?=
 =?utf-8?B?SVNnNkY4R3ZLNUpUbWJUbE4rM2d5cmdQQmI5OFZSc3NXY2lFZXRUL2J1WWFI?=
 =?utf-8?B?Q01qMEo5a3Y3VU1uQ1BkYlZaSitGM1dOQXJLVXFmK1pCNnA3aE5YaWlISExr?=
 =?utf-8?B?MWJEM1BzaEpEbDJ0SVZjUFU2aU1NS1pPYlFkTlRJL2cxNXRzMzVGK2RpMys0?=
 =?utf-8?B?VW85ZmZpbGw2RHpaWkVHdjN3S2RqRWlVT2VUK3dacGVpOC8yMzhtOGFtYXNa?=
 =?utf-8?B?S1FxT2VVTlFKQUdiSU9KTUptQ0FweUdXeG0zQWhzQ21aRWZSRG5rbWRQSmZp?=
 =?utf-8?B?WXhhekM5c1pSbG8rTW92TWUycjlJTmt3bTBzTkVkU2hTWjRINmNvUjluckVV?=
 =?utf-8?B?Y2phRkZXZlJtVUpORGppR01vRm80RmlZajNNcVZwandqdmRGMWJ2UnhtME0v?=
 =?utf-8?B?RS9VaDl2WUJpMVhvL1d4eDR6VW1sYkptcDE2MGVLcDFhaXp0WTc3WWIvUWhj?=
 =?utf-8?B?SVViSDNsdDkrY05aTFR5YjlvYnRMbkFxVFVEVnp6c1hHYVBIMDNTSmhnbWdy?=
 =?utf-8?B?eWZNZ21qZlUxU1JlQkc2SDZmNUtpMUx5NzhoWG0rYWRvWGJDVGMvUHVNcUc2?=
 =?utf-8?B?MnJZMUNKNE16WTZzOWR4bXh4a2hTMkw4MTFYYnVCZ0dsaktLTmVTTmJsVCtZ?=
 =?utf-8?B?UHYzdWUvMHUyV2kxc1phU0RCWEJBMVd2SGF5TWZGUWFEdzB0K1M5d1E1ZytE?=
 =?utf-8?B?VENCbURyMWJVZHZmL2Z3SmRNMFRBWUs2bWp1Z1RlMFdYdTFWTTFrRjN6MHFU?=
 =?utf-8?B?NklmelhVMnAzZklpUkNzclExYVYwaW5MZ1k0S3Z3SEMvSzVLVzdvL3J2ZEgy?=
 =?utf-8?B?NEFTdVBXUnhyQVo5L3E0aVlmZUZUSG9RbnZtLzNNaFJvUEtFQnBHWXQvZlV1?=
 =?utf-8?B?c0xqR1hDNkhJRjRud0VnTTZVVWdqeGNaMCttWkJKUlBrY202R3RMSjJ2ZGEw?=
 =?utf-8?B?WE1yM2lHR2FmQzZ1RVBGL3dOTE96c0RNMHo3M2JwaExmcFBFNTBXOTFtUXQr?=
 =?utf-8?B?KzB4K3BEMnc4S0dnK0NLTWRtVnh2b0dzM3lBaHR4SURkM3JBQ2tIK3g3ZTR2?=
 =?utf-8?B?dzBHNjQ0NzlHaVRHTFBzMDB0dTJvRlFtdkcrUGR2SnRjelUzYXJwdER5ZUc5?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8987473-31f6-457b-cbf7-08db6c0356e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 11:43:00.5367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWp8PP2EfpF81NzcJ6/d60iibq0WPV0eLcwQm/GBA3hGkjKLm7OT0ZTyaHpxOfzBvDSLp9p05OesZr57Ain6dri415uv48HBlMp0YoAk4TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8137
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/23 13:35, Maciej Fijalkowski wrote:
> ice_change_mtu() is currently using a separate ice_down() and ice_up()
> calls to reflect changed MTU. ice_down_up() serves this purpose, so do
> the refactoring here.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>


> ---
> 
> v1->v2:
> - avoid setting ICE_VSI_DOWN bit as ice_down_up() covers it [Przemek]
> 
>   drivers/net/ethernet/intel/ice/ice_main.c | 18 +++---------------
>   1 file changed, 3 insertions(+), 15 deletions(-)


