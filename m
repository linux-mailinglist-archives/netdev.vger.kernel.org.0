Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF10C333C3
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfFCPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:41:01 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:45915 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfFCPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 11:41:00 -0400
Received: by mail-lj1-f176.google.com with SMTP id r76so16667784lja.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=88zEtlZo9VcPYvQYA1jKvAsBkyo9fzTE6nwo1Hgnw4c=;
        b=g7xyhXorBa6FBLPRxz237Si+Si/iS47DotxTNT9gS16OG4gjNWyRGb5dCcvnI/8QvX
         xq3WRPTwie1oOh6i5GON8NUyBCfTnraWU9T+b3l1nrZg7dNuzHbATVP6/ijneNfXZlNj
         GO03Ng2cp1/WOXDZ9RS2z8kXYjDpjQg1kccFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=88zEtlZo9VcPYvQYA1jKvAsBkyo9fzTE6nwo1Hgnw4c=;
        b=qR42IsZ11sll3Ql3ek51dRm9igIMqw8szUeUbVxkosOkj86hnu99d4A9kP0DL+vq36
         Jf3qJ/QqF8PVqpeDtourQaEyf9zBXugZr1DdAJFM3VyRD9aCi0SyJKrKQiVifH/hLrFA
         c1UWC1tY3Ba/9lMx1OQ2CW1asa1H7w5tj9ZjRup9Ch6ya0xB311GEv6T8SetfZCMaa4r
         uFNE98mHjmaSAMG4H31KeR0ZXb/X0zSX0Qva526+uLQVLeS7PIyamZhDIT5LFNhcgbXd
         RjE/w/bT5OtJ0s4HX9cPnD2QM29+bdIMupS3j3hzCqb0yeqzNJRwgIaXdirYuR5t0Dhg
         UHcQ==
X-Gm-Message-State: APjAAAXjknGATJDsQFFGKxYdo0liS0c1/jGaljpjPjsHZCQ69Hodk4CP
        7JOETwWG84sVs5ixZWs1h5KWrjQtrrQ=
X-Google-Smtp-Source: APXvYqwcajLbCktYglOJzRLrRnp1Jz6WGo2guiW6WG6Rryz90QW3yuBGFRNo59bTJBF0tj0Idkz7jg==
X-Received: by 2002:a2e:9ed9:: with SMTP id h25mr4092249ljk.13.1559576458635;
        Mon, 03 Jun 2019 08:40:58 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id o124sm3219664lfe.92.2019.06.03.08.40.57
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:40:57 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id a10so13436461ljf.6
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 08:40:57 -0700 (PDT)
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr14530773ljj.147.1559576456787;
 Mon, 03 Jun 2019 08:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20150910171649.GE4029@linux.vnet.ibm.com> <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge> <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au> <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au> <20190603034707.GG28207@linux.ibm.com>
 <20190603040114.st646bujtgyu7adn@gondor.apana.org.au> <20190603072339.GH28207@linux.ibm.com>
 <20190603084214.GA1496@linux.ibm.com> <9c0a9e2faae7404cb712f57910c8db34@AcuMS.aculab.com>
In-Reply-To: <9c0a9e2faae7404cb712f57910c8db34@AcuMS.aculab.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jun 2019 08:40:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4pqF9bwjQHNzAKBmbAFTDWi9KwvLznj0HZLAZ+eGFpw@mail.gmail.com>
Message-ID: <CAHk-=wj4pqF9bwjQHNzAKBmbAFTDWi9KwvLznj0HZLAZ+eGFpw@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     David Laight <David.Laight@aculab.com>
Cc:     "paulmck@linux.ibm.com" <paulmck@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

On Mon, Jun 3, 2019 at 8:26 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Paul E. McKenney
>
> > We do
> > occasionally use READ_ONCE() to prevent load-fusing optimizations that
> > would otherwise cause the compiler to turn while-loops into if-statements
> > guarding infinite loops.
>
> In that case the variable ought to be volatile...

No.

We do not use volatile on variables.

The C people got the semantics wrong, probably because 'volatile' was
historically for IO, not for access atomicity without locking.

It's not the memory location that is volatile, it is really the
_access_ that is volatile.

The same memory location might be completely stable in other access
situations (ie when done under a lock).

In other words, we should *never* use volatile in the kernel. It's
fundamentally mis-designed for modern use.

(Of course, we then can use volatile in a cast in code, which drives
some compiler people crazy, but that's because said compiler people
don't care about reality, they care about some paperwork).

                      Linus
