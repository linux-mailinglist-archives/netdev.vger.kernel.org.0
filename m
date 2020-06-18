Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE231FFA4D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbgFRRbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbgFRRbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:31:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7121C0613ED
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:31:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l10so6913596wrr.10
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JqaYEW9ro3Fi3jPgS562P8d03wfWAt51jfhpJgRkxcI=;
        b=c8ZEUZc4gvCUPo6stmuWdn+y297x849AgRco7d/3H78tUqCIFncgRsZD+Yp9K3Qr6e
         bHyHrtownVi/X4/H8ghoEnnsgrkfnkhjTFKr9LqC+wQf4Pm/rNANMDf2J/1WseJcVvU9
         BTT8+AqBSxXncE+oICxrJfSKAhkucri8sWvYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JqaYEW9ro3Fi3jPgS562P8d03wfWAt51jfhpJgRkxcI=;
        b=oiTK/yhlZyWMcWeFo6C2pFSOxW1N6U8lviD1vhTtizXU2bkxYSViB72blGXbQGse9F
         2LUNiWea84A7buzu++Sfv3t1rCGozk1C4lUjBRX1kjbEupG9DLkeJEtk7c+9PNZgr02b
         Bu52qZI4rjrgWWHSeDCmn4JKY+iTUdCjkxtrHaHSxnmVcubQ9+l+G9rp14P6Vc35/zcZ
         LFp8txUvQ1cEbwCbumi7uYwFyMNkINvS/cj9/Nzlo/Lpwr6hEzAXatl3i+FajMj3LBYl
         Pkkh6NUdWVJFpti74oTAFDtQ4/yqFoGGeddW+Aj/4wKlw9ems3hZGIhVozY83XFTUTff
         YN/g==
X-Gm-Message-State: AOAM533ppq9shJraz9x95XvmvQPEBSb8tLT61xRNkPHQOd9O3cElk7VO
        TgMZTNqlN5OjUuuSFdLXnHhtUb/MMi7BE7MiRvflgA==
X-Google-Smtp-Source: ABdhPJx6Vzf/2/1fm8qrYtG5MGN7RobEP/IHY8UjXGssWAMiy9DMDA68HfJcWiMv28PW7LEAtUkso5vOLNm7Axn3BY4=
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr2937387wrs.295.1592501507201;
 Thu, 18 Jun 2020 10:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon> <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
 <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com> <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Thu, 18 Jun 2020 19:31:36 +0200
Message-ID: <CAHApi-kkACFLs3YT+BR7DUrRSM-97Kh9O=9uG5uKWuVG5ytKKA@mail.gmail.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Sun, Jun 14, 2020 at 10:55:30AM +0200, Kal Cutter Conley wrote:
> > Hi Saeed,
> > Thanks for explaining the reasoning behind the special mlx5 queue
> > numbering with XDP zerocopy.
> >
> > We have a process using AF_XDP that also shares the network interface
> > with other processes on the system. ethtool rx flow classification
> > rules are used to route the traffic to the appropriate XSK queue
> > N..(2N-1). The issue is these queues are only valid as long they are
> > active (as far as I can tell). This means if my AF_XDP process dies
> > other processes no longer receive ingress traffic routed over queues
> > N..(2N-1) even though my XDP program is still loaded and would happily
> > always return XDP_PASS. Other drivers do not have this usability issue
> > because they use queues that are always valid. Is there a simple
> > workaround for this issue? It seems to me queues N..(2N-1) should
> > simply map to 0..(N-1) when they are not active?
>
> If your XDP program returns XDP_PASS, the packet should be delivered to
> the xsk socket.  If the application isn't running, where would it go?

XDP_PASS means the packet is passed to the normal network stack for
processing. XDP_REDIRECT means the packet should be delivered to the
xsk socket.

>
> I do agree that the usability of this can be improved.  What if the flow
> rules are inserted and removed along with queue creatioin/destruction?

The problem is the mlx5 driver allows flow rules to be set on
N..(2N-1) at any time; even when no XDP program is loaded. Given this
fact, it would be totally weird if they just suddenly disappeared the
first time the queues go inactive. That's why I suggested that they
just always map to queues 0..(N-1) when they are not active. This way,
at least it's less surprising. What do people think?

> Jonathan

Kal
