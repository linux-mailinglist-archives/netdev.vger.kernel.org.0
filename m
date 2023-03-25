Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4FA6C8EB9
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 15:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCYOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYOBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 10:01:21 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A350F956
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 07:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679752881; x=1711288881;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=1vqA8dMlZ5zFb95+eL0LVK9gZwTBtiIp0LR1uLxMyB8=;
  b=GeJj6S8TsWdwP/b2+e1WvnoO1hYZChnBlX9uvud8xu4EprKaYKcQSmNZ
   vP5MnVI7RgGFXn7pHbz13Eu+aLALOkB+qDIDyNq2RdJBVZrqSt80ahgib
   lqwQn3LKchFp1FMXjpahyCWUmOG1odKqMzDicaWBwOGam8GPwyh/0OEzp
   Y=;
X-IronPort-AV: E=Sophos;i="5.98,290,1673913600"; 
   d="scan'208";a="313225471"
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy message with
 format string
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2023 14:01:17 +0000
Received: from EX19D012EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id EA7F980F95;
        Sat, 25 Mar 2023 14:01:15 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D012EUA003.ant.amazon.com (10.252.50.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 25 Mar 2023 14:01:14 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sat, 25 Mar 2023 14:01:04 +0000
References: <20230320132523.3203254-1-shayagr@amazon.com>
 <20230320132523.3203254-2-shayagr@amazon.com>
 <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
 <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
 <20230322114041.71df75d1@kernel.org>
 <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
 <20230323095454.048d7130@kernel.org>
 <pj41zla6032qn4.fsf@u570694869fb251.ant.amazon.com>
 <20230323133422.110d6cab@kernel.org>
User-agent: mu4e 1.7.5; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Saeed Bshara" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Florian Westphal" <fw@strlen.de>
Date:   Sat, 25 Mar 2023 16:49:34 +0300
In-Reply-To: <20230323133422.110d6cab@kernel.org>
Message-ID: <pj41zlr0tdaq1w.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D046UWB003.ant.amazon.com (10.13.139.174) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On Thu, 23 Mar 2023 21:44:52 +0200 Shay Agroskin wrote:
>> > That's why we have the local variable called __extack, that 
>> > we
>> > *can*
>> > use multiple times, because it's a separate variable, 
>> > (extack)
>> > is
>> > evaluated only once, to initialize it...
>> >
>> > We don't need to copy the string formatting, unless I'm 
>> > missing
>> > something. Paolo was just asking for:
>>
>> There is an issue with shadowing __extack by NL_SET_ERR_MSG_FMT
>> causing the changes to __extack not to be propagated back to 
>> the
>> caller.
>> I'm not that big of an expert in C but changing __extack ->
>> _extack fixes the shadowing issue.
>>
>> Might not be the most robust solution, though it might suffice 
>> for
>> this use case.
>
> TBH the hierarchy should be the other way around, 
> NL_SET_ERR_MSG_FMT()
> should be converted to be:
>
> #define NL_SET_ERR_MSG_FMT(extack, attr, msg, args...) \
>         NL_SET_ERR_MSG_ATTR_POL_FMT(extack, NULL, NULL, msg, 
>         ##args)
>
> and that'd fix the shadowing, right?

Well ... It will but it will contradict the current order of calls 
as I see it.

NL_SET_ERR_MSG_FMT_MOD calls NL_SET_ERR_MSG_FMT which can be 
described as 'the former extends the latter'.

On the other hand NL_SET_ERR_MSG_ATTR_POL implements the message 
setting by itself and doesn't use NL_SET_ERR_MSG to set the 
message.

So it seems like we already have two approaches for macro ordering 
here and following your suggestion would create another type of 
call direction of 'the former shrinks the latter by setting to 
NULL its attributes'.
Overall given the nature of C macros and the weird issues arise by 
shadowing variables (ending up for some reason in not modifying 
the pointer at all..) I'd say I mostly prefer V7 version which 
re-implements the message setting and avoids creating such very 
hard to find issues later.

Then again I'd follow your implementation suggestion if you still 
prefer it (also I can modify the macro NL_SET_ERR_MSG to call 
NL_SET_ERR_MSG_ATTR_POL to be consistent with the other change)

Shay
