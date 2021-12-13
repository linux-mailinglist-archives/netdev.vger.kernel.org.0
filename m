Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36935472C00
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhLMMKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhLMMKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:10:49 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7B8C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:10:49 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k26so14739315pfp.10
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aeDoOoeMSWHks6DEzg3i5Lx0mGgPR00BvNdSpkqFsNg=;
        b=qNeaJMryifL5dHzcUD3bMecJVazg6+6HB7zgNj3Hv4NrQ6RPYbygi8IDH1PQoLSZSw
         9Fcl/gL3T88ojswJo2R1LWis8Q7BJTZAlePl2CVbC7JMp8rTZztLqHvpFr//FeReXQ9b
         Pjh2ds1aZw498sG+qPpGeNUS+ZaeteLnUlKxsbBaxjPqxDcPqjKI//DxihvbuXpJtKSI
         Q7IMxMDukcqB/Bm20urfq2uzoZxCAHvlIpzr5ziqkuUJPztPoaJPxVxmvdJLJ3Smf3D3
         AUGR5izCC/EFpeq/suqZXu3+gLDHIA8nb1ohLPFKFkA5rp/Q2bSiByQ80gP4H1j3OjOQ
         4szA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aeDoOoeMSWHks6DEzg3i5Lx0mGgPR00BvNdSpkqFsNg=;
        b=3C7dQ+xso0y1zVANRj2y3R7LzPPRofP3Ua47I3pMFFo4s9ZKeu1x5gsnplJDaegE7o
         KNvFG2lsv6eLzInqzf21x8oCJy/OaZ6zSgmVCl02gzKpNQmgR5oCcguVLbUvDKke61jN
         Af9tLtK3zlZXsBvX7O+jmfM0DHEnkUZigvzNpBGfZ57wE+As9Jxk19X25suufy8zRpRX
         MHKM+qZm+D8J3dgj4fRoGO/bdvY/Q4Xk44wiqucoB6TuasWkGYYJqur2yA0S4b2GRmvb
         G+iNPzhPqTxlQhYNWxlNE+fz08ULrjXARJhm7AqbXOBkLT4QWEdGGtWYe9ISF7PnSPwL
         RoiA==
X-Gm-Message-State: AOAM532rJ4SwGU4RhMq8HuBaBwSBfUcXGUDy5gGkFSGyODvyiv45eoSV
        hgZgZz5BcJ/dLh+lr4jYc/k=
X-Google-Smtp-Source: ABdhPJwIjRtSFc9vWt5dvt98e1WwHpJJX97ibtV2H2StrTwlMvPztvRe3ph2WinCo4fKSqqCerI7OQ==
X-Received: by 2002:a63:e657:: with SMTP id p23mr1809369pgj.337.1639397448984;
        Mon, 13 Dec 2021 04:10:48 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h8sm13542230pfh.10.2021.12.13.04.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 04:10:48 -0800 (PST)
Date:   Mon, 13 Dec 2021 04:10:45 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211213121045.GA14042@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211211153926.GA3357@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 07:39:26AM -0800, Richard Cochran wrote:
> On Fri, Dec 10, 2021 at 09:14:10PM -0800, Jakub Kicinski wrote:
> > On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
> > > Do we know how PTP is supposed to work in relation to things like STP?
> > > I.e should you be able to run PTP over a link that is currently in
> > > blocking?
> > 
> > Not sure if I'm missing the real question but IIRC the standard
> > calls out that PTP clock distribution tree can be different that
> > the STP tree, ergo PTP ignores STP forwarding state.
> 
> That is correct.  The PTP will form its own spanning tree, and that
> might be different than the STP.  In fact, the Layer2 PTP messages
> have special MAC addresses that are supposed to be sent
> unconditionally, even over blocked ports.

Let me correct that statement.

I looked at 1588 again, and for E2E TC it states, "All PTP version 2
messages shall be forwarded according to the addressing rules of the
network."  I suppose that includes the STP state.

For P2P TC, there is an exception that the peer delay messages are not
forwarded.  These are generated and consumed by the switch.

The PTP spanning tree still is formed by the Boundary Clocks (BC), and
a Transparent Clock (TC) does not participate in forming the PTP
spanning tree.

What does this mean for Linux DSA switch drivers?

1. All incoming PTP frames should be forwarded to the CPU port, so
   that the software stack may perform its BC or TC functions.

2. When used as a BC, the PTP frames sent from the CPU port should not
   be dropped.

3. When used as a TC, PTP frames sent from the CPU port can be dropped
   on blocked external ports, except for the Peer Delay messages.

Now maybe a particular switch implementation makes it hard to form
rules for #3 that still work for UDP over IPv4/6.

Thanks,
Richard
