Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516C435217D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbhDAVRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhDAVRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 17:17:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BB5C0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 14:17:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q5so2319789pfh.10
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 14:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/F9aohR1BSzJ/+NpvA/TUMKcSy+/z/l1J3L1YQAAZs0=;
        b=vRFtG9phARD8ksalqZPB0vfzaDFw0FEeVKm+yHg6vlOSiKJ5glv6McGn0SYgW7ZJKa
         6CRM3fsu23NvinqsyGVUBsiymTQe9u6Cbe6VFX3/qkDOsEm7DsmOOXsuKo/IDpTSuTWp
         +wUZSU8kGlCIM45zPf2QDY/jVYJFf0imtsDPap4ZEg4q5sLGH6KnIHHncUG4IgB+yqp/
         MAFjGNj4GKlpjM9il9R/Cm2Eq+UjKxKF0w6Tapz2njn6BGpFZa/TycjMLgi/i+cP+ZPo
         oXrUkkQFNEaFtI6olWFHNxmFsqDuVEKO/1MRJVBPXQEdWMD9W/zO8OGNyfqBZlZaB75F
         2SLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/F9aohR1BSzJ/+NpvA/TUMKcSy+/z/l1J3L1YQAAZs0=;
        b=GqtSq9vmQ9XbY/GoX+7faxKEuKjE71JOFyy0n34r+8MJwFyCGPDdle0M70Yu6AZPyG
         QJ/so3Ax5y956ZN3NBfRmPyIaErvC6T33MFYNFmBs3GMrzxXnZ0JbYCk3pIA72vD/cUV
         sDwWYv80eC2EIWSxbXt7Vj+yyOm5MRYIZWMzcRhlLntIs02dYwafHINjhi5kj+1xpP/C
         pWHXOcCn/v1U5INC3Ld9SMEDiSWlwa0q1IMcdVZEBiOxlQUxtg91KJ1+0DCIJKl0Pu7M
         TvHPDt+JZELCuKTyOgz8OvLe1hlEl9sGiTTPMqCfb5LhSSGoRV7ScP6xZn3u1sxtmJEV
         hl5A==
X-Gm-Message-State: AOAM533kew/Xh59OlbqkqAliJPK9FD5PTMOyCQnWFo3gozynDn63N6Br
        4kM7dCyTB9qfs1Ak2vTPN9s=
X-Google-Smtp-Source: ABdhPJzBObiHDv4Vovh4V//eocHscpRdbE6CH8JfRcYBRouhq9tOwAhV9/roTM/+N7XOSZEMgQwGHw==
X-Received: by 2002:a62:84c3:0:b029:1f5:8dbf:4e89 with SMTP id k186-20020a6284c30000b02901f58dbf4e89mr9131213pfd.49.1617311850510;
        Thu, 01 Apr 2021 14:17:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id e6sm6060375pfc.159.2021.04.01.14.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 14:17:30 -0700 (PDT)
Date:   Fri, 2 Apr 2021 00:17:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: net: phylink: phylink_helper_basex_speed issues with 1000base-x
Message-ID: <20210401211721.hsrqn3gerz4nlwgk@skbuf>
References: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Thu, Mar 25, 2021 at 11:36:26AM -0500, George McCollister wrote:
> When I set port 9 on an mv88e6390, a cpu facing port to use 1000base-x
> (it also supports 2500base-x) in device-tree I find that
> phylink_helper_basex_speed() changes interface to
> PHY_INTERFACE_MODE_2500BASEX. The Ethernet adapter connecting to this
> switch port doesn't support 2500BASEX so it never establishes a link.
> If I hack up the code to force PHY_INTERFACE_MODE_1000BASEX it works
> fine.
> 
> state->an_enabled is true when phylink_helper_basex_speed() is called
> even when configured with fixed-link. This causes it to change the
> interface to PHY_INTERFACE_MODE_2500BASEX if 2500BaseX_Full is in
> state->advertising which it always is on the first call because
> phylink_create calls bitmap_fill(pl->supported,
> __ETHTOOL_LINK_MODE_MASK_NBITS) beforehand. Should state->an_enabled
> be true with MLO_AN_FIXED?
> 
> I've also noticed that phylink_validate (which ends up calling
> phylink_helper_basex_speed) is called before phylink_parse_mode in
> phylink_create. If phylink_helper_basex_speed changes the interface
> mode this influences whether phylink_parse_mode (for MLO_AN_INBAND)
> sets 1000baseX_Full or 2500baseX_Full in pl->supported (which is then
> copied to pl->advertising). phylink_helper_basex_speed is then called
> again (via phylink_validate) which uses advertising to decide how to
> set interface. This seems like circular logic.
> 
> To make matters even more confusing I see that
> mv88e6xxx_serdes_dcs_get_state uses state->interface to decide whether
> to set state->speed to SPEED_1000 or SPEED_2500.
> 
> I've been thinking through how to get the desired behavior but I'm not
> even sure what the desired behavior is. If you set phy-mode to
> "1000base-x" in device-tree do you ever want interface to be set to
> PHY_INTERFACE_MODE_2500BASEX? If so just for MLO_AN_INBAND or also for
> ML_AN_FIXED? Do we want phylink_validate called in phylink_create even
> though it gets called anyway for MLO_AN_INBAND and ML_AN_FIXED later?

I think these are good and valid questions. If I had a good justification
for the current phylink behavior I would have answered them, but I don't.
