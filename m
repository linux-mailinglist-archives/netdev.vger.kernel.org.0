Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3FC6C7153
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCWTvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWTvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:51:22 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DBC206BD
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 12:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679601082; x=1711137082;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=+QEQ3zF7qhdm3qoBr8Lu9i2WzsfaYRyNmXnPryqBZ90=;
  b=U+wpEvsNfzDY2po0JKXw3Kj1snltCV7AeJCcdVSHXrut+MZlUUCrbS/j
   9eo/C7XVXDhMRFjIJtnW7ONi1VbtMLt6L2R5BgRGEkBpaqcUAcBJ6iVgd
   8oL/OsL7ndaqqXBriR86YbUFYPY+uODHLgSVVwU5QnSlws0YEXXtH6J+I
   A=;
X-IronPort-AV: E=Sophos;i="5.98,285,1673913600"; 
   d="scan'208";a="271916921"
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy message with
 format string
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 19:51:15 +0000
Received: from EX19D013EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com (Postfix) with ESMTPS id B7883871DE;
        Thu, 23 Mar 2023 19:51:11 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D013EUA003.ant.amazon.com (10.252.50.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 23 Mar 2023 19:51:10 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 23 Mar 2023 19:51:00 +0000
References: <20230320132523.3203254-1-shayagr@amazon.com>
 <20230320132523.3203254-2-shayagr@amazon.com>
 <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
 <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
 <20230322114041.71df75d1@kernel.org>
 <pj41zlmt432zea.fsf@u570694869fb251.ant.amazon.com>
 <20230323095454.048d7130@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
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
Date:   Thu, 23 Mar 2023 21:44:52 +0200
In-Reply-To: <20230323095454.048d7130@kernel.org>
Message-ID: <pj41zla6032qn4.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
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
> On Thu, 23 Mar 2023 18:38:59 +0200 Shay Agroskin wrote:
>> Couldn't find a way to avoid both code duplication and 
>> evaluating
>> extact only once \= Submitted a new patchset with the modified
>> version of this macro.
>
> That's why we have the local variable called __extack, that we 
> *can*
> use multiple times, because it's a separate variable, (extack) 
> is
> evaluated only once, to initialize it...
>
> We don't need to copy the string formatting, unless I'm missing
> something. Paolo was just asking for:

There is an issue with shadowing __extack by NL_SET_ERR_MSG_FMT 
causing the changes to __extack not to be propagated back to the 
caller.
I'm not that big of an expert in C but changing __extack -> 
_extack fixes the shadowing issue.

Might not be the most robust solution, though it might suffice for 
this use case.

>
> -       NL_SET_ERR_MSG_FMT(extack, fmt, ##args);
> +       NL_SET_ERR_MSG_FMT(__extack, fmt, ##args);
>
> that's it.

