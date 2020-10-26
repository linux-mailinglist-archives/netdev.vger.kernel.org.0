Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18042994CB
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788996AbgJZSEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:04:11 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8075 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783317AbgJZSEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 14:04:08 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f970f830002>; Mon, 26 Oct 2020 11:03:47 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 18:04:00 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com> <ygnh8sc03s9u.fsf@nvidia.com> <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com> <ygnh4kml9kh3.fsf@nvidia.com> <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com> <ygnh7drdz0nf.fsf@nvidia.com> <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com> <ygnhwnzc6ft5.fsf@nvidia.com> <940495a7-d828-7439-a9c3-1e3bde6b02fb@mojatatu.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vlad@buslov.dev>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <940495a7-d828-7439-a9c3-1e3bde6b02fb@mojatatu.com>
Date:   Mon, 26 Oct 2020 20:03:57 +0200
Message-ID: <ygnhtuug6f02.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603735427; bh=ctSrWAQ0NY1TKhOSQc9gzDDrc0qvh1C3C99PiGGdXrU=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=nuycKJBAdQeQnXNYiX1op/9vxMC0tJTLSg5mqAmrEQSQThKM5g6r9GEwUXLYFVZLI
         9wQ11u4FN0NFHcQmsahZvDOENKIvObqERHiLnhceO9DtLR/MaHI3qtz6moiyiXppOh
         TJncjHJ0p6v27dQ2h2t0nAQXI8JKBZuBXgmL/QfGo97myJsPEvxpuc3WWSNYCNjZT4
         Q4jCSkDhrjtvWIuM1yvSsyDZeVSWJU1AyQw91UdLqPx9HdZKHYtZQLPraZDKeut+hs
         KhxImKqHEc+sA8CMXnSyB/jogs4GEHLNIeJBWbZWYC5Y7NxkolD07YhxgO/fFPu6hJ
         eHDSLh3cMcIxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 26 Oct 2020 at 20:01, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-26 1:46 p.m., Vlad Buslov wrote:
>>
>> On Mon 26 Oct 2020 at 19:12, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2020-10-26 7:28 a.m., Vlad Buslov wrote:
>>>>
>>>> On Sat 24 Oct 2020 at 20:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>
>>> [..]
>>>>>>
>>>>>> Yes, that makes sense. I guess introducing something like 'tc action -br
>>>>>> ls ..' mode implemented by means of existing terse flag + new 'also
>>>>>> output action index' flag would achieve that goal.
>>>>>>
>>>>>
>>>>> Right. There should be no interest in the cookie here at all. Maybe
>>>>> it could be optional with a flag indication.
>>>>> Have time to cook a patch? I'll taste/test it.
>>>>
>>>> Patch to make cookie in filter terse dump optional? That would break
>>>> existing terse dump users that rely on it (OVS).
>>>
>>> Meant patch for 'tc action -br ls'
>>>
>>> Which by default would not include the cookie.
>>
>> So action-dump-specific flag that causes act api to output action index
>> (via new attribute) and skips cookie?
>>
>
> yeah, something like TCA_ACT_FLAGS_TERSE.
>
> new tcf_action_dump_terse() takes one more field which says to
> include or not the cookies since that is shared code and filters
> can always include it.
> The action index is already present in the passed tc_action
> struct just needs a new TLV.

Sure, I'll try to find time this week.

