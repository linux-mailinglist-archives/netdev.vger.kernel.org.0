Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4818E33D6F9
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhCPPOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:14:02 -0400
Received: from mail-dm6nam08on2108.outbound.protection.outlook.com ([40.107.102.108]:61709
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238006AbhCPPMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 11:12:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwkY27Pdazr8LtKidoWyDa5CA0nI2hetTDztXZsJ4WfGAgS/ZU1XLogWFPGmYtyxJNzbPO6Vr2VYHWEG7JOEi5/6jbz7MiMCZNF/xQg/q97Gn/fDur7z7+PyyMDFrQYQ8J6HTuXkOz8t9yvRxrqKyosqgU88Z9v7v3uuTj7/kEAm1JjkpCVgq6pJVcVnMKRApblZCrpuu+dwJt6Vpt2jiwr1p4k/8j7oNApiU2ArVOzYTi+YETaS+USN3rXxMQOwbQbguof7c9oODvLQcOKRLRi4gABdEDfSNc8WQ0iA4pv6PPrgCFlSnUpr8FiWHnKr42QbZSPYLs0w7RlR0cq56A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKcaFsxR36hWQc9ctJsxDSBafNUOO5izih3/IymMg1U=;
 b=jAJ7rHO43CcurKC6QU4Asj60J9XGZamtq3s5d6kBhV23HovdEJNupULEXU8yyPJw+my+0+PMlYX34wc7G9YQdYzz4o9B7tMUsP/U9SAKsOJAhB0gQzVrNUIQzsd7qImbk+a01yrACFceJD55Wg9HYPSOVZ9uRnQ6DaxPtEgBk7/AXri9FaRzr/ektEWkSuRxWaTQaZJFH/xqrcPJPKRPc5KzljoOKR265O2A5zJIt5laHBEVY3A63y1+HcXuqvePorClQSg4TNsrTeXbvtvQfRas9hSa6EycCALEBtsNDt+LJnupeV4j7k1pRF4TFzr4coDhnu77SUi1Z7hmjPukng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKcaFsxR36hWQc9ctJsxDSBafNUOO5izih3/IymMg1U=;
 b=n85JeZzrMgFJxOIma+gK1S+stixmIeHIGpcRko71cdL1R2n1NsQ3huBQpDeorUdZE5jOHwbFgUwxAtMY65Gfm7KqseLTH3pbV+Uvj1f2IAQcTnRQrPspOGqXYv/yAIpjET2AvOEw1u9Lhvsh0cKtf+3VsRCjJ0egXjZ0Sw8Rcec=
Authentication-Results: netronome.com; dkim=none (message not signed)
 header.d=none;netronome.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB2889.namprd13.prod.outlook.com (2603:10b6:5:146::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.11; Tue, 16 Mar 2021 15:12:33 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80a1:dc0f:1853:9fc9%4]) with mapi id 15.20.3955.010; Tue, 16 Mar 2021
 15:12:33 +0000
Subject: Re: [ovs-dev] tc-conntrack: inconsistent behaviour with icmpv6
To:     wenxu <wenxu@ucloud.cn>, Marcelo Leitner <mleitner@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     "ovs-dev@openvswitch.org" <ovs-dev@openvswitch.org>,
        Paul Blakey <paulb@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
References: <DM6PR13MB424939CD604B0FD638A0D56C88919@DM6PR13MB4249.namprd13.prod.outlook.com>
 <189ecd92-fe8c-664d-9892-76c5b454cbc9@ovn.org>
 <YEvlysueK+eiMc1b@horizon.localdomain>
 <58820355-7337-d51b-32dd-be944600832d@corigine.com>
 <fc269566-9652-ed80-cea4-016c069fa104@ucloud.cn>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <c32bac8a-8127-1bf1-3b3e-13afdfbe7379@corigine.com>
Date:   Tue, 16 Mar 2021 17:12:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <fc269566-9652-ed80-cea4-016c069fa104@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [102.65.192.244]
X-ClientProxiedBy: LO4P123CA0220.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::9) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.107] (102.65.192.244) by LO4P123CA0220.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a6::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 15:12:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3bad4c4-bc5e-4da3-4dce-08d8e88dec41
X-MS-TrafficTypeDiagnostic: DM6PR13MB2889:
X-LD-Processed: fe128f2c-073b-4c20-818e-7246a585940c,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB28892EE8CB4AC022A34A310D886B9@DM6PR13MB2889.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9D5I9tzr321ZHL1KV+7aTc4TbpAMPOMQNOB42HtK7+ZXJZk1IhT8vUHHKi7Yd4CELwhSA/mIn0tr6oevuCdM0KWwFvwfQL8Zj3IXUZeN7PJEvqIV2nRXf4vH8WZmGHaG4QUZTuY3v6L0nrFOLiJs+hXAdzwvCXjYnrE4Pz+wIvS/ytFX2F3ZgLgtbeDCS0MjLPlIAl1RiOtLU+ilvhtYs3djyMyVr3rsDj9iIY2BIuy3izss+syB9ebVsuKmULMB5mWx766PaXkuzaefReW4gCHaFbqGFLuwbQcunzgEdB98vO6KFY/z+AZZKmcJfuDaomk/aP0tuEB+dgA2ViH0eKGSNETje85pshCcDO7NdrWlFaQVFzcUrwOaItkxXEsXCMbRBFzwjUEXSz9JjBffbUUhtjz/g6paqMLh/O7aT61mRWgJf7bTxaU+KeReXoA/bE1LmagpwQ1rMaOGyUmlv3Dr+XlmGUXR7/o9Lik7+kWl9OmT/ftF66Ei1tmgcPALaIequBQ24G1CdeS11hr/g1gA+e+GG6/OD5cREuFyT9xwA6660m+Zq3beRuUloIPACbgOSp3ybNvXG/c6RUhDP1XR8cEz3oSNYWbvkrf6lW/o5+zbbzY0ZdvFLxzryHNfqo3qab+ob5I3veE0EZ0Ggw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39830400003)(136003)(6666004)(83380400001)(52116002)(6486002)(956004)(66476007)(36756003)(66946007)(31686004)(31696002)(66556008)(2616005)(8936002)(110136005)(26005)(44832011)(54906003)(53546011)(5660300002)(2906002)(30864003)(478600001)(16526019)(4326008)(8676002)(16576012)(86362001)(186003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NmIzZVFWUlF6c1NOeWp6MkdYTXRwaW9Pamc4SmxvUU83c3NKanNXNUlJVFZy?=
 =?utf-8?B?clNwZGRLd0ZLN052Q01GakdTV3pNVXN0T3R3UHlKNHNsdEZMRTBBYUdRaEZK?=
 =?utf-8?B?cTFhcW4rQWZxYUxtcmx4UFZ3Z2JSOHpIWjdIQ1FDUisrai9Td0tzeUlkVGpu?=
 =?utf-8?B?SEQ1bEtVZSt4SFBuT3BWbE9kcmhrTHdJa2Z0NmNOK3R6M0FJUFFGSVUzMFFC?=
 =?utf-8?B?WDI1M0w0VUlpWWJtSnZ2MlZKMDlSbUl4eTR6cWcrRkpNSmtzRndRSkJJUEcr?=
 =?utf-8?B?ZytKZnpVZ2lRdEFmLy9DZWhaa3E2S3lCVVJ4R0VKSC9SbkEvVDN6ZTdnOEJP?=
 =?utf-8?B?MSthTmVhMU00dkdYNlBEdWI0RHhsZ1Y4K3p5Vk1ZK2dpSllvRnJPcHQzMTIv?=
 =?utf-8?B?TmNlRFZlREdmbjhqazZuZ2NZaUhXNHNXbzU1UjZGODdydEFIRmM1N2pqYlNO?=
 =?utf-8?B?bk9qbUhyWWR6L0lkK0RXWDZhYjhuZ1FFTjJmMERhU0x2aEwybGdNMmFoRnJF?=
 =?utf-8?B?eWx4a25URUFGMGxQVFpwM3lKaTVoalhGUVVHa2RNeDRsdUNLQ0lsdWs2d01O?=
 =?utf-8?B?RUZIL0JOemNGYlNzM0hZOG0xaWZpRDhjQ3lOeThZb2Evd0V1T1hFWlAzajV4?=
 =?utf-8?B?WGdISi9NWDdkUENETUpwdUd2Mjg1RVk4bEJENHljUXgzN1RsZ1NxN1hJL252?=
 =?utf-8?B?NnEvV1NQbEFuVjc1UkI3SWtXY1VWbzRBMDJFSmRUNjdVeElUR1p2d1I2dzkv?=
 =?utf-8?B?cUZXK0Q2QlRYeVF0ckJYL3oxWHBNN20yQ29xZExXQkRGZ21SVXhsMHNSWWpa?=
 =?utf-8?B?M0VrK3FZOE44UDU0WTVNS1Faa0NncXNjNGtzenB2bXQzVmpmQXIwVmxYVnZT?=
 =?utf-8?B?NFlOT0xGNjlRa1U5TG1LQzF0Q0NRZWhsVGMzNTFDTnBaNXZHRjdKTDJPV2tF?=
 =?utf-8?B?aS9kbmo0Yms3cTNzSVZ4NlhxalVXWUpZNDZBMTBsOG9Zc3VEUVRtQjQvT2NP?=
 =?utf-8?B?MXFzVnZWd0g1MGpvS2Vja1RXWVJqeWVuSWRMMW1LRzVNc2lKeGxTUnhCWUFS?=
 =?utf-8?B?NnF0VDBYaHFwdGpwTW50Qy9tTFBaNEVMcmtrOXpCUjJyOExhQ1U1YkErSllN?=
 =?utf-8?B?Nklvei9sWThGZmhHWHdHcVBzYk1nSXYvK3NObUZXcHUzZkNrSGxZY2dYSlRn?=
 =?utf-8?B?WnRvOEh3NE1zTzhKUEZncEovc1N5eUZ4dlZ2NThQeVRBeFJ4SEdWZTY1UGdv?=
 =?utf-8?B?VUw1SjhYV3UyVnRWMjlOK0dleno0WHJzRmZTRXFjdHMxSmNXUVBxTkNSaVFH?=
 =?utf-8?B?K1BHM1lsRDV4SHdtWTFmMnVMMkRIZFpuM3hyS0oxRkQ5emt5RmdGci8vZ0NH?=
 =?utf-8?B?dTc2Q0FaVTZLcmFXLzV5OUtTWVRJbFJML1RNbGVCcmtoN2xUQnhybU9rcTcy?=
 =?utf-8?B?V3RMTFJDemFIMGY1WHZhOG1uVkNtem5mZCtUNkxyYVR4amMvcVMrM3daQXBs?=
 =?utf-8?B?anRqKzRxcklGbmZSdVlTNkw2VDNCMEN1WUxjVGVVWnQrQ0NoOVhOWnE3V0xH?=
 =?utf-8?B?bjNRR2VURkRvMGpPQjBkQURtQkNBRDBRZ25Nd3drSmlwOUVzSkFqVmpjdmtk?=
 =?utf-8?B?WFM4QTdJQzFibnVEdENnTjlmWmpaWW5vcTNZaE83S2xjVis3UVpDSEh1ZkV2?=
 =?utf-8?B?WUlCQlBYS3h1NlhhMnY4ZzRjSWVlb25YNEJWR09UZW5uUkxweERYUzIyNkhv?=
 =?utf-8?Q?v/ZzGuJQl0Tj0qk4jIJueipdUY/YmuAYpJalXVg?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bad4c4-bc5e-4da3-4dce-08d8e88dec41
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 15:12:32.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tPgOKEGbUFB12+ZoUl1fwQkgI5wJdZ7RRIVeZRywWTo1ZM83yBkhZWhaiz8Tp7KC3VZ56+Ao88uqvtJdpqqoEOSndk7veR71fhjN0xGsYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2889
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/03/16 09:00, wenxu wrote:
> 
> On 3/15/2021 11:29 PM, Louis Peens wrote:
>> Hi Marcelo
>>
>> Thanks for taking time to take a look. I've replied inline - and also found
>> a bit more info, although I'm not sure if it clears things up much. I do think
>> that the main problem is the different upcall behaviour, I have not figured
>> out what to do about it yet.
>>
>> On 2021/03/13 00:06, Marcelo Leitner wrote:
>>> Hi there,
>>>
>>> On Wed, Mar 10, 2021 at 12:06:52PM +0100, Ilya Maximets wrote:
>>>> Hi, Louis.  Thanks for your report!
>>>>
>>>> Marcelo, Paul, could you, please, take a look?
>>> Thanks for the ping.
>>> +wenxu
>>>
>>>> Best regards, Ilya Maximets.
>>>>
>>>> On 3/10/21 8:51 AM, Louis Peens wrote:
>>>>> Hi all
>>>>>
>>>>> We've recently encountered an interesting situation with OVS conntrack
>>>>> when offloading to the TC datapath, and would like some feedback. Sorry
>>>>> about the longish wall of text, but I'm trying to explain the problem
>>>>> as clearly as possible. The very short summary is that there is a mismatch
>>> Details are very welcomed, thanks for them.
>>>
>>>>> in behaviour between the OVS datapath and OVS+TC datapath, and we're
>>>>> not sure how to resolve this. Here goes:
>>>>>
>>>>> We have a set of rules looking like this:
>>>>> ovs-ofctl add-flow br0 "table=0,in_port=p1,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>>> ovs-ofctl add-flow br0 "table=0,in_port=p2,ct_state=-trk,ipv6,actions=ct(table=1)"
>>>>> #post_ct flows"
>>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+new,ipv6,actions=ct(commit),output:p2"
>>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+new,ipv6,actions=ct(commit),output:p1"
>>>>> ovs-ofctl add-flow br0 "table=1,in_port=p1,ct_state=+trk+est,ipv6,actions=output:p2"
>>>>> ovs-ofctl add-flow br0 "table=1,in_port=p2,ct_state=+trk+est,ipv6,actions=output:p1"
>>>>>
>>>>> p1/p2 are the endpoints of two different veth pairs, just to keep this simple.
>>>>> The rules above work well enough with UDP/TCP traffic, however ICMPv6 packets
>>>>> (08:56:39.984375 IP6 2001:db8:0:f101::1 > ff02::1:ff00:2: ICMP6, neighbor solicitation, who has 2001:db8:0:f101::2, length 32)
>>>>> breaks this somewhat. With TC offload disabled:
>>>>>
>>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=false
>>>>>
>>>>> we get the following datapath rules:
>>>>>
>>>>> ovs-appctl dpctl/dump-flows --names
>>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:drop
>>>>> recirc_id(0),in_port(p1),ct_state(-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:172, used:1.329s, actions:ct,recirc(0x1)
>>>>>
>>>>> This part is still fine, we do not have a rule for just matching +trk, so the
>>>>> the drop rule is to be expected. The problem however is when we enable TC
>>>>> offload:
>>>>>
>>>>> ovs-vsctl --no-wait set Open_vSwitch . other_config:hw-offload=true
>>>>>
>>>>> This is the result in the datapath:
>>>>>
>>>>> ovs-appctl dpctl/dump-flows --names
>>>>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), packets:2, bytes:144, used:0.920s, actions:ct,recirc(0x1)
>>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est-trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:1, bytes:86, used:0.928s, actions:drop
>>>>> recirc_id(0x1),in_port(p1),ct_state(-new-est+trk),eth(),eth_type(0x86dd),ipv6(frag=no), packets:0, bytes:0, used:never, actions:drop
>>>>>
>>>>> Notice the installation of the two recirc rules, one with -trk and one with +trk,
>>>>> with the -trk one being the rule that handles all the next packets. Further
>>>>> investigation reveals that something like the following is happening:
>>>>>
>>>>> 1) The first packet arrives and is handled by the OVS datapath,
>>> Hmm. This shouldn't happen if hw-offload=true, because the first rule
>>> should be installed on tc datapath already. Or maybe you mean OVS
>>> vswitchd when you referred to OVS datapath?
>>>
>>> What does  dpctl/dump-flows --names -m  gives in this situation, are
>>> all flows installed on dp:tc?
>>
>> Yes, packet would be handled by vswitchd here, triggering the installation of datapath
>> flow rules. I think I may have mixed up packet handling and flow rule installation a bit.
>> These are the expanded flows:
>> ovs-appctl dpctl/dump-flows --more
>> ufid:65c93f06-9f09-4b62-b309-951c36d3d98a, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:2.080s, dp:tc, actions:ct,recirc(0x1)
>> ufid:30fd8977-0bcc-41b1-8800-1262cea71005, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
>> ufid:c176bac4-a42d-4e8b-99d9-bce386c1be4f, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
>>
>> The pre-recirc rule is in tc, but the post-recirc rules are in OVS.
>>
>>> triggering the installation of the two rules like in the non-offloaded
>>>>>     case. So the recirc_id(0) rule gets installed into tc, and recirc_id(0x1)
>>>>>     gets installed into the ovs datapath. This bit of code in the OVS module
>>>>>     makes sure that +trk is set.
>>>>>
>>>>>      /* Update 'key' based on skb->_nfct.  If 'post_ct' is true, then OVS has
>>>>>       * previously sent the packet to conntrack via the ct action.....
>>>>>       * /
>>>>>     static void ovs_ct_update_key(const struct sk_buff *skb,
>>>>>                                const struct ovs_conntrack_info *info,
>>>>>                                struct sw_flow_key *key, bool post_ct,
>>>>>                                bool keep_nat_flags)
>>>>>      {
>>>>>              ...
>>>>>              ct = nf_ct_get(skb, &ctinfo);
>>>>>              if (ct) {//tracked
>>>>>                      ...
>>>>>              } else if (post_ct) {
>>>>>                      state = OVS_CS_F_TRACKED | OVS_CS_F_INVALID;
>>>>>                      if (info)
>>>>>                              zone = &info->zone;
>>>>>              }
>>>>>              __ovs_ct_update_key(key, state, zone, ct);
>>>>>
>>>>>      }
>>>>>      Obviously this is not the case when the packet was sent to conntrack
>>>>>      via tc.
>>>>>
>>>>> 2) The second packet arrives, and now hits the rule installed in
>>>>>     TC. However, TC does not handle ICMPv6 (Neighbor Solicitation), and explicitely
>>>>>     clears the tracked bit (net/netfilter/nf_conntrack_proto_icmpv6.c):
>>>>>
>>>>>      int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
>>>>>                                    struct sk_buff *skb,
>>>>>                                    unsigned int dataoff,
>>>>>                                    const struct nf_hook_state *state)
>>>>>
>>>>>      {
>>>>>      ...
>>>>>              type = icmp6h->icmp6_type - 130;
>>>>>              if (type >= 0 && type < sizeof(noct_valid_new) &&
>>>>>                  noct_valid_new[type]) {
>>>>>                      nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
>>>>>                      return NF_ACCEPT;
>>>>>              }
>>>>>      ...
>>>>>      }
>>>>>      (The above code gets triggered a few function calls down from act_ct.c)
>>> I don't follow this part, and it seems it would affect ovs kernel
>>> dp as well. Can you please elaborate on the call chain you're focusing
>>> here?
>> The chain I was referring to is:
>> tcf_ct_act->nf_conntrack_in->nf_conntrack_handle_icmp->nf_conntrack_icmpv6_error
>> However I'm not so sure anymore that this is relevant, and yes, would probably affect
>> ovs as well.
>>>>> 3) So now the packet does not hit the +trk rule after the recirc, and leads
>>>>>     to the installation of the "recirc_id(0x1),..-trk" rule, since +trk wasn't
>>>>>     set by TC.
>>> If you meant vswitchd above, this can be the problem, yes.
>>> ovs_ct_update_key() is updating the key, and AFAICT that's reflected
>>> on the upcall. Which, then, it's fair to assume (I didn't check)
>>> vswitchd does the same.
>>>
>>> But for tc, +trk+inv is synthetsized when tc is trying to match again
>>> on this packet, when skb_flow_dissect_ct() in it will:
>>>
>>>         if (!ct) {
>>>                 key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>>>                                 TCA_FLOWER_KEY_CT_FLAGS_INVALID;
>>>                 return;
>>>         }
>>>
>>> Note that 'key' here is not part of the packet in any way. The only
>>> information that is stored within the packet, is
>>> qdisc_skb_cb(skb)->post_ct, which ovs kernel doesn't know about. So
>>> this wouldn't be reflected on an upcall, causing vswitchd to not see
>>> these flags.
>>>
>>> IOW, an upcall right after this flow:
>>> ct_state(-trk),recirc_id(0),in_port(p1),eth_type(0x86dd),ipv6(frag=no), actions:ct,recirc(0x1)
>>> can be different if it's from tc datapath or ovs kernel/vswitchd
>>> regarding these flags in this case.
>>>
>>> Makes sense? I think we're mostly on the same page on this part,
>>> actually.
>> I think this is what it boils down to in the end yes. I did do some bisecting of the kernel tree in the mean time:
>> Just before "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support" all the rules end up in
>> in dp:tc, but we have have -trk and +trk as explained. Then after the commit does look to be working as expected,
>> rules get's installed in tc, and only +trk set:
>> ovs-appctl dpctl/dump-flows --more
>> ufid:e476d5a2-3133-405c-9826-ab911c2c3240, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:ct,recirc(0x2)
>> ufid:b8369209-3069-4280-9914-820d98a3a536, skb_priority(0/0),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0x2),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.890s, dp:tc, actions:drop
>>
>> Then things go south again with this commit:
>> "1bcc51ac0731 net/sched: cls_flower: Reject invalid ct_state flags rules"
>> This is the point where the recirc rule is rejected by tc, and leads to the installation
>> of the two ovs rules as in the dump at the start of the email.
> 
> 
> I think there are some problem in the commit 1bcc51ac0731, The dp flow
> 
> with est and new in the mask, This flow will be reject by in the fl_validate_ct_state.
> 
> We will fix it.  This validate should not only based on flags in the mask.
Ah yes, that does make sense! Thanks.
> 
> 
> And in this case the dp flow does't contain inv flags?

This does NOT have +inv userspace match rules. For offload=true (on commit 1bcc51ac0731). So I think in this case the inv match is just wildcarded:
ovs-appctl dpctl/dump-flows --more
ufid:fa080783-115c-46bf-b605-2b1e8a1e9b1e, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.030s, dp:tc, actions:ct,recirc(0x1)
ufid:2a129dbc-d2a0-4f77-b7bc-2b13fd4f10dc, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
ufid:7ccc0cc9-800d-4ccc-9403-4b2c10d47da3, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop

> 
> What about the detail dp flows for tc-offload=false case?
For offload=false:
ovs-appctl dpctl/dump-flows --more
ufid:48c19d71-9e84-4b4f-b896-26c451bd5102, recirc_id(0),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00
:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:2.785s, dp:ovs, actions:ct,recirc(0x1)
ufid:427b06f5-d1c3-4c24-9ae2-01ef56b2c2a2, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:
00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:2.785s, dp:ovs, actions:drop

> 
> 
> 
>>
>> Also, not everything is good at this commit:
>> "7baf2429a1a9 net/sched: cls_flower add CT_FLAGS_INVALID flag support"
>> If I add userspace rules to also match on +inv so that it isn't wildcarded I
>> (with the ovs patches for tc +inv support removed) I get the same two-recirc-rule
>> behaviour. I do think that it matches the current theory on the upcall behaviour.
>> We will keep on digging on our side as well, this did give some more avenues
>> of thought, thanks.
>>
> You means the ovs with userspace flow +inv? And the dp flow doesn't contain the inv flags?
With these userspace rules:
ovs-ofctl dump-flows br0
 cookie=0x0, duration=104.387s, table=0, n_packets=2, n_bytes=158, ct_state=-trk,ipv6,in_port=p1 actions=ct(table=1)
 cookie=0x0, duration=104.382s, table=0, n_packets=0, n_bytes=0, ct_state=-trk,ipv6,in_port=p2 actions=ct(table=1)
 cookie=0x0, duration=104.376s, table=1, n_packets=0, n_bytes=0, ct_state=+new+trk,ipv6,in_port=p1 actions=ct(commit),output:p2
 cookie=0x0, duration=104.371s, table=1, n_packets=0, n_bytes=0, ct_state=+new+trk,ipv6,in_port=p2 actions=ct(commit),output:p1
 cookie=0x0, duration=104.366s, table=1, n_packets=0, n_bytes=0, ct_state=+est+trk,ipv6,in_port=p1 actions=output:p2
 cookie=0x0, duration=104.361s, table=1, n_packets=0, n_bytes=0, ct_state=+est+trk,ipv6,in_port=p2 actions=output:p1
# These two rules are new for this part
 cookie=0x0, duration=104.356s, table=1, n_packets=1, n_bytes=86, ct_state=+inv+trk,ipv6,in_port=p1 actions=output:p2
 cookie=0x0, duration=104.352s, table=1, n_packets=0, n_bytes=0, ct_state=+inv+trk,ipv6,in_port=p2 actions=output:p1


I get this (on commit 7baf2429a1a9), with offload=true:
ovs-appctl dpctl/dump-flows --more
ufid:f8c9546b-6bfc-46a9-b901-a44f39bfff71, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:2.160s, dp:tc, actions:ct,recirc(0x1)
ufid:45dce3af-9b92-4161-a129-20fdeab76f9f, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x33),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:drop
ufid:a1957f09-85c5-4240-a690-4eb0bbcc467a, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x30/0x33),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:0, bytes:0, used:never, dp:ovs, actions:p2
> 
> Or the flow not be hit anymore?
With offload=false it looks like this:
ovs-appctl dpctl/dump-flows --more
ufid:ea73a727-65b8-44d5-9997-b3dff3e3098a, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x30/0x33),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:
00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:1.741s, dp:ovs, actions:p2
ufid:32ceedd2-1809-41cf-a512-322093fc2135, recirc_id(0),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00
:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:1.741s, dp:ovs, actions:ct,recirc(0x1)

WITHOUT the +inv userspace rules this commit gets these two tc rules (offload=true, commit 7baf2429a1a9), which looks good:
ovs-appctl dpctl/dump-flows --more
ufid:03e76570-41ba-44a2-b4cf-15bf6890a3e6, skb_priority(0/0),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.220s, dp:tc, actions:ct,recirc(0x1)
ufid:cc469290-a485-4433-a365-18719f4d9f17, skb_priority(0/0),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),recirc_id(0x1),dp_hash(0/0),in_port(p1),packet_type(ns=0/0,id=0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:72, used:1.220s, dp:tc, actions:drop

and for completeness, the (offload=false) version of the WITHOUT +inv case, at commit 7baf2429a1a9:
ovs-appctl dpctl/dump-flows --more
ufid:5e12c343-d73b-4dec-9864-6d957a429794, recirc_id(0),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0/0x20),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:00/00
:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:1.247s, dp:ovs, actions:ct,recirc(0x1)
ufid:7ee39b78-338b-4dfa-b75d-89d42204c98d, recirc_id(0x1),dp_hash(0/0),skb_priority(0/0),in_port(p1),skb_mark(0/0),ct_state(0x20/0x23),ct_zone(0/0),ct_mark(0/0),ct_label(0/0),eth(src=00:00:00:00:00:00/00:00:00:00:00:00,dst=00:00:00:00:00:
00/00:00:00:00:00:00),eth_type(0x86dd),ipv6(src=::/::,dst=::/::,label=0/0,proto=0/0,tclass=0/0,hlimit=0/0,frag=no), packets:1, bytes:86, used:1.247s, dp:ovs, actions:drop
> 
> 
> 
> BR
> 
> wenxu
So in the end I think there are two problems - the on you identified with only checking
the mask in commit 1bcc51ac0731. And then the second bigger one is that the behaviour
differs depending on whether the recirc upcall is after the a rule installed in tc
or a rule installed in ovs, as Marcelo mentioned.

Thanks for helping to look into this

Regards
Louis
> 
> 
> 
