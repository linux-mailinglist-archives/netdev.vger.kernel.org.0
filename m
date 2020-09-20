Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39731271755
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgITTGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgITTGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:06:07 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA4C061755;
        Sun, 20 Sep 2020 12:06:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e23so10408171otk.7;
        Sun, 20 Sep 2020 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7f8Gud4dSwSaPwYsqNYPuO45xcYRjuIs8C3v7DQ6Iw=;
        b=O+yRxV4C2fwkHF6CnNUxJG5FlSY1ZvuoJkmFbtc25Yb6aWNiJxOVChOuOuehF1kQ0Z
         jmWvolkadOk9OLk0JnphLmc7qxZ02ZFW03+J3c4uTyFBDdyckYab1triCV7/8Pk4M2g5
         EhSCKazsbvdbXCkbjVL+AS0+qYa0jwzgwz6YzvYwpApbc11Rah9m6kXuURzJBl5n/PDS
         oHm5FGGvgTGKa+Q5WhMaZpiOOkxXK9qlD+pTTXo8/1EjB2KMO2Y8YVF6QP7SaJrWlEiV
         3DEVpfYv4huLyjGnFpf8EnGT37jTXF1NIogYlmITpDZVPjRW2xn7gw27udtGmW250man
         I24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7f8Gud4dSwSaPwYsqNYPuO45xcYRjuIs8C3v7DQ6Iw=;
        b=JZms1fF77s67oUJleElyrGLr0Dmr08mWPiBtgCBuwY1q4RSpXceVGl8Rhna+EuZnR7
         g4RstAvQsx8XGMy59ozt1o20UPLA6otTpDakGutqjmRm89CMeS7IN0i0XDUHpiFl0qZ1
         bfthftymE+JByOU3ElAS24EOxBDU3hOBgXyoPriabAq9K7zzNTc9tsgkH5bYZXthuH3S
         jXq0HFZyhxYnejOqzYsii/cTvQqwENWeyntIsSGUIeZYVIlpYhfQ2SonXIfiFBA2+NAu
         YbCUoFhM8gX0EbOvignqsBtvy+A/xX19RrTb70idBWjtFkl3oFuLNvA9TzTbfMIvBi0f
         R+Pg==
X-Gm-Message-State: AOAM5335h0JceBzD1duBX1SH1HAMivo+fop4xl7x5eZaz6/T2YXjCFHF
        9Wdb7G68o+FuOjm6IQ0zT5iycoNcLlPrADvHnGw=
X-Google-Smtp-Source: ABdhPJwumGQlO53fOjRhy1cq+KnFrTXhc0XXIgp+AiEAQGeU3Tcf3Z2chjKbLspZNKbLpXX3Ej93DkEFp87If4Y8Fr4=
X-Received: by 2002:a9d:6d95:: with SMTP id x21mr30555700otp.339.1600628766909;
 Sun, 20 Sep 2020 12:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal> <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal> <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal> <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com> <20200919192235.GB8409@ziepe.ca> <20200920084702.GA533114@kroah.com>
In-Reply-To: <20200920084702.GA533114@kroah.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sun, 20 Sep 2020 22:05:39 +0300
Message-ID: <CAFCwf112t7es1FFsEW1oRtc-H7qZEjZxEGd7p7VFP9Y5BAeDmA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, izur@habana.ai
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 11:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Sep 19, 2020 at 04:22:35PM -0300, Jason Gunthorpe wrote:
> > On Sat, Sep 19, 2020 at 07:27:30PM +0200, Greg Kroah-Hartman wrote:
> > > > It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
> > > > I understand your reasoning about networking (Ethernet) as the driver
> > > > connects to the kernel networking stack (netdev), but with RDMA the
> > > > driver doesn't use or connect to anything in that stack. If I were to
> > > > support IBverbs and declare that I support it, then of course I would
> > > > need to integrate to the RDMA subsystem and add my backend to
> > > > rdma-core.
> > >
> > > IBverbs are horrid and I would not wish them on anyone.  Seriously.
> >
> > I'm curious what drives this opinion? Did you have it since you
> > reviewed the initial submission all those years ago?
>
> As I learned more about that interface, yes, I like it less and less :)
>
> But that's the userspace api you all are stuck with, for various
> reasons, my opinion doesn't matter here.
>
> > > I think the general rdma apis are the key here, not the userspace api.
> >
> > Are you proposing that habana should have uAPI in drivers/misc and
> > present a standard rdma-core userspace for it? This is the only
> > userspace programming interface for RoCE HW. I think that would be
> > much more work.
> >
> > If not, what open source userspace are you going to ask them to
> > present to merge the kernel side into misc?
>
> I don't think that they have a userspace api to their rdma feature from
> what I understand, but I could be totally wrong as I do not know their
> hardware at all, so I'll let them answer this question.

Hi Greg,
We do expose a new IOCTL to enable the user to configure connections
between multiple GAUDI devices.

Having said that, we restrict this IOCTL to be used only by the same
user who is doing the compute on our device, as opposed to a real RDMA
device where any number of applications can send and receive.
In addition, this IOCTL limits the user to connect ONLY to another
GAUDI device and not to a 3rd party RDMA device.

It is true that GAUDI supports RDMA data movement but the data
movement is NOT done by the user. It is done by our compute engines.
i.e. the compute engines performs "send" and "receive" without going
to the host (aka no support for ibv_postsend, ibv_postreceive). The
only thing that is controlled by the user is to say which GAUDI is
connected to which. After that, the command submission the user
performs to operate our compute engines will cause them to send and
receive RDMA packets.

Moreover, as opposed to smart NICs where the Networking is the main
focus and the compute is only secondary, in our device the compute is
our major focus and the networking is a slave for it.

The hl-thunk userspace library will have wrappers around this single
IOCTL (like all our driver's IOCTLs) and also contain demos to show
how to use it.


>
> > > Note, I do not know exactly what they are, but no, IBverbs are not ok.
> >
> > Should we stop merging new drivers and abandon the RDMA subsystem? Is
> > there something you'd like to see fixed?
> >
> > Don't really understand your position, sorry.
>
> For anything that _has_ to have a userspace RMDA interface, sure ibverbs
> are the one we are stuck with, but I didn't think that was the issue
> here at all, which is why I wrote the above comments.
To emphasize again, we don't want to expose a userspace RDMA interface.
We just want to allow our single compute user to configure a
connection to another GAUDI.

Thanks,
Oded

>
> thanks,
>
> greg k-h
