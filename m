Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF52369721
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243307AbhDWQfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbhDWQfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:35:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCA1C06174A;
        Fri, 23 Apr 2021 09:35:00 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d27so21547177lfv.9;
        Fri, 23 Apr 2021 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Texo29/TAManixWJ0WLwhsj38WMAMERDoMBbLCNZrRs=;
        b=Pavjrow2GetlXZrtahcUnlxT8Ibu8JM7HztlkdWWSblArNXiA/NMEtgVbJkDa5sQ4A
         I19qWA7mCSu3s3yYTAByFZaKtTmpMtwDRQhDjClROAHXeublbrghiUGPvD6hjpu/3bTf
         1KNPTdZ3LSWuteJGCHzOjQo+1hP32qAVuZNsGAkj0at9jc9sqaV157Pcvmme4Fxjj32r
         Q97iqkAFaLiiVmuH9Ppc/37Iu5cYeK5A8TKQ4b0BGDy5o2qm3zNvvYpB03R+eGtgA2eq
         NT5eG7BqegDKJf80wZmSXhG5I6GxhDHn37ythipckH64X4hgGA2/cgY6QxdpN1zgmW9H
         lD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Texo29/TAManixWJ0WLwhsj38WMAMERDoMBbLCNZrRs=;
        b=MikvuBFgYY/670BetplLASYTHZxrV+DO0twHkYmubtpK9A3snFa9JbpgNMJGewC01b
         cV/jM71utplz6FuAEQ8QSxlhKoRppkjMsQZ4tsQN/NdMzANWRd9R1fHnx8Pmrfpf7H1s
         aeyirqmd81d6OJSQTy2u84+eu+AW6BUdkOifrsRWkOIfGnbE5hzmt3lrkFHiJruIGDNk
         yYmEPNBDSM0MJ0iNqtSgYtn1vyn2BvGurqddP+4orDxIhy1A8VFuguVVIMcYXoW8I37U
         HIX6sDssH9x4Ku7gv5zY3A7oec65QxWFnl5GT5CWb7HjBQ8vnMh9qQZukukGWiCsyQNH
         nOCQ==
X-Gm-Message-State: AOAM530ZR0PfiHUilrw9J4xyt4NRrUFwM3nYAtSPqFnwdRBEGjhIWtOK
        mFg1mc2OragSeuFm5lwG9X+ssMO4NULcHpaq/X0=
X-Google-Smtp-Source: ABdhPJxaY9153E4/ZtO8A0lcVcCDSmnzIZB2iyLjD7BVsadneDP+561DExicnQt1gxJm2HypY+n9i2R+M6XqIJX+zeQ=
X-Received: by 2002:a05:6512:21a5:: with SMTP id c5mr3391182lft.534.1619195699156;
 Fri, 23 Apr 2021 09:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-11-andrii@kernel.org>
 <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com> <CAEf4Bzai43dFxkZuh3FU0VrHZ008qT=GDDhhAsmOdgZuykkdTw@mail.gmail.com>
 <CAADnVQJ_PS=PH8AQySiHqn-Bm=+DxsqRkgx+2_7OxM5CQkB4Mg@mail.gmail.com>
 <CAEf4BzYXZOX=dmrAQAxHinSa0mxJ5gkJkpL=paVJjtrEWQex4A@mail.gmail.com>
 <CAADnVQK+s=hx1z4wjNFp5oYqi4_ovtcbGMbkVD4qKkUzVaeLvQ@mail.gmail.com>
 <CAEf4BzY8VZyXGUYdtOCvyLjRGGcuOF07rA1OJPTLpRmEat+jbg@mail.gmail.com>
 <CAADnVQJe-5sPyRxWnOwSyVyudkFo-WC2TgxXaibiMRM=54XhgA@mail.gmail.com> <CAEf4BzZbaOv0UoGF3Vwim94EgLtkTWtVYnDeuhfEbWkK9B1orw@mail.gmail.com>
In-Reply-To: <CAEf4BzZbaOv0UoGF3Vwim94EgLtkTWtVYnDeuhfEbWkK9B1orw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 09:34:48 -0700
Message-ID: <CAADnVQLkXhui3K2O4v4u1gfMVXzBdEtfuUixPhnb=n-BdUbH9Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 9:31 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > >
> > > static int remap_type_id(__u32 *type_id, void *ctx)
> > > {
> > >         int *id_map = ctx;
> > >         int new_id = id_map[*type_id];
> > >
> > >
> > > /* Here VOID stays VOID, that's all */
> > >
> > >         if (*type_id == 0)
> > >                 return 0;
> >
> > Does it mean that id_map[0] is a garbage value?
> > and all other code that might be doing id_map[idx] might be reading
> > garbage if it doesn't have a check for idx == 0 ?
>
> No, id_map[0] == 0 by construction (id_map is obj->btf_type_map and is
> calloc()'ed) and can be used as id_map[idx].

Ok. Then why are you insisting on this micro optimization to return 0
directly?
That's the confusing part for me.

If it was:
"if (new_id == 0 && *type_id != 0) { pr_warn"
Then it would be clear what error condition is about.
But 'return 0' messing things up in my mind,
because it's far from obvious that first check is really a combination
with the 2nd check and by itself it's a micro optimization to avoid
reading id_map[0].
