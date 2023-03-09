Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD5C6B2AFC
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCIQjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCIQi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:38:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5A0FCF96;
        Thu,  9 Mar 2023 08:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678379332; x=1709915332;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+dW/Fk5PjGDWeWV2LJCcsWNUHHJfMaHLA0DyzYS78nA=;
  b=PhqACMvVZ5W87gXjcWL47TAtwFuTkcvnWbA4IxLVZpqARPeJQT+ZrKXN
   baLFuUPqvtcxYXQdS6t3+EfsY3UpcH+vxewKItJeBSp/GN9Ih2AUrAIeo
   WUMCio6xB+YkBWv4wM/CTTsDmlTby5M269TdRP2E6LxJlMrNVGwGTRGqW
   r7n5THHJgq3/LBynfauWZj4sz2mOp09jAggE5MSuikWy3dC2Gv9BiUgsj
   Kr3EAHkHVh1dQuh5zMEFeaQwPEMBnP/jMNUImpRXCH/w6A8cZEY18T70Z
   EYjjoTUYuZOXVAimI4062/vMMWA3E8UwGgZ0W6bGEQZBIqGwKmQH1rVMF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="316884810"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="316884810"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 08:28:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="627429050"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="627429050"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2023 08:28:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 08:28:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 08:28:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 08:28:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 08:28:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1GkYWm3wExtQSlekLfu49zRs8PNmSyq/XrQCEsGpnOexvTooyRtEyLlP/uVNeARIPKKoyAu/SqgkwxlbmJgt5vh5SzClVCVhIyUOJVw5sfuUGOuvP9PIDnzIdX9vkKGZopcw3WP/+b4N/EInxGCcU9t455ngabsNr/jenvPCAvGUi9k4DZR57yqmIdhETyqyzFRvISK84ZxHbRvcjnzpQOEcXxRNOIq23bj0vxkwQSAnjfHusctCYO8RGSfmpZoGj5Qo7b329JQ2UfJvl+sVbf695z2tnVESrQTTJERQ4sipzzb9/y4hPCStWVbk9rEBOVJWM3O88lT/NxkNceHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqXLCIXgKK7+vYg1eDI4w2jEqShkqb1CgEQBHq+QGp0=;
 b=RadexJ4pwbYDjA1DS/C6l9XVzYFe5OSiMu1BDA1rOr6e9w+74z+jWaCHoiSLDSMFbhcJpgWXy7IlSvK7PvF5EcwgYzuZIHxHF7ZdMd2CbEmzo3gRstCCa+c1uQdenHlw8qtKZqLKVY1MTm/JGwsadb5t0F51Uc7e7sxLINWsQ+Egn9FhxuI0ODIyoNP59RhI+oKyqDXRE5usjDb+Jo2qrjM0hKGtyEUVox1hUSZP43tMpFc1LLSQGHQ/ecrVwf8k2wJ+K+otHm6mx1lUP+G0JePuK30OzdiK0BuvCUJ8R8x5Pj5jkoxoYnpdZNh5StHCjFDgPn9VR8lcEJXa576Zag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB7205.namprd11.prod.outlook.com (2603:10b6:8:113::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 16:28:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 16:28:46 +0000
Message-ID: <fba8f996-003f-1fb1-d5f0-09ef6fc24f51@intel.com>
Date:   Thu, 9 Mar 2023 17:27:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
 <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
 <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
 <9b5b88da-0d2d-d3f3-6ee1-7e4afc2e329a@intel.com>
 <98aa093a-e772-8882-b0e3-5895fd747e59@huawei.com>
 <0bc28bea-78f5-bcce-2d45-e6f6d1a7ed40@intel.com>
 <605cad27-2bf3-7913-877e-d2870892ecd5@huawei.com>
 <9e8a9346-37f4-7c5d-f1d0-cbba3de805db@intel.com>
 <1cea3621-8f5d-ba95-1b0b-e245ce770abf@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <1cea3621-8f5d-ba95-1b0b-e245ce770abf@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: 509c338c-2dcd-476b-171e-08db20bb5b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6e4dQo2iQ0wBGcV9m6wigQjfPKin6KybpdO0G0YWyqu8ZquCm2kCchKtQfNhV4XmdAbDwpORRHuNF/luwjF70mI71x4DE1n4qD1Sm7GZEqQlAIOTzSzlMTsGkHplF7LSaldOkWoLafkJBJYRLrwyjqIoRGDLQX0H7P1TqLU04h3tTBoAT8sFzKMI/imvh3zj8EIDWw4hUTxie3S46T9qgpAFRbz628pEYJcpGmU1FvOIA4mNcAZAmYy5Auk/MXEXXNE/MUnAm8TgkFmzBipQrBXzUk9Fh+UBVvR9M/DCfMYN8zgl+bfc7GbkU5b6PzKRv980QTLhvrTJVcRGv/2zmSusiwzZlYPn5eZPIvOS7y3b76dU2vV8CzghyFH9iYaSt0ni/le8lKJxiVlJzcRjp8v6ypf3A4+2Z91cAa3EQuYCGSzxUcySxOkc6PT+mfJRm30nyki7uif/EBMwbmyQ1ly9kTIzp9RKXbQwGo9gbErvDVvI3E++aRoyuMOFZdts63jEHJ/M+FkgwzfwW3eXEn6+afvLVpq4xdGY49m2utLhWSCSvBuUZB7UiUclFe81vel+OB44L8ipzzMBYPeeLKJGSGLNzBRTlChzyVvvW1wTm+9GJBTIXzO+4I06/fnEpe0pvoUM/X/6Wf7ylYo3QjyFeYW012N+B2lNMAYggCHLjH3+zZxBFZL/NV/sDiu9weU2cCRX/llRmPVfOIGudu35XszB/397s36Ax6WFRl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(82960400001)(36756003)(316002)(54906003)(38100700002)(7416002)(8936002)(31696002)(86362001)(66476007)(41300700001)(6916009)(66556008)(4326008)(8676002)(66946007)(5660300002)(478600001)(53546011)(6486002)(26005)(186003)(6666004)(6506007)(31686004)(6512007)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVNFUGVzcFNvUzREZ0ViblRkbW0zcmUxNjBPYjhFSEpSeXY4dVdGTWxjZGtT?=
 =?utf-8?B?SlkzTno5NTlUVjV0TGZrMU1oVHFJREoyT2FuZnFPVXBmT3JpTjdVSHZvcFU1?=
 =?utf-8?B?ajgvNXFiTDRJRHRxbnBOQXFXQ01HUDVvZFl3QlNaQVFSbjgzYjllbTVPTzFI?=
 =?utf-8?B?bG9zK1EycVI5OVJSM05LZW8zWFJPK0syRDJZNDZobnhUcmRWRUVzQnpnRUVD?=
 =?utf-8?B?dlM0MzJRVkhhbzFSSk15WkFhMWdobEVMK2x6UGYvZkNYWHdSbjdvRzh3dTJM?=
 =?utf-8?B?ckRiUjZoZGc1b3B5VFlTdUdyYTQ5Nml0UDc1SkRVemxDRG5Tc1hlU0lneDlz?=
 =?utf-8?B?NHNxNTc1M3prRi9oNTd1MnQveXcvbjR3K2p3RGFQTG40OE00ejUwcFY0Q2V6?=
 =?utf-8?B?akdkdnVrZEYxeFpvb3k5eUNyeVo2TU5JVFd2bEVXelYxTVVpeDZkQkRwUE5X?=
 =?utf-8?B?TVQ5YVBsc3FoSUx3cmR1QU1QRHpVaWc0REdmNVM1Z3FMdHlRUkkram9EdjFF?=
 =?utf-8?B?Mmw5NVY1b0JqaWpibnVRN1Z3QjB1a1k3S3hzbWc3S3RiRGdVdGEwUkJQcGQr?=
 =?utf-8?B?MTZCS2hLd05oeUlHWUt0QTRvNVU4RTVranF2L3FFOEdWeXAva0NBTzJoMFlZ?=
 =?utf-8?B?K0R3MSs2UXNNUnQzYW11cFpmeFN3dEFOZVNUWHBsbUliQ1grSW16WGVjYjlG?=
 =?utf-8?B?UkJXY3hJZE1Zbld6RW8rdklwS2lpSUc5M1hYR3FCcmNXOWQvSGluRnRhcGVN?=
 =?utf-8?B?dGtRY2xWc01oRHJxMmhQeTh6ZzMvUFFUWFhSdXMvbWt2eVRac3RPWTBOa3Ay?=
 =?utf-8?B?WHUrTHNDK05BK0x0WUpWYjYyVTdLdWE3eUQ4bFU4N1JoL09UUWszcEFOcFRL?=
 =?utf-8?B?dWppc2Q3RmhmMEZPK0lRNGlqNGJhZ0JUS0ZmUlRZOWlXb2o4OGFLUjJtbTU3?=
 =?utf-8?B?TzRPak1LelZiMTYvMWZvTnhZMFFBQThteWRkTGR5RlppTUNZMGpkc2szRVc3?=
 =?utf-8?B?UXp1bXlQTDkvTFg2Tkg3RkE0MmtPMkZiVzBVVCtmTUZ4WW8rZHJPOUd0ZDNE?=
 =?utf-8?B?NDkrV095aFZaWkVOL2l3RTZnclBtTDVsUzkwUkdPOGVCbVovN2J4ODgxVUNW?=
 =?utf-8?B?SGZIUWxMWGxkMEZjSy8wcDdISG1xelh6Y2plajJwZE5tL0lEZDUzSCtZZGds?=
 =?utf-8?B?WWRPQUw3d2IvMmhvRk5Gbmw0MWQ4MGJJaVBYQ2dwZHB3ZmxBQ0JGeWN1eThu?=
 =?utf-8?B?dmVDTmVtZy9sdWJpLy9aWlpUWVQxVmVGVnk1RlZEcXJuOWtyL0xORFdwRFc4?=
 =?utf-8?B?azhnUWVNYytNdW94aWlML2hKNUhrUFFCS3RsSVlQWWpkYitwaFU0b1AybW9t?=
 =?utf-8?B?Z3lzL0d1eXBtSDlwd0tLa2ZkWVNUSTdySklkUVZ6Y0hwUU9SVkN4RDd6Y1BS?=
 =?utf-8?B?Yk50aVowSEYvSWRBWkVMQU1oZTJKZThDcGlKL0U2cE4xSzliWGRha2pTZWxs?=
 =?utf-8?B?NmJaT09UREI4SlhLcDFYMVdod0R5Vm1Pak5SWWIwVmZxN1E1T1pha0ZseXY4?=
 =?utf-8?B?aHNjWFlHZGV6S2tnV2VweGJqWWNtZDl6QmFabGJ1WXdSU1pWNGJVZG12ZVZj?=
 =?utf-8?B?WEdTVGMwNCtKMEVvYnROeEI1NWZiVGEvelU1S2sxODBqOU1wNE00aEI5Z1VK?=
 =?utf-8?B?V0RBclVLRTZDamdJc3VGK002c1hlS2xCN1IxaFppSlRRSkV6QjdYUzUrK01H?=
 =?utf-8?B?ZXZoV1R1U21lMURteXdPQkZ6ek55cmxjZUFzYi9iQ24zNFlXdk9CeFQwdU9S?=
 =?utf-8?B?T0ZTdEtjaU4zcWJNSUhDMWE5OC96eDRpTCtnaEM2NlRIREJHM2I1WTQ4QXZl?=
 =?utf-8?B?M200Tkk3WjJRZmxmMzNHSExJeUsyUWhoNkkrbFltOTRESUhYU2ZBYmJuVlp0?=
 =?utf-8?B?Wlo0MlpNT3k3NDZ2c21LSS9MRnVpNUt6TEJkNFZRa2g4OTJrOE9aYmJSR09H?=
 =?utf-8?B?NXVyUnp6dTErUllLVlUvSDdFdTc3eUt6YVJQN0dkdGl6Wm5BZVJEb0s1OXZW?=
 =?utf-8?B?blhPdFRGOGhFdEZ1dzhpaGVWS3d1WXpWN1NSV1Vtd2xEL0NWT0o5UjZISmNx?=
 =?utf-8?B?d042RVVDdHkvZUlRK2FZeE4wQnRucTZlQWtGcy9BSjIrQ2Fuc1ZVOEtYMkd0?=
 =?utf-8?Q?fCtWnWexvJuReJNGnHPcOy8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 509c338c-2dcd-476b-171e-08db20bb5b09
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:28:46.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFqzOzUUDXihVk9Xu9cqdl4KT8Cx/RhYq+5pPYPmIuniEEu9vI2E5xCCpGmUUF8gGrFQBVtVLBFoqdpQycoacfjHj0LGPFeA21IuQzWP8XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7205
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Wed, 8 Mar 2023 14:27:13 +0800

> On 2023/3/8 2:14, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Tue, 7 Mar 2023 10:50:34 +0800

[...]

>> You mean false-positives in both directions? Because if ->pp_recycle is
>> set, the stack can still free non-PP pages. In the opposite case, I mean
>> when ->pp_recycle is false and an skb page belongs to a page_pool, yes,
>> there'll be issues.
> 
> That may depends on what is a PP pages and what is a non-PP pages, it seems
> hard to answer now.
> 
> For a skb with ->pp_recycle being true and its frag page with page->pp_magic
> being PP_SIGNATURE, when calling skb_clone()/pskb_expand_head() or
> skb_try_coalesce(), we may call __skb_frag_ref() for the frag page, which
> mean a page with page->pp_magic being PP_SIGNATURE can be both PP page
> and non-PP page at the same time. So it is important to set the ->pp_recycle
> correctly, and it seems hard to get that right from past experience，that's
> why a per page marker is suggested.

Oh well, I didn't know that :s
Thanks for the expl.

[...]

Olek
