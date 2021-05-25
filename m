Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61513900FC
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhEYMaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbhEYM3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:29:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491D5C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:28:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso12443653pjq.3
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 05:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=we12QyGJLIpM0jO39h0NAhXuggnm9KsPV9kAG0oC8uk=;
        b=uhaBdL5QeHzqE/rSgRf7YiBHNjM4flxtwjioqZNFPnRumyynh1qiuXsY6bSzaU4VlY
         4chX8PW/z4kthO6yhbc9pDxuS2p4Dej7S0gYlvV91KB+ql2MtAC6WufWd3RXMx740971
         OynzPguZteQTfIldTxFRDvHy35mzLegDfao81Pcs5+S/OBaVHRmQ4wHrFGUGo0LlH2i+
         0pssqt0uQigcI/g7GTJOrvNXNAMMJ9/lp20COKr9SJZ1fmihRNVlSCX5wL5cSPEi+p5m
         ZvitaxuDmm0qh0MH3ILZBWDTZPIPaSaqALkhMNUc19XZ/X+nzEJqX6y8C6zUZuYHJD0m
         /Bqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=we12QyGJLIpM0jO39h0NAhXuggnm9KsPV9kAG0oC8uk=;
        b=BrQdiS4n3J0w4zpdv04fy99WVwpLXDLyX5XCy/FNDrQ7Q655tP48ehuTQPgC2b4T9m
         vf33lEk0Vev/zd0KFcO4QILc3yvFzzUJGPUm9FN4ZXRAo3FGDWdpUbj1raZtUU/RRVJ9
         2bEjQB+PzULCnyg7AAG9buE/gNq/OmUc+jb2Buui2Snb/QFhKPeVwuIP5NMsIhkZgg/G
         TDLv3gGFpSUMAM+KYcbA3urA5lVZ8Myz3D/3oW14RF/X+emND6I7d+uvMYUBZU8O+IIt
         dq0CAer8P9jldH6m5O+EX98nNYR3934Yf0T1nt7MYNPjklvl0XIlTmKi0sx7T1b4HM6O
         8h5w==
X-Gm-Message-State: AOAM532OPPPcvlUhw3ek0AyNVMIkJeY2pmrYZCHnlmlclldM2Icx20mi
        NKFOXwWcwgjzpbR/7nbLAkJbUf/EoPQ=
X-Google-Smtp-Source: ABdhPJyyi4m4271/5bNyno0b89dYa5mtp0PQNMhEiH+kleKjsCAN3bkmIp+y4GlIWeanyuVl6c0YdA==
X-Received: by 2002:a17:903:3106:b029:ee:fa93:9546 with SMTP id w6-20020a1709033106b02900eefa939546mr30444656plc.23.1621945703766;
        Tue, 25 May 2021 05:28:23 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z19sm1947730pjq.11.2021.05.25.05.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:28:23 -0700 (PDT)
Date:   Tue, 25 May 2021 05:28:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 2/7] ptp: support ptp physical/virtual clocks
 conversion
Message-ID: <20210525122820.GA27498@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521043619.44694-3-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 12:36:14PM +0800, Yangbo Lu wrote:

> @@ -76,6 +77,11 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
>  {
>  	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
>  
> +	if (ptp_guarantee_pclock(ptp)) {

Going to need to protect against concurrency WRT ptp->num_vclocks.

> +		pr_err("ptp: virtual clock in use, guarantee physical clock free running\n");
> +		return -EBUSY;
> +	}
> +
>  	return  ptp->info->settime64(ptp->info, tp);
>  }

Thanks,
Richard
