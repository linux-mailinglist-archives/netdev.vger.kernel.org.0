Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6C45F2DF
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhKZRaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhKZR2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:28:52 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAD4C061D6B
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 08:58:50 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n26so9508067pff.3
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 08:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ezkqewlojXXMzLVn7+0N/HYJV9QLTwfFf6GZrXJss8U=;
        b=LsDePcNJNV6yQXLwRfClUIxRsLmLvzD9EqgGDxTVXGNQ9+XLEDMHu6BCWEr7UOyc0G
         n+zpqfxllRjbvPFyrOXc/huXs65VEobJI7RT3y7VHwdK1fVTs8MQCkaokmXjotAOtsHS
         tODcMgXjy/5q3qkjbUD+ukTknNsk6SWwgDykMh8Y3/qdUIHaqILliFfT595CgPmDu1oL
         tGDNxHrHXHf/DHesFw9YDArmV0sa5p9pjnop1bs4R553r7fV7O+PTunG3J/08230G4pG
         3JY+bPF36Mxj0BCIbGfwUm11GJUxNArVjPrmhNURElN5ZA0CIsqpbw1REFOcu/QFAHcf
         M9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ezkqewlojXXMzLVn7+0N/HYJV9QLTwfFf6GZrXJss8U=;
        b=wSm+W0PmM7rb2pkAyf/JLTlRU/ZmEvrY1QkdqWZ6HlvU8fqd9j0ef1xSXz8Xxq7C4b
         7l/EYt7Qd5LtHceU2fP3mS6vToaIMgIktJM4PKYLc/v81T3Dv3Lh7NhGAbr8HvNfJtza
         8NYpnOOXN4pHoas1LgGTG6x+WhU0K4rd53DHTLfD4TxpA9dThEz3fULRsetBlh8PpZrT
         QnO6QzBBiWVvwY65QFDPfCZtPEciqVsn8BKbRsrTGFdNEOHduLqQVomzlh+KewWuwHwo
         Rt+0UjTUH81U3Cwh46AoBEqLCAplDtzCXnK5ltfTqEZqwF5j8MfWnvpZI3AWu4fOC90K
         O4Fg==
X-Gm-Message-State: AOAM530HqMktjLU2C056azJdBPMhpky/7j3hC0qaTRmbGqoN3ueABN42
        /BsN2fwSfQFDDTaXRePJYp8=
X-Google-Smtp-Source: ABdhPJx2FUAItYVAwDJVz8AB7ltQ+33hfb/lMBWCbgYtHNk2nrHq9UjBg5SP2/5RHy4AD/loAtXAWQ==
X-Received: by 2002:a63:6881:: with SMTP id d123mr7893960pgc.497.1637945930415;
        Fri, 26 Nov 2021 08:58:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m15sm10895103pjc.35.2021.11.26.08.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 08:58:49 -0800 (PST)
Date:   Fri, 26 Nov 2021 08:58:47 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Message-ID: <20211126165847.GD27081@hoboy.vegasvil.org>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125232118.2644060-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125232118.2644060-5-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 01:21:18AM +0200, Vladimir Oltean wrote:

> So PTP over L2 barely works, in the sense that PTP packets reach the CPU
> port, but they reach it via flooding, and therefore reach lots of other
> unwanted destinations too. But PTP over IPv4/IPv6 does not work at all.
> This is because the Ocelot switch have ...

Not that the details are same, but I'd like to report that the Marvell
switches (or driver or kernel) also have issues with PTP over UDP/IPv4.

When configured with separate interfaces, not in a bridge, you can run
ptp4l as a UDP/IPv4 Boundary Clock, and it works fine.

When configured as a bridge, and running ptp4l as a UDP/IPv4
Transparent Clock, it doesn't work.  It has been a while, and I don't
have the HW any more, but I don't recall the exact behavior.  I think
the switch did not treat the Event frames as switch management frames.

(BTW, running ptp4l TC over Layer-2 worked just fine with the switch
configured as a bridge.)

Just saying, in case somebody with such a switch would like to try and
fix the driver by adding special forwarding rules for the IPv4/6
multicast addresses.

Thanks,
Richard


