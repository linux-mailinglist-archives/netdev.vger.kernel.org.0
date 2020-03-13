Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7766185310
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgCMX7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:59:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36165 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgCMX7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:59:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id m33so9228348qtb.3;
        Fri, 13 Mar 2020 16:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/H3qCw5rKkhc7/u/0Gpl73eALsRiZGY9Q2zkIT3aD7k=;
        b=KOX66hhPDpePl/uar3NHsQQ2sK55/WBMle6ZvT3cDR217nY7mngYfkz+gDrvxQap24
         ZGN7Rjy9rEErfKFv370ZlDr+noLqEDjleiQsgYNCLDpgAbnQafQmSnuk7qMJ7a8emkRt
         AnB6DaKz8luExYqLi9Q45f57qva0ctTTzPQV4z1wiYEYrgpK7dJXLp29+AApLzkmNT01
         W5PrzDljvcCQ48nfGLGtz7t/wyvM2u1SIGSzmMmZoErzTlLw30Wyq8oilMN26wVvkhqC
         2uLwaNG+Tog+X60C7KO2NKwI9crAm6LAQWfd6VrYKrcAzRCsJ8+0ncB6k/wigydVePtQ
         g3vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/H3qCw5rKkhc7/u/0Gpl73eALsRiZGY9Q2zkIT3aD7k=;
        b=OYRArR6i1Yf9YsTrZ4fytaCCpH1pIgdJz0gFKkD9wan9Nbrm7m9Vxg4Oe1FHRfSlTu
         sCeLrXaPzWnC/0CWXY4K9v22XoojcCaAmpdHbmGjl+sC1NFhH7gqitA4oK0zHabFrath
         gaakedx0omulo1qmV1mAsB0tMU2NDr9XTUFmeQvnkC8wWGvzmbKFh1D3x+Eh94+gvU+U
         83nKsv2FZC81X3b4XuADUVCAe6x64tzz2bwE4DhCKBM7Z4ediSQGkNZ0P4JhS3T2KUGp
         K+5rQxGshOEwT495UftyPI3T/3jHplDDcp4LfdWofrlnj88OhDiqLUD3cnOcA2A/ECwC
         sLPQ==
X-Gm-Message-State: ANhLgQ2Iv1mnsA35e37J72kBRlfBimzC0FkE+flIrtCCUnR/k4xRSPNB
        9qB4S//Sqd2UWEJ96WYfmJC+ExS5kjLTyZrfD9w=
X-Google-Smtp-Source: ADFU+vsyEAe3+8v9uyQtRyutAIb9Pv896L6zWdqMlGCGaaprefwydl6ZHmrXut1cup6LGaGUJCyenND+DmZL9wd/I4M=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr14999818qtj.117.1584143941238;
 Fri, 13 Mar 2020 16:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200313230715.3287973-1-andriin@fb.com> <20200313235309.34matqh7iaahawkf@kafai-mbp>
In-Reply-To: <20200313235309.34matqh7iaahawkf@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 16:58:50 -0700
Message-ID: <CAEf4BzZ5htm+SV9aJpa8fkzQ2LSgoWZLFTK-AOSMj6r-70mXEg@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] selftest/bpf: fix compilation
 warning in sockmap_parse_prog.c
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 4:53 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Mar 13, 2020 at 04:07:15PM -0700, Andrii Nakryiko wrote:
> > Cast void * to long before casting to 32-bit __u32 to avoid compilation
> > warning.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/progs/sockmap_parse_prog.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> > index a5c6d5903b22..a9c2bdbd841e 100644
> > --- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> > +++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> > @@ -12,7 +12,7 @@ int bpf_prog1(struct __sk_buff *skb)
> >       __u32 lport = skb->local_port;
> >       __u32 rport = skb->remote_port;
> >       __u8 *d = data;
> > -     __u32 len = (__u32) data_end - (__u32) data;
> I think this line can be removed.  "len" is not used.

hm... never checked that, I assumed compiler will emit warning about
unused variable... v2 without this line is coming...

>
> > +     __u32 len = (__u32)(long)data_end - (__u32)(long)data;
>
> >       int err;
> >
> >       if (data + 10 > data_end) {
> > --
> > 2.17.1
> >
