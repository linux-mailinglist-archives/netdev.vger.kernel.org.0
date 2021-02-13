Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB431AAE1
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 11:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBMKb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 05:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhBMKbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 05:31:53 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03EDC061574;
        Sat, 13 Feb 2021 02:31:12 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a9so3508646ejr.2;
        Sat, 13 Feb 2021 02:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KjvhHXpjdCsZRnabfXS9WYIUXjB54ZyXNRDtU9w/hp8=;
        b=FaUVVyzNj8vKQyYbTBvvjhTyKG0Hed09hcwDxd8jk3sivvdQTc4VgnNliXBJWVc/PV
         26ctSk9LQNyjoRM3MtxEVO+5ztZx6XnP/puwCGKPPaFZN/VG4KyownVohWQNOpXc3YDN
         ReWiskMmSt3nkpTouytqbIu9FjWcs7qIM461y1WMfi4acjXrIBr3Zsq+EhZi+SDlOKUe
         NV0Sk15NikK/MnMTMynUiNzGtoZQXg6IVpdfHnbrzCgunpLQFRMK42D/1iUhOEf3l4u0
         BN8v+kwWA43JKF7tRnpEC+QA+31bKpMmCxxaKSuMn93P9tah3qqu3Zq6mE8HMuv9Zns3
         xcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjvhHXpjdCsZRnabfXS9WYIUXjB54ZyXNRDtU9w/hp8=;
        b=MiT4jtFoIZPVSlhjd53X5WjqSZ/H0Aog4ef4UvQJLCe3+PuCoDvHFKaY5a2yX48Q/U
         oM4985DxAOIZtnDiYd17Fycvni96UgBouZFLrGJfCYlbT9b/HpklkxfwdTHFtdk4bYna
         ypxTLBs6+p+g8qMZn2pzpzwcGYo2rsA3l0eXr/CUWz5WYPhb4QayEuCIuKYObn18+0Km
         6h3nP7i4VDr3Sm7N0FFAzrnxg0g0pZo28VihG6YVSvT7E7BrJrzP3tVwIxsvjOvSWY0C
         jkiunw8HNirQfLPSGVMKwYDIto1qNwFxF3MwVyL/OJYysQUsnU8DkHc5YE7JbszflopF
         5cHw==
X-Gm-Message-State: AOAM530fcYsYQEJassJMs3OU2rvv0sgf5Q3rZ4MDkhIEOAiqJytBOT31
        WnxLcUlPrbjJI2vU/tPsM5c=
X-Google-Smtp-Source: ABdhPJzLZXBVeUWHb45DgHQTIKeSwN19ozE6isLoTlFnXPrGPk1xgnJD2wQukrsODPulDjK7HxkagA==
X-Received: by 2002:a17:906:f950:: with SMTP id ld16mr6980506ejb.248.1613212271524;
        Sat, 13 Feb 2021 02:31:11 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e22sm7614734edu.61.2021.02.13.02.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 02:31:10 -0800 (PST)
Date:   Sat, 13 Feb 2021 12:31:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
Subject: Re: [PATCH net-next v2 1/3] net: phy: broadcom: Avoid forward for
 bcm54xx_config_clock_delay()
Message-ID: <20210213103109.jffo5kbzsviqg5cf@skbuf>
References: <20210213034632.2420998-1-f.fainelli@gmail.com>
 <20210213034632.2420998-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213034632.2420998-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 07:46:30PM -0800, Florian Fainelli wrote:
> Avoid a forward declaration by moving the callers of
> bcm54xx_config_clock_delay() below its body.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
