Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32483B93A1
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhGAPCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhGAPCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:02:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9E4C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 07:59:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kt19so4425857pjb.2
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 07:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UAGVLjB36MgxuPh8OdchWwkPgu9UBNarCKGBxlRs9jg=;
        b=H5Ik3qE01ivYt7AZdSXw24kR3XnOiLdmzMBx3FA3LYoLyhKEycteN8iAogGBlP7MCF
         Oq5QZ1YsWOBf7LHOg3Gow3bqLyqmxkhC5X1UrxSrwEwcTDUOXZgpn27I/AjFbbAhozev
         R3SHQ/BziWCnybVagwJvE01QbriC+uTT+KB342DcqWiUjfgW5DVDEkgNmrOSoIBxGXhj
         qnDU5E+ZgpCJ2TVhf2cgSGkqMK2fzfHuKWGd673hnVwCMpVeKHVJ2YmuEb8J5l1dAsFJ
         KIWwFdTWkut3pC0zYifXAHObBdEOpH/ggfKkhRWfYhdOsdQwu2nKGxYxp6KNIayItjmp
         N+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UAGVLjB36MgxuPh8OdchWwkPgu9UBNarCKGBxlRs9jg=;
        b=ctcRPMe9b892AC0O1+4GzoEfRcFVScpRpuzCh9+INdrdTBYEwLSdTKAqTIvkGFR/G6
         mypc/hLi/IqXLSqvCpAI4/SG73OyZs2zK0EQMwXbf7pULyaL9dd+WvUhXSFSG2Utv9fm
         mb+oOG8vY7Z5fajdtQN/BE3tivHIRaFgryd6cmVScwkgmGkPHHoUcpD0You0NELqZG8p
         yRwhj/rwGYGxddgoKDhirpDUVjxbc+qDQv6F/8h0yNwqFuMJTSx0iVDmpT25NvSWSUsk
         2mw6Z3aPpb0GIMYOBXI5LYOv5pBQzxskHnFkjqN/R5HS9Vod0mPZ+hlG/cklRrhSJmpm
         ZPpA==
X-Gm-Message-State: AOAM533YQiRd3/6TezUh2qM8I9kgdOUF8qP8J9O98NmR1apwUn/+KV/x
        vbqDtETjBdgwMmeaFk0KRaE=
X-Google-Smtp-Source: ABdhPJwZaRYvDHP44rGuFBgBZTgik8umrwftRPz/gB56xDShUaV/rd2eo8JutFl2aaSX3OK/dXqXXQ==
X-Received: by 2002:a17:90a:e7c7:: with SMTP id kb7mr10251622pjb.96.1625151578811;
        Thu, 01 Jul 2021 07:59:38 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w7sm128694pgr.10.2021.07.01.07.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 07:59:37 -0700 (PDT)
Date:   Thu, 1 Jul 2021 07:59:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210701145935.GB22819@hoboy.vegasvil.org>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:

> Since these events are channel specific, I don't see why
> this is problematic.

The problem is that the semantics of ptp_clock_event::data are not
defined...

> The code blocks in question from my
> upcoming patch (dependent on this) is:
> 
>     static irqreturn_t
>     ptp_ocp_phase_irq(int irq, void *priv)
>     {
>             struct ptp_ocp_ext_src *ext = priv;
>             struct ocp_phase_reg __iomem *reg = ext->mem;
>             struct ptp_clock_event ev;
>             u32 phase_error;
> 
>             phase_error = ioread32(&reg->phase_error);
> 
>             ev.type = PTP_CLOCK_EXTTSUSR;
>             ev.index = ext->info->index;
>             ev.data = phase_error;
>             pps_get_ts(&ev.pps_times);

Here the time stamp is the system time, and the .data field is the
mysterious "phase_error", but ...
 
>             ptp_clock_event(ext->bp->ptp, &ev);
> 
>             iowrite32(0, &reg->intr);
> 
>             return IRQ_HANDLED;
>     }
> 
> and
> 
>     static irqreturn_t
>     ptp_ocp_ts_irq(int irq, void *priv)
>     {
>             struct ptp_ocp_ext_src *ext = priv;
>             struct ts_reg __iomem *reg = ext->mem;
>             struct ptp_clock_event ev;
> 
>             ev.type = PTP_CLOCK_EXTTSUSR;
>             ev.index = ext->info->index;
>             ev.pps_times.ts_real.tv_sec = ioread32(&reg->time_sec);
>             ev.pps_times.ts_real.tv_nsec = ioread32(&reg->time_ns);
>             ev.data = ioread32(&reg->ts_count);

here the time stamp comes from the PHC device, apparently, and the
.data field is a counter.

>             ptp_clock_event(ext->bp->ptp, &ev);
> 
>             iowrite32(1, &reg->intr);       /* write 1 to ack */
> 
>             return IRQ_HANDLED;
>     }
> 
> 
> I'm not seeing why this is controversial.

Simply put, it makes no sense to provide a new PTP_CLOCK_EXTTSUSR that
has multiple, random meanings.  There has got to be a better way.

Thanks,
Richard
