Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78EB5AFA53
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 04:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiIGC5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 22:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIGC5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 22:57:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73F7FE66
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 19:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzycBm0bYY2wdLF+DDBWPaABubrrRQj1DGxKxX556V6dzrHJuLsJjFWpQsbtVSxLknkgBjSFACc+d9XMZ76tdLoRmLwzqbjExXSJ9q0dYVOV/hiboAEmjKJHt462FpPhCSZZZauoI/NTa5WAmYGbIPi4yFwvQcYIIubGEH34SFXxQuXvvbSdqVrLbkxdx8YwgwX+qwVnbmmbSNvJ9sK7o8rwroozhBUIChASbcc88GP4EjKwdJjh9tPB23Q1XTMRHchn2IwlVhfNdQwRZum2KWALqAzIyebRYRx2BFdPDSBaZQy3qCaNZ9P/gKY3/8/FjzzLSMlBpM5GlxdWF+UOiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ewVRjyoLWjnlKwBTeZeC9d5X1byZYyV9kySRuL2IGE=;
 b=oFuXt8az8wMKLRke6vpyN702PmVVvfuJVKGxEXiAqXfL9xO7DqQvCQ3Vq/F9/jzMdqj2hleDZjnzJ+nZ1aza1YR+NAKXb2w2U6qGEG+D+JEwSqMRGYVaT2RNC1yiJmdbeAyqMXqbjXrd2PdzkC2YXeQlZcPldNZ0+lFq0ltW5qdc5QvJNptsYZByNF20IDsHBML+L9TZBi4ss81ubnW1vr7HyBSF6cyHwAbunngKcjfWsB4B4OykqfsSslggtG+lmsa7NSxyNJa97cpJKuDi41Qz5vyG1n5L0Ep2fTaGwX7NoBSqoAad+I0rd9oXxp1TJ6T9fOPEJdlpoDL4vpwGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ewVRjyoLWjnlKwBTeZeC9d5X1byZYyV9kySRuL2IGE=;
 b=au0piMFoBj27mpYIPvN4S5Sr8Z55KI5N253Vv6qu09yifVf6aMu7u6xyQYCdpJtA3KKIoHtGxg867sg7q+Mlgy5G0gHFn7spzcShJAqwlDkUAOv+ywJaThyeSNAv4vuMqiiW2mvaEb7ehJ7uT6zxrQ/3VFUnfvgI+W41sM0en46viOA4E2qJ7dq7+96Ed9y+hRTjwdErid3X/xiTkdioJ1atnUB82TpbTZEnGFTSFz+TXd6v2yD3tLlH9un2wOSRKxx2fkraLsCz+M5AHakVMaFmDE/W5K5U6sbCsKCf8hzU7do0TNGfinc4GbokGVJU8DdKvZZZ1a4Z/xv65HSXRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by PH8PR12MB6675.namprd12.prod.outlook.com (2603:10b6:510:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Wed, 7 Sep
 2022 02:57:12 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::c4ee:2739:5cbc:4f7c%6]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 02:57:12 +0000
Message-ID: <76fca691-aff5-ad9e-6228-0377e2890a05@nvidia.com>
Date:   Wed, 7 Sep 2022 10:57:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [virtio-dev] [PATCH v5 0/2] Improve virtio performance for 9k mtu
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
To:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com
Cc:     gavi@nvidia.com, parav@nvidia.com
References: <20220901021038.84751-1-gavinl@nvidia.com>
In-Reply-To: <20220901021038.84751-1-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c0fdc37-a399-46af-f554-08da907ca975
X-MS-TrafficTypeDiagnostic: PH8PR12MB6675:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTieR1D4lsT72Sii7OMczGVGbY+ruDoqkJdNQpPAqKA9l/AYh1h0yZL7jBMXwM7Ix/hLa4lxv0CVlVYKNchwp+YSpQKGpd8QCG3HYD+3mX8q39mLzryhU+DvgKlkVTfOG54Cg2Et6NjMvLBWi/ytgHt6VRm62MaxEhHfHZLOdzKdXnI3bFOknYk0+U/MLu2JGG6f5TVksRvnW5qqLy3ISdhuS28Oae5Ndf3S2fmcpUgMpmJrJThY3qFzc4aDYvLobQn28PD2lV0OeKx/rTTG7GAeeErCPzyfo1kEMs+4KaotKpCPx2RTfmwqlKYNa2rf8+BIKQev8kBzafQm5IbqryRx6AWIFfGbNOTgdxfEDQ94Jm+XpFwRq97JtKnyYf7URzYGURjkykb8fCLidAlrxXtLcAByfu3JwvXl0etuCBLKW/SJCrZgjqcrTqyF1Q3UNnWQw4K1LMXsZ+jD+NNiofSMgZBiYHwbfPGKnBtFK1ZKirHZpjhA1vseL51qh36MHzT8MKrGStDmwunO2hGGFFR8m/Lg786PqoARMiszhMGOmvVGfIgags4ztaJF6KD6U9X9HiLWlgjKeAus/dgPFq1TmeT6ELxDqZWEe8l0FYU8zfyedAvt7tFTyWFAXHa5z2SwPETfInSnIxucL3/1CQhFcgTMdELqcUbnmbANrqfoIv/jg4yI2zzVSgmNjKrMDucs+dkWXgvZ+mdJEviQqT1pDGpr21GB8AtvHVjy8w6rj53cuJ2G8iIFeMd1I5YUPiEYbS3Au2S4ljbr4s7O5AXMtWgrmZ6xc/K5au/jPIw9sYy1cZyDLAdZhQaXwoVr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(186003)(4744005)(2616005)(6666004)(6486002)(53546011)(8936002)(5660300002)(7416002)(31686004)(86362001)(107886003)(41300700001)(478600001)(36756003)(6512007)(26005)(6506007)(83380400001)(66946007)(38100700002)(921005)(31696002)(2906002)(316002)(4326008)(66476007)(8676002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2pvVDFLQjJZYlhuMnIwTzV3UHZCWFN4Q1RvY2V6a0FBV25nRUhjRGN3dDQ0?=
 =?utf-8?B?NnZmYWhZSElUY1ZnbVBReHZEZ2QzUTJteTdldkRBc1dlbjNGaHQxQmVvcm8y?=
 =?utf-8?B?UmJoWnI1YTh2VCtBSmxwcnRxQk1LQjVyNDQxd21TWTc3ZmdncEhiaUUyMzdK?=
 =?utf-8?B?SnpsQ21BU1p3dEVPa0h3K1R6emwvT2JIRXIvRERDOGhWeU4rQ0Ewc3Vlb0l4?=
 =?utf-8?B?clA5T1ZtSENDTnBVek9iQUprS1lRVEpkTk12QldLUkhxQXIrKzFMOVVtTXVV?=
 =?utf-8?B?bm1SdmRkK3UzQ3plbmpFUkhFNkFjWkp4UTFTMllKeHAzVFNvU2piaTgyVlNu?=
 =?utf-8?B?M0p5MC9Fci9KbnlxZDBkcGFId0N5Rmw5dTQyY3FwTHBqZk9sS3JLaXVDSnpK?=
 =?utf-8?B?RjRLRnFUdy92RjQySllQY1VZL0FuUmNpNittaDgvV3VsMjVIU21wa3NWTmNn?=
 =?utf-8?B?cDl3Wkx5eTBYYllRWmdYbWpjb1dJOHAvQzAvT241MkdDeGMzM1FRY3hNQ1RI?=
 =?utf-8?B?b3p0T01MaHdhNmZEMmtTYzJlbjdyRllObGF0cFVOdDhYeERKV3hpR3crRlU0?=
 =?utf-8?B?UTFKb1B3NHFSSklwK3U0MzFpWFhoZHpaSWZ1cjlSVlhLKzViUmIxbEZxbnRZ?=
 =?utf-8?B?cmJTNkdwcjVJYitxV3M5Y2ZaT0J3S2d4eEszTVpTb1VNUzFUbll3ejU3Wkdj?=
 =?utf-8?B?MzgyR1BOYUZITFhtMk4rOGhiQVNWckZUWVZFM2ZibHdZY3dMNzdFRk1TS29h?=
 =?utf-8?B?RjlnM3ZjYjFOYnpEbjc3RWVFeHRKRm5xQ3BnbkQzd2ZudDBQcEJjM05SVVFy?=
 =?utf-8?B?L0FWUDdhUnZIVnNRZnQwRkl5b0RNZ3ZNVDFBaWs3M0JwYndyZ1hTVmlXU3RB?=
 =?utf-8?B?VE9wTGlER1BobXEwc3dWWlphMUVqS2FnWFNLUi9NOTY5OHVodmJ1MUZNNUF0?=
 =?utf-8?B?ekdmY1d2VkM0RzZ1Vmx2RUk1RE80aWR1cmF0TnljeXA2c25mall4RUxsY29n?=
 =?utf-8?B?VU9WTHBBUGJBRlMrRHk1dUFjV3JqQVFrek1BZlJEUENNVlNoZk9TTmdVTVFR?=
 =?utf-8?B?VzQ5L2RrYjJqbGR6ejErdWUxOWxERDBpSmlPZHBzN3BmV3BaL1JSZlpHUkxO?=
 =?utf-8?B?YWVpbjNUMXRiTVdvTG1qcE1RQk96a3hYbmpUOGlKVkpuTEs0eFRMOGRQNU5Y?=
 =?utf-8?B?Y1VsUWQwSTVnUTdsWjlraFVaY0ZaenZRSlFuUkRyeVVpd3RrZFFxRVFnMmdC?=
 =?utf-8?B?SERHSVJUTjFuRlo4bER6ZHhEczJMTHhoeitzSkdxaXRUdUFkelRCa0F5a3Bx?=
 =?utf-8?B?MkJ0ZldHTlQwQ3pkWXkzYXFjZWFCb1NYak13dVJnV05sMGFqUHFuZXZYaUpv?=
 =?utf-8?B?TUNOeVhOZ2Y4ejlGVUdwUlhSTGZUMHBkOE1uT0k1elVLOUZiWFgxc2VqUXNW?=
 =?utf-8?B?T3dLZEFoOElINktRSkdUZmtXUDRJSXBna1lNV0ZGR0VBdk9yTkw5NWpJVkdy?=
 =?utf-8?B?VDVTUERsV1VtWkJzTEpSNHdlS0tJUzNWUnN2MDc1NTJGV0tGcnRuZnh2cmNo?=
 =?utf-8?B?TndheTZRVFU3QkswUGtxZGg2djBvOHdzMHFBQ2hmOHZ1OEVzQ2xPaldGeWEv?=
 =?utf-8?B?NWJEeERHM0t0c2dNVlFkMVd5bzU0dkM5U1FucTduV3Bvazk2UmwvdDdlczVX?=
 =?utf-8?B?WHR5bjQ5NFd4WjBZRWRsbEkwd3E4QWY4N3oxUTUyT0ppVnlkdDdlNFhuc1Uy?=
 =?utf-8?B?U250L24ycVQwdFVrUEFUVi8yaE9WbzFMVTBZbEd1MUhNMU9TS1FvTGhNM3Vu?=
 =?utf-8?B?VC9aMHF3Y3lDZlFpTW4wS2FwS1B1VjNSc3VtNGM3VXkvMmRXcEx6V003OEx4?=
 =?utf-8?B?VTVCcFNraHJjbHRMWllVRUs4Vk8wUXRsNjcvWUZ1eTZHSlhxTmNNdkl6T1NW?=
 =?utf-8?B?M0FLTkU3MENlQlMxcjV2SGtiQVRBczNXQlhhVnhDMDlweGs5Qi9yeno5dnlt?=
 =?utf-8?B?aGsrNit0aUxmS3lKYlZhNVNQcjdTdnBWWWxYQlVRYVMzTFYzK2NyRzlCeWht?=
 =?utf-8?B?MXhJOEE0M2lyd1VhN28zdG5aRDVmUDFvNnlqQjIvd3JhWWg5ZUdPakpudjd2?=
 =?utf-8?Q?KFmCkq5RaF3Wxst8C/jrYSifN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0fdc37-a399-46af-f554-08da907ca975
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 02:57:12.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viN4DvZhwzaEBhuZhEnpyxsnlOPQw6tAftYsy5+A65iaOHBrA/VtDzVX0LT+5/syPqlZJhU+sVEB30TW+s1UoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6675
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub, Michael,

Sorry for the previous email formatting.
Should this 2-patch series merge through virtio tree or netdev tree?

On 9/1/2022 10:10 AM, Gavin Li wrote:
> External email: Use caution opening links or attachments
>
>
> This small series contains two patches that improves virtio netdevice
> performance for 9K mtu when GRO/ guest TSO is disabled.
>
> Gavin Li (2):
>    virtio-net: introduce and use helper function for guest gso support
>      checks
>    virtio-net: use mtu size as buffer length for big packets
>
>   drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
>   1 file changed, 32 insertions(+), 16 deletions(-)
>
> --
> 2.31.1
>
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
>
