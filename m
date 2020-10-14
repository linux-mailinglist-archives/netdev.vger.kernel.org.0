Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5DE28E7D1
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgJNUT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNUTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 16:19:55 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC96C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 13:19:54 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id f15so143279uaq.9
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 13:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrvJrX65U6vLiPmuTAVjyW8jYHeV38/WEfDDQB/XuhM=;
        b=AO7dJoJ5H0NzaZw1WOSPqWlaBhRHBLMpXXOvxma5gZM+tANJxVrQPHRIwqtTmv4kD2
         1/MKF537RrtJv3QmGUrxQAMxanGXgDJF/kV9EsTqWA+55j5hgPLMxSAcvfmOZh1WkWGP
         l0US7Eg8pZ4hHnr3uRu+TEVzJXEIG2t1X7xFyt9r1aqSqPxD4aay3KO4y+L4eafNxV2p
         zgi5ME6yIzmP3VCHFaPZeMNfFbNpeWzjzbkq3XMMfvlSdFz/IzD7tut6WsFDs4IdRXJh
         SroI4ZXGmjr30smFf7/2yFuYJBuTcb0+qcRiXp6VTA2xovfiU5stR78JZAKH7ihJuqGN
         5sdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrvJrX65U6vLiPmuTAVjyW8jYHeV38/WEfDDQB/XuhM=;
        b=fmvORaP3bPPzaHHlhYiqSd4/Grada4dI6wMa8OQczxy8OmTYOiofmfuEP+c3ppRavc
         Wb8ko2qOXT+C4LlgKZGI+aMW0i+yRQxdHooStp0hc8jTeYJCxvSppCHtLcvD1lPyTLG3
         pwcT245RGyB1xYGqfMxeRdXS8bQEH4Hpn/GeKtYKjNGubGeTlca4IEOwfZfIAnLUDUQj
         8TifUELfht9BW/in6psqrHvLAFgbqMonPAAbuP5MUfWxBSDsqnaoCvWONFzWtYvnYLap
         VzNXt9Hkr/klfzJrIBQrEqDOLvaCaEk/czGvZehvQ724L4ge1xtuBWwGYLc8GHqHdzdM
         Cubw==
X-Gm-Message-State: AOAM530rnQwOP9UxLK2MK40k/sldhbSEhFBKo4VKYFOnDVC3oXNTfJ6I
        QRGzieynrLohI6cqgqlYxJswckfEJu0=
X-Google-Smtp-Source: ABdhPJzXE1/9tqxNHfiPSQtgUHJNmGF14GA8m8FT/WoZK1gkWbcr0dUcwr6n2TNSF2qFkklyymwDfA==
X-Received: by 2002:ab0:6156:: with SMTP id w22mr414351uan.122.1602706792217;
        Wed, 14 Oct 2020 13:19:52 -0700 (PDT)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id i3sm105179vkp.6.2020.10.14.13.19.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 13:19:51 -0700 (PDT)
Received: by mail-vk1-f177.google.com with SMTP id m3so69673vki.12
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 13:19:50 -0700 (PDT)
X-Received: by 2002:a1f:3f4d:: with SMTP id m74mr799775vka.12.1602706789747;
 Wed, 14 Oct 2020 13:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com> <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
In-Reply-To: <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 14 Oct 2020 16:19:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
Message-ID: <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 3:48 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 8:12 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2020 at 4:52 AM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > On Sun, Oct 11, 2020 at 2:01 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > There is agreement that hard_header_len should be the length of link
> > > > layer headers visible to the upper layers, needed_headroom the
> > > > additional room required for headers that are not exposed, i.e., those
> > > > pushed inside ndo_start_xmit.
> > > >
> > > > The link layer header length also has to agree with the interface
> > > > hardware type (ARPHRD_..).
> > > >
> > > > Tunnel devices have not always been consistent in this, but today
> > > > "bare" ip tunnel devices without additional headers (ipip, sit, ..) do
> > > > match this and advertise 0 byte hard_header_len. Bareudp, vxlan and
> > > > geneve also conform to this. Known exception that probably needs to be
> > > > addressed is sit, which still advertises LL_MAX_HEADER and so has
> > > > exposed quite a few syzkaller issues. Side note, it is not entirely
> > > > clear to me what sets ARPHRD_TUNNEL et al apart from ARPHRD_NONE and
> > > > why they are needed.
> > > >
> > > > GRE devices advertise ARPHRD_IPGRE and GRETAP advertise ARPHRD_ETHER.
> > > > The second makes sense, as it appears as an Ethernet device. The first
> > > > should match "bare" ip tunnel devices, if following the above logic.
> > > > Indeed, this is what commit e271c7b4420d ("gre: do not keep the GRE
> > > > header around in collect medata mode") implements. It changes
> > > > dev->type to ARPHRD_NONE in collect_md mode.
> > > >
> > > > Some of the inconsistency comes from the various modes of the GRE
> > > > driver. Which brings us to ipgre_header_ops. It is set only in two
> > > > special cases.
> > > >
> > > > Commit 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address")
> > > > added ipgre_header_ops.parse to be able to receive the inner ip source
> > > > address with PF_PACKET recvfrom. And apparently relies on
> > > > ipgre_header_ops.create to be able to set an address, which implies
> > > > SOCK_DGRAM.
> > > >
> > > > The other special case, CONFIG_NET_IPGRE_BROADCAST, predates git. Its
> > > > implementation starts with the beautiful comment "/* Nice toy.
> > > > Unfortunately, useless in real life :-)". From the rest of that
> > > > detailed comment, it is not clear to me why it would need to expose
> > > > the headers. The example does not use packet sockets.
> > > >
> > > > A packet socket cannot know devices details such as which configurable
> > > > mode a device may be in. And different modes conflict with the basic
> > > > rule that for a given well defined link layer type, i.e., dev->type,
> > > > header length can be expected to be consistent. In an ideal world
> > > > these exceptions would not exist, therefore.
> > > >
> > > > Unfortunately, this is legacy behavior that will have to continue to
> > > > be supported.
> > >
> > > Thanks for your explanation. So header_ops for GRE devices is only
> > > used in 2 special situations. In normal situations, header_ops is not
> > > used for GRE devices. And we consider not using header_ops should be
> > > the ideal arrangement for GRE devices.
> > >
> > > Can we create a new dev->type (like ARPHRD_IPGRE_SPECIAL) for GRE
> > > devices that use header_ops? I guess changing dev->type will not
> > > affect the interface to the user space? This way we can solve the
> > > problem of the same dev->type having different hard_header_len values.
> >
> > But does that address any real issue?
>
> It doesn't address any issue visible when using. Just to solve the
> problem of the same dev->type having different hard_header_len values
> which you mentioned. Making this change will not affect the user in
> any way. So I think it is valuable to make this change.
>
> > If anything, it would make sense to keep ARHPHRD_IPGRE for tunnels
> > that expect headers and switch to ARPHRD_NONE for those that do not.
> > As the collect_md commit I mentioned above does.
>
> I thought we agreed that ideally GRE devices would not have
> header_ops. Currently GRE devices (in normal situations) indeed do not
> use header_ops (and use ARHPHRD_IPGRE as dev->type). I think we should
> keep this behavior.
>
> To solve the problem of the same dev->type having different
> hard_header_len values which you mentioned. I think we should create a
> new dev->type (ARPHRD_IPGRE_SPECIAL) for GRE devices that use
> header_ops.
>
> Also, for collect_md, I think we should use ARHPHRD_IPGRE. I see no
> reason to use ARPHRD_NONE.

What does ARPHRD_IPGRE define beyond ARPHRD_NONE? And same for
ARPHRD_TUNNEL variants. If they are indistinguishable, they are the
same and might as well have the same label.

> > > Also, for the second special situation, if there's no obvious reason
> > > to use header_ops, maybe we can consider removing header_ops for this
> > > situation.
> >
> > Unfortunately, there's no knowing if some application is using this
> > broadcast mode *with* a process using packet sockets.
>
> We can't always keep the interface to the user space unchanged when
> fixing problems. When we fix drivers by adding hard_header_len or
> removing hard_header_len, we ARE changing the interface. I did these
> fixes a lot. I also changed skb->protocol when sending skbs for some
> drivers, which in fact was also changing the interface. It is not
> possible to keep the interface strictly unchanged, otherwise a lot of
> problems will be impossible to fix.

I understand that for bug fixes this is sometimes unavoidable. I don't
think code cleanup is reason enough, though.
