Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC68269143
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgINQSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgINQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:17:00 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF029C06178A;
        Mon, 14 Sep 2020 09:16:52 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id c13so453762oiy.6;
        Mon, 14 Sep 2020 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ZaZZqacCDA7oXtm//wcKDDOo/3GMN+o9Qri31drCCNY=;
        b=KDPADuN7sgN/H3qQhT8j9VnWJODEPaZsmTPIcGxPaBo6rYW0M8NvhKwJ5MAs/3V+SS
         aINw+7oVh2lqilrsOaj3DUq883Gf+0koNWpY6VRJi1GI31oIL+QkVBpCqs12ssFD+j/D
         zgW+1aROsUUIgtHyCf2nFByMV/syL9pyQ/TlcCq1R3lm21S88e9PHDQxB9dzZvBwZI2V
         uxgaKsEAz7ggMkvM0tGLLLqAT6/fVl7nNQ3120h18qyrvDxYYXcPBivgjPIv8cgp818y
         qfva7as4FDH1guCOFqYfCk0HmlLHFNXdMqaQ+sEadFnndjNT4gjh5Dyg1u94poMxWOFW
         REDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ZaZZqacCDA7oXtm//wcKDDOo/3GMN+o9Qri31drCCNY=;
        b=FoxOLYYKyCReZmtWH0W2qAg7FCtDhg/jCjYJzUA4SDI8QHTxKdOjSYHNUIeFVXsI+V
         KyyhEM6H7oldaVYUZ8RtYjeP29TQblFKH8A4aKDdxTehxjL/trq9voXY0VUGyWE0qo1v
         bbTLh1r7Ux24o6oSYGHIkEL1F6om+CW5IR7jd4zQdwPpIMSiTJt1vAYbaoGO6XlEuip5
         oBwALD+e+2NCRZuBqFhVPXjc1aWUNEd5/xazoLbGJj4PmH3fSOcitmUPVm1Bk/8noPdD
         4a+ejSsl2DRW+j7WZetZ5pA48MMiO81SIeLSDSfCkrWlkEf5vULgtC2haj+Fbh2QhkrL
         IUcA==
X-Gm-Message-State: AOAM5334RyVkQH9OdTPMsY5k4K9nWqpBru2xDhoil2MHPLMmGZWEHvgC
        tXraCSALB6DaOeJSRzEyLKEDJDrBwBPOdCOEpPA=
X-Google-Smtp-Source: ABdhPJw0AH9qtuaPrhz2Yb6lSzCjGlx3LPzihJTQ+wosCraP/j9VN3J50rwZNcsB1cM9u+eHfC2fe+D09//UnMjiZ/E=
X-Received: by 2002:aca:ec50:: with SMTP id k77mr92502oih.35.1600100212390;
 Mon, 14 Sep 2020 09:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
 <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com> <20200901131623.GB1059@1wt.eu>
 <CANEQ_+Kuw6cxWRBE6NyXkr=8p3W-1f=o1q91ZESeueEnna9fvw@mail.gmail.com>
In-Reply-To: <CANEQ_+Kuw6cxWRBE6NyXkr=8p3W-1f=o1q91ZESeueEnna9fvw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 14 Sep 2020 18:16:40 +0200
Message-ID: <CA+icZUUmQeww+94dVOe1JFFQRkvUYVZP3g2GP+gOsdX4kP4x+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
To:     Amit Klein <aksecurity@gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tytso@mit.edu" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 4:53 PM Amit Klein <aksecurity@gmail.com> wrote:
>
> Hi
>
> Is this patch being pushed to any branch? I don't see it deployed anywhere (unless I'm missing something...).
>

It's here:

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise

> Best,
> -Amit
>
>
>
> On Tue, Sep 1, 2020 at 4:16 PM Willy Tarreau <w@1wt.eu> wrote:
>>
>> On Tue, Sep 01, 2020 at 01:10:18PM +0000, David Laight wrote:
>> > From: Willy Tarreau
>> > > Sent: 01 September 2020 07:43
>> > ...
>> > > +/*
>> > > + * Generate some initially weak seeding values to allow
>> > > + * the prandom_u32() engine to be started.
>> > > + */
>> > > +static int __init prandom_init_early(void)
>> > > +{
>> > > +   int i;
>> > > +   unsigned long v0, v1, v2, v3;
>> > > +
>> > > +   if (!arch_get_random_long(&v0))
>> > > +           v0 = jiffies;
>> >
>> > Isn't jiffies likely to be zero here?
>>
>> I don't know. But do we really care ? I'd personally have been fine
>> with not even assigning it in this case and leaving whatever was in
>> the stack in this case, though it could make some static code analyzer
>> unhappy.
>>
>> Willy
