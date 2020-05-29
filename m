Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667C01E78CE
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE2Ixd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgE2Ixd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:53:33 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05040C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:53:33 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id k22so1323470qtm.6
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0uCL+dWXPjHkQQZSfru5+7sAxG7iZAUYBQ1L3TRneQM=;
        b=dAqVaDOIsJpz/fMeqjPJlVeRAjsfFc+W492ul6luDVy/dTKLvVHJ6Kpd/IrKKXW0KE
         9JjsXNcWv8APSWeo3IMt9Pn7EzY7C+0by0FK9C6zzWm/44A8q1m74gprVUreGxl1lSdr
         HI/uxFphzIOa5d4uoggb1dlkFuP0syGMKrC3grKou/9qoQBpAmPFv9dHEM8UUkrCwLCW
         39vpnEhSZ8bkWoHAJ/YoZ2vKOjNUek5ohiP2RNv60HBT3LYUYSjxncINlREKN2bw+w02
         Xl8NLjJJSxZcmhhjVjPHkOLteza3qAOTYEEva8pPu7id1sFw1iI2I+RIIgOYZ7kbFkyE
         YqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0uCL+dWXPjHkQQZSfru5+7sAxG7iZAUYBQ1L3TRneQM=;
        b=HyPTVYaFdxqcxB7ZUL58JgVHZy2moqdhVEPqSXCsaM9WJORc8tS+DCE1GVKpgBeEgq
         jDCjbCnwmQO0Y4+4/BUkj2piEe+OhbDX4ZTFi4sKXD28DM1NWCtb7tB5kmuEqwvRfKrt
         klth/9GWoFirpLf/wsYWEJZn6rMN+yTPcP7kmzQlExKdc73UujpC1tNNFCoz6EXHyu5e
         Qn9ZfblPN0jG0Kdc6XWGOp0FOEo6PldvhujqYI2Lx1nfjADpFDRKbj0IDfTkp/xHCkcz
         M07c3cwpSxJpu57FBWXY1Q2KIS5E3BIXmAszOSGdc0cEQP2IV3zdJoHyKpFp0jJeCOOg
         QMng==
X-Gm-Message-State: AOAM532y+nRDIIMwaI1tQGuOZB5JWH4+1CqFEvMU8r51RP47WpSamdlS
        YT5CTGRYwLHkZYNX13IiMuhXRQokYj8R+6u8sfn8jg==
X-Google-Smtp-Source: ABdhPJygRhIOj2kA/PknCONKEsDYic44Z26KuALdf+JDnzGLitFajEVeGVmHhriYRTgokRn3mXFGU6DWYlKvnXUkkyI=
X-Received: by 2002:ac8:36c2:: with SMTP id b2mr7131479qtc.257.1590742411915;
 Fri, 29 May 2020 01:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz> <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net> <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com> <CACT4Y+bZjRL7LoDhXUrcGWNBYzEWQEq0Mbpzqj6+cP_0nDGWGg@mail.gmail.com>
 <69a77196-60c6-6cc4-abb9-6190b7c016dc@solarflare.com>
In-Reply-To: <69a77196-60c6-6cc4-abb9-6190b7c016dc@solarflare.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 29 May 2020 10:53:20 +0200
Message-ID: <CACT4Y+bs-eiJQQjofAAo0oLNPzosOmhMuJOLHP0sShQScGKX7A@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 10:46 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 29/05/2020 07:14, Dmitry Vyukov wrote:
> >> (In C99 it gets subtler because an 'indeterminate value' is
> >>  defined to be 'either a valid value or a trap representation',
> >>  so arguably the compiler can only do this stuff if it _has_
> >>  trap representations for the type in question.)
> > Interesting. Are you sure that's the meaning of 'indeterminate value'?
> > My latest copy of the standard says:
> >
> > 3.19.2
> > 1 indeterminate value
> > either an unspecified value or a trap representation
> Yes, but (from N1256):
> | 3.17.3
> | unspecified value
> | valid value of the relevant type where this International Standard
> | imposes no requirements on which value is chosen in any instance
> | NOTE An unspecified value cannot be a trap representation
>
> > My reading of this would be that this only prevents things from
> > exploding in all possible random ways (like formatting drive). The
> > effects are only reduced to either getting a random value, or a trap
> > on access to the value. Both of these do not seem to be acceptable for
> > a bpf program.
> A random value, XORed with itself, produces 0, which is what we want.
> (XORing a trap representation with itself, of course, produces a trap.)
>
> So it'd be fine *unless* the 'in any instance' language can be read as
>  allowing the uninitialised object to have *different* random values on
>  separate accesses.

Ah, I see. I thought the result of such XOR is redefined to be an
indeterminate value rather than UB.
Thanks
