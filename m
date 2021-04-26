Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B270036B441
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhDZNs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhDZNs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 09:48:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1B1C061574;
        Mon, 26 Apr 2021 06:47:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lr7so10884187pjb.2;
        Mon, 26 Apr 2021 06:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bmdsWUiF+UouXeclb/QihxwtZO4aP5KYKDt52Zt+pR4=;
        b=ILSFUuiLwE37BRQu5JDZqCTdAQAudrwHpuDt6K1EvUbXHNIdaVtaZr77Rh+vQSvjLe
         thCqKkZtLDUVKa2r03sBgmJzXi5DOuf5IWZe+S/DgzEzD3E7JLDQKj+JE5sI1T0iv2CG
         bq7ifvwCSFEm2GP+GqkfvqKkychzmZkrVY9rKLC33kx1X4F062Bcpjx5/WxNzwe0Xctt
         nLL32sVGqka8QeWXSzXQKv9FsmDe/tnADo2SjlfiKzuOI9nuqPHNmc/a6UcNeNTbYE1k
         Tm3XIDkd9DS6uuSc8pRUvuAcpqTT6CP23KadYr+fSBubYtgy6AOq9zEUXttaT2RNRDqr
         1NaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bmdsWUiF+UouXeclb/QihxwtZO4aP5KYKDt52Zt+pR4=;
        b=YcTTEVdClG+Gt9R2+glGxAKbupOYlGVw5Q4/2i1A70nBus7tkFBe6zCE+6iu18l5IV
         59hGuU6+dsBKAv60vavLyF0HbRBO5pUlzlB1CZybYf2wwumSaigIctDUwc26fDkb05OG
         mhzSmMiuHdKB/khlXQMYcz/z7ED1luPdC2Bm2f5RnB73YWxkbFMDtRx4BS/BJRAfzamX
         lk2K6UJsDvJAl8HUb5UnGt4d2cnpqaXvMhVpGlB6ybC/WJfvijVE5v3BXyDCFYU77lGb
         qpenis6G1dxMr2ScpYdrZcrYLw8meDCaI1ZnwoG6WtraZfD7LbnTZIAFaVpMK1AJ13b2
         iD/A==
X-Gm-Message-State: AOAM53022MAwuoQ0qlLNNo2idKzjeiYrTw+4e652IX2HqfW3QGe4j20H
        asdoLs13aXln0V6F0WA3hWE=
X-Google-Smtp-Source: ABdhPJydRykU+2De9QBNGf7IWO8IIPiFBuuveO5U4roLi5yOjmpVqFT7MCRru5SYj/BoVVmboO+9Ag==
X-Received: by 2002:a17:902:9347:b029:e8:c21c:f951 with SMTP id g7-20020a1709029347b02900e8c21cf951mr18837629plp.14.1619444863043;
        Mon, 26 Apr 2021 06:47:43 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id fw24sm12326791pjb.21.2021.04.26.06.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 06:47:42 -0700 (PDT)
Date:   Mon, 26 Apr 2021 06:47:39 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, v2, 0/7] Support Ocelot PTP Sync one-step timestamping
Message-ID: <20210426134739.GB22518@hoboy.vegasvil.org>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426093802.38652-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 05:37:55PM +0800, Yangbo Lu wrote:
> This patch-set is to support Ocelot PTP Sync one-step timestamping.
> Actually before that, this patch-set cleans up and optimizes the
> DSA slave tx timestamp request handling process.
> 
> Changes for v2:
> 	- Split tx timestamp optimization patch.
> 	- Updated doc patch.
> 	- Freed skb->cb usage in dsa core driver, and moved to device
> 	  drivers.
> 	- Other minor fixes.
> 
> Yangbo Lu (7):
>   net: dsa: check tx timestamp request in core driver
>   net: dsa: no longer identify PTP packet in core driver
>   net: dsa: free skb->cb usage in core driver
>   net: dsa: no longer clone skb in core driver
>   docs: networking: timestamping: update for DSA switches
>   net: mscc: ocelot: convert to ocelot_port_txtstamp_request()
>   net: mscc: ocelot: support PTP Sync one-step timestamping

Please fix the memset.  Then, for the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
