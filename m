Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C2448223
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbhKHOvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbhKHOvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:51:12 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB50C061570;
        Mon,  8 Nov 2021 06:48:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so11782pjb.4;
        Mon, 08 Nov 2021 06:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eXl1H2PvB/dAhQZfxa5AWUQCdZb9d4W9i502eO8U1g4=;
        b=R2IIgFxRPxZ5UampCEqIXTw0RkteoV+w12Kh/0cHaxc20HtiMEgTePNEy58s7xwJEa
         jlhmkCHAb+3D9or0CFioNkIFj3LpCuQuSAbHeOOhjqVRp5VOMfIYaZG2qzG8C5bfTQh1
         nq2wr+ZykNiqMMFd+lp4SJ0bakErXlCDMebmKqYSKSGbJ1HGYBLeDBvzVN+PGSls4OLs
         UuGVDRtMUYunQatN+M88FT0rHocSOqyQmSpzi/xCfc/psa1fN4mornoYszDmKjRUN8Am
         /xyNvzlWpeEqBLHUavPoi0mUNvAJrR3xu8gzZRxFOCzhNuNjPslIOX6KPRiJrJJVKhC0
         CGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eXl1H2PvB/dAhQZfxa5AWUQCdZb9d4W9i502eO8U1g4=;
        b=OU205Tsy4EDQfBj0zomaCVZIUUf4RIHY2WXrsLhiFXElVVdz6rUVWgwqZnKv4daFkp
         qFDLxz5pAFlFZwR9Hb1IWk7spr0chJIyi8Hxl8MArAgdR6EgjzAOPOGHWwlM9vs/kAzK
         qWwDaIAY5/olZdpljsNYu9an9US6lHomUEgK8Byan1+sFkWXHygHYaFH1l4G1ZqvgH7E
         ByUqhxs8WrFj5YCPe3eo/U8w/bSRPN9BMG8d9ycQxJjeBZW16aTc4Oi4PEOx284cJQ4i
         W5p967w53lmoeoY3np1ubU66RfHOSoztlz/wbz6Lt91uBFiy+FFZyJ9Xib93IqjkJLW1
         Rf2Q==
X-Gm-Message-State: AOAM5308+lGGZFB6EA6c3xtCnelcEUMze++FZ3GayOkKX1dvYOysLqnu
        Rpv6mLL2MCAgflVv1DwOo9o=
X-Google-Smtp-Source: ABdhPJwK7Y5wLJJBWfPIbgnvw7+qD/2DAgRxCcw60kj3RUbkVmTlHVwkGiqfGr+M9RuIA5d8GtRioA==
X-Received: by 2002:a17:902:e842:b0:142:dbc:bade with SMTP id t2-20020a170902e84200b001420dbcbademr227691plg.45.1636382906902;
        Mon, 08 Nov 2021 06:48:26 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o134sm8330185pfg.1.2021.11.08.06.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 06:48:26 -0800 (PST)
Date:   Mon, 8 Nov 2021 06:48:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Message-ID: <20211108144824.GD7170@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
 <20211107140534.GB18693@hoboy.vegasvil.org>
 <20211107142703.tid4l4onr6y2gxic@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211107142703.tid4l4onr6y2gxic@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 07, 2021 at 04:27:03PM +0200, Vladimir Oltean wrote:
> On Sun, Nov 07, 2021 at 06:05:34AM -0800, Richard Cochran wrote:
> >         switch (cfg.rx_filter) {
> >         case HWTSTAMP_FILTER_NONE:
> >                 break;
> >         case HWTSTAMP_FILTER_ALL:
> >         case HWTSTAMP_FILTER_SOME:
> >         case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> >         case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> >         case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> >         case HWTSTAMP_FILTER_NTP_ALL:
> >         case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> >         case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> >         case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> >         case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> >         case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> >         case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> >         case HWTSTAMP_FILTER_PTP_V2_EVENT:
> >         case HWTSTAMP_FILTER_PTP_V2_SYNC:
> >         case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> >                 cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
> >                 break;
> >         default:
> >                 mutex_unlock(&ocelot->ptp_lock);
> >                 return -ERANGE;
> >         }
> > 
> > That is essentially an upgrade to HWTSTAMP_FILTER_PTP_V2_EVENT.  The
> > change from ALL to HWTSTAMP_FILTER_PTP_V2_EVENT is probably a simple
> > oversight, and the driver can be easily fixed.
> > 
> > Thanks,
> > Richard
> 
> It's essentially the same pattern as what Martin is introducing for b53.

Uh, no it isn't.  The present patch has:

+       case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+       case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+       case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+       case HWTSTAMP_FILTER_PTP_V2_EVENT:
+       case HWTSTAMP_FILTER_PTP_V2_SYNC:
+       case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+       case HWTSTAMP_FILTER_ALL:
+               config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;

There is an important difference between
HWTSTAMP_FILTER_PTP_V2_L2_EVENT and HWTSTAMP_FILTER_PTP_V2_EVENT

Notice the "L2" in there.

Thanks,
Richard
