Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CB0322BB8
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhBWNvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhBWNu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:50:59 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F68C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:50:19 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so34713713ejc.1
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 05:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yJUBfLn/TUTX8OgjEPkwRcOeZgkLWm0elheJGriMu2U=;
        b=dLVtQHokpEWDU3bl7PLAtbwXjPPMoY+gXzuwNgl3vDmm/+AE/Xl0zitKKbDsWmUVGn
         YFVYbnYfLYy8HC1AtyyfktgBMJPp6TdAZkAdvq0te3rdv9lKSeSOpHXxynQZJ8kzzxay
         nZ/dMdNR/rQe6SAOhbskFIFgfUBwtV0A225Qo94hqXH7KRHfzACt8NfG7arNUCt2L1dQ
         ihXhjqhWJ41VdG4IGt0HA6mbDbQVLvD5jcmEQrJ0UZUFRF1Fwm9sWFR5Tgrd/7IZqsJE
         jhBOTZlNBETX9I6fnLrXov+syJwIB3XqLlBN/VWbRI5N6BpeCOWxacd+w0wySBr0VNFL
         m+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yJUBfLn/TUTX8OgjEPkwRcOeZgkLWm0elheJGriMu2U=;
        b=ZGXr4HZLUa8Tq0bSLPUFvCqRBHzLJ26i8ZXeh0c7r1JUe1KXSSdCLoJ6yj4cDpXhCm
         W8ChNx/Oeiwiergsjcsr0KEkE5uXrFNGFM1nesko/lwEK4BwI/btQ1529LK33foNvdy7
         j3gflpYxPXnQP3KHYmFYhcQhmtsBafcSz1p/pCfVMk3icMAYKs7nukeUsd5sqCr5aVeD
         NHZDWxwfvSDbJl3Iv/zdTfe9SV4c3e1Xay0dX9jXEkQp7NQWgjQQvq+HrTEWMQH7i7ON
         7rtxKnrcjDhWXgk8xl5kWfnG0QAmVuij0WnMoC6nSLD6kaD3dmrBH1eEFEW7wKlqFo7z
         nSdQ==
X-Gm-Message-State: AOAM532Sh7KtQW5WR279hEQ7sVS3+1caExoanbgNxVwVRCJ7SAgqVcxp
        1ZnR1xZtxvlNs76zi4HBkKVSO+k4yxo=
X-Google-Smtp-Source: ABdhPJw/DmoAh+1tp8VovFVmnSIQd75rslQkUdauuWjtW33ILklPcCmVN1VIlv5O8WjXHg8RNd2Sug==
X-Received: by 2002:a17:906:d10d:: with SMTP id b13mr25451804ejz.204.1614088217781;
        Tue, 23 Feb 2021 05:50:17 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id fi5sm4705481ejc.43.2021.02.23.05.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 05:50:17 -0800 (PST)
Date:   Tue, 23 Feb 2021 15:50:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <20210223135015.ssqm3t7fajplceyx@skbuf>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
 <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
 <20210222202506.27qp2ltdkgmqgmec@skbuf>
 <20210223133028.sem3hykvm5ld2unq@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223133028.sem3hykvm5ld2unq@soft-dev3-1.localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 02:30:28PM +0100, Horatiu Vultur wrote:
> The 02/22/2021 22:25, Vladimir Oltean wrote:
> > 
> Hi Vladimir,
> > Hi Horatiu,
> > 
> > On Mon, Feb 22, 2021 at 08:46:26PM +0100, Horatiu Vultur wrote:
> > > > - Why does ocelot support a single MRP ring if all it does is trap the
> > > >   MRP PDUs to the CPU? What is stopping it from supporting more than
> > > >   one ring?
> > >
> > > So the HW can support to run multiple rings. But to have an initial
> > > basic implementation I have decided to support only one ring. So
> > > basically is just a limitation in the driver.
> > 
> > What should change in the current sw_backup implementation such that
> > multiple rings are supported?
> 
> Instead of single mrp_ring_id, mrp_p_port and mrp_s_port is to have a
> list of these. And then when a new MRP instance is added/removed this
> list should be updated. When the role is changed then find the MRP ports
> from this list and put the rules to these ports.

A physical port can't offload more than one ring id under any
circumstance, no? So why keep a list and not just keep the MRP ring id
in the ocelot_port structure, then when the ring role changes, just
iterate through all ports and update the trapping rule on those having
the same ring id?

Also, why is it important to know which port is primary and which is
secondary?

> > > > - Why does ocelot not look at the MRM/MRC ring role at all, and it traps
> > > >   all MRP PDUs to the CPU, even those which it could forward as an MRC?
> > > >   I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
> > > >   support for MRP") description that the hardware should be able of
> > > >   forwarding the Test PDUs as a client, however it is obviously not
> > > >   doing that.
> > >
> > > It doesn't look at the role because it doesn't care. Because in both
> > > cases is looking at the sw_backup because it doesn't support any role
> > > completely. Maybe comment was misleading but I have put it under
> > > 'current limitations' meaning that the HW can do that but the driver
> > > doesn't take advantage of that yet. The same applies to multiple rings
> > > support.
> > >
> > > The idea is to remove these limitations in the next patches and
> > > to be able to remove these limitations then the driver will look also
> > > at the role.
> > >
> > > [1] https://github.com/microchip-ung/mrp
> > 
> > By the way, how can Ocelot trap some PDUs to the CPU but forward others?
> > Doesn't it need to parse the MRP TLVs in order to determine whether they
> > are Test packets or something else?
> 
> No it doesn't need to do that. Because Test packets are send to dmac
> 01:15:4e:00:00:01 while the other ring MRP frames are send to
> 01:15:4e:00:00:02. And Ocelot can trap frames based on the dmac.

Interesting, so I think with a little bit more forethought, the
intentions with this MRP hardware assist would have been much clearer.
From what you explained, the better implementation wouldn't have been
more complicated than the current one is, just cleaner.
