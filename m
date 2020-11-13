Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5182B1BC8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 14:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgKMNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 08:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMNWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 08:22:31 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CC9C0613D1;
        Fri, 13 Nov 2020 05:22:30 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id p1so9868793wrf.12;
        Fri, 13 Nov 2020 05:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gzAM5/34WGhJmOugyCwQPFpl5aixkDcuk0CgzVtzJO0=;
        b=K3mFJ8hEOlm55D4UrfXq+sf04+yHRvyxv8188aJY0pqtVArXjpxOL6sPhoL9zHiov8
         KLrP69YCyc96Iz+M37D4aPVoqP7cy7GFUffvGmcSjad+VZPXFzycpQtenLhx707ZqJ0f
         CSUQ/tV1ra2b7NbAe6uAi9Ld5h83QhDJZ41u5kqrMrXPzFLJphgans1xKb85+YHsoxRr
         xJos6bPWwsAcQd7qniVM4oKCIg8/UaaO+tjojmQ1Q3zC0Et3veYEh8Llqb8NwViV3EOY
         59diiHzBNGOk+gN2Uc8FMgAIpQHPA1dG5Gn4uZ/5cnmTzshh4G0qNMnI8zXNRjiGh6Mc
         04hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gzAM5/34WGhJmOugyCwQPFpl5aixkDcuk0CgzVtzJO0=;
        b=NMV+I8PtqLqhtbKIvJjjDOH4WfdltaC/wiKwBtHbMzEmS/xQmC644HDMsn5MaRWjHC
         5slSd8R7SmrdJRd5DOc7Pry1uyVb6+/EOB1NB2HHpYgmwLdVnzyZIydsARoNMcB3KY5c
         PI4f02LpbSch8OfmkfbtMk539eggMcezWzYGzqLXKYpgKS00ipbJx2UTS6Jfz8ceycyM
         AQnQWoul9ubGHYE2y4VlacfyVuzcnleSXFlPTzezDcNkRH7iIaaWD0EP/P64NdQP066s
         jtoisxKUvXFcSGa6nrfNshui7bSKBCiXLQLurYXVhYrCYZCwImDukZ19j+OSRZk0gcfx
         zg0g==
X-Gm-Message-State: AOAM530v8G2t7UeAWx+hNa40wt2/vK8zxi7wlbez8NWHj36KJeWSbGpo
        tJl9zZYQAl2g8LYDwPY5yWyIO02QxIEn8Gl9FxQ=
X-Google-Smtp-Source: ABdhPJzsbxweaLb3PeIq0ZgtrnX/SUHcUw7bZeFQH523s6o7TXXrg5JBgMmvN3W4NlKC8VWr6BuZsrO3TJ4kQB0FxbI=
X-Received: by 2002:adf:f241:: with SMTP id b1mr3485684wrp.248.1605273749327;
 Fri, 13 Nov 2020 05:22:29 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
 <20201113122440.GA2164@myrica>
In-Reply-To: <20201113122440.GA2164@myrica>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Nov 2020 14:22:16 +0100
Message-ID: <CAJ+HfNiE5Oa25QgdAdKzfk-=X45hXLKk_t+ZCiSaeFVTzgzsrw@mail.gmail.com>
Subject: Re: csum_partial() on different archs (selftest/bpf)
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        viro@zeniv.linux.org.uk
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 at 13:25, Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Hi,
>
> On Fri, Nov 13, 2020 at 11:36:08AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > I was running the selftest/bpf on riscv, and had a closer look at one
> > of the failing cases:
> >
> >   #14/p valid read map access into a read-only array 2 FAIL retval
> > 65507 !=3D -29 (run 1/1)
> >
> > The test does a csum_partial() call via a BPF helper. riscv uses the
> > generic implementation. arm64 uses the generic csum_partial() and fail
> > in the same way [1].
>
> It's worse than that, because arm64, parisc, alpha and others implement
> do_csum(), called by the generic csum_partial(), and those all return a
> 16-bit value.
>
> It would be good to firstly formalize the size of the value returned by
> the bpf_csum_diff() helper, because it's not clear from the doc (and the
> helper returns a s64).
>
> Then homogenizing the csum_partial() implementations is difficult. One wa=
y
> forward, without having to immediately rewrite all arch-specific
> implementations, would be to replace csum_partial() and do_csum() with
> csum_partial_32(), csum_partial_16(), do_csum_32() and do_csum_16(). That
> way we can use a generic implementation of the 32-bit variant if the
> arch-specific implementation is 16-bit.
>

Folding Al's input to this reply.

I think the bpf_csum_diff() is supposed to be used in combination with
another helper(s) (e.g. bpf_l4_csum_replace) so I'd guess the returned
__wsum should be seen as an opaque value, not something BPF userland
can rely on.

So, for this specific test case, it's probably best to just update the
test case (as Eric suggested).


Cheers, and thanks for the input!
Bj=C3=B6rn
