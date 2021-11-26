Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC55445EF4A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377476AbhKZNnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377641AbhKZNlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:41:32 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFB3C061377;
        Fri, 26 Nov 2021 04:55:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so38299503eds.10;
        Fri, 26 Nov 2021 04:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XoDP5F/yOusx5/YBoqVWibZH3fsiV58n61Gin+ALY40=;
        b=CSPlnxmgjlR51w+Lty5xI4KpwzI7/YdxadLO5uJFboWEM3V2ZQMWV8nmkX6Ofl3teQ
         XgSjB8JgC9RBE5/j4NOcgAwMjxsyaqT1KkhwzE1jkCRWe9nv544vta/nOggkR/bjVOE7
         7I1YhfZ+7cZMxNBP8pSGmKpFvtv9FzuwUBUSmahlXmPk1h4f22xRbecSh5HoJ6Vm+lwG
         61va/qPaUxXol1WPP/rG3W/Vt/7ijIs+IIn+HWqpCO+Vbxscluauk8Zoz0n0u7LQmDLN
         jgxNrzU9efq+Qk2MrPoTdplkHZ4rxdwyPU1+vZQiUmd10SRr2lVQjOyEeB1GcMnu1Szt
         qglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XoDP5F/yOusx5/YBoqVWibZH3fsiV58n61Gin+ALY40=;
        b=KoRFPY+cKs+OoAsjLbo5nUyNdh43xuihCWg6lpIN9FyQGRapS7FYFzcSro8GEk6qo7
         XBEq/Ygdc5taFlv0MSYEfOEN7ksUURZ+/wKLqd41fCA5jIpRj6kTsyO4mLEcUY2DEXrz
         INvHzvHF5Mz6v6ImmqsrQjactYUtHKjc4jtbtzGiYOWlOoIcXWYdsNPIF/PU7kzTuoGa
         jQey/eFXDvEk4paOKgqCtB/zDlP2vpmJ5SKCzgRTOt0ykf1+U4n63eYUTS6uLDA18vWI
         DLfsp8kFwFm1ZOy1Q+FU2Ojb9INp65dvdF7UwtCQPVqm0C8cFGD70iXoFDHlDXXiSj/M
         Q73A==
X-Gm-Message-State: AOAM531kzc2uy1wFdwEsnp/Z3l9FiUNkRCbcvjO4TsPEuUbnOaXi0ZPK
        E+9XhYuxKY0GWwVT7AKgdp4=
X-Google-Smtp-Source: ABdhPJy8vlkC+yFalHKqEc2cHKSZwX0xHVjq73bu6dqBmcWwtEMxcphRTDCCWrCCTuF0MjYU76SHAA==
X-Received: by 2002:a17:906:6d52:: with SMTP id a18mr37840175ejt.193.1637931314096;
        Fri, 26 Nov 2021 04:55:14 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hc16sm2935969ejc.12.2021.11.26.04.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:55:13 -0800 (PST)
Date:   Fri, 26 Nov 2021 14:55:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 1/1] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211126125512.qgld6r5a7ylcseot@skbuf>
References: <20211126123926.2981028-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126123926.2981028-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 01:39:26PM +0100, Oleksij Rempel wrote:
> Current driver version is able to handle only one bridge at time.
> Configuring two bridges on two different ports would end up shorting this
> bridges by HW. To reproduce it:
> 
> 	ip l a name br0 type bridge
> 	ip l a name br1 type bridge
> 	ip l s dev br0 up
> 	ip l s dev br1 up
> 	ip l s lan1 master br0
> 	ip l s dev lan1 up
> 	ip l s lan2 master br1
> 	ip l s dev lan2 up
> 
> 	Ping on lan1 and get response on lan2, which should not happen.
> 
> This happened, because current driver version is storing one global "Port VLAN
> Membership" and applying it to all ports which are members of any
> bridge.
> To solve this issue, we need to handle each port separately.
> 
> This patch is dropping the global port member storage and calculating
> membership dynamically depending on STP state and bridge participation.
> 
> Note: STP support was broken before this patch and should be fixed
> separately.
> 
> Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
