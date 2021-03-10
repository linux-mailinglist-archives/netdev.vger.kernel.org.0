Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB7333294
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhCJAv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCJAvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:51:36 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CA9C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 16:51:35 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b13so24484764edx.1
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 16:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=owQb56cWVlYEBc3shoHPbmBiP14n3jOFAOCgKVQbHH4=;
        b=kyKurqUnZGSsSkEavcpUsTHVpJb45YuW2OTz9Jw4hGBNOU9yk6AiGcvJMKwvaq5XOY
         LDsvVfNCKrW6XkO2SMzEwFt0S3nBynxZdj0tce78xU7w3lOT4BdAUUUUmA5mrfuhFub3
         lAaw9D0UOvnZWbCpWP3aXW3Sb1hdzplcrveCdWy4NCsAUEvyiBUVIXitSxRMylZG+pXU
         LBzGps7KNAxxhF2f1pRsimeFT1QIUS2t4ar1DM+gyONbOlRoSKxgl1/4D4XuJrCEIGSc
         af3lUolft0CqLfnAHbLVlxIVAuLsYdxNgSBiDvZNb/36Fv4AyGjVF+Ce/QFnOIlf1qVk
         pnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=owQb56cWVlYEBc3shoHPbmBiP14n3jOFAOCgKVQbHH4=;
        b=MO/KuweKpsOzqA+917Lg52EBPGiofseGpw+LMLHErOijJX/wLwFTqEq1on5gKpbSjf
         uDJ1C/FFRMFcSx2gPfXuqOxQO90snKXojWAcX2lbIrjJMkw1RZP1SeUucKeL6I+Ps6R8
         k93QGmQa1hYpiVugmvvw3hPG6A18eckT8NRINgOoHp1kjAJfIurU/aQ+58IdGcJWDQ0G
         +Fl4R03DT0VCW3rn5WFxRvtr4QQrFGBsWT+zmxOXwhfL/02qz4rN/cB1Qt6ewSExH3SM
         zLgW1wCA+/Cr1g2CiDCG+QrqzNOndIU8xlue6/JS/TFKVtrOhVZQUnS+oYNTnHOIRyoR
         LiXQ==
X-Gm-Message-State: AOAM532dHo9lb0dWKyugDZMZEjOY//qA5TzavAhpJHY5TL+4Ujon+m8i
        +n4w0fa3zkmhRzOrVcBS97I=
X-Google-Smtp-Source: ABdhPJwIQ36PZ3R3Kjzy4I8vTNq1kKJoGQbhzFU1gKT83sWikR1ORC/WjF8agqfxa1DdIWSmsR1qdw==
X-Received: by 2002:aa7:d917:: with SMTP id a23mr383136edr.122.1615337494249;
        Tue, 09 Mar 2021 16:51:34 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id 14sm9128034ejy.11.2021.03.09.16.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 16:51:34 -0800 (PST)
Date:   Wed, 10 Mar 2021 02:51:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <20210310005132.mzfzkxtpo3hjnsts@skbuf>
References: <20210309184244.1970173-1-tobias@waldekranz.com>
 <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
 <87h7lkow44.fsf@waldekranz.com>
 <YEgTKSS+3ZmeXB66@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEgTKSS+3ZmeXB66@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:30:33AM +0100, Andrew Lunn wrote:
> On Tue, Mar 09, 2021 at 10:28:11PM +0100, Tobias Waldekranz wrote:
> 
> Hi Tobias
> 
> As with Florian, i've not been following the discussion.

I'm afraid there isn't much context for these patches, except Tobias
pointing out that some of the command sequences I've since spelled out
in the selftest produce results that should be refused but aren't.

But this discussion has actually branched off and into the weeds from a
completely different problem. Tobias reported that DSA attempts to
install VLANs for 8021q uppers into the VTU when the mv88e6xxx ports are
standalone, and the driver doesn't like that. This isn't due to an
invalid constellation, but instead due to improper management of a valid
one.

I've attempted to solve those issues through these three patches, which
at the moment are not properly grouped together, but I think I will pull
them out and send them separately, and let Tobias finish the central
rejection of invalid VLAN constellations:

https://patchwork.kernel.org/project/netdevbpf/patch/20210308135509.3040286-1-olteanv@gmail.com/
https://patchwork.kernel.org/project/netdevbpf/patch/20210309021657.3639745-4-olteanv@gmail.com/
https://patchwork.kernel.org/project/netdevbpf/patch/20210309021657.3639745-5-olteanv@gmail.com/

It would be nice if you could take a look at those three patches before
I resend them tomorrow, also for Tobias to let me know if they fix the
issue he initially reported.
