Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE23F4E4E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhHWQYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 12:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhHWQYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 12:24:19 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC82BC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 09:23:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n12so27033707edx.8
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4oZp2oA2DoFMe6YUkEUj/Z9Cb0F+Usy+fOwEsJnYYYs=;
        b=Dow8kezNib4j+RHeulxeiHR8AB8/6cQaqiFjNmQ4/SegWJPigFsS9a8m5mqxakZk8/
         9FL9f5FI3dfM8Sx5pJvFpHieFV04XRtC92LCuDG+9G6ASLAUhtm1aCH2FahibTqjMi5b
         RVPWcwit3+6giuVZnoqFTe7kcmDGDznTdqel8czLpKdCTAOO2BNPX01YyoFyok/vP/Lt
         UjKpjQXfwq+Mo32b9hhE2/mxNiRvqDDkIWWM03v+Z6gnmLBLuUcrZRPrLdpcElFTypXg
         4SkP9bd3N+ouKeJ/ph0rE4gZvTuij/uWpV1Rhpgt+cbDzJmxaDIObZ9wviTgSV8Ky3ua
         ki5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4oZp2oA2DoFMe6YUkEUj/Z9Cb0F+Usy+fOwEsJnYYYs=;
        b=Z55n/MZFny7AO1/I+MsNWmyUQWYxBUiVYMoYvQLaKQgNbTj4Qq8YYogNPnLkiyR/lp
         zeSd9pnphh2wrJWj2nGLug9mnBhBdZKZtXCgXTB5xWWi3iPk2HP5vz0L99Hh7DeecEsj
         fQsYagaGoqdYPKmsNPGqjQFklzCTOTvgqXG/ZvbpKXAdA60qvRj9lJkCOPbfzMmCW4HP
         5+7oW+PVudaRwpomTRAcMKEBNJ4IZscNKWPiI99w62k/t+qnmlWamm5gUIJoQXV6bkwd
         uHGzRtC4EETjCe9deGv7ZQyBo/beV90OyE13q81Ivh+G7uZ0hFwiqVJLiCF5qIgRr+iM
         xfzQ==
X-Gm-Message-State: AOAM53113CVZg6sWNANnDLSaa3p5O14SRyro4qALwRdQZRu+Zbe7NF1m
        86Aqp7Ahn6lERzDp83g8GpA=
X-Google-Smtp-Source: ABdhPJz3yWkAA7ZvGhlbe6uNWEU+sDiji4NYwhHQwHj31nIaJ52tiBOHt55jkAdfQVOeflfAGBVQHA==
X-Received: by 2002:a05:6402:1215:: with SMTP id c21mr38355779edw.137.1629735815213;
        Mon, 23 Aug 2021 09:23:35 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id l16sm7702024eje.67.2021.08.23.09.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 09:23:34 -0700 (PDT)
Date:   Mon, 23 Aug 2021 19:23:32 +0300
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
Message-ID: <20210823162332.mj5gmjb4to3uacnq@skbuf>
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

I tried to do something similar in DSA. There we have .ndo_fdb_dump
because we don't sync the hardware FDB. We also have some drivers where
the FDB flush on a port is a very slow procedure, because the FDB needs
to be walked element by element to see what needs to be deleted.
So I wanted to defer the FDB flush to a background work queue, and let
the port leave the bridge quickly and not block the rtnl_mutex.
But it gets really nasty really quick. The FDB flush workqueue cannot
run concurrently with the ndo_fdb_dump, for reasons that have to do with
hardware access. Also, any fdb_add or fdb_del would need to flush the
FDB flush workqueue, for the same reasons. All these are currently
implicitly serialized by the rtnl_mutex now. Your hardware/firmware might
be smarter, but I think that if you drop the rtnl_mutex requirement, you
will be seriously surprised by the amount of extra concurrency you need
to handle.
In the end I scrapped everything and I'm happy with a synchronous FDB
flush even if it's slow. YMMV of course.
