Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387E9404027
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 22:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348752AbhIHUWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 16:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHUWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 16:22:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ACEC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 13:21:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i6so4615518edu.1
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 13:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mx1GDiALnUZOH5H4kmCBwVFt/uXe5864V+8BV4Kn1do=;
        b=BHylC2Oa8gXK7ndOSJ+i+Pfw2qi/Rqal6Y4ibGBHzIujOcP1zpXA6HuE8djsjZTNbD
         JwhokDUWIrop3OiwVMTYhjqoYqdanJ5mZwEV4DrBaKVyTEexoC/qUarPOCm1DwCVyHlp
         spWSTEcdwtDVaLL1d+WIVelh4jNxl65piV8cJ1lcGb4BQVVePNjrjA+y0HcrohFwHg3F
         Mb6VHdPeyNqRSUWswv8mEVJ61e5B00iUPAIK5Lq9qglt0ZaZzUxNoExvaEGK66xAi6hH
         uVKrbanI42joqbCYkZiN+2iHaBYDdgd9WoLVAeoc3YAPzMWmBHUwxC5JQEroE9Lh7hl7
         aZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mx1GDiALnUZOH5H4kmCBwVFt/uXe5864V+8BV4Kn1do=;
        b=gkanzwD0UjdCyNSy9N1d7N3ARyjIZ5RiZYi0Dp32t0VyUl3iNXYWhbYQd+bRTrO83V
         OtfKP/vdoqHqolpa3S7MBMPB0ZEfKTNI7RSz+QzrrkAE/yu0icfzbg3jQ1wZXCYcDqL9
         5ytaSka3TQ8S9D5V+4B/RQNwBzAR3JHQjU0h/V2geJOsCEAfhxn1m+LTHmGqRRChgFhB
         WASApQL9sYnhDaMQRdz/LQ773dz4IsU9Jy7Fv8xHxHRb04WjFXJZjEBuNppudRxdsGMI
         n0l7Q/7FW4fwdAeSReg0t89VdZ4uksuwN6cHZcmGrR6fxqC/jSWKczAQHtxe4yGSx1X0
         PVoQ==
X-Gm-Message-State: AOAM530fHRXg6YmFtuLNiQyCNC4LxYBVQjFGKgfMMJ+yepHysxVfzrZK
        b5BpgkEC8czSkue5+A2aYsQ=
X-Google-Smtp-Source: ABdhPJzMhWVkRKPKse+7L9eeXKLPEDM/GhePHfkcUNsJMZ9GgpV88VYQlR2dVXwwUlHlHKnvvtBKJw==
X-Received: by 2002:a05:6402:c84:: with SMTP id cm4mr33057edb.381.1631132467759;
        Wed, 08 Sep 2021 13:21:07 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id r18sm43656edd.69.2021.09.08.13.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:21:07 -0700 (PDT)
Date:   Wed, 8 Sep 2021 23:21:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210908202106.bdwnwwx3gcvw54my@skbuf>
References: <YTRswWukNB0zDRIc@unreal>
 <20210905084518.emlagw76qmo44rpw@skbuf>
 <YTSa/3XHe9qVz9t7@unreal>
 <20210905103125.2ulxt2l65frw7bwu@skbuf>
 <YTSgVw7BNK1e4YWY@unreal>
 <20210905110735.asgsyjygsrxti6jk@skbuf>
 <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac8e1c9e-5df2-0af7-2ab4-26f78d5839e3@gmail.com>
 <YTeWmq0sfYJyab6d@lunn.ch>
 <a71d0e0c-159e-e82e-36f2-bf3434445343@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a71d0e0c-159e-e82e-36f2-bf3434445343@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 09:49:48AM -0700, Florian Fainelli wrote:
> On 9/7/2021 9:43 AM, Andrew Lunn wrote:
> > On Tue, Sep 07, 2021 at 08:47:35AM -0700, Florian Fainelli wrote:
> > > 
> > > 
> > > On 9/7/2021 8:44 AM, Jakub Kicinski wrote:
> > > > On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
> > > > > Again, fallback but not during devlink port register. The devlink port
> > > > > was registered just fine, but our plans changed midway. If you want to
> > > > > create a net device with an associated devlink port, first you need to
> > > > > create the devlink port and then the net device, then you need to link
> > > > > the two using devlink_port_type_eth_set, at least according to my
> > > > > understanding.
> > > > > 
> > > > > So the failure is during the creation of the **net device**, we now have a
> > > > > devlink port which was originally intended to be of the Ethernet type
> > > > > and have a physical flavour, but it will not be backed by any net device,
> > > > > because the creation of that just failed. So the question is simply what
> > > > > to do with that devlink port.
> > > > 
> > > > Is the failure you're referring to discovered inside the
> > > > register_netdevice() call?
> > > 
> > > It is before, at the time we attempt to connect to the PHY device, prior to
> > > registering the netdev, we may fail that PHY connection, tearing down the
> > > entire switch because of that is highly undesirable.
> > > 
> > > Maybe we should re-order things a little bit and try to register devlink
> > > ports only after we successfully registered with the PHY/SFP and prior to
> > > registering the netdev?
> > 
> > Maybe, but it should not really matter. EPROBE_DEFER exists, and can
> > happen. The probe can fail for other reasons. All core code should be
> > cleanly undoable. Maybe we are pushing it a little by only wanting to
> > undo a single port, rather than the whole switch, but still, i would
> > make the core handle this, not rearrange the driver. It is not robust
> > otherwise.
> 
> Well yes, in case my comment was not clear, I was referring to the way that
> DSA register devlink ports, not how the mv88e6xxx driver does it. That is
> assuming that it is possible and there was not a reason for configuring the
> devlink ports ahead of the switch driver coming up.

There is a comment in dsa_switch_setup:

	/* Setup devlink port instances now, so that the switch
	 * setup() can register regions etc, against the ports
	 */

The fact of the matter is that in the current driver-facing API, there
is no better place to register devlink port regions than .setup: we have
no .port_setup and .port_teardown. This also forces us to register the
devlink ports earlier than we register the net devices.

In one of my previous replies to Leon I did indicate the introduction of
these two methods as a possibly less horrible way of packaging what we
have now in this patch as .port_reinit_as_unused, which is basically a
.port_teardown followed immediately by a .port_setup, as it would be
implemented by mv88e6xxx.

With the introduction of .port_setup and .port_teardown as an immediate
bug fix, reordering the devlink port registration vs the netdev connection
to the PHY could be done as further work, but it would sort of be a moot
point, since it would not solve any problem anymore.
