Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E235A7E7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhDIUfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhDIUfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 16:35:02 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C78C061763
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 13:34:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5-20020a05600c0245b029011a8273f85eso3618905wmj.1
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 13:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GK004sInYOHhof1JjWwDmtxkvocHoAqUdiyoZCy6woQ=;
        b=DsaK/ksXSYFy5TQESsIcYaDH1xnAyDRN/6IFq4K7Kvi3MFz/FW25kQ+/etDudYyrFE
         w7/L2zWEGy1A5rYfMcGqIejCbPI4WHyBECY0DENOu0U2n6pLcDBQBFgwm7TD7raehWlr
         GOifn2zCe2+B41LrA13oG1d87i1a+twTsbtS5V/f5ymXQ7whX9H0NDJu67P91uoNPVt0
         Gw/HNy9InG5lDJeIPXfvWPQ3oX15SrYG7uOAohIDc2mLVPhS8oOWUSpkKNrZcnIGvybJ
         EtZLi7wKsnKsTiVR6GCgKaGTINGG9CluyuKPIL891QC+0WjFd5Fjuvg5oSGR7b97bYNV
         9zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GK004sInYOHhof1JjWwDmtxkvocHoAqUdiyoZCy6woQ=;
        b=HdBSkpQqJ4Y1AJod1k+RUAhL7C+beCB/mzqDMvpCaRBmqHf2JQp9gSGnqFVcpEJmoH
         i9xPwKPq9wPTvqWJWJiq6igFW3UvpkaoY/XYq8Pj4RektPWI8CMyqphS9qdZpM2KljZD
         9g9D+FmswcrKvP1Dz6tnJwdgN03UK63WVEKX5JwibkBgic9TiLhPACm/Um5Uxqlz4E95
         QGqT7sGdy7xbyG7D5FzJFo3QX3AekEpe8FWADYO98DrtHhbQQMPDVYIoQTS6g5mtD1DL
         OPPOVw7L95OnY2N0qKQrf9t89c8zGQuQ1qthRCyg80py7gu+5Oo+Tg0oLUkJ82yoXNzj
         e8Cw==
X-Gm-Message-State: AOAM532k0jFQejFv5kdLqUdcV/S96Lm4vr+nT7vWLneUbgvH/o2vn2Q9
        kk3DiSxJrdnTXY52IAldlJvJJg==
X-Google-Smtp-Source: ABdhPJzhzAmdoRgX7Z9FeNTyzivW1OfJZckdBKDyuHCQX1MVDLuIUgMajLC1PgBgHtUAqtYz7bb0qQ==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr15275493wmk.52.1618000486973;
        Fri, 09 Apr 2021 13:34:46 -0700 (PDT)
Received: from apalos.home (ppp-94-65-225-75.home.otenet.gr. [94.65.225.75])
        by smtp.gmail.com with ESMTPSA id l13sm5511003wmj.3.2021.04.09.13.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 13:34:46 -0700 (PDT)
Date:   Fri, 9 Apr 2021 23:34:43 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/5] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YHC6Y0jSte0fWygK@apalos.home>
References: <20210402181733.32250-1-mcroce@linux.microsoft.com>
 <20210402181733.32250-4-mcroce@linux.microsoft.com>
 <20210409115648.169523fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YHCknwlzJHPFXm2j@apalos.home>
 <20210409122929.5c2793df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409122929.5c2793df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 12:29:29PM -0700, Jakub Kicinski wrote:
> On Fri, 9 Apr 2021 22:01:51 +0300 Ilias Apalodimas wrote:
> > On Fri, Apr 09, 2021 at 11:56:48AM -0700, Jakub Kicinski wrote:
> > > On Fri,  2 Apr 2021 20:17:31 +0200 Matteo Croce wrote:  
> > > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > Co-developed-by: Matteo Croce <mcroce@microsoft.com>
> > > > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>  
> > > 
> > > Checkpatch says we need sign-offs from all authors.
> > > Especially you since you're posting.  
> > 
> > Yes it does, we forgot that.  Let me take a chance on this one. 
> > The patch is changing the default skb return path and while we've done enough
> > testing, I would really prefer this going in on a future -rc1 (assuming we even
> > consider merging it), allowing enough time to have wider tests.
> 
> Up to you guys. FWIW if you decide to try for 5.13 the missing signoffs
> can be posted in replies, no need to repost.
Thanks! but...
I think I prefer another repost, including mm-people on the list as well (and
fixing SoB's).
I just noticed noone is cc'ed and patch [2/5] adds a line in mm_types.h

/Ilias
