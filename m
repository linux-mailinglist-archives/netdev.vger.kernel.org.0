Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6057221EF2D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGNLXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:23:07 -0400
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:27342
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgGNLXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 07:23:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eknp3Q3MG/X38SJncIRFmiF5++5NBMvc8I9+Zbkeeob6v6D5B+AkkaYbN2V/XMDgTqD+5CiOTeeXgx6bLrcZWDkp2rrpMpmmlYP+2U3K298VI90KBnYmBL42pa+7TNfi4ieQH6s/wOzzBRNm2r9l47nAY5HL4cW1fZ/Jvm5XXhxJMNHxkloNmJcIpz6Fy6BfrduW6USnD3RNWo2q/1Ox70OZy1ESZMoYVKV++W+1Pk21O0waEVBTT/N/S8KS3ml4+NbGx6AEoWFJo5oc0TS96+jyLnLVYGoHreJ+iNbmZ8A4jDnr766ZPN46SlnZHdrorDn4q1nXYsfmhGgtnBPcJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSeeGuCCiCfBa3dn2izsCsnOQ1Q6fQJj58ortI98Qlg=;
 b=nDzyBqNj+D0I8nZE1TeFGWqUPbMyiooiTUVsefSsGBu8sDN5kgMrrVFvzzwhUkJ3TkmR4vkKgP6zG7bOiLesVWfDB8ftyRQPhvfXoi3wQD4pL2edd7ogkw0Dzqy+Lf005FYiSVgWcG1NlrxNkQfv+HDeJWFbcZb50npyROvdNV74YDeGcVflE67QAKKy7Si++kXun9yUQ2LTrfRtxR6xMRIk/N49/4XnpqGqzvtAbOOfSpEc+vpff08spOnJI1klAwkXuNq3PueDl+gtiAfeeg9H5EKHfPQb418VDeYuMQip2+EL7e8VX7BYUQHrEHupjxLQJDcd21HN51nf00uGeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSeeGuCCiCfBa3dn2izsCsnOQ1Q6fQJj58ortI98Qlg=;
 b=F5aYeJyXkeymD3wcnoYyDui6qEP9gu1TMfA5wFTblGkAwSE1vM7E++tRm5uQu14T57LNE+/Ov52HD7ytDD7kBep8TfR/feeC7L8jn/vRqwRQc7B2A4Tzix5hWvcpmhNR8ORbRzMVJSqNFMrOu7oinD6QdgDiyuKl8znOCIzw62k=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB6583.eurprd05.prod.outlook.com (2603:10a6:20b:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 14 Jul
 2020 11:22:55 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 11:22:55 +0000
Subject: Re: [RFC PATCH] sch_htb: Hierarchical QoS hardware offload
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Dave Taht <dave.taht@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
References: <20200626104610.21185-1-maximmi@mellanox.com>
 <CAM_iQpUSY2Oxy2umgM5-DwMg9Y9UXX-Gkf=O4StPJFVz-N7PzA@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <8b48f489-8646-91d3-fa1b-fe115c4979d4@mellanox.com>
Date:   Tue, 14 Jul 2020 14:22:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAM_iQpUSY2Oxy2umgM5-DwMg9Y9UXX-Gkf=O4StPJFVz-N7PzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0006.eurprd07.prod.outlook.com
 (2603:10a6:205:1::19) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM4PR07CA0006.eurprd07.prod.outlook.com (2603:10a6:205:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.10 via Frontend Transport; Tue, 14 Jul 2020 11:22:54 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 83f21a35-c745-40fb-571d-08d827e84132
X-MS-TrafficTypeDiagnostic: AM6PR05MB6583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6583E686EBD11321AF8009EAD1610@AM6PR05MB6583.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHNbzV/2ITo7qpAnokcmjCc9zAtPQxRr5wsuyZWCFT5viE8YQFRVQFmjNlh7ejIsk28vf/bwQzHr95LgsR03fYpMCTjWjp5qo16aQ6r6u8TQw9eQE93DECCJH/hW1JXdJCyZSGHHXIbVOssgQKBEMfZwWGBYdt0jxJd/ipmH1j2+oRY8+A6NG9JzrcqFNbjiTXC6DKb90saySTRVgsxvvk+sM9unokZchV6X22RVZ+yczTRXZjRglzCThzP8DKHApVcDMTeM4sZdxHE7pVIlML8TTyQsOWca+ro75b8LJKHyScfN+7Rnp0Z95Kaj2hc44Fu51wDDWPPFYQT9S9MIdNrKMasC9iw1+BBj4Dv1gri2TmF6iHr2XiDPpsRMJVeI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(956004)(316002)(6486002)(36756003)(54906003)(16526019)(5660300002)(107886003)(16576012)(52116002)(55236004)(186003)(83380400001)(4326008)(53546011)(478600001)(66946007)(31696002)(8936002)(6916009)(86362001)(31686004)(66476007)(66556008)(2906002)(2616005)(8676002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tkDh1W7oMqOYQfXwMWL7etCJgpbzlbRTHrKxusGZOqGalex7k3GqS1vcKTBYpDBxRHV8xnk1NBc2n7D+/9Aa0c6ItTfry6lp0x3u+MaK6VQ16IFCOv6MRP28RSEyUmDhj2SrG8VsM1s5uaGyYQXGGSbVsycpNCF8QapM+/VWgIkpdDcnR7iPaKv0vVucEkloCPzkRZBH2poXYYNrUyH8w7zYyqSGCR8z7haNXl04PMl6di4aBbCP5tHww6rVHaPWlJ8999HtCWbt7Y5VeqFgpm4k0V1szcU1w9ymAenl5AI+dhJ1W+aPjk3R9ognSvAaTJqQIvNgw3nV/ZAOPAZRWdFj34Ys96gO/q4ptfS5Z76Cvl8zygZ1TcBE1wfLCZ2G7BQn0v+bwTMqss8Gl2XHV+MUTzvh3PpZfbT/QWPARpnDAsGmtp1QeH3hIGILpa+MPI9JxK/ZzyW8th3KWIgKbTbVy5UnR0sQgixc2N3UJMGf89Cg1WjGSIqs+5n8xV3+
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f21a35-c745-40fb-571d-08d827e84132
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 11:22:55.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDqHaGw5in4lmi83ajmc9JcJe2BmWrlk/T49Q/bkAAfZnShISmk38oFw7hduxhS1B7TlAHp7dDW+bC5b+WFvLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6583
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-08 09:44, Cong Wang wrote:
> On Fri, Jun 26, 2020 at 3:46 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>
>> HTB doesn't scale well because of contention on a single lock, and it
>> also consumes CPU. Mellanox hardware supports hierarchical rate limiting
>> that can be leveraged by offloading the functionality of HTB.
> 
> True, essentially because it has to enforce a global rate limit with
> link sharing.
> 
> There is a proposal of adding a new lockless shaping qdisc, which
> you can find in netdev list.

Thanks for pointing out! It's sch_ltb (lockless token bucket), right? I 
see it's very recent. I'll certainly have to dig deeper to understand 
all the details, but as I got, LTB still has a bottleneck of a single 
queue ("drain queue") processed by a single thread, but what makes a 
difference is that enqueue and dequeue are cheap, all algorithm 
processing is taken out of these functions, and they work on per-CPU queues.

>>
>> Our solution addresses two problems of HTB:
>>
>> 1. Contention by flow classification. Currently the filters are attached
>> to the HTB instance as follows:
>>
>>      # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
>>      classid 1:10
>>
>> It's possible to move classification to clsact egress hook, which is
>> thread-safe and lock-free:
>>
>>      # tc filter add dev eth0 egress protocol ip flower dst_port 80
>>      action skbedit priority 1:10
>>
>> This way classification still happens in software, but the lock
>> contention is eliminated, and it happens before selecting the TX queue,
>> allowing the driver to translate the class to the corresponding hardware
>> queue.
>>
>> Note that this is already compatible with non-offloaded HTB and doesn't
>> require changes to the kernel nor iproute2.
>>
>> 2. Contention by handling packets. HTB is not multi-queue, it attaches
>> to a whole net device, and handling of all packets takes the same lock.
>> Our solution offloads the logic of HTB to the hardware and registers HTB
>> as a multi-queue qdisc, similarly to how mq qdisc does, i.e. HTB is
>> attached to the netdev, and each queue has its own qdisc. The control
>> flow is performed by HTB, it replicates the hierarchy of classes in
>> hardware by calling callbacks of the driver. Leaf classes are presented
>> by hardware queues. The data path works as follows: a packet is
>> classified by clsact, the driver selectes the hardware queue according
>> to its class, and the packet is enqueued into this queue's qdisc.
> 
> Are you sure the HTB algorithm could still work even after you
> kinda make each HTB class separated? I think they must still share
> something when they borrow bandwidth from each other. This is why I
> doubt you can simply add a ->attach() without touching the core
> algorithm.

The core algorithm is offloaded to the hardware, the NIC does all the 
shaping, so all we need to do on the kernel side is put packets into the 
correct hardware queues.

I think offloading the algorithm processing could give an extra benefit 
over the purely software implementation of LTB, but that is something I 
need to explore (e.g., is it realistic to reach the drain queue 
bottleneck with LTB; how much CPU usage can be saved with HTB offload).

Thank you for your feedback!

> Thanks.
> 

