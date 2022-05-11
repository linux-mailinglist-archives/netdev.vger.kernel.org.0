Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6952321E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiEKLsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240799AbiEKLsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:48:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8842438C8;
        Wed, 11 May 2022 04:48:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmSRxYXFxjaP/tbSGfxF1P8LUT9KSUoH7b4osnO4TK9hNXcHIr0LypOlwS8n/gGueaAOykZpfjQ8U8J8lwrBIESh5Nj+yibJhs9l57bsgAX+GceIa1KGHeFvPs37Ft+uHdJ5oTxs3MkehBlkYVIxzOcZgWR7PFSOEaFFhEiPsOvg63yYktl9kikRCLVPfNs9TbFF+Kvj1h6mhdbYx8p4mqxmIz7gaSXU8MHyyaeXxzmlUeld1aNHShvshNuQQy4TV6Q8AiMkvqoNI77Oxo7WkLSoS7q0F2ieU7LfZzr7JgQCmprrrjEtNbMalFbsfZ4/J6YICGkW6fLWSuhI3nlDeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnmtBpoJ0fSBNeWIQP4lRipzER/hFR6CuwoVllfC114=;
 b=VnZ1FeUMubD9pp2X4sYjVJU9ovzTUNsVe/zg0gxWuufL3KMuGjF2YOGIDGz8nIN7aMA+4hQZpnWAt3SC+wMcAApsP61PnibAFCZr2ZtveqmvTUUobJwzlwtMGq1LTlW8TKPIhMGjxo03QyUTO7zO4FT9tA9Syct11kDpVcbWVKfo+YrWxEevifIiP1qBYbNnoK9sq191Fu9YoGyVvVRObY8noJ5BQinoe23MXAHxPzb5F1nnmI6CBe6eTuC6YFvMs97b/3GUfuQ17fjJAgo/Ogc2IlV4FktPD5wPiOCm7aW3xFGEL5u6dvBmatdwceV79WHnr4bYuGaZ5RX2U8oQhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnmtBpoJ0fSBNeWIQP4lRipzER/hFR6CuwoVllfC114=;
 b=AYiOa0FOrgrGBWtC+rRQMf0+s2SU8oEAe/wsPEdfGG8qaRMoNf7CXRqO9QjJFqeq925Pdw94s3J5K3JsEmIMgIpjMjC9mVw/vpYJbxIWDWKNS0VP4RCC4J+lD++QHYV9U5FVPL2QR5f5fGee3Dcnqakcm+cG+V1TQMwOh7xdDRuaVz3WYvS0cYwc9BvzzX42mzjRKtEVr3jVOgNKjyAoCGtooTTPXyOHFhuZRuoEgdiJ+hCtFQglRt22KHKGiXoucTvbHzk+ByRgPFNnIpWagtVytEUOCaqmtvz3A7gb6bQXBHrrSSj6lEZEhVTSPy6Bd5a9NbDGoO3wyU6/iIHuJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB2915.namprd12.prod.outlook.com (2603:10b6:408:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 11:48:36 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 11:48:36 +0000
Message-ID: <13051d07-babc-1991-104b-f4969ac24b9b@nvidia.com>
Date:   Wed, 11 May 2022 14:48:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
References: <20220503171437.666326-1-maximmi@nvidia.com>
 <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
 <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com>
 <CAEf4BzYnVK_1J_m-W8UxfFZNhZ1BpbRs=zQWwN3eejvSBJRrXw@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzYnVK_1J_m-W8UxfFZNhZ1BpbRs=zQWwN3eejvSBJRrXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0276.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::11) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b131dae-2117-49b7-22aa-08da33442e93
X-MS-TrafficTypeDiagnostic: BN8PR12MB2915:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB291535546BC234C290CA027BDCC89@BN8PR12MB2915.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izoC3xyVM978T+K/huFsp+NssGy86ieV3R2VTFDrNmGHw32iQ+btORxDqnM1Dzr5LjEBHI+8407qlan9OerbOtv97B/teKEGp1qFq3IZfdiPl8yAP98H4y8l9oMuxTZPWDDOGL8s2ygCFrCVvuLn+fg0djCWrChFJ58gILdjJ/jjCWMVYprZ1wjzLgLRwsLHtfmt7QbEyy9qYUq43O/XZhpa/i4g9B7U+elAOr3E3qQfit4Cgoy+oZMMrDVVpwrpGfKtn0ZHTA8kvpSpk7ci0usaiHA0HsRc9jqXpByAdJlUYZOorLw3Bm9kZQ4kLu2YstXkAOlNVbCEVqZhJ0951ao2s0v0EMBkzeDwWLfU5yAJ7ztehGBkKyxj+Oo0HjRU4ButBYKvuiFu+JVdMBMlLRyPuGu+gpyvmX0B6Za04/uf/x93L9W4p8zkMUdWoU5/gnusSdkhF5ef5HHwpGq5fBJsjrnciOqdhl7fbKPzee1Ls9EdO8YWli8hAvEWY+ll0/Lb0NI4u+kD4kNEWNycL3ny4bys1jE0XqyqO9PYmXEjqDphjg54UXCQDgckVvydX1DOMRMIFCvnwzZl/rc6sgY1DC3/Rm5xUF+Bh7sIsdvXxutQn1swN284Nc3aGN/ElnQA3Q1KtptPyaws+B3NF0Ub9piMmTLrTAgskKByPbGf/w7I2zhtT+QK5lxwUJ5WPkNwfVzN2DUgLvjKqu+E68iGidc0Clvm5Nlukumkl0hamfMgGDJ5O9EDxYqTzc5MyUgl18YAB6eNIzWYsunaVluP+aod+/VAsKPLV+YO/xQboDvqTtf30FbEIJFbAPhzWHjR9nrust+OTSuGNKhClatTXHUOM3WSHwx9Z8OGtrI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(38100700002)(6666004)(6506007)(53546011)(508600001)(86362001)(31696002)(54906003)(966005)(6486002)(2616005)(4326008)(66556008)(8936002)(8676002)(66946007)(66476007)(316002)(26005)(6916009)(6512007)(31686004)(36756003)(83380400001)(7416002)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nm4veGh5T3djdnB4TUNZYWloekJpZGF0RTFia3JYMlRDQ3hPbEF5Z0g3anlH?=
 =?utf-8?B?SW8xekh6WXlTelRoelF6azVFZ2RLWmI4OUFjVHVOc0NCUDY2UzJaWkRjWXE0?=
 =?utf-8?B?YjlmZzZHRWZDWHA5U3Q1UmpQd1NWSm4wK3hSVlltYWxmNG5QR0VoTmRHNENx?=
 =?utf-8?B?TTQrcVgwN3p0NmVUTldZK0NWNHNOOHliQldmQWFQdWlrYlNxMjBMTlFxZXFG?=
 =?utf-8?B?bFFzZ2puZHkyeDdFaUlpTzdlZmdPQytLWFBCckN4S3NxdFNVNUd3a0hwSkQ5?=
 =?utf-8?B?TTluYmRQeGkyb1hoWUs2T2orTkFUTkl5VmlBMHROU3dBMDgwMHhaMm9MVCtR?=
 =?utf-8?B?ZEZoODFYeVhWVk9zOTg4ZFZtUTZnSEEzaitSMkxsRjVUM3JUZHZzUXJoaFRz?=
 =?utf-8?B?RUtObmdqQml5SUtBNGtMVnphWHZQZ0I5TmV2bGJsUEdsbzNOUE9NdU40ak4z?=
 =?utf-8?B?cGFEc0w4RzNUNFRtRnFSb2Jkald6Q1Nkd05EOXpkWGp5aCtMS3IyUnMxWU12?=
 =?utf-8?B?YkczVWNqbFJITk05dVdrN25nakM4UFNYai9xMWk5MnZwZWxDMDFEV2xNb09D?=
 =?utf-8?B?STc3aW92U0k0Sk03S0lyak1SYk52enBOdGtJTWEyaXVwdVBEcmUweHRZVUJl?=
 =?utf-8?B?REpwTmhpQlNtYStCK2FEMzZUeEtsNmxsWjJlbU9CTXlHUjBHaU5vTzd2S3JN?=
 =?utf-8?B?S3pkUTJFV0g3aFBVWlFZYk5KMkkrVWk3VHdXMXlNSUZjbzN4VlUxcHFPbXF1?=
 =?utf-8?B?dEgwU1V0czNpVHBwNlBWL2xHS0JiSmV0VGg1SkpyTnJWUzVqNklWeTczdlg4?=
 =?utf-8?B?OWV6bktRTzMydFZFQ0lGOXlqRU15Zy9JcG1ORlRqV1NWL01xR1JRWkk0eStD?=
 =?utf-8?B?RkFlWThpNU9OcVY3Sk8xMVk5bGFOUWZMcmY1QVpyNStwRE5qdGRjb2FJZExn?=
 =?utf-8?B?SmVyUVRHVnd3MlAybnhGNVhxQkRGZ0FjdGhwSUdoUSsrUWwzOXowK1NjNXQ3?=
 =?utf-8?B?eStCMjNESWE0alp4NVFLTGVqaXZmdDB2a2xJVHg4SE9QcThqRkhmZVFCUXdX?=
 =?utf-8?B?SnBvNzFVY3hYNUdLUi9hM3g0TkkzRmVDTUNvamkrdmk3ZXh2bnlVcUNMSjBo?=
 =?utf-8?B?c2EybUR3MWpYSitpcFZkdkpkOHU2b3BwaUcvVUlGNnRSR1hsSjlxTGREZnlj?=
 =?utf-8?B?UDArT2FhdjVGOStDaUY5QmkxMGlkQUYyN1lqKzF2QVMrenNhbk52d3REc285?=
 =?utf-8?B?NkROMFMrRklzUnJ4Mjd2SjBGUmRSKzV1WVE0L2lOQ0NWbEpiVG8xZ3pWUC9Q?=
 =?utf-8?B?eThVdU96Y2ExLzBpc1lHMVBhc0NxLzFzZEQ2eHlQaExtZWIyeFBod096eG9z?=
 =?utf-8?B?TnptdzNWQmFDY1V6THNiUDZaUUV2TzVoR0laR3NlNDg4N1dmSnVtNG44S2tG?=
 =?utf-8?B?YVFIelgySHV3Rzl3eWtnaFI2WVlLb09uVXJVM3MwQnVMd2p4THRVVC9HK0hs?=
 =?utf-8?B?VVFZclg4NGoxNnlxbWpOeGpETHdOTWZpUUNBUUJQVURSSE5NMHVGNmVkanA2?=
 =?utf-8?B?Nk1EZXJBbEF6SjhUTEw2bVRQVnozdG05cGsyU1BjTmtwUlhCNklzNHBJSEg3?=
 =?utf-8?B?Y0VNRGdiZ0JlczdLQ3RmMkd0TkpKMjhucUhoa1cyYk5jWHpzVFBSb3VDQmFJ?=
 =?utf-8?B?eUZ6WmtYNWo4RERIODJhLzI4RFo5ek1NKzBGa2s0K3pLbG5qbEhXRC9JVDcv?=
 =?utf-8?B?elB6eWRVUmlhbStGdmFjL3gvOWFNbng0VTBmTUF1dGhhK3FJWVhMOEpIOC8r?=
 =?utf-8?B?T2huNmhGQ0Vod0tFTUd2VDlZNFZwRVBtMzdQTjVlaUY0WEZkQzNwaTVNWmZ0?=
 =?utf-8?B?YVRoSkdXNHpnUDBJRjhwU0Vicm9oUjMyTDRkdGdzK2xMdDRETUVpRnZoSlZP?=
 =?utf-8?B?NVFYRDVjYXBnREM5VDZGbHdnZTlUUlkyN3pCb0dZZVVvUm1UM2RHRVI5WW5s?=
 =?utf-8?B?M3FkVnl2TStZdEVRUllQY0FnRm9CeFJZRDVnMEtNNDFPWjhKb3dxY3lVR1NJ?=
 =?utf-8?B?ZjZwdDY5QkVpY3paRjAzbTdhVlM3T2lCNERTL2hJK1dEWlREb0hEMTYvMmtU?=
 =?utf-8?B?a3JoeExGQzRzMWtLZ1FWM3ZTU1owM0FPMDJLT3g4ZytNMTNwaklQUXZldWM5?=
 =?utf-8?B?Qk1TM01OMTVBQmlqakhNOHpOWnFTTTFxdWxLNytOVUVrUU52bzE3NDJ3L3Rn?=
 =?utf-8?B?VGhqbzJNTDdUVVQzcm45VzhxRWpXLzhFZkgrdmxBdzlYWDRSTEt0Y2Qwblhr?=
 =?utf-8?B?cDRoWS83RGd3T1RqYjBYRkpOUGxFZUprSGZKczQ1elRJVzBkOTlkUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b131dae-2117-49b7-22aa-08da33442e93
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:48:36.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4s4mj88whTC0qHkNecce6WOHcO4vljsme+tGNVypagrC+kKc+EXI3Puw3UlKrhmhVlR9LztZXkfHU6R+GlLOxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2915
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-11 02:59, Andrii Nakryiko wrote:
> On Tue, May 10, 2022 at 12:21 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> On 2022-05-07 00:51, Andrii Nakryiko wrote:
>>> On Tue, May 3, 2022 at 10:14 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>>>
>>>> The first patch of this series is a documentation fix.
>>>>
>>>> The second patch allows BPF helpers to accept memory regions of fixed
>>>> size without doing runtime size checks.
>>>>
>>>> The two next patches add new functionality that allows XDP to
>>>> accelerate iptables synproxy.
>>>>
>>>> v1 of this series [1] used to include a patch that exposed conntrack
>>>> lookup to BPF using stable helpers. It was superseded by series [2] by
>>>> Kumar Kartikeya Dwivedi, which implements this functionality using
>>>> unstable helpers.
>>>>
>>>> The third patch adds new helpers to issue and check SYN cookies without
>>>> binding to a socket, which is useful in the synproxy scenario.
>>>>
>>>> The fourth patch adds a selftest, which includes an XDP program and a
>>>> userspace control application. The XDP program uses socketless SYN
>>>> cookie helpers and queries conntrack status instead of socket status.
>>>> The userspace control application allows to tune parameters of the XDP
>>>> program. This program also serves as a minimal example of usage of the
>>>> new functionality.
>>>>
>>>> The last patch exposes the new helpers to TC BPF.
>>>>
>>>> The draft of the new functionality was presented on Netdev 0x15 [3].
>>>>
>>>> v2 changes:
>>>>
>>>> Split into two series, submitted bugfixes to bpf, dropped the conntrack
>>>> patches, implemented the timestamp cookie in BPF using bpf_loop, dropped
>>>> the timestamp cookie patch.
>>>>
>>>> v3 changes:
>>>>
>>>> Moved some patches from bpf to bpf-next, dropped the patch that changed
>>>> error codes, split the new helpers into IPv4/IPv6, added verifier
>>>> functionality to accept memory regions of fixed size.
>>>>
>>>> v4 changes:
>>>>
>>>> Converted the selftest to the test_progs runner. Replaced some
>>>> deprecated functions in xdp_synproxy userspace helper.
>>>>
>>>> v5 changes:
>>>>
>>>> Fixed a bug in the selftest. Added questionable functionality to support
>>>> new helpers in TC BPF, added selftests for it.
>>>>
>>>> v6 changes:
>>>>
>>>> Wrap the new helpers themselves into #ifdef CONFIG_SYN_COOKIES, replaced
>>>> fclose with pclose and fixed the MSS for IPv6 in the selftest.
>>>>
>>>> v7 changes:
>>>>
>>>> Fixed the off-by-one error in indices, changed the section name to
>>>> "xdp", added missing kernel config options to vmtest in CI.
>>>>
>>>> v8 changes:
>>>>
>>>> Properly rebased, dropped the first patch (the same change was applied
>>>> by someone else), updated the cover letter.
>>>>
>>>> v9 changes:
>>>>
>>>> Fixed selftests for no_alu32.
>>>>
>>>> [1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
>>>> [2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
>>>> [3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP
>>>>
>>>> Maxim Mikityanskiy (5):
>>>>     bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
>>>>     bpf: Allow helpers to accept pointers with a fixed size
>>>>     bpf: Add helpers to issue and check SYN cookies in XDP
>>>>     bpf: Add selftests for raw syncookie helpers
>>>>     bpf: Allow the new syncookie helpers to work with SKBs
>>>>
>>>
>>> Is it expected that your selftests will fail on s390x? Please check [0]
>>
>> I see it fails with:
>>
>> test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512 (errno 2)
>>
>> errno 2 is ENOENT, probably the ethtool binary is missing from the s390x
>> image? When reviewing v6, you said you added ethtool to the CI image.
>> Maybe it was added to x86_64 only? Could you add it to s390x?
>>
> 
> Could be that it was outdated in s390x, but with [0] just merged in it
> should have pretty recent one.

Do you mean the image was outdated and didn't contain ethtool? Or 
ethtool was in the image, but was outdated? If the latter, I would 
expect it to work, this specific ethtool command has worked for ages.

>    [0] https://github.com/libbpf/ci/pull/16
> 
>> [1]:
>> https://patchwork.kernel.org/project/netdevbpf/patch/20220422172422.4037988-6-maximmi@nvidia.com/
>>
>>>     [0] https://github.com/kernel-patches/bpf/runs/6277764463?check_suite_focus=true#step:6:6130
>>>
>>>>    include/linux/bpf.h                           |  10 +
>>>>    include/net/tcp.h                             |   1 +
>>>>    include/uapi/linux/bpf.h                      |  88 +-
>>>>    kernel/bpf/verifier.c                         |  26 +-
>>>>    net/core/filter.c                             | 128 +++
>>>>    net/ipv4/tcp_input.c                          |   3 +-
>>>>    scripts/bpf_doc.py                            |   4 +
>>>>    tools/include/uapi/linux/bpf.h                |  88 +-
>>>>    tools/testing/selftests/bpf/.gitignore        |   1 +
>>>>    tools/testing/selftests/bpf/Makefile          |   5 +-
>>>>    .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
>>>>    .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
>>>>    tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
>>>>    13 files changed, 1761 insertions(+), 22 deletions(-)
>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>>>    create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>>>    create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>>>>
>>>> --
>>>> 2.30.2
>>>>
>>

