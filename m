Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45F4346750
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhCWSLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 14:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhCWSLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:11:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24394C061574;
        Tue, 23 Mar 2021 11:11:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b16so24564432eds.7;
        Tue, 23 Mar 2021 11:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MCPLjYxUPHJjtBbr7qDhhFRxaOGID3RaKgPQJfHXKhA=;
        b=IAqUok+DArpZQejw91eZHydS0XrzluCKK0ZGAZpbIptMzLrt4s+5PiKLp47Tl6DKmX
         +e4vrRP2O99MYhS/le+qtAg3eqo3R/OTJ8OcCndsDzZLtsrsUtBQ+XmXjyrgggpPCrU7
         3PdKFZ2J2Khhfo1E8BBsCEhh5D2a78n4PUruGWl/xjRsIrLYX/BwmNSg157Md8JPniZU
         q1ugaObuP/R4rX4m9P0FiSwWlzVnm+j0K+nx5oCFpCO+SZA4EWo4alJUKaMt/q6TnchL
         v4wHA+vyfmfbEgC5hZPTN9l92kzLXpGPc4U/E1DovEqDwnzG7OvRbIAhmn4O2hce/cZZ
         JFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MCPLjYxUPHJjtBbr7qDhhFRxaOGID3RaKgPQJfHXKhA=;
        b=pyw3xIY/A1gEo5x1GMEyPPXBIF/qpLaVPQiWSUrQWbmmXf1a5xdlSrOeAY2JgWbNIK
         g6xgcaRvEUvBJvlVTjtIiBcU11YuGdVaR0qCbIcvj02t1bGmmsDGCQ7ZnNIYlaWK0nrZ
         HAmmMgQoaXGNbFmd5KyI4sAKkg0Df4RkylsyyFB3uVRCb0LnLC1ICb3FbmC0U99zGgeR
         czqf23rpIhqkDdqjUEYZUZz1kbmW9o3cJwkOIku3wrTLcMQI1LvGlUxYyEszzRAZrO0Z
         p2157VU4ixQ8jiO/3TN9SnYiwuaFz7IGAn5bVJhXPBXB7Cwezygfcdpdto+ZsoTBYelX
         vfcw==
X-Gm-Message-State: AOAM532qPgWL29+39Mmm8iJ7faNoEXfCu3YL2oQAHOHTwGjUKj+n8tyn
        UOy7EeaV47dbQD+QGKIymcQ=
X-Google-Smtp-Source: ABdhPJwOuKc4clJVlr0UtJi1IMZX0R8u62ZekH6IBTGaMU7qqcHlVZ/TqF9C12+AqK9DoZRnJ7x8vQ==
X-Received: by 2002:a05:6402:614:: with SMTP id n20mr5805238edv.58.1616523074872;
        Tue, 23 Mar 2021 11:11:14 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bm10sm13359816edb.2.2021.03.23.11.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 11:11:14 -0700 (PDT)
Date:   Tue, 23 Mar 2021 20:11:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v4 net-next 04/11] net: bridge: add helper to replay port
 and local fdb entries
Message-ID: <20210323181112.xxzfosb4dokpgn72@skbuf>
References: <20210322235152.268695-1-olteanv@gmail.com>
 <20210322235152.268695-5-olteanv@gmail.com>
 <f9076daf-7479-8c49-5e7c-ea20d86214c4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9076daf-7479-8c49-5e7c-ea20d86214c4@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 01:12:33PM +0200, Nikolay Aleksandrov wrote:
> On 23/03/2021 01:51, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > When a switchdev port starts offloading a LAG that is already in a
> > bridge and has an FDB entry pointing to it:
> > 
> > ip link set bond0 master br0
> > bridge fdb add dev bond0 00:01:02:03:04:05 master static
> > ip link set swp0 master bond0
> > 
> > the switchdev driver will have no idea that this FDB entry is there,
> > because it missed the switchdev event emitted at its creation.
> > 
> > Ido Schimmel pointed this out during a discussion about challenges with
> > switchdev offloading of stacked interfaces between the physical port and
> > the bridge, and recommended to just catch that condition and deny the
> > CHANGEUPPER event:
> > https://lore.kernel.org/netdev/20210210105949.GB287766@shredder.lan/
> > 
> > But in fact, we might need to deal with the hard thing anyway, which is
> > to replay all FDB addresses relevant to this port, because it isn't just
> > static FDB entries, but also local addresses (ones that are not
> > forwarded but terminated by the bridge). There, we can't just say 'oh
> > yeah, there was an upper already so I'm not joining that'.
> > 
> > So, similar to the logic for replaying MDB entries, add a function that
> > must be called by individual switchdev drivers and replays local FDB
> > entries as well as ones pointing towards a bridge port. This time, we
> > use the atomic switchdev notifier block, since that's what FDB entries
> > expect for some reason.
> > 
> 
> I get the reason to have both bridge and bridge port devices (although the bridge
> is really unnecessary as it can be inferred from the port), but it looks kind of
> weird at first glance, I mean we get all of the port's fdbs and all of the bridge
> fdbs every time (dst == NULL). The code itself is correct and the alternative
> to take only 1 net_device and act based on its type would add another
> step to the process per-port which also doesn't sound good...
> There are a few minor const nits below too, again if there is another version
> please take care of them, for the patch:
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks for the review. For host MDB entries, those are already offloaded
to every bridge port (which yes, is still giving me headaches), so
replaying them for every port that calls br_mdb_replay is at least
consistent with that. For br_fdb_replay, honestly I am not yet sure
because mainline DSA does not yet handle local FDBs, I might end up
touching things up a little when I come back to the "RX filtering in
DSA" series (I need to address Ido's feedback by then too).  I would
just like to get something started. It's even possible that by the end
of the kernel development cycle, the end result might not even look
anything remotely similar to what we have here - this is just what I
deemed as "good enough as a small first step".

If nobody has objections or sees problems with the current series, I
think I'd prefer to send a follow-up with the const conversions, so I
can spam less people with another 11 emails.
