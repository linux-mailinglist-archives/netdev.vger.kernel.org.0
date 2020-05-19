Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19891DA437
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgESWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESWCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:02:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC7C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:02:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so271084pjb.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ItCBBq7njJq0xXoYStxRuaitB0x1NRpk2LvkE91n+Uw=;
        b=N9qHk7EYXCl+bWHjv/+PT9JK68+GycKjv6WEUFvYXvAJdnGd2sRAbeAYs4xKiW80Rm
         RXmPvdgvDg6CDyQB5ib3URafbbc9+ohiP2M+OlUwXm3HrdkW5nSYcZn7ven6REY9cin1
         o1IAkRHa3YuerW7ITaI2XO59ELFHJ9GbYnALgRhDz+Dw5dE8rGlO3hpf1zjuIsNX8cJY
         fJ9PY8i/W0LYaIKCA7ia6Gthn9lHN/P7dpvWLuZVjv+OKKDMYHwIolbv6FblVqXvr0k1
         XYyHV5l+oHnCIV4ifKuFVyHhi2Wg2JIW8d4xWr6YoUi76R92pKE3PXRTX2v2S0tnDJGa
         I2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ItCBBq7njJq0xXoYStxRuaitB0x1NRpk2LvkE91n+Uw=;
        b=Ceyzw/u3ogWr5HMA+JoJFkGEgVAO1kZhHxaMgYrTn7/KZuHAqVJCsJEE3OnnC9pqoE
         PVa0whQ5jKf2I2jLV0L1+5aYGbO+XZgkJVzu7xS2yWzKY/lzMPvDKGWiiWZQujeu5A1c
         nBWXTXYLdYiS7i354H8pxtLoYbpZwySacwSSLPs3NOghSK4FlReeYG2qLP595i3n8qCW
         pakYtM4NPq4Fn4ec+XjQDmT7K2PU9ie+1n1skNkFmJEuriGNtIER6Zu0clxiV3PhZKCT
         KOW5YGMXOIKF1lsnxXd4xn4wU6XTPecYOxY0/JGV+qkwxB9yqGfb8uxbs0ABZA8h45Sp
         +oEg==
X-Gm-Message-State: AOAM532bmP4wq/N3G6xq7dhTHBBSlHkaUo9mhXjDoOdwI07AL5O/kMje
        xZMw87wsgce5qzAZnh4UJeLb3Q==
X-Google-Smtp-Source: ABdhPJw+M8jU+CESYDTFzBWHUTE6YX0xdBJKQEUAVvlVOl3CAnDqyXWN54YiFbxWKQ7JUm8Ee66HXA==
X-Received: by 2002:a17:902:7402:: with SMTP id g2mr1490152pll.241.1589925727940;
        Tue, 19 May 2020 15:02:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y10sm381105pfb.53.2020.05.19.15.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 15:02:07 -0700 (PDT)
Date:   Tue, 19 May 2020 15:01:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200519150159.4d91af93@hermes.lan>
In-Reply-To: <20200519214547.352050-2-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
        <20200519214547.352050-2-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 23:45:23 +0200
"Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:

> Sequence counters write paths are critical sections that must never be
> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
> 
> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
> netdev name retrieval.") handled a deadlock, observed with
> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
> infinitely spinning: it got scheduled after the seqcount write side
> blocked inside its own critical section.
> 
> To fix that deadlock, among other issues, the commit added a
> cond_resched() inside the read side section. While this will get the
> non-preemptible kernel eventually unstuck, the seqcount reader is fully
> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
> 
> The fix is also still broken: if the seqcount reader belongs to a
> real-time scheduling policy, it can spin forever and the kernel will
> livelock.
> 
> Disabling preemption over the seqcount write side critical section will
> not work: inside it are a number of GFP_KERNEL allocations and mutex
> locking through the drivers/base/ :: device_rename() call chain.
> 
> From all the above, replace the seqcount with a rwsem.
> 
> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Have your performance tested this with 1000's of network devices?

The reason seqcount logic is was done here was to achieve scaleablity
and a semaphore does not scale as well.
