Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1C261B2F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbgIHS7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731392AbgIHS7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:59:06 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF773C061573;
        Tue,  8 Sep 2020 11:59:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t7so73532pjd.3;
        Tue, 08 Sep 2020 11:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=zedEPQGTgVh6pwqDk0aWi8hxMzGKzWUmqBIMlLqZOG4=;
        b=l7MXgcIZjI4C9SmbVSd/BmycyCfbx5QonD/hyX8DJ8mlPQDUcmyRlizQIDEWPyF24j
         z4GnRnkEk3Jaq+9jBALEya6feS/8AFJMDxUOcZDH9Z2JGGMQZD/zGwm6uqHRwgr7nzn1
         GwOlTyNr7X5LWNckKX9/kQL7ufTKJHCVXeCVuskSq3yWqLmYVzG4kuKhNfq/DRMl+faQ
         RXAip3TFE4JsLMJ4OnvHWIFxZwMpkeniLy0TCkM3HV9mFyWfpGihCIc9Q30v1RbzTQGx
         IFoezPYHOGKn9vOksTejlgv7i1fDBKSD5n3uuZncfcy3eyDtnfx9SG/b7IzxttHvb6d5
         yuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=zedEPQGTgVh6pwqDk0aWi8hxMzGKzWUmqBIMlLqZOG4=;
        b=cTDmQYA7QnSQcVWzgd3qr/nCyANsWsZDyTd8i4+cQaX79ZZ5KztRCdxl8VGY28II2E
         hZq/Y9ME9JOF9RacPl0VRI1TOH8edq/owX7OZVlQppv+rjjjCiV36QzDbYGN5r6Tgssm
         hpPl+IGFYrXra0L7QJnJyZzxUq3EaIMd4Xthb70gNViE2WpemRCtXrdVHdwaLsmal8xi
         D/Xc5lPjFHno3rbi42HVkFJ/S/OgMogIXYLQorHcSoE8yrFdMkQHU4JmAMEQI04bv4Sf
         vaEberg9h52vj1W5k6eB93/8x3bv29FDou5KgFY4pXzR5Xth8Lh37/y9lV5sqLn5+k/L
         lz1w==
X-Gm-Message-State: AOAM531FRmccA+0pnNdsuIHlwCs2J0dBnMhT9H4w7khdlAUwyksv707m
        SWTL3gVN8tBzKtF87PW0sMA=
X-Google-Smtp-Source: ABdhPJy2AVjojpzvmfZCrMU+GLKjch2IFyH+TW23AfdHdvweaw7ZVqq/ze7bnk6ilAMA7HmZN6I+5A==
X-Received: by 2002:a17:90a:528a:: with SMTP id w10mr215768pjh.107.1599591545258;
        Tue, 08 Sep 2020 11:59:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id bt13sm48279pjb.23.2020.09.08.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 11:59:04 -0700 (PDT)
Date:   Tue, 08 Sep 2020 11:58:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Message-ID: <5f57d4702cb4d_10343208ab@john-XPS-13-9370.notmuch>
In-Reply-To: <20200904162154.GA24295@wunner.de>
References: <20200904162154.GA24295@wunner.de>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Wunner wrote:
> On Wed, Sep 02, 2020 at 10:00:32PM -0700, John Fastabend wrote:
> > Lukas Wunner wrote:
> > > * Before:       4730418pps 2270Mb/sec (2270600640bps)
> > > * After:        4759206pps 2284Mb/sec (2284418880bps)
> > 
> > I used a 10Gbps ixgbe nic to measure the performance after the dummy
> > device hung on me for some reason. I'll try to investigate what happened
> > later. It was unrelated to these patches though.
> > 
> > But, with 10Gbps NIC and doing a pktgen benchmark with and without
> > the patches applied I didn't see any measurable differences. Both
> > cases reached 14Mpps.
> 
> Hm, I strongly suspect you may have measured performance of the NIC and
> that you'd get different before/after numbers with the dummy device.

OK tried again on dummy device.

> 
> 
> > > * Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
> > > * After  + tc:  4007728pps 1923Mb/sec (1923709440bps)
> > 
> > Same here before/after aggregate appears to be the same. Even the
> > numbers above show a 1.2% degradation. Just curious is the above
> > from a single run or averaged over multiple runs or something
> > else? Seems like noise to me.
> 
> I performed at least 3 runs, but included just a single number in
> the commit message for brevity.  That number is intended to show
> where the numbers settled:
> 
> Before:           2257 2270 2270           Mb/sec
> After:            2282 2283 2284 2282      Mb/sec
> 
> Before + tc:      1941 1950 1951           Mb/sec
> After  + tc:      1923 1923 1919 1920 1919 Mb/sec
> 
> After + nft:      1782 1783 1782 1781      Mb/sec
> After + nft + tc: 1574 1566 1566           Mb/sec
> 
> So there's certainly some noise but still a speedup is clearly
> visible if neither tc nor nft is used, and a slight degradation
> if tc is used.

After running multiple times it does seem to be some small performance
improvement by adding noinline there. Its small though (maybe 1-2%?)
and I can't detect this on anything, but the dummy device.

But the degradation with clsact is also caused from this noinline.
If I add the noinline directly into the existing code I see the
same impact. Likely some some small performance improvement for the
no clsact case, but a very real degradation in the clsact case. Presumably,
due to having to do a call now. I didn't collect perf output
just did the simple test.

One piece I don't understand fully yet is on a single thread test
the degradation is small, but as the number of threads increases
the degradation increases. At single thread its 1-2%, but creeps
up to about 5% with 16 cores. Can you confirm this?

> 
> 
> > I did see something odd where it appeared fairness between threads
> > was slightly worse. I don't have any explanation for this? Did
> > you have a chance to run the test with -t >1?
> 
> Sorry, no, I only tested with a single thread on an otherwise idle
> machine.

We need to also consider the case with many threads or at least
become convinced its not going to change with thread count. What
I see is degradation is creeping up as cores increase.

> 
> 
> > Do you have plans to address the performance degradation? Otherwise
> > if I was building some new components its unclear why we would
> > choose the slower option over the tc hook. The two suggested
> > use cases security policy and DSR sound like new features, any
> > reason to not just use existing infrastructure?
> > 
> > Is the use case primarily legacy things already running in
> > nft infrastructure? I guess if you have code running now
> > moving it to this hook is faster and even if its 10% slower
> > than it could be that may be better than a rewrite?
> 
> nft and tc are orthogonal, i.e. filtering/mangling versus queueing.
> However tc has gained the ability to filter packets as well, hence
> there's some overlap in functionality.  Naturally tc does not allow
> the full glory of nft filtering/mangling options as Laura has stated,
> hence the need to add nft in the egress path.
> 
> 
> > huh? Its stated in the commit message with no reason for why it might
> > be the case and I can't reproduce it.
> 
> The reason as stated in the commit message is that cache pressure is
> apparently reduced with the tc handling moved out of the hotpath,
> an effect that Eric Dumazet had previously observed for the ingress path:
> 
> https://lore.kernel.org/netdev/1431387038.566.47.camel@edumazet-glaptop2.roam.corp.google.com/

OK, seems possible it could be an icache miss we are hitting. To really
confirm this though I would want to look at icache statistics. Otherwise
it feels likely, but difficult to tell for sure.

This noinline change subtle and buried in another patch. If you really
want to noinline that function pull it out of the series and push as its
own patch. I am against it because it appears to be directly degrading
performance for my use case and only providing small (if measurable at all)
gain in the normal case. But, at least if its submitted as its own patch we
can debate the merits. We would need performance data for some real devices
veth, nic, and dummy device also across many threads to get a good
handle on it. Also perf data would help understand whats happening. My
preference would be to also nail down the icache stats so we can be sure
this noininline improvment in non clsact case is fully understood.

> 
> Thanks a lot for taking the time to give these patches a whirl.
> 
> Lukas


