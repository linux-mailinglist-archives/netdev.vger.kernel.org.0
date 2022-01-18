Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306D1491FAC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244517AbiARHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:04:01 -0500
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:3163
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230196AbiARHEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 02:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m72jEllKakfw5TVGo084CKfY1ljJpWIS8opZ2huY+zltOEyEXlz15beTVqbW9g7UpbZTu9MLIv2rvSjItkdGZqhYHRvJQ3/rwoyQ+7nmdbRp7DWn73mH25ts44HLv1JUAzFXJaHWjI74TfVVwdDMlFsHx9IoacqZKpbJX/d66NNLV9DNLiN5tGR8C1UEmt3u0r7EUdcv7H3ZP8U6zvjehjKqZekxC9kZc7Lt7CAT4QuwCyafSp37wNN09XXuOw4yh7i3ktJTwA4HlKxqe1BCPA2WfXBYmQcoXkvpxeXYnNjA65767ePrumjI8G7aUasGcDTrTgQJadVXl6VfsYjMIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYYMWMIU8YgOTrH8f5w8hVsng5YHw6hamkgJ0ZXHSFw=;
 b=f8oZWn++0XrkO1v1diVd9FnPoSGrd7X5y/g/jM7vuVpkukDU1h+AU68ruBtns0/Loi9Hv9RD1nXJ2NPNTiuFU8znI/JN4bvyNX1bcFLSfI1AHpsL9EdE2/liMxesT90M3k7bsstv0p9pZM/0qYnatCOpa7pqz/zqAACXedlmJpZo7dVKyd6VQJPZ8t0ALwJxXIz6XKHQ79h/K35P1J/siV5Eau/P+kinN+t2xJbbArQwqEx5sZjsgl3yrCCybXQSdGqEwf879nSlXa7is5mX1L8I20EhILIEwqanBIrOq/HTgaifxf5Io3RdsiGUgEXFr7CixMYqdyVme6r91qud3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYYMWMIU8YgOTrH8f5w8hVsng5YHw6hamkgJ0ZXHSFw=;
 b=DZwNZrnetqWukC8s4xD8eTOWBuHLh4KBBONgVbamjo7RQOK9bm87up7GQrpneptXCR/7ALsEEcubSYgLTfAdrx1LzcJP5TffFuCrgc1ol21Po9ZtiiPb8APPa1Jhx6LqA7Z9EnDcOsdCOAEF8sVHLOfUTZSZIvj4QsVjzpidvjp/3BLAVzm+y7yoAT6gsHOR1//gZhq8YsTBVg7c9EXtHfM+vfwVdZ3a4t7cQUonFJyxXfAhzSdj4KvvD2uGn7NJh4yevbX4DlCVOr7d2A1ndyTY9+HEFzuQyECvtvxdTNqUHy3OzcB/5hcknFHDcuKqV9cS/DB+bHMdbmFYh1S5oQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4236.namprd12.prod.outlook.com (2603:10b6:5:212::14)
 by DM5PR12MB1209.namprd12.prod.outlook.com (2603:10b6:3:6f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 18 Jan
 2022 07:03:59 +0000
Received: from DM6PR12MB4236.namprd12.prod.outlook.com
 ([fe80::f98c:6cdf:1fec:e25f]) by DM6PR12MB4236.namprd12.prod.outlook.com
 ([fe80::f98c:6cdf:1fec:e25f%4]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 07:03:59 +0000
Message-ID: <350e045e-e566-3213-c93e-faeba8011b42@nvidia.com>
Date:   Tue, 18 Jan 2022 09:03:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [net:master 63/64] undefined reference to `__sk_defer_free_flush'
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
References: <202201180234.dBCoLWV3-lkp@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <202201180234.dBCoLWV3-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR0301CA0012.eurprd03.prod.outlook.com
 (2603:10a6:20b:468::25) To DM6PR12MB4236.namprd12.prod.outlook.com
 (2603:10b6:5:212::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c75e385f-8936-4890-2169-08d9da50b38c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1209:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1209EC43D94A6DF2436122BCC2589@DM5PR12MB1209.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:167;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wltTWJD4nJ6oFM6Bo+n1axW1hj3vMEfyv9Ph6XSeg+mrBVP9ecuZPGFqgvuUNUq8QUMAAfRodeeosyafYkazR5QXBIMJh9YrOMGliNjkBbmLS0d365D4IzLwM1NOw/wDS4Bwb7T6SgFRoYJd+uUAmWezVHYyzt5UccR9BpsW9EaAVTgqSZFMRElBmkf4NKBq4BuurYCAkK1FufLfjTkLmTG4g6EbSq5CFmXEFhVE530sApXiraWEjDIuJJQiPLjFlYbhqzrDv/us4IOV2H/xDKUK423gezl9QPelN54wE9t7+izuXf0bNi6UI61fS93NEblzN0KULK532OuJWOSpmeQCQxGAZbWOOTz3TKz7kouysntENX5Fwosoh9VkNXiI3nhq7mkY1nvGeJi5fHKgIILXdA62SRHgH/2WSkI65YebTlh73HSHhjy3Yw1E8+rIh8zFYHTfKbfFTFHMk4G3bdwXAFzZyOddNtCfa76o/eWJMQFAc2XWAx9PGbZVK30NfSK/zSpC/YYx4IMKUoSRz4ldzQKYupC1Bvku9Whj6o7ypQt/M4ImKsFVDZWHD5vvZUUyMzIpKwCjZLPT7dc2pT/auVixmCaPAydTFPOmnqKj3dpVQgvXRhYWV+8fkxaMl7zSiMm3Ex9EvUgW2NBjkb4Vcmxt7VkLHHPjWbWoFqqyhXBX5CxFezUtef65XLvRNhMFipb2rnjAynZajLyzwA51eKDLq3bEwyJm2Z5trvLIK0xCz4mHjWYbzRmGY+E6r3R7gqwZ8bYl0f9iJ+jRe6YvoSi7FS8mBMg/FyY6Hdi4zUP1GAgzCvO7kiHdFqGlcLxLfPy8DlWCBQA6XHHOKFkkK9iP77M3kr3MeKCSWAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4236.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(2616005)(316002)(2906002)(8676002)(966005)(186003)(31696002)(86362001)(4326008)(8936002)(6506007)(38100700002)(66476007)(6486002)(6512007)(83380400001)(66946007)(53546011)(6666004)(508600001)(36756003)(66556008)(31686004)(45080400002)(6916009)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFVnaWFMK0Q3SXRqZVQ4RWliUTFKb3pudVhjWE9Udk05Rm5pM083dTFabFkv?=
 =?utf-8?B?NzlmSEhuZnAvNGFUWjdGV2lRQnNWNERIalAvWEtOWWVvMXZVaW8yc2tmZWc4?=
 =?utf-8?B?N253dE9iVHlVUGJ0aVh4WEplc0h6a0RQY1BreFg3dXBVYllaMjE3QklKS1gx?=
 =?utf-8?B?QmxtK1dIQVFXMWNWU0V4eDAzK1RyejNoQW1FSDlJWm9NdHFWeTdEd2xYemJv?=
 =?utf-8?B?VlRyOW42ZmgxRTJVK3FiS3ZvTHFrSThjYjFYYTNWUXdYTTFZRGNjNThXK0Iw?=
 =?utf-8?B?akNmczYzR1gzTVhwZVM3YU9GY2Y3a2dXNTFpTjA2akszVVcrRFRRY0YrQmpY?=
 =?utf-8?B?QzVHVWg1NXpqTWZpQ1BWeHY2MzZmZFRxZ3VlWTlCdElEbXdXNzBKVStvTEhX?=
 =?utf-8?B?clRER1ROMlk5S016eFJzbE1QYUZzZmxDNWdmL3FmdDF3WGY0dzB0R1JXVUNP?=
 =?utf-8?B?b3BjeHNkQS9pYTlVSGw2UVNDWVdjVmg5YURtY05ad2dDZ0JLaGpJWHhZQW0y?=
 =?utf-8?B?RXNpTjZWQXd1RkU3S2RRaVkyTHFNMFJJTjdPRGxmcWROQTAwK1pHV09rS1Y4?=
 =?utf-8?B?MHJmQzlOdXhOOEdCM2JReklvS0dpTWdGNzRKd051VEhYazlHa2xJVUtpWW9J?=
 =?utf-8?B?VGhqaE5BNnpJZ0R6L2w3ZDN1Q0hvRHBRajhnQkJYOW5BYWc0N2lLS3FNdHcy?=
 =?utf-8?B?alRCMWdCV3BUZjVWTUcxT2dLek43Yk1OK0VZS1F4Rnh4K2VxVGw1dDF6SGZD?=
 =?utf-8?B?YzlHOHFKakdJR2l5Yy9rdjJ2dzFCRHdJVW1ydWErdjJhUXl6Ti9JQnFtMG9J?=
 =?utf-8?B?ZnF1L0s5YTVsbVRrOVVkM3ZPWklWUlBoMkdXZWdUSDdnSDc5Z3VYQXN2ZEdX?=
 =?utf-8?B?ZjNkbDV6dmw5UGtiY3QxUGhtSEZPWWFldmFOTjhVZHRuZFNnZDNOMXMzNVZE?=
 =?utf-8?B?OHdPR0JIMmlUQUl1NGlBajJkMnV4UndzQVMzbDhxWlRma2UzVlpmWE9hRWVP?=
 =?utf-8?B?aG12MCtYemJjSEdKdzNUb1JjeG5LOXBDNjNXc09FMklZNHlYNXZ2NTB5Y0Jx?=
 =?utf-8?B?QWlib0pBSktURXhBK1FMTHdLZU40QWI4UUVrLzZtWENLM3Q4N3RsUlcyaUFC?=
 =?utf-8?B?MmxaYVcxNVBWazY5cUxULzFXRnRacU9yU1dNNmN3TVgyZGg5THdQWWJMY3g2?=
 =?utf-8?B?LzEzRFpieGxneDMzTXZ3RUloYlF1RXh4UjA5WnZ4amFyRjVZRFRadmNBWUF4?=
 =?utf-8?B?WFdGMk1acXlkOTd5YlhoOGtVRkN4VFZVVitXZVVPSXJiclpwcFgrcjV5TGVl?=
 =?utf-8?B?Y0tlUGZZSWZwL21VaUw0YlE4NU92RUNHS0x2ZlhycVBXaUJYK1pzUVVmOTRq?=
 =?utf-8?B?V1R6ZGQ4WGxzMDRmWWJ6ODlFWHRzcjdWK29FZDhCUmNUT1FsY3RjMGZnVGU5?=
 =?utf-8?B?Z05xT2EvT2tQcXM4aC9ySC9tUVp1SXQ3WkVoRklrR2ZjTTgrRHoyN0FZRkpr?=
 =?utf-8?B?dE9qSzRVZ0tHNGZpT0JmYmJsNjBDdkZySFVKVGljOTBJUVRvZGtXektGM0dO?=
 =?utf-8?B?ZEtKdUZVWXAxbE1qbVdxV2wwM3V1bHN3U2xaWExMVFVIZldZb3NXazFHWS9Q?=
 =?utf-8?B?YWh4bEZqWUh1NlVtQjdQU1JJV0FDVkgwbGZnSkJndDFTYzhqNVNOWmpVbGd5?=
 =?utf-8?B?MUZLc2FDRk8yWCs2cjBsa0Jtem43TDE0VEtvTWI1dlc5dUVSZHVqdUVuN3FY?=
 =?utf-8?B?Mjc0aWloVWJ2ak11eUZHenBiNTlrNTlIZ3o4a3lyMnFNTVg5d2lYeTNsZkZ3?=
 =?utf-8?B?VmRpUlJoWitMRjJwdEcvb0xFcm13QWMwODBJVUlWTWl2TDVVRVRaYi8zeE1F?=
 =?utf-8?B?UTNOd0YrUVJwQUtLV3Jpbjh0Y29RV25KUG1wbDc4MWFDRW5pSlpPZVFXT0pN?=
 =?utf-8?B?ZU5mOHNrNG11UWFTb1BoL0tNYzR2QStWNzI2OTk3RkpjUW0zUU93Mlp0U0NV?=
 =?utf-8?B?Um4vYy9yS1ZMcmNCNGtmNTQyWXVCd1lhK1d4U3Y5RHA5QjcwZWNWUUY1V05o?=
 =?utf-8?B?V3daUkp0dVNpYUh6WlZoOTBkcHZ3Z2tqNXNISmhHeWg4QlVoaWF2eVRJV2Rk?=
 =?utf-8?Q?9B5Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75e385f-8936-4890-2169-08d9da50b38c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4236.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 07:03:59.6835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrjocw80yAd7WaJaJklcJGCLfmDQhVpdKA8e//HV0GBZ982z0I/JdLl6QAW0aipa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2022 20:55, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> head:   9ea674d7ca4f6ce080b813ac2d9a9397f13d2427
> commit: 79074a72d335dbd021a716d8cc65cba3b2f706ab [63/64] net: Flush deferred skb free on socket destroy
> config: h8300-randconfig-r006-20220116 (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdownload.01.org%2F0day-ci%2Farchive%2F20220118%2F202201180234.dBCoLWV3-lkp%40intel.com%2Fconfig&amp;data=04%7C01%7Cgal%40nvidia.com%7Cde5d47b7a86e4df308f108d9d9eaf8f2%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637780425491208086%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=FcJT%2BcZas79QercgEQ2d8RBv55Q9I%2BMDFxgfIS5zIo4%3D&amp;reserved=0)
> compiler: h8300-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fraw.githubusercontent.com%2Fintel%2Flkp-tests%2Fmaster%2Fsbin%2Fmake.cross&amp;data=04%7C01%7Cgal%40nvidia.com%7Cde5d47b7a86e4df308f108d9d9eaf8f2%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637780425491208086%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=6bsH%2BIo3rZjPek84f3iwFoc6AkqdzMOj6cV6iv3YAx0%3D&amp;reserved=0 -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=79074a72d335dbd021a716d8cc65cba3b2f706ab
>         git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
>         git fetch --no-tags net master
>         git checkout 79074a72d335dbd021a716d8cc65cba3b2f706ab
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=h8300 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    h8300-linux-ld: section .init.text LMA [0000000000466120,0000000000498245] overlaps section .text LMA [0000000000000280,0000000000f8ea7f]
>    h8300-linux-ld: section .data VMA [0000000000400000,000000000046611f] overlaps section .text VMA [0000000000000280,0000000000f8ea7f]
>    h8300-linux-ld: net/core/sock.o: in function `sk_destruct':
>>> (.text+0x51f1): undefined reference to `__sk_defer_free_flush'
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flists.01.org%2Fhyperkitty%2Flist%2Fkbuild-all%40lists.01.org&amp;data=04%7C01%7Cgal%40nvidia.com%7Cde5d47b7a86e4df308f108d9d9eaf8f2%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637780425491208086%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=1%2FCK7gIpBGGOvntJV1tPV%2FmmnYwvsT9YtqPXA7sy4CQ%3D&amp;reserved=0


Sorry about that, will send a fix.

