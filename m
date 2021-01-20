Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04902FD748
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbhATRgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730315AbhATRd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 12:33:27 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DC3C0613C1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:32:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s11so19432639edd.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 09:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QTMVQgDq2jKhh9J1ZTlbgInAmy4fkP7up3eyTXl09OY=;
        b=UfRn/mMsTk9xYRR0DnQ8fh1MXodJTjG8/SPFA7HbvH+2lgYqueQS+1j41e0vm+dIT6
         kIsmprUb7MGlBoFkvkuO0SYRSbE5xNt3tOHktVGCnn8sDiiwidr60eILa89/pUr3EXN7
         M98moJPOXQr2DGHerkunXaNNGnXB2K09/8d8mjmDNyJAX0/vKOc2rfB5gtIE5M05KkzX
         qqYR8iE4KDzyqt0QN8AodUNqKvHOrGnWPM1at2+8HMYekJZTEZx/aAdHbJnI5XT0S/oR
         wxvGxl8+JLG1WYqFjZ2rUX2hSjCEMDLl9v6Hu7X18GURRWWf9rWLU4tqyBpT6bWBe9lX
         gHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QTMVQgDq2jKhh9J1ZTlbgInAmy4fkP7up3eyTXl09OY=;
        b=T7lXoiWpKCPrGCeIT4v9BzF9bWAxiGJ01k6WVuwIb0r6/eOfNflFukg7osqXQYcrTE
         qWg7YnsrLYy/RdciMZBf1saBBpcqr20zwdnIEu6cfefm8KjX4BgEz50CGIPRn5pRXeW8
         5E0h/LJfhTCK0O6uBTvIuDp0DXUIgvUargAJp0nL9HtigmpFuemFZOmhCDRvYZS/zrk7
         xtzjuvOGUUo+g+SoeJNd5JbW18UU9MalxXqLiNdVNi0VRKSuHCdz6ly3etbzp8wufpC9
         Mb7i/12ld8TTD+QKDcJYfWydp4LJ1olcuSfCNrUAfmj2er+mZhrS6x3hT75yo1mjKdP1
         IIrg==
X-Gm-Message-State: AOAM5326ve4OSusEuqPLq5OYUxuBx119gElXdbHCpcFN5Re8MNJuRVr0
        Y0qcCHC70gf9vPPlXRu/laM=
X-Google-Smtp-Source: ABdhPJyfGWl5H4tISYzdefkRrp2U3d2hJt3ag1vJNcu0x6Rv4E/jJszlJoDqJPky4sQw+fecrEtYBg==
X-Received: by 2002:a05:6402:757:: with SMTP id p23mr8314560edy.245.1611163963953;
        Wed, 20 Jan 2021 09:32:43 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k6sm1153898ejb.84.2021.01.20.09.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:32:43 -0800 (PST)
Date:   Wed, 20 Jan 2021 19:32:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 15/16] net: dsa: felix: setup MMIO filtering
 rules for PTP when using tag_8021q
Message-ID: <20210120173241.4jfqhsm725wqeqic@skbuf>
References: <20210119230749.1178874-1-olteanv@gmail.com>
 <20210119230749.1178874-16-olteanv@gmail.com>
 <20210120084042.4d37dadb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210120084042.4d37dadb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:40:42AM -0800, Jakub Kicinski wrote:
> drivers/net/dsa/ocelot/felix.c:464:12: warning: variable ‘err’ set but not used [-Wunused-but-set-variable]
>   464 |  int port, err;
>       |            ^~~
> drivers/net/dsa/ocelot/felix.c:265:53: warning: incorrect type in assignment (different base types)
> drivers/net/dsa/ocelot/felix.c:265:53:    expected unsigned short [usertype]
> drivers/net/dsa/ocelot/felix.c:265:53:    got restricted __be16 [usertype]
>
>
> Please build test the patches locally, the patchwork testing thing is
> not keeping up with the volume, and it's running on the largest VM
> available thru the provider already :/

I updated my compiler now, so that W=1 C=1 builds would not fail.
That should hopefully prevent this from happening in the future.

> I need to add this "don't post your patches to get them build tested
> or you'll make Kuba very angry" to the netdev FAQ.

Since I definitely don't want to upset Kuba, how bad is it to exceed the
15 patches per series limit? Do I need to do something about it?
