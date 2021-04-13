Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8ADA35E1B8
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhDMOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhDMOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:40:48 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041E3C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:40:29 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z13so10705025lfd.9
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=B0Ze6zSePn8dZkD37LVudsQ716aTcli/ZveubzeD3u8=;
        b=wGLMN6M+fpgYXDaOgMvbsV9YQT3c5dH36ePoA+A+QDzVbBDzGRc6wzf0IuOncaS9aR
         Yl5krVByvJzPZVDcuYfoQgXN267xiPHiBM1eD8a9mSXfwu4HsCmwAU0V+lmINpmkuSst
         3yuK7+gtaatssmw+xAWp2t9Yji/t/BZd1KTTvNDtuNScx9NnXFl/Vwdvl04pPqApfrjA
         TOzSbifIu98RMKZjKWBSTThTTw1Va1/MNsSC8rxUHskOvQffoC22m0S00vga0QcLxh4k
         bVQRwwj4xllY6QWFfJ5HN7zSRsX7Z/ul8pBewtivFYMrniAT0BOg4K1Yiv69tw3hNhM+
         bdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=B0Ze6zSePn8dZkD37LVudsQ716aTcli/ZveubzeD3u8=;
        b=hPL1R3mT3ldFwrFDFdRtND5Ap6FtOXL+knuxi+jCXtMPNTz0QQJ0uKqqI7/YKzFJWh
         yyCR+16AizmeqrupeGyTISD5O6Z74ZvTzANMFHb8go6yFl8Hk3IUNs5XFCJIwa1lt8Vh
         5JPO8/LzTDDxstA39o6eDHl6qvDin1eETPvDqTY1i+1+2Rj92HuzjxjozWF0Qcog2lBS
         IIyRUQ5aZMeuj6l6NV/fpolJVvkUi1exyfA+iStJ38fXUldbY+jI3DKCRY8u6UsxQtrg
         pfezkSazgfg52Rp5mwlvH0SxaAeYQiXwKRy5OJobXUhd9y9TtKwegZHNS6wvb2U8MRby
         wj2w==
X-Gm-Message-State: AOAM531WTHyWSY2d2zbRys0s3NPbCrqARhtK/Y7YqpRGMsRuYollCGEP
        03/fSu3f3Kix0eogv1Bs037qjA==
X-Google-Smtp-Source: ABdhPJyyfHteWuNMJ9zxIqN3kTx27GAhgDzcIq80qon/4QXIUL/AtXJmAyix9ycyk0A0nt57CAK53w==
X-Received: by 2002:a05:6512:b9e:: with SMTP id b30mr8084353lfv.278.1618324827516;
        Tue, 13 Apr 2021 07:40:27 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q28sm3403883lfo.95.2021.04.13.07.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:40:26 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
In-Reply-To: <20210413015450.1ae597da@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412235054.73754df9@thinkpad> <87wnt7jgzk.fsf@waldekranz.com> <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com> <87o8ejjdu6.fsf@waldekranz.com> <20210413015450.1ae597da@thinkpad>
Date:   Tue, 13 Apr 2021 16:40:25 +0200
Message-ID: <87lf9mjlie.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 01:54, Marek Behun <marek.behun@nic.cz> wrote:
> On Tue, 13 Apr 2021 01:13:53 +0200
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
>> > ...you could get the isolation in place. But you will still lookup the
>> > DA in the ATU, and there you will find a destination of either cpu0 or
>> > cpu1. So for one of the ports, the destination will be outside of its
>> > port based VLAN. Once the vectors are ANDed together, it is left with no
>> > valid port to egress through, and the packet is dropped.
>> >  
>> >> Am I wrong? I confess that I did not understand this into the most fine
>> >> details, so it is entirely possible that I am missing something
>> >> important and am completely wrong. Maybe this cannot be done.  
>> >
>> > I really doubt that it can be done. Not in any robust way at
>> > least. Happy to be proven wrong though! :)  
>> 
>> I think I figured out why it "works" for you. Since the CPU address is
>> never added to the ATU, traffic for it is treated as unknown. Thanks to
>> that, it flooded and the isolation brings it together. As soon as
>> mv88e6xxx starts making use of Vladimirs offloading of host addresses
>> though, I suspect this will fall apart.
>
> Hmm :( This is bad news. I would really like to make it balance via
> input ports. The LAG balancing for this usecase is simply unacceptable,
> since the switch puts so little information into the hash function.

If you have the ports in standalone mode, you could imagine having each
port use its own FID. But then you cannot to L2 forwarding between the
LAN ports in hardware.

If you have a chip with a TCAM, you could theoretically use that to get
policy switching to the preferred CPU port. But since that would likely
run on top of TC flower or something, it is not obvious to my how to
would describe that kind of action.

Barring something like that, I think you will have to accept the
unacceptable :)

> I will look into this, maybe ask some follow-up questions.
>
> Marek
