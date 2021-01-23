Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2B301241
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbhAWC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbhAWC3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 21:29:07 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DAFC06174A;
        Fri, 22 Jan 2021 18:28:27 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id r189so8271883oih.4;
        Fri, 22 Jan 2021 18:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BsDzyWGQpODPbH1iLNKpROubuzOQsoIWVH4nNscjPfc=;
        b=W7FPwbwJ/Tu4gxGZ31mbzZ342RijhVm5CNSuhNdCBaLdw3RLkh6EwPpBpPxxOvssOp
         Xf5e1kcF8su5TCDN1a5MRU9TKLMuF4btTCWUJRR3o/KCga+e+prQRT9AYLE+yUbwoRDD
         JMs3CmXeSZjRyAO8dQTBS+4IfzaEVMKg5+ufZknb1yNC2R172t/xeF6Fh8tjaTvh9s96
         E1zseTc4URIdrqWzg30zhW2ZpwEt01c7TIwhWEORsmK5p6jCtJYa56Qy740TPL21gTsr
         i/aOwEEu0gbjM70bcOaZkanEBHIn1jjpIALpiGo41GSrTJhqcA/ol3cBcrtJJPsGIZDH
         C8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BsDzyWGQpODPbH1iLNKpROubuzOQsoIWVH4nNscjPfc=;
        b=YWz/zjxOEy97xxTLIiOis3bxV8FrXdRsMYlAEUniHqB/IcVYOcKUIBIGnIlrrq23o8
         wtZdqnOVk9Ot2BpPtqPt0bav3eVsPKoi+sPzpDZmEaC71o0yjVjDXdkfIxESeH10U6j1
         yyGxgaM99TQj0A4dwTBOuL78ndHxsLyg+tSMHQcN+PAn7sC0JBanu0x/GCqjZB7KtqVC
         ISRGQbKO9oDMfd/H2s+4R6kV2Ja+2daHsmJNb2gSBfIn0e+6dQrRyliRrkVt+9HngWGq
         yZGn357vdwQ1uGHO7qLZlc5tU8xTJCxSxSHT5vWCtDde0p66fTp5ZEZ3wy9BoINF91SO
         rxMQ==
X-Gm-Message-State: AOAM530trS7Dh6RW6pW50dQQWVvzvHdd5lP/OLpOUzjCFmsaNaz8K1Eo
        qo7Vjelapc5kgxsvOenRCks=
X-Google-Smtp-Source: ABdhPJxgYFnXQg2ZTCgtcmNrP0OktrCUPaah9P6i71SwQfx/LEdU42a19tF7Fo3pmrYZvV+u1+uO6w==
X-Received: by 2002:aca:a844:: with SMTP id r65mr5162645oie.35.1611368906406;
        Fri, 22 Jan 2021 18:28:26 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id i126sm2078627oif.22.2021.01.22.18.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 18:28:25 -0800 (PST)
Date:   Fri, 22 Jan 2021 18:28:23 -0800
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
Message-ID: <20210123022823.GA100578@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
 <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jakub:

In terms of backporting, this patch should go together with:

    9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window

Thanks.  -- Enke

On Fri, Jan 22, 2021 at 05:43:25PM -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 11:13:06 -0800 Enke Chen wrote:
> > From: Enke Chen <enchen@paloaltonetworks.com>
> > 
> > The TCP_USER_TIMEOUT is checked by the 0-window probe timer. As the
> > timer has backoff with a max interval of about two minutes, the
> > actual timeout for TCP_USER_TIMEOUT can be off by up to two minutes.
> > 
> > In this patch the TCP_USER_TIMEOUT is made more accurate by taking it
> > into account when computing the timer value for the 0-window probes.
> > 
> > This patch is similar to the one that made TCP_USER_TIMEOUT accurate for
> > RTOs in commit b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout()
> > helper to improve accuracy").
> > 
> > Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> > Reviewed-by: Neal Cardwell <ncardwell@google.com>
> 
> This is targeting net, any guidance on Fixes / backporting?
