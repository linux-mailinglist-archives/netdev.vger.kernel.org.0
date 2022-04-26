Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663425106F0
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347185AbiDZScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbiDZScV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:32:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EE649F32;
        Tue, 26 Apr 2022 11:29:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQIBJkGBswtpY4l8YcwvGcr0VjDgrX34BCE6QyVPoo9J4X26PDrVTVXYNASZvolbh5IKRLSDfEkrKnO6IzshEPBLXLphqhd0oyVTEjZ6vQIZhqdgJCRKvtHjkaW0C9RnmtO0PALPmCCifosN426DmfoN1ASsHRWMsK2ByOU+DLkn3Be77jo8JxS0bkcb6tSXI0XvuPta9gY1o18guLeVZ/YpLALDh3mWi68DqeQO0PPgodI6tZDkfgrUR+nkkxdrH88N+4IInnaQCtIHrYPZ1Qtn0JWxPvPw7hLgjpFy6Qr5QKjkvRa24QwqaFIbhmxLYlkyepGOqudDH8Pg2kRnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4HBUIHsjpG/A/tFWnAuDqgzTMR24x2t/NWxaU5dOns=;
 b=cA9QhTagJ4gww8AKtOPGCcds22xZboSnNKcs2EVAPxX5RtXO4wd5bbLgI1Bb6Rb1wyHnE5q64FLRhrblyJ+kYIJheCikN7yYp9uMFsrFipvdFxgSBEGpI/JhXSJ5Tl80arTAz9tbSUG/ivAouMkqz2FIBD2ZWVDJj5G9FWQ2POWJgRbEbIkIi5W8uRLtXCYMwmeS3xX2++kUWa6vCsSSJRCsyn6C1Z0vNMM9vp2IEsN5XBN4de28csxJKpLvTZ0E9sirPKaHVoyssMVGW1Bp1HNQqBQxdkyr8nkwq+tkC9q1HtOO5J5L5/EiLMnCbaMO/kbOZ7xWDgyrBVojG1D64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4HBUIHsjpG/A/tFWnAuDqgzTMR24x2t/NWxaU5dOns=;
 b=i9FvzNocaRWYk8R6fXxAvpF77Nqwno+VGie+nsts71c2B5j7NPVjNj9yyoAZo7qfPwmVKb/RitvyEPE5g45gVMdm4DIdw0eDLwnPzpqjMy3TxpX8Oz/fBPmTN7kFrJtQD0p7v2w++Bq4uF+XKfisp6CBnY5wTMYXGizoLnvwX1twO+8nqLRnw9zozR4ngt4hbhwWaqRcFp/9FA7rPEJXK5RtGU+ZNTcr2np50yiyVLZQLu7OMjAQIn4Qcv0d7rpzDOBasDA/XECRtMKhfJbjRShNIm9neaFko/59v9PPcNKc5kVJdkZu1u19tPwYuUen2oAfsJAi8YaPddxt3zo8oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM6PR12MB4911.namprd12.prod.outlook.com (2603:10b6:5:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 18:29:10 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 18:29:10 +0000
Message-ID: <92e9eaf6-4d72-3173-3271-88e3b8637c7a@nvidia.com>
Date:   Tue, 26 Apr 2022 21:28:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next v6 5/6] bpf: Add selftests for raw syncookie
 helpers
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
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
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
References: <20220422172422.4037988-1-maximmi@nvidia.com>
 <20220422172422.4037988-6-maximmi@nvidia.com>
 <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0053.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::17) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0ab164b-165e-4dfc-1168-08da27b2a814
X-MS-TrafficTypeDiagnostic: DM6PR12MB4911:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4911352EFACBCBAB085CA16EDCFB9@DM6PR12MB4911.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DHlTZ7LXyzpS0DUlhSxFVyHlqXGRStNu/bEL/uUyTYut88KDFXGvjFDUqWYOjC9q22FyyIkXi/7O7gd7TCFfmPbIbSVaUHDfLBkI+Cabfs087lSq0eJAZHN6Fw+X1GwKiHRRPzcFD80nd/p5TvTChNFa+kE98qUCWzmnZTnkwM7FUmnuj4c0qI+eo4VgAHUSelKQmN0zSzai+qLl7jOPxLn4wiYiIv5emxslig8acbhVawEaLL1OmF98WxUQJMLPbgoQlrOU6fh8FqmhCQ4BJk0Iqkr9uaBZXVhgMX4T+qIUOOuG4ZBG4naeYlL20mRgFJ6q8bzDrMAKl9BhxBcceK167BftFWt9UK3pvA0d3bD2rX7zEwSYv0F5lw/ReNXYcDnIqwZxESGbLQcuMVqc4PMmcUgNQUzEUoNuzhCuKauNl/JEXC9fAE/F/hWIbqUnqEckgI00Py1v9SsJ1rVlw0NsECB+eVYIB/rHVfRap8Y0nyFctksP34GTOGvFgs8qHNDXgTkz23mzM5BPHWqmgZ8KFWYih3QoW3ckO/+XhApgPgi9SZq3+N/YvjhjzI9qPPeStEK0lidtBWn1dp1fUkt41PqwzkKvRsP4JO5MNzvdpSfvoSWMWm4ImaPZjSm6o6OxVQoMwaUaHwbicaMn5GjiaKCp6mUBLC9M6Xl5VsYa7UTMqrQEG94n6Cm54R2pTAdH2euUxEPLCPsvgYGYl4Zacm4Iw/QECx8+S8JKeU8lZ8jOXzWxMuJRZcC41L0FSNOcIX2s4MBPgoZRzH2gAP2XYaSDbJz917WtnkHXNRYoYvQTGSLK1qab34DQAhLly1pFiTWCrKyFtPRjLbwBIIetUBTsPlAWAYLZ152+cLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(508600001)(83380400001)(66476007)(31696002)(6506007)(54906003)(6666004)(8676002)(4326008)(86362001)(6512007)(316002)(66946007)(66556008)(38100700002)(53546011)(110136005)(6486002)(5660300002)(36756003)(966005)(2616005)(7406005)(186003)(7416002)(2906002)(8936002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkphb3p4NGNIRGZReFUyem5VRnlWRE1IYkdtUlJHVEpNYkhFelBBQXg0MG5m?=
 =?utf-8?B?M3dwcEtYdzlMemdiejRqZXRBM0FIS1p5TlRIbEZtZVc0YVErcmpEeHZHRFJV?=
 =?utf-8?B?UTZOZGlXT0lBM2FDa0ljR2JGcEJ2MUJ5MmtCdkR5cHVQQWtxUFlNVno3ajFl?=
 =?utf-8?B?Vkx5YmlXRUxaT2xqMnMzQjhhMisvdm41TDdyRkFsTmRXTlc2WW5YNnhheGhK?=
 =?utf-8?B?akEwVDU2M3ZKRkFWSVBBVUpnSmhyZG03VjVrOGZEdStyZytiYTVnM3ltN2J4?=
 =?utf-8?B?ZWJmYkJhTStLVFNNWVlOWWRGOTZJVDl6TG9xcXNBUXZCVmRod2J3WGdpanFz?=
 =?utf-8?B?cXlpNVdHUVNua2RXVDFKVHR0b1UrYjhSMU1WMi8vWElKUkdBM3UvcTlWTDly?=
 =?utf-8?B?MUhVTU5iRlpESWdkNmZXUDdVTmJBK3BUaVZ6ejkxQStxL2dNZzllcStqV0Rr?=
 =?utf-8?B?OEtLa0pNTWV5NURuRzZnL2ZlSDR6bjgwUTBIVFphMmxtK3BVbnhYZ3VwMlhv?=
 =?utf-8?B?NkRxVXJsb20rR0N1ZmZuamRHNG1tU011YmVwcEZZSzR2MFoxQktINSs5Y0NX?=
 =?utf-8?B?TzdzTmNHQ2tqbjRqNEhCQVFtdUN5OXZQdVJheUl4eVdiUU1aZEQ0T3hiMGNZ?=
 =?utf-8?B?NnZWMGNjL0FJZTlQSXRBWkxNWmtuSkREaTVTT3ZrKzFGNlR0c2FpM3d0eDRm?=
 =?utf-8?B?UnZ2MUJSdk96MFFQSTgzWUtyRjhNeU1qMWgrNjYwVkFIcU9lVVV1N0NXVm5p?=
 =?utf-8?B?a3FpTDB2RkRBbWdzL3h2YUM5VFZMRjkvZnpKM3FnRlUvS1pVTmxkcXliWnIy?=
 =?utf-8?B?QjZXMExkaUN1SUNoQ0tHYVVQbWxvaTMvNHJtckx4a1p5U0dMK1VsRUpRalpn?=
 =?utf-8?B?VXpUQzNTZDlmUGtZanFiNFlYd3R2VGpnVUVraHg2dVEzVC85b1pRZkFyajJS?=
 =?utf-8?B?bmlmbHVKa2JxM21XR2wyeE9aUXl5VWZUTUI5VVRTaFFqZjJtTHYvRHhzU3VM?=
 =?utf-8?B?QmhRY3pZTWh5OGlPK2QzcmN5NTNhZTkyU002WU5RU2czcEJPa0diYjN1Ky8y?=
 =?utf-8?B?QTdEbGtncmF6TDNSWUhjQXU4L2RRSDBGeldMYUsvTFlKUkZHT3RuMlA5Z2dP?=
 =?utf-8?B?ZHJwdWswUTJ3TVVKeStxOHpMOWJmZERreG4ySUtTcWMrZzFmMkFIZjJ1VTdN?=
 =?utf-8?B?VGpHSENHMWZ2Und3b0hUL3RSN21hcEFFVXNQNEkxaURVWWVnQzRWNUhQdEFo?=
 =?utf-8?B?a25EYzU4K2Q0S3VHTTY5c0ZPUFgrbUpjOU5VQ3IxcUgyQUd5NllPUEExR0RD?=
 =?utf-8?B?WHpoUmJRUFg1KzM2Ylk3WGJySnBURitnK3MwYU5YR1hyRWZ0RUdpTUFIU2Fr?=
 =?utf-8?B?RmM1MHpwUDRWS0lxSGI1dGRFOVFDRm9QWkNnWWErSmlPSlZXK0JBQXNtczhw?=
 =?utf-8?B?TFdxS2VVdlJiUXgxb1kvU2ZSNW5MMUFxS2ttV0xJMmxwMFpLQnUrL3lFMk03?=
 =?utf-8?B?Z0ZBNlcreHpDdDFSZXV0cjhPWk1ZSmpKdGR5b1kwcWtnZERha1FySVh1UmNW?=
 =?utf-8?B?N0JKRzl0VzhxSlpnS0VjNXpRVW14eFk0YjlPOTNYcVpaZ2hZOVdKRjBBVHd1?=
 =?utf-8?B?K0RTVmdEd25PSnl4OWJvKzJCaHp2WDVUN013RUJNd0ZXUWlORnF2OGRtc1A4?=
 =?utf-8?B?SE01b2hQdXQ0YUJVSHdjOVRnUDFnMWs0SVBCeWJvc3V0cjhTUFhGSUtia3Uz?=
 =?utf-8?B?L1lGYmUvdHA1OUlOYlRSRzFMREhIMVhmTTlRZVAzSGM4SXhoS3RpMDdXWEN6?=
 =?utf-8?B?SzRoVndJbnB4RkNqRld0YW9aUVI3bkFlUm5EZWEycndSQTRsUmYrcUxSUnli?=
 =?utf-8?B?VFRIVDAzdXFPZnhSTjluYjZXdXJvUzZPT3dCeEsxMjlSWEhBdVgwU3BGT3pa?=
 =?utf-8?B?S0pKa1A3VE9uSUNvbVo4Z2NLMDFYc2FkNFloblFZeDBucVFTVXphemNKdldw?=
 =?utf-8?B?OUFlc3RERUlUTU91dEhnbmppdWVJVUduNGhERG51bFYySFBoOE1odG4vbWNh?=
 =?utf-8?B?Y0thUnU4ZmFlUloxYmdmOWhwdkpYZlBlcWhEOVJyZ3B1eCt3M1RWYS9XNzNE?=
 =?utf-8?B?WDhpUG5ZblZQVXR1Q1g3cTcvWUFUbFNYZWlxVVI3WFBUQXIrd0ZFS2E5MFBy?=
 =?utf-8?B?WGxRNDVLSHV1WWFXalpEQmRjSVBLOHFvY0JhQlZGWFljbWxuUEpIQ1Q0dnBs?=
 =?utf-8?B?a3NORlFTNTJPelF1SGRrNjRBQlcrRWQ3M1JpNlNqUzNGSFlDM3Ava0NWSnNF?=
 =?utf-8?B?cXliYTBEdVZOdjBWcmhyMG9DU1RETVFqRW1lOENHaUxXa3ZCTTJFZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ab164b-165e-4dfc-1168-08da27b2a814
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 18:29:10.7176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWpSlFeitTBGgxLdWRHh1x8rppbI55xFOzd5K7fhstmS1JEdD6b7YNHlICHx11oyhTN6Pa/AHVlAkmHtOWwX6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4911
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-26 09:26, Andrii Nakryiko wrote:
> On Mon, Apr 25, 2022 at 5:12 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
>>> +void test_xdp_synproxy(void)
>>> +{
>>> +     int server_fd = -1, client_fd = -1, accept_fd = -1;
>>> +     struct nstoken *ns = NULL;
>>> +     FILE *ctrl_file = NULL;
>>> +     char buf[1024];
>>> +     size_t size;
>>> +
>>> +     SYS("ip netns add synproxy");
>>> +
>>> +     SYS("ip link add tmp0 type veth peer name tmp1");
>>> +     SYS("ip link set tmp1 netns synproxy");
>>> +     SYS("ip link set tmp0 up");
>>> +     SYS("ip addr replace 198.18.0.1/24 dev tmp0");
>>> +
>>> +     // When checksum offload is enabled, the XDP program sees wrong
>>> +     // checksums and drops packets.
>>> +     SYS("ethtool -K tmp0 tx off");
>>
>> BPF CI image doesn't have ethtool installed.
>> It will take some time to get it updated. Until then we cannot land the patch set.
>> Can you think of a way to run this test without shelling to ethtool?
> 
> Good news: we got updated CI image with ethtool, so that shouldn't be
> a problem anymore.
> 
> Bad news: this selftest still fails, but in different place:
> 
> test_synproxy:FAIL:iptables -t raw -I PREROUTING -i tmp1 -p tcp -m tcp
> --syn --dport 8080 -j CT --notrack unexpected error: 512 (errno 2)

That's simply a matter of missing kernel config options:

CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NETFILTER_XT_TARGET_CT=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_SYNPROXY=y
CONFIG_IP_NF_RAW=y

Shall I create a pull request on github to add these options to 
https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest/configs?

> See [0].
> 
>    [0] https://github.com/kernel-patches/bpf/runs/6169439612?check_suite_focus=true

