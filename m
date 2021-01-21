Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376802FE0E1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbhAUEjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbhAUEFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:05:52 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74503C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:04:55 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 15so522612pgx.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z4961jt1yqYw+6AjM3/ZcftAy8KN1wVKDXeUsQv84XQ=;
        b=hLW9aUbDZEMnDt3hhOer9sdZ5cKF/ujjVMVDEOFGYSmLhjsDRdIwRF6SEatQhag+lQ
         T/w8Dki/GX0+Yo8sE7cSTBC4ak7lo+pt3SAKo5Ts0Px3Dqst1gaqt7FAKsEfN0UPYPED
         0sb82DYS1tSnMK+QHDXTa4NAw6eoWimoTsSIse9EL26rSIkj9pPk6ktksFKkQ2GyeuR6
         orzO6Vi1mz66spsl0ZfpQZE/ePMi9N99kPXFFwgSQpDgGgKLeoxi8gMHjCEb1MtauZ5w
         IQg5iLg4EVIFpXuHLm4fc3DekKUrduXJPRxOFFjFjMT5ERuf5x2NGuysw4l/vNi6EDDg
         sikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z4961jt1yqYw+6AjM3/ZcftAy8KN1wVKDXeUsQv84XQ=;
        b=kBBRqz8y0KAiGAfzHMMwMNODdr9o3ByoIuFOnHTcR63S9I4HbMVIYsFK1OZEVYIDjF
         LF975pGbF15YzSLqRRJsPyTjbSIb/6vVLBrcFzsNQ8py9ktRoj2oyYCS10VZC32D+JjD
         PBWVPhfcjhEvvbccx3HWo8SpG9s805YERvpHvYso0cH3pOOlfakkC3zrQ7XMhZ1g8BG5
         33F0vi2vO7I15SJl/UHlia3v0X3L4HHQllFrDkXR4F/oaNsm+RERJjrzz+rUq5Z8rg9d
         7Y4oKMlLPYkjs9icblFv6ZrSk9UxBExHTfRf1IHFo9vHK4CTwH/BX0pCYH3M9ZzJoPJ8
         Mtow==
X-Gm-Message-State: AOAM533r+ZZ16ovXzMJWdKZT6qOLc2orLAj3d7hy9TVS9JfwvJbIT0ts
        GCqGg8320yn4EPJaBoo1zCY=
X-Google-Smtp-Source: ABdhPJz8FZmBmeWwQjzgEE9fIQXCaZkLesnOHFCYwp5jy8a8K1V+bC1sLZEjfLd4j9qWGeoYCoIN2g==
X-Received: by 2002:a62:c301:0:b029:1b6:74fb:696e with SMTP id v1-20020a62c3010000b02901b674fb696emr12242531pfg.59.1611201894990;
        Wed, 20 Jan 2021 20:04:54 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x19sm3851924pfp.207.2021.01.20.20.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:04:54 -0800 (PST)
Date:   Wed, 20 Jan 2021 20:04:51 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121040451.GB14465@hoboy.vegasvil.org>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114223800.GR1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 10:38:00PM +0000, Russell King - ARM Linux admin wrote:

> So, I think the only way to prevent a regression with the code as
> it is today is that we _never_ support PTP on Marvell PHYs - because
> doing so _will_ break the existing MVPP2 driver's implementation and
> cause a regression.

The situation isn't as bad as it seems.

For one thing, mvpp2 incorrectly selects NETWORK_PHY_TIMESTAMPING.
It really shouldn't.  I'm submitting a fix soon.

As long as the new PHY driver (or at least the PTP bit) depends on
NETWORK_PHY_TIMESTAMPING, then that allows users who _really_ want
that to enable the option at compile time.  This option adds extra
checks into the networking hot path, and almost everyone should avoid
enabling it.

> Right now, there is no option: if a PHY supports PTP, then the only
> option is to use the PHYs PTP. Which is utterly rediculous.
> 
> Unless you can see a way around it. Because I can't.

I still think the original and best method is to hide the two (and
with your new driver, three) esoteric PHY time stamping drivers behind
a Kconfig option, and structure the code to favor PHY devices.

The idea to favor the MACs, from back in July, doesn't really change
the fundamental limitations that

- MAC and PHY time stamping cannot work simultaneously, and

- Users of PHY devices (representing a tiny minority) must enable the
  otherwise uninteresting NETWORK_PHY_TIMESTAMPING option at compile
  time.

Thanks,
Richard
