Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE0528C3C2
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbgJLVEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730845AbgJLVEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:04:22 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FCDC0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 14:04:20 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 67so19051922iob.8
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 14:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UOV+wZSty8SFi6MYQVj35TSEg5h/obGY+TCOAt7L/FU=;
        b=P1GGgpG8ooD5mkWbCTzonrFgaySG8R8UTioqSHnXcUfieFh6gAPW1RUT5yJE1/5lmd
         N9Lrd3gpmIbctpqiSVW/xIXcCpgJbz2kjZzgtmFC47RGZRONTQONOEE1QJJGJtmzBI2Q
         GRP8y0zXYP9QA22sdwpY5OlwyH7dzcjm0NgZSv8BLszDZXnQqB0I0lKz0JSwrTtZfwZx
         jpOKRxn9Cz7j3/7w8HbWEbRIQacAP+zTw4a0g9GLrrah8k/Koc9jg4JHAAvWaDThRfzs
         ORSdbfMDt30uIEeC5smg+0pxuvyvQk4WJfGckA7jAJWi1GHceZFA6v3U3HADXZ6ATcnh
         EkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UOV+wZSty8SFi6MYQVj35TSEg5h/obGY+TCOAt7L/FU=;
        b=pFsRl1tCOHf2TSOciS6CoMav/EAoMSL03jr9N5SGNgFajByE2Jn9ZHzXa9RwcVr8Kt
         sL0EZIIiGMSIoFRKQblPW/seWD7tv5cCGr1pNDD82BNRa5uaToqGnkwFH/unsLfRJccH
         8SmzOHt8gz/0lCCT2ix1yLEZw3auyNTECqRieZsf4WhaPYI7Gj6NMHv0DB0QXtbMzlpS
         S3pfYqghBm/eDSIhRPJQ32eUC6bz4ZCNQoz5k9gkg5FddhgYlAIKCeQTzqhqg3Z2scI5
         qicN/AynxdPnJfemegoSaKulOjJd3uVOCvmiEFeK/vOjyVBl85JsMfGdAbhcuxnjysRj
         JCgw==
X-Gm-Message-State: AOAM531rAs1CTICy/PJl/QuQAJba8nOMpm81vTbpSfWHQs2Jwh10Iqzt
        HAQIybzeN6SrU8PhTQIkC9NKyPSrlMQpZI4POrZFMg==
X-Google-Smtp-Source: ABdhPJz/oXMaf3NdxBr/YUP34hLYpHoGuDElu1QGaCL9svj1l1e93Koq+PqUfLWU+mbrGF+lAQoHl3UeQYh5WOrjetU=
X-Received: by 2002:a05:6602:2c84:: with SMTP id i4mr11403491iow.89.1602536659858;
 Mon, 12 Oct 2020 14:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216615767.882446.7384364280837100311.stgit@firesoul> <40d7af61-6840-5473-79d7-ea935f6889f4@iogearbox.net>
 <CANP3RGesHkCNTWsWDoU2uJsFjZ4dgnEpp+F-iEmhb9U0-rcT_w@mail.gmail.com> <20201010130938.138c80d9@carbon>
In-Reply-To: <20201010130938.138c80d9@carbon>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 12 Oct 2020 14:04:08 -0700
Message-ID: <CANP3RGeQJYbn-RbxJvUO-WauDDhCEQQz086DgNhh3KeubCA33w@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 4/6] bpf: make it possible to identify BPF
 redirected SKBs
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 4:09 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Fri, 9 Oct 2020 11:33:33 -0700
> Maciej =C5=BBenczykowski <maze@google.com> wrote:
>
> > > > This change makes it possible to identify SKBs that have been redir=
ected
> > > > by TC-BPF (cls_act). This is needed for a number of cases.
> > > >
> > > > (1) For collaborating with driver ifb net_devices.
> > > > (2) For avoiding starting generic-XDP prog on TC ingress redirect.
> > > >
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > >
> > > Not sure if anyone actually cares about ifb devices, but my worry is =
that the
> > > generic XDP vs tc interaction has been as-is for quite some time so t=
his change
> > > in behavior could break in the wild.
>
> No, I believe this happened as recent at kernel v5.2, when Stephen
> Hemminger changed this in commit 458bf2f224f0 ("net: core: support XDP
> generic on stacked devices.").  And for the record I think that
> patch/change was a mistake, as people should not use generic-XDP for
> these kind of stacked devices (they should really use TC-BPF as that is
> the right tool for the job).
>
>
> > I'm not at all sure of the interactions/implications here.
> > But I do have a request to enable ifb on Android for ingress rate
> > limiting and separately we're trying to make XDP work...
> > So we might at some point end up with cellular interfaces with xdp
> > ebpf (redirect for forwarding/nat/tethering) + ifb + tc ebpf (for
> > device local stuff).
>
> To me I was very surprised when I discovered tc-redirect didn't work
> with ifb driver.  And it sounds like you have an actual use-case for
> this on Android.
>
> > But this is still all very vague and 'ideas only' level.
> > (and in general I think I'd like to get rid of the redirect in tc
> > ebpf, and leave only xlat64 translation for to-the-device traffic in
> > there, so maybe there's no problem anyway??)
>
> I know it sounds strange coming from me "Mr.XDP", but I actaully think
> that in many cases you will be better off with using TC-BPF.
> Especially on Android, as it will be very hard to get native-XDP
> implemented in all these different drivers. (And you don't want to use
> generic-XDP, because there is a high chance it causes a reallocation of
> the SKB, which is a huge performance hit).

We want the benefits of not allocating/zeroing skb metadata.
We probably can't (always) do zerocopy...

But let's list what we have on at least 1 sample device:
(a) cellular interface receives, no LRO, into skb, no build_skb
so each packet is <=3D mtu and requires meta alloc, meta zero, payload allo=
c
on some devices, payload is copied because nic does not receive into
all of system RAM, just SWMMIO style into a small ~60MB buffer.
(b) GRO happens
(c) TC BPF with redirect or routing/forwarding/iptables
(d) GSO happens, cause no TSO at NCM usb driver
(e) NCM driver copies payload, discards skb.
[and it allocates around 1 more skb per 16KB]

so we basically have at least 2 allocs and 2 payload copies per <=3D1500 pa=
cket
(and cellular mtus are likely closer to 1280 then 1500)

Lots of room for improvement - GRO/GSO are probably a net loss
(unclear) and all that allocation/copies.
If I can get XDP to eliminate the skb meta allocation and the fast
path payload copy in the cellular driver.
(so we only have copy from xdp frame into skb), then it's already a
huge win - we're down to 1 copy in NCM driver.
NCM could technically not require a copy with USB controller SG, but
current demo patches for that are not a win.
(Most likely usb controller is crappy, but lots of work left)
If forwarding/tethering is through XDP Redirect, then I also win due
to no GRO/GSO on that path.
(at least I think so)
