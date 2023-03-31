Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA016D203F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCaM2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjCaM2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:28:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9256D1EFEB;
        Fri, 31 Mar 2023 05:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7ZpSK7GjfgyP1lpMVs9s71enrcnwHhDc+XTut1yerCg=; b=zBq2dE6wqUlrjq3xea7L3aRcRh
        yVJsFTVYq5tCybuDc29hMgODvvyKRLi+z3bYzvZtEmlUEXfbQjxbcpH3pSwjGI5hsqPQPqvJ393aR
        UANvsc1SkSUjwhwU0i4F30AuMf4jKgLzy29QnGoBvk3rH/F/4Cl3HHj+woQ2XOrktCPA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1piDrA-0091YU-FW; Fri, 31 Mar 2023 14:27:48 +0200
Date:   Fri, 31 Mar 2023 14:27:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gustav Ekelund <gustav.ekelund@axis.com>
Cc:     marek.behun@nic.cz, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Gustav Ekelund <gustaek@axis.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: Reset mv88e6393x force WD
 event bit
Message-ID: <ac0425d3-d52d-4c1b-8bf9-a4be2db87600@lunn.ch>
References: <20230331084014.1144597-1-gustav.ekelund@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331084014.1144597-1-gustav.ekelund@axis.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:40:13AM +0200, Gustav Ekelund wrote:
> From: Gustav Ekelund <gustaek@axis.com>
> 
> The force watchdog event bit is not cleared during SW reset in the
> mv88e6393x switch. This is a different behavior compared to mv886390 which
> clears the force WD event bit as advertised. This causes a force WD event
> to be handled over and over again as the SW reset following the event never
> clears the force WD event bit.
> 
> Explicitly clear the watchdog event register to 0 in irq_action when
> handling an event to prevent the switch from sending continuous interrupts.
> Marvell aren't aware of any other stuck bits apart from the force WD
> bit.
> 
> Signed-off-by: Gustav Ekelund <gustaek@axis.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
