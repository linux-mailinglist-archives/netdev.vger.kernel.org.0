Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECCE3AFDA1
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFVHOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFVHOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:14:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D7DC061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:12:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u2so1244642plf.3
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 00:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rw4KoUm2hcTt6WSUNhF2TANUZSIC99GXIdnoPj/lEl0=;
        b=ibA6V70wJZ9Okkz13p28pZnmM4ysLYZMGAstSSHd2ixn5ClNBAudPCgKqZZfNrSb/o
         BDjb0OzOdx2LBH++Sx+HhJ5JeF5P+ETFl3TDocTNfxIBuyrU0wmrMNiGue4xLKBaUwWX
         6J4koqVdsC20h0qG9kVwAE6hQ3YsoW5m1kfyQKcFzgKrQF8PNLdXXdfXkjza8N+w6Njh
         toGIUsc+2Km2dK0fNhdGAbTrmxOLanR7QBEbWyHZNmK5K9fLZv8/8W8dWVHfc4zZBEEd
         2h0cJOCopWGRC2H8YpeCiHr9+fku+8hnHTgSUl/V7ojZnCB0uFKhIPNt4gtN4jbyzzMK
         Yp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rw4KoUm2hcTt6WSUNhF2TANUZSIC99GXIdnoPj/lEl0=;
        b=YKL7lUQ3W9v+Hig1VQQ1QfWpKpdgB/QREB0mubrtQ7pMsF45zlDapMXCLH8YYdR9jr
         6jShQCXeppGG9LZ4HMAhXn+/ybCM1KjTSnHlqIJgDtNr8FFVc6Qzk1Qks3NcqFLSuHR7
         WAJK/EcVIJaAN/83UId5iWgAviRq5oiciPHEqyp6zTV8Ny2DSx0YgEKBOT+8x2j1U7w8
         gUvAxxZvvT+JjITsrJA8op1Qz3CAmgiPhdM843cpSNNhynlRxY9E0+7g5eEb/Z244jpc
         LLME0xqmezJLcAZDZdLzjwro4EosEmfm11aX8jB6rzdAmUnQE2XqMZfgZ3GH/pldv3H7
         oXaw==
X-Gm-Message-State: AOAM533K5EIpPoKOU2pmVQut9fl6tt6CMVrhobAqt5wFsQFg2UjkTeMA
        /CmbbkmvV9N7a4uGUpVYGGjbB/LWrfXDv8DBow5IFw==
X-Google-Smtp-Source: ABdhPJyH3hpOdLOB8vJZhXTirmZfMEmY48i5QNhhGNGGPshsAadG6q5U+go2R4jELJt6R9/37xITXPH3Y2DKFlXTlq4=
X-Received: by 2002:a17:90a:5106:: with SMTP id t6mr2527272pjh.231.1624345935641;
 Tue, 22 Jun 2021 00:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
 <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com>
 <CAHNKnsQdWWJ1tAHt4LPS=3jWNSCDcUdQDSrkZ9aakYp-4iaKVw@mail.gmail.com>
 <CAMZdPi_e+ibRQiytAYkjo1A9GzLm6Np6Tma-6KMHuWfFcaFsCg@mail.gmail.com> <CAHNKnsS44SrnWXXkMNX=HvgeMRnZMckE-CWVTK_Z+Nyd3RRcPg@mail.gmail.com>
In-Reply-To: <CAHNKnsS44SrnWXXkMNX=HvgeMRnZMckE-CWVTK_Z+Nyd3RRcPg@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 09:21:08 +0200
Message-ID: <CAMZdPi-rE6+zaCYU8XkWPvrwjJQLx22BF=T8OT+6Ah1oja15Wg@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Jun 2021 at 19:22, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Hi Loic,
>
> On Mon, Jun 21, 2021 at 10:28 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > On Sun, 20 Jun 2021 at 16:39, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >> On Tue, Jun 15, 2021 at 10:24 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> >>> On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >>>> The WWAN core not only multiplex the netdev configuration data, but
> >>>> process it too, and needs some space to store its private data
> >>>> associated with the netdev. Add a structure to keep common WWAN core
> >>>> data. The structure will be stored inside the netdev private data before
> >>>> WWAN driver private data and have a field to make it easier to access
> >>>> the driver data. Also add a helper function that simplifies drivers
> >>>> access to their data.
> >>>
> >>> Would it be possible to store wwan_netdev_priv at the end of priv data instead?
> >>> That would allow drivers to use the standard netdev_priv without any change.
> >>> And would also simplify forwarding to rmnet (in mhi_net) since rmnet
> >>> uses netdev_priv.
> >>
> >> I do not think that mimicking something by one subsystem for another
> >> is generally a good idea. This could look good in a short term, but
> >> finally it will become a headache due to involvement of too many
> >> entities.
> >>
> >> IMHO, a suitable approach to share the rmnet library and data
> >> structures among drivers is to make the rmnet interface more generic.
> >>
> >> E.g. consider such netdev/rtnl specific function:
> >>
> >> static int rmnet_foo_action(struct net_device *dev, ...)
> >> {
> >>     struct rmnet_priv *rmdev = netdev_priv(dev);
> >>     <do a foo action here>
> >> }
> >>
> >> It could be split into a wrapper and an actual handler:
> >>
> >> int __rmnet_foo_action(struct rmnet_priv *rmdev, ...)
> >> {
> >>     <do a foo action here>
> >> }
> >> EXPORT_GPL(__rmnet_foo_action)
> >>
> >> static int rmnet_foo_action(struct net_device *dev, ...)
> >> {
> >>     struct rmnet_priv *rmdev = netdev_priv(dev);
> >>     return __rmnet_foo_action(rmdev, ...)
> >> }
> >>
> >> So a call from mhi_net to rmnet could looks like this:
> >>
> >> static int mhi_net_foo_action(struct net_device *dev, ...)
> >> {
> >>     struct rmnet_priv *rmdev = wwan_netdev_drvpriv(dev);
> >>     return __rmnet_foo_action(rmdev, ...)
> >> }
> >>
> >> In such a way, only the rmnet users know something special, while
> >> other wwan core users and the core itself behave without any
> >> surprises. E.g. any regular wwan core minidriver can access the
> >> link_id field of the wwan common data by calling netdev_priv() without
> >> further calculating the common data offset.
> >
> > Yes, that would work, but it's an important refactoring since rmnet is
> > all built around the idea that netdev_priv is rmnet_priv, including rx
> > path (netdev_priv(skb->dev)).
> > My initial tests were based on this 'simple' change:
> > https://git.linaro.org/people/loic.poulain/linux.git/commit/?h=wwan_rmnet&id=6308d49790f10615bd33a38d56bc7f101646558f
> >
> > Moreover, a driver like mhi_net also supports non WWAN local link
> > (called mhi_swip), which is a network link between the host and the
> > modem cpu (for modem hosted services...). This link is not managed by
> > the WWAN layer and is directly created by mhi_net. I could create a
> > different driver or set of handlers for this netdev, but it's
> > additional complexity.
>
> Correct me if I am wrong. I just checked the rmnet code and realized
> that rmnet should work on top of mhi_net and not vice versa. mhi_net
> should provide some kind of transportation for QMAP packets from a HW
> device to rmnet. Then rmnet will perform demultiplexing, deaggregation
> and decapsulation of QMAP packets to pure IP packets.

Exact mhi_net act as the transport layer in that case.

> rmnet itself receives these QMAP packets via a network device. So any
> driver that would like to provide the QMAP transport for rmnet should
> create a network device for this task.

Yes, this is what they call the 'real' device (or lower_dev).

> The main issue with the integration of mhi_net with the wwan is that
> the mhi_net driver should pass its traffic through the rmnet demuxer.
> While the network device that will be created by the rmnet demuxer
> will not be a child of a MHI device or a wwan device. So to properly
> integrate the mhi_net driver with the wwan core netdev capabilities,
> you should begin to use rmnet not as an independent demux created on
> top of a transport network interface, but as a library. Am I correctly
> understanding?

Once the link is created, packets received by the 'real' ndev are
automatically forwarded to the upper layer (in that case, rmnet). So
the 'transport' netdev doesn't even need to know about the upper layer
details.

> Does the same issue appear when we begin a more tight integration of
> the qmi_wwan USB driver with the wwan core?

That should be handled the same way as for mhi_net, indeed.

> I would like to say that one way or another, rmnet will be converted
> to a quite abstract library that should avoid direct access to the
> network device private data.
>
> >>>> At the moment we use the common WWAN private data to store the WWAN data
> >>>> link (channel) id at the time the link is created, and report it back to
> >>>> user using the .fill_info() RTNL callback. This should help the user to
> >>>> be aware which network interface is binded to which WWAN device data
> >>>> channel.
> >
> > I wonder if it would not be simpler to store the link ID into
> > netdev->dev_port, it's after all a kind of virtual/logical port.
> > That would only postpone the introduction of a wwan_netdev_priv struct though.
>
> I like this idea. This is likely to solve the link id storage problem.
> But only if we plan to never extend the wwan core private data.
> Otherwise, as you mention, this only postpones the wwan data structure
> introduction to a moment when we will need to rework a lot of drivers.
>
> Looks like we have no absolutely good solution. Only a set of
> proposals, each which has its own shortcomings :(
>
> --

Regards,
Loic
