Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3003B4AD9D9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358121AbiBHN31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350497AbiBHN3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:29:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724C9C03FEFC;
        Tue,  8 Feb 2022 05:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=w+Ej+La2LqxHnMgE2GgZYSXKz5C1mPbpdOPN8mSn2B8=; b=IN
        PaFa2GK1Wf4auzuE0IlGRosTuaGXONOMUiysokRNZbdZbO9xjRFIW+uTOj5gFFPQm6Om2oSmeaQre
        SUmkyF+1ZFVSoSZx5q/5Lp8vS4a6tQKFFg8lVxeZJk1v+SM56y227YYiQXZmYJGnrby2sb8/jxuUU
        AB7jcLlCgd2HOSE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQWB-004reI-LW; Tue, 08 Feb 2022 14:26:51 +0100
Date:   Tue, 8 Feb 2022 14:26:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: mv88e6xxx: Add support for bridge
 port locked feature
Message-ID: <YgJvm3fy5SBOpiPk@lunn.ch>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
 <20220207100742.15087-4-schultz.hans+netdev@gmail.com>
 <YgEnIksFSHaRZtK7@lunn.ch>
 <86mtj1lfm2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86mtj1lfm2.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 01:14:45PM +0100, Hans Schultz wrote:
> On mån, feb 07, 2022 at 15:05, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Mon, Feb 07, 2022 at 11:07:41AM +0100, Hans Schultz wrote:
> >> Supporting bridge port locked mode using the 802.1X mode in Marvell
> >> mv88e6xxx switchcores is described in the '88E6096/88E6097/88E6097F
> >> Datasheet', sections 4.4.6, 4.4.7 and 5.1.2.1 (Drop on Lock).
> >
> > This implementation seems to be incorrect for 6390X, and maybe
> > others. I just picked a modern devices at random, and it is different,
> > so didn't check any other devices.  The 6390X uses bits 14 and 15, not
> > just bit 14.
> >
> > So either you need to narrow down support to just those devices this
> > actually works for, or you need to add implementations for all
> > generations, via an op in mv88e6xxx_ops.
> >
> >     Andrew
> 
> The 6096 and 6097 also use both bits 15 and 14, with '01' being Drop On
> Lock and the default being '00' No SA filtering. '11' is drop to CPU, which
> can also be used for 801.1X, so 'x1' should suffice for these devices,
> thus setting bit 14 seems appropriate.

Your code does not make this clear. Please define all four values, and
then mask and set both bits as needed.

Thanks

    Andrew
