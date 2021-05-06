Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3E13752F9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhEFLVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbhEFLVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:21:52 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB69DC061761;
        Thu,  6 May 2021 04:20:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4581112wmc.1;
        Thu, 06 May 2021 04:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mvFbkvQ5VEcFaBQBYLgUC3qPOWAANW4uhpr/PRzv3bw=;
        b=pFNflUuaOWurwW49KEo8O3XL06LjXCHRNT+sDxviEulc90DqsaYtyJN+HYuB30g7Kr
         tkcgDaEVZJnPaepNLHRNkhKTLLylR1OND9ie5HinMCy9lXEDSaQepzRrmDAYaE5TuJCv
         sTV4TwbDl7jhkUyeL4Fw6MzkISXPKmaZ+nscPaNhSo62+17mFpno8U3KxZwJxOoBupJr
         fBN1s6M+qGTYIToMKKvriUtBuSmnHWWQ9YMNnzNBjgT3ZrN9n3Bi5MJ+4SRJolzQCctp
         qqEJae8PXeP4tvYqMkHJXTjGK1akmA6iRJNNVUpdjoe/ODEfsvYKSN26VC0LSYypk0TD
         SeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mvFbkvQ5VEcFaBQBYLgUC3qPOWAANW4uhpr/PRzv3bw=;
        b=biagKlK7yW+naGlJhIP4k145WcbtYn/jIOnbw68Kxyyucrv+JI7Essa4XY0TNwmkwC
         0PPF/rYKKBvH+5THtic62O5xUT+S/gPcg5vbsJdm8R1JkrTOxydbynLW446hR2miek1y
         d3L39Cco46AWSEBR/Er4wRQXFyPUt3N4Nl9HglFau1DVB74JJse5k0fzkQVJxfQ2VEeJ
         4L5Vu8Z6ju8iwSbfPiDw9UsTKG1HSxtAzoTM/P0hSq/NRf94nRQWfLCncFNLzc69cJ1t
         WGWlECSTCsqW+h1pu6c0MJQvOW7NZUWOH5E0077jqYHlcjE8Ps0/bMVIcf8Lj96ITcmH
         br9g==
X-Gm-Message-State: AOAM533V0I3spw1+/O7Ugy+ALjkWEpCLVlop5auWqDUnKkiZ0kmm3UWz
        dILccYvfOvc3j0MLHZdzSI0Y66hPve4=
X-Google-Smtp-Source: ABdhPJweankzTnYz84yyj1lHKrKrnDHLQgrSE9N4PTU1Dky9xvVRZJdxJesXH89VETdQ2GVOqCvZxg==
X-Received: by 2002:a1c:5945:: with SMTP id n66mr3390669wmb.139.1620300052494;
        Thu, 06 May 2021 04:20:52 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id n6sm3806323wro.23.2021.05.06.04.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:20:52 -0700 (PDT)
Date:   Thu, 6 May 2021 14:20:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 08/20] net: dsa: qca8k: add support for
 qca8327 switch
Message-ID: <20210506112050.gccgrck2i7ylsc5n@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:02AM +0200, Ansuel Smith wrote:
> qca8327 switch is a low tier version of the more recent qca8337.
> It does share the same regs used by the qca8k driver and can be
> supported with minimal change.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
