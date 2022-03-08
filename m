Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B679B4D243E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350729AbiCHW1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350767AbiCHW1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:27:10 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C75758818
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:26:13 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id l2so622707ybe.8
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 14:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQq3SynHbfzQIPYNpHUBmUwyHOpCXtYVid9TkLiPR84=;
        b=E32rxw7TwTeERB6Hx9tI93nh9RhodTuf08u4JMSLpFnTRwa5HB/QUkia6t0hSg8CmC
         qg0X6//kY3vOukaS2O3j1/esFs2h6zNz9BCS3Q2IsxlaUzGF45wNig1XYSytmxl1HExp
         /DXaTIzKkxjghiz51Ly8IfVpM8jHAewmNPi71YltNCQspq9ul9FsfogA+Y91PIJSF4WB
         yiv2RitaWdOL0X+RkTtwPAo3pvbRjRn/yD9clJ1VHL58G2NM93NnCa7+e+WDV7Kk66aM
         h/qWrtoIrTZvqCiPAJgafdU6S/l0OkzcxQnHsrtWA2glngwBUfuTWfBXKjfBkC896VaY
         82tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQq3SynHbfzQIPYNpHUBmUwyHOpCXtYVid9TkLiPR84=;
        b=TXgOY+KYpMnT+sqDrK+dS3oAhodRQ7vu3P/Uw2yFg0iMtPyP+vKzYwZV2AhDBLEgRk
         k/Y9wAjUE607M5sKf1WBf+iRZHf6rX6bd/HyPYZSZZr1bVAn6cE+mYwmxw1i/iEwvV6t
         8u3RHP73pjCz4/rcJgUQOEKtmAzUj//05q3pI8bQGDnuzoZpDbMSM6+YMB37fndFhcI9
         /UkECpu45Ra65tcXRvRxdnaHohzk597QHVAXEU9conryqFFfbs5DaTCToo2loagMRvuy
         pW51S/cP062AY3X5Oo1uhm37ayXEM11syTsac+M///0AOxJ3LaTelBWacm2Pwiw+11S6
         Updg==
X-Gm-Message-State: AOAM533MJxMZYl1vyzlj0kWAId4cqk2mMcnm3p2Zvx9e9Ya1oJIHwQc5
        8/rwpJfi//WIxPHnoH7nPIU3oIN3jIDUwXLDqAeRGA==
X-Google-Smtp-Source: ABdhPJxdFmHSXXiq2p5wb8jOLNSlAFnQZfQbcB1N5/vvNpwKaIJOcWtim+yYBSZr022nArIozxcAkKA1xlEUFgt93/w=
X-Received: by 2002:a25:d9c7:0:b0:628:be42:b671 with SMTP id
 q190-20020a25d9c7000000b00628be42b671mr14210828ybg.387.1646778372203; Tue, 08
 Mar 2022 14:26:12 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org> <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com> <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
 <218fd4946208411b90ac77cfcf7aa643@AcuMS.aculab.com>
In-Reply-To: <218fd4946208411b90ac77cfcf7aa643@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Mar 2022 14:26:01 -0800
Message-ID: <CANn89iK9AoGsXDhoFKY5H_d-tZ7QGv4qjsyk6MZnd9=aZxHuog@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 2:12 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 08 March 2022 19:54
> ..
> > > Which is the common side of that max_t() ?
> > > If it is mon_tso_segs it might be worth avoiding the
> > > divide by coding as:
> > >
> > >         return bytes > mss_now * min_tso_segs ? bytes / mss_now : min_tso_segs;
> > >
> >
> > I think the common case is when the divide must happen.
> > Not sure if this really matters with current cpus.
>
> Last document I looked at still quoted considerable latency
> for integer divide on x86-64.
> If you get a cmov then all the instructions will just get
> queued waiting for the divide to complete.
> But a branch could easily get mispredicted.
> That is likely to hit ppc - which I don't think has a cmov?
>
> OTOH if the divide is in the ?: bit nothing probably depends
> on it for a while - so the latency won't matter.
>
> Latest figures I have are for skylakeX
>          u-ops            latency 1/throughput
> DIV   r8 10 10 p0 p1 p5 p6  23        6
> DIV  r16 10 10 p0 p1 p5 p6  23        6
> DIV  r32 10 10 p0 p1 p5 p6  26        6
> DIV  r64 36 36 p0 p1 p5 p6 35-88    21-83
> IDIV  r8 11 11 p0 p1 p5 p6  24        6
> IDIV r16 10 10 p0 p1 p5 p6  23        6
> IDIV r32 10 10 p0 p1 p5 p6  26        6
> IDIV r64 57 57 p0 p1 p5 p6 42-95    24-90
>
> Broadwell is a bit slower.
> Note that 64bit divide is really horrid.
>
> I think that one will be 32bit - so 'only' 26 clocks
> latency.
>
> AMD Ryzen is a lot better for 64bit divides:
>                ltncy  1/thpt
> DIV   r8/m8  1 13-16 13-16
> DIV  r16/m16 2 14-21 14-21
> DIV  r32/m32 2 14-30 14-30
> DIV  r64/m64 2 14-46 14-45
> IDIV  r8/m8  1 13-16 13-16
> IDIV r16/m16 2 13-21 14-22
> IDIV r32/m32 2 14-30 14-30
> IDIV r64/m64 2 14-47 14-45
> But less pipelining for 32bit ones.
>
> Quite how those tables actually affect real code
> is another matter - but they are guidelines about
> what is possible (if you can get the u-ops executed
> on the right ports).
>

Thanks, I think I will make sure that we use the 32bit divide then,
because compiler might not be smart enough to detect both operands are < ~0U
