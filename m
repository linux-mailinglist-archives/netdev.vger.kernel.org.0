Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436554D0DA5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243635AbiCHBq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiCHBq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:46:57 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139173B03B;
        Mon,  7 Mar 2022 17:46:02 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id c23so19366920ioi.4;
        Mon, 07 Mar 2022 17:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZF3jjml8gHoMGe/6ujoxgmRuAgN0wrADO7T1ytoQlCw=;
        b=WfcMeNLdh4Pm+mt6ab76xkmpVLwakCh08SPuKJhzRR4vwpmZSdGTIiafqxoNDPaHO3
         GEZzI2JImi7am1z3beqwCXFsm2G9yWKDxuc6bT1BoThkuZtFn1AIHYNokSNR0LUJ4oZb
         Hihyh6+9yAhOne86xB2lsVhVeQii8IIFy6jhzIgGGWrH6e8iFfgVveE73rba5fbOEien
         98M/Vv4sJbAKskC0+LOIn+zKMlala9hvmUiniLpvFw9etlsa0hi3muZTJIp8kiXojOVY
         iEBzZIGUdZCuw/K9X5hTict54hwHhbbWdd/H6kd7KkqGar9nNYfSG+0j+zibsjii4Ygj
         /Zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZF3jjml8gHoMGe/6ujoxgmRuAgN0wrADO7T1ytoQlCw=;
        b=dPCA/J+Wrbywfv+Kyk7YyY2phKiQjXrfpmYNV4OepZhgkgx56lKkjYyXbjNCMa9kWJ
         wcw5XtsImy+byhFpl3CAvt9KxdDVtAkVYuub1GMXwBFhVg1e2135Thi0AzSnvX6mOKIA
         0ecScCW8fPBiA3Am+SSuBmx695YJ2MIUEOJEaee2MdBxhrw/J5MzLV/bOwKQba51XaoO
         oHcyOZxl3X9ufEcCYc64JcoUG9tQO4yhSKFfe4p0LYFbWzRfFQMZQdGYsbmo/NUmQ6eA
         ii0V+Lh/8qt4u73KSs20ksQmUU7NaxR8QT0ZG9VfyBn5HgKxvrjZEwK5GZfxvqUNaETO
         Lqjw==
X-Gm-Message-State: AOAM530nVLt+J/u45qmjp1Hj/Dtpltjdw+n3sXTmiOqCv6kXDBFUFIK9
        nrP7T1rSLmuAP6n9m6+ahRrc2z6dJ1mhp23pIM0=
X-Google-Smtp-Source: ABdhPJx0orrM+20oBeADOwU18aKBO3V3a93TYoZX0f/+kDgglPAtC+Sps9jWcJHtEYImZHBzKSZ5ZqvZySWSupVuJBE=
X-Received: by 2002:a05:6602:1605:b0:644:d491:1bec with SMTP id
 x5-20020a056602160500b00644d4911becmr12567959iow.63.1646703961520; Mon, 07
 Mar 2022 17:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <CAEf4BzaugZWf6f_0JzA-mqaGfp52tCwEp5dWdhpeVt6GjDLQ3Q@mail.gmail.com>
 <20220305200939.2754ba82@yoga.local.home> <20220306103257.fcc36747bf6a689a24c91d59@gmail.com>
In-Reply-To: <20220306103257.fcc36747bf6a689a24c91d59@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:45:50 -0800
Message-ID: <CAEf4Bzak7JADnf=bp92LGBGefKt=nzvLB49=weNTv1A3B5fSzg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add kprobe multi link
To:     Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Sat, Mar 5, 2022 at 5:33 PM Masami Hiramatsu
<masami.hiramatsu@gmail.com> wrote:
>
> On Sat, 5 Mar 2022 20:09:39 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 4 Mar 2022 15:10:55 -0800
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > Masami, Jiri, Steven, what would be the logistics here? What's the
> > > plan for getting this upstream? Any idea about timelines? I really
> > > hope it won't take as long as it took for kretprobe stack trace
> > > capturing fixes last year to land. Can we take Masami's changes
> > > through bpf-next tree? If yes, Steven, can you please review and give
> > > your acks? Thanks for understanding!
> >
> > Yeah, I'll start looking at it this week. I just started a new job and

Thanks, Steven. Greatly appreciated!

> > that's been taking up a lot of my time and limiting what I can look at
> > upstream.
>
> Let me update my series, I found some issues in the selftest.
> I'll send v9 soon.

I haven't checked, but if you haven't based your patches off of
bpf-next tree, please do so in the next revision, so that we can land
your patch set and Jiri's patch set on top without any issues. Thanks!

>
> Thank you!
>
> --
> Masami Hiramatsu
