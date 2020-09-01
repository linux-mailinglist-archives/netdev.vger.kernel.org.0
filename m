Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C06258B73
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIAJ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAJ0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:26:39 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3190C061244;
        Tue,  1 Sep 2020 02:26:39 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x14so555170oic.9;
        Tue, 01 Sep 2020 02:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=mLIgB74gTmTBxvCD4+rjK9R9eU37V+0RvNz3rrSN+Bg=;
        b=htPVOCgose3zitvb3KTmY/Wpl9HNzcXKAGaZxxvlOwxU+1Y7ypTVwVBCc6jftF7IRc
         Jqyn+c62Fwg1A74hwuuoX7efl3ouXh5u2Pdafp+UMZyP/ZgZ+86n4973iO14YeNkHv0C
         /NMUmXtEao0+RRFA9ji/l5audwSHuRhjHDY5TnsajDnrzXjMJVLJA0F7svMo/fTofI58
         Io0i/h1GuosYhRu8KGvwpx/y5OosmTckbEy67uGaQkoJoeDoGxRkminYmGIM6qY7LC3P
         ZceCjaf7AWYgw4SED+NTd5NJqNPxkp6A/a5Dweku5WmGFbP/JTiQUN9u8toxpm+SeTCh
         Qa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=mLIgB74gTmTBxvCD4+rjK9R9eU37V+0RvNz3rrSN+Bg=;
        b=JNQpgeLzyBQRiT6sd+XPnhPSBYWg3k38FHeOwpKZJtdJgbjczzZUjqCJFn41YgTtnU
         yzEoFqKCwSLS8FlpZxu01X2W4ZGT7RwKy5neqRmg3GgjaiTex7c2+whdDuwQ9DTpKRBW
         Hwig35A+DVnJrium2B6IBfhzru7o49KBf3fNtMzUJTjG17+67iN3W76B15fs1Stf6QNx
         XFxde6KQwT3aTY7JB+ZJuTFB8yZ7iB3DA2mLWd9QYP6+qKn7PwW/fo1kLFUBGI86+g7k
         g9QkPA/qT4JGz/yDBHdmVz1CtauGbgmGNPMVri6uHQUgzvdU9wv6qbX50hTtudhvPPuv
         d/3A==
X-Gm-Message-State: AOAM531Hc24kTdgx7owk8lfBY5pJqW99T6RleIVZD2Kv05HfNKhB8qoa
        mrk7KxRBIB7gqY7PyBhIeOKkhTjVJfqQI6v25d8=
X-Google-Smtp-Source: ABdhPJyqGnqt75BAUsAk746/IfyZkBmLYNOB3Ag1tlE5bn+XzKh2hBxRfU2QQEWRK9Lxejnbo6vmXzZlhelElxDILPc=
X-Received: by 2002:aca:ec50:: with SMTP id k77mr524120oih.35.1598952398562;
 Tue, 01 Sep 2020 02:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
 <CAKQ1sVM9SMYVTSZYaGuPDhQHfyEOFSxBL8PNixyaN4pR2PWMxQ@mail.gmail.com>
 <20200901083947.GB901@1wt.eu> <CA+icZUXjDaoLG36X7Jd7i6=Ncf6xTm44qL7ZV+i7pmNgtLuJSA@mail.gmail.com>
 <20200901085658.GC901@1wt.eu>
In-Reply-To: <20200901085658.GC901@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 1 Sep 2020 11:26:25 +0200
Message-ID: <CA+icZUVh89QScwNYc18qzh+UWpvn+L49cvt+OHmw-55OvAEW_A@mail.gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Yann Ylavic <ylavic.dev@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:57 AM Willy Tarreau <w@1wt.eu> wrote:
>
> On Tue, Sep 01, 2020 at 10:46:16AM +0200, Sedat Dilek wrote:
> > Will you push the updated patchset to your prandom Git - for easy fetching?
>
> Yeah if you want, feel free to use this one :
>    https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise
>

Thanks,
- sed@ -
