Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABBF3773CA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 21:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEHTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhEHTSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 15:18:23 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E061C061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 12:17:22 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k19so10537694pfu.5
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 12:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=alWosC8jjcsBfiktvQLzMN0NeLEI0Z3u1S1DtJwK6SA=;
        b=aBJJHUyGUyUdWVbSOO4wStk5d7mmUYsb2Ytkc71TjZg8y0+plbISYDmz91xyRAY1JT
         E1wleY+4GlQGPQPm9aYGki6abukX8xnK5qyPvPGx4ek7jP6+1VmJyWYWVLBhpOIcvV2+
         5t1nvpf9s5fxDvNyUFdy4rlKhGsDiHDrimtWsUwSN0t2HU9/t0v4awxYTsHCM/TK711U
         3b2zwdPzoT7pI8LUG0Rqznd+iD2l1InfqcTcBmU97Ci9Za8D43Nq6RhDbV1rGRUBxaRd
         gzZ+cR/k4ViK2/nmFPXnKioB1vo9ey8OS/YHD9gey0dcHQpaI1E50KTCwLrgpVQKrNSY
         jkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=alWosC8jjcsBfiktvQLzMN0NeLEI0Z3u1S1DtJwK6SA=;
        b=ZMx9WRnnXFmeXPojODUfdAAcVTfgufvFcZ25DX51IStGkFVsSppOKyexT+oQTLBNw8
         RSr3K43R1DPV9wSF+ppuz4+CY2mXDaI9/6wKlLoJAygidZ9B1t+bpMZ3atbbW9KIp77E
         3iVgAEISUc+7wt3nGHauUuVjhk6hreiGHSVSRizLhAzGb9G1L8e8vriQ1VQndb2XkYoo
         8uOoUZPJzgJ8JHeVF6oI4C9gzyUN71BqviCXKy9I7QCPceiLFuhGHg+oJAGLHsm+iWJQ
         aN9IMdkVu8L9J/F96mJALlglHQBPr7jJ6z0n8v4gy1vbOW3pUBAmi47T5fPDo58jWukR
         gyug==
X-Gm-Message-State: AOAM530sJ4j6HqOZwUXxszzZyGxKN0w2PEwoi4+gX0uwnhSrUmUojgD/
        KiSrOnfFZb+HFvPgMrZlXys=
X-Google-Smtp-Source: ABdhPJy3Nj4l4w1qSXkzxEQyplS8uZJC4ndIkoM7JAQJ7iscGRXZuS/LTE+K/L6WPJXt32OGWI65dw==
X-Received: by 2002:a62:1d8a:0:b029:24c:4aa1:ad01 with SMTP id d132-20020a621d8a0000b029024c4aa1ad01mr16642818pfd.27.1620501441471;
        Sat, 08 May 2021 12:17:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f15sm7328157pgv.5.2021.05.08.12.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 12:17:20 -0700 (PDT)
Date:   Sat, 8 May 2021 12:17:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next 0/6] ptp: support virtual clocks for multiple domains
Message-ID: <20210508191718.GC13867@hoboy.vegasvil.org>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507085756.20427-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 04:57:50PM +0800, Yangbo Lu wrote:
>   ptp4l -i eno0 -p/dev/ptp1 -m --domainNumber=1 --priority1=128 > domain1-slave.log 2>&1 &
>   ptp4l -i eno0 -p/dev/ptp2 -m --domainNumber=2 --priority1=128 > domain2-slave.log 2>&1 &
>   ptp4l -i eno0 -p/dev/ptp3 -m --domainNumber=3 --priority1=127 > domain3-master.log 2>&1 &

> - Make changing on physical clock transparent to virtual clocks.
>   The virtual clock is based on free running physical clock. If physical
>   clock has to be changed, how to make the change transparent to all
>   virtual clocks?

Yes, this is a serious defect of this patch series, and there is no
way to fix it.  In the above example, suppose that domainNumber 1
needs +11 ppm and domainNumber 2 needs -12 ppm.  You can't adjust one
clock in two different ways.

>   Actually the frequency adjustmend on physical clock
>   may be hidden by updating virtual clocks in opposite direction at same
>   time. Considering the ppb values adjusted, the code execution delay
>   will be little enough to ignore.

Assuming that the frequency offset is exactly the same on all domains,
which will very often be false.

>   But it's hard to hide clock stepping,
>   by now I think the workaround may be inhibiting physical clock stepping
>   when run user space ptp application.

That won't work either, because a phase offset on one domain will
result in a large slew at the maximum rate, but that rate would spoil
the other domains.

The best way to support multiple PTP domains simultaneously
is in the application.  It is really the only way, because the kernel
does not handle any details of the PTP, like domainNumber.  The kernel
only provides clock control and packet time stamping.

ptp4l does not handle multiple domains today, but it definitely could
be added with some effort.  It would have to synchronize the clock to
one chosen domain, and track the phase and frequency offsets of each
of the other domains with respect to the chosen domain.  Having done
this, the software can convert time stamps between the domains
perfectly.  Using the tracked phase and frequency offsets, it can also
switch domains seamlessly without hacks or guesswork.

So I have to say NAK to this series because it can't do any of that,
and it cannot be made to work either.

Thanks,
Richard
