Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C1F2FDBCF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbhATVK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 16:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436681AbhATVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:01:56 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC7C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:01:16 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id by1so29054219ejc.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YjAUNJN3Oj78l83ee42AKihXG4Dod/ZokWIkhLHuWQM=;
        b=LRNB6FMKBaVXQZAzDaLPV50mCj4Zms60F58i2XTpHO9PR3bkdwZQvekqtBy7cEHIPu
         rxXhVY2URfGUk9bdinnVuVYL1nWBvQyHUnwcSGacoeiNqdaE9ofZCpZufju7pTnBgaI/
         N635OaKeq6ENDDX+smU54+IGJuuULcT56Sdec0buSHfqrrwI2DO98ONaMHT/9/8M3kBt
         QEF0Eg2usBaUjB/lt4nixHxQ1HwHeMDE7+8tpLksQxbIDE8dQHbR1f3mxtSFnsyvXIeI
         v1pKBgxVJPkRGUAfl7sh18Z02pvA2J0Op8jAhj7Q1l8YgJmiR+X0QY7RtYNT8BDbeFPt
         pDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjAUNJN3Oj78l83ee42AKihXG4Dod/ZokWIkhLHuWQM=;
        b=FnvEmMHfax+VrPxeAuT87ZODHRegyyzU8IKoyynBfPmxa3zGfXOILk0caLmIuaVUHD
         bD6h4U9Hl6j8z4AHfyvF4pPYjYExUzdByQdZ9G4nlCNLOAERgwrRK86L2zPPZkSFPHQr
         Z97VbyWvvXJWVS9nH7a29HfclpOmBUwX/YlerTvECwPtNwrssZ9DCkMtZ0fB9TObhS+d
         4yjIM63Ujy4GmGTkuXz5lYI2oAXrw3uVMbzFRd120jPXnWjJ8QpFfWdpdZ75HuOm6c18
         ssLJchrv/AMoHZskrE0jr5bN1iCfuypmhHUcyWVHcQcBhzT0Ihs8rFKT/WDSFodMQiyW
         Fvzg==
X-Gm-Message-State: AOAM533RPiEp5UmgZ8ICYyosH8FQJ4QQYxZ2ueGy3XLtmGhXQq3m1mlP
        8GwpNSskc3w7bXHMrOlMOZk=
X-Google-Smtp-Source: ABdhPJwQkPqkvBpyj+uQmNdU/ghsyEnRCbyDHjwGYNl2nbaN6G5+ATD5gIyA6gMWiGl28PEGjc0VgA==
X-Received: by 2002:a17:906:3fc1:: with SMTP id k1mr7558425ejj.58.1611176474782;
        Wed, 20 Jan 2021 13:01:14 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cx6sm1768175edb.53.2021.01.20.13.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 13:01:13 -0800 (PST)
Date:   Wed, 20 Jan 2021 23:01:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 15/16] net: dsa: felix: setup MMIO filtering
 rules for PTP when using tag_8021q
Message-ID: <20210120210111.mqjdhwf6sq6qthui@skbuf>
References: <20210119230749.1178874-1-olteanv@gmail.com>
 <20210119230749.1178874-16-olteanv@gmail.com>
 <20210120084042.4d37dadb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210120173241.4jfqhsm725wqeqic@skbuf>
 <20210120125813.3e04e132@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120125813.3e04e132@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 12:58:13PM -0800, Jakub Kicinski wrote:
> > how bad is it to exceed the 15 patches per series limit? Do I need to
> > do something about it?
>
> It's not a hard rule IIUC, if you have 16, 17 patches as an atomic
> series which is hard to split, I'd think that's acceptable from time
> to time. Especially if the patches themselves are not huge.
> If you're already splitting a larger effort, keeping it < 15 is best.
> In general if you can split a smaller logically contained series out
> that's always preferred. The point is if the series is too large
> reviewers are likely to postpone reviewing it until they can allocate
> sufficiently large continuous block of time, which may be never.
> It's all about efficient code review.
>
> At least that's my recollection / understanding. There may be more
> reasons, we'd have to ask Dave.

To be fair this series is abusively large even for me to read, and _is_
easy to split. In v1 I had posted just the first half, but then figured
that reviewers might want to have the full picture of where I'm trying
to get at. But now that the picture has been given, I'm going back to
the split format. Thanks.
