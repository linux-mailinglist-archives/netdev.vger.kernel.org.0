Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463CA20BB8C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgFZV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZV3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:29:09 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5CBC03E979;
        Fri, 26 Jun 2020 14:29:08 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id o4so5144199ybp.0;
        Fri, 26 Jun 2020 14:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O1Cr1Nu3UyTaQQFqq0CbyS7obrmuDqHeOtKDFb3CTEg=;
        b=sDElFdFwLGNbUMURMKdOe/GnDfnrsppGwHXRuqEY397HfBIM+A17GcFr233woO9Jzz
         b5szSGFjFUHmpRCbA4x/sFZASvpVUUPdzrK8nXZwwINTfHCCuUFY8aMMSvHwYgY40YXy
         QVZMf+KracsefYAOEoF6cjjUzpDqR0gyy3m/GGvh5nx62kAPqqtm13ZfDbqhZmldrjvv
         h7pgWTrQW2ITlElc/2HRpjokUpypE1dY06VMOYAiXhvXjrQXpgGzftFBpO0X4rwW+sGn
         y+u24cDmpxm7sbaCaBmLCzGXguzxFxKjNQ0dObKvmkNhGNn3uTSnJifAdEGCh+bgng+r
         vASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O1Cr1Nu3UyTaQQFqq0CbyS7obrmuDqHeOtKDFb3CTEg=;
        b=tC6QpzfnmyvIy34mf/4SArPxyebKewCrW5ekKOWwE25UoJzJoZ2oU2LgcfoeqlYesM
         IN6lCRV/SSRG0YLwwoJRd6KoJ3L/XPLDo7eQ2T8POlsqpKCRtIQhoxS77Dhhpd21AwkE
         tEJ/019AIPwMXFS/IkECtGm1RO8gFA5+7OCP3Hb2HfLpG5c2jZrt52UZL2+qeU+IIgZw
         AuIGLZKFZBMKUn6r+mJVY7skDJWRXt0q/wQ5s6W7hxTtNdHeOd8CiSs6e0OAUkMUrE0i
         eg6tfg6AkLI6jC276Da4TKG28IP0PqyqZAa276sdNtPeEfolbhz74HhtzagR4iELBG6l
         bb+w==
X-Gm-Message-State: AOAM533+jeIQ7DaBg47c1f1+ksm7PWxt+4K3nsPGOyC766IYCh219zT9
        BKuT1ouRYN0vNPGpwoyMEQyT2+/fteMHnbvdtQ==
X-Google-Smtp-Source: ABdhPJxY6hiAkqlRdesuucM6Y5RfjdKlGjWxj65UT+n3VRf6PHIOMyPRG9keJqAM/dxadi3OFuKhlxu59027YpnGV98=
X-Received: by 2002:a05:6902:1021:: with SMTP id x1mr8283076ybt.464.1593206948203;
 Fri, 26 Jun 2020 14:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-2-danieltimlee@gmail.com>
 <CAEf4BzbWboyWH1NzvDT8AHxUs4mEV9tBUOyksGgaJrN7QKJLXA@mail.gmail.com>
In-Reply-To: <CAEf4BzbWboyWH1NzvDT8AHxUs4mEV9tBUOyksGgaJrN7QKJLXA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 27 Jun 2020 06:28:53 +0900
Message-ID: <CAEKGpzhu+2=kiO6zRMMrBS6PAY4K=WhyOhso99axwHY5mw6Eng@mail.gmail.com>
Subject: Re: [PATCH 2/3] samples: bpf: cleanup pointer error check with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020=EB=85=84 6=EC=9B=94 27=EC=9D=BC (=ED=86=A0) 05:25, Andrii Nakryiko <an=
drii.nakryiko@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wr=
ote:
> >
> > Libbpf has its own helper function to check for errors in the bpf
> > data structure (pointer). And Some codes do not use this libbbpf
> > helper function and check the pointer's error directly.
> >
> > This commit clean up the existing pointer error check logic with
> > libbpf.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> This entire patch is wrong. bpf_object__find_program_by_name() returns
> NULL if the program is not found, not an error code.
>

Oops, I'll drop the patch and resend with the next version.

Thanks for your time and effort for the review.
Daniel

> >  samples/bpf/sampleip_user.c    | 2 +-
> >  samples/bpf/trace_event_user.c | 2 +-
> >  samples/bpf/tracex1_user.c     | 2 +-
> >  samples/bpf/tracex5_user.c     | 2 +-
> >  samples/bpf/tracex7_user.c     | 2 +-
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> >
>
> [...]
