Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2488C4FFF9D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiDMTwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238464AbiDMTwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:52:32 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236852C116;
        Wed, 13 Apr 2022 12:50:10 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d3so1787299ilr.10;
        Wed, 13 Apr 2022 12:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Tiu9GfgkD+GsqRA+j44Yw5I46wY8QuomfzRtQUPRFo=;
        b=D5ENLHyIiXmfehIAfPvIzNbsh7FgNaxwTQ8E5JHc+qCJQekBE3jWYJG/5UGakpQYpt
         l9INOvekj/V4cZP6yRjHoUBs3DazVWY2KhnQ5QK9f7Ln/qUuxJE1IZ0faSXl1Di2Lbfe
         IhcYpML5tcE/4cXu4Mvsn3IOZqWVwZ+txDAjk+zFoMFHirVpo4Ld6ATJIi5aL4zXcAOv
         TO3YWwYuJRta8cc9uu9glKHyedWzM5Ch1XKyMWqhpI/tZ/19yfvZuivrC97s6rVAweaZ
         ewfdrUO9ndm9uFTZgmOn//KwW8sXPabDK21x0VGc8VjzfUnr9sNW2ElT5ijo7QjYwIpR
         Y94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Tiu9GfgkD+GsqRA+j44Yw5I46wY8QuomfzRtQUPRFo=;
        b=jYSBtq2x6KY9AVp1ATy8sEM7bmX9/aiYEyTJl4aYmf8Di8JIYukDNqXWHkV/6t8oud
         D7BNCE95Tgx1fqakYBqaceHdShkXn77O+zKHrazvivfxCz24eRD2H1vHpRrAIszRAILY
         SXj68yKX3Uwu4m9ymm5JAvnPHnjAMxD0cQmF1py+yIsmydOgV1O5hSzekhFTW1HJw8wC
         IaKcQ8kS3nyd7OkkDOTxyR0DyXSYFyFooR6JRTRYKvausM6JzwcPa1DP0RDkhMjluAU/
         sPQGiio4Wk1l4KuzNxkLDZOymVN7uOgIoS2hdF/w2pK/PtCwEXkTGNOS7A4SGwpPFIom
         q3xA==
X-Gm-Message-State: AOAM531FbP645W9eZRyKETAkPHWQNSwDbcgknIlYON78fImJ1jjuWkoD
        euV+0abokWwuqBYWSx/tkth72wxHRhGscXjCB5c=
X-Google-Smtp-Source: ABdhPJwJa9eBFjniQ9Fom7Jxfe4EKNMPTKbtvRYrK/n+O1jm5v8MlaDb9vDzHDgQaagvGqppkERZwtug8H7feDgfVwM=
X-Received: by 2002:a05:6e02:18c5:b0:2cb:cdca:bed4 with SMTP id
 s5-20020a056e0218c500b002cbcdcabed4mr2847853ilu.239.1649879409551; Wed, 13
 Apr 2022 12:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
 <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com>
 <e7692d0b-e495-8d3e-4905-c4109bf5caa4@linaro.org> <CAEf4Bzbb+AmuABH2cw=48uuznz7bT=eEMc1V9mS3GSqgU664Tw@mail.gmail.com>
 <bb29d766-f837-195e-63cc-15d02f155f2c@linaro.org>
In-Reply-To: <bb29d766-f837-195e-63cc-15d02f155f2c@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 12:49:58 -0700
Message-ID: <CAEf4BzbiVeQfhxEu908w2mU4d8+5kKeMknuvhzCXuxM9pJ1jmQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix KASAN use-after-free Read in compute_effective_progs
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:27 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> On 4/13/22 12:07, Andrii Nakryiko wrote:
> >> it would be ideal if detach would never fail, but it would require some kind of
> >> prealloc, on attach maybe? Another option would be to minimize the probability
> > We allocate new arrays in update_effective_progs() under assumption
> > that we might need to grow the array because we use
> > update_effective_progs() for attachment. But for detachment we know
> > that we definitely don't need to increase the size, we need to remove
> > existing element only, thus shrinking the size.
> >
> > Normally we'd reallocate the array to shrink it (and that's why we use
> > update_effective_progs() and allocate memory), but we can also have a
> > fallback path for detachment only to reuse existing effective arrays
> > and just shift all the elements to the right from the element that's
> > being removed. We'll leave NULL at the end, but that's much better
> > than error out. Subsequent attachment or detachment will attempt to
> > properly size and reallocate everything.
> >
> > So I think that should be the fix, if you'd be willing to work on it.
>
> That makes it much easier then. I will change it so that there is no
> alloc needed on the detach path. Thanks for the clarification.

Keep in mind that we probably want to do normal alloc-based detach
first anyways, if it works. It will keep effective arrays minimally
sized. This additional detach specific logic should be a fall back
path if the normal way doesn't work.

>
> --
> Thanks,
> Tadeusz
