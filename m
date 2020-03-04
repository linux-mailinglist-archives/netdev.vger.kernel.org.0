Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9E9178E01
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgCDKGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:06:30 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36408 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbgCDKG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:06:29 -0500
Received: by mail-ed1-f68.google.com with SMTP id a13so1613877edh.3
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qvjAotCReIalwn7hfhRA/t4b2Gvv6W6FE/RxEgqf7t8=;
        b=TlS//aLMBwYMpsokQs4f+uhkB8/BG6XV1ID6SLScsSnRde6IV1KEaVzUesz7X0HS48
         sIqEqXZkY/mPsymtHOURw4GXi3q66hWqhz2+X9RmD1Tt6GIOl5oQyAoTRaDV+5sRRvhv
         IvnergFq3KB0EY3wYxA/Gb3RTzWpD64yfgeDV3JxMSWKZo+ch1ImmDmVc8jJLAtePuTN
         5+J8TBDTgjG5wlwCK7CmVA+ykJI20Yp+CqZVyJsr1sUMeh2NpynuAmioA6YLOSuZCp3t
         ktALDGuW+aAoYRgsy3D1e9JSlCS0FPG0GzdP12OhnzaiM45ZI2LYw36sH6Z1KBVgRgP7
         DORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qvjAotCReIalwn7hfhRA/t4b2Gvv6W6FE/RxEgqf7t8=;
        b=P9NK+AFm5zj6qaAJNwqeTSdZ12Xi0HgU7/ej+qYNq7lNCS/wukK/DMy3/xI2dbdlkD
         CYyFWTeMnoUlA9IWDZdgAQASJV/D47LvgIqdMh/hD2I5+Clnriem4yRw86NBz+yPh6FH
         GETbzLTMrZz8Dhe1sxvTqSiJVClqE1tHTKurFjFdci/WsHvDJBIFTUE4y+gduBUbdDbp
         uWNOfjf223Pz3WzS1u/+HINu4nHFQvg5eeLBEkwbdTiahAYKx8bnE0kIcZ6GKuKA22cM
         Md53c9iZAvrY35jhxCUNymxRRQMWShHsds0EL/aeE8Tp6w4c6cibzMoahfpwBO0uxHH8
         RLnA==
X-Gm-Message-State: ANhLgQ0WMuboRcMAtJx19TMI1oVZ53HQNkCD93PP0zcUUy26BCSjT0Ma
        sU9d47yUUv+5azyAg2c7Q+i9WKmsPenLTxBVm33aAg==
X-Google-Smtp-Source: ADFU+vsOS1A0XyioMVvDKG5rYZHg689H6J6a0RrbmZGMdwpvoTGbmXSr6HznowYHxLngFqxStbYPiqT+Uq3K7hbs3qQ=
X-Received: by 2002:a17:906:15c2:: with SMTP id l2mr1771475ejd.302.1583316386498;
 Wed, 04 Mar 2020 02:06:26 -0800 (PST)
MIME-Version: 1.0
References: <20200228105435.75298-1-lrizzo@google.com> <20200228110043.2771fddb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSfd80pZroxtqZDsTeEz4FaronC=pdgjeaBBfYqqi5HiyQ@mail.gmail.com> <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net>
In-Reply-To: <3c27d9c0-eb17-b20f-2d10-01f3bdf8c0d6@iogearbox.net>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Wed, 4 Mar 2020 02:06:15 -0800
Message-ID: <CAMOZA0+T3k25ndRKpSwDZ9vHkMaJUz4XhtfGFGNn=sPrGoSQ4Q@mail.gmail.com>
Subject: Re: [PATCH v4] netdev attribute to control xdpgeneric skb linearization
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Jubran, Samih" <sameehj@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ast@kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[taking one message in the thread to answer multiple issues]

On Tue, Mar 3, 2020 at 11:47 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/29/20 12:53 AM, Willem de Bruijn wrote:
> > On Fri, Feb 28, 2020 at 2:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >> On Fri, 28 Feb 2020 02:54:35 -0800 Luigi Rizzo wrote:
> >>> Add a netdevice flag to control skb linearization in generic xdp mode.
> >>>
> >>> The attribute can be modified through
> >>>        /sys/class/net/<DEVICE>/xdpgeneric_linearize
> >>> The default is 1 (on)
...
> >>> ns/pkt                   RECEIVER                 SENDER
> >>>
> >>>                      p50     p90     p99       p50   p90    p99
> >>>
> >>> LINEARIZATION:    600ns  1090ns  4900ns     149ns 249ns  460ns
> >>> NO LINEARIZATION:  40ns    59ns    90ns      40ns  50ns  100ns
...
> >> Just load your program in cls_bpf. No extensions or knobs needed.

Yes this is indeed an option, perhaps the only downside is that
it acts after packet taps, so if, say, the program is there to filter unwanted
traffic we would miss that protection.

...
> >> Making xdpgeneric-only extensions without touching native XDP makes
> >> no sense to me. Is this part of some greater vision?
> >
> > Yes, native xdp has the same issue when handling packets that exceed a
> > page (4K+ MTU) or otherwise consist of multiple segments. The issue is
> > just more acute in generic xdp. But agreed that both need to be solved
> > together.
> >
> > Many programs need only access to the header. There currently is not a
> > way to express this, or for xdp to convey that the buffer covers only
> > part of the packet.
>
> Right, my only question I had earlier was that when users ship their
> application with /sys/class/net/<DEVICE>/xdpgeneric_linearize turned off,
> how would they know how much of the data is actually pulled in? Afaik,

The short answer is that before turning linearization off, the sysadmin should
make sure that the linear section contains enough data for the program
to operate.
In doubt, leave linearization on and live with the cost.

The long answer (which probably repeats things I already discussed
with some of you):
clearly this patch is not perfect, as it lacks ways for the kernel and
bpf program to
communicate
a) whether there is a non-linear section, and
b) whether the bpf program understands non-linear/partial packets and how much
linear data (and headroom) it expects.

Adding these two features needs some agreement on the details.
We had a thread a few weeks ago about multi-segment xdp support, I am not sure
we reached a conclusion, and I am concerned that we may end up reimplementing
sg lists or simplified-skbs for use in bpf programs where perhaps we
could just live
with pull_up/accessor for occasional access to the non-linear part,
and some hints
that the program can pass to the driver/xdpgeneric to specify
requirements. for #b

Specifically:
#a is trivial -- add a field to the xdp_buff, and a helper to read it
from the bpf program;
#b is a bit less clear -- it involves a helper to either pull_up or
access the non linear data
(which one is preferable probably depends on the use case and we may want both),
and some attribute that the program passes to the kernel at load time,
to control
when linearization should be applied. I have hacked the 'license'
section to pass this
information on a per-program basis, but we need a cleaner way.

My reasoning for suggesting this patch, as an interim solution, is that
being completely opt-in, one can carefully evaluate when it is safe to use
even without having #b implemented.
For #a, the program might infer (but not reliably) that some data are
missing by looking
at the payload length which may be present in some of the headers. We
could mitigate
abuse by e.g. forcing XDP_REDIRECT and XDP_TX in xdpgeneric only
accept linear packets.

cheers
luigi

> some drivers might only have a linear section that covers the eth header
> and that is it. What should the BPF prog do in such case? Drop the skb
> since it does not have the rest of the data to e.g. make a XDP_PASS
> decision or fallback to tc/BPF altogether? I hinted earlier, one way to
> make this more graceful is to add a skb pointer inside e.g. struct
> xdp_rxq_info and then enable an bpf_skb_pull_data()-like helper e.g. as:
>
> BPF_CALL_2(bpf_xdp_pull_data, struct xdp_buff *, xdp, u32, len)
> {
>          struct sk_buff *skb = xdp->rxq->skb;
>
>          return skb ? bpf_try_make_writable(skb, len ? :
>                                             skb_headlen(skb)) : -ENOTSUPP;
> }
>
> Thus, when the data/data_end test fails in generic XDP, the user can
> call e.g. bpf_xdp_pull_data(xdp, 64) to make sure we pull in as much as
> is needed w/o full linearization and once done the data/data_end can be
> repeated to proceed. Native XDP will leave xdp->rxq->skb as NULL, but
> later we could perhaps reuse the same bpf_xdp_pull_data() helper for
> native with skb-less backing. Thoughts?
>
> Thanks,
> Daniel
