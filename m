Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4F45675A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhKSBRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhKSBRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:17:14 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B2BC061574;
        Thu, 18 Nov 2021 17:14:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so35270608edd.9;
        Thu, 18 Nov 2021 17:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1n1HyPncdUTjIEpm1Cx9qSRpr21SBs9mEZlazYMpsaU=;
        b=kcKJ2iz54YE79iM/3bvWMFWhVGt86THHraacdRO1hkk9iNEC3g4ULFrsfbgRAIkHMn
         wW6tcraZwwdPrDXHJHUOr+KgGwfkv+UPJkR8/6BRVadfhesIwSgYMensxCzIMQxIRMg2
         g1oYr6tFxdg2RcKKgvmFJhlQ5RSljrBIBgwYl9O/fjl14iXxLiQdPIeMf/+vndm2bDE4
         acv8StLaX/hIfeDc5p08zrBS/nHZ9dNO1eFgR4MRuowshSG+JKMTbaaEFQryg5SY63ZV
         eaV8vQtw2imOn8Rc5/KbhIhuLAG4bqWXUijf2I/LjK5kAtPYHlpI+jRTObWM9+hlScqu
         0XOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1n1HyPncdUTjIEpm1Cx9qSRpr21SBs9mEZlazYMpsaU=;
        b=i7VWKzdw0x+KNTyZioSz5oG+s2aFjFf1HRwxN5xhxSjdfUjnZqzEq20DBNCBWFUemv
         aoOdzkEydqwpnhqQ5YBnjTIeXFxY1SoIFYtuFy+nHu7ZTEblZ2CPfEbcyd/hfq3CFJ8X
         n3OfJ1zKrGnfJgFKW2BdHwIw2gtfBJfASPyQyLgoWjmqORFvI8fYC4zYrvUht+95y47t
         dsiAsfjY7nt30xoe9X6qrndqxtnHkTuKS84MFr44FZm739P90iq2JmH6fO9MGYwnuFtC
         wGP229hzT5M/7ELfihoWjBacTG/Hmx6Ihw8uOQdoMRnub/SiaoCcoabfipSTD/R/AiyH
         vTpw==
X-Gm-Message-State: AOAM532gNSz/WBHReb/zN1KaMfqGXfxuKhd1s8qQ3YqDjl5+Ut/IECMr
        mEpvOkkfmOYmZm8m7WBGWbMt8wRpreo=
X-Google-Smtp-Source: ABdhPJzuA5AMUKd1K7p8fPIfjURHt8yur4dqlJ60NEOzAZLGm784bBNzv6O5B2Q004Nib6D3JpUCTA==
X-Received: by 2002:aa7:c155:: with SMTP id r21mr17908157edp.124.1637284452114;
        Thu, 18 Nov 2021 17:14:12 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id de37sm520006ejc.60.2021.11.18.17.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:14:11 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:14:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 08/19] net: dsa: qca8k: convert qca8k to regmap
 helper
Message-ID: <20211119011410.nvrfm72ccvp4psi6@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:40PM +0100, Ansuel Smith wrote:
> Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
> missing config to regmap_config struct.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

The important question is "why" and this commit message seems to omit that.
Using regmap will be slower than using the equivalent direct I/O.
