Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80D62216BB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOVCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOVCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:02:38 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F812C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:02:38 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id e13so3299319qkg.5
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HcfXxbBjcw3eikcKaHhGf3FP9CedzkXPE03UeYpW8LE=;
        b=Wj6l20fjxQ8R+Vhf46pRwzbxVVX119XU+nBT6IRaazceCrTvuJpV2vJ0NCXg0fotL7
         KEWSqi8NKfGw6BO1k1CVvGt6Jfm/wd0ox4+pP1ZLgxf6lH8N5dDB9A5U1FqBfCtjrDXr
         dRZSW4c0T8ySzNWcQXs+Eu27/nO47dhTYmghp4Q/JYusXec2L5nSKf7/VaWyit+eoaxk
         9sc1C59U9KffNkW0cE9xniNeVnYQXpvo/R+MNpingIEv2BGgBvLqXhyIk99+yy9T6OHy
         mF+uwuHW8QHsBNqqz4BArrqbiOMOZBKadrKLs/UdePy/R3F6SVjBv92NrDF/pUKO1eoM
         jjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HcfXxbBjcw3eikcKaHhGf3FP9CedzkXPE03UeYpW8LE=;
        b=R/O5xwJeJqdWJfCzzZwcG+HpMqVur21lZed2SJVK963ecxmrKSUqscUIeaAYs6d2rN
         PuA0wqbO0i+fw4l0iizN1UnqDPQg2Ux8bLYkYaJ5beLna45HGaKottjTYJVEEU1rqjQA
         IpZL9jVTL+BuUgzl4ma0tVuOVk/1cFRTg3E//1qbjhuQPtdhxCotG2z6HgrdN5nZdbpl
         907Tl7CecoLOqJlC9tWhYm+8TXTouJPhRTRHXd9zrdcQJYg2IN/PRR2N4cFEEJF63FJr
         oABadUXftoSGK+OXnUWslhA0dBvKuXpxSKVxfH/+MuV4Zs8LgpAYVVsTN4z8JhH9Smtn
         FZhQ==
X-Gm-Message-State: AOAM532XvKy0MLbeBIARugU+gicnkxtC/HHOZRlODyxPQVTHuaL+XwU4
        zByJsN0gFIa9a/iMslOVGCIQkT1634siit4Wo1w=
X-Google-Smtp-Source: ABdhPJzJEdgRD7OM7T75wCnwDyWz3IR/qibDggVnEsd5Dnnuh8oDLjBshSOYOf9PIPRHNPLdx3A2TwDhu02UUd3XJ7M=
X-Received: by 2002:a37:6449:: with SMTP id y70mr951760qkb.435.1594846957080;
 Wed, 15 Jul 2020 14:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
 <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com> <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 15 Jul 2020 23:02:26 +0200
Message-ID: <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
Subject: Re: NAT performance issue 944mbit -> ~40mbit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:
> > After a  lot of debugging it turns out that the bug is in igb...
> >
> > driver: igb
> > version: 5.6.0-k
> > firmware-version:  0. 6-1
> >
> > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > Connection (rev 03)
>
> Unclear to me what you're actually reporting. Is this a regression
> after a kernel upgrade? Compared to no NAT?

It only happens on "internet links"

Lets say that A is client with ibg driver, B is a firewall running NAT
with ixgbe drivers, C is another local node with igb and
D is a remote node with a bridge backed by a bnx2 interface.

A -> B -> C is ok (B and C is on the same switch)

A -> B -> D -- 32-40mbit

B -> D 944 mbit
C -> D 944 mbit

A' -> D ~933 mbit (A with realtek nic -- also link is not idle atm)

Can it be a timing issue? this is on a AMD Ryzen 9 system - I have
tcpdumps but i doubt that they'll help...

> > It's interesting that it only seems to happen on longer links... Any clues?
>
> Links as in with longer cables?

Longer links, as in more hops and unknown (in this case Juniper) switches/boxes
