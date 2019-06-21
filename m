Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259B14EFA8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 21:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFUTwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 15:52:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39142 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFUTwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 15:52:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so6985144ljh.6
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EPSJqa3r1kdyeW63tEDVfee+BtIlOEavn4pUB+slDmE=;
        b=FxvgRGtyu1GHn+LoCk6L7b9S6nnVEJp3In9a+9NdlESKonBgQGNXxtTcLCDGNZqg6F
         DCqMNHj428Wv/9sYXFn2CchLvY/+N1Y/9qz7UP9fBQY6qN8pi3407yWqxxE1sm/g0+us
         45iFIHBMz3SCku+NxzceHGk5ejHCaad47CGj3etT+fwZVcGjtls2XTrWUcLrIHkuAVUb
         XwYMzgieQNSogPEkhAh0nBnz+QANVzF2m2YEh0PkZlGsUHR3aFLDE4XuhBP9omb8Ace6
         NhKHqOegkITJgEPr9lp6fczKnbzepU2dhWH16ai78TcJeVcOOWhs2bqzjp8VbhZOzEQK
         QRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EPSJqa3r1kdyeW63tEDVfee+BtIlOEavn4pUB+slDmE=;
        b=lBYg13g61Srhi02kynfM6Pw50e2QuSmAh3JRqRoQRNpjTk0C/EKGHGkJZzFeskKAh5
         h3PS83XwxFgOyp96Jvk0+t6rJmc+crGWaKj845miZDvQ5ikUSNYXtZlswBqtzoZYgRxw
         /YKOkyLhlzlPMbpKCG7npZwzaboSE3I0vVjJ5gJIDtUJW9dcZoZL6nqOhqpaDHB4wSFs
         HIphDZXfXaIGPaTlKxnv7GRUpVvILqwaDcFhyXzhiNPZLkKnb6fgc6YnbJ/yKmTH2AsK
         WuWRTWtuAMjyxDpQbjooye99+vhVdWba188yATcV6V7926Kr0tQRLKZCKev97vF7y0+m
         V4uQ==
X-Gm-Message-State: APjAAAUSS1DvVRMd3wkM7GFTRkz9WUkdkZU1VYJljfe8p5GvQSIlKvLx
        HKGpnk+3mDYnQNyS7RDTUpjBCokPTQORhLrq7VjDZg==
X-Google-Smtp-Source: APXvYqwmgr6JVDpHjL3J2y/q0YsZxYtmOKk21hZ72BiolF78wfaNNrNM5R1VurDkz55ydTUUelxfcrPrq9vhsyfWjCU=
X-Received: by 2002:a2e:8007:: with SMTP id j7mr28448543ljg.191.1561146734869;
 Fri, 21 Jun 2019 12:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190618120024.16788-1-maximmi@mellanox.com> <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
In-Reply-To: <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Fri, 21 Jun 2019 12:52:03 -0700
Message-ID: <CALzJLG-eCiYYshkm_op1PqkCmxTmdDdPSGbX7g2JMqTb8QXyJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 2:13 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Tue, 18 Jun 2019 at 14:00, Maxim Mikityanskiy <maximmi@mellanox.com> w=
rote:
> >
> > This series contains improvements to the AF_XDP kernel infrastructure
> > and AF_XDP support in mlx5e. The infrastructure improvements are
> > required for mlx5e, but also some of them benefit to all drivers, and
> > some can be useful for other drivers that want to implement AF_XDP.
> >
> > The performance testing was performed on a machine with the following
> > configuration:
> >
> > - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> > - Mellanox ConnectX-5 Ex with 100 Gbit/s link
> >
> > The results with retpoline disabled, single stream:
> >
> > txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> > rxdrop: 12.2 Mpps
> > l2fwd: 9.4 Mpps
> >
> > The results with retpoline enabled, single stream:
> >
> > txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
> > rxdrop: 9.9 Mpps
> > l2fwd: 6.8 Mpps
> >
> > v2 changes:
> >
> > Added patches for mlx5e and addressed the comments for v1. Rebased for
> > bpf-next.
> >
> > v3 changes:
> >
> > Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
> > Bj=C3=B6rn's comments for coding style. Fixed a bug in error handling f=
low in
> > mlx5e_open_xsk.
> >
> > v4 changes:
> >
> > UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> > half of the available amount of RX queues are regular queues, and the
> > upper half are XSK RX queues. The patch "xsk: Extend channels to suppor=
t
> > combined XSK/non-XSK traffic" was dropped. The final patch was reworked
> > accordingly.
> >
> > Added "net/mlx5e: Attach/detach XDP program safely", as the changes
> > introduced in the XSK patch base on the stuff from this one.
> >
> > Added "libbpf: Support drivers with non-combined channels", which align=
s
> > the condition in libbpf with the condition in the kernel.
> >
> > Rebased over the newer bpf-next.
> >
> > v5 changes:
> >
> > In v4, ethtool reports the number of channels as 'combined' and the
> > number of XSK RX queues as 'rx' for mlx5e. It was changed, so that 'rx'
> > is 0, and 'combined' reports the double amount of channels if there is
> > an active UMEM - to make libbpf happy.
> >
> > The patch for libbpf was dropped. Although it's still useful and fixes
> > things, it raises some disagreement, so I'm dropping it - it's no longe=
r
> > useful for mlx5e anymore after the change above.
> >
>
> Just a heads-up: There are some checkpatch warnings (>80 chars/line)

Thanks Bjorn for your comment, in mlx5 we allow up to 95 chars per line,
otherwise it is going to be an ugly zigzags.

> for the mlnx5 driver parts, and the series didn't apply cleanly on
> bpf-next for me.
>
> I haven't been able to test the mlnx5 parts.
>
> Parts of the series are unrelated/orthogonal, and could be submitted
> as separate series, e.g. patches {1,7} and patches {3,4}. No blockers
> for me, though.
>
> Thanks for the hard work!
>
> For the series:
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
