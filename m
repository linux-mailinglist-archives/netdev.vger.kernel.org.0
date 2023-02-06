Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5D68C455
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBFROj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjBFROi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:14:38 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE9A59D2
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:14:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FapcWIJpm15y3/s4njxO9RTl433pNk4Vryq257ipT/W5c0O7PcSS5Z6XfuX2Yix7dS7dq0AcD7dhyiLB93x6aciqO90iEl+ePkCxW0mJmeU0EtDODqqvMEN/8bp8zh1UwXgor5PKWeG5+S6RZUKGRZeYRut/YjeFryQZusVsPZoWRRrYN+YQXd+2JfnXxP0wCDQqqJ1JYanzjrTO/vhEc0nr3HB/0Y1pljdYHq/O3Mv2w8/0a536EMTBqdJ+Abu2tnIACtuYt4qc5Low9xsqJp5INoT4ltWe4vL4aftVnU3q074WfKf2r9zmI7vyfDGNvt2+RGy0yxzt+u+lAS0m0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1Hnsy6FuMSOJIfg01Q1yehFGdgkUSAecgsMGzVXJu4=;
 b=MeQu7O5yxfMUNRQBZREbvruKjoJhibkpm/DsLzqtFjGQyGBe12NaS0tcQ/wFGnHWxSM+ceXZv3tnNx3FJ7Bj/hLSbPzx5XjszawRqJIkZzIlme6Ga0pVQpNE2UA01icz1wbWFpodcdBwQt2P5h1MNIOCb/7+UNRuGl20IsNkYW8pbMDCwEDbZ7aBpLPUMk/L1C+eFeml9rqMs6ciDyT2yoMDgy1Vf6KqJQ4DzqfayGJssVDUviYEC8ugrE/KGEQrAOVv0S+p+tcCUAsCAjEbntP9pxSSrYsPWydEnK0Db9e4ctY7oYsC58Ar3uaoKz9bhsdagVOqf7+lcd/7owP3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1Hnsy6FuMSOJIfg01Q1yehFGdgkUSAecgsMGzVXJu4=;
 b=jTxz1M6DP/JwlTOZSP8Q0G1R3gWF0qOSzkiA5yvx/LTSoLayxEzHyQIznqWCtbXen8zD/PtnP2UjkAv5yBxNkOoK/gpU9A2z2SuPoaFB8Vy0QQNrIA8Lp3egd6Vm5wC5gOGbaWXNH0HM2Wxvmu3pJCHwc21vpdSFvINSF0hLd0IUbKWew/uuTWGUmjluontFI2rdLP9hWy+thRZLS8Tqgepsh3o3xi7AK50jlCJxWjYwGAK81ABZ8L0/C99bYhRvr/XToWHZDjEOLszOfkGWTzYS4QyvLKGYUJKTq/KqzLYmkjuxP3IVZtvp21dMXVbQMog2/RFlXvaKs+mfNnNQbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by IA1PR12MB8221.namprd12.prod.outlook.com (2603:10b6:208:3f0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:14:34 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6064.027; Mon, 6 Feb 2023
 17:14:34 +0000
Message-ID: <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
Date:   Mon, 6 Feb 2023 19:14:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
To:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Marcelo Leitner <mleitner@redhat.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
 <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0034.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::17) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|IA1PR12MB8221:EE_
X-MS-Office365-Filtering-Correlation-Id: 77d76b1d-1246-437b-7ce4-08db08659dfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cx8srOnYqHFNPkeQjwq5UK/OKSoOR0oOzvSbDE0m9Vb6CsfDS9VaN+zUnEllF4G3zHr4kBFwngg0imEt4Fzsi82GdxRWOKZq8mi2e+2qtvRAWAkFTQgSjKjokRmHnBrPLrIXMCLUAfFNLU29VNS83D/hm5C2aSTuT+xpF+VUyq9poMNDbXm9Sm9sunAwpvoMwWWBxd+RslIilN8dDZvYrDV4TvcaIFF7f/O1M7tgG0D6HK8/RzcnfudBil0GyhHe13tKMuhD00pJJcfIMQhdkxgDd+ab4M+Lrh2orE6MrWlY8c/0FzZA3mBW9v18wXIxpACPOFTCLyJHeuG+R4j9EfzAQbfVMGDMyi8LxrchBgjpYw9CgRjA8U2w+zuIyjS36l2jxKhUPgfVKucZyb0+K9c/hoW8SfoGFNOHOygop0M8U3vZpzAiVhdQCdujKln7b152fgK078Vlq+qYUFGyUvayzFSEKNON4/oeK1SyC+/3g0hEZj/pV1I1caxNsVfIgIOvrBAKU/MC8pmtTR9hke5+IYZBGlgMYz+xTu1xSwcbqigeMwB7U2hErgQBI2IGxqm6hGaZtLamVM5Path91iiahMtJbsIKwUZ2kyip6aw4g/m2QhDIpavIkRVHrMosw9ylbrTsEMH0/XNJMdGRKMALhOHUC0OmfpfdFUV+QHY/QzS7j5fgDHERtgFwsps2IDxhUh3ybnL7cnzhUfAu+hUIba1r/mi3WjkM+mBcRYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199018)(31696002)(86362001)(36756003)(38100700002)(8676002)(41300700001)(66946007)(8936002)(5660300002)(110136005)(316002)(66476007)(4326008)(66556008)(2906002)(2616005)(478600001)(83380400001)(6486002)(6512007)(6666004)(26005)(6506007)(186003)(53546011)(54906003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXVTOEVCUndvT21xcGZVajRoQk44bWZ5RCt2cmJEWUNFcU5KTE55QmYybU55?=
 =?utf-8?B?dUZUaTZFWVRLdzl5OE9MZCt5cnNOemQxb3N6aG94ODYwMXJBemU4My9helht?=
 =?utf-8?B?c2NVYXA0S25sTlI4MWxJZGF0SVQvTHROK0MwcmJVdWpYUTFoNFZnUjgwQ09q?=
 =?utf-8?B?bFFDcUZ2bjh2YXYxNFpqVFJDL3RoaCtvbm5lTnNpS3Zqd25PR3p5YVdTZ0dH?=
 =?utf-8?B?L0JocWF4ZHVveHZmTlJtRlduTFNqRTF0Nno0MHREOGhjYmJoTm1FazMrcHEz?=
 =?utf-8?B?SFlDMm9JOFVqVGlWMGFaZDNKbi83b3dLMS9YN2lYREFSeGg5ZWFZeW5EdzNi?=
 =?utf-8?B?eWtja3p1ZTZocjNDRWMzTldpVUN1MUhhRGs2NEhEWTJ0a2FZakVzZzN3VkVz?=
 =?utf-8?B?ZnBZUEdWazFTdWFnNWcvQWJKOEJ4djRiQlI5Uy9DSXgza3dlY1VzeHlJbDN0?=
 =?utf-8?B?c2x5U0gydC94bmVDb3gwamlGd1poaGxvdlA0Q1ZBenI5VWJYSDAxeFdLSVZR?=
 =?utf-8?B?bDMweTVGUmdCazNMdUFhcUkwWVpEWWY5M0s3MHVCbkZTdkVSYU5CU0VlaHZa?=
 =?utf-8?B?b1hINld6d3RibWdISXhlTlhPM2RRT1dJOXo4SG5GV3JJMnBoc1BMWkNpZjlo?=
 =?utf-8?B?ZzhUMFM2MWlkQmgrblA1VHBrVjlRUldDZkZuUHp1VDQrdHBldEViVnJDU292?=
 =?utf-8?B?U0ZIZ0ZBaC9Wb2VsTHZWNENTTDg1ek9uc1Izb21BaGdZQ3hLZm1OcGFhZmMr?=
 =?utf-8?B?ZkN3NUltNTVLbHZ5d0NyQ0FaSU52VEozdFN1ekN2eWNMWXQvQURndEprSDVK?=
 =?utf-8?B?T2pBSzBIQU5xK0h5QVIwRVJpN0xocmhqdXR0Y0RTSGNPa201RWkzL1VyRlFs?=
 =?utf-8?B?Nit4QkV4YnJ5UWRoWXg1c01PTFFUbWh0YmpINjEwbm5lNmdwakdyQXcxLzA4?=
 =?utf-8?B?eU4wc29GUWFZcURWZW9uVmxyQVRHbFV6WkNmMUtZRFZmM3VhdnlvRWJPMDV1?=
 =?utf-8?B?QWpRSk4xaTQxbFBZb3NHRCs3VlgwR2Vha1o2RXQ2ck81ZlNXdEl3cUVTRC9p?=
 =?utf-8?B?WktVbVhqU0hwN1FQMVRxT0Q5QTJRTXp2QjlPQ3RvQ203dCtZMVV4ckY4ckN3?=
 =?utf-8?B?UGQxMm5IS200alpPd1hhWERWN3NHMS9rYmR4cm1jdXV2UzZCTFJ0NVhBQlM3?=
 =?utf-8?B?blo0eXgyTXhUUE8zZUtEWTE3MDN0enVjaHVKVWNyOFlPOUE2STJ1am04TFNI?=
 =?utf-8?B?TmszT1lHZ2tKandZL2JITE1UR05uRFYzcERCYTgvVEtBeUxIRnFmT2hmWkdH?=
 =?utf-8?B?eUhTU25vaG14NUxqcGZBZjhkT0ZqZW5SWHFwb3lZcGZzZVg0V20yRDJFUHVy?=
 =?utf-8?B?VEtTekZkR3FrNDZ1TTlxbUdJR014K0QxOCtQaW8vb2VLaTgrZVl0NVVvdXRB?=
 =?utf-8?B?bHU3L29OaFNTV0FmR3RDNjRNVzBaQTVvVVJPQ2ZEM3B1TVpoRUdKWjJiTTZU?=
 =?utf-8?B?RExPaGZTWlRKT0kraURJZ0psSWdKUWs1b3hXVVJhUVFlMjZkWkFiQUpPeGJV?=
 =?utf-8?B?UFYwdnNYMGJjRHd5SHk0SXVjUGxMTHJoZjZiei9BU2pDbG5XdGp2aEtGNkZ2?=
 =?utf-8?B?d1ZjbU1raVF2L3NGcHNzMGI2UVNya05UZHRtcHhvcmtxT2pScGNOVzlrdGIx?=
 =?utf-8?B?a0luY2tUWkd1MWpXdXFBbGpyeEZIcW1KMlpCcDlsb0NtbUQ1c3VyNUhhZmFw?=
 =?utf-8?B?WnZxM1c1SHg3QW9oMzlaQWJlZ1l1TzY2YlAzWnRLK3d6ODBzNmVGbzJOYjVP?=
 =?utf-8?B?QzV4MFVzSUhLeDBKQURab1QyR3lRWVR2MTBud2NrMStxQkh4YmRNb3dDVDc3?=
 =?utf-8?B?akxZYjhJdVljTkthR2RTcnlVV2NERTNlWGFJc0pJa1FIWmt3THJnc2R3Tmt3?=
 =?utf-8?B?dlhUWEkvSzNOcFZFa1hIUk1zb0pQemozdHg3K2RscXN6eW1TQ2JPc21oL05n?=
 =?utf-8?B?YlpROUpCbklWUGVvdlBUc2hvbFYzRk9kSStHakFjaUlZdXJkWGpSODhieHBM?=
 =?utf-8?B?cGxFL0YxMjQ0VnhzRlVCVWhCVWtUczZDZGpCd05FYmhabk5ZdTNYY081OXJJ?=
 =?utf-8?Q?BZRpyhv5lenWdNEM0faq5Gj2B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d76b1d-1246-437b-7ce4-08db08659dfc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:14:34.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KVEh2qVqe8PJpFCcIoWKzyHkLeO2HBD1iku4jLNt2r+SEzOAcPCOF9IfDdZmtl+/+qIi7TAP0Kg+Lbci9kNxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8221
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/02/2023 14:34, Ilya Maximets wrote:
> On 2/5/23 16:49, Paul Blakey wrote:
>> Hi,
>>
>> This series adds support for hardware miss to instruct tc to continue execution
>> in a specific tc action instance on a filter's action list. The mlx5 driver patch
>> (besides the refactors) shows its usage instead of using just chain restore.
>>
>> Currently a filter's action list must be executed all together or
>> not at all as driver are only able to tell tc to continue executing from a
>> specific tc chain, and not a specific filter/action.
>>
>> This is troublesome with regards to action CT, where new connections should
>> be sent to software (via tc chain restore), and established connections can
>> be handled in hardware.
>>
>> Checking for new connections is done when executing the ct action in hardware
>> (by checking the packet's tuple against known established tuples).
>> But if there is a packet modification (pedit) action before action CT and the
>> checked tuple is a new connection, hardware will need to revert the previous
>> packet modifications before sending it back to software so it can
>> re-match the same tc filter in software and re-execute its CT action.
>>
>> The following is an example configuration of stateless nat
>> on mlx5 driver that isn't supported before this patchet:
>>
>>   #Setup corrosponding mlx5 VFs in namespaces
>>   $ ip netns add ns0
>>   $ ip netns add ns1
>>   $ ip link set dev enp8s0f0v0 netns ns0
>>   $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>>   $ ip link set dev enp8s0f0v1 netns ns1
>>   $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
>>
>>   #Setup tc arp and ct rules on mxl5 VF representors
>>   $ tc qdisc add dev enp8s0f0_0 ingress
>>   $ tc qdisc add dev enp8s0f0_1 ingress
>>   $ ifconfig enp8s0f0_0 up
>>   $ ifconfig enp8s0f0_1 up
>>
>>   #Original side
>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>>      ct_state -trk ip_proto tcp dst_port 8888 \
>>        action pedit ex munge tcp dport set 5001 pipe \
>>        action csum ip tcp pipe \
>>        action ct pipe \
>>        action goto chain 1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>      ct_state +trk+est \
>>        action mirred egress redirect dev enp8s0f0_1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>      ct_state +trk+new \
>>        action ct commit pipe \
>>        action mirred egress redirect dev enp8s0f0_1
>>   $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>>        action mirred egress redirect dev enp8s0f0_1
>>
>>   #Reply side
>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>>        action mirred egress redirect dev enp8s0f0_0
>>   $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>>      ct_state -trk ip_proto tcp \
>>        action ct pipe \
>>        action pedit ex munge tcp sport set 8888 pipe \
>>        action csum ip tcp pipe \
>>        action mirred egress redirect dev enp8s0f0_0
>>
>>   #Run traffic
>>   $ ip netns exec ns1 iperf -s -p 5001&
>>   $ sleep 2 #wait for iperf to fully open
>>   $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
>>
>>   #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>>   $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>>          Sent hardware 9310116832 bytes 6149672 pkt
>>          Sent hardware 9310116832 bytes 6149672 pkt
>>          Sent hardware 9310116832 bytes 6149672 pkt
>>
>> A new connection executing the first filter in hardware will first rewrite
>> the dst port to the new port, and then the ct action is executed,
>> because this is a new connection, hardware will need to be send this back
>> to software, on chain 0, to execute the first filter again in software.
>> The dst port needs to be reverted otherwise it won't re-match the old
>> dst port in the first filter. Because of that, currently mlx5 driver will
>> reject offloading the above action ct rule.
>>
>> This series adds supports partial offload of a filter's action list,
>> and letting tc software continue processing in the specific action instance
>> where hardware left off (in the above case after the "action pedit ex munge tcp
>> dport... of the first rule") allowing support for scenarios such as the above.
> 
> 
> Hi, Paul.  Not sure if this was discussed before, but don't we also need
> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
> 
> Currently the in_hw/not_in_hw flags are reported per filter, i.e. these
> flags are not per-action.  This may cause confusion among users, if flows
> are reported as in_hw, while they are actually partially or even mostly
> processed in SW.
> 
> What do you think?
> 
> Best regards, Ilya Maximets.

I think its a good idea, and I'm fine with proposing something like this 
in a different series, as this isn't a new problem from this series and 
existed before it, at least with CT rules.

So how about I'll propose it in a different series and we continue with 
this first?

Thanks,
Paul.


