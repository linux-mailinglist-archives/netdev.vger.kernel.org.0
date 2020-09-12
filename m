Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC692676B9
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgILAPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:15:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE99C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:15:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so15872353ejb.10
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iarsOdSp31n6hgu8ZeU+i7GRzwyd0rhAl7TRqvBlRi4=;
        b=hWADilVigOzV+ZhG2S3Wz7iJo6UBXX5cWVlRHWYcUdMI++M1lBxYdM6RnNeD+A6qgW
         2qjJbJ4uY01uAyzHRZIIncaUsEC4aUHwJYAXGlrXPl6bopDUB1w24GJtRZ/CdD05mZmG
         q/T3gnvzQfXH3okc05S/5pkyQ5UdOEctS5bFWUUpP5xw6oCjn9fW/BRDvoND4wDMgKP0
         zv/No3lyf/zBecsO3OL8d19J4mIXAq9JVBZs5oBR6lsFU5EH8aB2OLRxsYh7xMtCKTkX
         1qoW64hxCnnPVmqgdR3tw88vxji1xl7yEE8uga1MPR2lWdew6onT4EcqfEqH2fZlYpQE
         t4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iarsOdSp31n6hgu8ZeU+i7GRzwyd0rhAl7TRqvBlRi4=;
        b=qW4Zv4ofDT/7WJX4y4MjKQgAEcddAv7YrP0DkBBUn8mjL4HCiuXfwSe5v6rzAaL4UM
         YES0rVcW9QTgehhLe6HGWg7L2XkpXUFN2zsfES/iH9Fje6dFMNG7CFG7mHiPn4dbNZf2
         YPbyLTrGS86cWxEvLRM3HGUAhV2QUuZBEG0i403tOb4XQwOyACtKzsy/uYPvS669FVDb
         kU+vTbwZpM11P5+Ec2beM3LEvWLOA33efbqrPazYSY+E6bjbQNJuQSU7Kazfjy0ofqkT
         mVyKp3lI6wv3GedhF0z88z7EXNtkpLYZKiOLC1MuQQs1A9oJ9PjRURJoJ9dQQfTMIIiY
         AP9w==
X-Gm-Message-State: AOAM5338yZHJvpwOPZwEF0UOJzaeqHIkBrNqLs50XvDgpfWzU8pipqMi
        fos/tlcb42vRuFv988hlgAQ=
X-Google-Smtp-Source: ABdhPJwM+85A6YHS0+5Y6a28r71NhMrctXZ6LZZSv7I0/YDsqIgUJkxHEfaV03mNp+PjkDspdOzJXg==
X-Received: by 2002:a17:906:a4e:: with SMTP id x14mr4256464ejf.112.1599869744934;
        Fri, 11 Sep 2020 17:15:44 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id m6sm2358467ejb.85.2020.09.11.17.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:15:44 -0700 (PDT)
Date:   Sat, 12 Sep 2020 03:15:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200912001542.fqn2hcp35xkwqoun@skbuf>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 05:07:24PM -0700, Jakub Kicinski wrote:
> On Sat, 12 Sep 2020 02:49:32 +0300 Vladimir Oltean wrote:
> > On Fri, Sep 11, 2020 at 04:28:45PM -0700, Jakub Kicinski wrote:
> > > Hi!
> > >
> > > This is the first (small) series which exposes some stats via
> > > the corresponding ethtool interface. Here (thanks to the
> > > excitability of netlink) we expose pause frame stats via
> > > the same interfaces as ethtool -a / -A.
> > >
> > > In particular the following stats from the standard:
> > >  - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
> > >  - 30.3.4.3 aPAUSEMACCtrlFramesReceived
> > >
> > > 4 real drivers are converted, hopefully the semantics match
> > > the standard.
> > >
> > > v2:
> > >  - netdevsim: add missing static
> > >  - bnxt: fix sparse warning
> > >  - mlx5: address Saeed's comments
> >
> > DSA used to override the "ethtool -S" callback of the host port, and
> > append its own CPU port counters to that.
> >
> > So you could actually see pause frames transmitted by the host port and
> > received by the switch's CPU port:
> >
> > # ethtool -S eno2 | grep pause
> > MAC rx valid pause frames: 1339603152
> > MAC tx valid pause frames: 0
> > p04_rx_pause: 0
> > p04_tx_pause: 1339603152
> >
> > With this new command what's the plan?
>
> Sounds like something for DSA folks to decide :)
>
> What does ethtool -A $cpu_port control?
> The stats should match what the interface controls.

Error: $cpu_port: undefined variable.
With DSA switches, the CPU port is a physical Ethernet port mostly like
any other, except that its orientation is inwards towards the system
rather than outwards. So there is no network interface registered for
it, since I/O from the network stack would have to literally loop back
into the system to fulfill the request of sending a packet to that
interface.
The ethtool -S framework was nice because you could append to the
counters of the master interface while not losing them.
As for "ethtool -A", those parameters are fixed as part of the
fixed-link device tree node corresponding to the CPU port.
