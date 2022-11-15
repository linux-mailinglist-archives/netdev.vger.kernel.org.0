Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EED6298C1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiKOMXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKOMW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:22:59 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF852657C;
        Tue, 15 Nov 2022 04:22:41 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ft34so35510979ejc.12;
        Tue, 15 Nov 2022 04:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0vu8h9GJojpRemJ9Ahu7D+FQ7WSSdPDE9lDATfhnwTM=;
        b=pnZk+LUKtQMhv/56SkeM39Y+k3BnN/kDjqoUBZZU7RVig6oP1ts7LnXrg2aUsfqoVh
         W/6DwQUq0liMMBGo0gpNTxafybC+cHRwOHrBZb0EwpAYlf/gzNZwGPVAvR1gwinLc/th
         W50AFOs8UQd6qOC50bSIH8MtPNBSvceKrX9hXdGu0F+xhQ9sg3oxujPPiuuGuQKGYcGV
         MHN/dWUEpupIoiCqX4c4EKoS+b7Nnx3eKXziYCA/HJFLlxovx9e6WorfK5AFlh6EykSs
         8dG3r8bLFOKKbNN/SFdkrcs9eHM/nRutTElOpZRjo400O6Ov+OXHAueIpHlnIOIaYP7a
         RHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vu8h9GJojpRemJ9Ahu7D+FQ7WSSdPDE9lDATfhnwTM=;
        b=vssFWzMftoHkIyMhYPaTVALPXDYt8EZ6oJ9lmOWwj3Vv2w2YnrvRjsuYApq6GJ0Q8b
         n5dxnJQq4QxvYAkMmmVzbIYZxp6po7CWmdYlDsZXpjKT77uogJOx5ugUKW+Vv4gPzaeK
         W2ZOo8weS19+9LYlo5juoGRErQlfQpG3L86P+N/1buc3LBLwfe+mRmu7Xpxh8PnP5b9L
         j07Non0tQuu9CmAmAtZrFXOi0DGGB7tdP2c3swMRGbXkbXT5JZkDFloqyEI2+1Nn43JX
         J9UrtRW+uO5y3dw+0p26oCSgeAE21gI1wCAiPTrmaaTVM+BLYztkdVZyEh7e908RjUSh
         yfMQ==
X-Gm-Message-State: ANoB5pnRhOIPB15YRY1lyUKwT8lzZXmLH6V9KCYX7p3TwqNGV+J26A4/
        Hm43ZwJPe1CCw0+q2Th/uGc=
X-Google-Smtp-Source: AA0mqf498FmrzMwERCX83ADtD5R6BcFUk/silzBJiv7W7IydV4i9VF2F3v8KS2sAFJLtNMiwgYdC/Q==
X-Received: by 2002:a17:906:3c9:b0:7af:a2d4:e95c with SMTP id c9-20020a17090603c900b007afa2d4e95cmr2627493eja.666.1668514960350;
        Tue, 15 Nov 2022 04:22:40 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id d18-20020a056402401200b004580862ffdbsm6158427eda.59.2022.11.15.04.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 04:22:39 -0800 (PST)
Date:   Tue, 15 Nov 2022 14:22:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115122237.jfa5aqv6hauqid6l@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 12:31:59PM +0100, netdev@kapio-technology.com wrote:
> It happens on upstart, so I would then have to hack the system upstart to
> add trace.

Hack upstart or disable the service that brings the switch ports up, and
bring them up manually...

> I also have:
> mv88e6085 1002b000.ethernet-1:04: switch 0x990 detected: Marvell 88E6097/88E6097F, revision 2
> mv88e6085 1002b000.ethernet-1:04: configuring for fixed/rgmii-id link mode
> mv88e6085 1002b000.ethernet-1:04: Link is Up - 100Mbps/Full - flow control off
> mv88e6085 1002b000.ethernet-1:04 eth10 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:00] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth6 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:01] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth9 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:02] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth5 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:03] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth8 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:04] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth4 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:05] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth7 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:06] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth3 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:07] driver [Generic PHY] (irq=POLL)
> mv88e6085 1002b000.ethernet-1:04 eth2 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:08] driver [Marvell 88E1112] (irq=174)
> mv88e6085 1002b000.ethernet-1:04 eth1 (uninitialized): PHY [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:09] driver [Marvell 88E1112] (irq=175)
> 
> after this and adding the ifaces to the bridge, it continues like:
> 
> br0: port 1(eth10) entered blocking state
> br0: port 1(eth10) entered disabled state
> br0: port 2(eth6) entered blocking state
> br0: port 2(eth6) entered disabled state
> device eth6 entered promiscuous mode
> device eth10 entered promiscuous mode
> br0: port 3(eth9) entered blocking state
> br0: port 3(eth9) entered disabled state
> device eth9 entered promiscuous mode
> br0: port 4(eth5) entered blocking state
> br0: port 4(eth5) entered disabled state
> device eth5 entered promiscuous mode
> br0: port 5(eth8) entered blocking state
> br0: port 5(eth8) entered disabled state
> device eth8 entered promiscuous mode
> br0: port 6(eth4) entered blocking state
> br0: port 6(eth4) entered disabled state
> mv88e6085 1002b000.ethernet-1:04: Timeout while waiting for switch
> mv88e6085 1002b000.ethernet-1:04: port 0 failed to add 9a:af:03:f1:bd:0a vid 1 to fdb: -110

Dumb question, but if you get errors like this, how can you test anything at all
in the patches that you submit?

> device eth4 entered promiscuous mode
> br0: port 7(eth7) entered blocking state
> br0: port 7(eth7) entered disabled state
> 
> I don't know if that gives ay clues...?

Not really. That error might be related - something indicating a breakage
in the top-level (fec IIUC) MDIO controller, or not. There was "recent"
rework almost everywhere.  For example commit 35da1dfd9484 ("net: dsa:
mv88e6xxx: Improve performance of busy bit polling"). That also hooks
into the mv88e6xxx cascaded MDIO controller (mv88e6xxx_g2_smi_phy_wait),
so there might be something there.

> 
> Otherwise I have to take more time to see what I can dig out. The easiest
> for me is then to add some printk statements giving targeted information if told what and
> where...

Do you have a timeline for when the regression was introduced?
Commit 35da1dfd9484 reverts cleanly, so I suppose giving it a go with
that reverted might be worth a shot. Otherwise, a bisect from a known
working version only takes a couple of hours, and shouldn't require
other changes to the setup.
