Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6C53257E0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 21:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBYUnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhBYUnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 15:43:11 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC99C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:42:31 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m22so10601541lfg.5
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=8EfSBvcdR4EKTANNEKf2f7e+g7KtghTP6m2GTdMy9HY=;
        b=oAYg3fDk2ND6k80iLie4Y13MeKmE6FldD7EvMNZfochqRHTl9y2Bfh/lkoqhD0sRlO
         1GnYSEwWJGGyU66h4y0gdLQcp/UI0tjL15epilFbWyslxloWoG0nBVZvrojZng70YRYF
         MXZW6wL0cJv5KkEjFtzEevwn5DGEMuAWJMsl5zmgdocB9pFNyQog50dUpgqtdt2m+O36
         mDPPHYhh0wtaRXnWWXX35zi3NC/oOusnXOeMcYGeULSjuwFeilokPfFocNjGY5d6qU2Q
         +mRMdDohiPoGySkAxIl3AuSxquc4lhTvM9Omh9qv4bq/a8c1MLkniLahQdaI/TLbeVpZ
         Fy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8EfSBvcdR4EKTANNEKf2f7e+g7KtghTP6m2GTdMy9HY=;
        b=jGHAO40cwxA/YZrhZdtAVsCdhmfLOtwS97ltOqvu/Wt7N4kAr98uehyiVD+nUBw8t3
         hLYUpRCvuiged3LHq9ybJKqkGLobUr76er8PuG8KX21E6FdCv88TDcMhX8TF8dEwrGcD
         2NDjn9JMC/K6Imrl3UyxM3H/JRFmBJ8kIDuQzDWJaNSgbHTIg1cJ6QyOIAN20XDQ+Bfr
         Ij24y3u02UUcQBKfSLoFxW+Hs0b7lkPzgY0CntfIF30vsd5VPnMscDmuQCS6HnFbKMoV
         EdorrEZMFlzmWKTKx1GPmCUTWLmFGfIbNY0YfToJUK+ZQJ/11cr++LmCd5eld9D1NIGY
         mSUA==
X-Gm-Message-State: AOAM53325JOTC6YkijsusFD0eLpA/8Qal/XToIBDy0SWfD74IQMXIm8t
        275aJyt4ALOxkW/mYkGxZmC8qiyDiLs0YzUr
X-Google-Smtp-Source: ABdhPJwkyaBF2JL++GxtE32boyAoKdSleVwzIP89KU+N+iYAXxzgoa3tnNcVhCwB/0st9wWnymrHng==
X-Received: by 2002:ac2:4151:: with SMTP id c17mr2694092lfi.416.1614285749656;
        Thu, 25 Feb 2021 12:42:29 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id i2sm1204802lfb.66.2021.02.25.12.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 12:42:29 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 08/12] Documentation: networking: dsa: add paragraph for the LAG offload
In-Reply-To: <20210221213355.1241450-9-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-9-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 21:42:28 +0100
Message-ID: <87v9afria3.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 23:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Add a short summary of the methods that a driver writer must implement
> for offloading a link aggregation group, and what is still missing.
>
> Cc: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index 463b48714fe9..0a5b06cf4d45 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -698,6 +698,38 @@ Bridge VLAN filtering
>    function that the driver has to call for each MAC address known to be behind
>    the given port. A switchdev object is used to carry the VID and MDB info.
>  
> +Link aggregation
> +----------------
> +
> +Link aggregation is implemented in the Linux networking stack by the bonding
> +and team drivers, which are modeled as virtual, stackable network interfaces.
> +DSA is capable of offloading a link aggregation group (LAG) to hardware that
> +supports the feature, and supports bridging between physical ports and LAGs,
> +as well as between LAGs. A bonding/team interface which holds multiple physical
> +ports constitutes a logical port, although DSA has no explicit concept of a
> +physical port at the moment. Due to this, events where a LAG joins/leaves a

s/physical/logical/ right?

> +bridge are treated as if all individual physical ports that are members of that
> +LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
> +state, etc) on a LAG are treated similarly: DSA offloads the same switchdev
> +port attribute on all members of the LAG. Switchdev objects on a LAG (FDB, MDB)
> +are not yet supported, since the DSA driver API does not have the concept of a
> +logical port ID.

Switchdev objects (MDB entries and VLANs) are supported, and will be
added to all members of the LAG just like attributes. Static FDB entries
are not switchdev objects though, and are therefore not supported.

> +
> +- ``port_lag_join``: function invoked when a given switch port is added to a
> +  LAG. The driver may return ``-EOPNOTSUPP``, and in this case, DSA will fall
> +  back to a software implementation where all traffic from this port is sent to
> +  the CPU.
> +- ``port_lag_leave``: function invoked when a given switch port leaves a LAG
> +  and returns to operation as a standalone port.
> +- ``port_lag_change``: function invoked when the link state of any member of
> +  the LAG changes, and the hashing function needs rebalancing only towards the
> +  subset of physical LAG member ports that are up.
> +
> +Drivers that benefit from having an ID associated with each offloaded LAG
> +can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
> +method. The LAG ID associated with a bonding/team interface can then be
> +retrieved by a DSA switch driver using the ``dsa_lag_id`` function.
> +
>  TODO
>  ====
>  
> -- 
> 2.25.1
