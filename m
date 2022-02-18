Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA04BB717
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiBRKnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:43:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiBRKnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:43:52 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF14825A97B;
        Fri, 18 Feb 2022 02:43:33 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id h18so14713037edb.7;
        Fri, 18 Feb 2022 02:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Thuz9Uo64aPeka2S6d2lt8dTabuHdIgegYkV8o7Wgo=;
        b=OSyNlSsmApXjWa65bZnCGTAvdfnPRQ8X+uhi+MDkVi/tB698GdI0HArwXDp71AshcX
         lbALjKMuD4lMiv5YPdXUNHlJw1E9hsD0q/CvwoIY7K5aVemplD2lSnNmeSOVOMpHSm33
         bVB1F5GMJmT6ShgdK1DL562ejhjhOOjyZK4dcIdQykMQvtBzX2chfMDaRXRNBj72YRXf
         p2eDOE+XAkRl/kR/AUJcOpLmav4xOFrTNiWctzZdd3W7UceRZKnk7cYV6BrjUs2CfGo/
         Y17XxbIkIkYbWS0Y+akD2T2obAXT01L5irhbAyiVn4U+nyEWuSaXUUTh1r0d+3eHyXvU
         6FXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Thuz9Uo64aPeka2S6d2lt8dTabuHdIgegYkV8o7Wgo=;
        b=eaOLwwPZ+mpbHLsuQYLe7PD2JcP9CAnQGLYmIPnL+Wb/MRuY87quJRkd4nPks6T7Qs
         QDJTgjmaOF9oYPg1SNxfekAE7eMzoSgcpVUWKkghTD9m1IHOfl8w3QfNcSw3bbjJez5R
         9hNByE3jl/OiZiEvsVxOCS73wKgf3Ezh48+H/bQ+XvhXxnMu9+uQEJf2nNlReGwWpXZn
         p2d6zxpJS+gJYadK542EXFYlGGPB8H9n3wq3VD+Y285mk+j68GurfJxuZJBMs2KnSwCI
         pSbZCxWCCo2/2GsopI0i59Dw0u54gaMMAaGp1NSoNKg4DIw0AEge6KpxTaIujMBpFdRs
         /UxQ==
X-Gm-Message-State: AOAM533DM5lLdBt+qVh2/aj9+glk1ic4DYxKfkt6TSTfcV+88PBt//7I
        6tuXEiBI71fBx2P7XyQc/z8=
X-Google-Smtp-Source: ABdhPJzfWzMPEQW7thJ+rut9P39XTZAz0s79d/BY4FLn9NMviYosi+40rIGqZJ+i5mWH9RyvUG48gw==
X-Received: by 2002:a05:6402:17c8:b0:406:80a3:5cad with SMTP id s8-20020a05640217c800b0040680a35cadmr7284471edy.388.1645181012161;
        Fri, 18 Feb 2022 02:43:32 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id f19sm4372310edu.22.2022.02.18.02.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 02:43:31 -0800 (PST)
Date:   Fri, 18 Feb 2022 12:43:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: export HW
 stats over stats64 interface
Message-ID: <20220218104330.g3vfbpdqltdkp4sr@skbuf>
References: <20220217140726.248071-1-o.rempel@pengutronix.de>
 <20220217155554.bo6gcva6h2pkryou@skbuf>
 <20220218083956.GA4681@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218083956.GA4681@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 09:39:56AM +0100, Oleksij Rempel wrote:
> On Thu, Feb 17, 2022 at 05:55:54PM +0200, Vladimir Oltean wrote:
> > On Thu, Feb 17, 2022 at 03:07:26PM +0100, Oleksij Rempel wrote:
> > > +static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
> > > +				struct rtnl_link_stats64 *stats)
> > > +{
> > > +	struct ksz_device *dev = ds->priv;
> > > +	struct ksz9477_stats_raw *raw;
> > > +	struct ksz_port_mib *mib;
> > > +	int ret;
> > > +
> > > +	mib = &dev->ports[port].mib;
> > > +	raw = (struct ksz9477_stats_raw *)mib->counters;
> > > +
> > > +	mutex_lock(&mib->cnt_mutex);
> > 
> > The eternal problem, ndo_get_stats64 runs in atomic context,
> > mutex_lock() sleeps. Please test your patches with
> > CONFIG_DEBUG_ATOMIC_SLEEP=y.
> 
> Good point, thx! I reworked the code.
> 
> Beside, I get this warning with differnt locking validators:
> [  153.140000] br0: port 1(lan2) entered blocking state
> [  153.190000] br0: port 1(lan2) entered disabled state
> [  153.320000] device lan2 entered promiscuous mode
> [  153.350000] ------------[ cut here ]------------
> [  153.350000] WARNING: CPU: 0 PID: 71 at net/core/dev.c:7913 __dev_set_promiscuity+0x10c/0x138
> [  153.360000] RTNL: assertion failed at net/core/dev.c (7913)
> [  153.370000] Modules linked in: atmel_aes atmel_tdes atmel_sha
> [  153.370000] CPU: 0 PID: 71 Comm: kworker/u2:5 Not tainted 5.17.0-rc2-00714-g845f6fa17e48-dirty #33
> [  153.370000] Hardware name: Atmel SAMA5
> [  153.370000] Workqueue: dsa_ordered dsa_slave_switchdev_event_work
> [  153.370000]  unwind_backtrace from show_stack+0x18/0x1c
> [  153.370000]  show_stack from dump_stack_lvl+0x58/0x70
> [  153.370000]  dump_stack_lvl from __warn+0xd8/0x228
> [  153.370000]  __warn from warn_slowpath_fmt+0x98/0xc8
> [  153.370000]  warn_slowpath_fmt from __dev_set_promiscuity+0x10c/0x138
> [  153.370000]  __dev_set_promiscuity from __dev_set_rx_mode+0x8c/0x98
> [  153.370000]  __dev_set_rx_mode from dev_uc_add+0x84/0x8c
> [  153.370000]  dev_uc_add from dsa_port_host_fdb_add+0x48/0x80
> [  153.370000]  dsa_port_host_fdb_add from dsa_slave_switchdev_event_work+0x1dc/0x254
> [  153.370000]  dsa_slave_switchdev_event_work from process_one_work+0x2b0/0x7d4
> [  153.370000]  process_one_work from worker_thread+0x4c/0x53c
> [  153.370000]  worker_thread from kthread+0xf8/0x12c
> [  153.370000]  kthread from ret_from_fork+0x14/0x2c
> [  153.370000] Exception stack(0xc1f13fb0 to 0xc1f13ff8)
> [  153.370000] 3fa0:                                     00000000 00000000 00000000 00000000
> [  153.370000] 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  153.370000] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  153.380000] irq event stamp: 0
> [  153.390000] hardirqs last  enabled at (0): [<00000000>] 0x0
> [  153.390000] hardirqs last disabled at (0): [<c0124b38>] copy_process+0x7d8/0x194c
> [  153.400000] softirqs last  enabled at (0): [<c0124b38>] copy_process+0x7d8/0x194c
> [  153.410000] softirqs last disabled at (0): [<00000000>] 0x0
> [  153.410000] ---[ end trace 0000000000000000 ]---
> [  153.420000] device eth0 entered promiscuous mode
> [  153.770000] ksz9477-switch spi1.0 lan2: configuring for phy/gmii link mode
> [  155.040000] ksz9477-switch spi1.0 lan4: Link is Down
> [  156.960000] ksz9477-switch spi1.0 lan2: Link is Up - 1Gbps/Full - flow control rx/tx
> 
> 
> Is it something known?

Thanks for reporting. It isn't something known (at least to me - who
knows whether somebody may have been chuckling while I was gloating that
I removed rtnl_lock() from the DSA switchdev FDB notifiers).

It turns out that dsa_port_host_fdb_add() needs rtnl_lock() around
dev_uc_add(), at least if the master doesn't support IFF_UNICAST_FLT.

It's pretty nasty. If we add an rtnl_lock() there, we'll deadlock from
the code paths that call dsa_flush_workqueue(), which have rtnl_lock()
already held.

The only way I think we can get out of this is if we call dev_uc_add()
only if the master has IFF_UNICAST_FLT. If it doesn't, we should force a
call to dsa_master_set_promiscuity() during dsa_master_setup().
Not exactly the cleanest solution, but at least it shouldn't deadlock
and it should work.

Andrew, Florian, Vivien?
