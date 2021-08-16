Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483B03ED92A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhHPOs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhHPOs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:48:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE2C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:47:55 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bo19so26797527edb.9
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K+zhgFRJ+DUqtcgK+lv2D2SibB1ZuiRsKs/d3sTPn9U=;
        b=BwVAAqXdHJxtuByC1X9t4Y1y6Qb3Jb69SO17LwBbNmq0TnGPIRtitZdcQqJsv8yjIl
         rhzEiwt74j8UEnR0s2jeXI4gKR1KKts9AbuTYThdwWrj2Tav1FxyQ07uwLRg8zUEot8z
         fPn5DCxWkJFS2rr/27xPD5TiOJQbJle4/1Gmxz8U1HoMd172xTlrvCcVDtd+KGYUM4bl
         mqiMPi1M1vN+eZrkV+vyLa9PyKlhYCiqXQx/4EshI/WoVOoMmn1DTc3UujP6ita+uwPU
         45Vf743n+oFJizf/KKgDydI1CO7VA3jweUc9m+Vcilg5gHJxBehskCJ9iaVAIYmnEfp0
         W91w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K+zhgFRJ+DUqtcgK+lv2D2SibB1ZuiRsKs/d3sTPn9U=;
        b=YpvQdLvv0/+U8QyFEDbjolxqU1YV9RIi2Hh/n2aSjh4PpsJbIKR6r57RhU5JNNNWNx
         Bu7OwC6UFDdQiN77bJtyoeMLxpfXXA/wgYVdSc4coMO40r/ZPPkOZQXUXjM2zF0VXe6E
         84/rn0wve8XGxyt+uBCqfshmsEDWeVoDOmWg+iJJwmRemxDtGHkwfIPy9Ebs7rkfQou7
         g1TlYxjVCtB2bFh20U4x9fpWT8dF4Pr4sVSUFguirhDaNOKsgPatCn3P+57kKLWwEi0I
         QnTW90VyJFdbLrKt98HE7zBOI+pP2/Rj56MvDf5ilRnIyGs/klWMXb5FE390jfPqH9r6
         V+5g==
X-Gm-Message-State: AOAM533A6SF3wb0rD78zRQVnL/HlWLMg2JwCVkPN1Spboy2j57EEYPwC
        0BWkHfZC2T32Ynr/3MPsQbI=
X-Google-Smtp-Source: ABdhPJy7BZJcQV1UczxYoH+7lJHiwJahrP1U1VY7BvDleAyvdVMXN2SVZ9OXcASJ8pxFKimivdsXuQ==
X-Received: by 2002:aa7:c799:: with SMTP id n25mr19935947eds.16.1629125273896;
        Mon, 16 Aug 2021 07:47:53 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c16sm3777941ejm.125.2021.08.16.07.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:47:53 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Mon, 16 Aug 2021 17:47:52 +0300
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <20210816144752.vxliq642uipdsmdd@skbuf>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720141134.GT22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 03:11:34PM +0100, Russell King (Oracle) wrote:
> On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> > On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > > Phylink documentation says:
> > >   Note that the PHY may be able to transform from one connection
> > >   technology to another, so, eg, don't clear 1000BaseX just
> > >   because the MAC is unable to BaseX mode. This is more about
> > >   clearing unsupported speeds and duplex settings. The port modes
> > >   should not be cleared; phylink_set_port_modes() will help with this.
> > > 
> > > So add the missing 10G modes.
> > 
> > Hi Russell
> > 
> > Would a phylink_set_10g(mask) helper make sense? As you say, it is
> > about the speed, not the individual modes.
> 
> Yes, good point, and that will probably help avoid this in the future.
> We can't do that for things like e.g. SGMII though, because 1000/half
> isn't universally supported.
> 
> Shall we get this patch merged anyway and then clean it up - as such
> a change will need to cover multiple drivers anyway?
> 

This didn't get merged unfortunately.

Could you please resend it? Alternatively, I can take a look into adding
that phylink_set_10g() helper if that is what's keeping it from being
merged.

Ioana
