Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946E62FAC7B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394582AbhARVUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394541AbhARVUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:20:07 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6115C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:19:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ke15so17930210ejc.12
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Ljpv2y5oqIWSyjuM/YqQpNMASHXp2u1kmnU+/8BSek=;
        b=YeWho/BEgAyaAuEMWLCv3tAK7n7YvMy7vwYmnhqMlkpZ5Psn0umKpvou4XptGIBRYX
         Ey8B6YdXENf/uR+fxrgkKtnUDPRGlKoI6wJYFb5o3BzK23A4bv97qQJJqPfxrIKZlzrQ
         JiwgsQl8Thz1cvWh85YNHtdxMkg6QY8aVwF8kJ2UTnmVWOFQ8ExFJomqyswOF36z1THj
         eVI4I2b2ZB9fNpzvjCogoFM8vQ7fo9BUJWhgQNHezFIvjiwlB1RIQh8C1JfGiNyFdp9z
         FyiZJrsjseiBDHd9aHH5PJe7L5o0hwI2A5sZzoyRCRaYnvFL0Ak0973hh5HV+joPIP6l
         7C1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Ljpv2y5oqIWSyjuM/YqQpNMASHXp2u1kmnU+/8BSek=;
        b=DW5/EXovD62cCdpubliDC+fhQ46QwED3zCO4/RXXYS5CvqPKBWJCc4SYPGu6GECd6a
         tTxba7QEyWDFl6JQwsEPRhcBbps3JtIrbzPgho6Mlg1oVDc76+glnvmdQYPFmuJDO/YM
         0DSeGHlMhGwVyneuld47WCnNVhMh4A1XC9+WQvM04B2vKwdB/lVnr+Ug7hxtHMAb4aHo
         BYsx19C/5QaM5+2/H90NV4PUD2O53ogKimd6cdzh8JSDwnUmd6lAju0HYgNQozcDzKZ6
         vbsbpQRZQWWk2HcCQaFYbMmYGJ+iAs/kZCHOxDmEt+h8m1vGCnxfpJw++Q5vJhqTYERQ
         a9uA==
X-Gm-Message-State: AOAM5300cwvgD6b+tgcyYH8x8N29P1hQFbyqhL3307aXHMHsUus872HP
        a6tJV3aAp8Rd17aSVX4BzgRbJ0L4W1c=
X-Google-Smtp-Source: ABdhPJxEzDeARRGWv5j4g0skIi4Xy5eLzPk7GKVBflFLtW0Ol3m6Fd9YQz1Bt2fnZM9lZGFBcFzBAg==
X-Received: by 2002:a17:906:9619:: with SMTP id s25mr1001468ejx.345.1611004765431;
        Mon, 18 Jan 2021 13:19:25 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y24sm11325900edt.80.2021.01.18.13.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 13:19:24 -0800 (PST)
Date:   Mon, 18 Jan 2021 23:19:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning
 for DSA and CPU ports)
Message-ID: <20210118211924.u2bl6ynmo5kdyyff@skbuf>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
 <87h7nhlksr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7nhlksr.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:42:12AM +0100, Tobias Waldekranz wrote:
> > What I'm _really_ trying to do is to get my mv88e6250 to participate in
> > an MRP ring, which AFAICT will require that the master device's MAC gets
> > added as a static entry in the ATU: Otherwise, when the ring goes from
> > open to closed, I've seen the switch wrongly learn the node's own mac
> > address as being in the direction of one of the normal ports, which
> > obviously breaks all traffic. So if the topology is
> >
> >    M
> >  /   \
> > C1 *** C2
> >
> > with the link between C1 and C2 being broken, both M-C1 and M-C2 links
> > are in forwarding (hence learning) state, so when the C1-C2 link gets
> > reestablished, it will take at least one received test packet for M to
> > decide to put one of the ports in blocking state - by which time the
> > damage is done, and the ATU now has a broken entry for M's own mac address.

What hardware offload features do you need to use for MRP on mv88e6xxx?
If none, then considering that Tobias's bridge series may stall, I think
by far the easiest approach would be for DSA to detect that it can't
offload the bridge+MRP configuration, and keep all ports as standalone.
When in standalone mode, the ports don't offload any bridge flags, i.e.
they don't do address learning, and the only forwarding destination
allowed is the CPU. The only disadvantage is that this is software-based
forwarding.
