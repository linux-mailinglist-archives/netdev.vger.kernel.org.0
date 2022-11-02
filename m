Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E0961716E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiKBXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:10:18 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE8E658F
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:10:17 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id l9so113293qkk.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 16:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zE0kVQMhsKgnJAXV7culWIr2zj+2e0F5QP+AlSJYD+Y=;
        b=dOV0aaoUE3p9Hy61orb7bJZTfU2WsUVnpXr/iauN/Z+XQgYlGCt+M+YZmHhgYm9moj
         MitOzjtGguR6/KmO1vxd7HJtIorAeU22lhxkFAA+bVJ0XSZvuTBxE1sDoeOV5FQD2TS1
         AuT7D/bz13frTlIaq/GCHDUwGY099YbrH4M+U5omCpCCK7GvE6ZapiQmSWfsWunmcXDM
         yawhV9iiDAEWQb+pmEmOF31y8+HlQlIkC5qOdzuny+/UrWbGCW9eOws1TMn1iQCUlldS
         dVDzU6h50FRWtZveuLg8POHyK0zimg2RcvuAl/uZarfc3hS0Z46NHpACbLKfIQDf24/k
         tVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zE0kVQMhsKgnJAXV7culWIr2zj+2e0F5QP+AlSJYD+Y=;
        b=PLF3PM5kTnserMFWTPb/hakTYBWsIAexUG1ToVz8ldXQQeLnGoGDfLUCZlicwQXvzN
         VlphrKTpEWi++JQHUs95MXCLwkBHE3r/heGh9NPeAcIq9GD8Rn4TCSv9wBrMt/Lq89zE
         3ByBjFW+zQiyi1/kco32O1GTEWNvQvM8m533hJ8+HvPMf702qiTKE+EvbT4HPw+fE1jr
         yV7GjdbtTIWBwaWLiEqi9Tr+6z8MgjAkXpl49qNiIVaFsiQ81LdopjkVnn72Sy475fn1
         HPWc0oL6rdXoOZaV3eI+XfXUjcotVivlgI/IHGdi/Vbmwjn2FuTLlTaoQYa40SQvgguH
         Fs5g==
X-Gm-Message-State: ACrzQf1Dr7dAP4UgA18p3lqKI3+/IRC7ph7rcpCIHYWuGAXK5rRLRXYG
        MjqIDqNYWubd1mIfZounMwdEtq359z8=
X-Google-Smtp-Source: AMsMyM4sXCPasEcXNiSF9BFXXAEgCdn/1Mpu4RB7AuoU/rphVfSL067LixHmhVl0YZAC+0dj1nEFhw==
X-Received: by 2002:a37:88a:0:b0:6fa:a3e:45d with SMTP id 132-20020a37088a000000b006fa0a3e045dmr19670595qki.346.1667430616261;
        Wed, 02 Nov 2022 16:10:16 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id b8-20020ac86788000000b003a540320070sm2443163qtp.6.2022.11.02.16.10.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 16:10:16 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-370547b8ca0so1005827b3.0
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 16:10:15 -0700 (PDT)
X-Received: by 2002:a0d:d897:0:b0:36a:fc80:fa9f with SMTP id
 a145-20020a0dd897000000b0036afc80fa9fmr26054201ywe.43.1667430615534; Wed, 02
 Nov 2022 16:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221030220203.31210-1-axboe@kernel.dk> <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
 <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
In-Reply-To: <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 2 Nov 2022 19:09:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
Message-ID: <CA+FuTSd-HvtPVwRto0EGExm-Pz7dGpxAt+1sTb51P_QBd-N9KQ@mail.gmail.com>
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 1:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/2/22 11:46 AM, Willem de Bruijn wrote:
> > On Sun, Oct 30, 2022 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Hi,
> >>
> >> tldr - we saw a 6-7% CPU reduction with this patch. See patch 6 for
> >> full numbers.
> >>
> >> This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
> >> time that epoll_wait() should wait for events on a given epoll context.
> >> Some justification and numbers are in patch 6, patches 1-5 are really
> >> just prep patches or cleanups.
> >>
> >> Sending this out to get some input on the API, basically. This is
> >> obviously a per-context type of operation in this patchset, which isn't
> >> necessarily ideal for any use case. Questions to be debated:
> >>
> >> 1) Would we want this to be available through epoll_wait() directly?
> >>    That would allow this to be done on a per-epoll_wait() basis, rather
> >>    than be tied to the specific context.
> >>
> >> 2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?
> >>
> >> I think there are pros and cons to both, and perhaps the answer to both is
> >> "yes". There are some benefits to doing this at epoll setup time, for
> >> example - it nicely isolates it to that part rather than needing to be
> >> done dynamically everytime epoll_wait() is called. This also helps the
> >> application code, as it can turn off any busy'ness tracking based on if
> >> the setup accepted EPOLL_CTL_MIN_WAIT or not.
> >>
> >> Anyway, tossing this out there as it yielded quite good results in some
> >> initial testing, we're running more of it. Sending out a v3 now since
> >> someone reported that nonblock issue which is annoying. Hoping to get some
> >> more discussion this time around, or at least some...
> >
> > My main question is whether the cycle gains justify the code
> > complexity and runtime cost in all other epoll paths.
> >
> > Syscall overhead is quite dependent on architecture and things like KPTI.
>
> Definitely interested in experiences from other folks, but what other
> runtime costs do you see compared to the baseline?

Nothing specific. Possible cost from added branches and moving local
variables into structs with possibly cold cachelines.

> > Indeed, I was also wondering whether an extra timeout arg to
> > epoll_wait would give the same feature with less side effects. Then no
> > need for that new ctrl API.
>
> That was my main question in this posting - what's the best api? The
> current one, epoll_wait() addition, or both? The nice thing about the
> current one is that it's easy to integrate into existing use cases, as
> the decision to do batching on the userspace side or by utilizing this
> feature can be kept in the setup path. If you do epoll_wait() and get
> -1/EINVAL or false success on older kernels, then that's either a loss
> because of thinking it worked, or a fast path need to check for this
> specifically every time you call epoll_wait() rather than just at
> init/setup time.
>
> But this is very much the question I already posed and wanted to
> discuss...

I see the value in being able to detect whether the feature is present.

But a pure epoll_wait implementation seems a lot simpler to me, and
more elegant: timeout is an argument to epoll_wait already.

A new epoll_wait variant would have to be a new system call, so it
would be easy to infer support for the feature.

>
> --
> Jens Axboe
