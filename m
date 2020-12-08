Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D309F2D29B7
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 12:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgLHLYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 06:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729023AbgLHLYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 06:24:34 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AADCC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 03:23:54 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n26so24053146eju.6
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 03:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6lEazAPPBbbhXb9dlHy9Dkd0IMUaVYRZFZIEsUpcv4o=;
        b=XEWbLyRBMRpa88I21a44rymJI6oL5nVvKixoVoe+JiOo4RRPdPbozfYL28wg2vNvMc
         YNbx57hIHX0/HoTh+3EiOkgmtmdR8qd8R5M5cd3/OOHNSqdyFXnodNDREccnEUvLeIbV
         /TCyWTmdbzGd6HjX8VQ5hJ60aNnN8SFy9KfYdFluiLHi6GtijSOrRrPwhN++XSZNf35Y
         T6QZQbg5ws7oPofEH89bI6C4ozsQ42NJvXtezf0IorGrpu6JQDk5tmS2Md7kn/8KfENi
         SgbwVxyr/wcmo9+prOG8opysIoglNFwOEAI9KUIPtecjEGDaeDQ0CfKhPpib+HbDJnmo
         /oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6lEazAPPBbbhXb9dlHy9Dkd0IMUaVYRZFZIEsUpcv4o=;
        b=AzkQvw0Vq2rQz8o314UmYgBaRfYFl4p1hOiL16DPh6gt/FG/su9y+YLB3V/1eI5yOB
         RoGuRT3O/qnDOcY0voL53nDaB4gbTQ1dkmTzYLsJnWwu/hwLJbZn7H30wIyKAx46LEKr
         6MII+8fLTVFsBFBK4zffHx7UYMg5dJtVAZxvLdhBORkLckMH5F+fHRxkKhWc7Lmh4SDD
         ez5t2DXutN7xOAXe8AT0SqOzYVFcg0ntkm4W4HDrkRmq7OJCPxf8amz1EFG/+lpli4Ls
         Dcv2CeuQfmHbCEW5uHfvodkrPZQoWNwmkOC12x2gOUGg1lyX8cbUlNNlsAPA83k/eQhm
         49+w==
X-Gm-Message-State: AOAM531lPTWinIJJ81IBLkOkXCqsabQalGJCqGJjCGwv4YG3OnD4oqTA
        yS+MQmAH+u8yPfw+D0JWqkw=
X-Google-Smtp-Source: ABdhPJwShonyGqnA4bZ5Lo9+0E+/05TwA/6jA0WTFcyQFom1rPhsYp4dwf05/Hze+vwUpLVLyFDJmg==
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr22525313ejb.485.1607426632599;
        Tue, 08 Dec 2020 03:23:52 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id u9sm13069716edd.54.2020.12.08.03.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 03:23:51 -0800 (PST)
Date:   Tue, 8 Dec 2020 13:23:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201208112350.kuvlaxqto37igczk@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
>
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
>
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and
> from each associated port.
>
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>
> +struct dsa_lag {
> +	struct net_device *dev;
> +	int id;
> +
> +	struct list_head ports;
> +
> +	/* For multichip systems, we must ensure that each hash bucket
> +	 * is only enabled on a single egress port throughout the
> +	 * whole tree, lest we send duplicates. Therefore we must
> +	 * maintain a global list of active tx ports, so that each
> +	 * switch can figure out which buckets to enable on which
> +	 * ports.
> +	 */
> +	struct list_head tx_ports;
> +	int num_tx;
> +
> +	refcount_t refcount;
> +};

Sorry it took so long. I wanted to understand:
(a) where are the challenged for drivers to uniformly support software
    bridging when they already have code for bridge offloading. I found
    the following issues:
    - We have taggers that unconditionally set skb->offload_fwd_mark = 1,
      which kind of prevents software bridging. I'm not sure what the
      fix for these should be.
    - Source address is a big problem, but this time not in the sense
      that it traditionally has been. Specifically, due to address
      learning being enabled, the hardware FDB will set destinations to
      take the autonomous fast path. But surprise, the autonomous fast
      path is blocked, because as far as the switch is concerned, the
      ports are standalone and not offloading the bridge. We have drivers
      that don't disable address learning when they operate in standalone
      mode, which is something they definitely should do.
    There is nothing actionable for you in this patch set to resolve this.
    I just wanted to get an idea.
(b) Whether struct dsa_lag really brings us any significant benefit. I
    found that it doesn't. It's a lot of code added to the DSA core, that
    should not really belong in the middle layer. I need to go back and
    quote your motivation in the RFC:

| All LAG configuration is cached in `struct dsa_lag`s. I realize that
| the standard M.O. of DSA is to read back information from hardware
| when required. With LAGs this becomes very tricky though. For example,
| the change of a link state on one switch will require re-balancing of
| LAG hash buckets on another one, which in turn depends on the total
| number of active links in the LAG. Do you agree that this is
| motivated?

    After reimplementing bonding offload in ocelot, I have found
    struct dsa_lag to not provide any benefit. All the information a
    driver needs is already provided through the
    struct net_device *lag_dev argument given to lag_join and lag_leave,
    and through the struct netdev_lag_lower_state_info *info given to
    lag_change. I will send an RFC to you and the list shortly to prove
    that this information is absolutely sufficient for the driver to do
    decent internal bookkeeping, and that DSA should not really care
    beyond that.

    There are two points to be made:
    - Recently we have seen people with non-DSA (pure switchdev) hardware
      being compelled to write DSA drivers, because they noticed that a
      large part of the middle layer had already been written, and it
      presents an API with a lot of syntactic sugar. Maybe there is a
      larger issue here in that the switchdev offloading APIs are fairly
      bulky and repetitive, but that does not mean that we should be
      encouraging the attitude "come to DSA, we have cookies".
      https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/
    - Remember that the only reason why the DSA framework and the
      syntactic sugar exists is that we are presenting the hardware a
      unified view for the ports which have a struct net_device registered,
      and the ports which don't (DSA links and CPU ports). The argument
      really needs to be broken down into two:
      - For cross-chip DSA links, I can see why it was convenient for
        you to have the dsa_lag_by_dev(ds->dst, lag_dev) helper. But
        just as we currently have a struct net_device *bridge_dev in
        struct dsa_port, so we could have a struct net_device *bond,
        without the extra fat of struct dsa_lag, and reference counting,
        active ports, etc etc, would become simpler (actually inexistent
        as far as the DSA layer is concerned). Two ports are in the same
        bond if they have the same struct net_device *bond, just as they
        are bridged if they have the same struct net_device *bridge_dev.
      - For CPU ports, this raises an important question, which is
        whether LAG on switches with multiple CPU ports is ever going to
        be a thing. And if it is, how it is even going to be configured
        from the user's perspective. Because on a multi-CPU port system,
        you should actually see it as two bonding interfaces back to back.
        First, there's the bonding interface that spans the DSA masters.
        That needs no hardware offloading. Then there's the bonding
        interface that is the mirror image of that, and spans the CPU
        ports. I think this is a bit up in the air now. Because with
        your struct dsa_lag or without, we still have no bonding device
        associated with it, so things like the balancing policy are not
        really defined.

I would like you to reiterate some of the reasons why you prefer having
struct dsa_lag.
