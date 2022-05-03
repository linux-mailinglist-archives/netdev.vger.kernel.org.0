Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BDE517FB4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 10:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiECI3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 04:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiECI3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 04:29:47 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582DC27B04
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 01:26:14 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id CC76430000647;
        Tue,  3 May 2022 10:26:12 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B9E1F597D8; Tue,  3 May 2022 10:26:12 +0200 (CEST)
Date:   Tue, 3 May 2022 10:26:12 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Ferry Toth <fntoth@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 0/7] Polling be gone on LAN95xx
Message-ID: <20220503082612.GA21515@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
 <a9fcc952-a55f-1eae-c584-d58644bae00d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9fcc952-a55f-1eae-c584-d58644bae00d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 10:33:06PM +0200, Ferry Toth wrote:
> Op 27-04-2022 om 07:48 schreef Lukas Wunner:
> > Do away with link status polling on LAN95XX USB Ethernet
> > and rely on interrupts instead, thereby reducing bus traffic,
> > CPU overhead and improving interface bringup latency.
> 
> Tested-by: Ferry Toth <fntoth@gmail.com> (Intel Edison-Arduino)

Thank you!

> While testing I noted another problem. I have "DMA-API: debugging enabled by
> kernel config" and this (I guess) shows me before and after the patches:
> 
> ------------[ cut here ]------------
> DMA-API: xhci-hcd xhci-hcd.1.auto: cacheline tracking EEXIST, overlapping
> mappings aren't supported

That is under investigation here:
https://bugzilla.kernel.org/show_bug.cgi?id=215740

It's apparently a long-standing bug in the USB core which was exposed
by a new WARN() check introduced in 5.14.

Thanks,

Lukas
