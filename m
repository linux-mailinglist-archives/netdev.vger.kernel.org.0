Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A300CDA6B
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 04:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfJGCYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 22:24:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46782 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfJGCYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 22:24:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so11181126qkd.13;
        Sun, 06 Oct 2019 19:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oQVDfdvpNuS9LR4+M9rlMhnhNaHXLejC2F/bb7MSgEE=;
        b=a4OhdPIxsRJdogOCym2L/I1Pyr+JQE1pHa9X1g1s78QKEgy5IYRMP98l37beHT3fmp
         +KgvSpY1RZI/6vzCZz25HIeBAae05KDjreapCmiTBhNVdl677epogwGfinx9uZJ/NfYL
         GLYI+30ybg9/D9jO87ISLpBDJFgyMLpUKrpqP8WoGV4cTOYcdKHP5wL7EpXRhubQrm0p
         Z92D6mOCjv6j/Fn3tHPNpZviJTGtkGvZkVb0TOJgI9NMHi+1cY4aQQAs1oFlQQbUoCbK
         2U6+sNBr+YZGo8RmnLP5T5aA3XkPrgLcYTT8tP8J831b4NcNfpx3QbHOcLkylZRysGqd
         tJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQVDfdvpNuS9LR4+M9rlMhnhNaHXLejC2F/bb7MSgEE=;
        b=X34VK1HHoOCPvAdvm407ArM2vdWHG5dGRH1gDzgFJ7rrWzYOcpDstf5Aw3nChxKRZY
         sfpI3zm5/gUmJhHWRl2pCus8ADe3+4P5M9EUbeQIuugeOHhywRaTTBaeFgfhu8wwkP/a
         Evb66YsRWUh9od5P7ViXElQKraoyMlOeumFtZ1jgqusud1gPk30Rkjr4m7ZsmZLVsFhm
         xHdBaLALG4OxSd8pTART2YtBO0xJ6lhYNow6lzb4TeHLHWF8DOkqK4/maICw1sUMJJBZ
         xLwtzZlQOcyEFdzmmEohWhP3YMJ/8BMaWkJgiR6SPGtlselvpBedbyqKoTLWA32OnJSA
         pGWw==
X-Gm-Message-State: APjAAAU6uJRAfo5GM14PQsh70IVmkmOpZ9QKzIKEgFLcUlQ+IlClDJKX
        Epp+TQtNIuMKFe1AIZXQvihHyfALbRwpPa+9R/8=
X-Google-Smtp-Source: APXvYqwt1V+qOGtXOZp6pXd5iquuU7ZgbCZ+nKAk8RaJ//dLCQHrx31MOiuVQHe5XlBEYk4zkRwY90vmrbjsHWjgb4U=
X-Received: by 2002:a37:98f:: with SMTP id 137mr22224385qkj.449.1570415074875;
 Sun, 06 Oct 2019 19:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191006054350.3014517-1-andriin@fb.com> <20191006054350.3014517-4-andriin@fb.com>
 <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com>
 <CAEf4BzZ5KUX5obfqxd7RkguaQ0g1JYbKs=RkrHKdDFDGbaSJ_w@mail.gmail.com> <CAADnVQJDFhqqxzFXoWxJk5KAnnfxwyZw-QGT+e-9mOUsGEi8_g@mail.gmail.com>
In-Reply-To: <CAADnVQJDFhqqxzFXoWxJk5KAnnfxwyZw-QGT+e-9mOUsGEi8_g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 6 Oct 2019 19:24:23 -0700
Message-ID: <CAEf4BzbGOyCa3OXFMQHmtwrC2uB3K0QFs3GBDeVt8PDDOAnSVQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 5:32 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Oct 6, 2019 at 5:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, Oct 6, 2019 at 4:56 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sat, Oct 5, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> > > > auto-generate it into bpf_helpers_defs.h, which is now included from
> > > > bpf_helpers.h.
> > > >
> > > > Suggested-by: Alexei Starovoitov <ast@fb.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  tools/lib/bpf/.gitignore    |   1 +
> > > >  tools/lib/bpf/Makefile      |  10 +-
> > > >  tools/lib/bpf/bpf_helpers.h | 264 +-----------------------------------
> > > >  3 files changed, 10 insertions(+), 265 deletions(-)
> > >
> > > This patch doesn't apply to bpf-next.
> >
> > Yes, it has to be applied on top of bpf_helpers.h move patch set. I
> > can bundle them together and re-submit as one patch set, but I don't
> > think there were any remaining issues besides the one solved in this
> > patch set (independence from any specific bpf.h UAPI), so that one can
> > be applied as is.
>
> It looks to me that auto-gen of bpf helpers set is ready,
> whereas move is till being debated.
> I also would like to test autogen-ed .h in my environment first
> before we move things around.

Alright, will post v4 based on master with bpf_helpers.h still in selftests/bpf
