Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8FE343DE4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhCVKac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhCVK37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 06:29:59 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B82C061765
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:29:57 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z25so20344612lja.3
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yU+qIvBWk1kJvqdslxYHWF/zXGgpGkmRQmk9Yu+vJtA=;
        b=r0ghP52A1I0uK8WlxBsk21Vewm9OLJClR44DhKlfZKCXyrioNxYpwjBM7kKeXabHOE
         I5C6O4n+XNx3CuKswcA5ftZ6Hqn9T/5QhtdRjAPf+bC9FNnLWMtangd4u3Y3KJsgOYJ+
         Kl5w5c8BhfGncbU0z6dj4xCwwOVAQa/DAFZm7BFTLXVXyWeaJ/M0aANZMFYoC/Su8TVH
         xEDaW7XV88B1kWZozNEfHJIvq4q7m5/4Un/HibUUkkirt+2tKs6yjFvI0rGcTHErUNYA
         jM0ZeoCcRgtQ0OsCs62/8HBCxxkwUbvKYbSAhyBb1nMQ5GMG32almrLZwu2ZxLTYuTk7
         AlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yU+qIvBWk1kJvqdslxYHWF/zXGgpGkmRQmk9Yu+vJtA=;
        b=E8JJHCJ9KXridUXDz470F7UaIOm3HKV0RqdIC18oCQ+jnkmW57dDMJbL5cTtESh1mt
         IPLqN/3C2X70HqWCG759RKTWyDhfWnTwWHqWIMa1BUZ9eP7xWVHUdCOwdut+FlQOwQkH
         6Ow3+njlxIppVyCDvkTCTeD22o5VzUZV3Cm1JqCuNU6FSCmQrzeBPDk8Xx1a4KThv5Ec
         vPJu2AYASYdIwHszDgm423CHNtMA9BRqkJI4fK7BhzFTDvcEbS29WRPZgcdkqI46r3mk
         sTCQ3367e/1ttx+FIfNAQQHMAljxdc4wxXUWORloJr32IScIk6btrgknzo0Mmq29rpZh
         C6TQ==
X-Gm-Message-State: AOAM53276oD+BLQcx8asvNg3aGe+aI0aojHHSN+Hq10j1uyaPewRx+9N
        XGsFnmZzvbhUHkfXsd7Rsr8RHA==
X-Google-Smtp-Source: ABdhPJyT8YpHeks7w6/UwXq2lpPnHww4i0cs8C5c3gqi0y5gdESK5JvKAMLWbbzgWY74pBougy9feQ==
X-Received: by 2002:a2e:9a98:: with SMTP id p24mr9379943lji.265.1616408995470;
        Mon, 22 Mar 2021 03:29:55 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x8sm1530380lfc.8.2021.03.22.03.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:29:55 -0700 (PDT)
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
Subject: Re: [RFC PATCH v2 net-next 04/16] net: dsa: sync up with bridge port's STP state when joining
In-Reply-To: <20210318231829.3892920-5-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-5-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 11:29:54 +0100
Message-ID: <878s6fo50d.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> It may happen that we have the following topology:
>
> ip link add br0 type bridge stp_state 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> ip link set swp1 master bond0
>
> STP decides that it should put bond0 into the BLOCKING state, and
> that's that. The ports that are actively listening for the switchdev
> port attributes emitted for the bond0 bridge port (because they are
> offloading it) and have the honor of seeing that switchdev port
> attribute can react to it, so we can program swp0 and swp1 into the
> BLOCKING state.
>
> But if then we do:
>
> ip link set swp2 master bond0
>
> then as far as the bridge is concerned, nothing has changed: it still
> has one bridge port. But this new bridge port will not see any STP state
> change notification and will remain FORWARDING, which is how the
> standalone code leaves it in.
>
> Add a function to the bridge which retrieves the current STP state, such
> that drivers can synchronize to it when they may have missed switchdev
> events.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
