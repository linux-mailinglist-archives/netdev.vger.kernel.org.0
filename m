Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF32D22B457
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgGWRMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbgGWRLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 13:11:53 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7C5C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:11:53 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j20so3316605pfe.5
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 10:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tAQnWbaYFdt0fmRzbKPolPsjMN0h/+NYC7ktZIMqero=;
        b=BOEicV+33M3mxE/nIy+RzKMCuMrDJWUUvLdRs5U+lgloLL5aPTcCUJF8fDMIpVcoSL
         ZVhl9C2iBrAqHAXy5hXL/ggepWvbGa2RC0epTLpMvHkLSjlboHGCakriDOw2+5CUNBT7
         0WJySupSIWZnRcPmXujoCeaeYrVDMEC1ihZcpokVxXwy8zEivy29+pIIvpeNEHFaE94u
         iAVwTRc94Ymg6i75q6aoyeR9HBNUcbsTxWhA5xbXO5O62t10PaSUlknMd9VZrsLR5njx
         WJoXp0HaeZkTED09L3ArtbYHb+mSSg0S8iEybXgxnOrROA51PeM+AYCUpLeDRnnGfmYa
         Q2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tAQnWbaYFdt0fmRzbKPolPsjMN0h/+NYC7ktZIMqero=;
        b=gn5esECPBQyt2nlSC1GYpt6+evtiaDc/BjcrgBuCbPrvReQ7lBZy+jnAOhozMt/egf
         7gY2g3hjfL5bh/ahS8E7Rj5K6ZtYnZ3As1OSJ2qLw56HnFVuWVnBV/EpyYD7uouJyZbY
         JmOFJ/rO76ZwUSjyJTb4wRrY8hRBdUT8nk6aqLUIsCgB/bgJivGNVE+A0NSGh/O1ofDC
         8wOI6NSIWOXalBZxoUVqtlL+XSOUBW4q6u68/ot2jKDhUtdNGUy5shAeVklx7mSLnive
         H5TX5/gldsWqEOZOL5DGO/q4ChNagiMa4uEZKKmqzpH4XqJlCQ5yCKC3YwK6aQ6110Fu
         0tCQ==
X-Gm-Message-State: AOAM531HKZqWjJzlftZG0OEsuSjpAkwMAGAIDFyV2/J3TlPekLDRCzu6
        jiEXelfZ/yiQpY2svYY4qqU=
X-Google-Smtp-Source: ABdhPJy5IVS3P6MpOpypzrab0hi8+cRgCC5cfT4FAK1L5cYvcaMkS+e8NvneyA3BJOhujzYDeALz7w==
X-Received: by 2002:a63:6c0a:: with SMTP id h10mr5012436pgc.11.1595524313092;
        Thu, 23 Jul 2020 10:11:53 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u24sm3565586pfm.211.2020.07.23.10.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 10:11:52 -0700 (PDT)
Date:   Thu, 23 Jul 2020 10:11:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: dsa: mv88e6xxx: Use generic ptp header
 parsing function
Message-ID: <20200723171150.GC2975@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de>
 <20200723074946.14253-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723074946.14253-3-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 09:49:46AM +0200, Kurt Kanzenbach wrote:
> @@ -26,6 +26,7 @@ config NET_DSA_MV88E6XXX_PTP
>  	depends on NET_DSA_MV88E6XXX_GLOBAL2
>  	depends on PTP_1588_CLOCK
>  	imply NETWORK_PHY_TIMESTAMPING
> +	select NET_PTP_CLASSIFY

Hm, PTP_1588_CLOCK already selects NET_PTP_CLASSIFY,

  config PTP_1588_CLOCK
	tristate "PTP clock support"
	depends on NET && POSIX_TIMERS
	select PPS
	select NET_PTP_CLASSIFY

and so I expect that the 'select' in NET_DSA_MV88E6XXX_PTP isn't
needed.  What am I missing?

Thanks,
Richard


