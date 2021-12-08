Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E2046D35B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhLHMf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhLHMf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:35:58 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A00C061746;
        Wed,  8 Dec 2021 04:32:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g14so7780893edb.8;
        Wed, 08 Dec 2021 04:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9MiUm4l5U844AA3d0EfW8ti2Wpr/IulKdw4qVFUvPc0=;
        b=hGlkpXUJ7PRTd2AQI1BF6KYL+BqEZ6yvAbcrozgWUcYz5u0wPYvvX+JFNB2eqoWnWw
         KDdHkQkimI3odKd6ydUxfw8GmnCzqeKNXPqJReMzkFUN842MmRXvxXa//98uR9yczksU
         36HB1SrFQzkPu4B4f0FPvX6KV2pLBkb0ea5hMFrcBhJQO4+YdWW856nmtpmQesTKrk0N
         vOe13TqH2aUjr7AmNrVuYfu4+eNGTsVQKJKT7affRTjOEDD97aLNGP4nsLod8V5chVoI
         IBJsejHNPqrb3KaWpN/eYnpGAk4/wDBjFo2JIhJ11FR9uPakXOPVTvCRR0eOX87yfqNB
         vbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9MiUm4l5U844AA3d0EfW8ti2Wpr/IulKdw4qVFUvPc0=;
        b=cGvIZPpHHNDT8YU0/boZXSQ5Ctg27BzVTrXmYNc5OJrokRAVQ5cn7Js6yGviS9O6q8
         ht3jxvM81UmUrIMELTCV8TmaKRfN7XknTtMScdhZVVyrNOq/2ma7w9vh3WHFqRGLzUfL
         YGUFtjXVsPRRUUf0JsBGdN7UnM0ualcKEh4yrbkzB9UFhn8Vfk87kt6s02/i9khYGdPb
         kgZcy6acPvDYf/GqHWXNYrCBWeLj/Eq2D0JFiIo1X4kyHLMEK3rK9ZbwIEuBg/CibEbj
         YeJCn44SBwKcJsglsJsUmnmbmBf4yYrcPCa1+UaqYmSzJg7H+AWrOZCMuco4izU9LlUH
         DvpQ==
X-Gm-Message-State: AOAM530huoPzyjfu/MZMcDQc/lEzOf1Zclph/TVdF6OMJqFBzS/csFpQ
        g+tRz/1UAC0Y+Nt5jiZid7E=
X-Google-Smtp-Source: ABdhPJzN0q6o+Y3hYpF6vvbs6Lb7ffzekkkrvob9e4hP9zNOzkaERXua/ip0/5yu2uMvsX5h57J0nA==
X-Received: by 2002:a17:906:4488:: with SMTP id y8mr7000336ejo.175.1638966744494;
        Wed, 08 Dec 2021 04:32:24 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id gs15sm1367556ejc.42.2021.12.08.04.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 04:32:23 -0800 (PST)
Date:   Wed, 8 Dec 2021 14:32:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v2 0/8] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208123222.pcljtugpq5clikhq@skbuf>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:40:32AM +0100, Ansuel Smith wrote:
> I still have to find a solution to a slowdown problem and this is where
> I would love to get some hint.
> Currently I still didn't find a good way to understand when the tagger
> starts to accept packets and because of this the initial setup is slow
> as every completion timeouts. Am I missing something or is there a way
> to check for this?
> After the initial slowdown, as soon as the cpu port is ready and starts
> to accept packet, every transaction is near instant and no completion
> timeouts.

My guess is that the problem with the initial slowdown is that you try
to use the Ethernet based register access before things are set up:
before the master is up and ready, before the switch is minimally set
up, etc.

I think what this Ethernet-based register access technique needs to be
more reliable is a notification about the DSA master going up or down.
Otherwise it won't be very efficient at all, to wait for every single
Ethernet access attempt to time out before attempting a direct MDIO
access.

But there are some problems with offering a "master_going_up/master_going_down"
set of callbacks. Specifically, we could easily hook into the NETDEV_PRE_UP/
NETDEV_GOING_DOWN netdev notifiers and transform these into DSA switch
API calls. The goal would be for the qca8k tagger to mark the
Ethernet-based register access method as available/unavailable, and in
the regmap implementation, to use that or the other. DSA would then also
be responsible for calling "master_going_up" when the switch ports and
master are sufficiently initialized that traffic should be possible.
But that first "master_going_up" notification is in fact the most
problematic one, because we may not receive a NETDEV_PRE_UP event,
because the DSA master may already be up when we probe our switch tree.
This would be a bit finicky to get right. We may, for instance, hold
rtnl_lock for the entirety of dsa_tree_setup_master(). This will block
potentially concurrent netdevice notifiers handled by dsa_slave_nb.
And while holding rtnl_lock() and immediately after each dsa_master_setup(),
we may check whether master->flags & IFF_UP is true, and if it is,
synthesize a call to ds->ops->master_going_up(). We also need to do the
reverse in dsa_tree_teardown_master().
