Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7E138DB6
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgAMJZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:25:36 -0500
Received: from fd.dlink.ru ([178.170.168.18]:51294 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAMJZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 04:25:35 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 78C221B20EA4; Mon, 13 Jan 2020 12:25:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 78C221B20EA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1578907533; bh=2f/Y/GZU1BlOm+comjchqo4T/ukgrbsudCbLlFnoBlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ZAZKwYzGdwf5pLnqjfjSeZ4YvIe565n63YwJVIAem4xbd2z8u2oj1vxtaNhKkihkr
         Bxr4cOtZihdLMngmmTI1naX6NwU0RCHReWyMadzjPvxy45lByAxTOc70NudjGsijdx
         svrKCxNgWM+cSkIxkFyYCMUalioJ3HfhMLTtZmPs=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id B5EDE1B201FA;
        Mon, 13 Jan 2020 12:25:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru B5EDE1B201FA
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 5075A1B20320;
        Mon, 13 Jan 2020 12:25:20 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 13 Jan 2020 12:25:20 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 13 Jan 2020 12:25:20 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC net-next 00/20] net: dsa: add GRO support
In-Reply-To: <20191230171216.GC13569@lunn.ch>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230171216.GC13569@lunn.ch>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <e98ab4764c8a0a90c18bfd49305310fe@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn wrote 30.12.2019 20:12:
>> I mark this as RFC, and there are the key questions for maintainers,
>> developers, users etc.:
>> - Do we need GRO support for DSA at all?
> 
>> - Does this series bring any performance improvements on the
>>   affected systems?
> 
> Hi Alexander

Hi,

> I think these are the two most important questions. Did you do any
> performance testing for the hardware you have?

Exactly, this are the top questions. I performed lots of tests on
hardware with which I'm working on and had a pretty good boosts
(I didn't mainlined my drivers yet unfortunately).
But this does not mean that GRO would be that nice for all kind of
devices *at all*. That's why I would like to see more test results
on different systems.

> I personally don't have any of the switches you have made
> modifications to, so i cannot test these patches. I might be able to
> add GRO to DSA and EDSA, where i can do some performance testing.
> 
>     Andrew

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
