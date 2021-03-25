Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDED348BD6
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCYIq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:46:26 -0400
Received: from mail-eopbgr750058.outbound.protection.outlook.com ([40.107.75.58]:26606
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229693AbhCYIqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:46:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9XcViJsQLBgl8yv6W6r2E944+DNohVwcZP+xexCZ0Qmbg6V85/juo3AAFJybjD8PXFsMHhw5dKiXRf3F+6vgyq3MWKsT6saohCAMs6ahGwXjnywzz2v1+96zN5L60hEvPRKX583lOyJwjvf2g/w1yRRFLzp/pfZvq05JbYP9W9SwPSgkG91Gf1g1U/PdzxDv09NXttzuTuJc5T6Tz8Y2lKXZFjXBz5XgKwKFlrquAGMoXDoGUdEaJNobOA2pD8wOOgtp2OSd8Q7LNlNmyozgDD6XuyvD/WEecejzcFF2QQ3EouHhgIi8RFLvfOB/I8UZadk1MWAOzqbdaBbccX5pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJnIMHHTVfZDfo9AEvKbffUJh/naQbQAOt9ENz7Ymgg=;
 b=VRWyUGVlmCmRoReRWgeFO67/aH/I25JA6F9c4nimwwUU8oUni198W47y5MuZAUZVKkWyan+rT/QTToCGs+jeKw1pOxtThGMEtqS7SXJnUMzCdZdnmVvhaxrt65R3v1mBhTZ9RRg86VEd512e2Tlkuh/9FkJZugkrnXG9XFUYwufB5ub6Hrc0IznSekDU9g2EFBjwGgbHv94tBK1g7+dMDS734mHkWSwk9NsNCjdpqVrL3DVGWdp5Q7mvS+NJp6T6ue7AcjSr9CejUGOB1qCZUVpQ3QT8qBgoOqL9nKLiiodtURqDLDqipLq0/o0tNGQflx/PUgpAu4tMWe0r/C9NkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJnIMHHTVfZDfo9AEvKbffUJh/naQbQAOt9ENz7Ymgg=;
 b=t2yBphIbY1662BCBwtIcipg3QFg6mus1mkqhHLibqq/gUzXgZazqYRVIoTA6aFW9X4GkU/Nojd4abjZgxPVRuMBMLwbwE2Ur2AelrNE7F9bdryoC69Yr2s1oFsihOxLK42QbFCUwHJTtAJEXGTlrCYKMwk6uL6rWKY/24TzVhynfq9gAGu2zlH5XSg7gccIowdnBm4mTgvHEfG7qDef9HyO3CLh0zOexsiPlieF/9HdTTE70QLzFNHimev9aLbgTb193ONzT4723cdTLuXLgAwNqKpks8VOBSVcZuitje936nW+mEmpPdvsZE6+LeHRsRm2uGEvXCLfl0faNbDoJWQ==
Received: from DM6PR21CA0011.namprd21.prod.outlook.com (2603:10b6:5:174::21)
 by BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Thu, 25 Mar
 2021 08:46:17 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::73) by DM6PR21CA0011.outlook.office365.com
 (2603:10b6:5:174::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.1 via Frontend
 Transport; Thu, 25 Mar 2021 08:46:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 08:46:17 +0000
Received: from [172.27.13.94] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 08:46:15 +0000
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Paul Blakey" <paulb@nvidia.com>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia> <YFjdb7DveNOolSTr@horizon.localdomain>
 <20210324013810.GA5861@salvia>
 <6173dd63-7769-e4a1-f796-889802b0a898@nvidia.com>
 <YFutK3Mn+h5OWNXe@horizon.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <b89d8340-ca1c-1424-bbaa-0e85d37a84bb@nvidia.com>
Date:   Thu, 25 Mar 2021 10:46:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFutK3Mn+h5OWNXe@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59c0c36e-782f-4e6c-5023-08d8ef6a747e
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3176D5579F8CCE59FF96772AA6629@BYAPR12MB3176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BESSrntjArLBPeX7zspAkCkkWwwVsXaDvUrMuQ0yYoXNucotMEWIQdgYEHD9HiDkbTKBUJqf5i07SE05tRIXAqQMot5uT/oPcY0tsncm5EXuOXMZilYczdfXZC6V5lwJMtETUuxx+btJyyRc89dtuVzXJEVv7qDxvFblIyNVsNo2PRjiS9KAHACGJL5xpOoJsiwXI9pcEO9v9EF/8hM1z84UxhohwGzDUO7UPPJ+Be3UrhfdnbuJ9xiw5ikpDnMXNj5bhNBWSrixmGMW7dTBX+Ikydw1iNxs2VWfHKKXWYQ+b7Y77QOOjNTlQc5FhQLuRbS37hB/sk3VvcVPZT2QpKj/OFgWkv4fqQemUYIYQ0O+HOWb6Fhjc6aZe4DcDl1I8Ov7MIfeqR2K/8SYKErx1qmDhKcpI9l9VTtdXxJklz2xuyqWA7eQPRqEUzG2+7Oy2iB0fh5Sp0GJtp8nCmWjllWrx9LeW4HZLot5XjUpsUH2SOzPJ5fbCWbmHdakS82TdoCJdHdIVQk3YJPajcnFuemWY8cAMgTlB6GK1GdpWrDuzmfRaVzar3AFpZQF6IHwlIc+yGDyOTS+o2ovOQ/u3ZIZ3J+ifmlSRx/eiuhKAn4EINVhF4J7N+1ykE7i/I9xCOd4D+af89WXhcKkN3lm0WaYaDo5GgIGrs7CEYBRzHDCdaNR1b6+xlR1OzNggwOl
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(46966006)(6916009)(82310400003)(107886003)(31696002)(6666004)(86362001)(7636003)(31686004)(82740400003)(8676002)(356005)(478600001)(53546011)(4326008)(54906003)(36906005)(2906002)(8936002)(70586007)(5660300002)(70206006)(47076005)(316002)(186003)(83380400001)(336012)(2616005)(426003)(36860700001)(36756003)(26005)(16526019)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 08:46:17.1922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c0c36e-782f-4e6c-5023-08d8ef6a747e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3176
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcelo,

On 3/24/2021 11:20 PM, Marcelo Ricardo Leitner wrote:
> On Wed, Mar 24, 2021 at 01:24:53PM +0200, Oz Shlomo wrote:
>> Hi,
> 
> Hi,
> 
>>
>> On 3/24/2021 3:38 AM, Pablo Neira Ayuso wrote:
>>> Hi Marcelo,
>>>
>>> On Mon, Mar 22, 2021 at 03:09:51PM -0300, Marcelo Ricardo Leitner wrote:
>>>> On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
>>> [...]
>>>>> Or probably make the cookie unique is sufficient? The cookie refers to
>>>>> the memory address but memory can be recycled very quickly. If the
>>>>> cookie helps to catch the reorder scenario, then the conntrack id
>>>>> could be used instead of the memory address as cookie.
>>>>
>>>> Something like this, if I got the idea right, would be even better. If
>>>> the entry actually expired before it had a chance of being offloaded,
>>>> there is no point in offloading it to then just remove it.
>>>
>>> It would be interesting to explore this idea you describe. Maybe a
>>> flag can be set on stale objects, or simply remove the stale object
>>> from the offload queue. So I guess it should be possible to recover
>>> control on the list of pending requests as a batch that is passed
>>> through one single queue_work call.
>>>
>>
>> Removing stale objects is a good optimization for cases when the rate of
>> established connections is greater than the hardware offload insertion rate.
>> However, with a single workqueue design, a burst of del commands may postpone connection offload tasks.
>> Postponed offloads may cause additional packets to go through software, thus
>> creating a chain effect which may diminish the system's connection rate.
> 
> Right. I didn't intend to object to multiqueues. I'm sorry if it
> sounded that way.
> 
>>
>> Marcelo, AFAIU add/del are synchronized by design since the del is triggered by the gc thread.
>> A del workqueue item will be instantiated only after a connection is in hardware.
> 
> They were synchronized, but after this patch, not anymore AFAICT:
> 
> tcf_ct_flow_table_add()
>    flow_offload_add()
>                if (nf_flowtable_hw_offload(flow_table)) {
>                    __set_bit(NF_FLOW_HW, &flow->flags);    [A]
>                    nf_flow_offload_add(flow_table, flow);
>                             ^--- schedules on _add workqueue
> 
> then the gc thread:
> nf_flow_offload_gc_step()
>            if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
>                    set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> 
>            if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> 	                   ^-- can also set by tcf_ct_flow_table_lookup()
> 			       on fin's, by calling flow_offload_teardown()
>                    if (test_bit(NF_FLOW_HW, &flow->flags)) {
>                                      ^--- this is set in [A], even if the _add is still queued
>                            if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
>                                    nf_flow_offload_del(flow_table, flow);
> 
> nf_flow_offload_del()
>            offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
>            if (!offload)
>                    return;
> 
>            set_bit(NF_FLOW_HW_DYING, &flow->flags);
>            flow_offload_queue_work(offload);
> 
> NF_FLOW_HW_DYING only avoids a double _del here.
> 
> Maybe I'm just missing it but I'm not seeing how removals would only
> happen after the entry is actually offloaded. As in, if the add queue
> is very long, and the datapath see a FIN, seems the next gc iteration
> could try to remove it before it's actually offloaded. I think this is
> what Pablo meant on his original reply here too, then his idea on
> having add/del to work with the same queue.
> 

The work item will not be allocated if the hw offload is pending.

nf_flow_offload_work_alloc()
	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
		return NULL;

