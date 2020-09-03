Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3217225B9F6
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgICFAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgICFAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:00:44 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B64C061244;
        Wed,  2 Sep 2020 22:00:42 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o20so1254134pfp.11;
        Wed, 02 Sep 2020 22:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZA14PlrdbpPV+LvBRha5NeMnhbwv4WxXLA9HpimjeTQ=;
        b=H5Ks6QscSMH4AtQgZjOJjL3nPS8DI4SKjQ4KygbfF+HSLya7EoQczgodW2japN3GVx
         t1pk5Npv/5abuXHx6g6RBLr/DH3NYPhdF36rKz21tj0v1rmNWb3ADyV9RhnpLOLdA7pJ
         yqGIvn+uZHyfAi34QkrJUel39v9adqVLdcbTZhswTXv7+Qg2dwrmCZzjGzthvrMXf9ly
         d468ohdJbviQZwACwYsnqtHvwtEMSeBme80nqEhTe5RyoLF4HXt3sK83EwCEU3cTR6Gs
         mUYjOo90D6j4g2g6EAqSHtDW4zsTbu9Err2xWiD3NMz+V2c8EBSmLzVk8V6mfRcAqvrk
         b1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZA14PlrdbpPV+LvBRha5NeMnhbwv4WxXLA9HpimjeTQ=;
        b=ajTg9zJz/VZdczO5pxInryYgOnQBIdawdWiyQsopzBYco/BJi8mwsbQfem0KQPdBHv
         0PqXD4Rc7XvPnfWbqk5fJCGeAMF+NZYU0m5gRe25j2SRFbWaxm9GkCiCMSp+LcR5JqAQ
         5HqiJ4KrrH8yEMleSL1pw8sKMF3bHT/fbSNiPZ4DKpdxSeNbRenUEqftYpDz0Vk5koR3
         lsAtUdDk0KgVvFJb6TKy9Wd3kUJhFf3O7wgWMabxhZep8BiJi8Z3G0XvOOLmX0ZaZ5SX
         QEkLfDyndGw2Ysh2/9Cds6ZhiM9bBKZIMQMTPQV/HbJrxMIenv+61MPKjbYgVKZjRUmo
         Q7/w==
X-Gm-Message-State: AOAM532RGrxjvdQPZlA5HXE5yLvC1qsUFlz66f5zpJJDAXzNq1QSaKaf
        K2J9fEHXUxCaVRDn9KMHUjzT8j7PfDBC9Q==
X-Google-Smtp-Source: ABdhPJx0k3BYzCGo5rwms7hU+RHsmo8sqrGPXd2Mk2unOdP576RLkqviWEPdzk7osqe92Jt9J0noSQ==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr1431665pgw.442.1599109240861;
        Wed, 02 Sep 2020 22:00:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e142sm1413639pfh.108.2020.09.02.22.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 22:00:40 -0700 (PDT)
Date:   Wed, 02 Sep 2020 22:00:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Message-ID: <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
In-Reply-To: <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch>
References: <cover.1598517739.git.lukas@wunner.de>
 <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
 <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Lukas Wunner wrote:
> > Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> > handle_ing() under unique static key") introduced the ability to
> > classify packets on ingress.
> > 
> > Support the same on egress.  This allows filtering locally generated
> > traffic such as DHCP, or outbound AF_PACKETs in general.  It will also
> > allow introducing in-kernel NAT64 and NAT46.  A patch for nftables to
> > hook up egress rules from user space has been submitted separately.
> > 
> > Position the hook immediately before a packet is handed to traffic
> > control and then sent out on an interface, thereby mirroring the ingress
> > order.  This order allows marking packets in the netfilter egress hook
> > and subsequently using the mark in tc.  Another benefit of this order is
> > consistency with a lot of existing documentation which says that egress
> > tc is performed after netfilter hooks.
> > 
> > To avoid a performance degradation in the default case (with neither
> > netfilter nor traffic control used), Daniel Borkmann suggests "a single
> > static_key which wraps an empty function call entry which can then be
> > patched by the kernel at runtime. Inside that trampoline we can still
> > keep the ordering [between netfilter and traffic control] intact":
> > 
> > https://lore.kernel.org/netdev/20200318123315.GI979@breakpoint.cc/
> > 
> > To this end, introduce nf_sch_egress() which is dynamically patched into
> > __dev_queue_xmit(), contingent on egress_needed_key.  Inside that
> > function, nf_egress() and sch_handle_egress() is called, each contingent
> > on its own separate static_key.
> > 
> > nf_sch_egress() is declared noinline per Florian Westphal's suggestion.
> > This change alone causes a speedup if neither netfilter nor traffic
> > control is used, apparently because it reduces instruction cache
> > pressure.  The same effect was previously observed by Eric Dumazet for
> > the ingress path:
> > 
> > https://lore.kernel.org/netdev/1431387038.566.47.camel@edumazet-glaptop2.roam.corp.google.com/
> > 
> > Overall, performance improves with this commit if neither netfilter nor
> > traffic control is used. However it degrades a little if only traffic
> > control is used, due to the "noinline", the additional outer static key
> > and the added netfilter code:

I don't think it actualy improves performance at least I didn't observe
that. From the code its not clear why this would be the case either. As
a nit I would prefer that line removed from the commit message.

I guess the Before/After below is just showing some noise in the
measurement.

> > 
> > * Before:       4730418pps 2270Mb/sec (2270600640bps)
> > * After:        4759206pps 2284Mb/sec (2284418880bps)
> 
> These baseline numbers seem low to me.

I used a 10Gbps ixgbe nic to measure the performance after the dummy
device hung on me for some reason. I'll try to investigate what happened
later. It was unrelated to these patches though.

But, with 10Gbps NIC and doing a pktgen benchmark with and without
the patches applied I didn't see any measurable differences. Both
cases reached 14Mpps.

> 
> > 
> > * Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
> > * After  + tc:  4007728pps 1923Mb/sec (1923709440bps)

Same here before/after aggregate appears to be the same. Even the
numbers above show a 1.2% degradation. Just curious is the above
from a single run or averaged over multiple runs or something
else? Seems like noise to me.

I did see something odd where it appeared fairness between threads
was slightly worse. I don't have any explanation for this? Did
you have a chance to run the test with -t >1?

Also the overhead on your system for adding a tc rule seems
a bit high. In my case a single tc drop rule added ~7% overhead
at 14mpps. Above it looks more like 16% so double. Maybe a
missing JIT or some other configuration. Either a perf trace
or looking at your config would help figure that out.

> > 
> > * After  + nft: 3714546pps 1782Mb/sec (1782982080bps)
> > 

I haven't had a chance to do these benchmarks, but for my use
cases its more important to _not_ degrade tc performance.

I will note though that this is getting close to a 10% perf
degradation from using tc. I haven't looked much into it,
but that seems high to simply drop a packet.

Do you have plans to address the performance degradation? Otherwise
if I was building some new components its unclear why we would
choose the slower option over the tc hook. The two suggested
use cases security policy and DSR sound like new features, any
reason to not just use existing infrastructure?

Is the use case primarily legacy things already running in
nft infrastructure? I guess if you have code running now
moving it to this hook is faster and even if its 10% slower
than it could be that may be better than a rewrite?

> > Measured on a bare-metal Core i7-3615QM.
> 
> OK I have some server class systems here I would like to run these
> benchmarks again on to be sure we don't have any performance
> regressions on that side.
> 
> I'll try to get to it asap, but likely will be Monday morning
> by the time I get to it. I assume that should be no problem
> seeing we are only on rc2.

Sorry Monday had to look into a different bug.

> 
> Thanks.
> 

Thanks.
John
