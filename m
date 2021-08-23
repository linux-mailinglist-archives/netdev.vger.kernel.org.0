Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6A83F4E0E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhHWQMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 12:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhHWQMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 12:12:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3D0C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 09:12:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bt14so38150153ejb.3
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LOOVTjBWLXk9b77JvewF8WYFGU0rc87bf502taFTkOk=;
        b=PUYkgyyJZSvb/og6uSLYeQ77Yt+idYcAvohPWDnGl1ScZzUIKDqroLRmaXPHwvxrJk
         gWdHOkk411QjIcDOV0LMyYcYj3atY5LF2WZ4BDZUsiNdwgDuEPn9boT/jN0ITTVQr8M5
         guQbYm5EgYxFt0upCqosws6EeygNvVt+aQc/l+Ju1ruKcaFIcRGnANckWXDWmLUexRRh
         ZtgdZvX4Mzu+HFgrorM+xL/Bz6ikmj8MvvLUWHfQk74n9w9YIfjWUD3Km1UG7h8zXrlj
         4mZqGiood532tORpy3UAso57tvjn21WP1iVMm7QLrqBeAxeCc5YueiAyFjM25Dnbj5R4
         ZfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LOOVTjBWLXk9b77JvewF8WYFGU0rc87bf502taFTkOk=;
        b=YzN1Z+r5uNB8N5vUUnyIrNGy7wiv6dkLIPNGPeyXQlkkYD3vrOxpjPODCOXIzJ079a
         NaqnkTn0YQ/I6YVukdDjFjhbW9qhH6NQalDwus6yvP+W+TQ9U2OGnha/TPd6CFPQ3QF7
         zbkPpmy1U78SuDq3uKs01Azq3v5ZRuoPx5oBDYEuu7Bd/UCw1n83iDswPjOV5A/fXXEP
         1SFO09tlpWZS2Bpfw+pXAf7XVese2e6pToDJqv17TTl7/gExPBAdatheeaGMx1a7nUmt
         8NRO2DDbOV0jk/f92l82ZODdNFYQv4h7Crg56rHqIu+OJCo2NdxCLsyTmdV2f62fcX/W
         Levg==
X-Gm-Message-State: AOAM532bTrowiFjJ1XNCuHrnbkCpfSVyYbnZH74nospTb0ilzFisiyk+
        TXYc1atggtJOzDT2hj0sejc=
X-Google-Smtp-Source: ABdhPJxMmE5mHLVZSb0TmdUUg1k9OZf/eWslzmzokZyBAOAlMQx6rtK3v6SFYT8MY4Jfo+JPpnawEQ==
X-Received: by 2002:a17:906:30d0:: with SMTP id b16mr35986623ejb.495.1629735120368;
        Mon, 23 Aug 2021 09:12:00 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id k3sm528222eje.117.2021.08.23.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 09:11:59 -0700 (PDT)
Date:   Mon, 23 Aug 2021 19:11:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210823161157.mg3rtswzje3ww32k@skbuf>
References: <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
 <YSORsKDOwklF19Gm@shredder>
 <20210823142953.gwapkdvwfgdvfrys@skbuf>
 <YSO8MK5Alv0yF9pr@shredder>
 <20210823154244.4a53faquqrljov7g@skbuf>
 <YSPGh4Fj3idApeFx@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSPGh4Fj3idApeFx@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 07:02:15PM +0300, Ido Schimmel wrote:
> > > Inside the work item you would do something like:
> > >
> > > spin_lock_bh()
> > > list_splice_init()
> > > spin_unlock_bh()
> > >
> > > mutex_lock() // rtnl or preferably private lock
> > > list_for_each_entry_safe()
> > > 	// process entry
> > > 	cond_resched()
> > > mutex_unlock()
> >
> > When is the work item scheduled in your proposal?
>
> Calling queue_work() whenever you get a notification. The work item
> might already be queued, which is fine.
>
> > I assume not only when SWITCHDEV_FDB_FLUSH_TO_DEVICE is emitted. Is
> > there some sort of timer to allow for some batching to occur?
>
> You can add an hysteresis timer if you want, but I don't think it's
> necessary. Assuming user space is programming entries at a high rate,
> then by the time you finish a batch, you will have a new one enqueued.

With the current model, nobody really stops any driver from doing that
if so they wish. No switchdev or bridge changes needed. We have maximum
flexibility now, with this async model. Yet it just so happens that no
one is exploiting it, and instead the existing options are poorly
utilized by most drivers.

> > > In del_nbp(), after br_fdb_delete_by_port(), the bridge will emit some
> > > new blocking event (e.g., SWITCHDEV_FDB_FLUSH_TO_DEVICE) that will
> > > instruct the driver to flush all its pending FDB notifications. You
> > > don't strictly need this notification because of the
> > > netdev_upper_dev_unlink() that follows, but it helps in making things
> > > more structured.
> > >
> > > Pros:
> > >
> > > 1. Solves your problem?
> > > 2. Pattern is not worse than what we currently have
> > > 3. Does not force RTNL
> > > 4. Allows for batching. For example, mlxsw has the ability to program up
> > > to 64 entries in one transaction with the device. I assume other devices
> > > in the same grade have similar capabilities
> > >
> > > Cons:
> > >
> > > 1. Asynchronous
> > > 2. Pattern we will see in multiple drivers? Can consider migrating it
> > > into switchdev itself at some point
> >
> > I can already flush_workqueue(dsa_owq) in dsa_port_pre_bridge_leave()
> > and this will solve the problem in the same way, will it not?
>
> Problem is that you will deadlock if your work item tries to take RTNL.

I think we agreed that the rtnl_lock could be dropped from driver FDB work items.
I have not tried that yet though.

> > It's not that I don't have driver-level solutions and hook points.
> > My concern is that there are way too many moving parts and the entrance
> > barrier for a new switchdev driver is getting higher and higher to
> > achieve even basic stuff.
>
> I understand the frustration, but that's my best proposal at the moment.
> IMO, it doesn't make things worse and has some nice advantages.

Reconsidering my options, I don't want to reduce the available optimizations
that other switchdev drivers can make, in the name of a simpler baseline.
I am also not smart enough for reworking the bridge data path.
I will probably do something like flush_workqueue in the PRECHANGEUPPER
handler, see what other common patterns there might be, and try to synthesize
them in library code (a la switchdev_handle_*) that can be used by drivers
that wish to, and ignored by drivers that don't.
