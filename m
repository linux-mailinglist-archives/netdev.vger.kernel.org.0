Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB569009C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 07:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBIGxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 01:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBIGxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 01:53:05 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9411CAF1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 22:53:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrAi8ntbSjl/nL7UzIv+byJekvt3plptkwMCk1umYzqoT6UQmwj8I06tMSCO23egiuoI9YfIsTMz3ufTkL7ZR6L2PJRWqeBz25i7xaQXg6DyVuZLiOTthsJvR9UfCjSFThLjc41RY2SLTSNR2ql5Af+Wu/stWQ7zPFWXDC/kE6Hwm58wkLdKvUmnsdDkMi5T8V1Lh+BCp9iUhkar8Sqo52sl7GyBzsGNsV/9sZa4bh8iZucGmJpzMy7ktN/ypb8icJq3Z3gdWnpLcScMwir7P0KQsZnEfXzt9FI87Rdn2Q1Jh+XL+UqyxYKclO+HT6HgORIIWF4Y5SuJp/QH0CuuJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYvawmqZdNU5I3SCEGC1gIV4Zz5wuhunT6uHRF730Eo=;
 b=N0GPtAk8MxrZ/bp8p94Ku5ocYsp3+nPS9UByMHFT3jIC/tJae58QauqApqxJ1ghhwJBRpQBXYu3dIQqlcIvivNqCCMtrT1wDoE3cIetuZKz+qAj9U6MUXGbwDsBCEcdBGtsxcJdHpzs6Y8dBgj3QCaDpWK4M5cRbT9rfF73rPjAmLLn20wdNqwTfdp5Wrgz4urSHTDD3h6Q6SY5SFZxjix4quNFSDNFF8up1jWO4XluLavQIBK8PB5s7LfH+9iJDMZSBry+adBlVZ3xUyNEqdFqwotYUFcA7lCM5oM04H3R0YIdD7cf9cHhdf1mHvcsl/GhltyOg+faT+zTZW/yHqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYvawmqZdNU5I3SCEGC1gIV4Zz5wuhunT6uHRF730Eo=;
 b=dut+X8Fc+oHn7eOS8oUuundMmEr9OLWhNfEFzGVsyRDjXuNsRN2pHNE1mjHXHuNxXWeq+bM0s/ZyU85KKouIL8gmWGrdP6UXksZ29PiS4ZwS8E5h0TN3jNZuOJFCo8BXF93m8AIgiRvOUWRSCkhGdxRApsbjzEXfDQM9mXfKyI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB7755.namprd12.prod.outlook.com (2603:10b6:930:87::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Thu, 9 Feb 2023 06:53:02 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.6064.031; Thu, 9 Feb 2023
 06:53:02 +0000
Message-ID: <c2cde083-3d7a-5fda-5970-ebfc6413f43d@amd.com>
Date:   Wed, 8 Feb 2023 22:52:59 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 3/3] ionic: add support for device Component
 Memory Buffers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
References: <20230207234006.29643-1-shannon.nelson@amd.com>
 <20230207234006.29643-4-shannon.nelson@amd.com>
 <20230208215007.1c821ef3@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230208215007.1c821ef3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::39) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: 002276d0-efcf-4135-38b8-08db0a6a49a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EQI6NPnHy/hmt9XubZljfUM1CojcOduTFOzH4WdfwPtAkweOrJ0/ArguwYu10i5ElOPH2+HEDXvTtL09SEtXkB65jTeSgqkrEP1Nil2tUU1z5UDLbLy1RqNPZ5ccPYxB079QgsG6NVIbmeahrbaPsLdkN4F5nyhMlHL0KGZZSYslt8IGuXEa1hFrfRouY7S3v7ZLzATPdrzwmpdIVXcItEVJG6u7WuQnySM+Rhj1QhzFQKJ/4POsDRm4fqfxnCjeadjS65q1vXQETtvNb9KXjlPpauBC9eMGwCZH4TgjRqIKnL6IfN/JM8ZPSe8/btac610xTu3YitFq2Pr98TgDAco+Ph2YmHfbh7fp2Ai9wtycUL5bGj1pmvQpwA9oNVZZsbMlXlhDkToSjBIB94MikGvmrzx0N3hunf5DmX6HDe9AO4sdTJ8imUcF+za+pXYcV3wnsYyLJjZVOwrFoTHpR8OtdS4H37qWWU2yHzsSBMPSj8xs8MuVLMNmSXqHT+BruHPUh86PSPs8alT9Kz5igLCp8WrcjoErxvYKLf7t74g3eKX37yPSPJTlEinNsEXglxSSck/n+Phma1tqdz3XXVCgAW79EocmBVhxKlSoEQV5owu4C23Cd9lkz2aeIE9oLAuXKqcVr555g3cpizDdRxkLaMC77LMqh4t9BeBV8FQBNy8PKNkMRQGABCdCcuezqcSw4pDTgksvLeyLu3s13IP8Z/rdddc8jGUqeNsroxk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(6512007)(2906002)(44832011)(186003)(53546011)(6506007)(26005)(36756003)(6666004)(5660300002)(31686004)(478600001)(6486002)(8936002)(41300700001)(2616005)(4744005)(8676002)(66946007)(4326008)(66476007)(6916009)(83380400001)(66556008)(86362001)(31696002)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDdwQ0Rsd2hnOTBJR1JHM3RQVVRyN044eGNyM3UxSVZIdzc3REpJdi91WjNO?=
 =?utf-8?B?ZWxITlZqeHJJRTFna3dBY3d2N1p5NW5IR2F6RHVhRjQweWVEYS8xbU5UTmRk?=
 =?utf-8?B?clBTQUFqVEV6bm5ZVExwbXlHQlp1SkNhakJ0V3VzQjBoeHdvcEZ2VHhHRURO?=
 =?utf-8?B?ajQyeEM0UmVwNVFQK3c2OTBnaDFvLzI0Y09xekNkc0JGV2tQMHluOW8vOHkz?=
 =?utf-8?B?c1haSEtzL3U3MFBPUWFDMkZZM0JBQlpETWhxcDFCTkwxSkQ5cm0rbzRnbVpl?=
 =?utf-8?B?cjJUb2JTQnp1ZmhyUTA1azR6cGRqOW81MXpqMUVYcHkwUTBLZ0FaWnQyVnN3?=
 =?utf-8?B?dVdUcDR0a0VDLzliNEFwcklIYVhCRTVGa0UyZzU4T2JZRmtSZm5yVDBWQzFz?=
 =?utf-8?B?NzVIV2lja2ZLNnhjUFdGT0M4T1A5dEp5Q3VJbmpkcWhmdUVEeWg3VlhXNHdS?=
 =?utf-8?B?R3BEYTY1aFBiSFlLakJOdEJreFFQZUYrQ0lhNng5Wkpmck1JS3ZMV1czMWpK?=
 =?utf-8?B?RkYxT24reHU5TGJmYWlXME9QR3JWeTl2WlpmL1MvbzJaYzhmNGlzb3lVSDd4?=
 =?utf-8?B?SjNwc1RhVmlKc1BuS1pnQThwTkM1U1lHZDRqejFRaUwvS2I1dDh2NUVTRWow?=
 =?utf-8?B?aW5DZUt4aVBYdzhuZ0xyRDhsYzhoZ0s1KzVxUk5FbFErQTVCNkhhdHJ4VjY1?=
 =?utf-8?B?QzBsdmZ1Y2gzYUIwR25PcVhDTGFiandvamhicUY0OVRJSTJiMnhBSk9ZNXdY?=
 =?utf-8?B?dnp6cGh4Nmt3RkVTbVBqNVgrNzdNQnkyQ0FoU2hSeS9lVm8wOWZHL2FvdlJK?=
 =?utf-8?B?cU9VeWY4b2NrQTVUVHR4ZEFsYndEWFpDTnNHUm5HdC9MbmNLcExHQnFGTFNu?=
 =?utf-8?B?OGU1MFVVeUxEMWtHOTRPVGpLVC95cDlvZ2M0NEZjaGc5SEsxclNQTVY1OXl4?=
 =?utf-8?B?TVRWUVlWZFN1aXgyejR4a0hFaDlwenh4OGpkN1orS3FQV09jaHJrRFN5U01m?=
 =?utf-8?B?bUdOK3FWYWhwWklkaG1iZ1dNTWJOY0NGeGNXTmZQWE5PaEk5SmV5cW1rK25Q?=
 =?utf-8?B?TGdXWnExTTdyNUl0QzNrazVLSkpjcVkxSmc1eUlFQjdFalR0ajlEbHhiUjFq?=
 =?utf-8?B?Vk1BMTN1aTBlRTlyUlBqdUdNTythbm54elFrU3hpbXcwMTNRREdlYlFLdnBt?=
 =?utf-8?B?QzBFWjRQTkk2TTBqdVBvSEtzT0JGTWtMQ1pxUk1Xa3QyWHFTNnJxMVFVKytD?=
 =?utf-8?B?MUtIU2Jtdm1OSTIwVlo2bXZYaEw5SGtaYzhsMURCampCcHF4T3FsU2RybnAz?=
 =?utf-8?B?TWNvNHNLRmtFcUNRU1VNdUpNWDZ1VUtVaEFHb0U1aWk1L1RYcm1sM2RDRTN6?=
 =?utf-8?B?dHJoKzNBMlhWNThucUcrakRDZUExY2tJN2JhRFk2WVprM0VFb2FsVkErRGtG?=
 =?utf-8?B?VjdHQ2tQRjRRL2hOMFJVMExFYmlhR05CSE93YithS011b2ZlNFRhSlEzY1Yy?=
 =?utf-8?B?dnhqcmFSWjBIc3hqZ3ZKVnllQ3R5M0lzVEFQRnRJbW1pU1A1akk4UGtLWmha?=
 =?utf-8?B?QjMyNWlKbTZhWUc0aVlkVEdUSzlEYm1sb0N2b2pYMmlzMXZ3K3RQWU1Gb3VH?=
 =?utf-8?B?ZTVmcldsU2NCYk9BUE5UdDdlejY4ZnRHWk1oZGVzTTJaUEZPM3piZkFFc1hU?=
 =?utf-8?B?OC9WczU3YnkwemVyOTFWZGN6aEplOWtzaXpsVkJSMC83bmw3MkozeWJOMTFX?=
 =?utf-8?B?N1ZWNjU4ZUFVdUZobEV5cDV1NURsSnU5c3dxeE00LzdJU3JFdzM1TWZ1MWl1?=
 =?utf-8?B?VG5NcjlWUWNqVUdURktMQ0tKclkzN3hUeFFPY1VGS3pyWWQ2TlRPZlBySmYr?=
 =?utf-8?B?TVJjNnVvZWhJRlQvejhDYVg2cFpJOW8wR1VKUzl1ajRlMVRiQXBTQUJ0NERQ?=
 =?utf-8?B?dEZQc0VUVllsTm81ZzJ5K1IySGF3a0MzZnNyTXpjZHhwbXp6UTljVmJLN09Z?=
 =?utf-8?B?V2dZK051QVMzM2dtQkRZelFEN2lkZ2JvOHpVL252Wk5nTWNtRENnbnN6Nnkr?=
 =?utf-8?B?cEtISnErNjhhdmYxajVRZktOT1UzQXl3TXVjTjFkeE0zdnRjYnl3OEh0NTE5?=
 =?utf-8?Q?W+c1IcnNxI6eCJ/wAweY2e59X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002276d0-efcf-4135-38b8-08db0a6a49a7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 06:53:02.3594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kr0Yt2gW8w0kHgHHWaI1gWYX7uAQSar2PQ9YTMdvxf7hmRPjvaivXj9dz5dX2sHXneV953Pp9fYYHGAp6zGJsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7755
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 9:50 PM, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 15:40:06 -0800 Shannon Nelson wrote:
>> The ionic device has on-board memory (CMB) that can be used
>> for descriptors as a way to speed descriptor access for faster
>> traffic processing.  It is best used to improve latency and
>> packets-per-second for some profiles of small packet traffic.
>> It is not on by default, but can be enabled through the ethtool
>> priv-flags when the interface is down.
> 
> Oh, completely missed this when looking at previous version.
> This is ETHTOOL_A_RINGS_TX_PUSH right?
> 
> Could you take a look at what hns3 does to confirm?

Hmmm... I hadn't seen that feature creep in.  I guess I'll have to hunt 
down an up-to-date ethtool and experiment a bit.

Yes, on first glance this looks similar, except we do both TX and RX 
descriptors when CMB is enabled.

I'll look at this more tomorrow and see what it might take to roll it 
together.

sln
