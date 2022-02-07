Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0D4AC0E4
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357264AbiBGOQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390936AbiBGOF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:05:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4914EC043189;
        Mon,  7 Feb 2022 06:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bZkPt3tJIWdpwN+WGfn+8VumHQlVZ74e44nHdwfLHi0=; b=zJxPWUxjtl0SxNUn8gsA7U4fGZ
        xOycPFeDc3quhnDYqGWc3uwL8tL8zZuPkypOUHRB+CK9gRf+j8YthUEy9jcegnBL6/NAuuTPUqQt7
        Fx+qbSB+dFbz43ikBSYn/MtGDvYqE6quuWGdULOvni2qxMoYZwgwRwLdiVtlCloH6nPg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nH4du-004e27-Mv; Mon, 07 Feb 2022 15:05:22 +0100
Date:   Mon, 7 Feb 2022 15:05:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: mv88e6xxx: Add support for bridge
 port locked feature
Message-ID: <YgEnIksFSHaRZtK7@lunn.ch>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-4-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207100742.15087-4-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 11:07:41AM +0100, Hans Schultz wrote:
> Supporting bridge port locked mode using the 802.1X mode in Marvell
> mv88e6xxx switchcores is described in the '88E6096/88E6097/88E6097F
> Datasheet', sections 4.4.6, 4.4.7 and 5.1.2.1 (Drop on Lock).

This implementation seems to be incorrect for 6390X, and maybe
others. I just picked a modern devices at random, and it is different,
so didn't check any other devices.  The 6390X uses bits 14 and 15, not
just bit 14.

So either you need to narrow down support to just those devices this
actually works for, or you need to add implementations for all
generations, via an op in mv88e6xxx_ops.

    Andrew
