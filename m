Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15401343DB2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCVKZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhCVKYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 06:24:53 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792B8C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:24:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id z25so20327820lja.3
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Wecwnopc86KzaaAOKv3X7oG8HgwPY9eS80QiSLYB0eM=;
        b=o9gsBfuKJWDHOxBZKihm/vEqdDWAXNrVhlxycxZQy37pipJyW6ONJLOzKcmRQ7Gbv7
         20vv+UH8W6QiL92d9C03a9mGmq+d3WJtH8UTQK6cC2JXyhHfIw52FegIVpNGOSGKh/YI
         GjY9n5N9xGsur6m/KKgcl7dSP/flaS44MD/wNnhm6nwrKa+LvnXRMZQTRn3TEfZmgKLO
         ctd8p1gnGt6gpwYqBW9V8pL41/4m/xFURw+aUyScIQol/mcO23KMYVuisAxzHcMpIchQ
         mcDpDqn9s335ondAHMjhHolvXGBPHbKeGjsS9TEHiDezPTDTPkiUiwN6qlrlgA6Q3NZa
         iWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Wecwnopc86KzaaAOKv3X7oG8HgwPY9eS80QiSLYB0eM=;
        b=RE8nTv/FihCOd1BqDsqxKYMK2pqijUH2Kd7Dh1zHstpEx31QGnsZ2iGV46w56P4PNe
         B3Sb1p1IcAhD6VrzOjWB/mokNh+zGYxe/nXnhTvkGLCZ21J+qRFm/QLvNgYQfufQkBKv
         72P6uWxBBgiEqAFxYIXvTCnrh2xLavkfFO+Cyp+tj8+P31oubrmhrZknyWIeSuy9mqeU
         zQWfCjgc0SVSGuPIEjhOXxwwdJMTraI5iRKYbTk/rlmPvGByrXGARdKU7QB5edZ/54yx
         J3vTFYuyBrdM+0lDrHotuSzNaq/W7OMvivtbqtwqhFu0Nfyy7Jbzbt1xUZOeY/7DsbPG
         ahqA==
X-Gm-Message-State: AOAM533OwL1kEMsEcHHkJqm4WSl5EWXg7Jtm9sBo+vQBeVvDp6HB2Nh6
        qXREFmb2vBB1+41lPRcaZaclDw==
X-Google-Smtp-Source: ABdhPJzsmd+NyeqccDbrblkBWBsQe0ffnkHfCmbHXOn/TJZBCABBdJ8Ef6kPsWWYQtRBB5tf2BaQfw==
X-Received: by 2002:a05:651c:50f:: with SMTP id o15mr9209716ljp.389.1616408690762;
        Mon, 22 Mar 2021 03:24:50 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r15sm1904337ljj.88.2021.03.22.03.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:24:50 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 01/16] net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
In-Reply-To: <20210318231829.3892920-2-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-2-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 11:24:49 +0100
Message-ID: <87eeg7o58u.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> DSA can properly detect and offload this sequence of operations:
>
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set swp0 master bond0
> ip link set bond0 master br0
>
> But not this one:
>
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
>
> Actually the second one is more complicated, due to the elapsed time
> between the enslavement of bond0 and the offloading of it via swp0, a
> lot of things could have happened to the bond0 bridge port in terms of
> switchdev objects (host MDBs, VLANs, altered STP state etc). So this is
> a bit of a can of worms, and making sure that the DSA port's state is in
> sync with this already existing bridge port is handled in the next
> patches.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
