Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087B133436
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfFCPzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:55:35 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:32810 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbfFCPze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:55:34 -0400
Received: by mail-lj1-f174.google.com with SMTP id v29so5434836ljv.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEvt8pGQEbFr4DBC3ZactO5sklI3XbY8H2zkXOcjs2g=;
        b=T1/m84q35iHVOMXlWw9a8KqEj4GwEOwLm06PoeEgn4nWnDGiSSZJiqTH54Nkz4QWfQ
         Eai3tdr9Z6bLfZm3CrxIY8OH3lKIsIpqVEb9uhG2g1I7juYcrS7cchRhE83PYLM0QaLt
         JDimS+ZheOBnr5JA+kS1fzrufMArQn4GLQAp8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEvt8pGQEbFr4DBC3ZactO5sklI3XbY8H2zkXOcjs2g=;
        b=e/M5g6o/jYSnuThw3Dzqlpj0BaiMjX0Mvt2Fm4AJ/W6HsXxsC8FbnFfPK1rlxVFbqL
         2sOpTQ8ACZV9F5Z93ajXAzIyiehZ0+JxcltJAT7YUxWGW9kB2EJ9n4t1BCO66gahJ4A7
         KA15tm0TeqfcYvxVqp7qyVIFU56s0YPA1xhoWra8JDkddZmeMko6iIXOjO2VU3UCDEND
         Bd9b0S9mfGBatCEMEaGoh+iAjUu9Fwf6QDEj55SdRt62LQLmqMLwN7+wZNfKA/ZXH7U2
         bXV4zmunWKtiXvJ/zptUAG+K1j6cwB+HgxuCcXBhYgRKl+VgM90soGXQhxK01TUrtS8/
         BEFw==
X-Gm-Message-State: APjAAAXepE/rOjGAZm2lN3xQ5kIarEz55paQxygLqKdcr5IqKDLWlhl/
        0fDVLGxAjO9FNgMd3oOkjh1sqjsbXvU=
X-Google-Smtp-Source: APXvYqw/BmEhzWQ1cMy6odCXTMY4NgPOk9ufnbyHoCEksAcHEOkwitIg0ervo1e09ZzkQR0DMs5Zag==
X-Received: by 2002:a2e:3013:: with SMTP id w19mr1997685ljw.73.1559577332272;
        Mon, 03 Jun 2019 08:55:32 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id v16sm3223718lji.88.2019.06.03.08.55.29
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:55:30 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id a21so1512816ljh.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:55:29 -0700 (PDT)
X-Received: by 2002:a2e:85d1:: with SMTP id h17mr14153700ljj.1.1559577329451;
 Mon, 03 Jun 2019 08:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com> <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com> <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com> <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com> <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
In-Reply-To: <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jun 2019 08:55:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
Message-ID: <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 2, 2019 at 8:03 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> In any case, I am now even more certain that compiler barriers are
> not needed in the code in question.  The reasoning is quite simple.
> If you need those compiler barriers then you surely need real memory
> barriers.

So the above statement is not necessarily correct.

Compiler barriers very much can have real effects even in the absense
of "real" memory barriers.

But those effects are obviously not about multiple CPU's - they are
about code generation and can be about ordering on _one_ CPU. Those
effects definitely happen, though.

So a compiler barrier without a memory barrier may make a difference if you

 (a) compile for UP (when a compiler barrier basically _is_ a memory barrier)

 (b) have deadlock or ordering avoidance with only the local CPU
taking interrupts.

 (c) need to re-load a value in a loop, but ordering isn't a concern

and possibly other situations.

In the above, (a) may be pointless and trivial, but (b) and (c) are
issues even on SMP. Some things only matter for the local CPU - an
interrupt or a code sequence that happens on another CPU can just
block, but if an interrupt comes in on the same CPU may dead-lock and
depend on particular access ordering. And (c) is for things like
cpu_relax() in loops that read stuff (although honestly, READ_ONCE()
is generally a much better pattern).

But it sounds like in this case at least, Herbert's and Paul's
disagreements aren't really all that fundamentally about the memory
barriers and locking, as just the fact that in general the only thing
that RCU protects against is single accesses, and thus any RCU region
technically should use something that guarantees that the compiler
might not do stupid things.

We do require a _minimum_ of compiler sanity, but the compiler turning
a non-marked read into two reads has definitely happened, and can be
very subtle. Even if on a C level it looks like a single access, and
correctness doesn't care about _what_ the value we read is, it might
be turned by the compiler into two separate accesses that get two
different values, and then the end result may be insane and
unreliable.

So on the whole, I do think that it's usually a good idea to show
_which_ access is protected by RCU. Perhaps with a
READ_ONCE/WRITE_ONCE pattern, although it can be other things.

I don't believe that it would necessarily help to turn a
rcu_read_lock() into a compiler barrier, because for the non-preempt
case rcu_read_lock() doesn't need to actually _do_ anything, and
anything that matters for the RCU read lock will already be a compiler
barrier for other reasons (ie a function call that can schedule).

Anyway, I suspect the code is correct in practice, but I do have some
sympathy for the "RCU protected accesses should be marked".

                    Linus
