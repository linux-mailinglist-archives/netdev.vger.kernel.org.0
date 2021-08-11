Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC13E9AA8
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhHKV7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhHKV7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:59:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2479C06179F;
        Wed, 11 Aug 2021 14:58:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id k9so6042560edr.10;
        Wed, 11 Aug 2021 14:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oqaYnk/BlOEVZwhZgFl0HlIbiKCRb2HikYJeEVtrpsU=;
        b=G+Jh5JTKtzuPm2ZSNCT48dtg4MkLnPfZn61RKWMryCZuvjJW59wBUJ7GoGVCLpoKju
         drUH7LhE231uHGCesRgD2PLlS1gMSdfavrCZhX5eUKhHQWxu3Kxxfz90aPnv3lz9dp9r
         0tCCpblpht9JAhlaYMfSmiHhrMobuaRPeixBB2PfBrRvxmMeSVa6Qgm/kGnfTGmh9bWF
         M+fq0UxCkAvdn9Uqm0+/NadxcUFbbrHOutGOze2Zd988K+4FXHfQ9omxX0Po2d2AzAr3
         LYWCtAocFksvCF9LYUSQmBjqGOLHk3Ylv1JAKDVWeUSOqFFbGHgUDrjiHOmHEVpytaBh
         U8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oqaYnk/BlOEVZwhZgFl0HlIbiKCRb2HikYJeEVtrpsU=;
        b=glPFbOQ4lA0O76R6Qmk6/jpuNfS4i6BDg6oWwKnMiUdzZwUF3rXtt+eCVmkqRFrX0R
         WGtI5iVMrqL8WBtCuisa8nqGTcC79C2hGOEBGPEeAiZBtiWOHxPmPRDntpjMr9rCWagI
         3q31mIJgnEwG+g8wk0YpEAOQmfuQwOTwj8fy+c9zlblKwcZBvJKrYHDD3KSRmocFwTGu
         NrZhIA/p7TCTLXJ8apZwNdhYrwpc9ehOo5pRkQKltvcWC3IPpc5qcXh/CqxH2ZOnC8an
         ylxw6nb6CIChS5Di34r+FI/sXHpH96so0Ci1X98y+cwkkGzS8Ns59V5DwDXccwqd5omw
         SGTQ==
X-Gm-Message-State: AOAM531fI+mqZa3O7YoU0egtmLe87t2Da8S3XGi3LJ8FesFRC5i4Ufe8
        8e4TQg48BD3ZjWCsEWAUSI8=
X-Google-Smtp-Source: ABdhPJyJAi9thw66oG77nCI4SgRcCEoibHonBPxvlBWiZP5LiB8Y9I9MFyXs+oXnyS18h2Jiv93SZQ==
X-Received: by 2002:a05:6402:30b6:: with SMTP id df22mr1273432edb.375.1628719115308;
        Wed, 11 Aug 2021 14:58:35 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n26sm217363eds.63.2021.08.11.14.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 14:58:34 -0700 (PDT)
Date:   Thu, 12 Aug 2021 00:58:33 +0300
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
Message-ID: <20210811215833.yst5tzgfvih2q4y2@skbuf>
References: <20210811135247.1703496-1-dqfext@gmail.com>
 <YRRDcGWaWHgBkNhQ@shredder>
 <20210811214506.4pf5t3wgabs5blqj@skbuf>
 <YRRGsL60WeDGQOnv@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRRGsL60WeDGQOnv@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 12:52:48AM +0300, Ido Schimmel wrote:
> On Thu, Aug 12, 2021 at 12:45:06AM +0300, Vladimir Oltean wrote:
> > On Thu, Aug 12, 2021 at 12:38:56AM +0300, Ido Schimmel wrote:
> > > On Wed, Aug 11, 2021 at 09:52:46PM +0800, DENG Qingfang wrote:
> > > > Add BR_ISOLATED flag to BR_PORT_FLAGS_HW_OFFLOAD, to allow switchdev
> > > > drivers to offload port isolation.
> > > >
> > > > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > > > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > > > ---
> > > >  net/bridge/br_switchdev.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> > > > index 6bf518d78f02..898257153883 100644
> > > > --- a/net/bridge/br_switchdev.c
> > > > +++ b/net/bridge/br_switchdev.c
> > > > @@ -71,7 +71,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
> > > >
> > > >  /* Flags that can be offloaded to hardware */
> > > >  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> > > > -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> > > > +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> > > > +				  BR_ISOLATED)
> > >
> > > Why add it now and not as part of a patchset that actually makes use of
> > > the flag in a driver that offloads port isolation?
> > 
> > The way the information got transmitted is a bit unfortunate.
> > 
> > Making BR_ISOLATED part of BR_PORT_FLAGS_HW_OFFLOAD is a matter of
> > correctness when switchdev offloads the data path. Since this feature
> > will not work correctly without driver intervention, it makes sense that
> > drivers should reject it currently, which is exactly what this patch
> > accomplishes - it makes the code path go through the
> > SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
> > -EINVAL for everything they don't recognize.
> 
> If the purpose is correctness, then this is not the only flag that was
> missed. BR_HAIRPIN_MODE is also relevant for the data path, for example.

I never wanted to suggest that I'm giving a comprehensive answer, I just
answered Qingfang's punctual question here:
https://lore.kernel.org/netdev/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/

Tobias also pointed out the same issue about BR_MULTICAST_TO_UNICAST in
conjunction with tx_fwd_offload (although the same is probably true even
without it):
https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/

> Anyway, the commit message needs to be reworded to reflect the true
> purpose of the patch.

Agree, and potentially extended with all the bridge port flags which are
broken without switchdev driver intervention.
