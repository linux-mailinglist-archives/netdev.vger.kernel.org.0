Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA613D9859
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhG1WZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhG1WZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:25:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00C3C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 15:25:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso6273185pjo.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 15:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PlIi2cixurYxAPAiuIl6BOiwCzVbLEKRb4x3h4Mu7CA=;
        b=WVNIXN3nYwOiXAuonilOD6LysCnlSvf7nNyBKevgmIVTpJQLCCqYq2HuOTvDh+kCe+
         tWlwijEjlVzi9zrJwBsbYH0cmn1RxqX9LmTa51VpcnhHd5AaT9mgDVYp7FjpDUuktFuE
         pwfN+VGfjU6iBz8VmJJS5+UPqxzuDOj9EMCXoWjOxxZYZ7xVu2ezZyaTNY69HU83O8ui
         afag75S33RIu7R2YKCkCLw6iBFKDzE3nBcPzJbVHuHqPhVAeG7RVWbouxAniVWPJ/Y1B
         tmpf4j6+9VKwYONj+dbmZmJUvuzsfq1v3o7Jx6te1QbcnVaEXOLyRrHGmyLa03JxgyyI
         ejDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PlIi2cixurYxAPAiuIl6BOiwCzVbLEKRb4x3h4Mu7CA=;
        b=FnhEjcjIuk8x4zV6HY7hKGYh8LhYGGtH99c62+3Qsn2XwILWEEaxe8TRnCWegiOUdo
         rYs3lxQqpTtcSGt2VgbiHhYt6PwrD07IS6rPz/mtxfnPhRMa7bJCTnf78CGE5CduELB7
         2yW860NQcfwSEDx+Wl/pjNTao1oNDHbFHrCXiThYOY2j6FsjY59RwYnxx9HHppRxIZYP
         MUrUnF5gSbpCP21pUiz9P/ygSLFBzpPc4COzsLt8iZE1OSnQHjvq9s7Uj3WSUuWxICnw
         havaFmesglx0zI4Br+7vJOgsDXOrBE2faIx+8HP4a/bQTvmw2s2CZNKaN4DDAc5udHc3
         L7eA==
X-Gm-Message-State: AOAM531CqQyBte5MLRhfCyG6KOKPy9TAnBw1vjqIvGc2AVxnJ7HNcixl
        CK+rGnsZz7A7xkyGcb470dc=
X-Google-Smtp-Source: ABdhPJz1Ic1QKhqoXWrvSgzH+mgq0MGuMaRGkyZueZlRtvckeRjquYo6WycxgyzRSCyHqyFNFaZ5pQ==
X-Received: by 2002:a17:90a:fa1:: with SMTP id 30mr11620597pjz.42.1627511100409;
        Wed, 28 Jul 2021 15:25:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t205sm1110267pfc.32.2021.07.28.15.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:24:59 -0700 (PDT)
Date:   Wed, 28 Jul 2021 15:24:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     George McCollister <george.mccollister@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time
 stamping
Message-ID: <20210728222457.GA10360@hoboy.vegasvil.org>
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
 <YQHGe6Rv9T4+E3AG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQHGe6Rv9T4+E3AG@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:04:59PM +0200, Andrew Lunn wrote:
> On Wed, Jul 28, 2021 at 03:44:24PM -0500, George McCollister wrote:
> > If I do the following on one of my mv88e6390 switch ports I stop
> > receiving multicast frames.
> > hwstamp_ctl -i lan0 -t 1 -r 12
> > 
> > Has anyone seen anything like this or have any ideas what might be
> > going on? Does anyone have PTP working on the mv88e6390?
> > 
> > I tried this but it doesn't help:
> > ip maddr add 01:xx:xx:xx:xx:xx dev lan0
> > 
> > I've tried sending 01:1B:19:00:00:00, 01:80:C2:00:00:0E as well as
> > other random ll multicast addresses. Nothing gets through once
> > hardware timestamping is switched on. The switch counters indicate
> > they're making it into the outward facing switch port but are not
> > being sent out the CPU facing switch port. I ran into this while
> > trying to get ptp4l to work.
> 
> Hi George
> 
> All my testing was i think on 6352.

Mine, too.  IIRC, the PTP stuff for most (all?) of the other parts was
added "blindly" into the driver, based on similarity in the data
sheets.

So maybe 6390 has never been tried?

Thanks,
Richard
