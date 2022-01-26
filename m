Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D828349D3F6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiAZVAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiAZVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 16:00:04 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0966C06161C;
        Wed, 26 Jan 2022 13:00:03 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a8so1163149ejc.8;
        Wed, 26 Jan 2022 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lEkoIfpLwpN4qDKwjyAgXgxx9hZ83QdosrwUlDdKfoE=;
        b=FatyzVxn8iwK6oF5QWSlw4gHgbM26lJJtdDThHmjips75V08YS8HIW0FNwTGKWyLyl
         YCafkxaxDuJ6uM+lHR+ZU+HyLZnYdZeXuw04I1iUeSrgWoU6XKXfTmGPjrHnfK9zof7r
         xKmaw3u7EYYwxXt5p4HccILZaknEuIkwN0ji/HogCS2rUtNni1ciZx4lzP9pAFMdOTez
         51TqDGCS8bLXSXjvxZ16sC4yR9rDsloMeZgo/mGKP3BEs8UNvSzjF76j/HwWHydjMPlm
         bkeiv7r38XrC78Kt3uIu6q+Qgv7wWHo1+OFaXq9c4ufQ3lP+YtucMbEKFq1baf2t9Z/v
         kjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lEkoIfpLwpN4qDKwjyAgXgxx9hZ83QdosrwUlDdKfoE=;
        b=R25MNVx42SPnDSoyRWNHaeKVomHhsscXnC2KSSp47tIso8lqyzxywCaDh8NBa7AEsq
         X8oIZrcNKMl+PLEhlAUA8LR46J6Fqrs6ITNAsmP3ZcBeTCjAuFV6oPjJns73Yaqm0ddC
         2IiAfu553crz4iOiCWh/ujuacw3fBHJ/uu1Bya2cnFAepxN1tX7oy1QURuDcbDfin/zZ
         ZtNdY7enPvVYcJ+oggpHSHR1ek+MqcJ0BwRPLKSPeUlc0XvJlqNcRq/eHWu0BAw7+Dv9
         yNIWhcTetwHfSWjbR3KD1cZbcjGtwvrJS7JEWoNaPqC7ExMZaZFIKqDfbx4dezhH0sI0
         0XgQ==
X-Gm-Message-State: AOAM533OjwElxxWyybVk9FVeOzEDjw2gZMFlQcyPYVH9FJl8wGvni7VD
        a2hw8hqxe8BcnMibPRcPaJY=
X-Google-Smtp-Source: ABdhPJyWcOaMaA6GtxM/Hfz7JzwQUmNhn6lmaq++H4vDoAn0iGlx32WV+ejhsiL+hdxIJVv7KEpWfg==
X-Received: by 2002:a17:906:3b84:: with SMTP id u4mr364282ejf.689.1643230802265;
        Wed, 26 Jan 2022 13:00:02 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id o14sm7872487eju.118.2022.01.26.13.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:00:01 -0800 (PST)
Date:   Wed, 26 Jan 2022 23:00:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v7 01/16] net: dsa: provide switch operations for
 tracking the master state
Message-ID: <20220126210000.qx5hxwgogjwllem7@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-2-ansuelsmth@gmail.com>
 <f1547841-2210-ec68-3111-333bb7468b34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1547841-2210-ec68-3111-333bb7468b34@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 07:22:51PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Certain drivers may need to send management traffic to the switch for
> > things like register access, FDB dump, etc, to accelerate what their
> > slow bus (SPI, I2C, MDIO) can already do.
> > 
> > Ethernet is faster (especially in bulk transactions) but is also more
> > unreliable, since the user may decide to bring the DSA master down (or
> > not bring it up), therefore severing the link between the host and the
> > attached switch.
> > 
> > Drivers needing Ethernet-based register access already should have
> > fallback logic to the slow bus if the Ethernet method fails, but that
> > fallback may be based on a timeout, and the I/O to the switch may slow
> > down to a halt if the master is down, because every Ethernet packet will
> > have to time out. The driver also doesn't have the option to turn off
> > Ethernet-based I/O momentarily, because it wouldn't know when to turn it
> > back on.
> > 
> > Which is where this change comes in. By tracking NETDEV_CHANGE,
> > NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
> > the exact interval of time during which this interface is reliably
> > available for traffic. Provide this information to switches so they can
> > use it as they wish.
> > 
> > An helper is added dsa_port_master_is_operational() to check if a master
> > port is operational.

"The DSA master is able to pass traffic when it was brought
administratively up and is also operationally up. We introduce a helper
function named dsa_port_master_is_operational() which checks for the
proper conditions on a CPU port's DSA master."

> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> -- 
> Florian
