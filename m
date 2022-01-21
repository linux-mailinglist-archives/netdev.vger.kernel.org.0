Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B084962A0
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381746AbiAUQJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239055AbiAUQJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:09:27 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8247DC06173B;
        Fri, 21 Jan 2022 08:09:26 -0800 (PST)
Received: from [IPV6:2003:e9:d70c:7733:6a50:4603:7591:b048] (p200300e9d70c77336a5046037591b048.dip0.t-ipconnect.de [IPv6:2003:e9:d70c:7733:6a50:4603:7591:b048])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B50BFC0271;
        Fri, 21 Jan 2022 17:09:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1642781365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vP6QRA8n/D5UmCqAFhTvJswXRwg0BQqWAbXe4MlFHhE=;
        b=TjwXP7ConHEUR1JGx/Xowi+KX+5cOPMY+Kmz2tZt298noUtD6Dphad6iZwVAWheQRz5yOT
        tHKuIxWA5djOz5u+d0yJf1PsGFXz9jqV9JWlliG4zwDmVQQUkqAm1Oq+DMQJ1E8jrqY+0k
        Q2RgRwDjHf6EI52Y1kAk3uN91QbHz8G+1wlrQ4i9NBO9NDsw07qv1sI0QgNCEb3B1ReD8o
        rfDdDea4vHkGHEvT9Oe+WBLjN50l5djdhz2HNhFwq0fdhZRa/d+pM99cW6VNUcY9i99iSr
        OtqwHKOI2AnHDnEmGfgzQYg5TE3vxM/M+tVk+738E84cKMV0+oXq3gIAqBEr6w==
Message-ID: <99d1c254-5d3f-f4be-b58d-8a956907140c@datenfreihafen.org>
Date:   Fri, 21 Jan 2022 17:09:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next v2 0/9] ieee802154: A bunch of fixes
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Miquel

On 20.01.22 12:21, Miquel Raynal wrote:
> In preparation to a wider series, here are a number of small and random
> fixes across the subsystem.
> 
> Changes in v2:
> * Fixed the build error reported by a robot. It ended up being something
>    which I fixed in a commit from a following series. I've now sorted
>    this out and the patch now works on its own.
> 
> Miquel Raynal (9):
>    net: ieee802154: hwsim: Ensure proper channel selection at probe time
>    net: ieee802154: hwsim: Ensure frame checksum are valid
>    net: ieee802154: mcr20a: Fix lifs/sifs periods
>    net: ieee802154: at86rf230: Stop leaking skb's
>    net: ieee802154: ca8210: Stop leaking skb's
>    net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
>    net: ieee802154: Return meaningful error codes from the netlink
>      helpers
>    net: mac802154: Explain the use of ieee802154_wake/stop_queue()
>    MAINTAINERS: Remove Harry Morris bouncing address
> 
>   MAINTAINERS                              |  3 +--
>   drivers/net/ieee802154/at86rf230.c       |  1 +
>   drivers/net/ieee802154/ca8210.c          |  1 +
>   drivers/net/ieee802154/mac802154_hwsim.c | 12 ++----------
>   drivers/net/ieee802154/mcr20a.c          |  4 ++--
>   include/net/mac802154.h                  | 12 ++++++++++++
>   net/ieee802154/nl-phy.c                  |  5 +++--
>   net/ieee802154/nl802154.c                |  8 ++++----
>   8 files changed, 26 insertions(+), 20 deletions(-)
> 

All patches apply without conflict to my wpan tree (to feed into net 
instead of net-next for these fixes) and compile testing showed no 
problems. I will do some light smoke testing on the weekend and also 
wait for Alex review. But beside one small review remark these should be 
ready to go in on the next iteration.

regards
Stefan Schmidt
