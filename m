Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA883E9A82
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhHKVps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhHKVpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:45:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982BEC0613D3;
        Wed, 11 Aug 2021 14:45:09 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id o23so7150372ejc.3;
        Wed, 11 Aug 2021 14:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+XK7Qk5Y2p36ge4CexpmpUnKhHpaYlCSYaz/IyqAE4=;
        b=tJ7O2fOIjUrVETc7EGgmzQBQ3UFDdaE98MZN1nJj+IqEJ/rF1UpBvXAA8ZgqcXtBrs
         KYvWXKXoA7GZaS7XjPu/leRt1RjiFsJj7pc9QbDX/ZZp0FNSjPihO4mmhmdhGyL3pWT4
         mIAZdYLcjLhdSW4bXZexgkff/bJPt4Co/X3gtNF9Tv/vRScIL16SGCrKOrWwdK7FxEWw
         Wiym9YDBI0Z5yExE16J1HtdCdtPa5VQH73b7gXDb3lCZScqwvMEpkKDH9JHHmowKtuyB
         RCmjmCBl4Fi59fg/2opwQfK+BzvcKcLdnijLKr6GbRGyUcmhORpODelGCgOucwJtjf0O
         crSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L+XK7Qk5Y2p36ge4CexpmpUnKhHpaYlCSYaz/IyqAE4=;
        b=DQpFKCKUdOpau8ChyUWlIKkstNHRzUlcIJEyGPI/wN1Bt6Cy6OnkwHUhnLRdiFeWdR
         NChX9zOz3w9qnHZD7/dwabQwSV1bYd6CJbp7qf0jYDRXgTK9fh7J1/9uo+YC++H7gZ3I
         +JbdBmZy7HyWox8cbMGW02au+gQAYCPZ/Jk/nFNUPse2ggjBy1Qd8uGAzQvIymrnzD45
         L9zZTX6xM6N+TN5zg3ZUtsZqR6IgOEPtGxs6kNCG26GqszdSF7463orpg3LTwlELmGn1
         W743oMK6YnWpKTgYFJJOEHZNCi0jHo1bxVXZJndSPcBXVoHeIT0VWpKcUqVk/1c79/c0
         Jh9w==
X-Gm-Message-State: AOAM530bps5lI7lHm3LPVTZagtj2BpgfU1oKFNt9b4yO9HmQzlmF8qlR
        2C/QqLgX/qHvcs4Zs7JyCCQ=
X-Google-Smtp-Source: ABdhPJyIOZeUAPVImHmwi51LzCcsOr775P136j/+YdkRJ87uc6R54jEJogGJYnRoadECvY5hsR1LxQ==
X-Received: by 2002:a17:906:d183:: with SMTP id c3mr547453ejz.283.1628718308227;
        Wed, 11 Aug 2021 14:45:08 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e22sm210965eds.45.2021.08.11.14.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 14:45:07 -0700 (PDT)
Date:   Thu, 12 Aug 2021 00:45:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: bridge: switchdev: allow port isolation to
 be offloaded
Message-ID: <20210811214506.4pf5t3wgabs5blqj@skbuf>
References: <20210811135247.1703496-1-dqfext@gmail.com>
 <YRRDcGWaWHgBkNhQ@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRRDcGWaWHgBkNhQ@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 12:38:56AM +0300, Ido Schimmel wrote:
> On Wed, Aug 11, 2021 at 09:52:46PM +0800, DENG Qingfang wrote:
> > Add BR_ISOLATED flag to BR_PORT_FLAGS_HW_OFFLOAD, to allow switchdev
> > drivers to offload port isolation.
> >
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> >  net/bridge/br_switchdev.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > index 6bf518d78f02..898257153883 100644
> > --- a/net/bridge/br_switchdev.c
> > +++ b/net/bridge/br_switchdev.c
> > @@ -71,7 +71,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> >
> >  /* Flags that can be offloaded to hardware */
> >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> > -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> > +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> > +				  BR_ISOLATED)
>
> Why add it now and not as part of a patchset that actually makes use of
> the flag in a driver that offloads port isolation?

The way the information got transmitted is a bit unfortunate.

Making BR_ISOLATED part of BR_PORT_FLAGS_HW_OFFLOAD is a matter of
correctness when switchdev offloads the data path. Since this feature
will not work correctly without driver intervention, it makes sense that
drivers should reject it currently, which is exactly what this patch
accomplishes - it makes the code path go through the
SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
-EINVAL for everything they don't recognize.

(yes, we do still have a problem for drivers that don't catch
SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS at all, switchdev will return
-EOPNOTSUPP for those which is then ignored, but those are in the
minority)
