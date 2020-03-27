Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75EA81961C6
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC0XLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:11:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39985 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0XLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:11:19 -0400
Received: by mail-lj1-f196.google.com with SMTP id 19so11927497ljj.7;
        Fri, 27 Mar 2020 16:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=13E8KOfNERpI6Jqei54Q/eY+o/HnkzH2AsrJB/HYb6Q=;
        b=jMOokhuZLPt1Nnko9Wa+2kqFvXS+JRETbPKiYahvM5gtOfYdMxXMW6OPtxcA/Rq3DV
         O3od7CUFHKzbqZCY3yjHk0SPvRs+wlY+lZxHZXZoHEXQOUoO4ZCxEualzYr/AhOod36D
         tKkqmruorO2MOlOYGp52VbR/8/I4wcWjz3ub52r0Dwd/laoh6r/jMRVJSz2vKYjozKTE
         toakK78xFuMzv3DqomChsZfhEa/bXGkRzRfwR4W3cGjGMBk0dzKSLXnXuUn9Fl3jPQDW
         qsG8BL3ttlifuyqrxfu3QzEp3AOCqUSV3Z2IEOfCmFoL1hlT+Z1RFD81EYbPHPoylrrk
         HFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=13E8KOfNERpI6Jqei54Q/eY+o/HnkzH2AsrJB/HYb6Q=;
        b=oH9ZILuJc/WigomKJm53hAYsc/fMPOn9PAjxSMpd55V2gyRzH2HayeSy9I1PCkPbpv
         dBmour66gFwBCIMfnvhewFc9OhfErFywGdTUue1umH3fYYlen0QqDvChDK9QGdjEhCFg
         C5pOzX3YfApslRTlBVfloldbWYOr2Jx1aGz9oOszGYmxZMI47rxeUQQGXFTyctnwDWMl
         +eeDldNfoYXfgIyOyDdg42FHonfY1bc11AmFzSXqLTaEBqgea3g+/9x4W0vGbmIsCnjN
         TR2UJY++7kAxqrdt0R4OP/P4vHY17imhd1TnXQX31EydviWmRq33+OCtYu287o1CQ5j3
         V4GQ==
X-Gm-Message-State: AGi0PuY3MkVdjGr3xXQS3EykDPs4047QbcM6PGtwg2VO9tmWHBCFWmlu
        IQkS8QEumTjfyJAf24mYujDceWCwVKmwMGzuXqo=
X-Google-Smtp-Source: APiQypK29PDLsrV9oArS12pDiX2aiqUnfXfsXIQY4EGhZAbiZgjUAlrcW+f978pVRkEkW+sbV7rrfNzeMDaOgcRD7SM=
X-Received: by 2002:a2e:9851:: with SMTP id e17mr660413ljj.215.1585350677285;
 Fri, 27 Mar 2020 16:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <20200325221323.00459c8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326194050.d5cjetvhzlhyiesb@ast-mbp> <042eca2c-b0c1-b20f-7636-eaa6156cd464@solarflare.com>
In-Reply-To: <042eca2c-b0c1-b20f-7636-eaa6156cd464@solarflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 27 Mar 2020 16:11:05 -0700
Message-ID: <CAADnVQJStoEcBD1BPS3hhmYVEWfbzbB-OWzXi8nsEPJWXueJeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 1:06 PM Edward Cree <ecree@solarflare.com> wrote:
>
> On 26/03/2020 19:40, Alexei Starovoitov wrote:
> > At this point I don't believe in your good intent.
> > Your repeated attacks on BPF in every thread are out of control.
> > I kept ignoring your insults for long time, but I cannot do this anymore.
> > Please find other threads to contribute your opinions.
> > They are not welcomed here.
> Given that this clearly won't land in this cycle (and neither will bpf_link
>  for XDP), can I suggest thateveryone involved steps back from the subject
>  for a few days to let tempers cool?  It's getting to the point where people
>  are burning bridges and saying things they might regret.
> I know everyone is under a lot of stress right now.

Same opinion a day later. No regrets.
