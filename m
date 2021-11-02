Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037694435C0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhKBSlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbhKBSlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 14:41:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4679EC061203;
        Tue,  2 Nov 2021 11:38:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g14so904162edz.2;
        Tue, 02 Nov 2021 11:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=str/dfDIj5VHMjVF37zMnOj5frfUi5Krc9aETI3IwUE=;
        b=cPt/NNvUClWWZ2/xyfxzl8l3IwDNZoC09613HwmL8lmBanan8rEMm8sj2HCsOk6d4F
         O2s/jeJYYq89uCGHQ901rIwBVPVZqsGEeIirK2H88DhkJgakIVyPj+8VA9azlTX5hUn2
         YJ+uJTK60z8ZEjFMlvGIxbZ2sB9eEDo8QbY/pnOiL6GRo9D7VNord3VTmLKpUhAp4txj
         a5Z8RhTpK56aSkt0OIxdt0sMdQHKkRImCVrcSYhGQcxJkfYOWw+egT3lG63AKUqmxbYF
         U6ogG3FFjGbxRcIC2xojtNHghVsY7XMAjSJzOOhiU7Zr5XpQJrjt7I03eDT3LgbLR8Ax
         RYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=str/dfDIj5VHMjVF37zMnOj5frfUi5Krc9aETI3IwUE=;
        b=NcdrvOYxl7uPfRKm8UNpTebig4cW8DE5y6fpVhwTE3RrfMIQgvx97SzjdDejYrJgmZ
         A6hZsELYl6HvV3Xj+rufmduRyY2K7l2Z8eH0JMjeh4+rVjt1m5gA1zogPu0KLL2IY7cl
         2YyMrB/aOpnneBzAQZ6fKudISqNQuQe6jfxT06sQZuNvF0NqFxpYIej1+dxJkH581itM
         z5ZYIYNB+mlpEBl9sBzBRolHG7Yx3+2EF40h8OROZ84MuZBmCAzYXEQTZ9JnndTL099X
         1kt3U5mxrUuWMObEaEnq2OxxugbaUNS+7q6bvt8FUMFFyiHvP3+BKtw9gPp9q2Z/sVl5
         iGIA==
X-Gm-Message-State: AOAM531mjmCe6EB04OalbtRWOQT3w3sKBxP42VRO/nSp+vdsw9AwjXQf
        Vwh0PMkX8t1zXQEhut80lyk=
X-Google-Smtp-Source: ABdhPJwArssL1ay535AtfsHzBVBPQKtHIlzi5QmsOl87Sxjz2ddkdB/CWJP5hMppA3a8AKpAldyzyQ==
X-Received: by 2002:a17:907:d07:: with SMTP id gn7mr45794781ejc.272.1635878322793;
        Tue, 02 Nov 2021 11:38:42 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id dx2sm8448418ejb.125.2021.11.02.11.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 11:38:41 -0700 (PDT)
Date:   Tue, 2 Nov 2021 20:38:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] net: dsa: qca8k: make sure PAD0 MAC06 exchange
 is disabled
Message-ID: <20211102183840.44mmy5mklmuluct7@skbuf>
References: <20211102175629.24102-1-ansuelsmth@gmail.com>
 <20211102182655.t74adxlw3q3ctlas@skbuf>
 <YYGDYoToj2r/uYIE@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYGDYoToj2r/uYIE@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 07:28:50PM +0100, Ansuel Smith wrote:
> On Tue, Nov 02, 2021 at 08:26:55PM +0200, Vladimir Oltean wrote:
> > On Tue, Nov 02, 2021 at 06:56:29PM +0100, Ansuel Smith wrote:
> > > Some device set MAC06 exchange in the bootloader. This cause some
> > > problem as we don't support this strange mode and we just set the port6
> > > as the primary CPU port. With MAC06 exchange, PAD0 reg configure port6
> > > instead of port0. Add an extra check and explicitly disable MAC06 exchange
> > > to correctly configure the port PAD config.
> > > 
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > ---
> > 
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> > 
> > Since net-next has closed, please add
> > 
> > Fixes: 3fcf734aa482 ("net: dsa: qca8k: add support for cpu port 6")
> > 
> > and resend to the "net" tree.
> >
> 
> Oh sorry! I checked http://vger.kernel.org/~davem/net-next.html
> before posting and it does say it's open. Will resend sorry.

Closed or not, the point is that Jakub sent the "[GIT PULL] Networking for 5.16"
email today, so this code is no longer in net-next only.
