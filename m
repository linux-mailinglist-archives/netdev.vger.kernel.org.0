Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2547F37749D
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 02:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhEHX7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 19:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhEHX7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 19:59:14 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC12C061573;
        Sat,  8 May 2021 16:58:12 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t18so12866246wry.1;
        Sat, 08 May 2021 16:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cDeX9dJBQUp2MmwTalg9QAqTtC+yrbk1DqUZMXyGIwY=;
        b=Yg1X4+PfmxNaU1p3FTyuZV5otAK93xJFjTeOxbEa5PUxysqLKnEjfXwW7BvTRpQnNg
         BYFGnQwQCXRaTUwYZgoUy1N2EcOCpSbZWbBVYOkTXB26JxzR87Ii3j1TPBQ9oeNf6Fmt
         kuAnguL1xa+zmEK2dKeDrA+3UzezU5GRbisVfjNpTwFIjsV0oQl4lmfutKVPiY9IJklB
         qYl+3sMMoIyyJjecRgdBk8wpFEPbSFVH8Lb9X61Q/7tF2L6kfKaNJ/d3NByrHo7S0y/m
         xI0kQy+I8FWyot4KUsKHbjIGSlWIthTN3KbeFF72lqFIswXUOQI8QBSZQCp4jmL3Funh
         /+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cDeX9dJBQUp2MmwTalg9QAqTtC+yrbk1DqUZMXyGIwY=;
        b=b6Bnsl9Fj/3a37/s9hKzUkCFDl3RySXVw1t3C0R9vOMRgnmQKV/mosgyF9pEgCgZhh
         t95aU6VEFoCPerukpZDRHBeTh14ikq2xRcmnW6hXO29z3HbVlkwspscOmmCFu4WMy2Q+
         seHl0IEhwDvAqsDmhwemEvn4FFkIshujje1zkCDF6Y0ckCvK78l6ooEa1pxFzgCKK28X
         RIphSJjRWXrlqqdBEvSeB1kyw1HA2DdjxyrHlwnt6R2/8JvjTNvHuOfXE1+/HOymk1O7
         7ojUcD09pYovgsWaa+AA37G3Dw8EL9flIgznSceT+7KnxRf7FRsCk27PH7bGMVXSnm9m
         kQow==
X-Gm-Message-State: AOAM533zCcgjfuLREgCnf+f6zGf4ZjjK084vYrUcKQe7Y727a4elMWgS
        KUnruzvT1tuNgFeTDDj5LZ4V0JW940mXJw==
X-Google-Smtp-Source: ABdhPJwp9E8RtWkiN6M1T88JmnVDD5Rx5q+XkFu/zdfkpwOuu7smSWC3mECPbMH/P9Cev6DNs87dqQ==
X-Received: by 2002:adf:8b09:: with SMTP id n9mr22167988wra.148.1620518291170;
        Sat, 08 May 2021 16:58:11 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id e8sm15849262wrt.30.2021.05.08.16.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 16:58:10 -0700 (PDT)
Date:   Sun, 9 May 2021 01:58:07 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJclj7wLsR3CK3KQ@Ansuel-xps.localdomain>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-19-ansuelsmth@gmail.com>
 <YJbUignEbuthTguo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJbUignEbuthTguo@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 08:12:26PM +0200, Andrew Lunn wrote:
> > +
> > +	/* Assume only one port with rgmii-id mode */
> 
> Since this is only valid for the RGMII port, please look in that
> specific node for these properties.
> 
> 	 Andrew

Sorry, can you clarify this? You mean that I should check in the phandle
pointed by the phy-handle or that I should modify the logic to only
check for one (and the unique in this case) rgmii port?

