Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4CF46D8DD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhLHQxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbhLHQxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:53:10 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0745C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 08:49:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so10211922edd.9
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 08:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yTtKz7qgpmyTBZxPy8RkUofqfaCY79MXklJwBcQAysU=;
        b=KyIHFoSAEwYaB/6ADRf7T90/f9CJP+rYuoJKDdG/cZ5VtKsHsKskhR246kCl+3m+f/
         Z2Q+AR7wxOUCiNKpGLA3d+Ixe8LxwovqmrxRAd3XjJUDGxtijGts/+snIIpOflBnRUR+
         TBXybg1thvIl+Vn1TrkCmaWHTs1or/Tw8lF9cQlBzBrzqufZq0YTP6BcL32N1puj7Rne
         N4zxlN2Zxj4n6/rADPtR8u0YAzajY10hzOCTHsHsaJhRNewUpvxq5Q6/gc4/Jd6q+szO
         qKjQI9CzxJwhmD4yJGoRDru/CgXE292svrfnSnvO4P9APNqy+qyrILk+VVYFJbm01gPI
         5FJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yTtKz7qgpmyTBZxPy8RkUofqfaCY79MXklJwBcQAysU=;
        b=jBBtgRi0+pv+J/o4nB6Ig0TDfrtfL08wvJYzozC7aAncAvqlOvkASrIAXduLnZ7sml
         2ePaVVaWiF2IxEoXKclUiMidwNHl7YmWH+g8rL85fSc7Lxmdv8ZeirfXUdNxFfnicJ4T
         vCbeKEGPNejADWRj7JOTdXPSm6rM/DV/SV92W8mOL7O3LpkzwfkWXfxryc/96ceWuDm+
         bY7t7xhhnfE8ZHMKUKn7zS/hCTgyfeMZu2amMFibAdE6tPpItlPby6Ogp4Mapfjd71yn
         ggFYW5eEFgJlw0FFDTwt8KBdN/v9UYDVFfC8ef7pCdHFEKSgCBU2nYzfynrZCgSt5nvt
         2MWQ==
X-Gm-Message-State: AOAM531wwwsbxwbHMuh7OiQhg4WrCR+HNTq7kIbBJ3aY2pTOGnKrVg9i
        QCSGabEoIjoFJ13+X5LK0Yrboy11/bs=
X-Google-Smtp-Source: ABdhPJyJ8qzCLLEtne334lGoqyLVM1iQ6ejhjEyaoECvO7Bhf2QT1y4EPZJwTyQRkIcCSyZj7EXIVg==
X-Received: by 2002:a05:6402:1e90:: with SMTP id f16mr20698205edf.91.1638982173960;
        Wed, 08 Dec 2021 08:49:33 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id e26sm2364081edr.82.2021.12.08.08.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:49:33 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:49:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208164932.6ojxt64j3v34477k@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
 <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
 <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
 <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208171720.6a297011@thinkpad>
 <20211208172104.75e32a6b@thinkpad>
 <20211208164131.fy2h652sgyvhm7jx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208164131.fy2h652sgyvhm7jx@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 06:41:31PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 05:21:04PM +0100, Marek Behún wrote:
> > Hello Vladimir,
> > > > > but the mv88e6xxx driver also drives switches that allow changing serdes
> > > > > modes. There does not need be dedicated TX amplitude register for each serdes
> > > > > mode, the point is that we may want to declare different amplitudes for
> > > > > different modes.
> > > > >
> > > > > So the question is: if we go with your binding proposal for the whole mv88e6xxx
> > > > > driver, and in the future someone will want to declare different amplitudes for
> > > > > different modes on another model, would he need to deprecate your binding or
> > > > > would it be easy to extend?
> > > > >
> > > >
> > > > ok I see. So if I follow your proposal in my case it would be something like:
> > > > serdes-sgmii-tx-amplitude-millivolt to start with ?
> > > >
> > > > I can do that. Andrew what do you think?
> > >
> > > Or maybe two properties:
> > >   serdes-tx-amplitude-millivolt = <700 1000 1100>;
> > >   serdes-tx-amplitude-modes = "sgmii", "2500base-x", "10gbase-r";
> > > ?
> > >
> > > If
> > >   serdes-tx-amplitude-modes
> > > is omitted, then
> > >   serdes-tx-amplitude-millivolt
> > > should only contain one value, and this is used for all serdes modes.
> > >
> > > This would be compatible with your change. You only need to define the
> > > bidning for now, your code can stay the same - you don't need to add
> > > support for multiple values or for the second property now, it can be
> > > done later when needed. But the binding should be defined to support
> > > those different modes.
> >
> > Vladimir, can you send your thoughts about this proposal? We are trying
> > to propose binding for defining serdes TX amplitude.
> 
> I don't have any specific concern here. It sounds reasonable for
> different data rates to require different transmitter configurations.
> Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplitude-modes"
> properties sounds okay, although I think a prefix with "-names" at the
> end is more canonical ("pinctrl-names", "clock-names", "reg-names" etc),
> so maybe "serdes-tx-amplitude-millivolt-names"?
> Maybe we could name the first element "default", and just the others
> would be named after a phy-mode. This way, if a specific TX amplitude is
> found in the device tree for the currently operating PHY mode, it can be
> used, otherwise the default (first) amplitude can be used.

Also, maybe drop the "serdes-" prefix? The property will sit under a
SERDES lane node, so it would be a bit redundant?
