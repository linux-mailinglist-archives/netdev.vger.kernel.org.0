Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B738268902
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 12:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgINKLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 06:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgINKLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 06:11:01 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE22C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 03:11:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y1so4836638pgk.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 03:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CcIK7JhnkbSO1lEJrhfie3yPWToQk+GRSxeB40Z4jYA=;
        b=dKFwHbMoItahTu8u/+Q8vhjORQMv0KHOMW9jgTla8pIUw/YyOYArRTgnpT+dBj0Wg4
         FxCE8/cGqUdP4OgB7PQUIBiA/P/uEY/ev8mZyk6jCSDGm/yGTwClzwH6ayoXQqya0xGv
         vrb37X7CiTIb5rmdnoLObPnTllT0xbvWTsymjqS1TcnCLNrrWSnUOWSTHvAiyyoS9iXq
         eleUhW9elApmcgEi4yZiI21/oSnyBeJY/wvZy9Q5R/yq4kPDHtheJ8sUcXE4rzNBewo8
         FnzTjPq3Ey2cBfbaRkppHwL+cbYkrRZ/zS8Qm41Pm7vORc2DMICG9E178RmaF+/xxd3W
         A67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CcIK7JhnkbSO1lEJrhfie3yPWToQk+GRSxeB40Z4jYA=;
        b=IJwomvHMR9P6ZATCLxsZ1MaC7EPzwohyqI8mSDTz5ig9eYBWRt58O6JNkjPVeivlA/
         RB9nSc1KtOcQHfKtjm+QvKQrin+jX8b6m98egFXu2S/2/N1vI8f6zkIwQaRPiNSsXOnJ
         0w1uPP/1d/gxUxlITJhtp/jQnGDN60HPLIKEkg/lcuIGEtJ5/hE/ouijuqVB5Y2W0iOj
         dXR/wt+ozmxwtHxO0xSW7DQf6xr0pvI87gMLZynd85orND9uJMPeFlPZtAcnJ+uDM3Ev
         sIWBB9pyzBkkUjWY0MJkUI/ZWK5/6YqBO1QC0kAP+Jv71J89GaOAAI7O9OmqEo9bT0QQ
         cNxA==
X-Gm-Message-State: AOAM5335jKs9/qGHl9gzlJQcVJcfHBCazy+oWsdIUpTHc+QxFYv2wZdc
        aF0nPYuCpNZIzfZeE0sijiD6p2TqJUJShExItyRS+HQSAhaZKA==
X-Google-Smtp-Source: ABdhPJzsbTCmFGP4VOI24LCpiaeUiMiOVRPcHyoDA8Gu0DlEq5mk4niGE0WkVOFw9qI6NKowaT+N86Hss7yRS8l0+vk=
X-Received: by 2002:a63:29c7:: with SMTP id p190mr10389274pgp.292.1600078260569;
 Mon, 14 Sep 2020 03:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <1599826106-19020-1-git-send-email-magnus.karlsson@gmail.com>
 <20200911120519.GA9758@ranger.igk.intel.com> <CAJ8uoz3ctVoANjiO_nQ38YA-JoB0nQH1B4W01AZFw3iCyCC_+w@mail.gmail.com>
 <20200911131027.GA2052@ranger.igk.intel.com> <b28b4e93-50c2-6183-90ea-8d33902e8f21@intel.com>
 <CAKgT0UcXLi5fK3UiOpfPKu6FxJh1tH4r+_ZjCNsH=cEqHztOOg@mail.gmail.com>
In-Reply-To: <CAKgT0UcXLi5fK3UiOpfPKu6FxJh1tH4r+_ZjCNsH=cEqHztOOg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 14 Sep 2020 12:10:49 +0200
Message-ID: <CAJ8uoz2vV4b8EXwdcU7WBxsY0bnM=Lk_b789w0Ki7+8CWRk6fA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next] i40e: allow VMDQs to be used
 with AF_XDP zero-copy
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 8:42 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Sep 11, 2020 at 11:05 AM Samudrala, Sridhar
> <sridhar.samudrala@intel.com> wrote:
> >
> >
> >
> > On 9/11/2020 6:10 AM, Maciej Fijalkowski wrote:
> > > On Fri, Sep 11, 2020 at 02:29:50PM +0200, Magnus Karlsson wrote:
> > >> On Fri, Sep 11, 2020 at 2:11 PM Maciej Fijalkowski
> > >> <maciej.fijalkowski@intel.com> wrote:
> > >>>
> > >>> On Fri, Sep 11, 2020 at 02:08:26PM +0200, Magnus Karlsson wrote:
> > >>>> From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >>>>
> > >>>> Allow VMDQs to be used with AF_XDP sockets in zero-copy mode. For some
> > >>>> reason, we only allowed main VSIs to be used with zero-copy, but
> > >>>> there is now reason to not allow VMDQs also.
> > >>>
> > >>> You meant 'to allow' I suppose. And what reason? :)
> > >>
> > >> Yes, sorry. Should be "not to allow". I was too trigger happy ;-).
> > >>
> > >> I have gotten requests from users that they want to use VMDQs in
> > >> conjunction with containers. Basically small slices of the i40e
> > >> portioned out as netdevs. Do you see any problems with using a VMDQ
> > >> iwth zero-copy?
> >
> > Today VMDQ VSIs are used when a macvlan interface is created on top of a
> > i40e PF with l2-fwd-offload on. But i don't think we can create an
> > AF_XDP zerocopy socket on top of a macvlan netdev as it doesn't support
> > ndo_bpf or ndo_xdp_xxx apis or expose hw queues directly.
> >
> > We need to expose VMDQ VSI as a native netdev that can expose its own
> > queues and support ndo_ ops in order to enable AF_XDP zerocopy on a
> > VMDQ. We talked about this approach at the recent netdev conference to
> > expose VMDQ VSI as a subdevice with its own netdev.
> >
> > https://netdevconf.info/0x14/session.html?talk-hardware-acceleration-of-container-networking-interfaces
>
> I still hold the opinion that macvlan is still the best way to go
> about addressing most of these needs. The problem with doing isolation
> as separate netdevs is the fact that east/west traffic starts to
> essentially swamp the PCIe bus on the device as you have to deal with
> broadcast/multicast replication and east/west traffic. Leaving that
> replication and east/west traffic up to software to handle while
> allowing the unicast traffic to be directed is the best way to go in
> my opinion.
>
> The problem with just spawning netdevs is that each vendor can do it
> differently and what you get varies in functionality. If anything we
> would need to come up with a standardized interface to define what
> features can be used and exposed. That was one of the motivations
> behind using macvlan. So if anything it seems like it might make more
> sense to look at extending the macvlan interface to enable offloading
> additional features to the lower level device.

Agree with this completely. This patch was not intended to "solve" the
container interface problem. This solution does not scale, is
proprietary, etc, etc. It just uses something, VMDQs,  that was put in
the i40e driver a long time ago. Do not know the history behind it,
but I am sure that Alex and Sridhar do. Anyway, what I believe you and
Jakub are saying is that this is just extending something that we all
know is a dead end, or in other words, putting lipstick on a pig ;-).

Please drop the patch.

> With that said I am not certain VMDq is even the right kind of
> interface to use for containers. I would be more interested in
> something like what we did in fm10k for macvlan offload where we used
> resource tags to identify traffic that belonged to a given interface
> and just dedicated that to it rather than queues and interrupts. The
> problem with dedicating queues and interrupts is that those are a
> limited resource so scaling will become an issue when you get to any
> decent count of containers.
>
> - Alex
