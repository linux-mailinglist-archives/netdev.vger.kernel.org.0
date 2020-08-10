Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD458240B32
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgHJQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 12:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgHJQcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 12:32:08 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AB3C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 09:32:08 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v9so10288357ljk.6
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 09:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFeBvVB1jEfzGpY+bt9baeLPv05boktfenH9hUjB0bo=;
        b=NLwt1l7ZkTPCOWy4Saoi0bq8GRA0HymCZr2MCX6EUf8yrgMhZYzCKPInB1idIbkf3Q
         cnY3zIobJzp8OWJPNknRKxwOvWW5ED2J8R3BCImD7hOYyBkEOE4SlteQxYj0Td2SaTEz
         aFRxvetDuNqc6x6dWJr8upX+Zw/7lLGsJRLt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFeBvVB1jEfzGpY+bt9baeLPv05boktfenH9hUjB0bo=;
        b=CMNy/8MQ+QOjo+DNYuxpKkqgu7i8XR8JXOZB7NhpWchBBmOTt7VutggVkWaKBbyQAQ
         qfKU5013JItJ2plaviHBdOLoAneL8BTwMMPFqWpTt8k9CmlHHO4gRzK8uNDayA9soCAD
         EuTsLAdme7BucDvcih4hZwoQFC3rHpiDvHh0s1HN6aCBceNfu5eHenqG7PleW2f2Lpmp
         +/vXgh7Iy7tUyxBa4eQZaCTjpXSVOWrfywIlH5q6gcaYHWDwkPyMgz67zVfXs5tyAZti
         aRRzPHlTws38+u066QZw8H52E8h7ux6QSUkFFWFabkH71sthtBZJTOGfKvCOHtJy3aKp
         SvtQ==
X-Gm-Message-State: AOAM532zPKsEu9vKMEdSxXHLBXKzWdwSYDmpzT7yBBoo6DalJBo2NdSD
        QJMPUaMjhl+gjusJTbR+vdsPzxFf+u0=
X-Google-Smtp-Source: ABdhPJxQnZEsQURQ38y0hLfiO3BN02sFSnohdVksGu51SYCtdPUlDbOaHjkZfEpQ5bqlB8q6plHA9Q==
X-Received: by 2002:a2e:8510:: with SMTP id j16mr942466lji.196.1597077126218;
        Mon, 10 Aug 2020 09:32:06 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id s4sm10956691lfc.56.2020.08.10.09.32.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 09:32:05 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id t23so10292179ljc.3
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 09:32:04 -0700 (PDT)
X-Received: by 2002:a2e:7615:: with SMTP id r21mr917059ljc.371.1597077124220;
 Mon, 10 Aug 2020 09:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu> <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu> <20200809183017.GC25124@SDF.ORG> <20200810114700.GB8474@1wt.eu>
In-Reply-To: <20200810114700.GB8474@1wt.eu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Aug 2020 09:31:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
Message-ID: <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 4:47 AM Willy Tarreau <w@1wt.eu> wrote:
>
> Doing testing on real hardware showed that retrieving the TSC on every
> call had a non negligible cost, causing a loss of 2.5% on the accept()
> rate and 4% on packet rate when using iptables -m statistics.

And by "real hardware" I assume you mean x86, with a fairly fast and
high-performance TSC for get_random_entropy().

Reading the TSC takes on the order of 20-50 cycles, iirc.

But it can actually be *much* more expensive. On non-x86, it can be an
IO cycle to external chips.

And on older hardware VM's in x86, it can be a vm exit etc, so
thousands of cycles. I hope nobody uses those VM's any more, but it
would be a reasonable test-case for some non-x86 implementations, so..

IOW, no. You guys are - once again - ignoring reality.

            Linus
