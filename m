Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16E93ED066
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhHPIhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:37:51 -0400
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:12001
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231861AbhHPIhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 04:37:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brFKxXDsmZRGwqhivfpY/SIG0ZwrdfBoHG6dL3l1Eu9UuvDwSJdvLXtNERfa+8wXBKU79OaBaKHC0WkiuaaXdhRXpAuQXdyv7FdytYeTwIy+wbDVHNdWz3jqOXniWoZVdYtZ1vszaNy4OE4ZA44v373BhFfSTGxTTpfVlO77qoN97E4YqETbSqCi9EVZwLvZI3StmGUjJdHwx84rKm1tF74KFf4Pv2HABfGPyGadTHKek0AkC2gPPCslXJsWlEi2lc2FqKRR8lMgBB+UvQafYWWHLoa5ollvSt2CaZeryU2zWiTGG+i/QItyWQa2oYmm3KgKq3jHWzwmlo4kwlwV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4Egvtb1EShprwi/yo8KmP9L+O8z0lq9T+lbjejH8q4=;
 b=MJtol/+t6L4dJT33UNi/Gw3Hu5bsrYxmGVdESHYEU6OuUF2rk1dydLTMKUP7vAzD8gE/8Z78SkU3tlFy48IHLxPb0ICXROF8Zk6N15Dcj3e8bXtg0po+hxyra6fLfDGNKEqwf9tHu6BFm95uph2b7v5BDhE1KDdLqtk3Mr4G8FTDl1MWESduepAQslTWWkiGsqV5prUAj7/m1K7ZKNMGdbYKYxScJ9qzd99woCGOK3X6J4S9fFycYlR8ipxFk0Ba7vlgGdpQl3M8+ZjDAA8HbTmN3fQwp2dDuU+9sHUd9wY8cW7a+oHJihAR5IusdnP09HWO8yBU4sQUONX0seAl7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4Egvtb1EShprwi/yo8KmP9L+O8z0lq9T+lbjejH8q4=;
 b=PSfZstDzvss8Fd1XeOsrG9Gavr6h1+P6yC2P0X0Wl+CXwroZu+21wGY5zE1gAPb6DMgQvs7nw6NsKJC+DeAVrg5RBuaPn8F45u1+VMUcnDYGEaKKOJe6qoXcXcNlQrouCaKPpBS3x3a4F/J0WQ/zvdPifeh0XGoREdEPuvJL8SVvKvPa959TWOgw049y3OcJfbtdNjwJlbXHynQnRIevT6RilISGJ8tJtJ7o3AJAoGHJDHzzb8Ux8KrhQlWuQKTLmnzKUjNL96iOfVLHI7nAa6VrjzhdsgOzg9IAxeiWjo4w17ES5JgSdfev5OQ0am3mLFUEpZ7pUdkjBLLds/PlCQ==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5519.namprd12.prod.outlook.com (2603:10b6:5:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 08:37:16 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 08:37:16 +0000
Subject: Re: [PATCH net-next 4/6] net: bridge: mcast: dump ipv4 querier state
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
References: <202108140311.dorJxbPR-lkp@intel.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f1da62c8-25e7-3183-7ac4-cab3888d141f@nvidia.com>
Date:   Mon, 16 Aug 2021 11:37:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <202108140311.dorJxbPR-lkp@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::16) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZRAP278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Mon, 16 Aug 2021 08:37:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c148efc7-ffcb-4c92-1877-08d960910d79
X-MS-TrafficTypeDiagnostic: DM6PR12MB5519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55194D7412C7637049BF2F83DFFD9@DM6PR12MB5519.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBWbodR2ccCcsayDu3fKhkjneJPrR+Mnb5Cpn0ai6ja2Tts/8cwk1o71PiHIpFD6T8uLkgWyB4X/Nk1qP0G7cipOaJ+mAesxoT8qR60O9Ktko1YdrdGmigaznK1o4hjAN88yk2imYDXbYm2mUOViAZd1wnI8kv7S20QHSpdn463usEq0XV3M9d1PiXbLS0au7cOqJSRHOPwKJDg1SDJf4TrdRt6zbODtPqIIs+P8GjTSVo7AwsR4e6fC6nMVpsnH5gXjdCKQe0MLunup/INuIsZTn+/7JbiQJmYKxMn30dOFov+uTCsjzi9fXvb8qrF3/ZGp1VWTzUt0OPyhG2FbTzuckoo9MicZ50UPnTzhfqw8yRRj31x2AsspqfnkMKtgDk0Bdq8KeEYRKm8uIM8Tx9ETZ9/QctUU4KY0aXrO8DVez5lNMGObaqqHq9piEtOmjNQ79ifrm564/10G5WHTWeJ6erYGuvakP3DEPqwv+te5R4moT+eQp6Gi43W1UFyyOKQvlGBdKTPwvpi17jqEl4VLhA2gm1lXPjzaaNrAxeJiWbwThoTseEo+3IF0VcwoQNRFxrXK6fHy2Fi+WrUnJ/ymIxXuH7VijlF8y6H58a2AV/dtn+17HFxT+Chj0jxlGKfam3xBTsjznYlu0AIn7VrmjHJFHtsnrbaH1A1Iw2d3UB7uROUZn9qtq7jwu20eTf51RlHy2mzMj0H1G8wtr7I39gsZ0xS9QpXHcQU8QE83poVRZdVmLdxSWReWoH2J1wkV5KgSZI7qgCGb9uZ2L3sjAIFkfgY3lHGXa8b9TgwiIUNmggqS7f2kYK2KvjBSACL7S+iJZe4yg8aSJQOtgfhvBCE55bUftnm1jfq+xRw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(316002)(16576012)(5660300002)(66556008)(66476007)(2906002)(36756003)(110136005)(6666004)(66946007)(38100700002)(8936002)(4326008)(83380400001)(26005)(186003)(966005)(8676002)(53546011)(31696002)(6486002)(31686004)(478600001)(86362001)(2616005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TS9neVNyeGxVVVZPSlJKTGZpY29NS3ByNVREeXA5VnkraEpSRW9XazZjdjNt?=
 =?utf-8?B?M21kaEVRbjMwNk5jKzRQRHVEa2thZFcyZEFiTVllaE9zS3lhZFlCZTQvMENH?=
 =?utf-8?B?SjhwbUlNMVBnL24vc1hLR1F1TnB4bFp6elljUmowWlZSWlRHZkhxSWVleHlG?=
 =?utf-8?B?YkxUL0NObGxIQXpwdElXZDR4UXhiNndVUVNNMHU4ZlJ3Y0w4ZVc2OWo5V29h?=
 =?utf-8?B?aXNMM3N2dmQ2NXE1eGh5SVVrM0xNOU5nMTRrcFJsOVZRMkZ6aVpWNy9xV1pG?=
 =?utf-8?B?ZTR0WEVzc1ZReDZXbkE3cmFyaFFSS3NRMlNlVGdDTXk3Y2lWVCt2TGVlM0Ir?=
 =?utf-8?B?cnVLS3QzVU40eHRXb2JRMWE2bVgxWit6bkJkL2pPdGtjaGdtZVVMZllSV2RD?=
 =?utf-8?B?bFpRenJLVzRZMkRVZlR6UmNCTHdhbE4vUmRFdnl1d1hkaUFKTDBhL0ZSV0dm?=
 =?utf-8?B?bnpWZXUzOGEyMVp6eG51WVhBV01sdUIvOW0yK01wRkRXTWY4RjQ5bURlVTFI?=
 =?utf-8?B?Z0RzakloblFyeExWNDlMZVNzaEFTRHJSLzQ0Mmh1VHV6UERqelAwVklyY0NK?=
 =?utf-8?B?NlRVN2JwbTZGK2J0Q1RRSGp2MzhZVThiL2hTME5uaWVpOHdrS05LMXFuK1FW?=
 =?utf-8?B?QlM5Uk9UTldEaG10SDNYU0lzY3l3Z0dRa1FRMFJITGhjT09vUk9IMmpNb3F4?=
 =?utf-8?B?OEZScHJSUUkrUkxzUTdFWVFEY3hydVVYQ0JpTGI3K1gwdnFNWHdndWJBRGhT?=
 =?utf-8?B?NHZGMDQwNnBBcXoxWU1lSnZEYm9TTWd3UDcyVGRpalp2N1BWUlBaNFV1RHpL?=
 =?utf-8?B?NlhFMHIzenhDNHBxOXlhOVdSaExOOS9ubzZpMnpOK1pFem9vZi95ZTdLbmFY?=
 =?utf-8?B?L0dla0VTWHNvK2RtZjdyQnc5UExLVXR1bDVOR2xqV3oxbE00TnF6a3BjWHZk?=
 =?utf-8?B?WCs3cU5kNDlHR2Vkd2NHOEpUMmVmOTcxRHBmNnQrNm1ZUzJ2NzJYM2Fmb2VF?=
 =?utf-8?B?RVhwdXVSejNJNW5SdkVwNHZsWklYLzdENlNOKzJZeG1oVXBQajkxNGV6VXo4?=
 =?utf-8?B?NlJJV2VhaWpvNVR3OGZ3RFZvWWM5UStGcjByeFJFTENVWkhMTnNObGkwZEtN?=
 =?utf-8?B?SllpamNXaE1LRVUzSzQ1dnY0azcrZExRZ29FM3hyYUZpcDV0a1oyR3NmaFpQ?=
 =?utf-8?B?UWJYem9zeXdMNGd5NDdkWVhhKzVsRGRsVWZhbGNnWlJXYXI0aDR4b2U2eEdo?=
 =?utf-8?B?WElDaWhTdWN1YUhLbDk0bS82YmNSZmNjcVMxM0d0ZTJnOE54YW5iMk5VNDZ0?=
 =?utf-8?B?RkVueTBlc2xFT2oyRHcvQnZCRXI2ZnBWUXFxNnBFRDdBcE14UEVHZUFScysv?=
 =?utf-8?B?RmZNRmc2K0dzdVo4Szc3VHFMSS8zYWxUQjlJMEhyOTEvZXhTd3dvejFkUWU2?=
 =?utf-8?B?TzhqV0FMV1hTeWxyNkxoMnhyelBjaHZXMitYdVFndDN6M29xOVZoZXFwNHE1?=
 =?utf-8?B?R0w1M3Y5TjV1b0dkTEx1R2tOU3RHN0dlYjBrQllpMEFOeUhBNkUxYk5wTzRu?=
 =?utf-8?B?TFFYTVdPWDZ2UEVOMVJDUGR1Uk5Pd3ltUmdCY2x2V25MVlRwRVdEdmN4dHZ4?=
 =?utf-8?B?QmlvdTV4elk2N2FWUlZvZ2pjNjdIQVRKaUhGOWdFaXREYzhVUVFlK1FPWVZm?=
 =?utf-8?B?czBsM1ZpaThNajltWkR1ZlJnajZqZG5TWHMwYnB6TTBrM3lFSGFGRUZ3eEFr?=
 =?utf-8?Q?rvd3OunZL8nrJNriGVbuGQQ3VMiqDQIBGIgHuTy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c148efc7-ffcb-4c92-1877-08d960910d79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 08:37:16.3175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgDN66mApgx6M3Bnm9m5ujxwQ4e9ZqxyL/5TObf/0EJx5KlNuEUrZQcEZ5Rwv/VgJsRNAURpns2R0OKxPdrCZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2021 11:33, Dan Carpenter wrote:
> Hi Nikolay,
> 
> url:    https://github.com/0day-ci/linux/commits/Nikolay-Aleksandrov/net-bridge-mcast-dump-querier-state/20210813-230258
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b769cf44ed55f4b277b89cf53df6092f0c9082d0
> config: x86_64-randconfig-m001-20210814 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> net/bridge/br_multicast.c:2931 br_multicast_querier_state_size() warn: sizeof(NUMBER)?
> 
> vim +2931 net/bridge/br_multicast.c
> 
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2929  size_t br_multicast_querier_state_size(void)
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2930  {
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13 @2931  	return nla_total_size(sizeof(0)) +      /* nest attribute */
>                                                                               ^^^^^^^^^
> This looks like it's probably intentional, but wouldn't it be more
> readable to say sizeof(int) as it does below?
> 

The nest attribute has 0 size, my error was the sizeof(0), where it should've been
just 0 without sizeof.

I'll send a fix, thank you for the report.

> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2932  	       nla_total_size(sizeof(__be32)) + /* BRIDGE_QUERIER_IP_ADDRESS */
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2933  	       nla_total_size(sizeof(int)) +    /* BRIDGE_QUERIER_IP_PORT */
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2934  	       nla_total_size_64bit(sizeof(u64)); /* BRIDGE_QUERIER_IP_OTHER_TIMER */
> 384d7e0455593b Nikolay Aleksandrov 2021-08-13  2935  }
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

