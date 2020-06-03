Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062301ED46C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgFCQdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 12:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCQdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 12:33:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F4DC08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 09:33:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f185so2771052wmf.3
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 09:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WK1Dm9kkaYUF6/octhmR4rBS5sG33VkFkNsRP9u2CtA=;
        b=lw0yAODA0xIWhqgtVB0m+vQc329Cp3pOurs+TCUG/pQ7rxUNanhGGkLVFLxqpau881
         VD7sMtANuNk+TA40kNWnG+OkLQl6FU0v/baW5GHbpwXaJiET4aubnoMqZun2brMimJhS
         XEgfDo8XwcWK5Xnp10tFZ1aHj/VAJqMSq38AZAhr6FUrS9DDvastL/zwSDWMJGOhuGmE
         oe2KA5IusFKv5DzusOY0Dc+UBZXrnnxqfVwaaN8f4tvPN1X4e3wqaShrVhunW2+XeQ8h
         YDcp4/VPGvJ6W+28DlTlh2Vv8SoQMWQD+ctp39f736dORD+zb0dcqiyxiTIkWsW646Ft
         i8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WK1Dm9kkaYUF6/octhmR4rBS5sG33VkFkNsRP9u2CtA=;
        b=LaEF7UKQC2hujE9waMHTNU3OI7w/mrLtrRbV1Iz1ldsRUkBExAYPPo1RnNQKK7hFD9
         e8O8XM5McwNkR/4UsEjSrlUtCd8QN7bof8M81MOZ3F/n56vPOsyuRjFzmIHSVyy8Kpfb
         KwhlDDBoME/bglxy/djcxnr6JI2YxxGlKnI4mQ0z3l5X+0ZhXkMifxMFozrRdBdXVPMC
         sSrfuj42pbUO/Rl1hd4rJLFIsA8U+WzRfwBHNKhAlxksivVZvFen8KrajGkSkx7ebqYu
         nJxAYxPRs6FKIQglLKk0DAbwDKFibIXltpQxFIgRsKQwMHyx8wYG/mzcjFkTjYTAkSuB
         VgFQ==
X-Gm-Message-State: AOAM530V3lNrLIpFZbTDGmphDXPhyKxU0esZufXza6xhMFRc8snKYkz8
        ZKYFJ8Afd4ADHWQFbr8dF9QGVhnMUl54vBVHVVrC8g==
X-Google-Smtp-Source: ABdhPJyNyHsy8njUzRiy5xHTiIUKce0eF75Do+olbf6Ho4kWqL/5IJ6xGgUZAfrqTbVFEfZV0dkw3GzwPoC0woaqid0=
X-Received: by 2002:a1c:ba0a:: with SMTP id k10mr16425wmf.81.1591202031822;
 Wed, 03 Jun 2020 09:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com> <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
 <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com> <CAG_fn=XR_dRG4vpo-jDS1L-LFD8pkuL8yWaTWbJAAQ679C3big@mail.gmail.com>
 <20200602173216.jrcvzgjhrkvlphew@ast-mbp.dhcp.thefacebook.com> <91a115bb-24d3-3765-a082-555b5999bb42@solarflare.com>
In-Reply-To: <91a115bb-24d3-3765-a082-555b5999bb42@solarflare.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 3 Jun 2020 18:33:40 +0200
Message-ID: <CAG_fn=X-ednJduk3k6JEA9mMw+DrT3uSJ=+WY269gY6p45fJ0w@mail.gmail.com>
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 5:37 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 02/06/2020 18:32, Alexei Starovoitov wrote:
> > The target for bpf codegen is JITs.
> > bpf interpreter is simulating hw.
> > For now if you want UB fuzzer running in your environment please add
> > _out_of_tree_ patch that inits all interpreter registers to zero.
> +1 to all the above.

Noted, thank you.

> Also, note that you can still fuzz BPF JITs by building the kernel
>  without the interpreter: CONFIG_BPF_JIT_ALWAYS_ON.

Unfortunately KMSAN doesn't play well with JITed code. To be able to
detect uninit bugs in JIT, we'll need to instrument the generated code
as well.


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
