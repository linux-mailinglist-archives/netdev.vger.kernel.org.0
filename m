Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4945A317453
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhBJXZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhBJXYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:24:36 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A535CC061788;
        Wed, 10 Feb 2021 15:23:55 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id l25so7135579eja.9;
        Wed, 10 Feb 2021 15:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LVyB6aVFegjh/BB39Z/3gEanq6lvT/mhc2gjTlbR304=;
        b=Ltsi8EvdBtQvRjoANMJcwrISpAFLvmJ2C8VxRcxriJbvaZ1H9uMjsHWcx4k1KVwIp0
         bEprsSTU/icuARDSY1rU06I6BedOoXhuhcIgJh6jxcQt9ggsbMK3SyzdhcxnWfOWN9gT
         E5PYWDallpyZg5bnCqT7zgXoUxWsagtNa206F8EEFkBmsPO6KcpFz/zIWRjDEVcWBl3U
         m0CKh8UMubbkzKQ1GFQajoSPGu94+hVxEvlymy59SIYbcYLFwtM3w4Yu7fAPflkJsmfG
         LbzrxtfSEmjjRz3SHakXq/z1GCjoceNkpUvScCPt/IKE/L2FAZmjSB2HX9PO1F40u57g
         evTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LVyB6aVFegjh/BB39Z/3gEanq6lvT/mhc2gjTlbR304=;
        b=Z126DDr/XTEWjcbQNU9ITxxEKF1kwLKL7YEQxjurwXEM66rwGxa+qTIUPgoEc2XE+g
         G1QwW/FWJy766KiZ3rwk/YkYujEqAstzlnI4EjyEMB5fMx4lZv/guLzjEdMJ1MfML5Dc
         dSm/KB9J62pzn5PyqOMQda+n/gsTKEqmT5urYELElGE0poYeHwOL2gvChkUisQnLfu8r
         HAauXRqhh7o4aNmZPKcT1njNbZSH+DNeKyBTSLOTCx+8FCzun3QukdEiUMDoBo0UCEgy
         Hjo1eu349jAa2a09SVqh+ACBcPpb2G4B8/FwfllBmk93Mbq9b345HPMpIFJPoBnpb61F
         FHVw==
X-Gm-Message-State: AOAM533kGjb2pwTL8s2oMoHNK+xJH25Z6Tdw8opVERCUO+Anrv5TvjFw
        3JWQaAQmcuRHN7fWFhzZ+Ug=
X-Google-Smtp-Source: ABdhPJzF0KSQ9DdcnciBemPnpUA2B28QOBhea1HzTO3oC0toBtKbhjUBAWV9/atUFBeQfPDx+7VJVA==
X-Received: by 2002:a17:906:8519:: with SMTP id i25mr5508356ejx.106.1612999434425;
        Wed, 10 Feb 2021 15:23:54 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id w18sm2263806edt.8.2021.02.10.15.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 15:23:53 -0800 (PST)
Date:   Thu, 11 Feb 2021 01:23:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210210232352.m7nqzvs2g4i74rx4@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
 <20210209202045.obayorcud4fg2qqb@skbuf>
 <20210209220124.GA271860@shredder.lan>
 <20210209225153.j7u6zwnpdgskvr2v@skbuf>
 <20210210105949.GB287766@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210105949.GB287766@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:59:49PM +0200, Ido Schimmel wrote:
> > > The reverse, during unlinking, would be to refuse unlinking if the upper
> > > has uppers of its own. netdev_upper_dev_unlink() needs to learn to
> > > return an error and callers such as team/bond need to learn to handle
> > > it, but it seems patchable.
> >
> > Again, this was treated prior to my deletion in this series and not by
> > erroring out, I just really didn't think it through.
> >
> > So you're saying that if we impose that all switchdev drivers restrict
> > the house of cards to be constructed from the bottom up, and destructed
> > from the top down, then the notification of bridge port flags can stay
> > in the bridge layer?
>
> I actually don't think it's a good idea to have this in the bridge in
> any case. I understand that it makes sense for some devices where
> learning, flooding, etc are port attributes, but in other devices these
> can be {port,vlan} attributes and then you need to take care of them
> when a vlan is added / deleted and not only when a port is removed from
> the bridge. So for such devices this really won't save anything. I would
> thus leave it to the lower levels to decide.

Just for my understanding, how are per-{port,vlan} attributes such as
learning and flooding managed by the Linux bridge? How can I disable
flooding only in a certain VLAN?
