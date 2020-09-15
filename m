Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0785126AB7E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgIOSH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgIOSCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:02:36 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1F6C06178A;
        Tue, 15 Sep 2020 11:02:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so3621883ljk.8;
        Tue, 15 Sep 2020 11:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LzBv6m1vPIL7/RF8uYFkuOR2dwzIsUMdUh6iBcqPluI=;
        b=ejQlfQPcLifvN49urcdE4CMTzVJFXphkZdhL3jg/MjKwpaHywIma22I996/7Lj6Dz0
         Z3MoR6ewUMCQzyxMRNqKBWA0CaXl9Kg5bSXAqpF+qymVNeHuxCynyHLZSGt894vCOaLr
         +nbvUvDOHlICO8iEvKfzFa1VvrPrsrZqQ0xu57qzCej4TXrmKtgTNK3CBdehnz1Yad8m
         E2a8JTpizIf0gfK0AN6ntAXuth03Dmk/Sf4kMcRv+a0/P8rSz9yZtMDakDfI4581CONP
         nhGtVUEFqqNBkjmkWNglbF1fByuEFKdfNeFvebemixKUMSu/QX6rexv18UlUL/bEbF7Y
         TdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LzBv6m1vPIL7/RF8uYFkuOR2dwzIsUMdUh6iBcqPluI=;
        b=pyELWw2xpAu5pZ9kWE2WS/yPZaApcNGHIZn+mjzUXu1h3A6me2pQFV+27e8Z4Wf8X7
         /sNlgDNxCVClnjrGxOV4A9Ayk6rnXM044fGobzAEyeekVQkVrVLNu6dAGrzRHpyfM4Vc
         5DlDeT6LZjISmsKtFnyNWkbta1d0vSmG/J/XccCv4nV4hgA4etbm9rlXTbaDPOh8YVPD
         e80BjAYEDB+YsXelDPIgNLD6X5HHQ1F+pfT9DO4a0q3Gn5x1fyIzPh60X+vy2W8gjSxI
         CPwxFDHtk5Ap86/EpQ2Urpf+XL10+xSN6FPVmfADdeIEPPwyxzLh6LgJLxwDzenS0F5o
         KUfw==
X-Gm-Message-State: AOAM532as0NP/b9AuKftHFggvqlR733Q7K1xUSC4vY5Vg/nLd79llRwk
        t/TLExsgbWtNVi4KxDXsF7JrOAgQkkRw9QHntjw4wvqq
X-Google-Smtp-Source: ABdhPJxNNC7peE5ca7c1t+3nBX3Ern1zKf1FTCJMjcvEzV0VZjC4bLYL77PxoVyFBD/A3Atnn6Dr8avv3W9r9It0Tjo=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr6927289lji.290.1600192939198;
 Tue, 15 Sep 2020 11:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
 <20200902200815.3924-8-maciej.fijalkowski@intel.com> <20200903195114.ccfzmgcl4ngz2mqv@ast-mbp.dhcp.thefacebook.com>
 <20200911185927.GA2543@ranger.igk.intel.com> <20200915043924.uicfgbhuszccycbq@ast-mbp.dhcp.thefacebook.com>
 <20200915174551.GA3728@ranger.igk.intel.com>
In-Reply-To: <20200915174551.GA3728@ranger.igk.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Sep 2020 11:02:07 -0700
Message-ID: <CAADnVQLz1UhmNQKX=+x3E=to8ZUrF_xZq_4b3R=Pr1O7ZtshCQ@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 7/7] selftests: bpf: add dummy prog for
 bpf2bpf with tailcall
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 10:52 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
> > > +   /* this means we are at the end of the call chain; if throughout this
> >
> > In my mind 'end of the call chain' means 'leaf function',
> > so the comment reads a bit misleading to me.
> > Here we're at the end of subprog.
> > It's not necessarily the leaf function.
>
> Hmm you're right i'll try to rephrase that.
>
> What about just:
> "if tail call got detected across bpf2bpf calls then mark each of the
> currently present subprog frames as tail call reachable subprogs"

sounds good to me.
