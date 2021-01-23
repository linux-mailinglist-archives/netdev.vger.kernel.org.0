Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE2301261
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbhAWCqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAWCqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 21:46:18 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3800FC06174A;
        Fri, 22 Jan 2021 18:45:38 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id y72so1381447ooa.5;
        Fri, 22 Jan 2021 18:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ac67bof6xx2niPfUiSINB6obuW30Yl6gKBcDMoWsLps=;
        b=TWN6/5tuWN09KxgXYis9xL/sf/taqvDK0zdsYvN+n1dExITRtPFMkOIm3wSZAY8TWm
         Y5xa2UWBCL6g504k79tvABTp8lmJDBqAMf5UfNJSvVJwN2QvrvDrXKcpcDCY2zmdT8Bd
         iyPk9Xk1E95TdaLSUH7yS1ffetKZ03d0BVZ0TP/TdrxoLBRWDNP7UvNFjXeMQiMGHNFZ
         1naUo7A0Xkr4d487BrJ4MlbL5gJngwW5AMu+pUkqSzpn4Vr9Q8O6bP3sm/4ID+8pyimO
         R2rABPoAxRAjVX+xAAKaqRyWNTLRtgKjCBB76QtZwaEtWZTQW/CogItTLQz7D+SJ4DIz
         A6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ac67bof6xx2niPfUiSINB6obuW30Yl6gKBcDMoWsLps=;
        b=EyizBKiENBDc5nJrapPkHceGXn83b6JVDrToEXMiGedEC96pdnjGSJ2xbOkaGYno7/
         NcqYNjaHDLcBs1osLu0BVDsIfYC+diGOjNexcE8Ce7AbicWnOT4oVuotlCqW43YBMjIq
         4Bbt9w5OtvXUXBCNpkAwYOgT5Dp6Lc38mZK2OYNoTnWHRVtg46Av9p177bmblrAohS0t
         cjByGRpr7ReHCeuMNuKtG3SCDpuxO8ol9NG9F2rmYBwRyMDdrs+ROct+IdrafxLFP4tD
         YuSY4UsQ6QXIFEJBKP5+tLTZrMcXSvKC9QkB6OlWl0cVgh5b5UVLZn3APzPGD8wCo9hs
         5rYw==
X-Gm-Message-State: AOAM531fpAan+3GpevpseVT6xxNu968VtlwFuqq+QruqQJ2Wkj+xcb4W
        VPy+6yjHUt4DT6sTiziiZDVAYBpoBOw=
X-Google-Smtp-Source: ABdhPJxPTWoTqktvaTj7Ftm4EJGhuIkXezC57/bN1fUjiFaBslTZobb454ArpI9WqLZ1GseWOKbR4g==
X-Received: by 2002:a4a:e9f2:: with SMTP id w18mr5917373ooc.88.1611369937632;
        Fri, 22 Jan 2021 18:45:37 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id h203sm2109175oib.11.2021.01.22.18.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 18:45:37 -0800 (PST)
Date:   Fri, 22 Jan 2021 18:45:34 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmail.com
Subject: Re: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210123024534.GB100578@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
 <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210123022823.GA100578@localhost.localdomain>
 <20210122183424.59c716a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122183424.59c716a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jakub:

On Fri, Jan 22, 2021 at 06:34:24PM -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 18:28:23 -0800 Enke Chen wrote:
> > Hi, Jakub:
> > 
> > In terms of backporting, this patch should go together with:
> > 
> >     9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> 
> As in it:
> 
> Fixes: 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window
> 
> or does it further fix the same issue, so:
> 
> Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
>
> ?

Let me clarify:

1) 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window

   fixes the bug and makes it work.

2) The current patch makes the TCP_USER_TIMEOUT accurate for 0-window probes.
   It's independent.

With 1) and 2), the known issues with TCP_USER_TIMEOUT for 0-window probes
would be resolved.

Thanks.   -- Enke



