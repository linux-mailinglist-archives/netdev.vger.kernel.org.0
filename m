Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48602DC5D8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLPSDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728984AbgLPSDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:03:32 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B10C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:02:52 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so29397948ejf.11
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 10:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7/O5jGVd63QArqSj+pteZeX/B13dyDnoBKftzgeM47s=;
        b=oZeHOzOERk9vs07TkHw6kOrymUBpTDIE8XNYbjtjFYTnK4feBg3EjLGl6V6Cjv1rMY
         lHx/BGWAAcoP/QCbtszvMcTTCcvcPk4sJA2y6hRsyz2ir6MQ+j5tKHGOGdgnFzTK8DNf
         SnH8d12EoJnhS+tK0DHRLtq0a5cxcTM2JkkCG0vjv8yfnKNugtGKz3UNlGnEyr+GuArb
         OjvJSeeocdl7z6rXlvdlvtcYEJBmdv27Pef+ncLTPJ6j2weWr/ZnNCmgrR1b0OwaIBPZ
         SvMSY4mnN7qNx1B84vw7go4eEs2Qpj4WY++h3PRilkSVgfdniKdXALiM2OpCpBB39EIo
         2yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7/O5jGVd63QArqSj+pteZeX/B13dyDnoBKftzgeM47s=;
        b=PCycAGIJxgr83h56hQlnmmDgFXPg5SCNIIDTi02JB0qpJ26du5RsLSR4PMgrFMvesf
         eMPy53rkI+c587wAlSQTAPK7kMEOjk1ZXQT3z0eNfvWX5utS1XBfN5CzJAEOYfa3F7h4
         8mfXuzI4wwhrOf1WXcGSby8NSV1tMHgB2kLya64Q8UhcnhHi0M5j6H/9k3pIVlL3eEVV
         As+wekESN2Fj+/5SGJuzv5N+WeThnx3rdQraFXRieLpSjD/9Hbb5xiwJXppqPicIkuCP
         ihJlpyDOoFb9E1adtaNePREJxQIWNKbzDNuYD4ABP51brlXnrklujyAT62NZL/8+wIgR
         vMEQ==
X-Gm-Message-State: AOAM533ejT32peYCEpRHTw1vn6fXUGoIOIJytnQLjfF1w0TfMf+Fpk3U
        ggthhn1BopAH2akkq+5tPQ0=
X-Google-Smtp-Source: ABdhPJzNXK8Hnlq/3R4+COHqObFFwetDb1q07uUdHSCHh5GWHDo64piIir0P33AyhzfGgyrT8yDaTQ==
X-Received: by 2002:a17:906:1a19:: with SMTP id i25mr31251209ejf.206.1608141770459;
        Wed, 16 Dec 2020 10:02:50 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id gt11sm1893725ejb.67.2020.12.16.10.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 10:02:49 -0800 (PST)
Date:   Wed, 16 Dec 2020 20:02:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: dsa: Link aggregation support
Message-ID: <20201216180248.u3uhrec2ssveubyp@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:54PM +0100, Tobias Waldekranz wrote:
> +	/* Drivers that benefit from having an ID associated with each
> +	 * offloaded LAG should set this to the maximum number of
> +	 * supported IDs. DSA will then maintain a mapping of _at
> +	 * least_ these many IDs, accessible to drivers via
> +	 * dsa_tree_lag_id().
           ~~~~~~~~~~~~~~~
           you named it dsa_lag_id() in the end.

> +	 */
> +	unsigned int		num_lag_ids;
[...]
> +	/* No IDs left, which is OK. Some drivers do not need it. The
> +	 * ones that do, e.g. mv88e6xxx, will discover that
> +	 * dsa_tree_lag_id returns an error for this device when
           ~~~~~~~~~~~~~~~
           same thing here.

> +	 * joining the LAG. The driver can then return -EOPNOTSUPP
> +	 * back to DSA, which will fall back to a software LAG.
> +	 */
