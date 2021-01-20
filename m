Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F522FD843
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbhATSaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404668AbhATS0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:26:34 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8396BC061575;
        Wed, 20 Jan 2021 10:25:53 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o10so35381227lfl.13;
        Wed, 20 Jan 2021 10:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bUKZ5BdNuXPwc8JBYX62se5lkjjXXlegt5r2v6pGujs=;
        b=KRKLju2pVx/375rqf/GkBTTo8/nLC/kAc3nObqSY4Yi6AY5nmqqEcMWKqiAYs3pqTC
         LGrnQoZnVIAHleDV65Bq7iMndVeDAsQep0hZeVjtOZsk1rPZkbIEYFZdCZshbbKrD7If
         GvYgVyk+aFwMsBnM04BG5PSAooQnnqbJw0rkjIMAYJMYeJyf7kzWcW/qOZjbWFFWZTyY
         Uzql9STwWdLqJRa0RL4jsAJ5O1L3D1+uzQsqi7PLYwsp62eTS/sDdoAA9C7JQ6sUNMR8
         FWsqGxKwpcibxZkCkz0a0aytzYJ3z+/lOy5V1KNQ3tZ+3Yzv4rdL/jHBRj1pJfbIjLWp
         IcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bUKZ5BdNuXPwc8JBYX62se5lkjjXXlegt5r2v6pGujs=;
        b=kITC5VaZDbDOZTweWzF+rt88Lg0UfuctAUKoE5fNEZpg5J+9GXaoYu74ouwMv6GYJM
         8aroKRQHjqqNjVTEiHFCg8AdFTmcsOG4bPnt0ax/YFcXBzn5dmdl3oKjXcSv7FmlMY74
         RfInvAF7gfu7Kzs1Y9N3b7/JOmgOKakbWpnsM5VHaKB9/opICD2UK2ckiBq3UyYT4GH9
         uYOsTMeimYN9orcugmLoPHK0rR8AnOYOfTQi8QoZ4v6fKnj3CeLzq22WR8vpo/qqrkE7
         FexyxVocvWTBrck+gYrlPXJgTGg0u6HJek+badpi6I5/qCIBKHDWv4RIStTk9owiQKA3
         8TQA==
X-Gm-Message-State: AOAM531swNGe9LLJmznSWSonNzk8rFo/0HS6GL8MdNG+5H37OYIQUxxr
        hFkARZy/mttif6+6pxgcPWaiqmWSPLVcIUeS3lc=
X-Google-Smtp-Source: ABdhPJxt3nUdxzr3WSDZVvNE9diZlmRIVDsz9F62MQtv97WfMKW8wUwVNq1EXsa1f0bPVNQk3ud38CtcU1b2cgHdRYA=
X-Received: by 2002:a05:6512:34c5:: with SMTP id w5mr4875982lfr.214.1611167151940;
 Wed, 20 Jan 2021 10:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com> <6cda7383-663e-ed92-45dd-bbf87ca45eef@intel.com>
 <87eeif4p96.fsf@toke.dk> <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
In-Reply-To: <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 10:25:40 -0800
Message-ID: <CAADnVQK1vL307SmmUZyuEAmy9S_A2fJwyHryCHBavQ-QDNyxww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        weqaar.a.janjua@intel.com, Marek Majtyka <alardam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 7:27 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.co=
m> wrote:
>
> >> Would it make sense with some kind of BPF-specific "supported
> >> features" mechanism? Something else with a bigger scope (whole
> >> kernel)?
> >
> > Heh, in my opinion, yeah. Seems like we'll finally get it for XDP, but
> > for BPF in general the approach has always been probing AFAICT.
> >
> > For the particular case of arguments to helpers, I suppose the verifier
> > could technically validate value ranges for flags arguments, say. That
> > would be nice as an early reject anyway, but I'm not sure if it is
> > possible to add after-the-fact without breaking existing programs
> > because the verifier can't prove the argument is within the valid range=
.
> > And of course it doesn't help you with compatibility with
> > already-released kernels.
> >
>
> Hmm, think I have a way forward. I'll use BPF_PROG_TEST_RUN.
>
> If the load fail for the new helper, fallback to bpf_redirect_map(). Use
> BPF_PROG_TEST_RUN to make sure that "action via flags" passes.

+1 to Toke's point. No version checks please.
One way to detect is to try prog_load. Search for FEAT_* in libbpf.
Another approach is to scan vmlinux BTF for necessary helpers.
Currently libbpf is relying on the former.
I think going forward would be good to detect features via BTF.
It's going to be much faster and won't create noise for audit that
could be looking at prog_load calls.
