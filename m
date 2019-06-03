Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CB33492
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfFCQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:07:51 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44492 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbfFCQHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:07:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so14028540lfm.11
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pxJWbikYyn86QHCb0MwofCFDPmQed9mzRIadXSeX7vU=;
        b=Z2rW7Y52J1jlD/vdLzyZA3EE5ZKf8u+7QkfyHu0DdN3BFL0k8qRy5xZypKkCU/4QVp
         +V9e3HJeIoju1wARoAembK05/AsHz0rFh3AYCJO3uYP54sEvCqed8Mb5dRqEOMI34gWw
         O6AIkk+mUiIV/IIPKYXRJlzU0eZx96PLgqUzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pxJWbikYyn86QHCb0MwofCFDPmQed9mzRIadXSeX7vU=;
        b=fZiE5Wrz9ZW+dlPFYG6FxJxt+RqnBVvShNvdJOpFBvv/nkB2nqxkSYd7T09uzmCc3k
         110LTmWUUkeskv8V+pF+LmDmitWPv7kRReh+9zWQO1NU0hgMIFjW0CKYAae2rfM2KCwX
         DMixWVgs/GP0y9t0pJrg8CkNSR+Dt85aTPMZoH9KtTS+L9CpcvOdd6iGRyv5BZaRC+1w
         ELr2DMzFNYu9H7IQVxHKSBvpO5voWg+jlGwCNGVF88hkCFC4m/wAkQZXMUpvRz2s11/V
         bg3gdFgbZzLsZwGHQyaHAUSsa7q/YH2/sVhO5RBq8tIAZSL1WuRnes9kKLznZJWb+OVq
         uhKg==
X-Gm-Message-State: APjAAAVpjQJTdSm7tldLQz8eVxXXzvD2ZWWlqMQ33rJ6msvej/7Yk9rZ
        oZmDvo096ki0Z448TqX/3aymdF4j1vw=
X-Google-Smtp-Source: APXvYqwEdAb9HqPzPDFKQQgkHXBkMfn7hWZ2DHP8swDifkkaRP+4YJPK3VK5sBgVfHEBts/jJFUwbw==
X-Received: by 2002:ac2:429a:: with SMTP id m26mr12412309lfh.152.1559578068090;
        Mon, 03 Jun 2019 09:07:48 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id u13sm3247277lfl.61.2019.06.03.09.07.46
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 09:07:46 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id j24so16795046ljg.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:07:46 -0700 (PDT)
X-Received: by 2002:a2e:85d1:: with SMTP id h17mr14182608ljj.1.1559578065814;
 Mon, 03 Jun 2019 09:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com> <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com> <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com> <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com> <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
In-Reply-To: <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jun 2019 09:07:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
Message-ID: <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
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

On Mon, Jun 3, 2019 at 8:55 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't believe that it would necessarily help to turn a
> rcu_read_lock() into a compiler barrier, because for the non-preempt
> case rcu_read_lock() doesn't need to actually _do_ anything, and
> anything that matters for the RCU read lock will already be a compiler
> barrier for other reasons (ie a function call that can schedule).

Actually, thinking a bit more about this, and trying to come up with
special cases, I'm not at all convinced.

Even if we don't have preemption enabled, it turns out that we *do*
have things that can cause scheduling without being compiler barriers.

In particular, user accesses are not necessarily full compiler
barriers. One common pattern (x86) is

        asm volatile("call __get_user_%P4"

which explicitly has a "asm volaile" so that it doesn't re-order wrt
other asms (and thus other user accesses), but it does *not* have a
"memory" clobber, because the user access doesn't actually change
kernel memory. Not even if it's a "put_user()".

So we've made those fairly relaxed on purpose. And they might be
relaxed enough that they'd allow re-ordering wrt something that does a
rcu read lock, unless the rcu read lock has some compiler barrier in
it.

IOW, imagine completely made up code like

     get_user(val, ptr)
     rcu_read_lock();
     WRITE_ONCE(state, 1);

and unless the rcu lock has a barrier in it, I actually think that
write to 'state' could migrate to *before* the get_user().

I'm not convinced we have anything that remotely looks like the above,
but I'm actually starting to think that yes, all RCU barriers had
better be compiler barriers.

Because this is very much an example of something where you don't
necessarily need a memory barrier, but there's a code generation
barrier needed because of local ordering requirements. The possible
faulting behavior of "get_user()" must not migrate into the RCU
critical region.

Paul?

So I think the rule really should be: every single form of locking
that has any semantic meaning at all, absolutely needs to be at least
a compiler barrier.

(That "any semantic meaning" weaselwording is because I suspect that
we have locking that truly and intentionally becomes no-ops because
it's based on things that aren't relevant in some configurations. But
generally compiler barriers are really pretty damn cheap, even from a
code generation standpoint, and can help make the resulting code more
legible, so I think we should not try to aggressively remove them
without _very_ good reasons)

                      Linus
