Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C737D59755E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiHQR4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238114AbiHQR4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:56:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934AC8A6CF;
        Wed, 17 Aug 2022 10:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27EEF6130C;
        Wed, 17 Aug 2022 17:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D000C433C1;
        Wed, 17 Aug 2022 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660758961;
        bh=H0WN0SKSzHj/Y3yIn4ttq9resFGHFWrpR6BX7VF6nwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mgO+rVa8N93OxE0V8iZUhqdR2/gjdD1sYo5xdeWad59Q2tJlj9OGuWPliJyd8ZOdc
         Gv32LZEDb/ZWnQOLYQ5eZx6B6h8dp7ap/9GmAeujcs6mF2+OghiD4PpTiGrsvu82n6
         5RDk904GtHWJUt2XR70q0UqCoB7gH7hxB2wLki2pkywqPUSsKk+SW2cxH0Uws0y0Yo
         z9BYTyDPDG+BUY7kq/gaMQ3vQqC6n6R1zuo+sUST1EX23yIktyp9alfmfb9CrMWD7c
         5qE3SixaJKzjwqC1DxDyHZb9IVG+OXIwsWijs0DaWCvvg1qBaKSSy2jikbqoER2Kv2
         xzNrI/yqaQNcw==
Date:   Wed, 17 Aug 2022 10:56:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220817105600.2aa3612c@kernel.org>
In-Reply-To: <20220817172704.ne3cwqcfzplt2pgp@skbuf>
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
        <20220817085414.53eca40f@kernel.org>
        <20220817172704.ne3cwqcfzplt2pgp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 20:27:04 +0300 Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 08:54:14AM -0700, Jakub Kicinski wrote:
> > On Mon, 15 Aug 2022 10:50:07 -0700 Florian Fainelli wrote:  
> > > Hi all,
> > > 
> > > This patch series has the bcm_sf2 driver utilize PHYLINK to configure
> > > the CPU port link parameters to unify the configuration and pave the way
> > > for DSA to utilize PHYLINK for all ports in the future.
> > > 
> > > Tested on BCM7445 and BCM7278  
> > 
> > Last call for reviews..  
> 
> My review is: let's see what breaks...

*nod*, thanks!
