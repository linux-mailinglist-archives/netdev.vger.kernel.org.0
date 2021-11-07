Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218CB44734B
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 15:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbhKGO3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 09:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhKGO3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 09:29:49 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F7FC061570;
        Sun,  7 Nov 2021 06:27:06 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so51373674edz.2;
        Sun, 07 Nov 2021 06:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wgS4Z8PT2Ebyn4QJE2ToIaYAg8RjXYt58lFNTo+dvGE=;
        b=c/tAG78sNGkBMwe6Dp4+rRg23U7Kd99wgdrtIKQo2oHungqMjEdWl3TaYq5h+IRN8Y
         RiRG6EBapGqOgwXLhPU0oWu5mDSr+SQsrzIiN6soKcWkIuUN57/f9bEsJU6MPrcS/lXt
         DM70AEGCMwQ7Fjd3Q4RLwJDzbps7RKckyL66/dS1+mXrihLATwHIIVzg4/n/kg6+8waw
         zxQsylhvgmVSIqlNeQkQzrT8R6/rszVSI6vIfTYvftoIyahqAfT5e4iFeBf3P2jE16DK
         yP1xn0NUxXlhCnMVA/d99FsS+HMDl2r3eLOm6dgz0eLuYSmtNiNhH25lB1gs+6rgDG41
         dBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wgS4Z8PT2Ebyn4QJE2ToIaYAg8RjXYt58lFNTo+dvGE=;
        b=01kPrJx/lmgS6wCD4LQg/SCVQX/l7FpLrK+NsWMPqv0mYEASnzuz5nvfO4egxXXYSA
         3qJaKiLcvmT8izae27rbkBDyAYr2IO1CL9yTjyQpgMCXnnpqLIucGi/ner2HdLOhgP4e
         uHF8r54z7Wj1XyA6MRSBLetlq9oDSuqpDFY2IRN+kGi2Kg2W787hglba+cXcxdzbZdDM
         LMjVbBiby+OiOE0Mfx2iyNIQFZW161vQR0/UJL1D8Rsr/mWJTXk8P12G3piX9KBpL9oQ
         GR8nuqnNema7rX/+LRMT/xer/NlcUtPwb/zRyIpChykSjw07ZzvnfJT2GHmAlEVvaHwj
         YFhg==
X-Gm-Message-State: AOAM530J8apdsk9d5ci2Z9XyD4/jp9pPiHHvuCr84P5V8JYb5aboCMZc
        TNO6BDKq7oiv0Jr9P5Kgm0F6UoPrIuo=
X-Google-Smtp-Source: ABdhPJz46MFttV0U9Z5DN4OZTU4O5wy2VDdafE5rFyTGwW9wascNbAhWj5wRJ9qi20zFhtiwyultYQ==
X-Received: by 2002:a50:becf:: with SMTP id e15mr99630830edk.114.1636295224727;
        Sun, 07 Nov 2021 06:27:04 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id ho30sm6772385ejc.30.2021.11.07.06.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:27:04 -0800 (PST)
Date:   Sun, 7 Nov 2021 16:27:03 +0200
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
Message-ID: <20211107142703.tid4l4onr6y2gxic@skbuf>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107140534.GB18693@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 06:05:34AM -0800, Richard Cochran wrote:
> On Sat, Nov 06, 2021 at 02:36:06AM +0200, Vladimir Oltean wrote:
> > On Fri, Nov 05, 2021 at 05:18:04PM -0700, Richard Cochran wrote:
> > > On Fri, Nov 05, 2021 at 04:28:33PM +0200, Vladimir Oltean wrote:
> > > > What is the expected convention exactly? There are other drivers that
> > > > downgrade the user application's request to what they support, and at
> > > > least ptp4l does not error out, it just prints a warning.
> > > 
> > > Drivers may upgrade, but they may not downgrade.
> > > 
> > > Which drivers downgrade?  We need to fix those buggy drivers.
> > > 
> > > Thanks,
> > > Richard
> > 
> > Just a quick example
> > https://elixir.bootlin.com/linux/v5.15/source/drivers/net/ethernet/mscc/ocelot.c#L1178
> 
>         switch (cfg.rx_filter) {
>         case HWTSTAMP_FILTER_NONE:
>                 break;
>         case HWTSTAMP_FILTER_ALL:
>         case HWTSTAMP_FILTER_SOME:
>         case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
>         case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
>         case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
>         case HWTSTAMP_FILTER_NTP_ALL:
>         case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
>         case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>         case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
>         case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
>         case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>         case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
>         case HWTSTAMP_FILTER_PTP_V2_EVENT:
>         case HWTSTAMP_FILTER_PTP_V2_SYNC:
>         case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
>                 cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
>                 break;
>         default:
>                 mutex_unlock(&ocelot->ptp_lock);
>                 return -ERANGE;
>         }
> 
> That is essentially an upgrade to HWTSTAMP_FILTER_PTP_V2_EVENT.  The
> change from ALL to HWTSTAMP_FILTER_PTP_V2_EVENT is probably a simple
> oversight, and the driver can be easily fixed.
> 
> Thanks,
> Richard

It's essentially the same pattern as what Martin is introducing for b53.
