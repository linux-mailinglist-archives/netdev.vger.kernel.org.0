Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51563E46A4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438311AbfJYJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:07:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42222 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438275AbfJYJHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:07:42 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so2167732qto.9;
        Fri, 25 Oct 2019 02:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BNqUVl5JhXUGBG9kreQv4HQ6twYK66HGwyTPZIQqshk=;
        b=Rci22rH4VHCMDPeHpym/2wdi2vheAEio8Qg2GpN9W4xFixcqI4UzxmQaU+6Zv7gkd4
         wphtW8txmNMgXPwyuKVzmGd/qbhARLp/t6w1N3FMo0WubfD2rP1PlNPF9TbzTcx7Ml/r
         aKi+87vNx+GvJuBi3fXA30V8uL7HUYY9dM5ANg7e3txJ0SZSf7YU8mSBiNV7kX1Gavv7
         9zKilWJABoRsS7EUUEjrXoPIVt71yPShD2oUu6Z8b8aN96cZUA8GoA4ulgnZg/k02z//
         joaehTqK0VepMEDvL7Y9sI4SzPIdmT6P3zIKZ1HH6C4McvsPE49Na6ukY5uq1YJL8/1x
         iZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BNqUVl5JhXUGBG9kreQv4HQ6twYK66HGwyTPZIQqshk=;
        b=HQdGmJ4OhNOpZz9LkSzywCPXKTKM0QumPQjuxaY/DgW9pVEhvLRmtW2PAdRJtBOYX5
         bS8EFdgni4Dgyb8jXW7Cvonb3sVXqeYun80U4oZysCY3KGef//mGhJpii9/ilvMD833O
         p77LyWKHlpeEmv4fBw3/seyb7HDdfE2vFVVZugNFfI0ZMz0kPVl2J4Qtpa7G67azSJcl
         66Ec3LxCmbrYQTCJd9i8baw+F7W9HF983rWZ2Irou1tgZlLk9pMKJMaaB0C5MjWOra5k
         U4EIPkuXSTqgFkuZAddwSBTcP3ilk0fEpDJ+RSrSXnfqv+cGI5L12xOAUncOGVRZov8H
         +tmQ==
X-Gm-Message-State: APjAAAWp5uYW/D0ecfw9lAC+BZP2xL/dMXR6BtAP8738I6f7cTJ9U49E
        /1GTyjF0WwZzLW3u67VppW9ZwkctD1qbCHS+mR8=
X-Google-Smtp-Source: APXvYqyxqvo8WixxaonOOhUTCm5R01BrvfpXOlJUiwbEp++GSuah1ZRQf06SzbZ+x5qTV0X3MFfTGRdDDH1b3jmZ0QY=
X-Received: by 2002:ac8:2a5d:: with SMTP id l29mr2069242qtl.36.1571994461390;
 Fri, 25 Oct 2019 02:07:41 -0700 (PDT)
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
 <8956a643-0163-5345-34fa-3566762a2b7d@intel.com> <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
In-Reply-To: <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 25 Oct 2019 11:07:29 +0200
Message-ID: <CAJ+HfNg8NMS7k+f4K3PH-cjA9XFbBbEetfZT55J0ntZejxV-PQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 at 19:42, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 22, 2019 at 12:06 PM Samudrala, Sridhar
> <sridhar.samudrala@intel.com> wrote:
> >
> > OK. Here is another data point that shows the perf report with the same=
 test but CPU mitigations
> > turned OFF. Here bpf_prog overhead goes down from almost (10.18 + 4.51)=
% to (3.23 + 1.44%).
> >
> >    21.40%  ksoftirqd/28     [i40e]                     [k] i40e_clean_r=
x_irq_zc
> >    14.13%  xdpsock          [i40e]                     [k] i40e_clean_r=
x_irq_zc
> >     8.33%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
> >     6.09%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_redir=
ect
> >     5.19%  xdpsock          xdpsock                    [.] main
> >     3.48%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp_redi=
rect_map
> >     3.23%  ksoftirqd/28     bpf_prog_3c8251c7e0fef8db  [k] bpf_prog_3c8=
251c7e0fef8db
> >
> > So a major component of the bpf_prog overhead seems to be due to the CP=
U vulnerability mitigations.
>
> I feel that it's an incorrect conclusion because JIT is not doing
> any retpolines (because there are no indirect calls in bpf).
> There should be no difference in bpf_prog runtime with or without mitigat=
ions.
> Also you're running root, so no spectre mitigations either.
>
> This 3% seems like a lot for a function that does few loads that should
> hit d-cache and one direct call.
> Please investigate why you're seeing this 10% cpu cost when mitigations a=
re on.
> perf report/annotate is the best.
> Also please double check that you're using the latest perf.
> Since bpf performance analysis was greatly improved several versions ago.
> I don't think old perf will be showing bogus numbers, but better to
> run the latest.
>

For comparison, on my Skylake 3GHz with mitigations off. (I have one
internal patch that inlines xsk_rcv() into __xsk_map_redirect, so
that's why it's not showing xsk_rcv(). I'll upstream that...)

  41.79%  [kernel]                   [k] i40e_clean_rx_irq_zc
  15.55%  [kernel]                   [k] __xsk_map_redirect
   9.87%  [kernel]                   [k] xdp_do_redirect
   6.89%  [kernel]                   [k] xsk_umem_peek_addr
   6.37%  [kernel]                   [k] bpf_xdp_redirect_map
   5.02%  bpf_prog_992d9ddc835e5629  [k] bpf_prog_992d9ddc835e5629

Again, it might look weird that simple functions like
bpf_xdp_redirect_map and the XDP program is 6% and 5%.

Let's dig into that. I let the xdpsock program (rxdrop) run on one
core 22, and the ksoftirqd on core 20. Core 20 is only processing
packets, plus the regular kernel householding. I did a processor trace
for core 20 for 207 936 packets.

In total it's 84,407,427 instructions, and bpf_xdp_redirect_map() is
8,109,504 instructions, which is 9.6%. bpf_xdp_redirect_map() executes
39 instructions for AF_XDP. As perf is reporting less than 9.6% means
that the IPC count of that function is more than the average which
perf-stat reports as IPC of 2.88.

The BPF program executes fewer instructions than
bpf_xdp_redirect_map(), so given that perf shows 5%, means that the
IPC count is better than average here as well.

So, it's roughly 405 instructions per packet, and with an IPC of 2.88
that'll give ~140 cycles per packet, which on this machine
(3,000,000,000/140) is ~21.4 Mpps. The xdpsock application reports
21. This is sane.

The TL;DR version is: 6% and 5% for bpf_xdp_redirect_map and
bpf_prog_992d9ddc835e5629 might seem high, but it's just that the
total number of instruction executing is fairly low. So, even though
the functions are small in size, it will show up as non-negligible
percentage in perf.

At these speeds, really small things have an impact on
performance. DPDK has ~50 cycles per packet.


Bj=C3=B6rn



> > The other component is the bpf_xdp_redirect_map() codepath.
> >
> > Let me know if it helps to collect any other data that should further h=
elp with the perf analysis.
> >
