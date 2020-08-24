Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1896524FC26
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgHXLA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHXLAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 07:00:01 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3B7C061573;
        Mon, 24 Aug 2020 04:00:00 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id j25so2125030ejk.9;
        Mon, 24 Aug 2020 04:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wURfUL1E5T5G5zAtpp5gFw8NGNP7EBRkkT26Hn99rX4=;
        b=EQVbPJt2lR/3QwZovyxFsOzDX8o+E46tU9mik1qQ++52BWgAfjcjbjF9tQ3fzLBiF8
         Wn8i+XI/Rx6tKExYWM7XK+3XmWqcQ4Gf191vbyFMDoxKDWXYkh50R6ZkO/K8vWbbV2ia
         QElt81XQGHqyUVhTUO2vOBJGDHkl7cbtcaHVGL3F8cRSUjAA4IacPAb1MopfZ+Uhgx1O
         8UgoSZgOFmhw4xEc0JLcI/kRGxRjxh+cz6QzYPrFCPY0n/I082ojwal4MVamqTQsh3TR
         /bDhxLVQyqLLgri9IEbaDhQeY+ddEUZYB9DfOeBtx4BPj50Xd8mi735rb1zgsLQ7MrqW
         SL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wURfUL1E5T5G5zAtpp5gFw8NGNP7EBRkkT26Hn99rX4=;
        b=BAmJNu+Q6nzslxD0I0ea+XEipK1qCNavfCcLpw3/Hu7ZVT7JNke06txBeXK2/KhNJQ
         sifrcMB93xIC48meOfI29xKDZN6igrlZy+BHt16S63nNp4/+cuLndere/f35iUtraKsM
         iKjLl16YWjIDPqtSiO0BR5UjfDcNEq4+Q+8LkJMcXVhLIcpS3yafdml3WRDemT9JrqC0
         x3Z+bUkiBYRTBAnIVBiKz3tBo5dMlDXJqP0CW6m/ZgQ3C8D4VNdDyApalfC+a+w/AN0m
         LeQNo8O7raap0lppzEYzq5azivwRW65tVZOpkj/5G5zaO0CNV0gQFYuRndIpBM5zzoZv
         i8qw==
X-Gm-Message-State: AOAM531WjxAbdEkbXPA8jvL62bEBRdlEwQx0l4+G9D23VemcPzybjjZl
        UU8FFYVqCw6Ci8kjXlOHLCM=
X-Google-Smtp-Source: ABdhPJwzRYW0prDIEUuFJxaVv29Jwxwx6HiYbSRC4xi8TfKhYZC2RVakGKAGITZuJS41xlZzsc0BlQ==
X-Received: by 2002:a17:906:403:: with SMTP id d3mr4881944eja.522.1598266799343;
        Mon, 24 Aug 2020 03:59:59 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id l7sm8926447edn.45.2020.08.24.03.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 03:59:58 -0700 (PDT)
Date:   Mon, 24 Aug 2020 13:59:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Jiafei.Pan@nxp.com,
        kuba@kernel.org, netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] enetc: use napi_schedule to be compatible
 with PREEMPT_RT
Message-ID: <20200824105956.7urh3wkzd45ror3r@skbuf>
References: <20200803201009.613147-1-olteanv@gmail.com>
 <20200803201009.613147-2-olteanv@gmail.com>
 <20200803.182145.2300252460016431673.davem@davemloft.net>
 <20200812135144.hpsfgxusojdrsewl@linutronix.de>
 <20200812143430.xuzg2ddsl7ouhn5m@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200812143430.xuzg2ddsl7ouhn5m@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Wed, Aug 12, 2020 at 05:34:30PM +0300, Vladimir Oltean wrote:
> On Wed, Aug 12, 2020 at 03:51:44PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2020-08-03 18:21:45 [-0700], David Miller wrote:
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > > The driver calls napi_schedule_irqoff() from a context where, in RT,
> > > > hardirqs are not disabled, since the IRQ handler is force-threaded.
> > …
> > > > 
> > > > Signed-off-by: Jiafei Pan <Jiafei.Pan@nxp.com>
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > Applied.
> > 
> > Could these two patches be forwarded -stable, please? The changelog
> > describes this as a problem on PREEMPT_RT but this also happens on !RT
> > with the `threadirqs' commandline switch.
> > 
> > Sebastian
> 
> I expect the driver maintainers to have something to say about this. I
> didn't test on stable kernels, and at least for dpaa2-eth, the change
> would need to go pretty deep down the stable line.
> 
> Also, not really sure who is using the threadirqs option except for
> testing purposes.
> 
> Thanks,
> -Vladimir

Do you think that this type of request is something that AUTOSEL can
handle?

Thanks,
-Vladimir
