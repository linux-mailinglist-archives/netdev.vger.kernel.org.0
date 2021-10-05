Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A8422C24
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhJEPRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:17:05 -0400
Received: from mail.efficios.com ([167.114.26.124]:55550 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEPRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:17:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EE21B38D87B;
        Tue,  5 Oct 2021 11:15:12 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id kZ6Ruhz5_vwz; Tue,  5 Oct 2021 11:15:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 771A738DEA5;
        Tue,  5 Oct 2021 11:15:12 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 771A738DEA5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1633446912;
        bh=F2x+Hi5WGEvzSTS/iYSt+2Kq3IbtXMx7Ua5K43Tf+8Q=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=fWZyv80Hc57O72INVh6dzebvppxNTTpSCWD6RX6UcVz0TCIG7KNJFBruatsJlbExw
         a8m1LH2syppBinNohKsGX7Let/OXR1df6ma27SCVmH/cJOlyEpjOnjXwgezNfnyBtT
         Ysfzbmm+lo0m6osH+K1EFWYLctbOmd5Blockkwo7Y10QWtKV+RwuP+99Djm81eXW80
         KKtj5gqs35x3yuV0hBt3DwAHpdU+xi2TuYGECth+9gfop5OvVk2mBE8x9LiSpqNf43
         YxLhniS72qCXG3Dxuv3pvMVdS43CxGasiiw7HWsLrHsg5K6ejL9ZnYlk9EpHxqrs7h
         h/K7AP6Vrbjjg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tJJJRKMZDi4F; Tue,  5 Oct 2021 11:15:12 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 5A3A838DE3F;
        Tue,  5 Oct 2021 11:15:12 -0400 (EDT)
Date:   Tue, 5 Oct 2021 11:15:12 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>
Message-ID: <505004021.2637.1633446912223.JavaMail.zimbra@efficios.com>
In-Reply-To: <20211005094728.203ecef2@gandalf.local.home>
References: <20211005094728.203ecef2@gandalf.local.home>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4156 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4156)
Thread-Topic: Use typeof(p) instead of typeof(*p) *
Thread-Index: 7dSlbpn4ImaK0wI9+IMWa3C1UuJxjA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 5, 2021, at 9:47 AM, rostedt rostedt@goodmis.org wrote:
[...]
> #define rcu_dereference_raw(p) \
> ({ \
> 	/* Dependency order vs. p above. */ \
> 	typeof(p) ________p1 = READ_ONCE(p); \
> -	((typeof(*p) __force __kernel *)(________p1)); \
> +	((typeof(p) __force __kernel)(________p1)); \
> })

AFAIU doing so removes validation that @p is indeed a pointer, so a user might mistakenly
try to use rcu_dereference() on an integer, and get away with it. I'm not sure we want to
loosen this check. I wonder if there might be another way to achieve the same check without
requiring the structure to be declared, e.g. with __builtin_types_compatible_p ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
