Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E136B44732F
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhKGOIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 09:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhKGOIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 09:08:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724DAC061570;
        Sun,  7 Nov 2021 06:05:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f5so12767760pgc.12;
        Sun, 07 Nov 2021 06:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S9Hzr0G+eW/ZzC3V59XnG0Uj0s7Oz1fOZsTjDtBfKfQ=;
        b=biEaVbLhY7qe3w4ohrNzHoW6Whl2En11wjfRFI12H7AB6fwaN+pYmbHDyxXV21rqjd
         rCLilmGcb5qNLBz9D2v9aJBU6ssz3GmdE1GQEcySx070mT+S3jtGyvVSikW3fJHVxext
         6Dhj2B+tVmpfo3EkrAEvFTE3UxCy5M3goppt3/A0gRd9EGacwBMSqcYxhiQM/97U26mS
         Qrc9v1mHIsJDNyHrmcZysY5pkq7YGNiZ0v9wveoYdvuYdxfrg8qI4S/unvrrZ0Q5ZItx
         2PO2FLI1TaHGCJXgoKRNODb2fH3QlplNvn+K4QJbegYUXK6njIg7Vr5ok9MfzJVzzqid
         8UCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=S9Hzr0G+eW/ZzC3V59XnG0Uj0s7Oz1fOZsTjDtBfKfQ=;
        b=crBy+JwF4PydmPRR/gI0eUW4UOym/U6yTIcqmNmwMOAMXLiXxoFBXTdJFohRWrA2QZ
         AMNHosOyECEyzwAgZRXfu1XjwJaOCTfsYgHd+5BcQ3Rb772qyVgG1UaRJcuPWO5eZDzt
         v2RDHdNXOXWzLNzG1qmNaZDUaTr7ALiddM9jRMVsIFU/xlKBr+6UYQEYUrOmD6Z6oVgE
         x9OrTiMR9EHtR8f6N8sP8Jy6qqN/X5ySNFJPpPcc61DaWlxNg3HChB3ucmeVvixdgWLF
         Tm9Dr442QAEJpccaFbP7mBQ/Le92MQyaDx9Fs5NXBav2N1RS9yvDktxW3VEM8/bsMThz
         bBxA==
X-Gm-Message-State: AOAM533f6eYLpak00/CMo4aE59t5HrYGjkhOOuxreQvSVANOmmqTRz/v
        2xi5FXcFzkDFD/sM1Ic9gceMXJ9Alzo=
X-Google-Smtp-Source: ABdhPJww0EP6IbQfQ/2x5B0xYENNMY6nqsUEnsglQ3f6GlitCE+xFH9zozCcDm/23EhZ6TmTs/87Cw==
X-Received: by 2002:a05:6a00:134a:b0:47f:2c6a:f37d with SMTP id k10-20020a056a00134a00b0047f2c6af37dmr65781184pfu.50.1636293938010;
        Sun, 07 Nov 2021 06:05:38 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x135sm5280958pfd.78.2021.11.07.06.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 06:05:37 -0800 (PST)
Date:   Sun, 7 Nov 2021 06:05:34 -0800
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
Message-ID: <20211107140534.GB18693@hoboy.vegasvil.org>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
 <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
 <20211105141319.GA16456@hoboy.vegasvil.org>
 <20211105142833.nv56zd5bqrkyjepd@skbuf>
 <20211106001804.GA24062@hoboy.vegasvil.org>
 <20211106003606.qvfkitgyzoutznlw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106003606.qvfkitgyzoutznlw@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 02:36:06AM +0200, Vladimir Oltean wrote:
> On Fri, Nov 05, 2021 at 05:18:04PM -0700, Richard Cochran wrote:
> > On Fri, Nov 05, 2021 at 04:28:33PM +0200, Vladimir Oltean wrote:
> > > What is the expected convention exactly? There are other drivers that
> > > downgrade the user application's request to what they support, and at
> > > least ptp4l does not error out, it just prints a warning.
> > 
> > Drivers may upgrade, but they may not downgrade.
> > 
> > Which drivers downgrade?  We need to fix those buggy drivers.
> > 
> > Thanks,
> > Richard
> 
> Just a quick example
> https://elixir.bootlin.com/linux/v5.15/source/drivers/net/ethernet/mscc/ocelot.c#L1178

        switch (cfg.rx_filter) {
        case HWTSTAMP_FILTER_NONE:
                break;
        case HWTSTAMP_FILTER_ALL:
        case HWTSTAMP_FILTER_SOME:
        case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
        case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
        case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
        case HWTSTAMP_FILTER_NTP_ALL:
        case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
        case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
        case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
        case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
        case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
        case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
        case HWTSTAMP_FILTER_PTP_V2_EVENT:
        case HWTSTAMP_FILTER_PTP_V2_SYNC:
        case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
                cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
                break;
        default:
                mutex_unlock(&ocelot->ptp_lock);
                return -ERANGE;
        }

That is essentially an upgrade to HWTSTAMP_FILTER_PTP_V2_EVENT.  The
change from ALL to HWTSTAMP_FILTER_PTP_V2_EVENT is probably a simple
oversight, and the driver can be easily fixed.

Thanks,
Richard
