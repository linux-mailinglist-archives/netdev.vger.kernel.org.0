Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C017B782
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfGaBWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:22:00 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38309 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfGaBWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:22:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id a27so48050000qkk.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8e2MbRkVwFshGJy8jHNU0lxsFiicJRQkfLnguyMaD8w=;
        b=amq+y8LsiqI8nEEWcPiEiV5w/J2kF6Z7YaFNQspWlgKarMAWSSaMd9h/Mz7FhSUt0G
         F72Aue2S1opOfDFuWM/P9gYYyO8XBXBRHEdrCg450b0XrxJdtUwahbEIkeu/RwMngjHE
         sedFEwYIGV3JQe/UcNbEnvnBg5vZZ0amFTmsMu2TXw3ydDI3GntW9TSbem2k/+nNgzOy
         BqE9FztlEJM/DrJAeS/+G+Y6xVSUv64Rmb4kgHLuiImvIrccPSsw8shIue1DXsIjbWy+
         sr6Iw8B+Dymt7PO0/ZeQgu7S881n4f4LLIihzz79CH4MzD0wnXxkafBf2dlaucNQSILs
         aRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8e2MbRkVwFshGJy8jHNU0lxsFiicJRQkfLnguyMaD8w=;
        b=D2pZ27+cAVf/CP+Gzjq/Rl1dkM7P6cvkMso3DZU3aI63sJJy46Kl19M1CAvRjBoZY9
         l+TEH7GybEL02lH52xikM/gFe7eHWoUXsiMZ655QbaMkf1gem/RER7wE2hEAFIgoygAp
         IC2CA+ozT415g8qESk0ErDR9urQFj3JS4NYrSBnP2fWVlfENigbFnq+OVJgSizfdsUL4
         zUnRFJQIjItabjUIK5PZpaoDt+cK/l6LTojVTHOQQi3ILM6dxU8gUKcjGzrY9yAig+82
         E1Af73uyOTFtKt71K0uIINI700/hMWxmZWpV3aYPwm5TPMcvCKfjP0ua9CcCEvvBkmzL
         C13Q==
X-Gm-Message-State: APjAAAWeWnImNIlgdVq49cMtARqKWvrrTec5P1B+5DuLTNHqbxCoCjsi
        W4IMb0XcsQdR2+Nws1dRB6LpNQ==
X-Google-Smtp-Source: APXvYqxKaWE7X20NIzhdysKSTq2YtDXu97GQKDosGFwKdTkrQuGBdckVixC2n665TQY74DRJnds/gQ==
X-Received: by 2002:a37:85c2:: with SMTP id h185mr81843298qkd.353.1564536119235;
        Tue, 30 Jul 2019 18:21:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x42sm34288821qth.24.2019.07.30.18.21.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 18:21:58 -0700 (PDT)
Date:   Tue, 30 Jul 2019 18:21:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load
 XDP
Message-ID: <20190730182144.1355bf50@cakuba.netronome.com>
In-Reply-To: <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
        <20190730155915.5bbe3a03@cakuba.netronome.com>
        <20190730231754.efh3fj4mnsbv445l@ast-mbp>
        <20190730170725.279761e7@cakuba.netronome.com>
        <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 17:23:39 -0700, Alexei Starovoitov wrote:
> On Tue, Jul 30, 2019 at 05:07:25PM -0700, Jakub Kicinski wrote:
> > Nothing meaning you disagree it's duplicated effort and unnecessary=20
> > LoC the community has to maintain, review, test..? =20
>=20
> I don't see duplicated effort.

Could you walk me through a scenario where, say, a new xdp attachment
flag is added? How can there be support in both bpftool and iproute2=20
for specifying it without modifying both?

How can we say we want to make iproute2 use libbpf instead of it's own
library to avoid duplicated effort on the back end, and at the same time
claim having two tools do the same thing is no duplication =F0=9F=A4=AF

> > Duplicating the same features in bpftool will only diminish the
> > incentive for moving iproute2 to libbpf.  =20
>=20
> not at all. why do you think so?

Because iproute2's BPF has fallen behind so the simplest thing is to
just contribute to bpftool. But iproute2 is the tool set for Linux
networking, we can't let it bit rot :(

Admittedly that's just me reading the tea leaves.

> > And for folks who deal
> > with a wide variety of customers, often novices maintaining two
> > ways of doing the same thing is a hassle :( =20
>=20
> It's not the same thing.
> I'm talking about my experience dealing with 'wide variety of bpf custome=
rs'.
> They only have a fraction of their time to learn one tool.
> Making every bpf customer learn ten tools is not an option.

IMHO vaguely competent users of Linux networking will know ip link.
If they are not vaguely competent, they should not attach XDP programs
to interfaces by hand...

> > Let's just put the two commands next to each other:
> >=20
> >        ip link set xdp $PROG dev $DEV
> >=20
> > bpftool net attach xdp $PROG dev $DEV
> >=20
> > Are they that different? =20
>=20
> yes.
> they're different tools with they own upgrade/rollout cycle

I think this came up when bpftool net was added and I never really
understood it.

> > > If bpftool was taught to do equivalent of 'ip link' that would be
> > > very different story and I would be opposed to that. =20
> >=20
> > Yes, that'd be pretty clear cut, only the XDP stuff is a bit more=20
> > of a judgement call. =20
>=20
> bpftool must be able to introspect every aspect of bpf programming.
> That includes detaching and attaching anywhere.
> Anyone doing 'bpftool p s' should be able to switch off particular
> prog id without learning ten different other tools.

I think the fact that we already have an implementation in iproute2,
which is at the risk of bit rot is more important to me that the
hypothetical scenario where everyone knows to just use bpftool (for
XDP, for TC it's still iproute2 unless there's someone crazy enough=20
to reimplement the TC functionality :))

I'm not sure we can settle our differences over email :)
I have tremendous respect for all the maintainers I CCed here,=20
if nobody steps up to agree with me I'll concede the bpftool net
battle entirely :)
