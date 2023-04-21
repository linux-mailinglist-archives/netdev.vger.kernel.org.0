Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03036EAF3B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbjDUQfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjDUQfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:35:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4460514F4F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=G7DrwUkI9X9/4ib3R85fzXA1RzcQ+DjdzK4lXUgppDk=; b=lg
        BQT3UjKSD8IJb5Iw5euEDPuDCOscd52wFgGw4En8g92C3qHw4zH5tJX/V5m+5AXnYYcrVkxme9qz9
        JXbH6HtNTDXJShI+myno/rgZ35hDHr5AAapdmcY9mESTluOwps5FMUPcy1MsCIAM7T4see9XbxhF4
        9MXt3CI3sph+9c4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pptiu-00Au1e-Be; Fri, 21 Apr 2023 18:35:00 +0200
Date:   Fri, 21 Apr 2023 18:35:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ron Eggler <ron.eggler@mistywest.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: issues to bring up two VSC8531 PHYs
Message-ID: <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
 <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
 <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You can also try:
> > 
> > ethtool --phy-statistics ethX
> 
> after appliaction of the above patch, ethtool tells me
> 
> # ethtool --phy-statistics eth0
> PHY statistics:
>      phy_receive_errors: 65535
>     phy_idle_errors: 255

So these have saturated. Often these counters don't wrap, they stop at
the maximum value.

These errors also indicate your problem is probably not between the
MAC and the PHY, but between the PHY and the RJ45 socket. Or maybe how
the PHY is clocked. It might not have a stable clock, or the wrong
clock frequency.

    Andrew
