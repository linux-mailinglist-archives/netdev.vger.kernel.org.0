Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549AF214E28
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 19:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgGER0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 13:26:55 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:20035
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbgGER0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 13:26:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ean+FsO/T1Q7Qo53GjuaCreeqMJshiqmHZKQ/Szd54q2OG0lQvOL5M14tIVF6qQc5WmS9v4aVW6DayhRKzyDjTyIDCOJzGNt4CT9qJC4YH4kxsCIwMKIAtA1vVKO0J32zESRH8qhc7CA+G/Lhe733vE7mOVb8cQ0mtHeg6hcR4FosqxzxtFrEO171nrDH70CLxblU+qbpAFYjsaEMeYooskfsJQNbAP3Ar/rMlmHDgXFYtc9eaxpSAdeXXqgx+vKnJdFnf5w1AmluQdNrTiZPHvzyz/5PS8tzIPqL0NoYYAYRJFTWAHo2r4U9lDTLzPIqUcXZhZDQpPVPUs0UhnMEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmXt3gOfwkvnAboxKqHL05183xQ2QKtq31lFMmaKX78=;
 b=htKDrFRTR6ukEN2oPedgNbj0232tYB4PCOBMngZQb6fNsTWO45b5ZWjN8S7ZSp4p2IZhFVSSTTG1MexvSWJIrZ6mPlvGiM/qq1vP7XEnmV+gY4b86VQGmLgsMEYaerFyFffL97RNJ6z9NO9NE9vO1LrR3lsxBRXuoZMAS+Zkyy3qUFzq+O3PuRVBm+8vT4l/yScKzdaLHd6P9waNoeLXvnjvhur0xPeZNIT9Vk1A8cIZXUzGxqVgyD1teH6vtxf39N0JFmB88ckV8Zf6ViguUD8/gA3MdIcpFexfO/wNg1vT0jbk23jdGJkxDAc1kRp3g5W8IbXu1QvJCJRhj/XVYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmXt3gOfwkvnAboxKqHL05183xQ2QKtq31lFMmaKX78=;
 b=rur+9INfVVjaeGpW8zawWvxjEOfcJfMJEK+wWDSAUEBEbkD0oRGfjDox+7dNle1DwBsKlWUtXk+VTR0uH6+VKu/Wvb+/fH/mNXjHLNerHbFW4huHOCnvqCe/X8aA0zCDHu651U4ThSDfKDDTlLF9tY9AsB34szdGligsygCqnhc=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB8PR05MB5914.eurprd05.prod.outlook.com (2603:10a6:10:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sun, 5 Jul
 2020 17:26:50 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 17:26:49 +0000
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, jiri@mellanox.com, kuba@kernel.org,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
From:   Ariel Levkovich <lariel@mellanox.com>
Message-ID: <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
Date:   Sun, 5 Jul 2020 13:26:35 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR05CA0123.eurprd05.prod.outlook.com
 (2603:10a6:207:2::25) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:956b:acd1:f5c6:f6b3) by AM3PR05CA0123.eurprd05.prod.outlook.com (2603:10a6:207:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Sun, 5 Jul 2020 17:26:48 +0000
X-Originating-IP: [2604:2000:1342:c20:956b:acd1:f5c6:f6b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35134015-f455-4c3d-6490-08d82108999d
X-MS-TrafficTypeDiagnostic: DB8PR05MB5914:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR05MB5914A1BB7CFD4C43A5355314BA680@DB8PR05MB5914.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7BW5wxB/QLZGd45AL1jfVrt3MMZK92OK5AgB2eV6n7/S/f5XOGtE4RzCVa+dBxwklY8Vmq3Ncs8WQCDRUYunDKRxinueShoouYm4XT8bUbdwOZQhixOOsHqSQKomu6XLspQWSVKYdTNhbsUkzVCJ/xZPcxOF2BBIoEL/LCR/qbPvjHQlA6NE/0w0mU7oEm8dW5nHm/LJ7xM2pQT0SLyeOwJ1I8jDSHaqbMSetX6tv86iSEqb5qgzJw4GUijKh3godIKvKngS+2rRdY5c8V8bWx+gE6gh/B8SlhUzG9pvK9BnQV01OCm6gTLlHpnNvWJlaxNU9wkrrxgRjbOv3/1v9z5ih7LYbtdx4+MnZ0zOWz33NuZXbjUh3j/3sAgnNYc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(52116002)(16526019)(8936002)(478600001)(186003)(6512007)(31686004)(53546011)(6506007)(86362001)(6666004)(6486002)(5660300002)(2906002)(83380400001)(36756003)(8676002)(316002)(31696002)(66946007)(66476007)(66556008)(4326008)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2m06JM+7NcIJHiu3BRXvinyGMhmihtrziv70gHVInFX5XySYsTZyMpRVfTWpdL5hE/Lg7n57zMgviZuRJm016amtz0SZ3fEISLGydXSsPHAmIQ0mlbh5PN5CIR8e7j+MTYlyJmNC4V3x2gDvY8gGA7DCDYF+6adipvEwXNUUeF5oC6Y2d/gy5fTv16B7S/+bZOkS+F7JnE1iTwaTInxTc2EfWiXaV5uD+pILhQO+a2bHmFnDMylCn3dPPIk8mCNYGGni3l3IgKzCaKW3GHj+Q6mg/rLFkjsP0Zxe7JZ1QXRn1h3FJ27q+rfXwjb1IS+DzDf0g0z6Gk6vt3VCPS2fJPTPrlz6zEanSYPi4w8as8NpHonteBiinlSxYrjS56yvl58xuD/XwhXxwPbbbPj3HNYFnc70nIUwSi7qsxhBE4Ysn+sRNpBacdALzDm3TwMO+sSjFBmmmF2yZ4D6vvbZ8beTTQPWT7HfPDrihQwuj/M2/vpbMHlQdsUWCIATfN64z51axnlSA2aeUzj8785jKuPmU3ndTom40gAbsNctNuy9wSxYEB14daCnY/wTRq79
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35134015-f455-4c3d-6490-08d82108999d
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 17:26:49.6087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VIJl5jJM5O5J4YtNhSUSmdBmxTL7KSGQ0BOq8xq9l+Ml225D+CHyQmlgJK3BPWQUpm++jYl46YJC7AzBwUcRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5914
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/3/20 7:22 AM, Jamal Hadi Salim wrote:
> Hi,
>
> Several comments:
> 1) I agree with previous comments that you should
> look at incorporating this into skbedit.
> Unless incorporating into skbedit introduces huge
> complexity, IMO it belongs there.

Hi Jamal,

I agree that using skbedit makes some sense and can provide the same 
functionality.

However I believe that from a concept point of view, using it is wrong.

In my honest opinion, the concept here is to perform some calculation on 
the packet itself and its headers while the skb->hash field

is the storage location of the calculation result (in SW).

Furthermore, looking forward to HW offload support, the HW devices will 
be offloading the hash calculation and

not rewriting skb metadata fields. Therefore the action should be the 
hash, not skbedit.

Another thing that I can mention, which is kind of related to what I 
wrote above, is that for all existing skbedit supported fields,

user typically provides a desired value of his choosing to set to a skb 
metadata field.

Here, the value is unknown and probably not a real concern to the user.


To sum it up, I look at this as performing some operation on the packet 
rather then just

setting an skb metadata field and therefore it requires an explicit, new 
action.


What do you think?


>
> 2) I think it would make sense to create a skb hash classifier
> instead of tying this entirely to flower i.e i should not
> have to change u32 just so i can support hash classification.
> So policy would be something of the sort:
>
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto tcp \
> action skbedit hash bpf object-file <file> \
> action goto chain 2
>
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> handle 0x0 skbhash  flowid 1:11 mask 0xf  \
> action mirred egress redirect dev ens1f0_1
>
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> handle 0x1 skbhash  flowid 1:11 mask 0xf  \
> action mirred egress redirect dev ens1f0_2
>
> IOW, we maintain current modularity as opposed
> to dumping everything into flower.
> Ive always wanted to write the skbhash classifier but
> time was scarce. At one point i had some experiment
> where I would copy skb hash into mark in the driver
> and use fw classifier for further processing.
> It was ugly.

I agree but perhaps we should make it a separate effort and not block 
this one.

I still think we should have support via flower. This is the HW offload 
path eventually.


Regards,

Ariel


> cheers,
> jamal
>
> On 2020-07-01 2:47 p.m., Ariel Levkovich wrote:
>> Supporting datapath hash allows user to set up rules that provide
>> load balancing of traffic across multiple vports and for ECMP path
>> selection while keeping the number of rule at minimum.
>>
>> Instead of matching on exact flow spec, which requires a rule per
>> flow, user can define rules based on hashing on the packet headers
>> and distribute the flows to different buckets. The number of rules
>> in this case will be constant and equal to the number of buckets.
>>
>> The datapath hash functionality is achieved in two steps -
>> performing the hash action and then matching on the result, as
>> part of the packet's classification.
>>
>> The api allows user to define a filter with a tc hash action
>> where the hash function can be standard asymetric hashing that Linux
>> offers or alternatively user can provide a bpf program that
>> performs hash calculation on a packet.
>>
>> Usage is as follows:
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto tcp \
>> action hash bpf object-file <file> \
>> action goto chain 2
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto udp \
>> action hash bpf asym_l4 basis <basis> \
>> action goto chain 2
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> flower hash 0x0/0xf  \
>> action mirred egress redirect dev ens1f0_1
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> flower hash 0x1/0xf  \
>> action mirred egress redirect dev ens1f0_2
>>
>> Ariel Levkovich (3):
>>    net/sched: Introduce action hash
>>    net/flow_dissector: add packet hash dissection
>>    net/sched: cls_flower: Add hash info to flow classification
>>
>>   include/linux/skbuff.h              |   4 +
>>   include/net/act_api.h               |   2 +
>>   include/net/flow_dissector.h        |   9 +
>>   include/net/tc_act/tc_hash.h        |  22 ++
>>   include/uapi/linux/pkt_cls.h        |   4 +
>>   include/uapi/linux/tc_act/tc_hash.h |  32 +++
>>   net/core/flow_dissector.c           |  17 ++
>>   net/sched/Kconfig                   |  11 +
>>   net/sched/Makefile                  |   1 +
>>   net/sched/act_hash.c                | 389 ++++++++++++++++++++++++++++
>>   net/sched/cls_api.c                 |   1 +
>>   net/sched/cls_flower.c              |  16 ++
>>   12 files changed, 508 insertions(+)
>>   create mode 100644 include/net/tc_act/tc_hash.h
>>   create mode 100644 include/uapi/linux/tc_act/tc_hash.h
>>   create mode 100644 net/sched/act_hash.c
>>
>
