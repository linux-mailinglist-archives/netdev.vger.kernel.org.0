Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB005672A67
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjARVZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjARVZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:25:48 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DAB654D5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077137; x=1705613137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/4H35n04JqOzOJCDPxwQBojogW+cGiuA3NvNMPn526o=;
  b=PSEYNV+R7dMfR+QJS0noENOG6SkFdUdjgJKkuk7nIrXC04SIGjP3pKsk
   NKdXVsapI82SQ1p1doNopLkqkXHc1dLg1crHKUNaJmFvOVh/O/IY0ViSX
   PSy9rog88KAhDH1IzMY23dJtJmCrIZd7lmpQpVTuQSn5jy+3bOecUF2j6
   2XL7O6UB9EAAfr3ehCe1MiLwNF8/4LGGOEBzSwIyDhp5BV6tBWZU4aJYd
   qg4fxnYYPL/SZXymR1boL5JzI9rhhK8DhL29JG4WiHdy+WOo8tkKyPgG+
   6t6XEVSEu5+pLaLbtlvrNY+1DQxq2giB/Zd6mrK7f/yg2/l5pV4Sg1eJd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="389602549"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="389602549"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:25:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692172959"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="692172959"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 18 Jan 2023 13:25:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:25:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:25:36 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:25:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAm8zBybZGOswa5J/w5YVj9tyXiYo6kATDdyjWE0x+0ptaE4sYheaGhVD+9E9y47Jegq7qTzT7cxjmcbkJvKL8r2AWeoFZjsyRQGjH/mQmBYL1Xnz7wVzwqmZfAH/9Q++1cj4hrzeRQqBO6fptQJ7eogHe+Dy3VHy7tgvzX7JhdH3oqFHg0MnnGFnO7h3A5JaygoeFrB5KS2e/YgykclQhPjksrOEy9pi3qAA2fCdI6I0nyxNjSES9nGPqqWUY/m1TyOD7qIERlMKtq10hsUN2sxnB7d6EyWmYtgzVNBwr3Q87OTCFDnX5PKVw0halAIfGyLW9ro1bnz+qwGBbz93A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Iqx/34T+jwSkJR+BEogfL2XVgBFGiKJab4oOu12SIQ=;
 b=gTGoGrIKJOQO1wSors4IJ3ks669Uq5ifco7Ly9/tALIpsOs2widM3XcwaohJHhY4YdLjamAVOGlzZ8rSWtGfdvJSAc10RwSfsBYJiRJIsBP60JwPoyJcv1JNNVszLj0CuLAETWZ9GXVkc/gjAhuw7xgizoT5nVOoBGW49HA90XYjtRVhOAbLzjluz8dXpvCRvHn+tBCqLH2VAyaEZsJMzbqoZFKKT3RMDakglTfAyhpX10gfZ/Y/+93U0Mn0JSDCsySeEaYHPiveZ3H2HbZzTtwk+35Br04lGidDbebhuWXCe+GO1S+3xeWqikffT9RuheDbdXzQvix7xE6qToRNqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA0PR11MB7356.namprd11.prod.outlook.com (2603:10b6:208:432::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 21:25:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:25:28 +0000
Message-ID: <a7fe0a12-2686-dcd1-79e5-094a55d6a0a4@intel.com>
Date:   Wed, 18 Jan 2023 13:25:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v5 12/12] devlink: add instance lock assertion in
 devl_is_registered()
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <michael.chan@broadcom.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>, <leon@kernel.org>,
        <idosch@nvidia.com>, <petrm@nvidia.com>,
        <mailhol.vincent@wanadoo.fr>, <gal@nvidia.com>
References: <20230118152115.1113149-1-jiri@resnulli.us>
 <20230118152115.1113149-13-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118152115.1113149-13-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::35) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA0PR11MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c28fedc-0f3c-4d58-e95f-08daf99a84fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+7JtLAKHhFQrIj7DUSe8eCZ6PORVAhVfdY4zBRNmdl78OWPjN4u903z0BmdUusAq1j3qogKRwimbND2irwxtnv2tymvkl9lzFMONpfy5UbHwmeHS7SbTvvDAdyilEKSyuEctssEi9wB9BujGEKXqCfu+b/vrRWXj/mcSRrX/wqXnnfncDrK8xVt000vmBXrT6uUPlN3znMlgxeJwSGTh8asfierwSIwh/2d5EMYgP8OCtsFa3P2osrmB4lYP3AgTiF1THYor6w8+tAa6Sk05qkk5WRq8gV0nEGBWMaigNNtETX8xY7ME27ka2p7xqELnkl8SnyQmu/AEsnoL6YqGwloYjDtmN+gHfwaOyXs6O3U6UHgHNvoZaT+BZGF4IpkJWwxfbU9eFDFutKH5f0vdMYXe9605NJMwvNFaEZ5NGI6FwgcEEUGmuNzGigXXggvl3JZ3sOkUodoxj48X4SnhsBxrX8hbQVXeRVHHtqNKOhrsf0Bd1k9WtpqLRKD/qG3Mf7OFjrtt84ulyg9Pfpa1P6Ce+TclZVPts5xRMSjT7jubNt88MWf9PI0Yr2isTz279pYQHwvCAyZq6xmWoyLitqkApzBtQ2Cwwlk6SPiJLO7ClEV4gtd0fws5oYCkI1Lq2kzBO5awS9Gtm4ioBK6swtJYzUch1vxWGu++N+sM2CcozKG2H3fUQ7RypSun4mgCF9gJ90J3JyBEtjafG4MpRV2HaOur6Tb/wzWqWX6Gko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199015)(2616005)(6666004)(6512007)(6506007)(8676002)(66476007)(66946007)(66556008)(4326008)(478600001)(186003)(6486002)(26005)(41300700001)(83380400001)(7416002)(5660300002)(8936002)(4744005)(2906002)(38100700002)(82960400001)(86362001)(53546011)(31696002)(316002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnV3cEZFWERmTDI2bWNQSUF0dlYrZkFnc3lEaUFuaFFEOXNEWWtzQlJPVzlG?=
 =?utf-8?B?NVBpYkV3QlJxMzdvYTJpWlM1eHFrQUtMNFpzZTA2bVdNbytBb0hxbjRGVEM0?=
 =?utf-8?B?NW93OGkrRXVGT2QwU08wdUFDeDZEamxJOUdPUGVCdnFSNkVnVFU2VlRuelJU?=
 =?utf-8?B?bTZRSytsWHNxZXFFdm1iV0VJblhFeElGeHJZd1JZTm55ZGF1KytPcWJMWHQv?=
 =?utf-8?B?NkF2ZUhxUmk4T2NRaDFXQklYTDRtaWJpdzNJRVVIVXJzN1hSMUJzWENVRndI?=
 =?utf-8?B?cGZuVTlrNzh4QmdGWVU1SXc4bTZDbHhVV2tvTjluR2VrOHdpREx0QlRqdFhu?=
 =?utf-8?B?NjVpRitwQjVKYkJNRWtoSlN4NEJwL1pNc3locXBjVisxbWNGTUVqWUw3bFZ4?=
 =?utf-8?B?Q210NWsyTTdyc2dZZ3kyZjBIbmRpazdlUFRVdG8rbW5kQWhhWFg3SE5PV2d0?=
 =?utf-8?B?Tzkxdk1YbERmYVlZSVUzajdwb3JJOWFkYjlFQndRVDBuK0QwaXhYNkpPcFhh?=
 =?utf-8?B?WXg3YXN6alppelAxMDRGb3ZTb21kdzhMNkVxK1l6QzRPNFYyc3hyMkdFZGdR?=
 =?utf-8?B?WmlIZi9EeGw1d0lxbjFUTDM4cjdUbGVEQllVT0x2WEhpYjhTU2tPSEVOZkpP?=
 =?utf-8?B?dy94SXdDa083bmRpL1VHd2pjdlJESnNkYjUwbHdPTFlXV2NxeEpKNUJoZFlm?=
 =?utf-8?B?RGx3TStLeGpnZ3JXaW0wUXBZcDhxNHRmRW5jdWg1bHpwZXR3RHpiRm5TNEpH?=
 =?utf-8?B?cU5DQ1pMd1JwTGxvZFROSmIrcm9BWEdyUFhYRktVUFlyK2hDQlJDU1Q5MXRD?=
 =?utf-8?B?SEtaMmgrMVJNMU1OcWg5ckJYWUNOZzBCWjZieHNDcEZIVjBHYkJoYzhibHRh?=
 =?utf-8?B?TEdjM0NMbzd6VFk2VXp5SjE0Uk1ZOXVVdlFMMmcvZTZXRDNBdmE0QnBieEg5?=
 =?utf-8?B?b09EYThEdnBaV0xXWkNBa3IyU0h2SENIMG5rcDMwU09wL3FSc29NWks4Zm0r?=
 =?utf-8?B?eGdkZDBtK3YvamtqeGUxclhQQTFYNE1lT2Y1ZU81Uytwd2tNVmVRYXVKUDJv?=
 =?utf-8?B?V0c1SDMwT1owTUxBSXNlMkplaVNSV2I0V0VEY1h4V3RJNGh6aWhuYURzUXkz?=
 =?utf-8?B?cW42V3Q2ZXFsbHBWVkZWZERoQWhJRkxSdHlvYlBqQ2lxaGhSd2k0cmpzQ2sy?=
 =?utf-8?B?Z1h3MEsrQ3FSbURTUnRSdHE4NUR3MCswUzhYeDNTcTh4elVvd2ZLY0VIUW4z?=
 =?utf-8?B?SWoxSk1aOXhvQkx3VDNYQk5BS2RKN1FiT29lSjRhaUlZTU15S1hKWW5TNHpX?=
 =?utf-8?B?TFBkSFZyaGh0RkErbTZhb3NHMkNZcVM0UnFRRWF6VG4veWlKMUxuU3l6S1Rw?=
 =?utf-8?B?YzlHM0h3b29sdmVEdzk4ZmZWRFo2Y09VcU1zWUNXeUppMlIxRnNkUGIydzds?=
 =?utf-8?B?RCthek1veDMwZmU1MFRRcncvY3JZUlNScUhlOTIzcUJCbHpEM3lhN0tOc29u?=
 =?utf-8?B?MnlhSyt5MWExMUJIdlQ1Y3Z0NEFHb3g0RlVLdWpvRmt0LzNlQU5zQVFoSEMv?=
 =?utf-8?B?NmdDV01nUmhKS3JRdVhJNmpBQ3FwbTg1d01HQWo1bVhsOVZ0Q08xejFKamNo?=
 =?utf-8?B?bUFlclptZXNrL1R2L0xUMW0wUDZBSzlkaFg1azFaT3llM3FoZkw0YjlVU1p2?=
 =?utf-8?B?Zjd2NVlOdVlaR091SExueGFudCtPeW5RZWIwSVNIOGdNUC90UHJ4bWJFcmtY?=
 =?utf-8?B?SFF4enJ0cjQ1ZkVlQzZ2ZFRTbVozK280elhMSG93K2JkVE10Z0Vwa0ZXRk5h?=
 =?utf-8?B?Q3VCN2RPTnlGeXYyUVIwTGV1ZVhOZnRrOVNVd3FMZVFWL3FCa3oyZHU3dDQ0?=
 =?utf-8?B?UUJJMVQ3YlJCVlQ4NWlUTGlNR3FGQVNjYUJFcURsUTZhNXZtMlQ2cEZwZHl1?=
 =?utf-8?B?T1lqb3pEMjFob2NFbTh4bm90T0RBMExXQWpyS1YxaGo0YUtqdm83UVRHM3Av?=
 =?utf-8?B?V0U0L1BRVkJxZzdwUGNzSlIzWFJwNnU3c0owV2F1Z0hoeXQvSlFNT0t1RFNr?=
 =?utf-8?B?aTR1Y0tHSmZ2cGhiZ2dBdDRDbGdUeTdlOCtDQkFxVUs0elBPMUtVczVFTHBu?=
 =?utf-8?B?R2Nnb3RXbVpISjRaNXRjM3Q3VlU0SElpSFFPZitZSGE1K3N4emxxSGgwV1BO?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c28fedc-0f3c-4d58-e95f-08daf99a84fe
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:25:27.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k93eHx9NOruzv/WM67K21IZrP9YxqRs0xr6PcAntEYMpckUUWCIeLHPpYZUV1iD3FV+I7RJFu+MpdUBtueCspSataRwd35MNQuE/y3quHv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7356
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 7:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> After region and linecard lock removals, this helper is always supposed
> to be called with instance lock held. So put the assertion here and
> remove the comment which is no longer accurate.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
