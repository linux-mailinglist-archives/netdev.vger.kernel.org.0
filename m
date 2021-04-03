Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97763353431
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhDCNqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 09:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhDCNqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 09:46:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A023C0613E6;
        Sat,  3 Apr 2021 06:46:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ap14so10869422ejc.0;
        Sat, 03 Apr 2021 06:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gpqI5zaiSzdqgoMtsxH2Ghsa0ztJUbkC171IHtI+SVY=;
        b=L2Olk9jQn5m43ENQrm08GiTxUgKIKgVrEiwG6Qi4jD9+eRxh0ub5R4iPZ8Hyx5LFLD
         ELVGQIYoiKMJACTIVjtR8hTGs5J2fJwRYns8xCgGFRfyUAEwjAaSFO48EQz4z7ibXPp4
         VROV7c7AlU+6k1sK8Knihmq+cTFLCVOOYBYlMvojNJscnZYWaTfWGqqHd42VmwP0kpyn
         lnKWymHJF2//8XT8+Zu5u4Icu7d93h6XNdbtG3wpfI1D4rYk3eyyY7m9viICEylytIvn
         ainTkzqxTE2es1yoorXyc4nfEeuvhQz1zEmtt1QlOz/7C4k35YxF9ANWc0epiiZ51C1F
         BSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gpqI5zaiSzdqgoMtsxH2Ghsa0ztJUbkC171IHtI+SVY=;
        b=pJaHnjiSb7VD45PqdhODc0qYo+KfFZRF0qzvowvkImzmZ2Mc4bQd4fGkgSkfD13v3u
         K+ruBJCmme/pFHdIkOmGgMfk4Wn3VKJNZtJEtUbfiLwwYmUVPFpUwI/eXEC9aUtT9zqo
         3N7mQNUIrTRqtiYvSfcZjCg3MYAtH1VPsZzpdoUWiS+0VHyEpfQrAksEC5E10Zu4yCqs
         ZSRMgetiuBOGa5EvLWIGfo/kdX+lx4HLWP0PVLbMMGB6Zin1dHQpUoBbpv25l2qQCbsi
         i+V0bghimrEgf5LrXMMnRLgFx0c2/ljy6Q5YsaT6r4rZHmXucop4KbOfComyQsgVL2Fn
         ZqVA==
X-Gm-Message-State: AOAM531+JKHGqJPogm2J56bK/7c1qNlSlGpfU3I6VLy8rIVu+6Fo2NW/
        Zc8KZhATaX1lHFm6BQAI8Kc=
X-Google-Smtp-Source: ABdhPJzvvus0cuipFF2oGyzlhKHLZ92KLvCVbO+lHDdDak7EeuNhjAD/FW+IfGXm+kFnfN9Gc22rHA==
X-Received: by 2002:a17:906:14d4:: with SMTP id y20mr19104499ejc.190.1617457568030;
        Sat, 03 Apr 2021 06:46:08 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id lt22sm1823259ejb.115.2021.04.03.06.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 06:46:07 -0700 (PDT)
Date:   Sat, 3 Apr 2021 16:46:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210403134606.tm7dyy3gt2nop2sj@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
 <20210403130318.lqkd6id7gehg3bin@skbuf>
 <20210403132636.h7ghwk2eaekskx2b@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403132636.h7ghwk2eaekskx2b@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 03:26:36PM +0200, Oleksij Rempel wrote:
> On Sat, Apr 03, 2021 at 04:03:18PM +0300, Vladimir Oltean wrote:
> > Hi Oleksij,
> > 
> > On Sat, Apr 03, 2021 at 01:48:41PM +0200, Oleksij Rempel wrote:
> > > The ar9331 switch is not forwarding IGMP and MLD packets if IGMP
> > > snooping is enabled. This patch is trying to mimic the HW heuristic to take
> > > same decisions as this switch would do to be able to tell the linux
> > > bridge if some packet was prabably forwarded or not.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > 
> > I am not familiar with IGMP/MLD, therefore I don't really understand
> > what problem you are trying to solve.
> > 
> > Your switch has packet traps for IGMP and MLD, ok. So it doesn't forward
> > them. Must the IGMP/MLD packets be forwarded by an IGMP/MLD snooping
> > bridge? Which ones and under what circumstances?
> 
> I'll better refer to the rfc:
> https://tools.ietf.org/html/rfc4541

Ok, the question might have been a little bit dumb.
I found this PDF:
https://www.alliedtelesis.com/sites/default/files/documents/how-alliedware/howto_config_igmp1.pdf
and it explains that:
- a snooper floods the Membership Query messages from the network's
  querier towards all ports that are not blocked by STP
- a snooper forwards all Membership Report messages from a client
  towards the All Groups port (which is how it reaches the querier).

I'm asking this because I just want to understand what the bridge code
does. Does the code path for IGMP_HOST_MEMBERSHIP_REPORT (for example)
for a snooper go through should_deliver -> nbp_switchdev_allowed_egress,
which is what you are affecting here?
