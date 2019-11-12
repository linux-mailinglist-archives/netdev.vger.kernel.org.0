Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA167F975D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLRjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:39:33 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44112 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLRjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:39:33 -0500
Received: by mail-qv1-f66.google.com with SMTP id d3so5132940qvs.11;
        Tue, 12 Nov 2019 09:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7DIrP1Yf+X4ZzvL9JgMF6ymSVIXZzSV6EaGGlyzgr8E=;
        b=F0+AzZDsiOs2+N9QKh4Krn+lX3z95dKwqiHgk5VjKmukaVewRVBZhGg42+FGR8cryl
         j2heo0VGJucBp/mk8butiXDk/KnSctCLK7T5l2GL4vVZhRXoiO/6f75Hgmz85rXeLets
         cuAsZYepd3UN4wBGRN/xMJ1qCq6GozZUhf9rRB8VHFrEholud61pV+Ok2WuWax3nr3tW
         35LtPvkBoacPshNHxKbH/xkCSdiep0vt2gy29JpR+5khUAn+mtq8fu1p3v8rRIsl4IIx
         mmAz3nc9BYlRWVu+O93AN9fI1wCNavwp8frJfcA0+2tTHwD3WiZfzYvgE8/LZIpUZqMV
         QwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7DIrP1Yf+X4ZzvL9JgMF6ymSVIXZzSV6EaGGlyzgr8E=;
        b=KG6j8ejOWRFgw+4ord1M3hKT4luiolR109EcRgwr0FKU/MX/Ew6aShZx5u3htk0/En
         qjoPH+qyJ+udsZcVOoCrV04Vwa3Axy5ewAgvXk3W9G5ZKx2m2Bw8lTDmLtIa2+dSMJZO
         U9AdwUV3LggLdeyqEaFWFrgeJdHHoOCBbuK/zzoSfJ1KfQxiT/hSOo7FTfn/j2HL7M6o
         n1EE28grzPi581yFeOBsBHuOzVU24CR89sJxk2wLS9V/w4HGpEmmFO5xmNq/4JHDIL+b
         3wTbr4Lxf46Wob/AkyWvTDr0PWe1Yt3Yh2EVQxg9qDfel5PAwKLimmS/knlCHOjOKwUA
         0pqw==
X-Gm-Message-State: APjAAAWDvoEGa7ULUqlB1vjpWI26KN2fUO/KRCEQH74kmKRccHco0qZW
        0rG5YFG3LhLdGn+o0Q4QRaYQ7855G6uEciYK9iw=
X-Google-Smtp-Source: APXvYqzgEhcDmcaFlF19CO4Y4ZVJje318juiacOkBQLSxLi13vs2iRrv5SqCROIvkOZS3JrdMZ0ahduV4+TdzehpkF0=
X-Received: by 2002:a0c:9a43:: with SMTP id q3mr30455153qvd.101.1573580371802;
 Tue, 12 Nov 2019 09:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk> <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com> <87wocqrz2v.fsf@toke.dk>
In-Reply-To: <87wocqrz2v.fsf@toke.dk>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 12 Nov 2019 09:38:55 -0800
Message-ID: <CALDO+SZEU7yfZK_JTPKQm-8HR_HMUfNjdMMik862dJDBc8SGQA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 8:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>
> > On 19/10/23 (=E6=B0=B4) 2:45:05, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >>
> >>> I think for sysadmins in general (not OVS) use case I would work
> >>> with Jesper and Toke. They seem to be working on this specific
> >>> problem.
> >>
> >> We're definitely thinking about how we can make "XDP magically speeds =
up
> >> my network stack" a reality, if that's what you mean. Not that we have
> >> arrived at anything specific yet...
> >>
> >> And yeah, I'd also be happy to discuss what it would take to make a
> >> native XDP implementation of the OVS datapath; including what (if
> >> anything) is missing from the current XDP feature set to make this
> >> feasible. I must admit that I'm not quite clear on why that wasn't the
> >> approach picked for the first attempt to speed up OVS using XDP...
> >
> > Here's some history from William Tu et al.
> > https://linuxplumbersconf.org/event/2/contributions/107/
> >
> > Although his aim was not to speed up OVS but to add kernel-independent
> > datapath, his experience shows full OVS support by eBPF is very
> > difficult.
>
> Yeah, I remember seeing that presentation; it still isn't clear to me
> what exactly the issue was with implementing the OVS datapath in eBPF.
> As far as I can tell from glancing through the paper, only lists program
> size and lack of loops as limitations; both of which have been lifted
> now.
>
Sorry it's not very clear in the presentation and paper.
Some of the limitations are resolved today, let me list my experiences.

This is from OVS's feature requirements:
What's missing in eBPF
- limited stack size (resolved now)
- limited program size (resolved now)
- dynamic loop support for OVS actions applied to packet
  (now bounded loop is supported)
- no connection tracking/alg support (people suggest to look cilium)
- no packet fragment/defragment support
- no wildcard table/map type support
I think it would be good to restart the project again using
existing eBPF features.

What's missing in XDP
- clone a packet: this is very basic feature for a switch to
  broadcast/multicast. I understand it's hard to implement.
  A workaround is to XDP_PASS and let tc do the clone. But slow.

Because of no packet cloning support, I didn't try implementing
OVS datapath in XDP.

> The results in the paper also shows somewhat disappointing performance
> for the eBPF implementation, but that is not too surprising given that
> it's implemented as a TC eBPF hook, not an XDP program. I seem to recall
> that this was also one of the things puzzling to me back when this was
> presented...

Right, the point of that project is not performance improvement.
But sort of to see how existing eBPF feature can be used to implement
all features needed by OVS datapath.

Regards,
William
