Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF875FC1A6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJLIMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJLIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:12:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9B856BB7
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj6Yai+xS/wVTunRPpj6bk6S4a//9FGyp0QcDvPWrk76NhmKTtht+Qs1v/o0YlT4c4Kx2BiZ25hCXuPW2Ahmt1S65+VqQnFAhPlUj1XMyTgAV2FoGcyyme/T1KX0dJu2mp8o/PzlbP3ZzSmuUTKV7WXTsfK3XCohe3vs2w36P97dnj4k/uUq2bkiQMPbfvvwE9U2QzusVDOkA815jNJpsztT4P6Nldc3OfVqKNVKAfZ5MeMIxqs9BOHgb0gWDtHBEAle5Uprpf9ku9U/yqrKKl/9VwYrgHKYZuIUlG0w8/ajXr9sDOdy35h+V1qTw3bo8Pt+QWXAmjzQqEiWIbzIHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jc38y3gYkkhhFjOdty+o+RGh179ulQQqqZeYgEGiQko=;
 b=C9gYJlg3AjZjOdkUsaUfnVnhZnz9adKgrUnMcM0ePtSdNEKsUaaNDaU4Jw/qNIAtMgoxRuIa6tOupUPZH6hS1P6Xgp57cqDGiWiem0nBNGug7slvaDEar7ciZX8nPLGy+4O/XBSR9HzI6r3c9OfveFPHr9dfojQcGiQ1d/VDHGzAjoP9tVaawhLS9Ksj9n2cIaaqg+6z68OOTcym9O9z5hn1uppf2tT4lR084HdK/qCvwp3lWE7eRm5ejFRHrctVTFU1G/dgkbDFDT3jNKu9ECQ4sm/kMGaDkwqtGKBy2HKzetUprfyenpcLRYn7j0bbxiGilI9tiIklqVsdwa3pMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jc38y3gYkkhhFjOdty+o+RGh179ulQQqqZeYgEGiQko=;
 b=C+TGMW6P7U8kkilw/wmfEcB0VM2SdY67OimEphT1FkMoM6y6UcIEQyhZYJxEh3V9lLGXromn/1HDi53LUOP6N2jVyEI5FV3DdWUlzSAUrvlvJaDUo2mOcTB2nUsTjihv05Vldr/P68KmeoE+Y8cUklU4mN0T2mRhiUSIrhuBtcXBps9eGx5HTHev2xYUZmCuJlYrF7z8wnPBl8RV4UTH+Tguxb30vCvpIY2NI2Uoh6ym+3leX9A0y2ZP1iamOeYKTsJfscFtflCF/3KUQgbGC8sJ+Ke568hKH989LMLojs0T9XM54ojvtsLCAEsnjhc7++MVthOdCLRfkR10pMbGwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by DM4PR12MB6231.namprd12.prod.outlook.com (2603:10b6:8:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 08:12:15 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c0df:e760:de70:d4e]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c0df:e760:de70:d4e%7]) with mapi id 15.20.5709.015; Wed, 12 Oct 2022
 08:12:15 +0000
Message-ID: <4c28ed5e-d669-1f27-fa8f-b4f1e651c013@nvidia.com>
Date:   Wed, 12 Oct 2022 11:12:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net v3 2/2] selftests: add selftest for chaining of tc
 ingress handling to egress
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
 <1664706272-10164-3-git-send-email-paulb@nvidia.com>
 <f3d875d44afaf43250dca8f9614cab119bdf5d2c.camel@redhat.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <f3d875d44afaf43250dca8f9614cab119bdf5d2c.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0663.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::10) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|DM4PR12MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e878777-c6b3-4628-a774-08daac2978dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntEbzYNsa8OoSfNHPiuY1oyQM7xmSUKqAOv+An9q53O+86QcLI3UTl52PtjQUDsnXoc3H2NeD3gms9uFCnIagskdQXwOe+wokHkseLJwonay435yK3mM8ymrh3tsjGRt2so0oqtWinMvsUc6+AKIaEVvfLiFdrsBVk+vYwaRFldDc7U/iWfxrmWiy0S9bot6+poKKfsVDXher8QLPWVGigu43p/9QiH9p4LQV8zo1ZYSKa0RJNcgsAPVE5wsW7L/+wndITOKHdqWBTQSf3FcwZqx7w3RG4D4NZBFyKexoz1IVP6DOFWIdXUL9X2NqavQoY8CTw7TlnGsumRRJpvZ1G8ZAYY29I4I7R9kaw9DwPfEAkzTYJP9Lz8OmjsY4EKGgWuIF1xrqZLyrPTJp1zR9wez4USJiSEXPzXh37qGjgqRnbs+qGgVFtGTvpaF1Jve5A3+LTy9jnRUzPQ/sDbfWqs21WDZ1A7W9rafq770MdajLyTSAKwY6UquZGCYYWVC9VQUX7jTkWL2VKfl0eBIl65oW5o6lxOGczNLRjQSvZbnrIsLYwSfDm06+U3Z4JLdaOa3Q8WElptnHzMYn5F8GCJNLb+AZiWbcMFYxLWBTvoIjdgnikX2NtW5WfK5gs4U7WyN35hPINhCU7H/xwjAX7XhXA77HfEc6o+9GbWZ37arLOsFqOuooRgUndhonw3SkNvtL6o+e1lAisdizUvE5d49Cgp60xa+t3GhPHBtrDYJo7/9h7oYghn5N9V/USRgm96hy7gslI7RgKeonxG668vb16CoJLwGB49VukdtII4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(38100700002)(31696002)(86362001)(6512007)(6506007)(53546011)(2616005)(478600001)(26005)(66476007)(66556008)(66946007)(4326008)(8676002)(6486002)(316002)(110136005)(2906002)(6666004)(186003)(8936002)(5660300002)(6636002)(54906003)(83380400001)(31686004)(36756003)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHhKckUvUG52NEpiOXZQUXhDMUk5b1NIckhoa2F1Y09xemR0QlNHbnpLRTQ5?=
 =?utf-8?B?WHhKNWtmTmIrbEJDTHdpd01GcXN1M2JwSWdHVVJKU3k0MDF4K0llRWtIVEMx?=
 =?utf-8?B?WFJEbXlEamFKcFE3TzV5U2pjRS9tMFRYSEVSTjRINHRmVFR2enNNVTlmTTY0?=
 =?utf-8?B?MWJVbmVYOUNwbml5Q0NYelFnRnFIK2hmZ296WWdYY0ZmcVFiM25Uc2RoRmhC?=
 =?utf-8?B?YlNLNWt1WDE0ZzBUY3liOFJtaTkxeUJJNmlpeTQrUkZlMTZSeDRBLzhIUFI3?=
 =?utf-8?B?VENSZ1JlQWU5R3JWMXB3VUNEaXN2dmxvUURCTlBXYjQwZVQyNS9PVnBWVGx5?=
 =?utf-8?B?Wi9ya2VFRnZSVjN2aVJERUt1Wk5LbXhMWXAyT2pYN0lyeWwvTVJ4d1ZlbGkx?=
 =?utf-8?B?R0gwNWU1Q3l5RFByYU4vQUJoc1pKbEdINGtHbmNieHhJZUFNT3FNcmMrYTVF?=
 =?utf-8?B?czVZeTJLeUF5L1BFOGdpVG8yUU5tNEpwakF4a1dYY0tMYkcyUEZNVXdaSSsz?=
 =?utf-8?B?dktsckZKK2QyRWhBWTQzSW82eFpaZVpKellOWlBZVGlUMkZUWU5QZXlzNVJX?=
 =?utf-8?B?UWVnajdQS084OFpqaXV0ZVFpMi93cFdVSjhRM2VJVFUxNjlldWYxMkJBV1Fx?=
 =?utf-8?B?UnYyd3MrYTJaU0tJaDBudStlM2xrRjBnamhxSDZlcEhqS3NnNExXc1Q1ZTRM?=
 =?utf-8?B?T1pUSXVzaHBZMUJUNVZGbVJZaUxSeTNoM1lFNTJyb3o0Tng5ZlF5R2VzSGMx?=
 =?utf-8?B?c1htVWFrUmdBM3JEY0RQM3RWQW5Gd2pLWjJYUDN1MmRBTEQrUkk2ekJMeTBB?=
 =?utf-8?B?cXZGckZKQ2E4Q1hNUDlsSW05SlRpU0Vid2NnWlhxSzV6RzBWNGR4WHRsekpV?=
 =?utf-8?B?d0hnTE9ONzZSTXdWdjg4b2UvQXhLUG9RZUhVVXc2M0RhbG4wTjNBTlRWQjRl?=
 =?utf-8?B?UWdDaG5panpPYmRIOW85WTFmbTJnQzZMVWVVcHRIV0FmWFhGOVZEbVZQdGtV?=
 =?utf-8?B?bDAvTkRSWE91U2FrVjJHSlhYNmVtVFlNdEpURGxDNTFsVG1VcXZpMFliRjBi?=
 =?utf-8?B?V0Q3U0VGQmhtKytHUHpQakJuYlppMlEvRjFRUXYranpGTVlkY05oVWJCQ2xQ?=
 =?utf-8?B?M0tzVHlpbThhTFNQRjZ6b1M4VkpaOUkreU1CcW5kUWpvOTFkUm1BM3NDKzFR?=
 =?utf-8?B?UnBGSU56WWk4d0pmQjZqUkJHSURTa3J5Rmh1dGRiSnl1ZHlmRG5hVjBIR3RK?=
 =?utf-8?B?cjQyVmNUak0wMXBQOFRFa05IdHQ4TU5NTkNRclhySEFtOFc5WGdnWmZvK1RL?=
 =?utf-8?B?Y3JBdk15b1hhV1BoL2U4dFNmdUQwV1NYK0UzSmw0cnRrNjlrVG1MUTE0WGpL?=
 =?utf-8?B?QXliOGs1ODRrbjN6R0ZUNGR6cndHeEpDdjI2MVAzU3F0YmEyNVBpVnJXVHBw?=
 =?utf-8?B?VWRaVHVyWHNGbnREeGZHL0MvN2d1N1FNZ3d6ZXZOV0VDNXdUVTZ4RWxYSW5v?=
 =?utf-8?B?N0ZQWUo2VlRScGdDVDI0ZGIvUzhaeGUyaDBnSG5uR2VJOWIrTlc3TkxDVGhU?=
 =?utf-8?B?Qlo0U2t2U2VmekJJK3ZPZk1weUZCNFcwNlFNNEtRZFN3ZGp6VGVYVUZKRUFp?=
 =?utf-8?B?TCtoK2RFNDYrNXVTbTgvSTdwTytqZmxRQ1YzOHRaVndHNFJXbGVHK1htaGRv?=
 =?utf-8?B?eHBzNFJ4ZklPb25BbUN4amFQQ3JmaTRrTnNxOW5Qd1RNcEhaTmRVUDhQU3Bk?=
 =?utf-8?B?RkZEaXlzNlR3VFlyYzRwcEJ1NTRoWmRPc3h5RllEaC8rbTVIQkZidmVEb1Fp?=
 =?utf-8?B?VEt3ellIQUlvTkFxWjAyeFVuRUJuSXFrRmlicnhHYlN0MVV5OXpYa0NVOS9x?=
 =?utf-8?B?cy9BSVdHZVZlRW83dzFvL2Z6N09KY0x3emxySWIzTWpNbWdNekNRODNBWC9F?=
 =?utf-8?B?eTB1K1lscHJhUVZ6YVkzaU5MY3dYcXFVL04yeHdFZ1ZhSVBFOVBPcVdGVC9T?=
 =?utf-8?B?SkhPNTdscVlvSUNPRnJ5Nkt2U1hBN0w2Y2hqbkdVdnlDaXdyMEJ2N0xQbzN5?=
 =?utf-8?B?K2Z0OVhIK00renJ3ZDhrY3p2enh3SDNPb1ZOTVpkamZGTTc5SC9sMWtvSVdE?=
 =?utf-8?Q?Q/xdZEI+d7PpiBjsIAEWe1E45?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e878777-c6b3-4628-a774-08daac2978dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 08:12:14.9908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvm91N1oej/ZcJCHPCEdfixHjd+ZVrvILHk9/bkwn3HpdXIysCI9CSt1pJAi1cuzOi0XeUG0Z6IJT+szQMI1dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6231
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/10/2022 12:36, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2022-10-02 at 13:24 +0300, Paul Blakey wrote:
>> This test runs a simple ingress tc setup between two veth pairs,
>> then adds a egress->ingress rule to test the chaining of tc ingress
>> pipeline to tc egress piepline.
>>
>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>   .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
>>   1 file changed, 81 insertions(+)
>>   create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh
>>
>> diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
>> new file mode 100644
>> index 000000000000..4775f5657e68
>> --- /dev/null
>> +++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
>> @@ -0,0 +1,81 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +# This test runs a simple ingress tc setup between two veth pairs,
>> +# and chains a single egress rule to test ingress chaining to egress.
>> +#
>> +# Kselftest framework requirement - SKIP code is 4.
>> +ksft_skip=4
>> +
>> +if [ "$(id -u)" -ne 0 ];then
>> +	echo "SKIP: Need root privileges"
>> +	exit $ksft_skip
>> +fi
>> +
>> +if [ ! -x "$(command -v iperf)" ]; then
>> +	echo "SKIP: Could not run test without iperf tool"
> 
> You just need to establish a TCP connection towards a given IP, right?
> 
> Than you can use the existing self-tests program:
> 
> # listener:
> ./udpgso_bench_rx -t &
> 
> # client:
> ./udpgso_bench_tx -t -l <transfer time> -4  -D <listener IP>
> 
> and avoid dependencies on external tools.
> 
>> +	exit $ksft_skip
>> +fi
>> +
>> +needed_mods="act_mirred cls_flower sch_ingress"
>> +for mod in $needed_mods; do
>> +	modinfo $mod &>/dev/null || { echo "SKIP: Need act_mirred module"; exit $ksft_skip; }
>> +done
>> +
>> +ns="ns$((RANDOM%899+100))"
>> +veth1="veth1$((RANDOM%899+100))"
>> +veth2="veth2$((RANDOM%899+100))"
>> +peer1="peer1$((RANDOM%899+100))"
>> +peer2="peer2$((RANDOM%899+100))"
>> +
>> +function fail() {
>> +	echo "FAIL: $@" >> /dev/stderr
>> +	exit 1
>> +}
>> +
>> +function cleanup() {
>> +	killall -q -9 iperf
>> +	ip link del $veth1 &> /dev/null
>> +	ip link del $veth2 &> /dev/null
>> +	ip netns del $ns &> /dev/null
>> +}
>> +trap cleanup EXIT
>> +
>> +function config() {
>> +	echo "Setup veth pairs [$veth1, $peer1], and veth pair [$veth2, $peer2]"
>> +	ip link add $veth1 type veth peer name $peer1
>> +	ip link add $veth2 type veth peer name $peer2
>> +	ifconfig $peer1 5.5.5.6/24 up
> 
> Please use the modern 'ip addr' syntax. More importantly, it's better
> if you move both peers in separate netns, to avoid 'random' self-test
> failure due to the specific local routing configuration.

I have one of the peers outside a namespace because I needed the egress 
tc rule to see both devices.

Besides that I will change as requested, Thanks.

> 
> Additionally you could pick addresses from tests blocks (192.0.2.0/24,
> 198.51.100.0/24, 203.0.113.0/24) or at least from private ranges.
> 
>> +	ip netns add $ns
>> +	ip link set dev $peer2 netns $ns
>> +	ip netns exec $ns ifconfig $peer2 5.5.5.5/24 up
>> +	ifconfig $veth2 0 up
>> +	ifconfig $veth1 0 up
> 
> Please use 'ip link' ...
> 
>> +
>> +	echo "Add tc filter ingress->egress forwarding $veth1 <-> $veth2"
>> +	tc qdisc add dev $veth2 ingress
>> +	tc qdisc add dev $veth1 ingress
>> +	tc filter add dev $veth2 ingress prio 1 proto all flower \
>> +		action mirred egress redirect dev $veth1
>> +	tc filter add dev $veth1 ingress prio 1 proto all flower \
>> +		action mirred egress redirect dev $veth2
>> +
>> +	echo "Add tc filter egress->ingress forwarding $peer1 -> $veth1, bypassing the veth pipe"
>> +	tc qdisc add dev $peer1 clsact
>> +	tc filter add dev $peer1 egress prio 20 proto ip flower \
>> +		action mirred ingress redirect dev $veth1
>> +}
>> +
>> +function test_run() {
>> +	echo "Run iperf"
>> +	iperf -s -D
> 
> Depending on the timing, the server can create the listener socket
> after that the client tried to connect, causing random failures.
> 
> You should introduce some explicit, small, delay to give the server the
> time to start-up, e.g.:
> 
> # start server
> sleep 0.2
> # start client
> 
> 
> Thanks!
> 
> Paolo
> 
