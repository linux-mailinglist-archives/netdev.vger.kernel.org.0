Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD936A6FA
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhDYMAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYMAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:00:05 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7638C061574;
        Sun, 25 Apr 2021 04:59:25 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e5so24281444wrg.7;
        Sun, 25 Apr 2021 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8KHdZTzB5dgfRAU0lEA2gt32lF1fprQam0jC3ww0W64=;
        b=Ai0jmEFjrPeSPkmccM78UE+jIsEWHopVHtT+OAXvx+K7fgTu8c7rgLsaF1smxnv7nI
         uM0uulHh3qvWpJXUOlH6lDS2vq8ESBv9iggElz9w5ClIO2AABUb4xhrYlg7UAAec1iph
         XuAjCAYWr4kZa2u+BiQ8/SkMqNdPjSobAu5wrr12ETj1LkQDhKYE6Y/bXykGtSQ8T83f
         Tr58KfAaA7VHR1xW3N6D2AZlP14jbt1xtbMSxBkl5GM72NJloomgBCvwxMATjz6v+sGA
         /Vc8q6PBv0wyEW2oyoUT92p+teN6c9T5RB6jiL6Oavk/92cK1pGLeqsBYDE1AcpHZ88m
         wzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8KHdZTzB5dgfRAU0lEA2gt32lF1fprQam0jC3ww0W64=;
        b=mndsSYVXDWVJ97nrRtfgl8prIzy9wHBnPEBlEmSJAmwFwTK+GUd8e5FY1Ln9Sx6qPZ
         HMGpfAs3M9jc7/Ro+L0wwOzaSNx5aK9SM9SvZxvRTsjNYldlfijoraeSKB8g+2znEFwX
         O8suVI0sYEyS9t0y+1i1ZS90aLyWnFN+nCJ0HlfofiaIBJtrrbU3nVP+w9WwJ76trUK+
         kveLlMmZNByXIv/unLHqY1w2aG4d3qYEujiMOS2S3upI18OF5bJouVAz763Zf4WASXah
         D4e7BjxaR+IHf4RlsmqqWMhdyswd3P2ckmJ3viTfQOAtFyGm3QrpG6y0x3kR1LidvkOd
         CJWg==
X-Gm-Message-State: AOAM533HMjLiLJ8X3xH+QPrVU8kydwCwZUoimwNcGEpWvDWEPK12HIue
        Md1zgwBAi6gyeX2uTZrhEthCkJSuHs9+gw==
X-Google-Smtp-Source: ABdhPJyE3dy+asCu9vuV8z6p85bA1GNmwIgLABXac/CwtbgRTksf3eK5UrRFs6ZgjwA/EhnNRIsHMw==
X-Received: by 2002:a5d:6a84:: with SMTP id s4mr877193wru.178.1619351964259;
        Sun, 25 Apr 2021 04:59:24 -0700 (PDT)
Received: from Ansuel-xps.localdomain ([5.170.104.9])
        by smtp.gmail.com with ESMTPSA id w22sm16469137wmc.13.2021.04.25.04.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 04:59:23 -0700 (PDT)
Date:   Sun, 25 Apr 2021 13:59:19 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] drivers: net: dsa: qca8k: apply switch revision fix
Message-ID: <YIVZl9qbXLcCrqNl@Ansuel-xps.localdomain>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-12-ansuelsmth@gmail.com>
 <e644aba9-a092-3825-b55b-e0cca158d28b@gmail.com>
 <YISLHNK8binc9T1N@Ansuel-xps.localdomain>
 <20210425044554.194770-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210425044554.194770-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 12:45:54PM +0800, DENG Qingfang wrote:
> Hi Ansuel,
> 
> On Sat, Apr 24, 2021 at 11:18:20PM +0200, Ansuel Smith wrote:
> > 
> > I'm starting to do some work with this and a problem arised. Since these
> > value are based on the switch revision, how can I access these kind of
> > data from the phy driver? It's allowed to declare a phy driver in the
> > dsa directory? (The idea would be to create a qca8k dir with the dsa
> > driver and the dedicated internal phy driver.) This would facilitate the
> > use of normal qca8k_read/write (to access the switch revision from the
> > phy driver) using common function?
> 
> In case of different switch revision, the PHY ID should also be different.
> I think you can reuse the current at803x.c PHY driver, as they seem to
> share similar registers.
>

Is this really necessary? Every PHY has the same ID linked to the switch
id but the revision can change across the same switch id. Isn't the phy
dev flag enought to differiante one id from another? 

> > 
> > > -- 
> > > Florian
