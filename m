Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E239382C72
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 14:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbhEQMoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 08:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbhEQMoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 08:44:10 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B5C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 05:42:53 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id q10so5503772qkc.5
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 05:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6T4maM20wkpjUTzPHq1v9/9VNN9YGOt3sjTVfNPSz1A=;
        b=nvQT7F/3r8Y0wxzeiOXETNl8o2OLI4D/k81fdrFR3vutCkklITXoCdrZz9ASp2ZBmB
         BfcbXLPGRk2XfClI7UJK4ESMbXY+KvUO4w/UGZsvTUd8MZJ8UVl40oZnlzJycdVKsWYa
         XWB6eqWVefR7y8PZpJB4NXbzuarlMoX5rifOyBq3pwdhnoFsaKvF4UIDhVx0jz0pVU/T
         R88UfdeYaLiuVfgNA1u9m/iWYDVB7+dntp+c1JfJNdJox30QTs45OTsjzXWxs+VCo/Jk
         lk510WDJIZZ8ocSVkI15fU6zHj5hxvUeU3461SsSyadTRbUH1lN2ezUL7m7uO1m8sYQa
         rFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6T4maM20wkpjUTzPHq1v9/9VNN9YGOt3sjTVfNPSz1A=;
        b=MrHX6G4nxBBf2NvNuS8cCpbIfIRtxWuF5FNpD30xFoe41UAK4zr7n5IpzTbzIPU57k
         BSJjUPQ9cTVwVUi7UNTyrbaXQ342A8b/LSp8R/OdXyaUdM69Irv/UaizOstz4EzOnnKc
         E/30jlxn2CvvyfKuvWZ7vjyZ3n0nN78DDu/NYDI/NkVrIp96kMJs5mzsp8+3Qo6Cmh8z
         AnQLTGx6IBcs9V0dO+UqkZRo9IwjwN49nwWQ0m+/i/9T10P3uhiyRyFBncS8vG3Nmak2
         1/UTirMC3tJEofGp94WcJs7Z02DGz5y3RHW5wOCixbTKlFEBWl6CW7avoGQfXY28QXHC
         GPcw==
X-Gm-Message-State: AOAM532yA2Ga7+AJk9n41NiNdF1HZBWIG2Bn/i1xWfatfuspQE+znu1+
        U6oTf89BGvVesT3jvLeXq480wNyoJCuSYRegUjYZhA==
X-Google-Smtp-Source: ABdhPJyPjy1frJ81yPJoA2iI4XVIbHNfQ2CW7ecWz7Hh38SxdjORxtgenMKkbPSq2yE5PrFX69JqZnQX3kEyDd/YeSM=
X-Received: by 2002:ae9:e850:: with SMTP id a77mr52728763qkg.424.1621255372672;
 Mon, 17 May 2021 05:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008ce91e05bf9f62bc@google.com> <CACT4Y+a6L_x22XNJVX+VYY-XKmLQ0GaYndCVYnaFmoxk58GPgw@mail.gmail.com>
 <20210508144657.GC4038@breakpoint.cc> <20210513005608.GA23780@salvia>
 <CACT4Y+YhQQtHBErLYRDqHyw16Bxu9FCMQymviMBR-ywiKf3VQw@mail.gmail.com> <20210517105745.GA19031@salvia>
In-Reply-To: <20210517105745.GA19031@salvia>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 May 2021 14:42:41 +0200
Message-ID: <CACT4Y+Y1M7ewJmipTB=B4fbYR2DMn_kX69Vks93yo=g2g-iXKw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 12:57 PM Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
> > > On Sat, May 08, 2021 at 04:46:57PM +0200, Florian Westphal wrote:
> > > > Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > > IMPORTANT: if you fix the issue, please add the following tag t=
o the commit:
> > > > > > Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.=
com
> > > > >
> > > > > Is this also fixed by "netfilter: arptables: use pernet ops struc=
t
> > > > > during unregister"?
> > > > > The warning is the same, but the stack is different...
> > > >
> > > > No, this is a different bug.
> > > >
> > > > In both cases the caller attempts to unregister a hook that the cor=
e
> > > > can't find, but in this case the caller is nftables, not arptables.
> > >
> > > I see no reproducer for this bug. Maybe I broke the dormant flag hand=
ling?
> > >
> > > Or maybe syzbot got here after the arptables bug has been hitted?
> >
> > syzbot always stops after the first bug to give you perfect "Not
> > tainted" oopses.
>
> Looking at the log file:
>
> https://syzkaller.appspot.com/text?tag=3DCrashLog&x=3D110a3096d00000
>
> This is mixing calls to nftables:
>
> 14:43:16 executing program 0:
> r0 =3D socket$nl_netfilter(0x10, 0x3, 0xc)
> sendmsg$NFT_BATCH(r0, &(0x7f000000c2c0)=3D{0x0, 0x0, &(0x7f0000000000)=3D=
{&(0x7f00000001c0)=3D{{0x9}, [@NFT_MSG_NEWTABLE=3D{0x28, 0x0, 0xa, 0x3, 0x0=
, 0x0, {0x2}, [@NFTA_TABLE_NAME=3D{0x9, 0x1, 'syz0\x00'}, @NFTA_TABLE_FLAGS=
=3D{0x8}]}], {0x14}}, 0x50}}, 0x0)
>
> with arptables:
>
> 14:43:16 executing program 1:
> r0 =3D socket$inet_udp(0x2, 0x2, 0x0)
> setsockopt$ARPT_SO_SET_REPLACE(r0, 0x0, 0x60, &(0x7f0000000000)=3D{'filte=
r\x00', 0x4, 0x4, 0x3f8, 0x310, 0x200, 0x200, 0x310, 0x310, 0x310, 0x4, 0x0=
, {[{{@arp=3D{@broadcast, @rand_addr, 0x87010000, 0x0, 0x0, 0x0, {@mac=3D@l=
ink_local}, {@mac}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 'bridge0\x00', 'erspan0\x=
00'}, 0xc0, 0x100}, @unspec=3D@RATEEST=3D{0x40, 'RATEEST\x00', 0x0, {'syz1\=
x00', 0x0, 0x4}}}, {{@arp=3D{@initdev=3D{0xac, 0x1e, 0x0, 0x0}, @local, 0x0=
, 0x0, 0x0, 0x0, {@mac=3D@remote}, {}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 'veth0=
_to_bridge\x00', 'geneve1\x00'}, 0xc0, 0x100}, @unspec=3D@RATEEST=3D{0x40, =
'RATEEST\x00', 0x0, {'syz0\x00', 0x0, 0x2}}}, {{@arp=3D{@local, @multicast1=
, 0x0, 0x0, 0x0, 0x0, {}, {@mac=3D@broadcast}, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0=
, 'veth0_to_batadv\x00', 'veth0_to_hsr\x00'}, 0xc0, 0x110}, @mangle=3D{0x50=
, 'mangle\x00', 0x0, {@mac=3D@remote, @mac=3D@local, @multicast2, @initdev=
=3D{0xac, 0x1e, 0x0, 0x0}}}}], {{[], 0xc0, 0xe8}, {0x28}}}}, 0x448)
>
> arptables was buggy at the time this bug has been reported.
>
> Am I understanding correctly the syzbot log?
>
> I wonder if the (buggy) arptables removed the incorrect hook from
> nftables, then nftables crashed on the same location when removing the
> hook. I don't see a clear sequence for this to happen though.
>
> Would it be possible to make syzbot exercise the NFT_MSG_NEWTABLE
> codepath (with NFTA_TABLE_FLAGS) to check if the problem still
> persists?


This happened only once so far 40 days ago. So if you consider it
possible that it actually happened due to the arptables issue, I would
mark it as invalid (with "#syz invalid") and move on. If it ever
happens again, syzbot will notify, but then we know it happened with
the aprtables issue fixed.

This bug does not have a reproducer, so it's not possible to test this
exact scenario. It's possible to replay the whole log, but somehow
syzkaller wasn't able to retrigger it by replaying the log. I don't
think it's worth our time at this point.
