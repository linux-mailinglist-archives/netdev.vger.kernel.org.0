Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B213C696675
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjBNOUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjBNOUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:20:54 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856EBDD;
        Tue, 14 Feb 2023 06:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676384453; x=1707920453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9hiwyrx2LqfRcPSm9X6XvljQXozGQ5ZNl2mmHuX3cuw=;
  b=CgLYVrEKqG+EEW+T4vMDfmJGtniqTgWfrhvI+88VjbwEo0JCKgyUcdis
   7KYveZFWN5MDU2cuiya4DEefVShJb8kCjA1A9ih4aZBmrPFQ1mzMjBsbr
   GnnwJQep0DX+aw/6RKSQK72RNOMXyMj6fU1qDdMsr3DcPHbqwrUEU59xo
   FWggK7c90p2fdG90C+ze1Z6eMSWK/rZn0DRmZqFE+3kwjW03ZcGTw3EvI
   p2z3qOHFoDBX9IBsUV9BqqLLW3hmes+SZdFOQZHL6vz3FFsWg1LiU/mbl
   jH0C2KRdKPBt98ZouGg2g6Mpuwd5pHql2W6IobpARAlcKjutQs69mpqko
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331165861"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="331165861"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 06:20:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914755202"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="914755202"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 06:20:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 06:20:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 06:20:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 06:20:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAHIElFPO7Fpq5m7Q+EnZ0Jl40HRJYnOlmrRwY6I0a+oSxBXr6Y4e6PCgNSbIAmZo2StL8x5WyUMx4I5cPh8dtCPnd0Ow4lG3Q728BFNv4+5SI6wvo3KlVA6hbAfjUDNvLnfG/fnjX4cJzpXSdxv2z8xKhDp+i1ECux7/vhocd6eoXK3Zp9D3fnWBfH55MzxtHhvYJHN+9/gSTGvMre1y2r14NrBn34furZvNfxTBNFx+fka5EK9vJrxxKPRaR5CZP0eii14590IyLSsXh2pZ9YEUM/GQyzziOdAJ5butAuYoIW5rGKHqDpwBcpoBZdZaYqjBNoU2zLvm8VuNnBP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvEE85x5wmMGST0xvGLb1J+xpJeszXewHzTtunsVg1E=;
 b=jQDIdJ/io+b/HHmmRZuBBFIFP6gduBdh7UMOYeQ24YWikXTdq+hIgQGtnsVr+Q9E1N+YgsYIG5Jw84M81oeWvf63E+3DSIFLdhGZc+e/R7LNozip0lFtoJofveZm8LjxxkaWBovN2yxXBuvLTClurapOD05a56dOeDpd8XZWLebzkVf2x0E6CBzy9/EHXaJ/ZmcC+KT8rrhUFaBRflHUby3I49t5QXqht/Xx2cFcYk7O0101AouC0lGRrDGuzNhhjr+nWTbKMKH8uquksId0woZ76fFb0reW48QoV+rVRab3iF8jQn8GTvZxMpUI/CmD74PT8YtBzK2sDy6hzAptLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 14:20:50 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 14:20:50 +0000
Message-ID: <f2ba5752-cb22-47a9-0080-d2f978d0f45b@intel.com>
Date:   Tue, 14 Feb 2023 15:19:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [Intel-wired-lan] [PATCH] ethernet: ice: avoid gcc-9 integer
 overflow warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Martyna Szapar-Mudlaw" <martyna.szapar-mudlaw@linux.intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>
References: <20230214132002.1498163-1-arnd@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214132002.1498163-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0077.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SN7PR11MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 314909f6-3f4c-444a-7092-08db0e96ac11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qK4HJlk/Xynwgww05GZNPqLfAVbDBZhkUcY0WGcs+thPvBL+D15QUrSSHslA3f7Tfy7t03cwV4LR2UmHI4UIGvjFANiSbleO0/fPmPY9f2A1lj4lRXlxjwwFNMFZaHLxV348qAI/EBTsLTIZv0m3eejeJrwkQvOsQ81RtoQQSbDfUe+n4BhnBJF0JmSNy5HLqIPIgZdZ/DNTvuF5PD4v1Rjs18pbwsPintbkQJznrxclkkLtFqM85aFeCglVs08TZU0vfj2FR+GaV0drVvisOXXHK4uSU4bES5T72Nkw2vtAs7ka0LQXWZV04ijd9lP7IfZuG+pJZup5O0vX0Wl2EQEEiF81rXkeGLBfCs1OlAhEWv9qtkAOMvweFymTyoT+xHMW8oeTk7IHyzzsxmqsIHFjUCb3GDOfsSHGsL+mCUjU3HfqIu210dYvcHog+Zi4UBUS6oOuzLBl9oQvLNt9UPM2cqM04zp2Tuv03yFle3/uv9SF18T5pDPu7aiUikFxAmcqN0edLnQ0O0gHCcemmmZQGMV9oSgO9JjSy4sBWH6Ulkv86q6VMzVB2Vmmr2ybuVbJng+8bpytGiQwBhyRlTNWlqh73m5wRgJrBv0FoXOHZAA/WELDaraFACrATv23d0nDSYUbV/NLmlv9tMYBEFtR3XXOy5LqVb9mrCXsmjYH28J+c1rcaqX1E7r8hrz8QOAolBvyCjD0E5AU75K0h1gXgZFiuHwOkmHRAuSTpMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(7416002)(2616005)(83380400001)(36756003)(8936002)(54906003)(41300700001)(6486002)(86362001)(31696002)(82960400001)(478600001)(38100700002)(316002)(5660300002)(6666004)(6512007)(6916009)(8676002)(2906002)(66946007)(66476007)(66556008)(186003)(26005)(31686004)(4326008)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlFxcElWdGpsOFFQYXNOOHBKR0VVekRyZ1ZJMk9jNkxNWEtGWkVYOE55TldG?=
 =?utf-8?B?UzVIaHJaK0F4MTE5dTR5b1gwUVVMaC8vRVkwbWJCUHV2WTRSNWpIMUtsQWEw?=
 =?utf-8?B?U3plQU9CV1pWNW9LWTg4Y2JjSUZIOXI0R01HcmJ5RThVYzFUK2pDOUNKeW9N?=
 =?utf-8?B?QVU3WTNFS3huUUxmTFQxNmFtQmRZbDlXcUN3ckF0NGd0UUtBTURVeGFUbVVB?=
 =?utf-8?B?QTN5VG5BeVBTaHFEb0Nzbkd0ellUNkxTV0tJeVBYK0h6ajFwandqcHFTenlD?=
 =?utf-8?B?OGw4Sk4yeGpicXJrNURzU0Y3OVI4UlliOXgwNnZHby91MDNoNHZGU0wweTNR?=
 =?utf-8?B?a0MvKzQ4SFd4ZUY5SnBVSTErREw1cDREc3cwQzdKOWhxOTV0S1BFMlFwNEFY?=
 =?utf-8?B?M0k4M3lkbUIvNXFtVVV3cTFtN0Jhdzl2K0tRSDlBeWZmTkFVWDBFanZRajZp?=
 =?utf-8?B?cWdlYktRa0JIQ2FCRGdCYzBKcjdlRWZvSzZEZm5LK3VLYlJyamJMaVhKWUFl?=
 =?utf-8?B?TnFvMkJoUkFVQVRsQ2lQMTZLemZ2MC9FV3VqSnZORUcwc2pGaEZsa0Y0dHoy?=
 =?utf-8?B?Q21UcVpUREF5bHlNcmx1T0hRZFpvdDR4MFBTOFJEVWR3NXZUR0padjVLMVhD?=
 =?utf-8?B?d2pYcktrMmtjYUtyQm9kSEFGNHpEWGZTRVZ1STdDNUFhRUJWb2Nrek51RG5q?=
 =?utf-8?B?aUQ3SEVoeDJjT0hpaitNaTJ4UFhoNGp2Qmh3bTljT3JyTElJYUJ3UitiT1pZ?=
 =?utf-8?B?TE9SbXBYK1lOR2ltL1dqeVJwZnorTHZ6YkVzd01NVDhKTzM2NVVZa3lUMm53?=
 =?utf-8?B?V2x1SDQvK1R6b2phS1BidG15M2xVZHdjVTltMjVBSHV4RUtMcHNCZHcvZnFp?=
 =?utf-8?B?YzAvd2dWWTVSNVkvZEtoVURvaGhPMjJXL29nZ2sxdmxUbHVVSGxjbGU0MHNB?=
 =?utf-8?B?OVVKUittdHZjT1lDdEpEd3FzbTVqYis5SFJadDJicjhMb0tISE9WcUppT2Js?=
 =?utf-8?B?S1B5RDlPNmtRdW9TOUU0TGtZRjZaT1JWUWl4S1BESUY4c3NrS2tMQlk1NERC?=
 =?utf-8?B?WFp0OUhRczVSeHgrV3ZsQ05ZZmdaL0FCM090MkFIMzdxZU5qRnVNMWxSU1U5?=
 =?utf-8?B?QngyaFd0RjRBb0FkNnVWbzNEVHYwbjJBdHlveWpkT0dXY1ZFWnd1cXB6ODli?=
 =?utf-8?B?bncyNnd2THdTSE9Jcm8zdWh5cWVIS0VzQlgxMWo5NVN1MlJCcDRLUm5wQVo5?=
 =?utf-8?B?Vm00UFB6a1lGZ2dJOENZZ0EwRlNBVitmZGhLaHp6a1ZhRUQ2aEJKM2JXb05H?=
 =?utf-8?B?WWY1bEZZaWxvRmlzQU52bjFpaGsrN3RMSFVBeklMbExXUitmLzA2Zkg1U1VP?=
 =?utf-8?B?c2NWYVVxODF2TDhneDBYUHc0bk9DaThCa2Y1U1JQZmRxbGJlVVArMTNqZVZV?=
 =?utf-8?B?dEZQMFNhRzErVW14YTB6LzdwSU94SnZ2aFlhd3J5bzYyV2RXWWxWeHVQQUd2?=
 =?utf-8?B?WW5xV08wMit5OG5wd3oxdGFvTWxyTk90WW1wT0NCSWc5bGV2TVFHNXdNbE16?=
 =?utf-8?B?bTgxb0dham9hcjl6bmJiZFdaWU8yWFpGYmdpUzRtZDlCQlc4OFVtWnlsNGtM?=
 =?utf-8?B?MFhaUXJoeENEcXFrWUdJQlQ3cklYU0NzRzUzWFJZOUs3VENIMjNwRDY2a05X?=
 =?utf-8?B?bWt0TzI1dTZuQldHeU1QR2R3clZhZVlvZllpb2hUS2NtMlF0K052MmNBMm5t?=
 =?utf-8?B?VTVWUkpnZjlnYmRoSG9TL3ErUEtDZG5yTHA5WDhqMDhxTkJ0c1drVkZqZmxX?=
 =?utf-8?B?c3pkMDF0RGxiL1lvS0hFK1lLMG5mSm9kNWp4V3c0S3VXR1J6WDR1bkUrS05o?=
 =?utf-8?B?Z3dtVU9nUmdIQ2IxZEU4WGJINjZhRkd3L29hUkdDUGhXSWVZNW9ab0FWUVl3?=
 =?utf-8?B?cXY4MlMvdlQvYWpiWi9hTzY3TFhHKytTc2F2aEh3NlFtQWJXV0paMVJ1UzBH?=
 =?utf-8?B?bGp3Wk9jWTRKSWU1MjltODNlNzlKeTR5RFNnUEJtRExOTS9UQkEzM2tsQmJD?=
 =?utf-8?B?Lzg0ZjJuU2M2aVAxSFFJam9rdWVnSUw5bUw1dWZvSzZyNnFEY2Z6NUxZaGkx?=
 =?utf-8?B?RStOWUZXaWQxY2dyejFZYmVZTGJxTGlhbTNrYTBsdCtDQU8yL3VJTEpocG1E?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 314909f6-3f4c-444a-7092-08db0e96ac11
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 14:20:50.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiUnYNnVS1sbIiSR8ZYIUF85ktDMDR74txR9U/bARyiUK85Td/dsmtyK/+fWpuT3jVdACNpnxCullbu6Ib6p8uIhCbgXwHONJggJNHmtEUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7468
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 14 Feb 2023 14:19:49 +0100

> From: Arnd Bergmann <arnd@arndb.de>
> 
> With older compilers like gcc-9, the calculation of the vlan
> priority field causes a warning from the byteswap:
> 
> In file included from drivers/net/ethernet/intel/ice/ice_tc_lib.c:4:
> drivers/net/ethernet/intel/ice/ice_tc_lib.c: In function 'ice_parse_cls_flower':
> include/uapi/linux/swab.h:15:15: error: integer overflow in expression '(int)(short unsigned int)((int)match.key-><U67c8>.<U6698>.vlan_priority << 13) & 57344 & 255' of type 'int' results in '0' [-Werror=overflow]
>    15 |  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
>       |   ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
> include/uapi/linux/swab.h:106:2: note: in expansion of macro '___constant_swab16'
>   106 |  ___constant_swab16(x) :   \
>       |  ^~~~~~~~~~~~~~~~~~
> include/uapi/linux/byteorder/little_endian.h:42:43: note: in expansion of macro '__swab16'
>    42 | #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
>       |                                           ^~~~~~~~
> include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
>    96 | #define cpu_to_be16 __cpu_to_be16
>       |                     ^~~~~~~~~~~~~
> drivers/net/ethernet/intel/ice/ice_tc_lib.c:1458:5: note: in expansion of macro 'cpu_to_be16'
>  1458 |     cpu_to_be16((match.key->vlan_priority <<
>       |     ^~~~~~~~~~~
> 
> The code looks correct to me, so just avoid the warning by replacing
> the macro expansion with an intermediate variable.
> 
> Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")

Should it have "Fixes:" tag if the code itself is correct?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> index 6b48cbc049c6..e9932446185c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> @@ -1453,10 +1453,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
>  		}
>  
>  		if (match.mask->vlan_priority) {
> +			u16 prio = (match.key->vlan_priority << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;

Maybe just u32?

Also, I'd go for FIELD_PREP() here. Even be16_encode_bits(). Or does it
have the same problem on GCC 9?

			__be16 pri;

			pri = be16_encode_bits(match.key->vlan_priority,
					       VLAN_PRIO_MASK);
			headers->vlan_hdr.vlan_prio = pri;

But I suspect you (or somebody else) will say "please don't mix fixes
and improvements" :D Altho I'd go for this one if it silences the warning.

>  			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
> -			headers->vlan_hdr.vlan_prio =
> -				cpu_to_be16((match.key->vlan_priority <<
> -					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
> +			headers->vlan_hdr.vlan_prio = cpu_to_be16(prio);
>  		}
>  
>  		if (match.mask->vlan_tpid)
> @@ -1487,10 +1486,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
>  		}
>  
>  		if (match.mask->vlan_priority) {
> +			u16 prio = (match.key->vlan_priority << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
>  			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
> -			headers->cvlan_hdr.vlan_prio =
> -				cpu_to_be16((match.key->vlan_priority <<
> -					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
> +			headers->cvlan_hdr.vlan_prio = cpu_to_be16(prio);

^

>  		}
>  	}
> 

Thanks,
Olek

