Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F334C1B05CA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 11:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgDTJgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 05:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726307AbgDTJgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 05:36:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB9BC061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 02:36:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a7so3970958pju.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 02:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=3DGhAD7IJSYwN5Mh5wLkFIUQWPuH8Xyr5nhCfZdhrRE=;
        b=zBk0M5IVJTUHZhgTJvFVpuI50jKguU5uoGrX54baKAYHE3pFHiaWlt+kDCmF45FGY9
         J/qX6D+oHD+PEzRPiyyGOdn/sMaFkKT9QBk5NCK1xWLKcyQakpCQQtO8/2jrEXGU9t4V
         +srfyBTS/ERMCJSmCejLk0o/fWlPGPo0BXoUmxHqshzGIDuNT1PL6za/0tvgI/GltBWg
         +QjypSIht2By96xTrQ4Lifzuei9gj/dac64sJgtL/Gzyorq4BJUubtILITWTp+8Uo7Iv
         3lNXNiGJgIVg0JBWnfqJE3spIiCVVZ3YrQ7hNF1dXnp3SF34CzfbpsDcEPXuSKBCEpAA
         WLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3DGhAD7IJSYwN5Mh5wLkFIUQWPuH8Xyr5nhCfZdhrRE=;
        b=o6eBeMmh/blNquedKXsnesaacbP7Xo7dvYbgXwpZQHatoYgQI+chLEMRmJM2VUyjga
         MkNd3AcVesSvX7VLbpUwTctbd4rYrpoxFSpLG2/3b88QCQ7BeWxBzQ0BhvtzLzXKpQaD
         iOWyyfkAZJzrwIDE70X61WRc/W0lE8pZGtO6FjC8DF0NXP7s46idC+78eJR4U/emEPaV
         uWara+NWzRGO2wklRtRV1xjOcweqDfqH7HGGPI8dvZ6E/CdEE9hcACcL3e6iliwYwbY1
         XDFUEhG5WgJx5y2h77glZukWYGFY4hvJ8jo7rQ+7hmJUC/rP3IgzC6MSypclotHz+YfS
         7loA==
X-Gm-Message-State: AGi0Pua1SMBHLdZ+w9eYrnCv9eN1K5E2NYelw3cA5EYbhicADyFpnUqN
        vRNTakt4j51f0wA6i66Rfo7z
X-Google-Smtp-Source: APiQypIFyoGdo5N2UATcTDeToHVhHOExE0hyeqDVi9r+wjICYlrbxxJlpXV9YK979M9CMtO6YnDT+Q==
X-Received: by 2002:a17:902:b101:: with SMTP id q1mr15411011plr.246.1587375379433;
        Mon, 20 Apr 2020 02:36:19 -0700 (PDT)
Received: from arctic-shiba-lx ([47.156.151.166])
        by smtp.gmail.com with ESMTPSA id u21sm677223pga.21.2020.04.20.02.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 02:36:18 -0700 (PDT)
Date:   Mon, 20 Apr 2020 02:36:10 -0700
From:   Clay McClure <clay@daemons.net>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Message-ID: <20200420093610.GA28162@arctic-shiba-lx>
References: <20200416085627.1882-1-clay@daemons.net>
 <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 02:11:45PM +0300, Grygorii Strashko wrote:

Grygorii,

> > CPTS_MOD merely implies PTP_1588_CLOCK; it is possible to build cpts
> > without PTP clock support. In that case, ptp_clock_register() returns
> > NULL and we should not WARN_ON(cpts->clock) when downing the interface.
> > The ptp_*() functions are stubbed without PTP_1588_CLOCK, so it's safe
> > to pass them a null pointer.
> 
> Could you explain the purpose of the exercise (Enabling CPTS with
> PTP_1588_CLOCK disabled), pls?

Hardware timestamping with a free-running PHC _almost_ works without
PTP_1588_CLOCK, but since PHC rollover is handled by the PTP kworker
in this driver the timestamps end up not being monotonic.

And of course the moment you want to syntonize/synchronize the PHC with
another clock (say, CLOCK_REALTIME), you'll need a PTP clock device. So
you're right, there's not much point in building CPTS_MOD without
PTP_1588_CLOCK.

Given that, I wonder why all the Ethernet drivers seem to just `imply`
PTP_1588_CLOCK, rather than `depends on` it?

In any case, I was surprised to get a warning during `ifdown` but not
during `ifup`. What do you think of this change, which prints an error
like this during `ifup` if PTP_1588_CLOCK is not enabled:

[    6.192707] 000: cpsw 4a100000.ethernet: error registering cpts device

--- 
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 10ad706dda53..70b15039cd37 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -462,8 +462,8 @@ int cpts_register(struct cpts *cpts)
        timecounter_init(&cpts->tc, &cpts->cc, ktime_get_real_ns());
 
        cpts->clock = ptp_clock_register(&cpts->info, cpts->dev);
-       if (IS_ERR(cpts->clock)) {
-               err = PTR_ERR(cpts->clock);
+       if (IS_ERR_OR_NULL(cpts->clock)) {
+               err = cpts->clock ? PTR_ERR(cpts->clock) : -EOPNOTSUPP;
                cpts->clock = NULL;
                goto err_ptp;
        }

-- 
Clay
