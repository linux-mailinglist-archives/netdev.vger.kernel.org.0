Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0209745504F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbhKQWXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbhKQWXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:23:03 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8065C061570;
        Wed, 17 Nov 2021 14:20:03 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z5so17767535edd.3;
        Wed, 17 Nov 2021 14:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=F4QdOr9bJ3YUb5WTpB8Vwlmm3Z7xVDJFxij0GVR1z1M=;
        b=jT8esgGLHrFpOPuo93+nKpOnY87kqUQmpH+WjUUMdyeocaVFe3YDyW/W+FflCXugGG
         yLBd2EOFT4qcFKkqcgYcIaoTR7FkwDeBmKCrbP9elR+ZVkvnPQsFnXmAJM+88RPzV8g3
         nmr7H8k8G5eilQD7QnSRdaViBwHtBf/8KmdNYDgy1p7Bz/qV7cFckrWcZqsGQ3tKtPl9
         9roBx2KH2c2AfmbDi/t0+Xr2yrubZCFKV0EVWCi6v0Ikdaputi0NPd0wlMXg/nYG6zbJ
         cYZ1DPEOE0/I7wp0eIRyCoz5+AWZiUetvGgEdYx0cSVo9PdlTSJijSHyswaETN3jhiL4
         V0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=F4QdOr9bJ3YUb5WTpB8Vwlmm3Z7xVDJFxij0GVR1z1M=;
        b=TkTiDKpNX/bTiv0fpOsd6sKWzA47WOrZXo/LiIW01YOOt205e1ONMUE4ArLWaWq6MR
         cJKm2brRrFVw9fGg5bGvZlyW2luHTgCApSvRICzo2YjXUZgG46XmsyQaJtFlBLtdgpKi
         g0GI8HDQnVFf0pyrfPQX/iz+zDfXkVqs9rlDIWcDGf+NugW0Tcc83PKpyJvlb2iGpEkb
         sYy2U1nxWwuK7d1zAq/jgsT9AFtdjx4pt7Xts/e4qO+nmwNXi85oJo7Ostd/nvNQV6Fn
         XRJGEYcbs7uFvhxQitGCZU68zgmCjrhr7mZVFBHorZ2wcNpBND6e5uIlvccMTpBAqcwA
         XLkg==
X-Gm-Message-State: AOAM533/qbmV7XcJinZ4zpnRpG5pT7F/oHqFfHO6GZWPem291P9qSxjE
        iv59VTrkU6KR3Dam8vaJuUM=
X-Google-Smtp-Source: ABdhPJyL15Yc/wO/2IvYZlErTW4szvjPzGyHKT8vBbRfzgNo1RQ4CRR3+PJ+T34n7LeaQPzQFh0FLA==
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr26846073ejc.493.1637187602267;
        Wed, 17 Nov 2021 14:20:02 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id z7sm586067edj.51.2021.11.17.14.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 14:20:01 -0800 (PST)
Message-ID: <61958011.1c69fb81.31272.2dd5@mx.google.com>
X-Google-Original-Message-ID: <YZV/++cUA2rfKKyj@Ansuel-xps.>
Date:   Wed, 17 Nov 2021 23:19:39 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: regmap: allow to define reg_update_bits for no bus configuration
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-2-ansuelsmth@gmail.com>
 <YZV/GYJXKTE4RaEj@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZV/GYJXKTE4RaEj@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:15:53PM +0000, Mark Brown wrote:
> On Wed, Nov 17, 2021 at 10:04:33PM +0100, Ansuel Smith wrote:
> > Some device requires a special handling for reg_update_bits and can't use
> > the normal regmap read write logic. An example is when locking is
> > handled by the device and rmw operations requires to do atomic operations.
> > Allow to declare a dedicated function in regmap_config for
> > reg_update_bits in no bus configuration.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Link: https://lore.kernel.org/r/20211104150040.1260-1-ansuelsmth@gmail.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > ---
> >  drivers/base/regmap/regmap.c | 1 +
> >  include/linux/regmap.h       | 7 +++++++
> >  2 files changed, 8 insertions(+)
> 
> I've applied this already?  If it's needed by something in another tree
> let me know and I'll make a signed tag for it.

Yes, I posted this in this series as net-next still doesn't have this
commit. Don't really know how to hanle this kind of corner
case. Do you have some hint about that and how to proceed?

-- 
	Ansuel
