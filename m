Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215E733E72
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFDFhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:37:22 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39463 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfFDFhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:37:21 -0400
Received: by mail-qk1-f193.google.com with SMTP id i125so2055776qkd.6;
        Mon, 03 Jun 2019 22:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=36J3I7Fuugme+mq6p4mk4Ngg78eCdJB/76haz5JE75s=;
        b=m5ewveizZ8GMYQ4T78LySwh+5lInoyktPCXEG5LudhnWLgmzcoxp898J1dDdVeOtod
         bxFsOkq5nHwT+ZkbqbDML1djROlLvB8yCqINCIZLNeBAiXQmlJUM1dQXRUO6pIvFzJbg
         x7HEbSHFuJeLzh4zJkk+qsUTsfbo5owDlTHw0v1tjYQOZnAamjxyxi8hODxWGTr4xItf
         aH3KaRIosM/5sfGe/0MvEtM6NFZZ2PzRCKgqr7dQ7maj8pSDHD5/jPRqWvArb2aemODw
         +PdzG8ZrwxKlPmvZ18YpK7zocAg8Q14cogpzsZqJa8sYynTgyXAPhYa2t+YxU8sILQfk
         OEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=36J3I7Fuugme+mq6p4mk4Ngg78eCdJB/76haz5JE75s=;
        b=me/Bp3vAcuj3iQJhYFxc+PEpminvf2rzEc0UQI0x8kNDKSA6CEvzEu5ROTJ4JmpwJ7
         Z6T94tnhKJ4Y0l0qKL4G3Py8Fc440nhXAt6B3lr7Qz9kjpl14Aq01ANzpSFFHeO1sxTg
         z9mP1v/j49uOEYdRKi5tlpVZvlRcjVlBV4XdFo6byVUJ0tRiMjNTVp+Qo+O/jd3T6K70
         qlLpiv+oDaq2LMukhKMYjiUxOpafpXkwOabBwHYwUvBvuER/aw5qxB7M8M3j7nu1v0hP
         FKVeLDAMM6X0RfGvBuaRsjKckCUVhfwtBQst2ZbwXpDvO7VRxrZzqMcYZcRhxkT+4nGz
         QqMg==
X-Gm-Message-State: APjAAAVaegFaqT9Xy8q2WR7aIb0SJNt6pZQlqDYwjScyOzZ7411ODqVW
        9/bIK6h9+nvWCjvaVvtznXsJ/xG+YXjbK315Ujo=
X-Google-Smtp-Source: APXvYqwwZfIzPzJ/9wzDwWVYTlppF0yZUkCQJEaPMWzc87FrKCSy+qUelljfh7rYkYgEO4Vrow0lfcDJ/PXWnbWh3iI=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr25993787qkj.39.1559626639747;
 Mon, 03 Jun 2019 22:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <E5650E49-81B5-4F36-B931-E433A0BD210D@flugsvamp.com> <CAJ+HfNj=h1Ns_Q4tzmK-5q8jr5icVLA9-tiH7-tQTXx0hATZ0A@mail.gmail.com>
 <a9c3be97-6c74-6491-199f-219bd4c2c631@iogearbox.net>
In-Reply-To: <a9c3be97-6c74-6491-199f-219bd4c2c631@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Jun 2019 07:37:08 +0200
Message-ID: <CAJ+HfNiMksZg2yyGcPV-njA4NmXmeW_70MDpoPugBtD8pHsYZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jonathan Lemon <jlemon@flugsvamp.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 01:11, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/03/2019 10:39 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Sat, 1 Jun 2019 at 20:12, Jonathan Lemon <jlemon@flugsvamp.com> wrot=
e:
> >> On 31 May 2019, at 2:42, Bj=C3=B6rn T=C3=B6pel wrote:
> >>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>>
> >>> All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
> >>> command of ndo_bpf. The query code is fairly generic. This commit
> >>> refactors the query code up from the drivers to the netdev level.
> >>>
> >>> The struct net_device has gained two new members: xdp_prog_hw and
> >>> xdp_flags. The former is the offloaded XDP program, if any, and the
> >>> latter tracks the flags that the supplied when attaching the XDP
> >>> program. The flags only apply to SKB_MODE or DRV_MODE, not HW_MODE.
> >>>
> >>> The xdp_prog member, previously only used for SKB_MODE, is shared wit=
h
> >>> DRV_MODE. This is OK, due to the fact that SKB_MODE and DRV_MODE are
> >>> mutually exclusive. To differentiate between the two modes, a new
> >>> internal flag is introduced as well.
> >>
> >> I'm not entirely clear why this new flag is needed - GENERIC seems to
> >> be an alias for SKB_MODE, so why just use SKB_MODE directly?
> >>
> >> If the user does not explicitly specify a type (skb|drv|hw), then the
> >> command should choose the correct type and then behave as if this type
> >> was specified.
> >
> > Yes, this is kind of hairy.
> >
> > SKB and DRV are mutually exclusive, but HW is not. IOW, valid options a=
re:
> > SKB, DRV, HW, SKB+HW DRV+HW.
>
> Correct, HW is a bit special here in that it helps offloading parts of
> the DRV XDP program to NIC, but also do RSS steering in BPF etc, hence
> this combo is intentionally allowed (see also git log).
>
> > What complicates things further, is that SKB and DRV can be implicitly
> > (auto/no flags) or explicitly enabled (flags).
>
> Mainly out of historic context: originally the fallback to SKB mode was
> implicit if the ndo_bpf was missing. But there are use cases where we
> want to fail if the driver does not support native XDP to avoid surprises=
.
>
> > If a user doesn't pass any flags, the "best supported mode" should be
> > selected. If this "auto mode" is used, it should be seen as a third
> > mode. E.g.
> >
> > ip link set dev eth0 xdp on -- OK
> > ip link set dev eth0 xdp off -- OK
> >
> > ip link set dev eth0 xdp on -- OK # generic auto selected
> > ip link set dev eth0 xdpgeneric off -- NOK, bad flags
>
> This would work if the auto selection would have selected XDP generic.
>
> > ip link set dev eth0 xdp on -- OK # drv auto selected
> > ip link set dev eth0 xdpdrv off -- NOK, bad flags
>
> This would work if the auto selection chose native XDP previously. Are
> you saying it's not the case?
>

Yes, that is *not* the case for some drivers. With the Intel drivers
we didn't check the flags at all at XDP attachment (check out the
usage of xdp_attachment_flags_ok), but e.g. nfp and netdevsim does.
Grep for 'program loaded with different flags' in the test_offload.py
selftest. I like this approach, and my patch does this flag check in
dev_change_xdp_fd.

> Also, what is the use case in mixing these commands? It should be xdp
> on+off, xdpdrv on+off, and so on. Are you saying you would prefer a
> xdp{,any} off that uninstalls everything? Isn't this mostly a user space
> issue to whatever orchestrates XDP?
>

No, I'm not suggesting a change. There is no use-case mixing them.
What the flags ok checks do is returning an error (like nfp and
netdevsim does) if a user tries to mix, say,  "xdp" and explicit
xdpdrv/xdpgeneric". This patch moves this check to the generic
function dev_change_xdp_fd.

There seems to be a confusion about how this is supposed to be used.
It was for me, e.g. I though using "enable with xdp and disable with
xdpdrv" was OK. This was the reason why I added an error on "disable
with xdpgeneric off, if xdpdrv is active" in my first revision of the
series. I removed this in v2, after Jakub pointed out the
test_offload.py test, which is a great showcase/test of what should be
allowed and what shouldn't in terms of flags.

TL;DR: Let's stick to what test_offload.py asserts, for all XDP.


> > ...and so on. The idea is that a user should use the same set of flags =
always.
> >
> > The internal "GENERIC" flag is only to determine if the xdp_prog
> > represents a DRV version or SKB version. Maybe it would be clearer
> > just to add an additional xdp_prog_drv to the net_device, instead?
> >
> >> The logic in dev_change_xdp_fd() is too complicated.  It disallows
> >> setting (drv|skb), but allows (hw|skb), which I'm not sure is
> >> intentional.
> >>
> >> It should be clearer as to which combinations are allowed.
> >
> > Fair point. I'll try to clean it up further.
> >
