Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C004350DC
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJTRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJTRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:05:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6EEC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:03:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id om14so2904097pjb.5
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 10:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uJCxU4kwRxM1pAsgJ4u9Ijs/Sad14IXM5teQZ4nxEb0=;
        b=dKTjeQneobhM/Px1mWtjeAmAuXvEHWwa1aE8t1O825WsnvdR1LiUVJr4zRkVMWuUNC
         jPo02y7tKMzzOClKcyoeR/iBOeOKuX+W/VIAmznCq/cQW7YQ/dG87bXZHYXBHWW3GkFK
         NcNzdo9QqyeleeLsgeLZGjoI/Iq+8+vUcDAWoLWYKbgUgpNHuoYcUo+fBuixCes4XONI
         v3wWreW+79VyKWVXbvFzb2jL08hW/VPI/XggZdA6fSWueoyYapmSx/mrIW/gLWJGKEfv
         2sAefgI4T12axwFHbRAjNtFBGbFG0OUR3Rwd9omjnPeX8RQBiEGu9wS087dz+2/jmu0s
         WqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uJCxU4kwRxM1pAsgJ4u9Ijs/Sad14IXM5teQZ4nxEb0=;
        b=VwDvaboR7/8VvGL021EV5QDEGoKEZCLygRElmT3xoRpzeJfyvpMGymQuIPzPNLOOno
         wZTy+whs3I23GwVh2FVSwuS0M0sEeZSsz2mSx/BEsmnywxy+6y+nSNZDKKmyE+oA2wtr
         cUrTynsW5nB71PWai0DVLRyvOkifNzTEES2GVbc5MGDEnfSRShZi1zT50w6mAXhHmxYI
         SJvn+N8yF6jqY+HwVlR+PSEf/aK+T3AC8ofqeYv2jQqwJ1LypFLsTrZ86rVxXnkzpxtS
         q9hMwZ9N41CHM5QiqOjPGfpItYh4pzWlxulvAHLO5yu6ZlZhiJhOzyNjnjt0/QPFMEU6
         l5Lg==
X-Gm-Message-State: AOAM530Wtv7GGUyZuLIMRL9a6BCU5x8ORS31GWsCDDaJvlkMFwf4Wp8A
        /hB4+IVW+A7UqgyFjBLRD5VlqVdy37+5hw==
X-Google-Smtp-Source: ABdhPJz2abtV+SLSC+tBoQqFvkjG1dKNpxf6w0FXnTSQ0kysdUbiMBrGT/O0h1cBy3U8lbszYAIFpQ==
X-Received: by 2002:a17:90b:1c09:: with SMTP id oc9mr190412pjb.33.1634749402395;
        Wed, 20 Oct 2021 10:03:22 -0700 (PDT)
Received: from [192.168.254.55] ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id d19sm3286673pfl.129.2021.10.20.10.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 10:03:21 -0700 (PDT)
Message-ID: <3955b3c158099ae01a76cee8f3e8f099956f27e3.camel@gmail.com>
Subject: Re: [PATCH v4] net: neighbour: introduce EVICT_NOCARRIER table
 option
From:   James Prestwood <prestwoj@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Date:   Wed, 20 Oct 2021 09:59:59 -0700
In-Reply-To: <0fa3610f-50e4-139e-f914-da2728ab5b6c@gmail.com>
References: <20211018192657.481274-1-prestwoj@gmail.com>
         <0fa3610f-50e4-139e-f914-da2728ab5b6c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, 2021-10-19 at 20:15 -0600, David Ahern wrote:
> On 10/18/21 1:26 PM, James Prestwood wrote:
> > diff --git a/Documentation/networking/ip-sysctl.rst
> > b/Documentation/networking/ip-sysctl.rst
> > index 16b8bf72feaf..e2aced01905a 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -200,6 +200,15 @@ neigh/default/unres_qlen - INTEGER
> >  
> >         Default: 101
> >  
> > +neigh/default/evict_nocarrier - BOOLEAN
> > +       Clears the neighbor cache on NOCARRIER events. This option
> > is important
> > +       for wireless devices where the cache should not be cleared
> > when roaming
> > +       between access points on the same network. In most cases
> > this should
> > +       remain as the default (1).
> > +
> > +       - 1 - (default): Clear the neighbor cache on NOCARRIER
> > events
> > +       - 0 - Do not clear neighbor cache on NOCARRIER events
> > +
> >  mtu_expires - INTEGER
> >         Time, in seconds, that cached PMTU information is kept.
> >  
> > diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> > index e8e48be66755..71b28f83c3d3 100644
> > --- a/include/net/neighbour.h
> > +++ b/include/net/neighbour.h
> > @@ -54,7 +54,8 @@ enum {
> >         NEIGH_VAR_ANYCAST_DELAY,
> >         NEIGH_VAR_PROXY_DELAY,
> >         NEIGH_VAR_LOCKTIME,
> > -#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_LOCKTIME + 1)
> > +       NEIGH_VAR_EVICT_NOCARRIER,
> > +#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_EVICT_NOCARRIER + 1)
> >         /* Following are used as a second way to access one of the
> > above */
> >         NEIGH_VAR_QUEUE_LEN, /* same data as
> > NEIGH_VAR_QUEUE_LEN_BYTES */
> >         NEIGH_VAR_RETRANS_TIME_MS, /* same data as
> > NEIGH_VAR_RETRANS_TIME */
> > diff --git a/include/uapi/linux/neighbour.h
> > b/include/uapi/linux/neighbour.h
> > index db05fb55055e..1dc125dd4f50 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -152,6 +152,7 @@ enum {
> >         NDTPA_QUEUE_LENBYTES,           /* u32 */
> >         NDTPA_MCAST_REPROBES,           /* u32 */
> >         NDTPA_PAD,
> > +       NDTPA_EVICT_NOCARRIER,          /* u8 */
> 
> you are proposing a sysctl not a neighbor table attribute. ie., you
> don't need this.

Can't there be both, as there are with several of the other attributes?
I very well could have done it wrong, but my intent was to make this
settable via sysctl and RTNL.

But going the per netdev route as you describe below, yes this won't be
needed.

> 
> 
> >         __NDTPA_MAX
> >  };
> >  #define NDTPA_MAX (__NDTPA_MAX - 1)
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 47931c8be04b..953253f3e491 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -318,7 +318,7 @@ static void pneigh_queue_purge(struct
> > sk_buff_head *list)
> >  }
> >  
> >  static void neigh_flush_dev(struct neigh_table *tbl, struct
> > net_device *dev,
> > -                           bool skip_perm)
> > +                           bool nocarrier)
> 
> why are you dropping the skip_perm arg? These are orthogonal skip
> options.

I felt it was more appropriate to describe the reason/event (no
carrier) that triggered the flush after adding this option. Rather than
using something called 'skip_perm' to skip non-perminant entries.

> 
> 
> your change seems all over the board here.

If it wasn't obvious this subsystem is totally new to me :)

> 
> You should be adding a per netdevice sysctl to allow this setting to
> be
> controlled per device, not a global setting or a table setting.
> 
> In neigh_carrier_down, check the sysctl for this device (and check
> 'all'
> device too) and if eviction on carrier down is not wanted, then skip
> the
> call to __neigh_ifdown.

Sure, this seems like a good path forward. I was not a fan of needing
to go into the neighbor iteration loop since we want to skip everything
for a given netdev anyways.

Thanks for the feedback

- James



