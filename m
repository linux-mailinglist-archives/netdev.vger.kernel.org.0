Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE133E07BF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbhHDSi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:38:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:38186 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhHDSiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 14:38:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="235943019"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="235943019"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 11:38:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="501323683"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 04 Aug 2021 11:38:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 11:38:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 4 Aug 2021 11:38:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 11:38:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOIw1CnZO/gT5Rjfwwh5aBfzGCV4KcZrMV98A+OZzq6LINEKCT1BqMxJ4aO2TvmS+VS6mykCOBgr8NMSdU6NtYPUmXfG17tcwuLH91O35KcYxnmczgHFrn+En1/2nDdPK3eRPZZc5ERIxCfrz3jVlKp64kil+nXODUIPiv1IxGgiMr9kGyUYbIYK7U8qRVCEMaV95SihNcboljSgkMMXs44x35xVROFRFFYSaClzbMHqG9xq4nslvaZhypm26LfcLYb3wVwq05NS+n3OwBOBDSIn49LP5HjOvPXzuWq1sa4RXD4aS7D8xsHjG2BegyjoFBUQQhXq0SRvaQZT+eSJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6B+kM6PoZ/JqqIEac4MlQEgLTedIK8LlC5J4551NG4=;
 b=P8eGJM9a21LOBJt6iU32kYUuR+oMAOGOOIRlbL7Sc2ZNM8VE8LUaCrBXlRwZ4ANddST6RzR7P9qVyF6Xn+kUdFfdAAVBtLnnMxq+SzYOD7WffzoCYslFR2hYSs8osuGdtoaYhVyq2V9GrTeYcsxVYQr/TKfoHQrgH6gQVcGYA2R9US7SsDqSTF1hVze02P/wss2y3ywLlgJVgLSrqXJqVMg3qyg8ZYppXJsaDqvy552t/l3HP/6sa+iBhEORFKHyioXTRtBK+cCvcYS7eYwtY+VuGjOcJj21/rlWTa0ssii4j4OnK4jigAnU0dIw/NQ9WVU4lpc3F50M2hSZz18BrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6B+kM6PoZ/JqqIEac4MlQEgLTedIK8LlC5J4551NG4=;
 b=wPsNEUKyWPCPOjetHPALD78la+Yu5HNxx0Q18gRIU91A3xMlwAvWZBijgZt/L2q15rIeK+TB4cmAvcXSLvHfKQf1Pra1hhElP3B4BngvwbwXISc84VMSURdNh5t5bjoPLA73gMtmfGJwnak7GflxTB//+pi/WWu0UY5yeRQd0yM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CO1PR11MB5076.namprd11.prod.outlook.com (2603:10b6:303:90::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 18:38:06 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909%7]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 18:38:06 +0000
Subject: Re: [PATCH 0/2] net: fix use-after-free bugs
To:     Pavel Skripkin <paskripkin@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <qiangqing.zhang@nxp.com>,
        <hslester96@gmail.com>, <fugang.duan@nxp.com>, <jdmason@kudzu.us>,
        <colin.king@canonical.com>
CC:     <dan.carpenter@oracle.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1628091954.git.paskripkin@gmail.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Message-ID: <b30b28c5-5e96-6f5e-a43d-141419dda6ae@intel.com>
Date:   Wed, 4 Aug 2021 11:38:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <cover.1628091954.git.paskripkin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:303:8e::12) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MW4PR03CA0037.namprd03.prod.outlook.com (2603:10b6:303:8e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 18:38:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efd79e0c-63fe-4faa-8071-08d957770017
X-MS-TrafficTypeDiagnostic: CO1PR11MB5076:
X-Microsoft-Antispam-PRVS: <CO1PR11MB5076F65EE982DB099C67E40397F19@CO1PR11MB5076.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZJL1N+aDeuUTV5xNkET+27xuWg340hBweY7gaB2WucdP+i3zMKl0rjTAas0OTLjDYg2ZeAWfKZg1yLpLqT2e+0FJT6yzLwKjrbI/xLYt3UHw89ugXgWW0fM572JZev7UUKGc87abmFSoxrOeqZlugr1RqZ5yqaG98eU2/aSRMwVdZrL5q6PhrEAvJXNwBpoizhpkBYgTdBUnuaETADp1z8hm3UobcXTCRFJHqkHYrtWwJpRoDlLD+khyByUY6f0l/3wWiGZgkSIzrWllG0FtzFSZ9pXLnlApjAevHEG/w+Ht77iJayXeagzZ3eOGjpmN1e5FMOU8L9cLiEsdFyyXwf8xds2h2t8dZ5mb/8byFi4ZeYszg9wSeVDSLd0l/JZO0i0oO5Z3Svu9GKq/6hx6DBoQdVcoFt4fuPeNu35Rtk55Q5Fi/rfTK7a0JT9lQsrpfl5LSn/oppiziBt1SiOzf6/6h0U5IxRid/Uyp+3F+DhmOuGc0jEzPKos0uMva9qASZ1BwYqvyAV88MqJ8M5nwWVs5/ChwvnNvy8Ea+XSIhdaXcqVwI+2jhkvLE8BRaNbwxrK0PymVAva3sBG4qZlSS0hQ1TUrzGAaaW0LRX/xxzunOgTywjLYPDyDTcDRQv4Whz84QvF12QJjKkNEfUvUi70SGyO98EMCKVqIfdMeWXlKmiEhBuxtP9hB7zQ7v/LcBOOXr/We+ksguRpciS9B2aFJdiSZV95yVr87AGXhw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4744005)(508600001)(4326008)(8676002)(6486002)(8936002)(66946007)(66476007)(5660300002)(66556008)(7416002)(2616005)(36756003)(31696002)(44832011)(2906002)(956004)(316002)(26005)(86362001)(16576012)(31686004)(186003)(83380400001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGMxODBocDg4T1FFSm12aVM5aHZvVDFTWjFmR3N3YUNuRU5yV3JRSXR1VU0x?=
 =?utf-8?B?Q2N3d2dRQVFmeTZ5UUNUck4rN0pST2NLTlVzS0lveElvekpUTzJvNGc3dk5U?=
 =?utf-8?B?MUxXTWtKYU5DbVhmSmNsQjFBZUhqRkUrK2Q4OXYrZlBVZ2xDRW8vbUQvVnhP?=
 =?utf-8?B?TXZvWUVBMnZPNTBnb3RRWmdkNnFIYWRUUW1pZDNvRFlqTTlKVVFUWVpPVXhV?=
 =?utf-8?B?em1JSUdUV0FTZm9iaG1VR1VXZS8wUVFudkxXRVpYY3V1cFoxMUVTeDFobllm?=
 =?utf-8?B?SXF0c2QrcVZtWDlzTU5SL1ppNjBDc0twQ0UzTUR4L0pGZkF0bUEyS0NQY1FF?=
 =?utf-8?B?VWQ0UGthZkpmcURSNVB3KzZlcE9oK1ZtZ0FHQkwva3p0c0tRVmRMODVzN1cz?=
 =?utf-8?B?ZDJMU08xYnRVM0FhYkt1RkU2Q2VKT2pxUHRneCtIWU1GQ0lJQmlja0RqN0cw?=
 =?utf-8?B?dGFETmlhMFVwYUlVcGtNRm95ZHpORHRHenpQNmxSWWxvRjJhUDdIWXlVWlNH?=
 =?utf-8?B?ZHkyR1RQdEo0Y2M5YVZEejVVSDNjVVpCNkpwUS9POXE3NXJCYm9WZ21Cd242?=
 =?utf-8?B?aVlnNldHSDZ5T0cwV1grcFNOeHFyU1pCdDFjSVUvMU9WSFBWZUh1emd0eCtF?=
 =?utf-8?B?VWpmK2s1eGlpTzNaYkJxMlNJWUFidU9Nc3pFc1BDRjMzMEdVNm9BNjVwUGhJ?=
 =?utf-8?B?Z2IxVjdEVlBXZGg4TTU1eUxlbzY2RmNDdld4ZWhtZEdpcnIzU05qV0pid0R2?=
 =?utf-8?B?V2lzaXNqV1UvdjI0VXJUWlAzOERiUi9NMlFtZDhCbGRIM1hKNjVCZkFFdVFL?=
 =?utf-8?B?cTVqZHc3aUxCUXhPeGQ0K3g4bFhSa2FoSUZJNTMrajlOVFlhSHlva3lLNWly?=
 =?utf-8?B?cXAzc1NzalRnTHhPUnIvT1ErTk5NREFLSnY2YmZyTHMyUFdjQUo5TFY0Rmk2?=
 =?utf-8?B?SzVBdi9tWjZ3TUV2T1pmRkpKNnNmOVByKzBtMGVKTi96OHFGb29jUXoraXBk?=
 =?utf-8?B?UW1TOWZTdm94cmV6Ui9IK29BM1VoUzAvOUhkYmZXN3RIcVJKc0FTZFpMQmNW?=
 =?utf-8?B?bHF2SzlsRWJlV0tRek44YkRUQ0k1bDNkNVZTKzFjQUk1U2FYb09nTnY4ZTNw?=
 =?utf-8?B?QUN1MEVmay9oYW9JcmdKNzNKVmo2VlZ2TnhQL2xTODNnOTY2NmNIRGZ3a2tS?=
 =?utf-8?B?MEwwcFlvWkNQRkFBUUh2TWd6YlJydUV6ZHFWcXdpTThrUGgxSzZWQ01NaFp6?=
 =?utf-8?B?ZGJyVnBBRzhSY0QwSG5ScEhWcFc5Y0h0bS9nMENIUTdtMU5qbGozcGxRUDRS?=
 =?utf-8?B?L0RSSG9aeG1ubGZiVW5DTDBkM1ZuanBnYkoyM05OaGROZ1pLV29OaDYreE1a?=
 =?utf-8?B?MjNjbk81blNjTjducVg2N0xiTnV6bTQ3MHd2cjhxTVkrRGJlTkZiSjd0cWwv?=
 =?utf-8?B?K1JrMnA2U0RKOTBUcm1BVUM2ZGRPYndWVTR3SlRNbUk1aDc2NXJQQlJ3QlZm?=
 =?utf-8?B?NEJVOXNjYm14M1dHQVFoY21FcXpqQXpka29WbHJobkxlelIxTWxMeFJ0eUhL?=
 =?utf-8?B?bDJHMFZkM3Z2TGJPUUNsMUJaSUFLUFFNbXRIZEk4ekx1RU1hdUxOR0hDNW1L?=
 =?utf-8?B?elJmc3ltMGNyRm1abEZ1UDg5UDRLY2w3aEhadHFzUTI5cGhWWkZsTEhjV2pL?=
 =?utf-8?B?bnlHRElsRWdlWGRnZGExc0xJeXJuaUQvcTd5Rk1maFVPYWdxTy8wWTlKTTlV?=
 =?utf-8?Q?iVSf/uAqzxaZe6KhQAsLFKAtEMz8zqJZ7LTX6xS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: efd79e0c-63fe-4faa-8071-08d957770017
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 18:38:06.4856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKBK5R+ddd5K71z0OtX5edDUyTUAsBA1TmRV8Zs46Wpg1/ks/muKXeSKM7vU3Sl3ownBz4ghGxLRDttQX1rHqxKj+ds3I92pkwPYjdHQu/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5076
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/2021 8:48 AM, Pavel Skripkin wrote:
> I've added new checker to smatch yesterday. It warns about using
> netdev_priv() pointer after free_{netdev,candev}() call. I hope, it will
> get into next smatch release.
>
> Some of the reported bugs are fixed and upstreamed already, but Dan ran new
> smatch with allmodconfig and found 2 more. Big thanks to Dan for doing it,
> because I totally forgot to do it.
>
> Pavel Skripkin (2):
>   net: fec: fix use-after-free in fec_drv_remove
>   net: vxge: fix use-after-free in vxge_device_unregister
>
>  drivers/net/ethernet/freescale/fec_main.c      | 2 +-
>  drivers/net/ethernet/neterion/vxge/vxge-main.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)


Looks like a good new check! For the series:

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


