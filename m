Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29BF515C2D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 12:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiD3KNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiD3KNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 06:13:07 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDFBBC3D
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 03:09:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id B17FE2800B1D0;
        Sat, 30 Apr 2022 12:09:43 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A626411B170; Sat, 30 Apr 2022 12:09:43 +0200 (CEST)
Date:   Sat, 30 Apr 2022 12:09:43 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220430100943.GB18507@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de>
 <20220425074146.1fa27d5f@kernel.org>
 <20220430100541.GA18507@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430100541.GA18507@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 12:05:41PM +0200, Lukas Wunner wrote:
> But this means that we may still call linkwatch_fire_event() after
> unregister_netdev()!

I meant to say, "we may still call linkwatch_fire_event() after
the state has changed to NETREG_UNREGISTERED".
