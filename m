Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F97553EDC
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355010AbiFUXDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355022AbiFUXDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:03:43 -0400
Received: from mail-pj1-x1064.google.com (mail-pj1-x1064.google.com [IPv6:2607:f8b0:4864:20::1064])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADD917E1B
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:03:41 -0700 (PDT)
Received: by mail-pj1-x1064.google.com with SMTP id cv13so11671565pjb.4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=48KAdNirHEv4RkT4Y2Kkn02In+bwoIBN5NSUht1OZRU=;
        b=pbLjupiG7nFUCQNqrDqwoAyQI8BfLcGFZrwgsEgyXphzI615dKsAfZqd8swf3sbWAH
         pJWk331tp/eldSWGxehn67s8gdQn9SdRUhoujYQDLwfmZEWHE8hdnCDDaRGWueYRSESN
         L2BQOlKz9lnj6qQkEDFScanlnoiFw6UIXYPg/82mBGksatv5kcfjbKViRK+yI3teSluv
         5YgHCxLmss8spK6MkP/jfS9XfBsTtFQRIIqQr8HOtFtYQ/rGxhgYVgIkWrsXQ5AA6uuS
         EnjJanOZDymg72VNIbfFDAyjRvwAfy5x1wY8Oyi8d1ESChEXVkTmM/Zobdm0aHlmjywu
         lWrw==
X-Gm-Message-State: AJIora/NLnmAuIvodJBEMbSGCphnEqi8CwbbC9igz42YRUlUUM8BX9xB
        Hv/Tsu4wpb8Ik0rulIQnj2Ns2yUUvXII2ak/Eypg47gAQDppIg==
X-Google-Smtp-Source: AGRyM1tXmMUztOkatDev7dcd7prU9uF84Umtd9H5Z7IdzN1YdEN2YpA1Mg8YG0iZsOQ0ahTYS1XRlxJI8tSb
X-Received: by 2002:a17:902:c40c:b0:16a:252c:ec82 with SMTP id k12-20020a170902c40c00b0016a252cec82mr12695366plk.5.1655852621409;
        Tue, 21 Jun 2022 16:03:41 -0700 (PDT)
Received: from riotgames.com ([163.116.128.203])
        by smtp-relay.gmail.com with ESMTPS id a1-20020a170902710100b0015e8d4e8690sm1023226pll.92.2022.06.21.16.03.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:03:41 -0700 (PDT)
X-Relaying-Domain: riotgames.com
Received: by mail-qk1-f199.google.com with SMTP id u8-20020a05620a454800b006a74e6b39eeso18007190qkp.12
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=48KAdNirHEv4RkT4Y2Kkn02In+bwoIBN5NSUht1OZRU=;
        b=kBimiMtzGauaXSvCkt7GgQTWwj+GP7yn/VNJb1Vx36GxhxEyrYuFiJXD/S/hr9ftJo
         QNaL21c7eiLtUwGVK+C+fPQEo6rRdoipqaVitnU5R12StEbE3Itbidm7HEoKUsDvBMR6
         iCKRgxwgYF3XyjV0z1ry5AHmV6uwicX5pRkN8=
X-Received: by 2002:a0c:fe48:0:b0:462:6a02:a17d with SMTP id u8-20020a0cfe48000000b004626a02a17dmr25915825qvs.108.1655852619393;
        Tue, 21 Jun 2022 16:03:39 -0700 (PDT)
X-Received: by 2002:a0c:fe48:0:b0:462:6a02:a17d with SMTP id
 u8-20020a0cfe48000000b004626a02a17dmr25915786qvs.108.1655852618955; Tue, 21
 Jun 2022 16:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220603041701.2799595-1-irogers@google.com> <20220619171248.GC3362@bug>
In-Reply-To: <20220619171248.GC3362@bug>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Tue, 21 Jun 2022 18:03:27 -0500
Message-ID: <CAC1LvL0rZcEHe_ZHDcB38XD49FmdURg4+yKHP0O=J7=4Xx8M3Q@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuze Chi <chiyuze@google.com>
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 19, 2022 at 12:13 PM Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > From: Yuze Chi <chiyuze@google.com>
> >
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
> >
> > static bool is_pow_of_2(size_t x)
> > {
> > - return x && (x & (x - 1));
> > + return x && !(x & (x - 1));
> > }
>
> I'm pretty sure we have this test in macro in includes somewhere... should we use
> that instead?

I went looking for a macro that provided this check and could not find one. I
did find the inlined static function is_power_of_2 in log2.h, though, that we
could use.

> Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
