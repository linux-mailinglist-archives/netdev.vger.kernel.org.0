Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295AD2B2FFC
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKNTJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKNTJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:09:12 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A40CC0613D1;
        Sat, 14 Nov 2020 11:09:12 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cq7so14555730edb.4;
        Sat, 14 Nov 2020 11:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JLdVN6GMW4s0rGfQ0nFt90uzelbVnIK4dvXuxZ/UCVo=;
        b=PsnG9ZF4pKG/q067PVFPFgRV4zYYE+9OGlh7Unwf8/Ze0/TYCd9Bxzw0XogLZG3aSD
         IwZGWBph8ltxVS8HYjammbB30r60oO/veumVCgb+8BFnVHe+bK88DHoQbhPt+5f6fn/U
         3395IIdrHKm6wEdkeIiyfBIn2Z3QPJ/V9I0vE735MreH3Z/k0r+lR6guacIP+rum74ui
         PqLDxSg0HSlJWb3kyF+ITOA2hQJTZT/fa+o5J+8DI26RMOOrJ+T4nxnlhoJaiRqRM65E
         G2ADkESjzQmzwNbofZR+9yV50B5/7XGGlc5E1fTkvudQ2tWCzD6B9Q6evX/wFjy+JjLz
         uDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLdVN6GMW4s0rGfQ0nFt90uzelbVnIK4dvXuxZ/UCVo=;
        b=G3ubtgmPOExvgyatJ5Ucn/h6RbYCkzaCYPWyp3zQeIklXyOgS8eja64goZ7+oNsiZL
         hufTKz3VD8Q0sGoJwkrqLyfWD15wHhfkmUURX/566+2WpbysFTJ5LboTx2tYMDH7gA6Z
         /mfz6ytm0YPH/hMrttB2OsUNH80w5EMR9roru0zaGM9a8OmOwI3fxGcNU3oLQds4v+Xt
         J4LHESX00im6YdvhvkRolby9CTocT1Wnvr3iJA9L1RmrTTayjQAO1CGnfY+/QnmwzvRw
         /e7sSuFaIMiQSSDhoj0VEHfEBPeiMNf3iuffuoO/H2yDne0LXjJhJFl30cBmzDINqZ2f
         OQFQ==
X-Gm-Message-State: AOAM531v/OAlU+s96WEOHeEn404PnO0E1oakVVMa4VbJcjwLSuu5gmeN
        ZIPBpHIYfWEB43mVlXTxGXk=
X-Google-Smtp-Source: ABdhPJz16mpu8mrBnCF4wgeqBuVm67aMKdWo7tP19Y5QpF8IFMwoYQFzEp/RM5sHyav43ENAeWkYGQ==
X-Received: by 2002:a05:6402:1542:: with SMTP id p2mr8372047edx.298.1605380950855;
        Sat, 14 Nov 2020 11:09:10 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id o20sm7264552eja.34.2020.11.14.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 11:09:10 -0800 (PST)
Date:   Sat, 14 Nov 2020 21:09:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH net-next 2/3] net: ethernet: ti: cpsw_new: enable
 broadcast/multicast rate limit support
Message-ID: <20201114190909.cc3rlnvom6wf2zkg@skbuf>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-3-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114035654.32658-3-grygorii.strashko@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 05:56:53AM +0200, Grygorii Strashko wrote:
> This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
> in TI CPSW switchdev driver (the corresponding ALE support was added in previous
> patch) by implementing HW offload for simple tc-flower policer with matches
> on dst_mac:
>  - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
>  - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting
> 
> Hence tc policer defines rate limit in terms of bits per second, but the
> ALE supports limiting in terms of packets per second - the rate limit
> bits/sec is converted to number of packets per second assuming minimum
> Ethernet packet size ETH_ZLEN=60 bytes.
> 
> Examples:
> - BC rate limit to 1000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
>   action police rate 480kbit burst 64k
> 
>   rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.
> 
> - MC rate limit to 20000pps:
>   tc qdisc add dev eth0 clsact
>   tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
>   action police rate 9600kbit burst 64k
> 
>   rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---

Your example for multicast would actually be correct if you specified
the mask as well. Like this:

tc filter add dev eth0 ingress flower skip_sw \
	dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
	action police rate 9600kbit burst 64k

But as things stand, the flow rule would have a certain meaning in
software (rate-limit only that particular multicast MAC address) and a
different meaning in hardware. Please modify the driver code to also
match on the mask.
