Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9F53980F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiEaUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiEaUgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:36:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B178994E5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654029383; x=1685565383;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YQ3nqDm8FWinTO1YZWdYhmVi046hI3Lo+WPFYKdAgJw=;
  b=g5FD0hkJ5roijIf5/TIUeAnx5RQ/Do67hFkvtWLdYPvV9euw8bMTd+Du
   arQsuiA4l0fb/J7bmSMypLnshMNRb37gktt+kndQZpIc/8BnkpL3kfHL5
   oLCs/snJ2oHizDhO59Jp9Z2+UtIlgIiTPzaOzOdEtNxbgPlRjjfX+mAgR
   /YraUVpzhXzoQ6X2zF6rpLB/lKkn3W5ht9f3IoXu1/HQ9S34Fao1TOkgb
   gmvz3Ty+NPBfCDbl/EKBZ7kJ63RC7agAxM00UmyCr8+fvQr0Wb4eRIT5X
   axUAVmBwX87+Op8EHDKuiOkQKW2m4WajT3X+2C5MLXQ7IuG8UGUyvgFbC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="275384364"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="275384364"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 13:36:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="612001650"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 31 May 2022 13:36:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 31 May 2022 13:36:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 31 May 2022 13:36:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 31 May 2022 13:36:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 31 May 2022 13:36:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LH9rlLB4Y1wg3dtpdccB1dwA/Dywlsmu11uDQPZLCU8KIb7h3sr2AmShuVpifBBBtbW9kAwnbCvqn211pGTCSWztFq4OeV+FRCoJx8sGVweVJSSvO0l8+PJ8OQHvXpLlC9QmGqSvmgiMMWXMKQ91plKht5UEtO1oUjIpqMzv0IhaZx5ZI54MS9ZVWmgcKqfri1Ftafg+TaIJ4OZVyjHnZvnnMHvV9DHdC3MRBExRcyL9APXTfqYcxhS6WElfxPy7Y0r7t/jFmKkONILihMyTZN4JuxSruBWqx/QvvThQZkBtf07xfOABF4Yyh06uDv81lLMLhB0SdgFjfnFLPynbyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=na3F4MyGoFKfMzJMMFsTgoh0TNYLQax4K0gISvkn10w=;
 b=XwltXzJE15HTJ3XfsXh5433CmaIPD4AoFs+coBudAoaLTT9vKYJlJSFQss0uR5oTKLdKjq2hGgT7rjD07VkwBfq+6hemj6nVQzq0DP8ILiv/5hMlu3bZ0oWarkgUm8PuZ0IwXW+DImXeCY/ezdBEAdzrHGyVZIXu1S4sSWiA37ViqedQwXgzOh3n85h4r0+vr12ZSbyWaeH5OWEHjsQCLyvxPFQRVZqFuC8wPuRi5hgtkoq67svHY2+Fxlw0bIw1JaH1xjI96GK7XkwngHF9SensWMaDl7n91TXuWT2KIHB9wt2oBJ14JT9qqwYU+N2rWV0zoZq09Qn0kz8S+CAE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN8PR11MB3827.namprd11.prod.outlook.com (2603:10b6:408:90::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 20:36:17 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::317d:11f9:2381:a3a3%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 20:36:17 +0000
Message-ID: <15b0507f-c810-8a75-e883-b23313a7badd@intel.com>
Date:   Tue, 31 May 2022 13:36:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3] igb_main: Assign random MAC address instead of fail in
 case of invalid one
Content-Language: en-US
To:     Lixue Liang <lianglixuehao@126.com>, <pmenzel@molgen.mpg.de>
CC:     <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <kuba@kernel.org>, <lianglixue@greatwall.com.cn>,
        <netdev@vger.kernel.org>
References: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
 <20220530105834.97175-1-lianglixuehao@126.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220530105834.97175-1-lianglixuehao@126.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:300:12b::15) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d6d6af2-4170-459b-3fc5-08da4345366e
X-MS-TrafficTypeDiagnostic: BN8PR11MB3827:EE_
X-Microsoft-Antispam-PRVS: <BN8PR11MB38273E911F00F71A752D0BB4C6DC9@BN8PR11MB3827.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWCuGXl+xl9g131LGLyPRBwtWl3iA4bilc1TRclwdZ2f7dZCLyZEUJYvhzJNBjHWDcOkCysBWHxb41nsPyUuZpIGNyIDYoEVyrCJTSUPcBVQtKAc0nnTEhA93xs9DWU3RjEkZNEUvhhTBgnF9/l0hh9xPtOs6yvFN4OOWYcH2YxDCXNzvo+++HOIsBJG0DOqgYWrgFxWuYditXt9/RkcNDO1rU4pa8mMp2bMTX/7DFwkn4V3feiPTJgAOGTby9/pGw2FE/YD8UOY+CYTFP3A2/hXX4O8VJSDPqQT/71Xb+y1mbYLtouLq0yhsR8SmR62Y2ZZBPqLGO4fbnrFyrz2UNEjsaSH2loXY865nq4yG2t1c/2lPUSCRDSMJOYqO4p549Pest4HfZeL03SoWHSlHBN8Q5jKwngyAGr4uVzmLWNpg2+muE8X8v17i3B9BQ3XcxxQ1sVHiL6TC2rGvWa81PsEN3Ze2aelMiqi/Gt1sAp9gX4woff+3Mz7COz0FodoDbqK2bQlPzE7pQKbpGhB018XLYwHYXhjLpybobHBtyQKmmIwe5cqfhZS8vtUtgD2Zci5mIzjfeyrZjA9ToSvisNpdJDvGHUllkStNrutk8a2BmljQtpnlaIDPL6vPlRQHrXln7pk9DCCTz0aYb5WjFQOs8GEalaPuUtHPecYeshY4bqV7Vi/UXJOI48dUs3AvW6pXcf36xDQft0XWHlNVEYquEQM4ScoSxY1S5JeY7tikzORCpGDpDHM0dCHYFEVxFwZFMgKLDnJPsdYg5sa6jnxpAvhN7fvmfPGU+MRNolKbIu1oy5IUJM7Gnaz4qPR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(316002)(31686004)(2906002)(6506007)(26005)(6512007)(36756003)(82960400001)(83380400001)(31696002)(4326008)(8936002)(2616005)(66946007)(86362001)(38100700002)(5660300002)(8676002)(66476007)(66556008)(508600001)(966005)(6486002)(186003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TCtIODQvRm9CSWZCRnA0L2psTmpmU1Z0QXdpUTlqWExaNEZwaWdaUFBoS3Mx?=
 =?utf-8?B?WnF6L1hqOVA3d1JOZDU0VHA4S0NBWnQ3V1U2eHQ3bEN1WTVEeXFrZnhFOFp6?=
 =?utf-8?B?SVVyNWtxcThEblRiVklYUjgwOVk1bVZQamJjL1Fad00zc0x2TkxjekdqODJh?=
 =?utf-8?B?RUNTRU8yNGtUZVVLQUdjTnBBNXVObUJPcGFYS2VHQmZZbXREbjNVekdRcDFz?=
 =?utf-8?B?akNNM1pwSnpPWWE1ZUxqbXczSDRUbnRZR0hubHdteEZyTGEwYjFZUnpiZTIr?=
 =?utf-8?B?RTBEUm1ZckRyTzkxZkczM29CcUJPVXlWTUpnbGZWMjNCSXFLbkRTY2IwNlVO?=
 =?utf-8?B?NVJVM3NTdTh2T3hzN3phN2w5ajZkUEFDQWFnUUJyOEJVcGRJendOY3Y1NlVq?=
 =?utf-8?B?OUZaZHRuTnFSNkxYZmlNSmVpUFNUZzVPZmc5SjJYNzM5NE43dHBjQmVuU2VD?=
 =?utf-8?B?NG82Zi91aGVEUHk0SHVVYWFGSlZ1aVNiNUJFSHNtVnlyK0RwWEVOaTFIVzZJ?=
 =?utf-8?B?Z2ZRZ2UvZ2Nmd09xNUU2RzdXNUJ0L2tYSXhOZnNDYjRmb1B1YjB6U3gxaXNQ?=
 =?utf-8?B?ME52QmRIOE9YZXI5QXZBTUFMcTRDRS9pY01EU3VaaDd3dnpYVzllejlqUlIx?=
 =?utf-8?B?eDloSEI2SnZMbzNibFgvbTFsd1l0Q1RWcUFNVENNMXVmWDd5ekhRNUY0ZkRi?=
 =?utf-8?B?NXRLalYrQWgvUjFXZFVjSEdmWG9TbWphbHc1N1lZUlZvSm80Y0ZKNDlMWktK?=
 =?utf-8?B?V1h1YkFRVzhUQmJ1V3U4VEMyRVZ3K0srMkV6ZTI3UVVOYk1yOWJyQ3dXRisr?=
 =?utf-8?B?RUo5b1Z0RkozNDRZZ05pdm9yKzlNVmcwbWxFc3FNWmtPTFpqaEVBWmtqYnFN?=
 =?utf-8?B?ZW85eTRUR3lKNEFYdUtJSUVobmdXdE40Y3Uxb1p6WXloZWtYcUUxRDhTdStw?=
 =?utf-8?B?S3pnYWZQYVZ1Tk1ZbVVKRGdJdllYd3pTR3ZJTGIxYVJwc0hyQlJYSGxnQWxO?=
 =?utf-8?B?OFNyQ2FtTlB3N1B1V29vcnNOOHc0Ymw0TDBJUmNCaS94TGFZbzZFR1VFY3Za?=
 =?utf-8?B?bGY1aFpabmpxRiszOTNhQVJmWDd0ZitRUWdFQnppVEV5Tm1nYTRmdmxGWUNV?=
 =?utf-8?B?OUduSFJPWG5pV3ZSam0rYWVoL2QyQ1VVNE56WStET0ZuUXZxdmkrS3h5MTZB?=
 =?utf-8?B?dFhSVzliVVFBc3RrenZRejAxYW84WDhobWRwMi93Mlc0WXEwQktVRVpZTHNn?=
 =?utf-8?B?U3NmK2h4VXF1aVNGcWRnT0YvMzdOMkRBd3l3OEYrNktUQ29QK3o0UDM0STdo?=
 =?utf-8?B?TGEzUkM1c0JVa1FZWWM2TndtTlFYTFNTbVhFQkgwZjNSZitQU0hNU3J5WndN?=
 =?utf-8?B?WFpDMDNzOUVocE80WFg5NFo0ODFWMXpMTWEraWxsT083dlhCUUtiYlZWWmI0?=
 =?utf-8?B?MTJmWm9hQ1lwUzVTdU9Lblo5QlgwN2RpUnU4YS92YldNRUJMdmpxUU9TRFVG?=
 =?utf-8?B?NHUzWGxwRHI0UWRUd0NHRGo0TDRvc3JJRVRkRjBaVU9OVTlUM3NoSEVMZDdp?=
 =?utf-8?B?WlFqWFNiOHRoK0syVUhYMGpwUnBGR3dYc0NxVzRpNVpLZ3ZHb2RqL1A4Q0JH?=
 =?utf-8?B?VGFSNzB4TU1MVlQ5OEFJRWwzOVhhWlYyZ3o3NUFwWUNBQTZrT2RNTklBOXMz?=
 =?utf-8?B?cXRvbS9JeVo0MkNzMnA2NFA4UzB2MkZ2THhOMTVWK2lwZlpKTnZTSm1nUTBr?=
 =?utf-8?B?bDBjUy8wMVVuRXExN0hKcitxWXRzTnFkTE5pRVVCZzNmeUlsUjY3dlFyZFdl?=
 =?utf-8?B?dVl3Q2Yrc0tRWjViUUoySG1zcFVveW1lbVBKNHNjYlQ5ZG1iTjBXRzN6Z2lG?=
 =?utf-8?B?ejZLaWZRaU9qd1ROVENmUjRlOG9JUHpPTG5XeGJOSEJ6bzlCY3hWWGRSNjhU?=
 =?utf-8?B?K3RPNElzSmZPUDJWMkk5bE1wa3pTL0IvUzhIOGFSUnFxUXNsbzJXOG1WRXBK?=
 =?utf-8?B?dzZIanM2b1BTUHBLQjQvNFc4ZkRyZGFYZHI4NXptTnBVaGw2a29kVWRzdldM?=
 =?utf-8?B?aFB1c3BIOXpxLzlNcnRjM0ZTY3gwejM2ekM1ZEwyTjRxYzFaeENhTit2SG00?=
 =?utf-8?B?dEY4cWtOMFVlU1MxdStoNzBoc2tCNVBTdVQ2M0JjdndabllIWjZFL2s5YUc4?=
 =?utf-8?B?RWRwYm16czlQdFFxU293bUgwZDhWVXhodEdZUFZYMVlVeHpicEZ4WTFSZG1k?=
 =?utf-8?B?T1FIUUl5aHVROUNweGRYS1ExNjhHcGhEdTNvcGhJd1BnM2prTFB2ZmRwbG5t?=
 =?utf-8?B?MUFlMThTdUlva0syU1pNVFVXdjBFcjhSWFlQQWdLREMveWNWeXU4TlFKT2p4?=
 =?utf-8?Q?Xlu8VuhsABWPmZIo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6d6af2-4170-459b-3fc5-08da4345366e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 20:36:17.3064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jotycwhQOEuJxj3Ea/zXcqyZdiBVGAuj+Eqb6UhpWnlrDtjYEwfInOE5+aWtgldLzfgcMHqM0Ut/d9pB738pghW8LQ2y30oN16OtsgCBo04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3827
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2022 3:58 AM, Lixue Liang wrote:

nit: Please use just the driver name in the title, not the file being 
modified. i.e. igb: not igb_main:

Also, as Paul pointed out earlier, each time you do a revision, please 
increment the vX number and please include a changelog under the '---' 
to make review easier.

> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> In some cases, when the user uses igb_set_eeprom to modify the MAC
> address to be invalid, the igb driver will fail to load. If there is no
> network card device, the user must modify it to a valid MAC address by
> other means.
> 
> Since the MAC address can be modified, then add a random valid MAC address
> to replace the invalid MAC address in the driver can be workable, it can
> continue to finish the loading, and output the relevant log reminder.
> 
> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..40f43534a3af 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	eth_hw_addr_set(netdev, hw->mac.addr);
>   
>   	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		eth_hw_addr_random(netdev);
> +		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
> +		dev_err(&pdev->dev,
> +			"Invalid MAC address, already assigned random MAC address\n");

I prefer the message as Alex suggested [1]: "Invalid MAC address. 
Assigned random MAC address". "already assigned random MAC address" 
seems a bit confusing to me.

Thanks,
Tony

>   	}
>   
>   	igb_set_default_mac_filter(adapter);

[1] 
https://lore.kernel.org/netdev/ad8cf673c8e9e21cb2e7afeb5c7e66cc76a36995.camel@gmail.com/
