Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE01348E09F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238099AbiAMWps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiAMWpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:45:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD38FC061574;
        Thu, 13 Jan 2022 14:45:47 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so6363411pjl.0;
        Thu, 13 Jan 2022 14:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4RRqBrmw4TBe6Qmao1QkNx5bovUudrxDbFnqUSc0p4=;
        b=d+AMNGi3pmM56Gw2ANsf4dVZkxxu9gTZDnubAuMgpsTG1TYyOSubjwAIJj3gchZ4gI
         0B77/wPoI6sJdx0dYzH9e+lPKGTrWqDi6uyscCT0NnwL12r9kMf7UvNqXJap9Ww9h00X
         ++eNBUvCUuailZefL6xUS4zuY/+i3LJ2umXQPcvLL5HwHhiKShI/TzgHyVvAtT9o+ZSK
         EV02hfsBZNw7tUb03GMWe5SwiQU5xrCuj5K+pvBnluwXB33LxlPrTMAfibhBsOZOmd2P
         oGea+Ra0tvVuvCYZOfjqrRNi6jwwrixOt69WwOVKo/qnSAZsLEczPsUnUk+MGwTjlCJC
         V5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/4RRqBrmw4TBe6Qmao1QkNx5bovUudrxDbFnqUSc0p4=;
        b=fFrph2ERd2e+6lFzehpoRYBhTLYqkgWHu+KU6hNW/GVTwMGeFv0eGh4xLPiaYInnGh
         pqN6tkyXaeQZ7rr/cMKByISdBdS/JtNAqdEOuOtiuTN/uqM92IHlLf8OJjFY8kHKlVMv
         waSfiRIT0Bo8xhOPiAaCbL/NSqgzhImjrNR67sXg/7XQCP/6VKiaCmCUY8MlpCONyzxC
         2n3KNJxQigfhnhREfzZhhGEsfbofHNyCyrw8wnoXSBWLaaeGGpwYHEP55HDz0+LqdXbq
         iTOw9VjGpdsztHWLjsR4Vue9M+WcxorfGVq1Gc3IRmvfeeq0ufYDNuNRlv4WZgVWh/ft
         mGsA==
X-Gm-Message-State: AOAM532B6ztdSeDHShCQMLXruKT2QUOR2of4si6pA8rMtvfG9d+IqC12
        eaZgW7qGrLfU0WadGlnNhIwqdgnGoJcquF7uHyk=
X-Google-Smtp-Source: ABdhPJyxLxthKpfUVIlwPxInPsYgz0dcn/oER61I63Kniua6f0bKm2UEhXy0QS1Rmwj+6QC6d9YSVxj1zeyLuLfEOK0=
X-Received: by 2002:a17:90b:3a82:: with SMTP id om2mr7541963pjb.138.1642113947224;
 Thu, 13 Jan 2022 14:45:47 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
 <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
In-Reply-To: <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jan 2022 14:45:36 -0800
Message-ID: <CAADnVQLF_tmNmNk+H+jP1Ubmw-MBhG1FevFmtZY6yw5xk2314g@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 4:27 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Alexei,
>
> On 1/13/22, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > Nack.
> > It's part of api. We cannot change it.
>
> This is an RFC patchset, so there's no chance that it'll actually be
> applied as-is, and hence there's no need for the strong hammer nack.
> The point of "request for comments" is comments. Specifically here,
> I'm searching for information on the ins and outs of *why* it might be
> hard to change. How does userspace use this? Why must this 64-bit
> number be unchanged? Why did you do things this way originally? Etc.
> If you could provide a bit of background, we might be able to shake
> out a solution somewhere in there.

There is no problem with the code and nothing to be fixed.
