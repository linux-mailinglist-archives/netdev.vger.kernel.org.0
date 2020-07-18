Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5222484C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgGRDZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgGRDZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:25:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0E2C0619D2;
        Fri, 17 Jul 2020 20:25:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e8so14922286ljb.0;
        Fri, 17 Jul 2020 20:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fMNjCYx76NgDH0JPRAj+Axk91ii1cUqbHRWJHhVk2LM=;
        b=jS/v9P2ju1YHGb42/9AOpyx9C2HIHuvkUy0A1ntUWTyDG8oTdWRwYhChnNOklCEg9n
         9MoJ4Uh9VkZWQYyisqv+U5SQXGxgqDEARWgGnZAEbOxTTK2mZrPk1yUkXgwhjHzIVzhW
         2xm8OtH7+LVBONAxiTOeEq0mce3vTA/Uko9ady0lwEDaQSGjHyO6+8VOyJ4uDeNIU+5O
         Qq+NuIN4yjJYI5ptPeRzlVs6XNuy/XeG7nTnwWRgt8KNHK79ldYRd3ij7z6TPsEHhZKM
         /GKIJrKvNlcopAsw/1XtsQrn5EhKBhLa8WyB95wbEouiCxIBfOVQgAd30g5EfmXlLmVB
         tOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fMNjCYx76NgDH0JPRAj+Axk91ii1cUqbHRWJHhVk2LM=;
        b=hdIJxKPXczPl0jAs4ZJzOFnlsgKCzxMIw63qCFJoh2svEAay5jtCj1rRC5EGGbrSnq
         onFPz5YX1Z3yTE9uYZ8y03FM6dndv+EG1ZuAknd9u5VQwGU648ftO/hfmVe10wxWSOrv
         Q3AEXY5kiSU7V4Z+ioOxb3e+d5wrqc7+f9t23G0cuiTqKas0qCcDg6j2ZmFNA7KY7YZX
         1H6oZXRW5YrcAEkaiQZukhKvV++bS9pyoQN4Hts0rMkEjOI0BeNB7OZC0k9/YjASwNFF
         CauUYH0o+DpfmcXBH+z2FkiqIoCDWSSp4i6erBNqgCMOcKdu/iAk/k3gDZJtslCgTwL0
         nFoQ==
X-Gm-Message-State: AOAM5322OU6pYN6qmGh3+D2L74jA9XHbP3ynASW/hv39iBeLhg7/W3LN
        X8lP/7fJDGpkYwqX4BwCCsvDZCDaO6Xr6nDwwiw=
X-Google-Smtp-Source: ABdhPJyQBpp54ucoG02JF28lhl3q+6sD9kUJbQDsA/Vov4sKBGa8vj3bYpN5PVIFTrMvtfxYb3w4DX46lcedRKBixmw=
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr5883357lji.450.1595042721756;
 Fri, 17 Jul 2020 20:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com> <CACAyw9_6FGzFxN9OfhGpYLNFQafPb-t_mv5E6tc5Qpzm0nwmWg@mail.gmail.com>
In-Reply-To: <CACAyw9_6FGzFxN9OfhGpYLNFQafPb-t_mv5E6tc5Qpzm0nwmWg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jul 2020 20:25:10 -0700
Message-ID: <CAADnVQJD5U-gikMYa=LEjN0yOA2nH5SsT9-PF+o=sU1=f9_SyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/15] Run a BPF program on socket lookup
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 9:40 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 17 Jul 2020 at 11:35, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >
> > Changelog
> > =========
> > v4 -> v5:
> > - Enforce BPF prog return value to be SK_DROP or SK_PASS. (Andrii)
> > - Simplify prog runners now that only SK_DROP/PASS can be returned.
> > - Enable bpf_perf_event_output from the start. (Andrii)
> > - Drop patch
> >   "selftests/bpf: Rename test_sk_lookup_kern.c to test_ref_track_kern.c"
> > - Remove tests for narrow loads from context at an offset wider in size
> >   than target field, while we are discussing how to fix it:
> >   https://lore.kernel.org/bpf/20200710173123.427983-1-jakub@cloudflare.com/
> > - Rebase onto recent bpf-next (bfdfa51702de)
> > - Other minor changes called out in per-patch changelogs,
> >   see patches: 2, 4, 6, 13-15
> > - Carried over Andrii's Acks where nothing changed.

Applied. Thanks
