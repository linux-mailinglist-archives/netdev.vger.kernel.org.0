Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02532FAD0
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbhCFNSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 08:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhCFNSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 08:18:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF693C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 05:18:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d13so6989333edp.4
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 05:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q38GiX2nLghiH2EuukByY59Sgt1/Sj8tYtMXdN/xisI=;
        b=SYOZbweDtXeacghF4USZ18x/cbl91UGnYchBynu36V5FkHt6ctM8XfaJwECOl0QvRY
         ffyLULc/oRqw3SGH4d8RW4FCZ5J127fdJFzkGcqlv/mc+N16r0NPc2G3hs7e2MSV8zHI
         lUWbQmDVghAX4eTlscb5AwJUDRuSVOt0iDrWowgq6yC4Lk3wuegE8IUUISdCgod78eBf
         kHfhoj8lqTtvCceNVpYWtPW6NS6d4OoeCDBYU0aPk6Uwf8jpA9spM/Tz2N+yb1dLhDLi
         zA33rxSKUqMPyhDVenWCofaCqkMZ1Cx64aEXs4lN1sXHJpgn4IJS5XCSLVA+HUv/VjRu
         AIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q38GiX2nLghiH2EuukByY59Sgt1/Sj8tYtMXdN/xisI=;
        b=KMW/ihvMjhYXL9PedoWJmTfjvRFEmXFxAAtADpr6o5tx0116BhMdW72hEuFN05IcAQ
         BSwYcKs+11/u6ajqutqUeCrYRElieP47N7Walko2tGDwqdUNfhCzrOiQjlpOhdqvC4/J
         wt2rIsPyD/ZMSIr7StKS0cgaNXg8v9EXzAd3/1GF4QbmQ1zDsxJfHYS7rF0vHED7oht1
         WvQ4JKtFru1hpfqEXxnbpAZcxQNdtNsnC+eULqkZkW1QNwVSwZYCH2pHH7uy7XfoKSyG
         xZdZ/eGPT+by86StIPdaa7ck1QOonA4G+XY2w/bKrYGCmKHwEcc88CMBEP56Vunxpc68
         OvMQ==
X-Gm-Message-State: AOAM531SX7sSVtC1x0y4r4YHasAOUACZRklRz7PhbZBtli7bRaEyXqip
        DUtafKoguUfhqRnAy/MEacE=
X-Google-Smtp-Source: ABdhPJwwmbibLF8OrdESM6utDtVQ14C5fMrNWaliUhiTuyOdFYBJuylEWIUn5t/ybHXLKY9Jvq8pxQ==
X-Received: by 2002:a05:6402:95b:: with SMTP id h27mr14091990edz.93.1615036695414;
        Sat, 06 Mar 2021 05:18:15 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id c20sm3237062eja.22.2021.03.06.05.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 05:18:15 -0800 (PST)
Date:   Sat, 6 Mar 2021 15:18:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>
Subject: Re: Query on new ethtool RSS hashing options
Message-ID: <20210306131814.h4u323smlihpf3ds@skbuf>
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YELKIZzkU9LxpEE9@lunn.ch>
 <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 06:04:14PM +0530, Sunil Kovvuri wrote:
> On Sat, Mar 6, 2021 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Mar 05, 2021 at 03:07:02PM -0800, Jakub Kicinski wrote:
> > > On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> > > > Hi,
> > > >
> > > > We have a requirement where in we want RSS hashing to be done on packet fields
> > > > which are not currently supported by the ethtool.
> > > >
> > > > Current options:
> > > > ehtool -n <dev> rx-flow-hash
> > > > tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> > > >
> > > > Specifically our requirement is to calculate hash with DSA tag (which
> > > > is inserted by switch) plus the TCP/UDP 4-tuple as input.
> > >
> > > Can you share the format of the DSA tag? Is there a driver for it
> > > upstream? Do we need to represent it in union ethtool_flow_union?
> >
> > Sorry, i missed the original question, there was no hint in the
> > subject line that DSA was involved.
> >
> > Why do you want to include DSA tag in the hash? What normally happens
> > with DSA tag drivers is we detect the frame has been received from a
> > switch, and modify where the core flow dissect code looks in the frame
> > to skip over the DSA header and parse the IP header etc as normal.
>
> I understand your point.
> The requirement to add DSA tag into RSS hashing is coming from one of
> our customer.
>
> >
> > Take a look at net/core/flow_dissect.c:__skb_flow_dissect()
> >
> > This fits with the core ideas of the network stack and offloads. Hide
> > the fact an offload is being used, it should just look like a normal
> > interface.
> >
> >         Andrew
>
> Yes, the pkt will look like a normal packet itself.
> In our case HW strips the DSA tag from the packet and forwards it to a VF.

DSA-aware SR-IOV on master, very interesting. I expect that the reverse
is true as well: on xmit, the VF will automatically insert a FWD tag
into the packet too, which encodes a 'virtual' source port and switch id.

What Marvell controller is this? How is the SR-IOV implemented in the
kernel, is it modeled as switchdev, with host representors for the VFs?
Does it support VEPA mode or VEB too? If it supports VEB, does it learn
(more like 'steal') addresses from the DSA switch's FDB? Does it also
push addresses into the DSA switch's FDB?

To your question: why stop at hashing? What about flow steering?
What does your hardware actually support? It is obvious that it has deep
parsing of Marvell DSA tags specifically, so the generic 'masked u32 key'
matching may not be the best way to model this. Can your DSA master even
perform masked matching on generic u32 keys, or are you planning to just
look for the particular pattern of a Marvell DSA tag in the ethtool
rxnfc callbacks, and reject anything that doesn't match?
