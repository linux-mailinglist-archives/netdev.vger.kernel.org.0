Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE85423378
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhJEW2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbhJEW2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:28:37 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB820C061749;
        Tue,  5 Oct 2021 15:26:46 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 5858F586F49B5; Wed,  6 Oct 2021 00:26:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5726960D2142F;
        Wed,  6 Oct 2021 00:26:45 +0200 (CEST)
Date:   Wed, 6 Oct 2021 00:26:45 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
In-Reply-To: <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
Message-ID: <qpnqonn-qr21-pr7s-sno5-70s1o1pq1or@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk> <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com> <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home> <20211005163754.66552fb3@gandalf.local.home> <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr> <CAHk-=whFhTofNk5G6dYFoFJC10EKzGdZVQdQygXHXWm_jodwBQ@mail.gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2021-10-05 23:27, Linus Torvalds wrote:
>On Tue, Oct 5, 2021 at 2:09 PM Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> Illegal.
>> https://en.cppreference.com/w/c/language/conversion
>> subsection "Pointer conversion"
>> "No other guarantees are offered"
>
>Well, we happily end up casting pointers to 'unsigned long' and back,

Yes, that wiki had only a succinct summary of pointer-pointer conversions.
http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf section 6.3.2.3
(pdfpage 59) has the details, including pointer-integer conversions.

>So it's not like the kernel deeply cares about theoretical portability.

All things considered, that's good enough.
Needless to say, how many times has the compiler changed and then
someone complaind and someone else replied "standard told you so". ;-)
