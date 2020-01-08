Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0B7134848
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgAHQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:44:01 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34672 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgAHQoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:44:00 -0500
Received: by mail-oi1-f195.google.com with SMTP id l136so3205943oig.1
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:44:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7YudrN+HcdAitESoUxkwkQAilxZS2k+YB5rlrRgMBQ0=;
        b=Vq71Xu2W++feGBM0vyHXxCYOFqC8ZZGVo7LYygbWrQ/WoxuGMt3GwXsgRYFlYxk5Ae
         C2tH5n9jMnlyClZ6NBlNWcHMmmunt4t9wicJck6v5upVkkg6AhxLkESwR02U8hltat3S
         qzBe5jNwrnVNuwHeUg6MU/OOTo8jDM6S7D4siPOpOaOKnVVN/SGcYKjCy5zdhPn68kT9
         dtZV78AZys9UpZAl6j0cGFf+hQZKJLfLNFGxpyftC8TvMCz8n/BxsGjkNqHbCx0sui5g
         DTcnuvPb8BYA0W6lM/aqF9Ct2Wv6+ErmAfVqnBiAPXuqvWKcBKnsX7Sf+8F3J9+hkJjE
         uU2w==
X-Gm-Message-State: APjAAAUz9EG+8BV+aSoA9LM7D/ozwT49KdqTpIkMIPFIZwr7VT7M8DAm
        GbFSf1l0248KTEC5a937YEOkewU=
X-Google-Smtp-Source: APXvYqy7wrq3omGb4YmdEI5OKvlOg+1dWF9JTkhFxYdZkQvxXeMaT/WlTagvl4lmOc3q0drFCs1PUA==
X-Received: by 2002:aca:8d5:: with SMTP id 204mr3585113oii.141.1578501839929;
        Wed, 08 Jan 2020 08:43:59 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o20sm1228209oie.23.2020.01.08.08.43.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 08:43:58 -0800 (PST)
Received: from rob (uid 1000)
        (envelope-from rob@rob-hp-laptop)
        id 220333
        by rob-hp-laptop (DragonFly Mail Agent v0.11);
        Wed, 08 Jan 2020 10:43:57 -0600
Date:   Wed, 8 Jan 2020 10:43:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Fix compile warning about
 of_mdiobus_child_is_phy
Message-ID: <20200108164357.GA17209@bogus>
References: <1577442659-12134-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1577442659-12134-1-git-send-email-yangtiezhu@loongson.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 06:30:59PM +0800, Tiezhu Yang wrote:
> Fix the following compile warning when CONFIG_OF_MDIO is not set:
> 
>   CC      drivers/net/phy/mdio_bus.o
> In file included from drivers/net/phy/mdio_bus.c:23:0:
> ./include/linux/of_mdio.h:58:13: warning: ‘of_mdiobus_child_is_phy’ defined but not used [-Wunused-function]
>  static bool of_mdiobus_child_is_phy(struct device_node *child)
>              ^
> 
> Fixes: 0aa4d016c043 ("of: mdio: export of_mdiobus_child_is_phy")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  include/linux/of_mdio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

A similar patch was already applied.

Rob
