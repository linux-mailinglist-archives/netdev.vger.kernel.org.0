Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED802473481
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbhLMS6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbhLMS6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:58:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30081C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:58:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so54510098edb.8
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R9tRYPb6/n97ciTmk66fxIkPaVa9JqzoSDalx6w2kUk=;
        b=WMvbjrvBtO7qJ3jzUpz6NQASFpXckt4eyL706l53Sc2OvM3/fkh4uttWtWK+IuLx+h
         Zs5v9bNE1OxDEcEuSmHY1T/U2TZknQZpQ0HbT2eTINZFBgLS2hBbYywxS4q+bAU7wbRp
         FhgLTIjNkTwmdhDqf+G/MkdrFcu2drMSwg92bo/oxkJMBgzIH6LvpI675XgkINkQR+XS
         4Ffpk0rBK2S5J5HpQeRnx+4z0+bJmKu4yu18gKYbptv3BNyVFMqHWzZKJTL96SUmGjis
         /fFW+4pPVKyf8/cIbIOevwcMqdFEbJfxIMR5oYY0uCUNDhtMO1EH5E/YDU96nsUSYCOr
         YEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R9tRYPb6/n97ciTmk66fxIkPaVa9JqzoSDalx6w2kUk=;
        b=cPQk+754kxk9KOTs2KSP2ug+y/WCfDmBNqYCY3W1LFhjmHop0CQCgrpgnOAFUReiss
         rJoxzt504r4ETN1PTzpSwUjFiIqxmj+smRtgUed+d5ZdLAcSHjZ5pZ8AxBaW0loI+MmG
         zBMdRTolo3LmLCxBMWXu5oTgDlTz/VK7UaVtPUcru5fV5YpW+CsS1KfNdWTK8nZdQZUE
         e3sNbldipbXhUuD/5upkGyNnYhzi+sLKKdXw7LBZx427Ui7TuEghbqEsaaF1nbzka0BH
         umY23VcdD3/3z06r6IEbwaljw1UwP637uWG8BcDxz1Jn9RRCBq5TBK6fJ/yGthOVbBsm
         nagQ==
X-Gm-Message-State: AOAM5336h80mRXY/7QH4WXoC7zU/rh3bPtSrjOvEO0RXpqGckxKSlZy5
        eoNkhxRqXsnEz9BY8IIq5dXvwWQJ1cQ=
X-Google-Smtp-Source: ABdhPJzO9vxXCpAnizNXi6r2UR3g5G3+v682aE2xrIO39MAaz8/Z5vVbpcE+1Ni/C9rB3XmhTFMv+Q==
X-Received: by 2002:a17:906:a215:: with SMTP id r21mr191545ejy.21.1639421917639;
        Mon, 13 Dec 2021 10:58:37 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id p26sm6621445edt.94.2021.12.13.10.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:58:37 -0800 (PST)
Date:   Mon, 13 Dec 2021 20:58:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211213185835.ltvv5qz7pincloyj@skbuf>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
 <20211213123147.2lc63aok6l5kg643@skbuf>
 <20211213171140.GB14706@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213171140.GB14706@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 09:11:40AM -0800, Richard Cochran wrote:
> On Mon, Dec 13, 2021 at 02:31:47PM +0200, Vladimir Oltean wrote:
> 
> > With other drivers, all packets injected from the CPU port act as if in
> > "god mode", bypassing any STP state. It then becomes the responsibility
> > of the software to not send packets on a port that is blocking,
> > except for packets for control protocols. Would you agree that ptp4l
> > should consider monitoring whether its ports are under a bridge, and
> > what STP state that bridge port is in?
> 
> Perhaps.  linuxptp TC mode will forward frames out all configured
> interfaces.  If the bridge can't drop the PTP frames automatically,
> then this could cause loops.

Considering that in this configuration:

ip link add br0 type bridge
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br0
ip link set swp3 master br0
ptp4l -i swp0 -i swp1 -i swp2 -i swp3 -f configs/P2P-TC.cfg -m

the kernel code path for PTP packets has nothing to do with the bridge
driver (unless maybe an explicit netfilter rule to tell the bridge RX
handler to not steal those packets from the physical port), I think it's
safe to say that yes, the bridge can't drop the PTP frames automatically.

> So if switch HW in general won't drop them, then, yes, the TC user
> space stack will need to follow the STP state.

The hardware offloads tend to follow the software model as closely as
possible, and as mentioned, I think this has to do with the software
model in this case, rather than a hardware quirk. I would consider the
hardware to be quirky quite in the opposite case: you send a packet
through a physical port rather than the bridge, and that one is affected
by the STP state. We have switch drivers like that too, but let's not go
there, they're rather the exception.

> > I think this isn't even specific
> > to DSA, the same thing would happen with software bridging:
> 
> (Linux doesn't support even SW time stamping on SW bridges, so you
> can't have a TC running in this case.)

As also rephrased in the replies above, the point was that STP state has
nothing to do, in general, with whether this is a DSA switch or not.
It is a bridging service concept, and applies to data plane packets,
which ptp4l isn't sending/receiving, since as you very well point out,
your socket is opened on the physical port and not on the bridge device.
So don't expect the STP state of the port to do something here. If you
send a packet on a socket opened on an interface that is backed by a
physical port, expect that packet to be sent - is the main point.
The fact that I used the "software bridging" term was just to clarify
that it hasn't got anything to do with whether the bridging is offloaded
or not.
