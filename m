Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5216FE21F6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbfJWRmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:42:14 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35869 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731112AbfJWRmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:42:14 -0400
Received: by mail-lf1-f68.google.com with SMTP id u16so16808079lfq.3;
        Wed, 23 Oct 2019 10:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DZCbcR5Iy8/K2bF0tkHCyOQWDKeY6OQ5I8XUt1jrWCM=;
        b=YUs/2M2PHadXLRMoF7pOYzScYZGY5PCeCsacPCyueqtEj0qdNzM4Hr6KLafL5+NB07
         GZPx8D8QEvJLLeMKadbuv97D8R2zpdg0Ziauh0POYTa4DPFb380D6bfvf/LfcKADPWF/
         0qmN8vv+uAK24QP9PUMsMke4QlFhVSzinnXBeVLZvy+gPrPezAXDgfnZuSmCcpWMHhMa
         k/iCPSGipJ73bZ5YaIE7GFlkKvX4d3vmHazVrnv+RnqYPcY+lWoo6w2rva77ZnXx6DTF
         bpa88lWkJnl4YI/LBrWDClkO7dX0gzpd0qyrcRCBYBeMCAKAzseVbzr49j4PF5Fg1MV0
         +OvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DZCbcR5Iy8/K2bF0tkHCyOQWDKeY6OQ5I8XUt1jrWCM=;
        b=Wg8VsB7zSUcg0WIJP1rrbTUCVaaK934vHIEH0MS5eMbE2JrhHKID/Axqy7bsUYBqeY
         FR7jLf62JPYS4zf2OwrimUe/l4JuKwvq7KF3eBKZOnbGByyGStXRXumaL8I+ndoWmkje
         YmKILwIqvBkC94F0XXN/gH9wEuW2YvjtAvXxJypocaCb74lxpxXrxuJc1VxlVFT9sJ64
         J10hh0jMQzCvBC8kGTeXTTv+P3Ix3ZAGlf55ytX3JK3xwXeCYdJ2YyV6hhUiA3S4F+Z+
         LrOAMdIqyL6oKkqdf8iSayBrTsTOZOmZMmRni035t1x4HaQvbU7d+978Zjsj1LuAhxte
         e3XQ==
X-Gm-Message-State: APjAAAWFRgFweiVae+1BuQ3TTp8xxdezQvHvfEUG8ZlBaEzsGldBaYVL
        Jl5DoqA7vk0RSCVAe07tgqrsoi9OXNNF8oISujs=
X-Google-Smtp-Source: APXvYqxbM46DYnjFMelwxJ6ieSaTahz1CzBnxDFA50cYAXoSzWE707p5aV7UO5MvdUZUvwLsXF7/fX6INTZgyFoEx+g=
X-Received: by 2002:a19:fc1e:: with SMTP id a30mr10401625lfi.167.1571852531741;
 Wed, 23 Oct 2019 10:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com> <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com> <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
 <acf69635-5868-f876-f7da-08954d1f690e@intel.com> <20191019001449.fk3gnhih4nx724pm@ast-mbp>
 <6f281517-3785-ce46-65de-e2f78576783b@intel.com> <20191019022525.w5xbwkav2cpqkfwi@ast-mbp>
 <877e4zd8py.fsf@toke.dk> <CAJ+HfNj07FwmU2GGpUYw56PRwu4pHyHNSkbCOogbMB5zB2QqWA@mail.gmail.com>
 <7642a460-9ba3-d9f7-6cf8-aac45c7eef0d@intel.com> <CAADnVQ+jiEO+jnFR-G=xG=zz7UOSBieZbc1NN=sSnAwvPaJjUQ@mail.gmail.com>
 <8956a643-0163-5345-34fa-3566762a2b7d@intel.com>
In-Reply-To: <8956a643-0163-5345-34fa-3566762a2b7d@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Oct 2019 10:42:00 -0700
Message-ID: <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Herbert, Tom" <tom.herbert@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:06 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
> OK. Here is another data point that shows the perf report with the same test but CPU mitigations
> turned OFF. Here bpf_prog overhead goes down from almost (10.18 + 4.51)% to (3.23 + 1.44%).
>
>    21.40%  ksoftirqd/28     [i40e]                     [k] i40e_clean_rx_irq_zc
>    14.13%  xdpsock          [i40e]                     [k] i40e_clean_rx_irq_zc
>     8.33%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
>     6.09%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redirect
>     5.19%  xdpsock          xdpsock                    [.] main
>     3.48%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redirect_map
>     3.23%  ksoftirqd/28     bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8251c7e0fef8db
>
> So a major component of the bpf_prog overhead seems to be due to the CPU vulnerability mitigations.

I feel that it's an incorrect conclusion because JIT is not doing
any retpolines (because there are no indirect calls in bpf).
There should be no difference in bpf_prog runtime with or without mitigations.
Also you're running root, so no spectre mitigations either.

This 3% seems like a lot for a function that does few loads that should
hit d-cache and one direct call.
Please investigate why you're seeing this 10% cpu cost when mitigations are on.
perf report/annotate is the best.
Also please double check that you're using the latest perf.
Since bpf performance analysis was greatly improved several versions ago.
I don't think old perf will be showing bogus numbers, but better to
run the latest.

> The other component is the bpf_xdp_redirect_map() codepath.
>
> Let me know if it helps to collect any other data that should further help with the perf analysis.
>
