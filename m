Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9828B5FEA9A
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJNIdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJNIdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:33:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2065.outbound.protection.outlook.com [40.107.101.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B81190E77
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 01:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WukQzvdwOVlz2NHfNjjvDvZrbIV/pyfNqebI7d6pYJKxN/ffm2/PwPgCeVfyvCaLD0uMvpyqGUWQ8oDiWo+hXss5f/GpMRpTXCBkEBik1ISL+Ateri2l886vKC12P3NwEB/VOLefdzh8I+XunIveajAAttDTaAwjBuJBXjzXzVpJv0BDMOfpBB9kMkouGAHc5ioh4xfNAGBCtvP2UPS6INY7Z2PD/OSvhW1Xo411jlE/ZroKxrAJArAWkuSzev9o3ZSPsgb5GCrT2ESZVnB7Y0hvPfUZ04So/wRtfECyxFNuuV+CzVt6m/cqi2L4ZHQU/zrVz3jzU1AE/DjyynutlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVbu0pDbO2kp3fpS4T0jiN+OZ6wuDAaPvECYisQZSOg=;
 b=bSAQnjx0xmRhM3BDPhU9i5/QyItVYTa47kaHI4ehGdtiwhEEs1K4FXTqz6VoPyHkp5+vvuWmEilikWO+xsMEa/8kFP+mIAAHe4twb3lWhONumuumXxhrQbBsU66IpsS9TXB1nX6tmJQLJRSQIBWatS54Ir+CVW5cThymCuWo8Tyfb3dIfIN7A+w9AT4PMt/3w/yzRY5WdLKBGJ5tjCHHlwBzS8FFb66ajb3wy8Ajjrs3cYvv8jKt6nci7OwJkSD2KqXpsBALNCmgpEztq5HGPY0Z/n1yamxt0dd3rQLEeiP9Nd1STFT4QCQuU7x7OxJgMrMj8+NrlfJEor50YWuLGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVbu0pDbO2kp3fpS4T0jiN+OZ6wuDAaPvECYisQZSOg=;
 b=yQC7Ia0ek3m9JME7lJyEjt08YsE8rKSWIzdGvmg2XmrQ4Igao8+XAKl5Wn0Y/HJIMUDf/aMdWHiepUttV8F8rjC9DRg2pM83QFQJPzko1gvw4au1YzSzhCE9fyQRyZqsUHC7nZgHqDep9eILLaf1oacfUeNgeMDpyx+6hbDGfH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2379.namprd12.prod.outlook.com (2603:10b6:907:9::24)
 by MN2PR12MB4472.namprd12.prod.outlook.com (2603:10b6:208:267::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 08:33:10 +0000
Received: from MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce]) by MW2PR12MB2379.namprd12.prod.outlook.com
 ([fe80::2e7d:cda3:bb38:a1ce%6]) with mapi id 15.20.5723.022; Fri, 14 Oct 2022
 08:33:10 +0000
Message-ID: <66db31de-192a-cd8b-cc97-f2902f6fa687@amd.com>
Date:   Fri, 14 Oct 2022 14:02:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as
 possible
Content-Language: en-US
To:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Gautham Shenoy <gautham.shenoy@amd.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chen Yu <yu.c.chen@intel.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Yicong Yang <yangyicong@hisilicon.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-7-eric.dumazet@gmail.com>
 <684c6220-9288-3838-a938-0792b57c5968@amd.com>
 <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
 <CALvZod7Bprb_Vt_6OqhtBCpgJc_EykK49emvpnfrpyX0RX5dGg@mail.gmail.com>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <CALvZod7Bprb_Vt_6OqhtBCpgJc_EykK49emvpnfrpyX0RX5dGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0201.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::13) To MW2PR12MB2379.namprd12.prod.outlook.com
 (2603:10b6:907:9::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2379:EE_|MN2PR12MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 355acbb5-ebe2-4450-ddb1-08daadbeba1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UP8Yk+/9X2MfuWqG89IYTyyHMMZpO5jsU/eDud4MrNYL2/J5Ystwg4kKUWSCNSMUXukuBasqEcUE4fr0hD/eOKfzNeG/ggPoAoy9u5seExCiHBpuKzIPsX0cQZRIGh15JQqFG4S3CQq+UaKPa/Sm17NEPyCaFH3IIRxjkWx4jBMoWw4nB4VhnPXoSvQ+z0y2J342oqapxerFbSWvz3jHfdXmCq9/ofRbBRPKdcnQLjIjrWxOduWFFAC+JS7WWUJQ8snTVxjB7NKwnjW1lKKmNRAJFj+33NskTcmUNBZj0t7LQfEHtXF4u4VMq/JzTk+a6FVuY7WkkVS/MX1KwHiMQvnbjslid2DgQHlq62LKkCTfsBXLyId3SYU7P/Eo+nSPpDhlE8CIg2ZKaKZ4GE4OmoEw3EFfkoxK3IrCIoL3I1zpHoxocLSpQh2abofdRcGAN3gQn6p58kSuHUgrCl0wgALf3DsJwiegRbX42+/tkibqQLdW/ZMfy1uzR/E9eBgmBznavZA8TlfEx1IjTqpe3bhSKZQ/lB67kU5zOlp6oJ4M8OMIDwt9YtmFXj0urD1Fqwyv/XeZ+XxLmCXPKAzuXuGoQfExKTEukiR2CuEkyFcHzXH+KvvBRQkdAS8lJi/ljZl+OnSO0q+UO0FSIgzxGghgMJABbHntdPdkfsaGwPnRdEpaYwV/NTE6AS6pDfKYKZhF+5bbR+UILx5Ai538mkOvscjQhHWv3R4WOaOSm+mkNVYB19rYJLHjT36qcLWJ0sfJRGAyds1pgms56PKVxclUhfyRb95SX5WpOUJSFZdNHGb/CI4Psz5VHYtojDYqeitS+qlth4fhlSkkGznILQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(66476007)(4326008)(8676002)(66946007)(8936002)(6666004)(66556008)(2906002)(110136005)(6512007)(41300700001)(6506007)(83380400001)(53546011)(36756003)(316002)(54906003)(31696002)(86362001)(2616005)(31686004)(26005)(7416002)(966005)(6486002)(4744005)(38100700002)(5660300002)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wkh6aW9sQnpJRFFRVU9EblBpSE1aM1hMWmVKUkM5UTA5TkE3S2h1NnZJSU1X?=
 =?utf-8?B?UGtRNi9HQXgrM3RmcVZtMWptNkVqZG4zSEdyWk8wTjJ0WWlWZzZzNm4veGVM?=
 =?utf-8?B?RVVjcjlhaEJ1cjlFTlcrOUVxUjBQWkU4MzNqRVZpNFlPTWgzNHRQTTYzallE?=
 =?utf-8?B?dEdOUFZsTnJHWHlocEFnTUUvekxXV2JaTE4wc2dsWDJXQkRVVXJ6YmlZZDRl?=
 =?utf-8?B?QjZpL3c4ZjdLd1dUVStUU3dJUTM4WGh0MDMxOUpqV0dnOG0xODNrN2ZmVlpF?=
 =?utf-8?B?YVNINmQwYnYyc3VrQnVubDNlY0hxNGNTWFhWNFdnVHhuRFJjdE9HQ2dIUFdO?=
 =?utf-8?B?ZktZdzA1Q0Y4NnhGRUpuVkd6M0lUK3YxaW1SL3BLLzlnbkw1cDg0Wmc3UnRO?=
 =?utf-8?B?WUFYcnVDTjZXSlJzMWE4YzIra3dlRlJOK1p0RTVOSU1JVk96aGtWeDlWZzBR?=
 =?utf-8?B?cXZXYnljWkNFQ3pvTmd3d3B5RXQ0aWFMUVZBSW5lb2ttKytwdmMrQlVYaFBj?=
 =?utf-8?B?cGJMWktaL1hzVzNwTHdYWU1HMkN1RWpmWmFSaGYyQUprTSszRldDemdxWjF4?=
 =?utf-8?B?UXpDYkwwUkRVYzMrY3d1OEhHYTVVMWE5MUF2TWdodGUrMTFBQWR3OCtpcjRh?=
 =?utf-8?B?TGVWNE1va2xDM29Ta0NtTFNvdXQ3bEVjMmdLeGxNUmtmajNOZEpHM1VmTnd1?=
 =?utf-8?B?alZzeTBNMnVTeDFRdXlFdkZLS3BUOXRNMitKaXRXT2ZTek9NRzd4Qml6clhj?=
 =?utf-8?B?aWdWS3BValhLRDVSaVFSaXRaNXh4amJaQ05TNU45OXFrazlPSTgrRzI0NHls?=
 =?utf-8?B?WVNpbml3cWJBbkk4cmtSUjk5WkptU3hPWHpyclIzSldFejI5SGg4dWxNSmlP?=
 =?utf-8?B?WURSRFpLVXVlZU5TWGNySjBVYysybE9xekswcHJUdzF2bVZYWUJnSXFxSVhQ?=
 =?utf-8?B?NExHd081Y3RxNGx3M0I1MUxtK2tCOUJyNC9ramdnMVRPblJtSzlZSDNLbG1S?=
 =?utf-8?B?UDdYY201NVlSNFJHK0JSUUxlM3kvRE1ZbExHYjZSUjNQR2JBbVVzNkJlMnl0?=
 =?utf-8?B?MUhGREQveWRKN3MybjBUM0dTbVFER0l5M29HYjI5cHpGYTlOc0RNZ082OHpv?=
 =?utf-8?B?Z1BRa2xKdmJPc20zWWRFNHUrNUNPQjRIVjRSMHlFSmVtdWw1WTdVVEJubzd2?=
 =?utf-8?B?WVd0eVNsdGh5aHk3VitRUWxscmFoVE9uendCZ09oY2hyR2ZXcTBrL0hCK2Ja?=
 =?utf-8?B?ZHVQY2ZxcFpKMVhtMXcwbWVLMTVvSG1haEs5TjFXRXMxaUgxQTFuOThJbjVZ?=
 =?utf-8?B?ckhVNXRoZlE1NlJpdkgvaWYwTUJaMXVaTUc4b3JLaVRRL2w1MGtoWkhGVFlm?=
 =?utf-8?B?cG5QWXRCakdiQWxwOWJOV3ZwMDFVV2RJK28vbk1xQW0xVGtNMEhjTkJBYUhD?=
 =?utf-8?B?c2IxODR0NUc3MTdLbVpuRWZlSTIzVEM1U0ZHeWU0MlV3RTB3L1Eva20yUmhM?=
 =?utf-8?B?YTdscEZWVWdDR0ZTUGY0bitoWWJNcnlGTVdZUWdUSzd5OXFwM3l1b1VNRE9n?=
 =?utf-8?B?UDUxKzRscnFNaVc3dS93a2ZmTDRBc0xwRnp3SGxQYjUyYmYyUlZDZTFaRlln?=
 =?utf-8?B?YXliNjE0OGpyV216TjA0M3Jmc3N6TWJVb1NaRzRGLzJ5b1dka0VHNHFDc1BE?=
 =?utf-8?B?U0ZzU1ZkNldIVzhGMTVBb1puMXp6cmVjaXZaR0l0ZDVvRFNlWjBaSHZRMWF6?=
 =?utf-8?B?czRWQWFhZ0xGS1MwQkYzbVZQZENyN0ZPNFErMC9MczRjaTlJVlQwbGxuTFVH?=
 =?utf-8?B?bk0zSUNML1VvY3paSVI1OWhtb0l3RnpNdXBGNXNyWm1EYmk2VFlHanF0cmFq?=
 =?utf-8?B?dC9LV2ZOOVNsS0hsR3M0ZDgyMDBZMnNMY1d5QzFna09EbVNraUZ0dHQ4Z3BC?=
 =?utf-8?B?aTUrbmtBNnpwZDRzVnBrckNqUjNjL1JQbHpEclovYTEzNnpJSFZWd3pETzk5?=
 =?utf-8?B?M2J1UWFxMmYyZHRRdVdKRDA5NndiTXZhejVLbVVDaE1CNm9sd2h1T3k2UDBC?=
 =?utf-8?B?UXRTYkNVMlEwdFVYdnYvaytIYWVHa254R2laVnpibUxNeGFXWkk2UFkrZStN?=
 =?utf-8?Q?u7wnzr5uNoaOfU9pk/kd5bomm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355acbb5-ebe2-4450-ddb1-08daadbeba1f
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 08:33:10.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G727GBSMMBxW7sFCOzU6wQ9zCZRqsuu3V0kAkQS4JJGTHELF7dMJQn9AzQVj5JYRX5iXPJp9w1u1Aj4o3nWhtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4472
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Shakeel,

Thank you for taking a look at this report.

On 10/13/2022 9:22 PM, Shakeel Butt wrote:
> On Thu, Oct 13, 2022 at 7:35 AM Eric Dumazet <edumazet@google.com> wrote:
>>
> [...]
>> The only regression that has been noticed was when memcg was in the picture.
>> Shakeel Butt sent patches to address this specific mm issue.
>> Not sure what happened to the series (
>> https://patchwork.kernel.org/project/linux-mm/list/?series=669584 )
>>
> 
> That series has been merged into Linus tree for 6.1-rc1.
> 
> Prateek, are you running the benchmarks in memory cgroups? Can you
> also test the latest Linus tree (or 6.1-rc1 when available) and see if
> the regression is still there?

I'm not running the benchmark in a cgroup / container but I'll rerun the
tests on v6.1-rc1 and let you know if the results improve.

> 
> thanks,
> Shakeel

--
Thanks and Regards,
Prateek
