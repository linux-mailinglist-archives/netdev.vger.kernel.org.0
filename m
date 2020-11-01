Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603A92A1BA9
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgKACCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 22:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgKACCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 22:02:32 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992AAC0617A6;
        Sat, 31 Oct 2020 19:02:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id r3so4982490plo.1;
        Sat, 31 Oct 2020 19:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dbp4d9VwR1A0nOp60T+uohgWaLBk9nOmKzpDG8Qbx/8=;
        b=ZLbgrhc+7nOSB8eh8mP31c2+KarmkUSuGXGAqbqJfB9ZvXOafCv1aGdwAd2Z6NP6G0
         dNW+T1uCn+qM8+XXrR5yhHLMAQ5XVPJGmOmDIT01hwyv6kCmgoJLWhntJOMwLJayQPuS
         vIsDH+r16BemiYtyCKrW3avwyqImz4svzyVsQo2AMKUGl8sLfscwU9triryPsJBKZ8Rj
         gxDF/h2j4bal60JLhR0xG7hDShl+Fh13S+YDNylh2m3GL9GTflkSOlpO1wWaTXD1uipl
         TBYKRLgdFWn6AzBd26cPRYU0Ka4YXmgz+0Rh2Wobh69Js55bBYxkIAXQy+7Kwffi2MiX
         CKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dbp4d9VwR1A0nOp60T+uohgWaLBk9nOmKzpDG8Qbx/8=;
        b=bmyiQCg2h+4rb6+enr3LgcLERQzE9W+DfVFLFyiZu/lewABnq0hIBN9l+nOLEmRECZ
         l+rcWZuBgG6f7vb6vuN5y4eY5klLX4SH/PmXoeX/23g9l+TXGISaSWcek4XUFjcquiSf
         PNFop+YFqqsDnVswKgrFTUvyz0lT1DgLpqccwDoJfjbJcp69hjfu0db9j3oY1AU/fjtm
         /JqI9+/d/FeUVMQxFE4sIfxy7xNhI75fShGj5j4JUGbNXNprqJ6Z5CtSP7FNMflGR/TR
         JlFRGz1oxZb8v01l1g4TKMcv5S/XC8ETsHsnu+bh6o6mx0dgRvB+rVM14paJIxezEKA0
         X6Ww==
X-Gm-Message-State: AOAM5304qlCXHrJxRhJUW+BX0lxGNsy1/dugOjcE20YnjrTvVMQZEELI
        h7K+PQBJfIXF81Thu8/KWa9MLYrHQCU=
X-Google-Smtp-Source: ABdhPJwHPjvIgQsUSXdGSRnIvPhUIFAs56oi/mTngVauv94fJGqREA2H1wsoJYVwm7tZXDG53t1SsA==
X-Received: by 2002:a17:90b:a4e:: with SMTP id gw14mr510551pjb.48.1604196150196;
        Sat, 31 Oct 2020 19:02:30 -0700 (PDT)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u5sm3008933pgk.80.2020.10.31.19.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 19:02:29 -0700 (PDT)
Date:   Sat, 31 Oct 2020 19:02:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw: disable PTPv1 hw timestamping
 advertisement
Message-ID: <20201101020227.GB2683@hoboy.vegasvil.org>
References: <20201029190910.30789-1-grygorii.strashko@ti.com>
 <20201031114042.7ccdf507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031114042.7ccdf507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:40:42AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Oct 2020 21:09:10 +0200 Grygorii Strashko wrote:
> > The TI CPTS does not natively support PTPv1, only PTPv2. But, as it
> > happens, the CPTS can provide HW timestamp for PTPv1 Sync messages, because
> > CPTS HW parser looks for PTP messageType id in PTP message octet 0 which
> > value is 0 for PTPv1. As result, CPTS HW can detect Sync messages for PTPv1
> > and PTPv2 (Sync messageType = 0 for both), but it fails for any other PTPv1
> > messages (Delay_req/resp) and will return PTP messageType id 0 for them.
> > 
> > The commit e9523a5a32a1 ("net: ethernet: ti: cpsw: enable
> > HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter") added PTPv1 hw timestamping
> > advertisement by mistake, only to make Linux Kernel "timestamping" utility
> > work, and this causes issues with only PTPv1 compatible HW/SW - Sync HW
> > timestamped, but Delay_req/resp are not.
> > 
> > Hence, fix it disabling PTPv1 hw timestamping advertisement, so only PTPv1
> > compatible HW/SW can properly roll back to SW timestamping.
> > 
> > Fixes: e9523a5a32a1 ("net: ethernet: ti: cpsw: enable HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> CC: Richard

Acked-by: Richard Cochran <richardcochran@gmail.com>
