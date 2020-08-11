Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58992419F3
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgHKKv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 06:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgHKKvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 06:51:55 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4570EC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 03:51:55 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id h16so9727230oti.7
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 03:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=UhlzAn4lpRrPkvaXfcTT/BOQCiRqfEE8LdsClAKhmAM=;
        b=LHLZp8IbHwDDGUjN8Y+RVrJXUEfCYDg1x+2Ds+fma8J+426mrrNJv8NZeQvtMyYB4H
         aAV8ReOwJrr2GoQlwkRwQLIldPGiQsG1DYfIrldOXtk4D9lmf/9Jb2GcKK7tw/ZLyC8j
         uPc1F7uatd+PtmzyQA/8JcGrieXkgSQJR9v9csGwELuVdpEl5EcE85WCFA3ECyQftuJ9
         IxpbhGUdx2NykMaPrQCvNOkDpQdjt5rMzDkw4tUlfAm3j2R6On1wyibgVCM8c9gpd0WU
         rgnCnnt0BP1TBentnAv8F1li0SEYVhUwUtclXaDNg4PGVYeNoWygKub9M9kt7yfHVhfZ
         Qjdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=UhlzAn4lpRrPkvaXfcTT/BOQCiRqfEE8LdsClAKhmAM=;
        b=Tz1R4Xv5LTLRw6yWU7g5cRgh1E39/JG9cGRdwPh9G+BAItqjAU6u8xl5Uihw6FB1mJ
         zPRJqZD8Xv+VB91sjybDSB4vIbQj86nwn5YfeZk3ZcULgLvD6zEj+WrT5nDYH5yNGlCk
         nYb4QpvYPuhcN6iv0JWVePnS9v3H6i2k9pbNbxvuztr+0cXzBxApfBwvCdzbwoiwQ1xG
         D3uOvowYYyKq7DZ3egDLpTl7csaCXy/FP/uRTsEJa6fC0gojAncX+9JOPQslAza/+gjT
         gAfSoVJXwXlrfeKlJgP9wwT8PqssB926INYYgMdBReP7zyCC06PkbJgZCQ+gqfYGHJ3D
         KFLQ==
X-Gm-Message-State: AOAM532HxpqCFcKn2fsG9crFQGf2snM7ks6s77Qu4zXXRUxAEDohzFJG
        FeuDN1SXXAkqGn6R3bKxOMagGjD3Q9qtWqMiueQ=
X-Google-Smtp-Source: ABdhPJz+BGd/7ig6kGHwKkEEbZ9XdMMcVll4WZJr4RT0soV9HxD2l0QM2X0gK6v6IQNbxxQSa31Vhh3anQEkxqZwwB8=
X-Received: by 2002:a9d:7997:: with SMTP id h23mr4680839otm.28.1597143114714;
 Tue, 11 Aug 2020 03:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu>
In-Reply-To: <20200811074538.GA9523@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 11 Aug 2020 12:51:43 +0200
Message-ID: <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ CC netdev ML ]

Hi Willy,

in [1] you say:

> I've applied it on top of George's patch rebased to mainline for simplicity.
> I've used a separate per_cpu noise variable to keep the net_rand_state static
> with its __latent_entropy.

Can you share this "rebased to mainline" version of George's patch?
Maybe put your work "user-friendly-fetchable" in one of your
<kernel.org> Git tree (see [2])?

Yesterday random/random32/prandom mainline patches hit Linux
v5.8.1-rc1 (see [3]).

So, as I asked in my first email what is a suitable base?
Linux v5.9-rc1 (this Sunday) or if stable Linux v5.8.1 (next 1-2 days)

Thanks.

Regards,
- Sedat -


[1] https://marc.info/?l=linux-netdev&m=159709355528675&w=2
[2] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau
[3] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/log/?h=linux-5.8.y
