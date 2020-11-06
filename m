Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD212A9D96
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgKFTJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgKFTJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 14:09:54 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11365C0613CF;
        Fri,  6 Nov 2020 11:09:54 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 13so2233339pfy.4;
        Fri, 06 Nov 2020 11:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zWilfhNuzCYQXGWyPu144qq5XXA5zk2vBoBbppBQ1Hk=;
        b=ZoT11CJgpo+UyUVuHfpRFOp+yu6hHMe/Q86jXOsBh5ut06sHVsVeUh50wTZ4eR0hJd
         68bqiTsrTsmeOyOanfB/xz7aOQtiJnPKN2JxcC6nsyDbw+xtgkePfOb9X3Md1lwHByDP
         KdKZnQKwLwDXjDX6dBXGoOOVUZzYTpmy4u7B2kYaqXX6GoQv3m57vjF42J6SI3dv0MsB
         YictuuqbYIEBtOC1E0j3iuRVfn2HqYIMec/nLHXSh3wWmchquge5CLe94/2ItyXkR+N9
         XrAXjxsTskEYBIH9XpdSJP0YPPvPCH+G68QLM4mMZM8x+NukGRgRF9nyvbrr4ZMd0L3J
         0g1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zWilfhNuzCYQXGWyPu144qq5XXA5zk2vBoBbppBQ1Hk=;
        b=fM3L7Xr99d/oysLG9roJgIAsZENAcSaK3Th/+PZq0yf2244KGuGLyHiJzwIyJygWjn
         vMQguaXajdhMRywJ0gPZmoHi8MXSJwUY9oY4YlRbw84IZ5ls4UAmMjqoz7FRgZ4oc9ff
         K5aAsA6OtPY+euEgnq4JHw73eFyf5JuTn6ui+R44I+qxHFACU6E+Heof5rng63aF1bz9
         stET4ZWNRaebbL0iBRl7ysxg+t8zD4PB94en+I3jDtB8ZJ5wHCb3+xzJOx5SOIQhWzs2
         ZCq+hlw4fkRyZhuleILiF4OQ7/Nm/WvbM2UVyv+lXA/2jvW84h9B4QTWcBt8+ks7syH7
         WdCQ==
X-Gm-Message-State: AOAM531PNZs7ve9qZiSpj459/lieLWGTjM5+o0cCpLwDlfONKY49tB/r
        toyr1Sfy/gNnt3LBNocargZ557q2spSosiy2nrbn+KsWUXQuAw==
X-Google-Smtp-Source: ABdhPJzvGct3A0nGGZ0oqUYkla1tYZiCemnARlLChRn5bl1E88r6pOtKFfQ8GbPe+3PNoHDMkWbzMrBd+gdxQJNtQOQ=
X-Received: by 2002:a17:90a:e014:: with SMTP id u20mr1067222pjy.117.1604689793615;
 Fri, 06 Nov 2020 11:09:53 -0800 (PST)
MIME-Version: 1.0
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-2-git-send-email-magnus.karlsson@gmail.com>
 <20201104153320.66cecba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJ8uoz3-tjXekU=kR+HfMhGBcHtAFnKGq1ZvpFq99T_S-mknPg@mail.gmail.com> <20201105074511.6935e8b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105074511.6935e8b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 6 Nov 2020 20:09:42 +0100
Message-ID: <CAJ8uoz1nyv-_X5+z-nwyDOc628uYwmUVJCLkXJpsHgFK_QV+wQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] i40e: introduce lazy Tx completions for
 AF_XDP zero-copy
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 4:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 5 Nov 2020 15:17:50 +0100 Magnus Karlsson wrote:
> > > I feel like this needs a big fat warning somewhere.
> > >
> > > It's perfectly fine to never complete TCP packets, but AF_XDP could b=
e
> > > used to implement protocols in user space. What if someone wants to
> > > implement something like TSQ?
> >
> > I might misunderstand you, but with TSQ here (for something that
> > bypasses qdisk and any buffering and just goes straight to the driver)
> > you mean the ability to have just a few buffers outstanding and
> > continuously reuse these? If so, that is likely best achieved by
> > setting a low Tx queue size on the NIC. Note that even without this
> > patch, completions could be delayed. Though this patch makes that the
> > normal case. In any way, I think this calls for some improved
> > documentation.
>
> TSQ tries to limit the amount of data the TCP stack queues into TC/sched
> and drivers. Say 1MB ~ 16 GSO frames. It will not queue more data until
> some of the transfer is reported as completed.

Thanks. Got it. There is one more use case I can think of for quick
completions of Tx buffers and that is if you have metadata associated
with the completion, for example a Tx time stamp. Not that this
capability exists today, but hopefully it will get added at some
point.

Anyway after some more thinking, I would like to remove this patch
from the patch set and put it on the shelf for a while. The reason
behind this is that if we can get a good busy poll solution for AF_XDP
sockets, then we do not need this patch. With busy-poll the choice of
when to complete Tx buffers would be left to the application in a nice
way. If the application would like to quickly get buffers completed
(at the cost of some performance) it would call sendto() (or friends)
soon after it put the packet on the Tx ring. If max throughput is
desired with no regard to when a buffer is returned, then sendto()
would be called only after a large batch of packets have been put on
the Tx ring. No need for any threshold or new knob, in other words,
much nicer. So let us wait for Bj=C3=B6rn's busy poll patches and see where
it leads. Please protest if you do not agree. Otherwise I will submit
a v2 without this patch and with Maciej's proposed simplification.

> IIUC you're allowing up to 64 descriptors to linger without reporting
> back that the transfer is done. That means that user space implementing
> a scheme similar to TSQ may see its transfers stalled.
