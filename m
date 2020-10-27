Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA25E29C03D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817089AbgJ0RNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:13:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40741 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1784700AbgJ0O7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:59:35 -0400
Received: by mail-lf1-f66.google.com with SMTP id a9so2708071lfc.7
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 07:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=C+qpU7upM+JQxch4WhcQ6VXYVZiD9niPVaw9YQVcUjQ=;
        b=yKT1wk2H1xeWhLAlCYrlqPLw61xxN+wtqxrf6qssvkhRiL4Y7mchUTkcm2Hw2sM0gQ
         O8vSqkl9RpLo0AahYcCOkIRTYcK+/ZJokPHK/9xstfSsgG8nDvrWad/sncUsxgUibB8m
         5+gJiWHn50OzzOT+RGAXWXvDfeppOKl7IdOniyPYVvdHEDftNkSAesSLzpmnwypKs+qo
         eBrT9glWwOUGeMPxCGE1ldbuOyubavaVFTOLKW8awSiKXyy9MTSYxgaUhGn4KtWXNxA9
         5AhWybEcYvo7oHVjixPbn1DlMV6WHnp+I3vVknMhmtq77Ttkj6Z3RgNnOS3T1Y8sYeFk
         y4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=C+qpU7upM+JQxch4WhcQ6VXYVZiD9niPVaw9YQVcUjQ=;
        b=ASwcHQ+Yvw9zVHRc4PDP72zT38wWEw3JoCGovCpI6zzEYsdBWWkw6LP8f85vHT99ju
         lUHdYIBis5350z8zYb49MQlgdN3FWNTwdQmHgk/OUoGRS2jau+imdV0RvDelsyazJrco
         ASH8BuwlOHq5hVBBZ74qnBxuYqv6xfy4TCSMWFtZmDexTTBz99En+ldF55F7Un1swSMp
         2TH0GzrVJ6t3OWLuXGozp2/v3QD/nY3/vugg7xbhWOXBZXHdwqCUI/01z/Gu2zG4nwrY
         GVADpS560zdBf/9xVmfXqN5homcjS46MXls91or2DxD6Mq4d1zxk62bzvku60/va5aLr
         oH3Q==
X-Gm-Message-State: AOAM531Vvpc03BjyqO9uLHgvRnZijrD/2pTyHsNbR646D3nabjgD6qYt
        rDonP2YwyT7WqA/cIntInS866MQSDjPCwKPp
X-Google-Smtp-Source: ABdhPJyywo75nYL4HVb6aB32xtHjhJhR6fMy4/VJRC3UaDDakJz4m+GncDU/d/KKaDR1fWUl9phXWg==
X-Received: by 2002:a05:6512:3055:: with SMTP id b21mr1060776lfb.229.1603810772072;
        Tue, 27 Oct 2020 07:59:32 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l129sm199897lfd.279.2020.10.27.07.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 07:59:31 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027122720.6jm4vuivi7tozzdq@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027122720.6jm4vuivi7tozzdq@skbuf>
Date:   Tue, 27 Oct 2020 15:59:30 +0100
Message-ID: <87tuufvhnx.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 14:27, Vladimir Oltean <olteanv@gmail.com> wrote:
>> The LAG driver ops all receive the LAG netdev as an argument when this
>> information is already available through the port's lag pointer. This
>> was done to match the way that the bridge netdev is passed to all VLAN
>> ops even though it is in the port's bridge_dev. Is there a reason for
>> this or should I just remove it from the LAG ops?
>
> Maybe because on "leave", the bridge/LAG net device pointer inside
> struct dsa_port is first set to NULL, then the DSA notifier is called?

Right, that makes sense. For LAGs I keep ds->lag set until the leave ops
have run. But perhaps I should change it to match the VLAN ops?

> Since ocelot/felix does not have this restriction, and supports
> individual port addressing even under a LAG, you can imagine I am not
> very happy to see the RX data path punishing everyone else that is not
> mv88e6xxx.

I understand that, for sure. Though to be clear, the only penalty in
terms of performance is an extra call to dsa_slave_check, which is just
a load and compare on skb->dev->netdev_ops.

>> (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
>> seems like all chips capable of doing EDSA are using that, except for
>> the Peridot.
>
> I have no documentation whatsoever for mv88e6xxx, but just wondering,
> what is the benefit brought by EDSA here vs DSA? Does DSA have the
> same restriction when the ports are in a LAG?

The same restrictions apply I'm afraid. The only difference is that you
prepend a proper ethertype before the tag.

The idea (as far as I know) is that you can trap control traffic (TO_CPU
in DSA parlance) to the CPU and receive (E)DSA tagged to implement
things like STP and LLDP, but you receive the data traffic (FORWARD)
untagged or with an 802.1Q tag.

This means you can use standard VLAN accelerators on NICs to
remove/insert the 1Q tags. In a routing scenario this can bring a
significant speed-up as you skip two memcpys per packet to remove and
insert the tag.
