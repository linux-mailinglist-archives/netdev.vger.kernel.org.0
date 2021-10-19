Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73A4433A86
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhJSPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:34:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:30938 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhJSPeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228820606"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="228820606"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 08:32:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="718319772"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2021 08:32:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 08:32:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 08:32:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 19 Oct 2021 08:32:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 19 Oct 2021 08:32:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIv4HubG/x+s7VrHM9iddvazabcC6xawjPGG3R4OUgD8MqCfGcjk5vLrt3XlIjq4TSQpzSEcEzbveNaWVn5CshsenUVnZHbyNtK/LEQvXLOftZMcGbI4fKTfNaplBP3nNFwIH02WfOyhMm5ZxMNFi0Y5duDLCEQK6bY1Xg1WgxConx+iXkavSFEXsBVQs06E4vt7A0xTu4se6lPuCVVK0yEe+x7TAu/LZa7v9ht1ZDJ0VYcmU1gylXboIajgC9+bf7LvnqoH707XFa+Ux61Bw3Xxn80+O/k+2JBj/srBPGk36nrU/Oi9ENOzQWCS5bMlcaESSU224fIJTXFcbJW8Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emQ9FVJWDjxl57B92IdFjog0JDtRmhvxWLhkNhhaLJc=;
 b=MygHEpBgVyrVD2SqLnFj58jusulT4ykfhRBVOlI4+ArIBdpqm0C6WUuGep4e2Om4mQK5ZxzWiOMeZP6VN/7Smd2lL+am2TvoONSdB2/V8FB1vUuZd+jLKy2EuLsQOHEkQC64QxI36byy6DmRFmub2ZAcj3Y8Al7oHKuhVNuFTCRN0/5eP/VIUe7uVDqYtRR9ga4wRe6lnH7N6HEKvgW7v9DmcuSedquBniRY1yxWe7EScLxElI54F2kyABuuT366vzwPzRcE9PUfv7hBmyeSN4r1EgpTE5c+oKn4PTXqw2dSiTtX0FVx2sBfY+EjhgtXy8CpnIwFRoS4fa7t6g+tpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emQ9FVJWDjxl57B92IdFjog0JDtRmhvxWLhkNhhaLJc=;
 b=HrNWTcon5ebKuw4lvMed4Q3ni6Z+PFl8U8QNVwBtUxc7l0a9lRleGFnE+CTem1juBIFNvFoeDalOmLvHqO2Kd5vY4kXiG/D8SJ33PrWExbSzgkDnG0WL5JEEBdFGftryhymbdCIgsojVhCMjWEsB0rZ/hB8mfqAxUMNBD+NFEo8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR1101MB2191.namprd11.prod.outlook.com (2603:10b6:301:5a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 15:32:34 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304%3]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 15:32:34 +0000
Message-ID: <12e0fb52-9853-7115-9699-176de053c641@intel.com>
Date:   Tue, 19 Oct 2021 08:32:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] ice: Fix clang -Wimplicit-fallthrough in
 ice_pull_qvec_from_rc()
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>
References: <20211019014203.1926130-1-nathan@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20211019014203.1926130-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:303:b5::30) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MW4PR03CA0295.namprd03.prod.outlook.com (2603:10b6:303:b5::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Tue, 19 Oct 2021 15:32:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eadaf2c7-6046-47ef-4f25-08d99315ac3f
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2191BB8A088D7E0209687C3E97BD9@MWHPR1101MB2191.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwiN/caUcnHOFxOT6BjwUXHOLL0Zuehr2Pi/raPGS0kNSKN04Yw4vQKhUAMQCdzczjmIGdBwjVHQPi7jElcln9SfLym8ahAFCd6dsgAw+hnoRtHWHnJ+2s5FAs716L6EWCfBBs52+AUEXJ1OXnjoRcNkJ5ARUkRaWMSJnWiZa+9+uzZkPZPAufWhcdIJdE6VTsDCpWGGNLkCqXmCHjzeqIjr16Efx5CCcB9TKNhJaUIMY9+XeNtcC3X8OUueh2mW66KZnRZHgyeAtkOLCZhnoqomc5JXLYGxgVXCgrXcPXYRkTsqeNsAOIKgdXFhWy6wFV3T3o2hQ1BLVd/2ZFR9u2w7WdqAjf9jmvBTHoM4Wgyl+E5WJMjXFsIyhVXzHy9RnpWWGU886hIe4cmaucKO/8zNUgBHhLBSYz4syXri1ztnCTVbrUUHqJ9LGCmv9Q1wQeyEs+oH0U3QglXht63JkqvhDZmDE38aDHTpE/sgJePL/pLyCyU5cMuBjHGOKAVCjzKhr7+gTHQU4hWgtohG/IB6p5qvtoYz2l0ArLJsC8J7FpuDwgbs3rb/M8vT/XuVmE1kEmoW6HlgP2KwWNCvTq5gDA4pSNX6ovAfrsLc6v5I0kWuvxsl01Sc3e2yagM3pSflBuNlouGvNUAnmGvMcWocVazSNI97/gWuKlu2wG+YsTU/MdmZn0fDZZwuDvYryW/qfDN+Uuqn1tBqBnIhNt2G1lRh05oXhq0zBQh7oFusjbKDFRbeOtJbmDXD8TIqRr4COHHAj4KVr3gy8uRUUPxws6geiMKFNSDP6DIbpI3/Zm/lWJ9HyAXrR+0vtAx7753Mrt0XpUZAzMNA1HegRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(26005)(86362001)(186003)(956004)(4744005)(316002)(966005)(110136005)(6666004)(508600001)(83380400001)(53546011)(66946007)(66476007)(66556008)(4326008)(2616005)(6486002)(44832011)(82960400001)(8936002)(31686004)(31696002)(38100700002)(8676002)(16576012)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vy8rc3NXT3ZoRnZNdUtHSC9zbTlIdW1iYWVBOVJneGIzS2IvcDdGVy9JMnVp?=
 =?utf-8?B?RDlieW9xbXZmZk13RG5hNko4UGtRMEc2c082ZC9zeTVzVFVVeDAwcmk3c1M5?=
 =?utf-8?B?MFNCRU9NZXozRis4Y05ETjRLeXRBeDZoaEhqRDloMFB0SGpndTJ1M3dvYXhV?=
 =?utf-8?B?Q2t2Snlxd3J1S2hwSGs4ZVA4SWMvNWt0Tk40TTB3TEhXQ2hhWHNrUzArMjBo?=
 =?utf-8?B?SGp5b01BSHliWGVmZGZUQU54dE5oNk5hQ0VOUmpzQjZJS29wejJaM1c1Y3ZQ?=
 =?utf-8?B?NGtWOXg0THhzZWtBVFMrTGRJY0dJN3dVV1J2aytSbGlrRXoxaVp3MGRXcEpn?=
 =?utf-8?B?eU1QZWI0Z0RtUElncEw4RUFxVHJVTWJCZUJVR0U2amZHT3lOMmxGQ3U1VVhn?=
 =?utf-8?B?alAyQUpSOVd2YlpSRWI2K016VUFuQmYyOUN0QmZqc09JaXAwenNkTkJtY3Y2?=
 =?utf-8?B?aitKcDk3WllGbjJrQjNDcElzWUZqc3FNZUZrRndhVTBjdWsvTm9LRTUyRm9H?=
 =?utf-8?B?N2lvUUl1THM4VnJHTFVRQ2lTZWE3YW0xb0NwRE92Tnl3ZmdmcXdmQ3NnM0NU?=
 =?utf-8?B?VE5Xalp3MEhEYTNKK3pzcXZmV2x1ZGtjSDZDdjl3WnVER1FFTUc5cEpEVlRT?=
 =?utf-8?B?RndOVGx5clFIaHhEd0s1eGFYc1RMZHNZbTFNZUJDUzhOMTNQdlFtUHlyekFM?=
 =?utf-8?B?YUQrSkVJRlB6d3hXT0MvR2w5WjdKamxsekx0M1lBMU9LUm9aZjVJVmQ4Z2NS?=
 =?utf-8?B?NE5iRzFyOU0yZFMrUmIzZHdxNzE1YkhORWRLUm9LZjJFNWFhbHpPMERwOTBF?=
 =?utf-8?B?Qjdlck8rZS92S0txZEVMYnFJbmt6alJ6Nk5yUjFIUnhsMFhPR1FVLzF2REI4?=
 =?utf-8?B?MytTK3VubXhmcWgyMVVjSm93cDhpVTJ1Q1NNMVV5WFp1UTk2N01hQ0Jzd2hv?=
 =?utf-8?B?Z1VNcWE1dkhaait6ZTRBcW93dGpBRitmSnJCTUgwZDdQM0hrYTNTcys0ZzhM?=
 =?utf-8?B?bXJ1WWg5eVpSRGhCeTJHSk1SUWFmK1RHNjB5NngwRGlBcXlIc1piZ3J4OXo2?=
 =?utf-8?B?b3NCYjVaTC9qOXY2UFFhWWdDZ0FEVjJla3V1YTNxcDhHQjdOWWVQMUVsSWtj?=
 =?utf-8?B?TXdxSlNGYlJseXlzbmo0NytRSGVLNHVHTU5tZVcrRENFdUs4Ni90UGZJWDRu?=
 =?utf-8?B?Nm14TGpZTVFBRXQ5MnlPNGhwZDZLcnZzWkZPRUhSYTQ4WFhtcUxQZEo1QjB5?=
 =?utf-8?B?QlRQK2ZnWU5ML0tZVElZY3RiaFVsUmhuKy9BN3dXZHNqWHNXS2NxWXpVUTY2?=
 =?utf-8?B?MUJ5Q1ZvYnk2NFVLRjkwWCtyMnd6aEFSYzhDc2dzaE12eXBpNUZmZENRQkNz?=
 =?utf-8?B?MEd6dUpmRCtyQ2ttRU9jYlgvM3g0OWpSYlA2Tk5hUFR2bW1acVRIT3JIL2Rs?=
 =?utf-8?B?NTVoc3N5ekRVRnF2OWdhYlozNlJmOVBkZFQ0WDdpZlBPYU5wOHFiYXEyVHpK?=
 =?utf-8?B?TW9ybXpBQWdlaTlTMlNEQk90RWFYU2tMQ3V0VkJEdjJQUkJzdXFsMzdIV1ZF?=
 =?utf-8?B?Sm9BWDBpSkp6YUQ2TmxWVmVUbTZOVmNPMkFoMWZWcVhCWGwzNElrQUVZQ3BS?=
 =?utf-8?B?SWdrU0l4ZXJtV241MFpOOVdXNWpzc1owdWpkcDFsMGVJMlNUSUhPUlFiTHU4?=
 =?utf-8?B?eE1VRGY0ZmQrdy9EeDNLWTAwcmxIOExEZElqV1FqN3hyQVU2L3kwYkhxQ2Yy?=
 =?utf-8?Q?6p39AvSIB8knFZBRAOBD5zoU44XQw3pJhGsgESP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eadaf2c7-6046-47ef-4f25-08d99315ac3f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 15:32:34.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcKaZhFk+3lQELrtlFYmxpKDJ8LhBqjbGGQzSP1r86ugZ8rqlAza4mXkfMY/iFNjocDvXg7R9DxudveLMfKgsRQpo0M0A6uKZprkzL+3s8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2191
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2021 6:42 PM, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>          default:
>          ^
> drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: note: insert 'break;' to avoid fall-through
>          default:
>          ^
>          break;
> 1 error generated.
> 
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1482
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
