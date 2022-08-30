Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11F5A600A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiH3KA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiH3KAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:00:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C96DD744;
        Tue, 30 Aug 2022 02:58:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id cu2so21101551ejb.0;
        Tue, 30 Aug 2022 02:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=9msk6WBLnWZjrxTGjiVKdyyxz1wY94MoE845lRUJ4ak=;
        b=LlsjjSBjlKMMokfYeb/CZVf5/9sNePtacq7KeVAsKrcOPcbUZf2e3zROiTQfZJKbI3
         NWVVnqBK8TEblYrdnXL5aEUwHhcWZ/2yEjhs4iScCxcsU/sO2XBP2ffqCsB7KEjP4dys
         Gmjdo9KZLQAk7t1EkSY6mKnLHcBjQ8Olu9A8LpNqEJ/x3XttXDX3m1UNI70AUp1kwXce
         Wp/st1Mw3Ml8NEVlQGbBTpdXlnXvAP7o4FlzJxw3CaKD9/CoijquWpv9z4GPP2KHJ2pC
         6z4zpSIZUjY9CTrDWV1EyrZzpQ8yjJnSOqhYACuRliokgtvf6n8FpWNV/yoiJcRxgAoK
         1FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=9msk6WBLnWZjrxTGjiVKdyyxz1wY94MoE845lRUJ4ak=;
        b=AaY9NF68W75N4DVWY0jfLmPaPwHknwxs5eBqjmLnP478KmXo6rkm3mz0IEGwB3h7O0
         M/CY4RN/j6/VGSMm93HHQLHipRlgva4fDnHK5+M/0YqPDE4wRnXJK/2WCprOokb4bAPK
         kEZbfhq4PZCLrglzM9CUX0htc0XzWvN8U5i07wHjOQ591HPciRDF9ffjqEE90cXjLQmG
         evm4TLif/ozNox+YBO4HWZ1KR9gkJY3UGbxzj2LBE056dUZIPPr3n6ca9qHDl/76PwzJ
         HVh48YFH2KnE+r6taMtmv+JxvPqWthLyNof5H0viORII1vRsnEOmQFdkUwcugvdW8GQG
         cFBg==
X-Gm-Message-State: ACgBeo1CptM5NbkszWhzjs7ccOUa3gKXEfMU6lZ3oJbiDuqByxyidFRd
        /BD5yR0z/HE2oViHzUi3qbc=
X-Google-Smtp-Source: AA6agR70oAYSH62S2MUtGVl6SB3MzJgM3MJWjMznbwFbBgMiuIPULHepkkAIHEOVrBTenMsKbfaLHQ==
X-Received: by 2002:a17:907:7242:b0:741:7cd6:57d5 with SMTP id ds2-20020a170907724200b007417cd657d5mr6833124ejc.419.1661853514160;
        Tue, 30 Aug 2022 02:58:34 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm5528568ejf.187.2022.08.30.02.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:58:33 -0700 (PDT)
Date:   Tue, 30 Aug 2022 12:58:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     o.rempel@pengutronix.de, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, san@skov.dk, linux@armlinux.org.uk,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220830095830.flxd3fw4sqyn425m@skbuf>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
 <20220830065533.GA18106@pengutronix.de>
 <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67690ec6367c9dc6d2df720dcf98e6e332d2105b.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Aug 30, 2022 at 08:15:59AM +0000, Arun.Ramadoss@microchip.com wrote:
> On Tue, 2022-08-30 at 08:55 +0200, Oleksij Rempel wrote:
> > Hi Arun,
> > 
> > starting with this patch set I have following regression on ksz8873
> > switch. Can you please take a look at it:
> >  8<--- cut here ---
> >  Unable to handle kernel NULL pointer dereference at virtual address 00000005
> >  ksz8863-switch gpio-0:00: nonfatal error -34 setting MTU to 1500 on port 0
> > ...
> >  Modules linked in:
> >  CPU: 0 PID: 16 Comm: kworker/0:1 Not tainted 6.0.0-rc2-00436-
> > g3da285df1324 #74
> >  Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> >  Workqueue: events_power_efficient phylink_resolve
> >  PC is at ksz_set_gbit+0x5c/0xa4
> >  LR is at arch_atomic_cmpxchg_relaxed+0x1c/0x38
> > ....
> >  Backtrace:
> >   ksz_set_gbit from ksz_phylink_mac_link_up+0x15c/0x1c8
> >   ksz_phylink_mac_link_up from dsa_port_phylink_mac_link_up+0x7c/0x80
> >   dsa_port_phylink_mac_link_up from phylink_resolve+0x304/0x3d0
> >   phylink_resolve from process_one_work+0x214/0x31c
> >   process_one_work from worker_thread+0x254/0x2d4
> >   worker_thread from kthread+0xfc/0x108
> >   kthread from ret_from_fork+0x14/0x2c
> > ...
> >  ksz8863-switch gpio-0:00 lan2 (uninitialized): PHY [dsa-0.0:01] driver [Micrel KSZ8851 Ethernet MAC or KSZ886X Switch] (irq=POLL)
> >  ksz8863-switch gpio-0:00: nonfatal error -34 setting MTU to 1500 on port 1
> >  device eth0 entered promiscuous mode
> >  DSA: tree 0 setup
> >  ---[ end trace 0000000000000000 ]---
> 
> Hi Oleksij,
> Is this Bug related to fix in 
> https://lore.kernel.org/lkml/20220829105810.577903823@linuxfoundation.org/
> . 
> It is observed in ksz8794 switch. I think after applying this bug fix
> patch it should work. I don't have ksz8 series to test. I ran the
> regression only for ksz9 series switches. 

I find it unlikely that the cited patch will fix a NULL pointer
dereference in ksz_get_gbit(). But rather, some pointer to a structure
is NULL, and we then dereference a member located at its offset 0x5, no?

My eyes are on this:

	const u8 *bitval = dev->info->xmii_ctrl1;

		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_NOT_1GBIT]);
							   ~~~~~~~~~~~~~~~~
							   this is coincidentally
							   also 5

See, looking at the struct ksz_chip_data[] array element for KSZ8873
that Oleksij mentions as broken, I do not see xmii_ctrl1 and xmii_ctrl2
as being pointers to anything.

	[KSZ8830] = {
		.chip_id = KSZ8830_CHIP_ID,
		.dev_name = "KSZ8863/KSZ8873",
		.num_vlans = 16,
		.num_alus = 0,
		.num_statics = 8,
		.cpu_ports = 0x4,	/* can be configured as cpu port */
		.port_cnt = 3,
		.ops = &ksz8_dev_ops,
		.mib_names = ksz88xx_mib_names,
		.mib_cnt = ARRAY_SIZE(ksz88xx_mib_names),
		.reg_mib_cnt = MIB_COUNTER_NUM,
		.regs = ksz8863_regs,
		.masks = ksz8863_masks,
		.shifts = ksz8863_shifts,
		.supports_mii = {false, false, true},
		.supports_rmii = {false, false, true},
		.internal_phy = {true, true, false},
	},

Should we point them to ksz8795_xmii_ctrl0 and ksz8795_xmii_ctrl1? I don't know.
Could you find out what these should be set to?
