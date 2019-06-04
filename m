Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFCA33E41
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFDFTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:19:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:32896 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDFTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:19:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so2053670qkc.0;
        Mon, 03 Jun 2019 22:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AI/wiY4OE7LFN+zbOeudtptKGaOOw11VFgeVZPkIngk=;
        b=eTOvgP+B3Bx3r8/aYA23MTpcsuuDvO4Y3bWDuIPmwdwFjRIR1WYqLCQy5X7WHJBFFN
         fc6h4C4inrXkzc0cpm+s1InVpDNhhqNvPLz+SKfLcGmnbXp3wjmprAyEznbS2MR3FpPF
         4Ljwhgjv0+JBNf4Hv/pgbRt2J7C6VehCsvsZC68k4CB06U/BPIxnOM33sr+kEc/7P+n1
         T9Cd4G+7RxmqY7P0iwxjH9sWZ6u1n+jMO5r5sDnyXDczWVOq4qk+B9w+wo0HB0SUIQ7E
         VYOxLdVU74LQOU7avgDbSACv+pZ3GUiZNv9R88MJ0ENNzb5D1UNXAbt09m3Z8JSqwF6S
         n0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AI/wiY4OE7LFN+zbOeudtptKGaOOw11VFgeVZPkIngk=;
        b=HT99uE2lSpHHGaiQLWj6swx6O/uajBZcjCrd+EaaAckL689bZipV0z/aErIX/wxee6
         HFw2JH+AZzGX2zQBRoz3wzwc1VbZWwsT5ZIMX0d+ByR2lv6M97QoO0tNloU5JDfWJtOY
         pduTGDkmt/lMkl084KcDZ96puBeUhdls7YzTCARsXMn48gv9GUiJhBcFGCdVVxl7ymY1
         kqf0rO9CcJS/X4oLt3pYeIjTQeQVzNqNWjrD8zvQ7qRdm5C5DT6qhfzdSr1Z9WcOEWvL
         eJwpchb3fY0ZUJoHyBbMjaigni9RL+zVZppL1Qb19wcrHGFTkMiJV+zJ2pBww99IsK/O
         tQyw==
X-Gm-Message-State: APjAAAUAAPHqiPt82FjmbK4Wj75oY7KvbItaapNHWnRfq2fZnv9fcM/s
        MyU5qNvK/A/cAZhyEq2f3DKW70H3fe2OtF7KDbQ=
X-Google-Smtp-Source: APXvYqyFo0x0RcfwJRocN4dLTHp//JlcXwLvfeYAthMGCpTCHbQk2HvGHrrFuf0TaECIE8ndvZoRgAa9ylkOOXKJ0gQ=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr25942378qkj.39.1559625540076;
 Mon, 03 Jun 2019 22:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
 <20190601124233.5a130838@cakuba.netronome.com> <CAJ+HfNjbALzf4SaopKe3pA4dV6n9m30doai_CLEDB9XG2RzjOg@mail.gmail.com>
 <f7e9b1c8f358a4bb83f01ab76dcc95195083e2bf.camel@mellanox.com>
In-Reply-To: <f7e9b1c8f358a4bb83f01ab76dcc95195083e2bf.camel@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 4 Jun 2019 07:18:48 +0200
Message-ID: <CAJ+HfNjZKawpGXgyLbVmpNAJxrgc0Xhy4+ihTnhTCt3Ei8aw8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 23:20, Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Mon, 2019-06-03 at 11:04 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Sat, 1 Jun 2019 at 21:42, Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:
> > > On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:
> > > > On Fri, 2019-05-31 at 11:42 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > > > >
> > > > > All XDP capable drivers need to implement the
> > > > > XDP_QUERY_PROG{,_HW}
> > > > > command of ndo_bpf. The query code is fairly generic. This
> > > > > commit
> > > > > refactors the query code up from the drivers to the netdev
> > > > > level.
> > > > >
> > > > > The struct net_device has gained two new members: xdp_prog_hw
> > > > > and
> > > > > xdp_flags. The former is the offloaded XDP program, if any, and
> > > > > the
> > > > > latter tracks the flags that the supplied when attaching the
> > > > > XDP
> > > > > program. The flags only apply to SKB_MODE or DRV_MODE, not
> > > > > HW_MODE.
> > > > >
> > > > > The xdp_prog member, previously only used for SKB_MODE, is
> > > > > shared
> > > > > with
> > > > > DRV_MODE. This is OK, due to the fact that SKB_MODE and
> > > > > DRV_MODE are
> > > > > mutually exclusive. To differentiate between the two modes, a
> > > > > new
> > > > > internal flag is introduced as well.
> > > >
> > > > Just thinking out loud, why can't we allow any combination of
> > > > HW/DRV/SKB modes? they are totally different attach points in a
> > > > totally
> > > > different checkpoints in a frame life cycle.
> > >
> > > FWIW see Message-ID: <20190201080236.446d84d4@redhat.com>
> > >
> >
> > I've always seen the SKB-mode as something that will eventually be
> > removed.
> >
>
> I don't think so, we are too deep into SKB-mode.
>

You might be right. :-(

Are you envisioning sk_buff specfic XDP_SKB functions, that only apply
for XDP_SKB? Ick.

> > Clickable link:
> > https://lore.kernel.org/netdev/20190201080236.446d84d4@redhat.com/ :-
> > P
> >
>
> So we are all hanging on Jesper's refactoring ideas that are not
> getting any priority for now :).
>
>
> > > > Down the road i think we will utilize this fact and start
> > > > introducing
> > > > SKB helpers for SKB mode and driver helpers for DRV mode..
> > >
> > > Any reason why we would want the extra complexity?  There is
> > > cls_bpf
> > > if someone wants skb features after all..
>
> Donno, SKB mode is earlier in the stack maybe ..
>
>
