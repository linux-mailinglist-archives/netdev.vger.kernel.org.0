Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E062560D1
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgH1Sw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1Swy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 14:52:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6551C061264;
        Fri, 28 Aug 2020 11:52:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u20so1105260pfn.0;
        Fri, 28 Aug 2020 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wDnMtZIra7WWgmvfJglhA0fiZqRqnvU/7bnAqVFUhpo=;
        b=l3D17DkTtbZzEoz7xBgwtmw9YL3jKyvX3GWoUoQR4cfBLfI28WoBcOtu9Z6YWdgx7+
         qHzEmYfjkYgJSu8+1vjXyOEWx4Iz/LMTnQ2hC7bH1luwC9Z+o93CI7fOm4+5kk23HV7s
         fAD9oX2HYMqbiAe/MjTbbXTgglPW4UBCApL7lUH6CNfLfzAZCkiR9YpJv4O1vAsiYcc7
         UKHkbnSr6+PVvp09w0fXcE0PKgx3UN/XGJ4AV1VLzqDCt5rEEDdU08jCeDdKhKzo6HUi
         oDHMn11B6xqZ6BKfp/v80KBW3neE4ma0z7i40dRIrRGX3svOdNuCpFjIYKdB1MZSY5Pe
         KTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wDnMtZIra7WWgmvfJglhA0fiZqRqnvU/7bnAqVFUhpo=;
        b=U+Rvi9CkrmKQKJ2bN+NHlcyAwF+pAbyaiOfsxizK3bqISQAFq68k6mNmxeo/s6vQ/8
         CQfc8pLPQFX6SD8nV3qp6DcOb1RnVbv91oDCW0Bumyk9wpjyNvvVTAMtcOE4QLt299lx
         tpHzN3NRwVWU8sOnQXppHBmNhjzTzgjXSGfaBPG5qNRbQdHBGRn/dOQAm4t06HNR3uIz
         nhGC5An4WWMOaG4IyvVaB9BF0vyzT8AoeiLUIKJhLWQXWZ5AMqgJJIVBJ8px9GbS/uLI
         erp8aDOBgpl78NoArFiAcFjstJUmUynPIHXZXx8SSwN9GKRa7TRCsrET6vL1my0h7TVs
         ovtQ==
X-Gm-Message-State: AOAM530EYIqaGzRnd2wxyhFa4LqBHWZbrY+4z/iMJSUqTLK8+lP+v0ij
        W4ydnrLEITemCgdBlRiY1O4=
X-Google-Smtp-Source: ABdhPJwJRfEBeGrLco/maQPI391lbIdXwMlUBBDe96UeCqHSJBIvvMTLRsKvG2OnuFc2okNchqngUw==
X-Received: by 2002:aa7:96d1:: with SMTP id h17mr336068pfq.68.1598640772141;
        Fri, 28 Aug 2020 11:52:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b26sm153047pff.54.2020.08.28.11.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 11:52:51 -0700 (PDT)
Date:   Fri, 28 Aug 2020 11:52:42 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Message-ID: <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch>
In-Reply-To: <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
References: <cover.1598517739.git.lukas@wunner.de>
 <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
Subject: RE: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Wunner wrote:
> Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> handle_ing() under unique static key") introduced the ability to
> classify packets on ingress.
> 
> Support the same on egress.  This allows filtering locally generated
> traffic such as DHCP, or outbound AF_PACKETs in general.  It will also
> allow introducing in-kernel NAT64 and NAT46.  A patch for nftables to
> hook up egress rules from user space has been submitted separately.
> 
> Position the hook immediately before a packet is handed to traffic
> control and then sent out on an interface, thereby mirroring the ingress
> order.  This order allows marking packets in the netfilter egress hook
> and subsequently using the mark in tc.  Another benefit of this order is
> consistency with a lot of existing documentation which says that egress
> tc is performed after netfilter hooks.
> 
> To avoid a performance degradation in the default case (with neither
> netfilter nor traffic control used), Daniel Borkmann suggests "a single
> static_key which wraps an empty function call entry which can then be
> patched by the kernel at runtime. Inside that trampoline we can still
> keep the ordering [between netfilter and traffic control] intact":
> 
> https://lore.kernel.org/netdev/20200318123315.GI979@breakpoint.cc/
> 
> To this end, introduce nf_sch_egress() which is dynamically patched into
> __dev_queue_xmit(), contingent on egress_needed_key.  Inside that
> function, nf_egress() and sch_handle_egress() is called, each contingent
> on its own separate static_key.
> 
> nf_sch_egress() is declared noinline per Florian Westphal's suggestion.
> This change alone causes a speedup if neither netfilter nor traffic
> control is used, apparently because it reduces instruction cache
> pressure.  The same effect was previously observed by Eric Dumazet for
> the ingress path:
> 
> https://lore.kernel.org/netdev/1431387038.566.47.camel@edumazet-glaptop2.roam.corp.google.com/
> 
> Overall, performance improves with this commit if neither netfilter nor
> traffic control is used. However it degrades a little if only traffic
> control is used, due to the "noinline", the additional outer static key
> and the added netfilter code:
> 
> * Before:       4730418pps 2270Mb/sec (2270600640bps)
> * After:        4759206pps 2284Mb/sec (2284418880bps)

These baseline numbers seem low to me.

> 
> * Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
> * After  + tc:  4007728pps 1923Mb/sec (1923709440bps)
> 
> * After  + nft: 3714546pps 1782Mb/sec (1782982080bps)
> 
> Measured on a bare-metal Core i7-3615QM.

OK I have some server class systems here I would like to run these
benchmarks again on to be sure we don't have any performance
regressions on that side.

I'll try to get to it asap, but likely will be Monday morning
by the time I get to it. I assume that should be no problem
seeing we are only on rc2.

Thanks.

> 
> Commands to perform a measurement:
> ip link add dev foo type dummy
> ip link set dev foo up
> modprobe pktgen
> echo "add_device foo" > /proc/net/pktgen/kpktgend_3
> samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1

Thats a single thread correct? -t option if I recall correctly.
I think we should also try with many threads to see if
that makes a difference. I guess probably not, but lets
see.

> 
> Commands to enable egress traffic control:
> tc qdisc add dev foo clsact
> tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'
> 
> Commands to enable egress netfilter:
> nft add table netdev t
> nft add chain netdev t co \{ type filter hook egress device foo priority 0 \; \}
> nft add rule netdev t co ip daddr 4.3.2.1/32 drop
> 

I'll give above a try.
