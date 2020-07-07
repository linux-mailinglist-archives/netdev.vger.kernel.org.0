Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0555B2174D0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgGGRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbgGGRMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:12:37 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73834C061755;
        Tue,  7 Jul 2020 10:12:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so42950370eje.7;
        Tue, 07 Jul 2020 10:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aNHtEnZTBch7Gx2snrNsW2nZihsOuYVKYHNmbrByQHE=;
        b=H0B2tj6KRU1H65d/EX/QZh7QoFIjZB9LjerPIu2vCxPdtZVz06v/c2o38yX/wbsUG8
         jPTFDn/nwbTaHq6XAFmEvCqQxWvI0JTbJ8SRmOEECGE2P3KGBGsSe8kFHYFaiC0uTQQH
         wNrf61pY/74HHKvJ0QHGzFHYrig8h+uwSuhBZ6+QJSLlFRVIcohE2Ew/6Z/FtiWZ0HK5
         MT+KsFSd1AT3nzBYXBgI39d3/9XoOm2YhQJhZKZzIBAXSqSxsQw/r8Nhz5ft62to+bqU
         nsur5b8AiPmlUNBy7ujLi7w/GtS107i3YYqVMei8XcTTAHlwps57W+NwBs17tCy4Fics
         rnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aNHtEnZTBch7Gx2snrNsW2nZihsOuYVKYHNmbrByQHE=;
        b=WL8aHPDl25TCz/x8CdJuqqjSRONr7rqhT57oKqfUYIWgmdhLwvpUkcRx/IhpUCJtsS
         Bhtwl3vWPsczpz6i5y2gKZJqTJKrI8pFzvFvSQqXx1YtGTd03hqtTtC1BsrQgIeSh+PA
         5zmgxLLCxeuQRXiZ0F1qUsOv4Tck4sU2PkZCPEBZ4/Llxm1XhkfQCw1W2uIvryNfX3ZN
         zReXmkMPCXzvnl7MLeIBNdChPkafEHTOaNr8ABrSB/+y54l+vwtbHl6WoPcVjT1eKsCE
         AMTHFQMh1jrqdLEjmQXm38BtkEmlXosFsrsPt+6npPe4+8NOIKCKHzkn0xDK3JH44RYY
         f7ng==
X-Gm-Message-State: AOAM5309CRnU4indIRSDMllpWNcMr7Lmv1YP0UVQ5wgzGCsRyBJzPZ+u
        UJxOzO0Ax6Zr0z+OkyaaGP4bmSdr
X-Google-Smtp-Source: ABdhPJzFYjKB7uTbxIgb2hs7jwA+BQEiC1aYeNXr1irhFLajz+IRYfKoNgLm5mi413xRZ1o1lp7VEw==
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr34391898ejn.364.1594141956134;
        Tue, 07 Jul 2020 10:12:36 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id s23sm638297ejz.53.2020.07.07.10.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 10:12:35 -0700 (PDT)
Date:   Tue, 7 Jul 2020 20:12:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200707171233.et6zrwfqq7fddz2r@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <874kqksdrb.fsf@osv.gnss.ru>
 <20200707063651.zpt6bblizo5r3kir@skbuf>
 <87sge371hv.fsf@osv.gnss.ru>
 <20200707164329.pm4p73nzbsda3sfv@skbuf>
 <87sge345ho.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sge345ho.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 08:09:07PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Tue, Jul 07, 2020 at 07:07:08PM +0300, Sergey Organov wrote:
> >> Vladimir Oltean <olteanv@gmail.com> writes:
> >> >
> >> > What do you mean 'no ticking', and what do you mean by 'non-initialized
> >> > clock' exactly? I don't know if the fec driver is special in any way, do
> >> > you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
> >> > all return 0? That is not at all what is to be expected, I think. The
> >> > PHC is always ticking. Its time is increasing.
> >> 
> >> That's how it is right now. My point is that it likely shouldn't. Why is
> >> it ticking when nobody needs it? Does it draw more power due to that?
> >> 
> >> > What would be that initialization procedure that makes it tick, and
> >> > who is doing it (and when)?
> >> 
> >> The user space code that cares, obviously. Most probably some PTP stack
> >> daemon. I'd say that any set clock time ioctl() should start the clock,
> >> or yet another ioctl() that enables/disables the clock, whatever.
> >> 
> >
> > That ioctl doesn't exist, at least not in PTP land. This also addresses
> > your previous point.
> 
> struct timespec ts;
> ...
> clock_settime(clkid, &ts)
> 
> That's the starting point of my own code, and I bet it's there in PTP
> for Linux, as well as in PTPD, as I fail to see how it could possibly
> work without it.
> 

This won't stop it from ticking, which is what we were talking about,
will it?

Thanks,
-Vladimir
