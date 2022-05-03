Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61897518ACA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbiECRR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240119AbiECRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:17:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBB139816;
        Tue,  3 May 2022 10:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhhO+CshGLtr0EDi77ZiGtMnhRDhO41vhrdF7irZrRnMzLdQcdSt5N3tl+y8RVxJmiOfaAhJfIb2iQ4DLi8ZqEm1nBwX6R7MGOoawUvHBqJbuFzhESiQ0uU3c5or2Ir+FjjUFuE18NWB+/Xr0jBCp5ArbGMtNDd7kzVj7PVOsQXp7+ruXnn222ED2blu3k5S3IVUuqVUSGJwisq2W8S1iEvu5azZO7LdXLopA58xA84yauxsxKHIljAYop6FL2EpsxF3iROPVqU9YHx3WFIzVdl3ffs6YW7dWPoNozfCITuy+r5leEGsopk2rXJYS+W4feYJXHAGxqIBKEr39qwCIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vu18XptJmXDYd1FgmwWXxeRXH4IsJBCNTpxrDIND9eI=;
 b=ZTH4B6OXROx3gsrnr7Urv37IGBmz8H9tQK7TAhjYhVS+j7B6iJhm7lbEce5dkbEQfr97w3bzuITaKx2ffEQZyH/On63iEtlMzvdDg8gzclqhokaxIVV9e1PepYrc50EaRtSnPTChqalOKluKHC2unxgQrIhuFhlowFxAq+9lIl9M537IEE0LP7Aw7v2HXj2Xmm8Bn8gj+hzVvKQV2VpVxn4E6Zo5gqggUgyKghn/ILu9LHwDvbieJgRQ+MWK/IpamhlGiGnv5lACoaworQqhZ7R9G4QoWRr5J0TfTujxcPavi9XEVoN4AQf1MyDWYoKp3QqthXwp4WYcSsHVyKn5yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vu18XptJmXDYd1FgmwWXxeRXH4IsJBCNTpxrDIND9eI=;
 b=Ht5GEeRNk5oOGsaJBwx2oc7a8wS7tCi3x49aG6AJRLGJ71sRfgjspxhJsAeHvR96OMrErsslqeLQRSBvNX/Z3fhfdj6FdB2AAtsz6FYSJlfhnWPYJ6P1hSh4nDfX1o70wgQVCjWqB1QAC1vvvqWPOOeb62x051CE3mk7s8bDFxxjFr8nHKxJcJpsCkUaWCJNTibRNBrel4Tvy1t5uDShcNsoa0teX7WeCG6103Cu6m0wrohFH3+AfbPHRoiqi0LWK4tIPwO4w3cqnyb1dkUc6IT+qDcahbd2ZrcdExIBQ6BfgojYRHFbp4Ma0/V0tZVCqzlqlf56jBZVQi7yw5vixA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22)
 by SA0PR12MB4398.namprd12.prod.outlook.com (2603:10b6:806:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 17:14:17 +0000
Received: from BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7]) by BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 17:14:17 +0000
Message-ID: <873772fc-9ec6-b9bc-4671-8c59150b3050@nvidia.com>
Date:   Tue, 3 May 2022 20:14:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v8 4/5] bpf: Add selftests for raw syncookie
 helpers
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220429111541.339853-1-maximmi@nvidia.com>
 <20220429111541.339853-5-maximmi@nvidia.com>
 <CAADnVQJrRONd+pPpfahyzLG7WCP54y_eoNb_8zCsN_m=S_OSZQ@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAADnVQJrRONd+pPpfahyzLG7WCP54y_eoNb_8zCsN_m=S_OSZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0099.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::20) To BL1PR12MB5142.namprd12.prod.outlook.com
 (2603:10b6:208:312::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95e08384-6be9-4313-be52-08da2d285ac2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4398:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB43984586C28D9A6A8787D8D0DCC09@SA0PR12MB4398.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oalrFzqG/Otmg5pRgOLOsiU5u9P+QhSfM6oE56cDKc+c+BAicCWbAXkFzNijrbg5Fda9cBN5YZzAT/YMdD0mRkh4TPtUjgqF423B0aoNPAkAv1Q0UDtWdbfmihhiKfa0LYiWF9geCgeMmftx8GqXHsMcLNQlBmpX2lilSY0zF4VyBRTXSupdjDJaio00hNQttvaC1ipTdCNolh82BCoI2Qv2Q/DztMW+c6QNyfgRIRZ92ibhc6W1hsM+l47t2fwgEfAjKBvMYPgpNPXqlvDa+BZKpCBhKMeKWsOZG3xF8FdYZQEgwe/OZMKQf+zjEoNW85xdwMby1o2fqYjyCii/G+k1E4yA7vA5LmHHnTASImzfhV2hKOw/JGvtYQEU9AZIoMP2ydbWEMsuMgTGcDyvgrEVTwP/WPdnZ6bdITk4zB9BOpoUeglH1fN/SxYxBO0scvhMQ3qdHJ4IAoD9cRFXzwt5uKEc5wCP3TCSKE4AaWgpjvXUAppMKE7rjIulOuDKxgGgql6df+GfvEgWVKwXpHt/+m3C9ZogI/+r575NCty1d6uQ9huPyx+Kyzz9futahI3Y+GJ+oRDe7Gkl2HxAghGkqwtPjqy70H+2SFYCUr15QqacSU/aoyZGUK+CrTPoGVOvF2XqYH4oR6C4wVg8gf76aarBVdb4JnGCI0vWGvyccUviEvu3wIxBZwmGEXhb68vXpT+c/zmnksqHyqiEUWv8/PpRrbYq8ZH/inDKfqoN3Skt4OAgDf0X7YV91c71GGIz15J/SEGDr006fWVCJEDg/2vV/Qb46PGmcKUe1ey+yvgqnpGRA/aKAG95uNZk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5142.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(86362001)(508600001)(5660300002)(8936002)(7416002)(966005)(6666004)(53546011)(6512007)(31686004)(186003)(66946007)(36756003)(316002)(54906003)(6916009)(8676002)(66476007)(66556008)(2616005)(38100700002)(26005)(6506007)(2906002)(4326008)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDVCTCtFNC9lWXNSRll2SFg4Nzdlc0FXbFIyekNVSDNvMFJrNitYZWhqUENO?=
 =?utf-8?B?WkVIdjVOQ2RaczNCcHZuYWk4SG9oOVdSbmtjSmxEZUFuQ1JzRGtXTUNtSy92?=
 =?utf-8?B?RGdaRDE1UTBZdDJPSk5ud0ZGbVhlV21XeStlZ1BOSUZTTG5nZUF1ZDBNSGt4?=
 =?utf-8?B?aVYvODhLRjRNV3loSVBuSEh6N0dFdGZGTWh5MlhnOEJmenpldUJTUFY4WnY0?=
 =?utf-8?B?WVdwL211WnoxdDRSVmNCWmlpMkR4YWtsOXYvd0d0dmU4RnhJdVFDbzhFNWZO?=
 =?utf-8?B?N1BMSjVUdFdTYnAxY0podWlQV2l1bisyMy9NTGxieDRnK2EwZXdRemJQcmJW?=
 =?utf-8?B?WjlWR1RMLyt1VW1qME45dXVROGdxcmVmK2RFTkpibzdsQkpvVmcrK1kzNmtt?=
 =?utf-8?B?Z2RsOGhpY1hyWS8rd1ZWbnFvM01XTVN5SlJqY1FyL3JIUGJSWlVNa1RrZWZs?=
 =?utf-8?B?OE9sanF5bTNhU0FlbDh1bUM5NE9GdXk0aGVJclZSM2xVeGxId1R0Z3NVNndq?=
 =?utf-8?B?VWhUVU1ta1lSeGZKZkwvR2h5Q09XNGR1SGthbDhreVpuN0VxWWpmUGR4R2NW?=
 =?utf-8?B?TXNkNDlLcGR4QWx3dlEyR1p4eitsREVkaElOSlJHSXVrQnM3NGVueEo0TjF3?=
 =?utf-8?B?WWZpRmYrNEYvK0RwYU5JMEhNUjR5ZVgxZGVSRG94cVYrNWhoSjBxK0ZadFdK?=
 =?utf-8?B?SkNGOEc4OTZkM2puVFZMS1FVekZHK2JvelU5VGJ5VXBMNGx2MkRjdlMxMWtv?=
 =?utf-8?B?MXRISnFvMHFUdDdESUFUY2lWQTJpbWI1QVFjNWVLM0VKQjRuV0tJcS9jWTkz?=
 =?utf-8?B?c21FM2c0NmZldmc3WngzNWo3RElJNjI4ai8xUjdXbDd4eHBXZktJaHloaDE4?=
 =?utf-8?B?LzVMVkgyNjBrZkN0VDFrRXZPL3dDZ1NYVzV5d0RkaVhNMUFoVCs5ZiswWEFQ?=
 =?utf-8?B?ZzRxaFdXa2lzZXY1b3hBamNLQVBXaFI2bTFJQlBRYlZteE9XOHJNZC8zQldT?=
 =?utf-8?B?Wmk5QlhGdCtFRTJSOUFRMmFTR0w2V0ZtenUvRXZSVGdHL3c3bkdmbHhTNFlC?=
 =?utf-8?B?WVFoU3RsYTg3bU9IN1FIaW1uNEMzUzhxTFVOdnZJQ2pYaytSSi9UeWFpR0FB?=
 =?utf-8?B?NEM2LzdZMmFlNlMwVWkrR1NmakxUYll0QUQ3UGhEMWNoWHZMNU16d25RcUdL?=
 =?utf-8?B?OWN0MjdpL0pmaStoaUEvRE9veEx0UG9nZ3N1WERWMVFmMmlZR2JRTDd6N2Fr?=
 =?utf-8?B?L1VVNk9FbiswVFR0RVVDR210OS9kdE5qRThQTVRrZTUxUWhSeCtPMmRTMXNx?=
 =?utf-8?B?bkZYYnR5SkFlaG5WOXhIQ1U3aGR1VmsxZHpNR3hkSm5Jb3RCVGhsT2ZrakZi?=
 =?utf-8?B?NC9MbkVsQW1FcU1VVHZHaTdSelBJNnNOWmZqSUw4NkhJaFRTOXpkQmIwRS9z?=
 =?utf-8?B?OUs5dmVicndvakpTdkpsaTFpVkFTaUFEQXo4MVdaV3pWUkJvYTV3OGpPeWhF?=
 =?utf-8?B?NGREeXBveHk5MTBGRFZIK2NoTk9KRytwd0pkdVlMc1c1dXZxSWlvN0tGbzBG?=
 =?utf-8?B?bGJxUEs1T2VVdEYrdlZtY2Jkbld4MTZFTUNsVnBQTTF5d2hWU05URUlKaWgz?=
 =?utf-8?B?eHBKdGRrRGtxVVZ6MHJZcW8yemZ1elV1a3lldFQzV2hRTmZaNGUzNlJHQmNO?=
 =?utf-8?B?b0VNSzVpVDM2VVlIRXBrekU5cHVkL0hPOVd6Q240bVlveUFKVm9vdmt6Vlg2?=
 =?utf-8?B?RVNiUHA1YjVSOWdwTmVyU2I2S3d3UjVENXBBeHJmbzBlQUx6eExzUmtDd2tO?=
 =?utf-8?B?OE9tUitnZGphZTY2bzdyOGpnSUtyUjRtdzkyY1VvSjVyS1JVeEVVSlg3WUxF?=
 =?utf-8?B?SXovRUZDNHIvcDhJb29oRVpYMEJtZy9yaDVaZGlYcTdoSSt5MHAwcWk2S2JC?=
 =?utf-8?B?WVY4OER0aDRzdWxyTXVDSS9oYXJYbCttZkJ0N1VqdEg0UWN4QTFNOFZaU1Y2?=
 =?utf-8?B?czhBRGJPWk9SOU95SWZIejFFSzhWUzFHbHNrVy9zWXI3cjM0aWNJNzUrdHA2?=
 =?utf-8?B?SDh2U0RpeUtPY1FLaUgxUFIyWmN3Rnp6RFo3Vm9RaGF1MVpDbEJzNkZWVHQx?=
 =?utf-8?B?SmZ4TDRRY0RKdXdUY1RNUnBCU0Z0WGczbmtzVTUzMEF2a2dUZCtiRGtDWDZt?=
 =?utf-8?B?QjQ5dmhqdXArbmtQeGhpNXhjNmlWbkpxUEFjeTU3cTVtYVByd3JLVUw2cmJ6?=
 =?utf-8?B?ZG8xRzh1bmlNS0VRa0ZhZEN2SXlqeTJjWHJxWHMvOEJnR2IrVEIrWWxyc2Vu?=
 =?utf-8?B?dWFuSmxxUXUyUGU5NVBPQVY2dG9mb2RrZWdmanYzajQvSGczdFg1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e08384-6be9-4313-be52-08da2d285ac2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5142.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 17:14:17.7093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgN+PKbLYbpjlk07ZyT83qcV7luggzT8ozK6UCyVajpzjBva+PCWbcz+KOVYhTYLNmKb8O/kGCA96R5/2J0C6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4398
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 19:41, Alexei Starovoitov wrote:
> On Fri, Apr 29, 2022 at 4:16 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>> +       SYS("iptables -t raw -I PREROUTING \
>> +           -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
>> +       SYS("iptables -t filter -A INPUT \
>> +           -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
>> +           -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
>> +       SYS("iptables -t filter -A INPUT \
>> +           -i tmp1 -m state --state INVALID -j DROP");
>> +
>> +       ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
>> +                           --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");
> 
> That doesn't work for test_progs-no_alu32.
> sh: line 1: ./xdp_synproxy: No such file or directory
> https://github.com/kernel-patches/bpf/runs/6227226675?check_suite_focus=true#step:6:7380
> 
> and going to be fragile in general.
> Could you launch it as a kthread or fork it
> like other tests are doing ?

A similar thing is done for the urandom_read binary used in another 
test. What I missed is adding my binary to the Makefile the same way. 
After adding it, both test_progs and test_progs-no_alu32 pass. 
Respinning with the fix.
