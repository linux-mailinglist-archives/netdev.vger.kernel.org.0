Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E33468EA17
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjBHIl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjBHIl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:41:56 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E012312D
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:41:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U77Dj5qyF6Bvkv1zzdVw/uCcXxHt5e+iXnXFSR6zjHeATw8C5xS5YTwixUXzfR2csSK/lE2Wk7MJ92g142CCetHQ498OV7mQCDPcOSpSLmWsAayWt5kFL1KyCTf5HyXx0QG348nygYDUC0vjse51t+Cuq3Q8FuIYn1r7pIOrt8NX5UAiR117RJAxhnoIyHOwYpIeWtsfRK73aAiNX1emoaS+iTWj91TF99YvLl/GGvrfxYLYp3z6/wSYaO84TCIMBoAkOAs6MPutN3hlEBIz+NxBBpEeWqRC5Qrc70XZQPXCqeN5CDYLrCw/NG0BzL3BFogpeAqOZ7QTX5cCHbKIGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SZK+l7LglrBUs0eIbyON+LvtgHz1mASEVpQ3f5Oig4=;
 b=cpIoXGwngkqG1f4QOrcaQyLjBLv/K92qiDJLpaS+c4jKd+U2Yi1oUSmCzojB1n2Aqk0fhzdIJDDGlqibE44OdY93Pi0UUYQN33vyBrEqIq9kODr9KutBNwKPGL/e0g4EcgeDsi1xpJZYcO7ZQa/ObCCmuJc2AXL/Z/8TtPbl2niowRfY/FCfJvK6KEaMGiFllEY0a73V3FBK7PiUFF5axlylOXKmoyklcZpVX30K9eryw1ZvZwpsGIwTWclHxWHT5ZLzPWbfeMZ6DaE2xe/ktCGR3k3RAxitJB5tgeujHnuzQpYlloBRA1DpxrvOZg/4eFTUSH+YYocpp5Nz920EKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SZK+l7LglrBUs0eIbyON+LvtgHz1mASEVpQ3f5Oig4=;
 b=K6uDyik1paAt9JehNp+PyGkzETyhWHNMFARZusSz1d+S75HfkSMs9jRInXgVnZgnUjguNlizKmC1ynd2TLGx8CrshuoWUAKsEk6ZqZtnUokHpVdjYyscXvZAOGznC2I4eaJO+afqq1bONgBJ0h8OiwQ0++gUHW3UkttcW3iO1nc8DBwSN4DZbkitL2ljrsY/QVR/A7aYq1lQh8ZqWRGVzXyDkrANJiokdwUdoC5o5C1MNm0ZkTe9HGNgV321cd7yHH0/zQ56kEwe6+YakKsYiY7z4NZNJSbqaLX/ZT0iVCUsGiq0i06uaURDryQEkZ7TvaDueZUTt2ZMbgNCFkBnLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 08:41:49 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6064.027; Wed, 8 Feb 2023
 08:41:49 +0000
Message-ID: <a2f19534-9752-845c-9b8a-3aa75b5f3706@nvidia.com>
Date:   Wed, 8 Feb 2023 10:41:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
 <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
 <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
 <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::6) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 146cf217-06ad-4c6a-e32d-08db09b05180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YiOmg7U28yxQUmj4MNGNCHoQcfrBL56igVqiOLggalvXxeQBZ5L6mg+duEIr/y8usN+wt1+eOKLFv4E0HJD4Zp7Gz7Vsm8zu44heoVzpFuEfIktpPmdIKDQNkE0WpPvWRJayT1FLL3fzBfpYVitA5vCBiYBO76rNAF2U5iPC2IXC90OyJaml3+mul1e7H364x0u1MOexo4WQbubemMLWxHWmxsifGplsKZ9iWVbtLJDi5dB4zvhw0dMGvpohJ0XD95RJn/6leZrqih3n3vRNkYuHuCUA8RpiTQoZ7zyPjB784fvS6Op2C53Hy4qaYCIHh9OQV5jRESoPG49Zcbn8OjiJBZkVosOymmJUwC3IdjDGl/yTSsGrORxZO81si5rPbwomlX22G98Lw17tLcepH7rz1fzbO6mwsHMcfLF4QuJDO+718kQv3RCC6e73ldQaek3epz97GZ+a2oe89GoWdoBMrA9se1RrCKFq0sG1Ep4nJNGYidkqiO6yX53mUYAVRJM+RFaKwkJdfPiq9gjTCNI+OcDHY5/hFhCC53w9qRzJvlq4aX8BaIHdlDzI2BJzSIXaj/Or1mzH7fUIfRGORdAST1inf5+ueqMbKbKlboEBVRRyPp9i8WyJj333LOYGjx47vgIqHx2COam9cNEFvCozXroYvMEGKrLIVHOB08HNzNitWKtcDU43QE6MTKkwaobfV1GBEJ88CTzItmKNh5jjBl60/4Esw4G93cJuhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199018)(5660300002)(86362001)(2906002)(8936002)(41300700001)(66946007)(8676002)(31696002)(4326008)(66476007)(66556008)(36756003)(83380400001)(107886003)(6666004)(6506007)(53546011)(26005)(6512007)(186003)(478600001)(6486002)(38100700002)(2616005)(110136005)(54906003)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDRqL1lTZnBwYTFBL0ZVZEhMVnkyTXovVkdSa0JxOGExTTF5THZMTi9qWFhR?=
 =?utf-8?B?SjhFTU5wMlI1TFFmekdSOTdSUkg2aFVnSU1CUk9XR2JCbzIvNVBrNzdWY2hm?=
 =?utf-8?B?ci9tcU01N090am8yVUhiaHduQkJkbWJDc0VOME16WmtjRk1QOXZiY0dITTJE?=
 =?utf-8?B?V0tWR2Q5TVRuU1M2dkN5NlpRYU1RaHBQQnA5SzVybWhxdlFHc0ZZbHljeDU1?=
 =?utf-8?B?T2lkaDZkRzJTbzRjRDJZZ1pRaVRDVS85dlJsazNPdUJ2Z3RLUXNWeC9VWUZj?=
 =?utf-8?B?ZVFMK2ZtdzhmcS81MkFVREx5MzJvSVNrNFNhS3l6ODBQVzNOc2k2MkdqSm5X?=
 =?utf-8?B?K0EvbUM3NWNhU0pSUXdCaXVxWVFzUkltS2ROVURKMFdITFBneUtPRy96N3g1?=
 =?utf-8?B?dkgrMFlrOGttMFBWcmFPZHRpc0w2NG1zYndnVmVGb3poY0pFVHNtbGpDK2lx?=
 =?utf-8?B?N1ZEZ3JRL21jUU9vMS9taDNMQnhhWHZ6ZXdVd0FYTUo2SmdUcm5MOGlhYlhy?=
 =?utf-8?B?RFR2aFRWZFgvUGtFQmxoTHROeDlnUUo5Sjk0OUIzL1BLR0JCWFMvR2RuMS9G?=
 =?utf-8?B?OHVpcUtNbjY1TXd3MzNTakQ3aFJwQUplSDU2Z2hlMmpPMmd1QVU2NlQ4TkxS?=
 =?utf-8?B?SnFpYUQ0bWM2cFVybTVhSHlJRDZKVmVVZ1RteUVacVl2RWQ2T0VCSS9PVmFQ?=
 =?utf-8?B?NkpXQjJHMTVxWWpTdzF5b25jbWErSU1YRXUxaXcrcHhGSE5QUmZEWmxqSUxY?=
 =?utf-8?B?emNBVHN2WitpUURrb2RGR3RCZWE0d29aek55UFVycnpMbGJXMEVwZXJTakpx?=
 =?utf-8?B?d3dWckp5VTVHQ0IvUTQ4UlFwWURUcTh5NTBOMXRNZStWMCszRzVjclFkTXRp?=
 =?utf-8?B?bXdxZnBFWXhTY2xqUHZGeGN2amg0NmpVRTkyWHppL0ZsNU9ZN1pxZHZGcndN?=
 =?utf-8?B?MEptUXBvbzE0STN1NHhqME1MRE9IYVU2NVpHU1JrQzNMUHRURHhMVHE5TjB1?=
 =?utf-8?B?QUhvdDlYQVBoTDY1WURMK0MwbjdXKzFYbDZRS2o0TEVWQVVOU3ZzbElJdk9m?=
 =?utf-8?B?Y1VSa1IzbDhZVTFUUVczMkN1R0xNWmM1cFMwYldMejdCZ0pxZjhuYVMxZkkw?=
 =?utf-8?B?WS8zd3VZMGFFc1RzY1BWWG1xR1lHMDhscXB2dmNDYjNFUnozTTdPOWRqZ3hS?=
 =?utf-8?B?KzJuUllCOWxJaWFqbGFKZDhpdmtnMi9oNWpDMXhRVVFqS1RKZm1lMWgrazdL?=
 =?utf-8?B?SXpMbUFGREphU2VYUktsMnAxakJGUHRpNlVzcVpHTlZVK09HOTM5RWFOQ21m?=
 =?utf-8?B?VUE2TVFCVlRad281OVhiZG5YcGRzd3ZoZk9XenZkcUI4Z29CMmc1bGFsZXA0?=
 =?utf-8?B?aXlZU2k0YzZ0Z3ZxcDJXVTFBL0RKZXpWUTBFbUdoZk9oSmJPN0dkNHRCQi9o?=
 =?utf-8?B?am9xZzJjWmhlOGJkOVZGUmhNYjRRZUxpZldRa3NMYmpPdEJTVENxUmpwQU9r?=
 =?utf-8?B?RVhOVzBvVGdCeGhKazhBRldXTFJWVTBRc2YvQ0hVM3k4elBmaW9MUTIwZHJO?=
 =?utf-8?B?bnJFVXJNY0g0TDFpYU9nN04vM1N2ZFhRS1Z3bmlFYUNwVTdkaGhEYTNJSksr?=
 =?utf-8?B?bEdFV0VtYW0xMXpWTmtGT0tFYzFkY3ZaMlBiREkreXhTSjJSU0tZTDJKTXZo?=
 =?utf-8?B?WGlLL0RTWDVCek51M2JaSmM1eHlBanZybm9iUHRITktGd2hRK3h2VTBnNUVa?=
 =?utf-8?B?OWpNaVJrSjRPVnVOeFVoYkxKYkVqOWQ3MXcwMitYdTRqYmxGZGlhS1hhd2Zp?=
 =?utf-8?B?TG1xZjVVODRsNDNkci9rakY3OVJUcWVERGh1YjloVjQ2by84T0kwcFpDbEVB?=
 =?utf-8?B?L1FwRU5zNnluVUVCMndLR2hkMGtHZ1p0WW1yYkVUMnNuR1J5blc0aEYzU1Fp?=
 =?utf-8?B?YmNQeko2OW1NY2NHTmRua2ZGcElkcSt3N2IvSXdYZFdRc1R4N2NzWUNlajRm?=
 =?utf-8?B?TTVKVzVVdnBnQlBVcng0REJNNlpvLzl1Zm1nTVk5RXIvdnNvaE9OelBBMVFX?=
 =?utf-8?B?dmJITVJHeDZacHZwVG5rdXNuK3Qwa1JaNHFLd0twMXlQYktVQ1JJOEJob1I2?=
 =?utf-8?Q?ljHNA9a8DwnLnMv6GTLORc/sf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146cf217-06ad-4c6a-e32d-08db09b05180
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 08:41:49.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BC3sfn0ydItL5Yk+32ipG7C1OAGdEuYEgWlC0mJVifOHrZgzS7LcBgbs4F0lJszcdB4eG72VQzxFjxgN/df+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/02/2023 07:03, Marcelo Leitner wrote:
> On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
>> On 2/6/23 18:14, Paul Blakey wrote:
>>>
>>>
>>> On 06/02/2023 14:34, Ilya Maximets wrote:
>>>> On 2/5/23 16:49, Paul Blakey wrote:
>>>>> Hi,
>>>>>
>>>>> This series adds support for hardware miss to instruct tc to continue execution
>>>>> in a specific tc action instance on a filter's action list. The mlx5 driver patch
>>>>> (besides the refactors) shows its usage instead of using just chain restore.
>>>>>
>>>>> Currently a filter's action list must be executed all together or
>>>>> not at all as driver are only able to tell tc to continue executing from a
>>>>> specific tc chain, and not a specific filter/action.
>>>>>
>>>>> This is troublesome with regards to action CT, where new connections should
>>>>> be sent to software (via tc chain restore), and established connections can
>>>>> be handled in hardware.
>>>>>
>>>>> Checking for new connections is done when executing the ct action in hardware
>>>>> (by checking the packet's tuple against known established tuples).
>>>>> But if there is a packet modification (pedit) action before action CT and the
>>>>> checked tuple is a new connection, hardware will need to revert the previous
>>>>> packet modifications before sending it back to software so it can
>>>>> re-match the same tc filter in software and re-execute its CT action.
>>>>>
>>>>> The following is an example configuration of stateless nat
>>>>> on mlx5 driver that isn't supported before this patchet:
>>>>>
>>>>>    #Setup corrosponding mlx5 VFs in namespaces
>>>>>    $ ip netns add ns0
>>>>>    $ ip netns add ns1
>>>>>    $ ip link set dev enp8s0f0v0 netns ns0
>>>>>    $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>>>>>    $ ip link set dev enp8s0f0v1 netns ns1
>>>>>    $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
>>>>>
>>>>>    #Setup tc arp and ct rules on mxl5 VF representors
>>>>>    $ tc qdisc add dev enp8s0f0_0 ingress
>>>>>    $ tc qdisc add dev enp8s0f0_1 ingress
>>>>>    $ ifconfig enp8s0f0_0 up
>>>>>    $ ifconfig enp8s0f0_1 up
>>>>>
>>>>>    #Original side
>>>>>    $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>>>>>       ct_state -trk ip_proto tcp dst_port 8888 \
>>>>>         action pedit ex munge tcp dport set 5001 pipe \
>>>>>         action csum ip tcp pipe \
>>>>>         action ct pipe \
>>>>>         action goto chain 1
>>>>>    $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>>>       ct_state +trk+est \
>>>>>         action mirred egress redirect dev enp8s0f0_1
>>>>>    $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>>>       ct_state +trk+new \
>>>>>         action ct commit pipe \
>>>>>         action mirred egress redirect dev enp8s0f0_1
>>>>>    $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>>>>>         action mirred egress redirect dev enp8s0f0_1
>>>>>
>>>>>    #Reply side
>>>>>    $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>>>>>         action mirred egress redirect dev enp8s0f0_0
>>>>>    $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>>>>>       ct_state -trk ip_proto tcp \
>>>>>         action ct pipe \
>>>>>         action pedit ex munge tcp sport set 8888 pipe \
>>>>>         action csum ip tcp pipe \
>>>>>         action mirred egress redirect dev enp8s0f0_0
>>>>>
>>>>>    #Run traffic
>>>>>    $ ip netns exec ns1 iperf -s -p 5001&
>>>>>    $ sleep 2 #wait for iperf to fully open
>>>>>    $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
>>>>>
>>>>>    #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>>>>>    $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>>>>>           Sent hardware 9310116832 bytes 6149672 pkt
>>>>>           Sent hardware 9310116832 bytes 6149672 pkt
>>>>>           Sent hardware 9310116832 bytes 6149672 pkt
>>>>>
>>>>> A new connection executing the first filter in hardware will first rewrite
>>>>> the dst port to the new port, and then the ct action is executed,
>>>>> because this is a new connection, hardware will need to be send this back
>>>>> to software, on chain 0, to execute the first filter again in software.
>>>>> The dst port needs to be reverted otherwise it won't re-match the old
>>>>> dst port in the first filter. Because of that, currently mlx5 driver will
>>>>> reject offloading the above action ct rule.
>>>>>
>>>>> This series adds supports partial offload of a filter's action list,
>>>>> and letting tc software continue processing in the specific action instance
>>>>> where hardware left off (in the above case after the "action pedit ex munge tcp
>>>>> dport... of the first rule") allowing support for scenarios such as the above.
>>>>
>>>>
>>>> Hi, Paul.  Not sure if this was discussed before, but don't we also need
>>>> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
>>>>
>>>> Currently the in_hw/not_in_hw flags are reported per filter, i.e. these
>>>> flags are not per-action.  This may cause confusion among users, if flows
>>>> are reported as in_hw, while they are actually partially or even mostly
>>>> processed in SW.
>>>>
>>>> What do you think?
>>>>
>>>> Best regards, Ilya Maximets.
>>>
>>> I think its a good idea, and I'm fine with proposing something like this in a
>>> different series, as this isn't a new problem from this series and existed before
>>> it, at least with CT rules.
>>
>> Hmm, I didn't realize the issue already exists.
> 
> Maintainers: please give me up to Friday to review this patchset.
> 
> Disclaimer: I had missed this patchset, and I didn't even read it yet.
> 
> I don't follow. Can someone please rephase the issue please?
> AFAICT, it is not that the NIC is offloading half of the action list
> and never executing a part of it. Instead, for established connections
> the rule will work fully offloaded. While for misses in the CT action,
> it will simply trigger a miss, like it already does today.

You got it right, and like you said it was like this before so its not 
strictly related by this series and could be in a different patchset. 
And I thought that (extra) flag would mean that it can miss, compared to 
other rules/actions combination that will never miss because they
don't need sw support.

> 
>>
>>>
>>> So how about I'll propose it in a different series and we continue with this first?
> 
> So I'm not sure either on what's the idea here.
> 
> Thanks,
> Marcelo
> 
>>
>> Sounds fine to me.  Thanks!
>>
>> Best regards, Ilya Maximets.
>>
> 
