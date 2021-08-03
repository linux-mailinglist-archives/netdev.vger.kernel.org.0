Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3415F3DEA11
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhHCJxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhHCJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:53:52 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED7C06175F;
        Tue,  3 Aug 2021 02:53:40 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hs10so26815891ejc.0;
        Tue, 03 Aug 2021 02:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dgsj6CTDrsaNTpuA4GdhQx2YF7HuEDl0c2L0lnwehSY=;
        b=CfhcTcYDjwDTtd0VrShCAR8CfjBqkmBZqd99U5BYpH7XFXZl2i+HU/iiO1z9cJUHxM
         xdaQqQ+bn/GFYHCpooywv1Kj8p3Kx6FcFLKeqOhQ6OQ+qXoJilSp/1MrhjZtANAqDlbs
         2zxdVB+jCCypmZ5GrJxkQ7m1UsHwb7tJUj+R2pPqelqJLYi4DZkVYNhqNBDTTOzwJXKZ
         VLPi5py22alr6jHriUXQM43kxACoWCmwkGHddBD05zjeEL34Qz7Uu3bsV7xQYAh/ed/8
         A7IbqK/be9SxwRDA673bPvRyd4gJuSwF66KyjvtukgA1AUH4br0Z6PbHQDyQPDy3cH/z
         35ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dgsj6CTDrsaNTpuA4GdhQx2YF7HuEDl0c2L0lnwehSY=;
        b=BUv7IW6USsTZEHHOIQ8+/rwL2DzLwLR0q87SBX5KBZSlhrYNyoyq6mfFw8gmvh1byD
         lR55AQN7oLB+8DdMMLaUNkHC5D+9ucldwqoXT5RQ1Y9rFyjcVSBZJQ6yyRLgt6Pz4wKh
         M0ZOUmVHKx11Lqo/Tggr9my0i7FCOBolxF9R7/z+jdIXMrRdHJf6klJx85CbGf4/BgvU
         muEI3+J9Yeeufg8iufJ7OaU08MjE6M3AYWHWG2va+SOmHlMUBuaYkM6+D4fr4lOn8Zew
         ClSGDcLvmApoW83uHn8IXbCLuHpQqhkPR54oe2Xww3cUAbAfbyklGKZigFczf4zXQqju
         QJiQ==
X-Gm-Message-State: AOAM5318z+CD/+kgnT0t20j2ZYxDr+7ILFsETyoaCUKBApJO3DBPsGjH
        7ZbPK19SUatOGPdHsIy9tnQ=
X-Google-Smtp-Source: ABdhPJyWlHsbH/UsftZd2WIdgR05CFr2JSLN68JwopqLRoKcKe1kNzrhFJ3Wd2/hTP9dJ3TIHiblBg==
X-Received: by 2002:a17:907:2096:: with SMTP id pv22mr15815530ejb.443.1627984419027;
        Tue, 03 Aug 2021 02:53:39 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id b1sm6018136ejz.24.2021.08.03.02.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 02:53:38 -0700 (PDT)
Date:   Tue, 3 Aug 2021 12:53:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: dsa: qca: ar9331: reorder MDIO write
 sequence
Message-ID: <20210803095337.5x643xg3axpv5ixl@skbuf>
References: <20210803063746.3600-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803063746.3600-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:37:46AM +0200, Oleksij Rempel wrote:
> In case of this switch we work with 32bit registers on top of 16bit
> bus. Some registers (for example access to forwarding database) have
> trigger bit on the first 16bit half of request and the result +
> configuration of request in the second half. Without this patch, we would
> trigger database operation and overwrite result in one run.
> 
> To make it work properly, we should do the second part of transfer
> before the first one is done.
> 
> So far, this rule seems to work for all registers on this switch.
> 
> Fixes: ec6698c272de ("net: dsa: add support for Atheros AR9331 built-in switch")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

I don't really like to chase a patch to make sure my review tags get
propagated, but anyway:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

https://patchwork.kernel.org/project/netdevbpf/patch/20210802131037.32326-2-o.rempel@pengutronix.de/
