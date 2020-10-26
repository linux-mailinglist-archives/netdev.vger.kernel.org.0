Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40BB299437
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788350AbgJZRqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:46:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6406 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1788225AbgJZRqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 13:46:43 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f970b870000>; Mon, 26 Oct 2020 10:46:47 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 17:46:33 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com> <ygnh8sc03s9u.fsf@nvidia.com> <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com> <ygnh4kml9kh3.fsf@nvidia.com> <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com> <ygnh7drdz0nf.fsf@nvidia.com> <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vlad@buslov.dev>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com>
Date:   Mon, 26 Oct 2020 19:46:30 +0200
Message-ID: <ygnhwnzc6ft5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603734407; bh=sF/ZEGVzJ6GJovhtYRNTKWOsniff6GBwDJu2O83kAuU=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=ZYEcFh68wHTZ1EJxMyCKznkBFePeYFR9OJObN2FOJg4Ut4vOaFMpaLPA+cztZyWwr
         GIC7+ZBUUHWgEeZ3V3vJQoWr9gwWyZyEztj00q6N419mgdARxmTAxJsJ41xuXsAd2l
         9nYvFi/cIIgCPCN1MeEKkIX6626IvPRQRpa6mAPgO4GQl5tyinJZdisCc1GpaL7hGw
         M0nEcds7hzDw7zJDVtTddkcncPRkVs6wbXI36ei5ylIuWaQuj04Hdymr39Z4Why5nv
         dN09lCkDCZSbd6GJlOPaZyLN/GH0Nn0UPdoyxSaloYcaiRrUfrfbp58RLliUgU5yvN
         6ejlz/O/DEFXA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 26 Oct 2020 at 19:12, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-26 7:28 a.m., Vlad Buslov wrote:
>>
>> On Sat 24 Oct 2020 at 20:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> [..]
>>>>
>>>> Yes, that makes sense. I guess introducing something like 'tc action -br
>>>> ls ..' mode implemented by means of existing terse flag + new 'also
>>>> output action index' flag would achieve that goal.
>>>>
>>>
>>> Right. There should be no interest in the cookie here at all. Maybe
>>> it could be optional with a flag indication.
>>> Have time to cook a patch? I'll taste/test it.
>>
>> Patch to make cookie in filter terse dump optional? That would break
>> existing terse dump users that rely on it (OVS).
>
> Meant patch for 'tc action -br ls'
>
> Which by default would not include the cookie.

So action-dump-specific flag that causes act api to output action index
(via new attribute) and skips cookie?

>
> cheers,
> jamal

