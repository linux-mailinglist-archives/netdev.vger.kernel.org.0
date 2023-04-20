Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2B26E9808
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjDTPHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjDTPHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:07:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC0359C7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682003261; x=1713539261;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nK7ZmP50c1zLYy66pF4ud2pJDGWNX8WF97HrCI76msI=;
  b=EqkBX9ZNnKFrp0qjCHMXB/BxCvz8oOP4k3H8HJ8BcqTy480OSRq9gNX9
   4gnCw9liToTtYzs4BEK9hHG5vKsD40y4d+CoMORgG6wsXkE1CGSy9k2CR
   LvJGcPu3TlcPEFZS8ihLRiiT9RQbd0CNj9FG2DbvfyEJGFK/HYs3d3Hjr
   XoPDlrImNCU4HHU041BbxCxXNGxh3q8h+sxNyifnSKBLQ42bpH3lpMHSA
   djjEL8pl8j32T/XrsbWW+1Ifvyl1IsuniHqnxY1p796d25GN8SlCrKbrH
   ygCP8LX0cGubSyRJiCmuOi3cpiQth8ZF4N0oV16YQjffzF6Cnb2SIi+Gl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="325364375"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="325364375"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 08:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="694552477"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="694552477"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2023 08:07:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 08:07:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 08:07:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 08:07:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRE9+5KFA+RlJAXVSZtUQuPlaEwogG9Ti8LY5B0HTX0KhV/NH1eSd5cMI2bL7ZebPZ/6vCHTxBg2wmxqWX0lr9yBtRUnU54emZNWnu7m6biouKvoz6CkjtP9XJBCIoy9C/2ADkvAMMTW6h2n7SR+AzXWPVQwRS9i/tVUiuYVbh24FHEmhoKKhc//qEGz1vPEOcs+Au26rg8F/jKhdeyglK52x4ZnJQAs2c/tV2nshrYJ/kBYVVS3fgm2ZfXKzhGTGM8TBKnyRluPHjtgCZUAPWtck2AylI7ejUDhW3yqG4wGLcgzDqSQaopTr+Qs850EFk8+xNzOHxp1jHIKqUzP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbe8gdPCCDLMr9tMhmQcXyQLOW2v3kIx/SXc6s29sdg=;
 b=hQFUF9dXGW8SS2RWC4JsVmbpcUOJM7Wxx9VcglY8Rlaw+ae2lDihvGwceCgCjrsqFaPzfFbGPMEocdhGcGaP4hXdH+kiQFhGPxQp75WsMwqcSOD2HFWgCpz/32ednUPOWkl3FO+jcy8rHDp+Q10e9PeJUGiYJYoXaVYUBOW6mgsKPZFdMUDevnilxBcxCBD4GV47jedV0M1DALm+DX+vOeUutgQOEt36Pd8JOU0jJ/FBl6umuI6Fc0dJ+Js4timqjcL31NYzoym1OjBl1kVjoqOKLoUaLkEKNr9GBZK4qOablCjFkefabvo0sl2YjEeoFRACuG+bsJNKnYlEBDOpmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6966.namprd11.prod.outlook.com (2603:10b6:806:2bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:07:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:07:19 +0000
Message-ID: <862a1a97-22a7-bbea-486e-2171f47a2148@intel.com>
Date:   Thu, 20 Apr 2023 17:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: skbuff: update and rename
 __kfree_skb_defer()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230420020005.815854-1-kuba@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230420020005.815854-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: f3068933-a597-4066-4142-08db41b0efb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 23sHEIcYfy56AWKonKXdXHlrnkAc9WmT0/awD5Zdnm065dGhJvziFwG6sppNfWilCxmKMmK5rKg38jmAU1F2C1wxAf4fRAJsHBBxJZrvQJnW4NYiEWLCmBNZNGMDE2dXWA4AXUq2SWtxTUpZ8qtfDeWMhRXTdBv3qOu7p9tOuPQ0L6NQX+re4aTYJMZpMvjTcFkKUbqTuhavQKcQtX3BIqy9h0GkR0C2FGFXNqQrxl40VL2/8iCrzmMhodmDOnum2vws44lyBUrOFYmw4fGD1wopHz+EQWSaequzJSWxui6rOh15AguECi1KX+kIzR54Xho9TXvQ0Cj9lmxMqyEMEa9+7UZw06W7gqhA8gKpDfQKr0KETwzSEC4bp5isVuW+SrBDjQ0vAFVw1stwnT9Fgo80DXD1QgRDKxNuITAidwF/zCr7uaGLTbUVhNYi1gsPCK8uXA7JtN/2Nw3kS5E5gXkhK06GQ3t07iet6OK2APNQnA1p/VARUd60K20dYZmh6nUJJ2GhFs1NJlpisArpnwvkxjTDyvvNolvSoU+PmedbslSbdHcuOQ8Ai5VAVf7Mv49O843e29S8bpb+KlRLO0QcHv6eAWnIhVVZ3+8OrdHj0VNQ1R9vSQjq8UGVJYGwxQ9H5sW3MX6UgRQbcsrj5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(2906002)(8936002)(4744005)(38100700002)(8676002)(5660300002)(36756003)(86362001)(31696002)(6506007)(6486002)(6666004)(26005)(6512007)(478600001)(2616005)(31686004)(186003)(316002)(4326008)(66556008)(82960400001)(6916009)(66476007)(66946007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTVPVC8xcFRtSUhyeWs3MzNIMjBWTFJ4QWxQWDNLQWRKdE1QRHFRVEpVMlRw?=
 =?utf-8?B?UW94OXQ4cmU5aTdNU1RrMGhLVW9LclZDN1N0WGhZM2hmcFV3TVFXcEJOVHpS?=
 =?utf-8?B?QUVycWJOSWk5dmowZWMvZUVjcGd0bWxVMzJydThMYWJDK3lQU2ZkZFhJRzRO?=
 =?utf-8?B?WEhWRWFKWmJENFd4UzZvVkhtTSt2L2pHalN0L3d5NTdIaWsxaE9jOElMZFlG?=
 =?utf-8?B?ZUpTdm1SQ2ZEWjBmd0RKTFZsTjZIc09yM1kyMTNaL1VCWlFTVXVlREVqYVJF?=
 =?utf-8?B?QlhzTW9UUkZNSTVCTTVRZTBRbkNjMDY4Z25NNmxldUFCcmVkc0ZEWTduQkhQ?=
 =?utf-8?B?Q2pJMmQzeXVJSmViUWkwMUNPR2o2S2xXTm1uK0o5cGV4YkRjOFlqb2p4QVBG?=
 =?utf-8?B?U0N2SUFzWVI1eW1HNlBleDFoTE0wNkF6M3oyakw1Yjg3bkpVY2hzODJ1ZWFl?=
 =?utf-8?B?RlRMcWFUL0VDMCthSkZ4TEdvblRFNHNrbU9vb2k4NklHaHZ2UEM2K1RHcWgx?=
 =?utf-8?B?ejBwTDZjU3dSVnJ5UGN2QTU3SGRyNUluMDM0M0ozSHhGK3RMUTljZWZXNHg1?=
 =?utf-8?B?RDVaci82WUd0eTNTWEJGY0hCZktCaHNwbitpYzluYlJ5T3ZwNnZJMGN2dUp4?=
 =?utf-8?B?N095cGpIMTdQWVdVcU5xTlNJQnVmVE1VcGt2TStHNGt0cHMrbStyekFpTzBE?=
 =?utf-8?B?MjRFTWFrRGpoU0VzZkowNlE2YmdzSG1mUUNDOGhqTXNwQXVwVVgrQ2FmcEly?=
 =?utf-8?B?Rm91QUNneTRUTkVQVStHZG9acExOc0lNKzk2MzU5T05RcVcvSzRFRlE3bnhl?=
 =?utf-8?B?YWdKWFhkT3BEQTF5VUpQMHJMa3hqUkhhbHl5aUJpR21naWtlM1d4MG1yclJM?=
 =?utf-8?B?WmtJZGx2TElqV1VQZ0RUZXNCa2R2M3F0MUp0ZUgxSTMvK21RSXZzdVk3Z29X?=
 =?utf-8?B?MSt4eXlodVZ5WGZodElGbDdJakRpbTBZbFlCTDdMZ0U3WVdHb0d1NFJrNFg2?=
 =?utf-8?B?cUN3NGNPVThGeUFWZkY1MWQ0TGNjYjlQZU5qYll5dTNGTUU0dFJRZmVOQy9m?=
 =?utf-8?B?R051aHRNa28xWHlDQ2pNa0tRYy9nZ1pYZWRzYTNjNHdHd3dWd2g2aWhqQk5G?=
 =?utf-8?B?SDhmQmcxNVRndGJ5bDVKS2oxM0tFUG5FSGQ5RmhJelBYZ0t2bjRESW4rM3VP?=
 =?utf-8?B?M2dNNmM5Sms3aHd6RTlhZDZLLzJ1TUIycDE4RnJwMGhRcDAxZmI0VzFFVW83?=
 =?utf-8?B?K0VMcUFyZVFiMnU0NWpLM1NnTTgxaFptREh1blBGYTVDSVpWd0RuZG9FUi9z?=
 =?utf-8?B?NmdXN1FiQ3RtZTlnbG9hMVFoSWpLQmUwMi9VaSs1d3QxTWRRRERlTTdJSFpv?=
 =?utf-8?B?OGFGOGFQdUt0Z3FpVFhQYmZNSkN1dTVFWjRBamNOQmtnUmY4Mk5CUkZXQUU1?=
 =?utf-8?B?UlRKMTBnVkVaMU80UHR4MWFrdzlZTUxUMmhtOGZDVkFORWFEVHhHMnFFcXJB?=
 =?utf-8?B?eEFIMDVKRVR3OHdpSXE0c2ZOb1QwM0JBYmp6NkV3WWNaOFRJejJUZkpGV1lp?=
 =?utf-8?B?L3Zodmo3NnBLZ2pWNDJIRjdXZWVNSkJDc0FxMGwwQVVDT2lxRkNrQVR5UXRp?=
 =?utf-8?B?a3c0dFNxM1p1NnluYXJoWnNCNmdVRjRTOHhaaS95UEVOcW9EN3A5WFlFckF0?=
 =?utf-8?B?RGp1UnRmaW1FWEFJanhsUjY1dDBXbWErV1BoUTBNdUJITlJOR3F5RlVjeVZH?=
 =?utf-8?B?R3MvV2xmNkVJRzEvOWJCbHdmKzRnUERKNkgvcENqSHNRMnNLWVdMaWM0ZDFj?=
 =?utf-8?B?RTZzWmYvd01wb0lSWTFMWXNMYTVlMEI3Vzlrbmk1RE4vdi9CV3NvbHYwUVB3?=
 =?utf-8?B?ZnBSMWlBaFZESXdiZ3hYN1BmSGJ6cGhYL29zckI5U25BOXM4TVNZbTRIUFI5?=
 =?utf-8?B?SXBjbEVhZnFOcVhSUXJKMUFtaGErVGFSWDUxTVVqM3BVTjZrNWYrZytScGhk?=
 =?utf-8?B?VVBibU4rMVYxYlE0VjlRaTUvS2lvYmFDNXkyTkdUZWFyQ3lHRHl1WVR0YjIv?=
 =?utf-8?B?ZEl0SDFXWEN2Wjhzd2c1V25hTFg2YzNGOU9xZDNxYVZmdld0TFNQc1Znc3Nx?=
 =?utf-8?B?QmJTTXFrTldYN1cvaHo4VzBrMGZuQTVSWnJHQWJPK215ZFIyaldqZEdNZGdD?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3068933-a597-4066-4142-08db41b0efb7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:07:19.8322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13Dt9Y9LQMaEpu5lJASwnUxz5puNF7zcJuoL1RoLPhNTJW1Jmi9ZESAwfGsOFlzpcrzYLZKuc1ItVl2ErgAG7/xVTXvSTml9Rmommq68vWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6966
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 19 Apr 2023 19:00:05 -0700

> __kfree_skb_defer() uses the old naming where "defer" meant
> slab bulk free/alloc APIs. In the meantime we also made
> __kfree_skb_defer() feed the per-NAPI skb cache, which
> implies bulk APIs. So take away the 'defer' and add 'napi'.
> 
> While at it add a drop reason. This only matters on the
> tx_action path, if the skb has a frag_list. But getting
> rid of a SKB_DROP_REASON_NOT_SPECIFIED seems like a net
> benefit so why not.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

[...]

Thanks,
Olek
