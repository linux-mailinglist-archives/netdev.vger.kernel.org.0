Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE6645DF81
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhKYRWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbhKYRUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 12:20:12 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD6FC06173E;
        Thu, 25 Nov 2021 09:05:21 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id w1so28331322edc.6;
        Thu, 25 Nov 2021 09:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rQkOTwt9uzrTb00l0feBsgvjTL/oGVpIgLhivljmnLw=;
        b=azl1ETsDxeR2RX0SwiYVeQ0ZpBxmcpQNfOInmGiT9fnCIx3ZIF/afzm2+wk/yltBWt
         OgJaxLJcsr0KbLVyTx5sc45/LPuYeFM5xM3lq3Eo4F5VNFvmuog3k3Th+mPqv1iVccpK
         +EvamI/JunZC95Owjqtsuz8DKmcL+qe0GV3xVdDRibMFh7hHe3kbdgVhAN2RQEElMC4Z
         DuuQRQsp52WtzEKjY1gockOP0U8OqVCOBgw8jWd+dXrXIEv+cUJbf38OQ5JnvyLyvM59
         A1UUGpTrNVNprhCk5Uesfdd0Esn2tmqMRx0V53zv/KKUom6Y6dDLYNYdx8SPVAJh4fii
         3Q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQkOTwt9uzrTb00l0feBsgvjTL/oGVpIgLhivljmnLw=;
        b=RklfoJt2AGiwdWYn5I78WWzGsksr1r44TJuKGwQ2mM9FHnbMiyg7sZLO6oBs6fY4FL
         oiDt/1WIsKjmcc2rr+/8p+OgHJJpsuXXCdkHGHGmNuwSPb6L6IjIdlPqowWWF5eQAwAI
         AcOhRlr/rZTnaQSB5Hyx02pfMs6ixfXiTcDnTK11rzVgXlXF2kIHenK5xkg/OjVUTvdx
         HK9MrBI33IkDmFmO1AilMAFmQGRqw1YdpPtEcHcmh3iwgrz0Kks1wJbEeUwKzG5kAZrW
         3QRwPKuv83LPyyh76ewqoOPapO+SbGvq1o6FmxIZiMhNuxi1V+JIXSl3Gh+W1jol7HgA
         LK3g==
X-Gm-Message-State: AOAM5320pB+mfSpekEqelUg9nKnOD/Yu+L+MncWwIeLkwG0494IP18P4
        tgJ2HuHd5LRjQBppP2zvNuU=
X-Google-Smtp-Source: ABdhPJxFP5/Hyey48CWKFkG0y0NXMu9d4h95DtqVuB5LFifdV4+PS3+0HUOAy/gCADSAe28lxCWqHw==
X-Received: by 2002:a50:e611:: with SMTP id y17mr39475594edm.270.1637859920003;
        Thu, 25 Nov 2021 09:05:20 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id jg36sm2135299ejc.44.2021.11.25.09.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:05:19 -0800 (PST)
Date:   Thu, 25 Nov 2021 19:05:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211125170518.socgptqrhrds2vl3@skbuf>
References: <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
 <20211108144824.GD7170@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108144824.GD7170@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 06:48:24AM -0800, Richard Cochran wrote:
> On Sun, Nov 07, 2021 at 04:27:03PM +0200, Vladimir Oltean wrote:
> > On Sun, Nov 07, 2021 at 06:05:34AM -0800, Richard Cochran wrote:
> > >         switch (cfg.rx_filter) {
> > >         case HWTSTAMP_FILTER_NONE:
> > >                 break;
> > >         case HWTSTAMP_FILTER_ALL:
> > >         case HWTSTAMP_FILTER_SOME:
> > >         case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> > >         case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> > >         case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> > >         case HWTSTAMP_FILTER_NTP_ALL:
> > >         case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> > >         case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> > >         case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> > >         case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > >         case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> > >         case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> > >         case HWTSTAMP_FILTER_PTP_V2_EVENT:
> > >         case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > >         case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> > >                 cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> > >                 break;
> > >         default:
> > >                 mutex_unlock(&ocelot->ptp_lock);
> > >                 return -ERANGE;
> > >         }
> > > 
> > > That is essentially an upgrade to HWTSTAMP_FILTER_PTP_V2_EVENT.  The
> > > change from ALL to HWTSTAMP_FILTER_PTP_V2_EVENT is probably a simple
> > > oversight, and the driver can be easily fixed.
> > > 
> > > Thanks,
> > > Richard
> > 
> > It's essentially the same pattern as what Martin is introducing for b53.
> 
> Uh, no it isn't.  The present patch has:
> 
> +       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +       case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +       case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +       case HWTSTAMP_FILTER_ALL:
> +               config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> 
> There is an important difference between
> HWTSTAMP_FILTER_PTP_V2_L2_EVENT and HWTSTAMP_FILTER_PTP_V2_EVENT
> 
> Notice the "L2" in there.

Richard, when the request is PTP_V2_EVENT and the response is
PTP_V2_L2_EVENT, is that an upgrade or a downgrade? PTP_V2_EVENT also
includes PTP_V2_L4_EVENT.
