Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB58941685F
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 01:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243564AbhIWXNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 19:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243552AbhIWXNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 19:13:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3429BC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 16:11:48 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eg28so29161656edb.1
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 16:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yK1HGETLvFQIxvcvCJWGGSBzuzv5ZjQLTKRZZBdXmcc=;
        b=pVzyFH5esjGzqUbEegFH6xhhbQsuwC1bdCVEDRPsfx7hHAxGV+zVyUIxNeqKn7UKSz
         KkxOBgfSzX2nwGIWpHQtqitMlDPJHNfXxiNXP2olFtalC6jFENfnEpBB800ssFcnEuQH
         ldMc3eh5i5EANwKpei72vHv+WD20kvcHWQmPFZ4GAovZl/P4t2kVp9ujgb9mqWtW91o/
         bbElQno7A/iuVGjgKQn92qPuoGtKAA0o+5CjmXk5sN/J0RabVWYm7U+LWR1PHafN9zZD
         6qfv1VtbQJQGSwSOWoUzD9fn7wewsQiMB/mroPlKsHggUgbHHeUj5lgFO5olK6PNpeZZ
         tSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yK1HGETLvFQIxvcvCJWGGSBzuzv5ZjQLTKRZZBdXmcc=;
        b=wHykSGarDifp4GMnPzV8I3cY4I/FhH4YFg0odx75oPIZS8/N+dUcNElG3yoxlV0F/V
         J8hzaii5RQud9GU2/xbSLgk0LQLkzXsT4VgvINCv+YKnLTHdTiuSlkunCNXCh/y10Yco
         JwCICP2lrECMQ53hTLT8itkot4tFA2p82mVtSzpT0JJZ4LrE2hKhd3hbDjBPC+qL1VLy
         BaxJm9l6zCHS288byo0LcwKJz0MwTjdDzbwbKQCtMVsmclHPQGR+X8+K42VFBzIq4z/b
         32iBCxcFHCNGpVWdT+o8UkRNUciQKdrPXZfxJED02DwFQIQXsWWy4d4RU2PWL6cnFrO6
         cp0g==
X-Gm-Message-State: AOAM530awnQXy+3mS6q3mvcwhpyVKalxGxBHMzy67qcvtW7SfiyACn6C
        VGW72OqOS/recghtv8DHylM=
X-Google-Smtp-Source: ABdhPJzJ24oXXzSFxDiA9Tt3LQqSGe6f33PfwdiLcGNwPV80I4I7cyizA56hCOqeHLZhFoRRxIWb1A==
X-Received: by 2002:aa7:d814:: with SMTP id v20mr1686814edq.169.1632438706805;
        Thu, 23 Sep 2021 16:11:46 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id j2sm4476568edt.0.2021.09.23.16.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 16:11:46 -0700 (PDT)
Date:   Fri, 24 Sep 2021 02:11:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: tag_rtl4_a: Drop bit 9 from egress
 frames
Message-ID: <20210923231145.pmbr6py32owurmic@skbuf>
References: <20210913143156.1264570-1-linus.walleij@linaro.org>
 <20210915071901.1315-1-dqfext@gmail.com>
 <CACRpkdYu7Q5Y88YmBzcBBGycmW92dd0jVhJNUpDFyd65bBq52A@mail.gmail.com>
 <20210923221200.xygcmxujwqtxajqd@skbuf>
 <CACRpkdZJzHqmdfvR5kRgw1mWPQ68=-ky1xJ+VWX8v6hD_6bx6A@mail.gmail.com>
 <20210923222549.byri6ch2kcvowtv4@skbuf>
 <CACRpkdYGy+tKUGudFLKL_U6DYpdJLnDxz1gh2gH=drOw9YdB6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYGy+tKUGudFLKL_U6DYpdJLnDxz1gh2gH=drOw9YdB6w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 12:58:00AM +0200, Linus Walleij wrote:
> On Fri, Sep 24, 2021 at 12:25 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Fri, Sep 24, 2021 at 12:21:39AM +0200, Linus Walleij wrote:
> > > > > Do we have some use for that feature in DSA taggers?
> > > >
> > > > Yes.
> > >
> > > OK I'll add it to my TODO, right now trying to fix up the base
> > > of the RTL8366RB patch set to handle VLANs the right way.
> >
> > But you didn't ask what that use is...
> 
> Allright spill the beans :D I might not be the most clever at times...

So the essence of the answer is in the discussion we've already had on
your v1 attempt to disable this "unknown" bit:
https://patchwork.kernel.org/project/netdevbpf/patch/20210828235619.249757-1-linus.walleij@linaro.org/

The idea is that bridges should learn only from data plane packets, and
the only chance a DSA tagger has to distinguish between a data and a
control packet sent by the network stack is to look at
skb->offload_fwd_mark, which will be set on xmit by the bridge driver,
if you implement the .port_bridge_tx_fwd_offload and .port_bridge_tx_fwd_unoffload
methods, and declare a non-zero ds->max_num_bridges value (note: the API
for bridge TX forwarding offload in DSA is subject to change/get
simplified during this development cycle). And to offload the replication
for data packets correctly, you should really re-read the discussion we
had about what happens when the egress port mask set by the tagger is all-zeroes.

Not to blow my own horn or anything, but I've repeated this stuff for so many
times now that I wrote it down for future reference, you can find the basic
concepts detailed in chapter "The data plane and the control plane" from the
paper attached here (there are also pictures, not sure how much they help):
https://linuxplumbersconf.org/event/11/contributions/949/
