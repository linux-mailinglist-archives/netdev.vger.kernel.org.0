Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C0746BDDB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhLGOkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhLGOkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:40:39 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C815C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:37:09 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so57667205edd.13
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 06:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OTT7YUCEa1E3hP8WLsO9/vJkBzlDJR6jCNZWQ2kHPcE=;
        b=JjkAOOJGR+yqBuSF0D0JXAckLr0e+ShpVyyrMMQ2ozcnkt4erkliUQe3cxHJ7MUAr0
         +6MjmKWl/PzeuTiGzKO8XotH9ZZm8VhJilGfpRKYcbmHXtKP0gklYBig3BwrlsJRldJa
         NxIsvuC4Pq2tyacEG6DtxAJtulPey8Nbcp3LNeJ6vHelF6LblonD44rEaeftutlFdekL
         w9wcrdOCTolQxwWl8edjkugsTDxT1iJiT/Gtf2luGuPbrOwX3nsoLwVSg+nbbsR688lG
         6WzsLkVuxzCHhd5/BVDLf+6t+9TdxiYKHKBRP9reJjyDfDx9uGS6DTThiZ5GzoKm45WN
         OKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OTT7YUCEa1E3hP8WLsO9/vJkBzlDJR6jCNZWQ2kHPcE=;
        b=q/8JFQeVQb/xRUs77Ld7MffjUZ56OQWhah1cC+pD/2EJhqf269YCWpbU0Knj1Ap8KF
         Dvv+Qbnr7A/be5iYe6VoQhI5TLpG1dYywnZWrRjmHgHyulAtSVJpKRlkkcJG1ADuYtiA
         jKshYXb/zgFYKTjIyeotVpwysVEuyWywpS0t3pB1ZSRj9UbTVb0+X94AWZ82URnLit5/
         EaxAHll7ro38M5FmqNOs+HZss/FLEbWutCY7Iv3lTlIfOgyaOms9b3h9EDwXhHVVCY8+
         nHboBHkv7Z/W5Bmn13zCKDBa5R/sKXO+vgFIw5SEwm92TiyhyyhVLVqtLZnZ7sImdaF5
         Y5FA==
X-Gm-Message-State: AOAM530/f8tl+JEmUnt+slszE8Pcjcc0NXLRawjOwVOdtDcm1Z3JX+1y
        X0XLD0BN+iy1YCHUZnoQTR8=
X-Google-Smtp-Source: ABdhPJzJri9kkTd7BidCqlvMsZQr8rDvN8iFEGt32XcSHFp5yjoBnUv71EP5OXOf0hYAKaudeJDSeA==
X-Received: by 2002:a17:906:3408:: with SMTP id c8mr53777950ejb.41.1638887826991;
        Tue, 07 Dec 2021 06:37:06 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id jx10sm8611488ejc.102.2021.12.07.06.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:37:06 -0800 (PST)
Date:   Tue, 7 Dec 2021 16:37:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211207143705.46fd2zavniwb3gri@skbuf>
References: <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
 <20211206232735.vvjgm664y67nggmm@skbuf>
 <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
 <20211207132413.f4av4d3expfzhnwl@skbuf>
 <Ya9op2QJwWRyqmDY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya9op2QJwWRyqmDY@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 01:59:03PM +0000, Russell King (Oracle) wrote:
> The change that I have proposed is based on two patches:
> 
> 1) Change mv88e6xxx_port_ppu_updates() to behave sensibly for the 6250
>    family of DSA switches.
> 
> 2) Un-force the link-down in mv88e6xxx_mac_config()
> 
> This gives us more consistency. The checks become:
> 
> a) mac_link_down():
> 
>         if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
>              mode == MLO_AN_FIXED) && ops->port_sync_link)
>                 err = ops->port_sync_link(chip, port, mode, false);
> 
> b) mac_link_up():
> 
>         if (!mv88e6xxx_port_ppu_updates(chip, port) ||
>             mode == MLO_AN_FIXED) {
> ...
>                 if (ops->port_sync_link)
>                         err = ops->port_sync_link(chip, port, mode, true);
>         }
> 
> c) mac_config():
> 
>         if (chip->info->ops->port_set_link &&
>             ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
>              (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
>                 chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
> 
> The "(mode == MLO_AN_INBAND && p->interface != state->interface)"
> expression comes from the existing code, so isn't something that
> needs discussion.
> 
> We want to preserve the state of the link-force for MLO_AN_FIXED,
> so the only case for discussion is the new MLO_AN_PHY. It can be
> seen that all three methods above end up using the same decision,
> and essentially if mv88e6xxx_port_ppu_updates() is true, meaning
> there is a non-software method to handle the status updates, then
> we (a) don't do any forcing in the mac_link_*() methods and turn
> off the forcing in mac_config().

Ok, so if we are in:
- MLO_AN_PHY (internal or external) and PPU enabled, we're letting the link unforced in mac_config
- MLO_AN_PHY (internal or external) and PPU disabled, we're forcing the link up in mac_link_up,
  via the "!mv88e6xxx_port_ppu_updates()" check.
- MLO_AN_FIXED, we're also forcing the link up in mac_link_up, via the
  "mode == MLO_AN_FIXED" check.

So in Martyn's case, a CPU port internal PHY link which is forced down
in mac_link_down would either be forced up or unforced, but never be
left the way in which mac_link_down put it. That is good and appears
robust.

Although it isn't strictly true that "[ if ] there is a non-software
method to handle the status updates, then we don't do any forcing in
the mac_link_*() methods", because technically we still do in
mac_link_down, due to the " || mode == MLO_AN_FIXED" condition plus the
way in which we are called, it's just that we undo it later.
