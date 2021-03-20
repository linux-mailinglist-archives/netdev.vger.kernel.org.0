Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41452342F55
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCTTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTTmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:42:25 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA55C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:42:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id z25so16142222lja.3
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVgAWw1YOr1g8Gf6SRPp2z7AA76SRYSgDFeMcq5+XRk=;
        b=d27AXJ3F2hzODjs3FGKrs1zzMMkbDWhFucO4aywXQXJM0JMSqZeoBFygnG1+BpqIHq
         3vLfWpJioMsTbwmY5xpxA8uFyOrjCct/ugbX4GQNicAqkaWyXkokmv8FTJp7ENkZHY4n
         FcSbp4jqG9i9ST8BTWnF38aLT5LiaBIzqT5po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVgAWw1YOr1g8Gf6SRPp2z7AA76SRYSgDFeMcq5+XRk=;
        b=NqPq2DOSJu5LTjXlk4pzDxG5ru2A7JMcrH/Axhstq0juA38/qJ2tixvYMB4W9mKZUC
         goTr0vekPRLhy1BgsuH+xBCSKJNchnlxrcrfeESMkvqiAQvbUjZNDp95CQGxTM/uDCg/
         UAy/yqEUPjDN6yczKp4ZUXC8PzLmLpZzaVXytDBaLLlxYdJdW0EhZFTFcPXdF1w3tdol
         JT9VLs2Vj7+mOgjdBw97osf8qrzfU7A2TdSL1MqMIwznCX/tkPg9hBygUm11ka047o0n
         Jv+BvHuIdGfrFroySV14sngAxQ1nIvGcHrXz7NrF1wWOfmDmIYjduL5fWjA8RUBIlSru
         QUfA==
X-Gm-Message-State: AOAM530hwt5Ez3D4gX5YX4iJe3ll7mvozEqLzyb65b0jR/Xt59b7LsPp
        romwE4Gci1Pw3Nw+bK1mUeB3G6awjo1D9w==
X-Google-Smtp-Source: ABdhPJy3ouaApJ2WsSbL841vnno/ZVeNrbPCdfVzqctqjuByzvZHf8rWTwcg1luIcre4ec6e3bHsPg==
X-Received: by 2002:a2e:9107:: with SMTP id m7mr4559468ljg.379.1616269343604;
        Sat, 20 Mar 2021 12:42:23 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id f9sm1248700ljg.115.2021.03.20.12.42.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 12:42:22 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id f16so16201423ljm.1
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:42:22 -0700 (PDT)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr4521968ljj.465.1616269341975;
 Sat, 20 Mar 2021 12:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210319082939.77495e55@canb.auug.org.au> <YFTJdL1yDId+iae4@unreal>
 <65e47dcc-702b-98e0-2750-d5b11a7c0ae1@pengutronix.de>
In-Reply-To: <65e47dcc-702b-98e0-2750-d5b11a7c0ae1@pengutronix.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 20 Mar 2021 12:42:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgmL3qJhjnoG1z9kH-N0RokWOHATRjPyLWGx=U7Ar-1qA@mail.gmail.com>
Message-ID: <CAHk-=wgmL3qJhjnoG1z9kH-N0RokWOHATRjPyLWGx=U7Ar-1qA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 12:28 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> Good idea. I'll send a pull request to David and Jakub.

I don't think the revert is necessary. The conflict is so trivial that
it doesn't really matter.

Conflicts like this that are local and obvious aren't really
problematic. Any maintainer pulling git trees will have seen them and
is used to them (admittedly probably me and Stephen more than most,
but still).

The conflicts that can be pretty painful and might be worth worrying
about ahead of merge time - or at least let the maintainer/me know
about loudly when you ask them/me to pull - are the ones that might
not even show up as a file conflict. The conflict might be purely
semantic rather than some simple "changed lines next to each other"
kind of thing.

Often even those are trivial, but they might fly under the radar. Many
of them cause build issues (think "changed arguments to or renamed a
function" on one side, "added new use of function" on the other side),
but not all do, And even if they do, they might do so only under
certain configurations and architectures, of course.

And occasionally there are conflicts that are just so *big* that they
are painful to work through (things like renaming variables and moving
code on one side, and then non-trivial changes on the other side).
They can look particularly scary when you see the conflict diff, but
on the whole it's unusual that it's a real problem. I reasonably often
ask people to verify my merge "just in case", but it's seldom actually
a big issue. I don't remember the last time I actually went back to a
maintainer and said "ok, this looks too nasty, please actively help me
out".

In fact, the most common conflict problem is not that the conflict is
_hard_ - it's that some coding patterns are just _annoying_ when they
cause conflicts.

Things like big whitespace cleanups across whole subdirectories get
_really_ old as you're working on the fifth file that has a conflict
due to the same silly syntactic change.

But something like this that just removes the
MODULE_SUPPORTED_DEVICE() thing that basically never gets touched
anyway, and we happened to be unlucky in *one* file? Not a worry at
all.

                   Linus
