Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43C028E788
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgJNTsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 15:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNTsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 15:48:10 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CB9C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 12:48:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so319176pjb.5
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 12:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OI4jlCc2mmbCuBsMcD2UTZJyNOwVDeANSr5z3/+odw=;
        b=JJyREcPGOM/LWIEJK/iY+WPL8SaxmQQBo8vYKePyau79KhgqFGg+Wjek2dGp3SG6xu
         /SFyiKg4V63mSxvGV+6yk2WB+0+SUHdAERGFbaQ9CONNeJYrCgFLg8weCQaB3s4ZZiZa
         2SUQd3hEKZocFPqdwmaQsqZ8URgU7yksp7uvnnaCLRbRC/njQ53fnQwWcnUmXqXx7jgn
         WrVLXhREGXnD40rbCNOShbYWagMq+e0X76hMGmjDHwHZHU63vzHBBb9n9gZBy5YtsybU
         FrI+a1udgg+aVoIgEMX8a4CuHaryk341NvrSYO3Jfu/q8t+e+KJcQBiQZKwHP47nABaA
         SvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OI4jlCc2mmbCuBsMcD2UTZJyNOwVDeANSr5z3/+odw=;
        b=ZcxDYu/TjqzydTLAOoteg0HHSuT0nyX0towBM1G7JLATk2CMo80lxax56UsmhKEXuN
         iamCVOQLO3YsID6U57XIaQyaqxjHzQ6uBEy/h0SG2sLIDS6m4EzT5QiJzUWwal1c7Jlr
         i9yaSkdgb8eLrw5W1cLKVWTWGAQbyBqFQfkS3l/+DpTkDs4ZFtfJ3xoYY6jKPou5GJ7a
         OYcb35w6zqemI36hzagFr5Hmo/73plHuAb7ALQI474rcXvCfDHIReGVdmey+pQHQEEfs
         vAb4pI8Q9So8KOAtBp4oA7Rgohj7ul04W8hlaq5QJsAjr6pv8qXEXywBEN/IqYXVs/L4
         TCzQ==
X-Gm-Message-State: AOAM530JjVrpTlw4KtVfhmd0rmWPtsMqsfu9VseDvYN67JuuyAfkkBfX
        AoRCwB9pLqk2nqvlLIPXZS+o3RaSl9LsyG5zgyoxTWU/5QE=
X-Google-Smtp-Source: ABdhPJznhr9+I7RB/MVgLM8EdCr01C6Vtgut/hidhQ55ON7fpQqTs/pYxZhs1UgkGzuN9rFFYPn372HK4krW6rBvrnA=
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr812367pjb.66.1602704890274;
 Wed, 14 Oct 2020 12:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com> <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
In-Reply-To: <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 14 Oct 2020 12:47:59 -0700
Message-ID: <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 8:12 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 4:52 AM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > On Sun, Oct 11, 2020 at 2:01 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > There is agreement that hard_header_len should be the length of link
> > > layer headers visible to the upper layers, needed_headroom the
> > > additional room required for headers that are not exposed, i.e., those
> > > pushed inside ndo_start_xmit.
> > >
> > > The link layer header length also has to agree with the interface
> > > hardware type (ARPHRD_..).
> > >
> > > Tunnel devices have not always been consistent in this, but today
> > > "bare" ip tunnel devices without additional headers (ipip, sit, ..) do
> > > match this and advertise 0 byte hard_header_len. Bareudp, vxlan and
> > > geneve also conform to this. Known exception that probably needs to be
> > > addressed is sit, which still advertises LL_MAX_HEADER and so has
> > > exposed quite a few syzkaller issues. Side note, it is not entirely
> > > clear to me what sets ARPHRD_TUNNEL et al apart from ARPHRD_NONE and
> > > why they are needed.
> > >
> > > GRE devices advertise ARPHRD_IPGRE and GRETAP advertise ARPHRD_ETHER.
> > > The second makes sense, as it appears as an Ethernet device. The first
> > > should match "bare" ip tunnel devices, if following the above logic.
> > > Indeed, this is what commit e271c7b4420d ("gre: do not keep the GRE
> > > header around in collect medata mode") implements. It changes
> > > dev->type to ARPHRD_NONE in collect_md mode.
> > >
> > > Some of the inconsistency comes from the various modes of the GRE
> > > driver. Which brings us to ipgre_header_ops. It is set only in two
> > > special cases.
> > >
> > > Commit 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address")
> > > added ipgre_header_ops.parse to be able to receive the inner ip source
> > > address with PF_PACKET recvfrom. And apparently relies on
> > > ipgre_header_ops.create to be able to set an address, which implies
> > > SOCK_DGRAM.
> > >
> > > The other special case, CONFIG_NET_IPGRE_BROADCAST, predates git. Its
> > > implementation starts with the beautiful comment "/* Nice toy.
> > > Unfortunately, useless in real life :-)". From the rest of that
> > > detailed comment, it is not clear to me why it would need to expose
> > > the headers. The example does not use packet sockets.
> > >
> > > A packet socket cannot know devices details such as which configurable
> > > mode a device may be in. And different modes conflict with the basic
> > > rule that for a given well defined link layer type, i.e., dev->type,
> > > header length can be expected to be consistent. In an ideal world
> > > these exceptions would not exist, therefore.
> > >
> > > Unfortunately, this is legacy behavior that will have to continue to
> > > be supported.
> >
> > Thanks for your explanation. So header_ops for GRE devices is only
> > used in 2 special situations. In normal situations, header_ops is not
> > used for GRE devices. And we consider not using header_ops should be
> > the ideal arrangement for GRE devices.
> >
> > Can we create a new dev->type (like ARPHRD_IPGRE_SPECIAL) for GRE
> > devices that use header_ops? I guess changing dev->type will not
> > affect the interface to the user space? This way we can solve the
> > problem of the same dev->type having different hard_header_len values.
>
> But does that address any real issue?

It doesn't address any issue visible when using. Just to solve the
problem of the same dev->type having different hard_header_len values
which you mentioned. Making this change will not affect the user in
any way. So I think it is valuable to make this change.

> If anything, it would make sense to keep ARHPHRD_IPGRE for tunnels
> that expect headers and switch to ARPHRD_NONE for those that do not.
> As the collect_md commit I mentioned above does.

I thought we agreed that ideally GRE devices would not have
header_ops. Currently GRE devices (in normal situations) indeed do not
use header_ops (and use ARHPHRD_IPGRE as dev->type). I think we should
keep this behavior.

To solve the problem of the same dev->type having different
hard_header_len values which you mentioned. I think we should create a
new dev->type (ARPHRD_IPGRE_SPECIAL) for GRE devices that use
header_ops.

Also, for collect_md, I think we should use ARHPHRD_IPGRE. I see no
reason to use ARPHRD_NONE.

> > Also, for the second special situation, if there's no obvious reason
> > to use header_ops, maybe we can consider removing header_ops for this
> > situation.
>
> Unfortunately, there's no knowing if some application is using this
> broadcast mode *with* a process using packet sockets.

We can't always keep the interface to the user space unchanged when
fixing problems. When we fix drivers by adding hard_header_len or
removing hard_header_len, we ARE changing the interface. I did these
fixes a lot. I also changed skb->protocol when sending skbs for some
drivers, which in fact was also changing the interface. It is not
possible to keep the interface strictly unchanged, otherwise a lot of
problems will be impossible to fix.
