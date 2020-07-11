Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E2921C624
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGKUaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgGKUaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:30:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13556C08C5DD;
        Sat, 11 Jul 2020 13:30:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m16so2465913pls.5;
        Sat, 11 Jul 2020 13:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5SxQ/W4fQ7dzP/hsn63V8CBLGv3LBO6R8zOG1XBAxQg=;
        b=r1uev5EJYj14z6OIUA2WzEr5gq48rqe95et2oKueB8EWZ+Y0lP2OGRRQlKhX66AMqV
         MmD42JAE7Qe1bKFoF2DXgufLjTc+beTeiNSCRqXNhV+Rkc7Cd+AdEkjQhD1SxGa8OL4R
         vY4JnGyfdbqeUx49H6jYvpPWGRuJqm3LqUeVnOZFUlNAmv2dgSIyizfLpfua8JVHPXFD
         xolp0f9DPSgRx8wETIQVk64ixiNGLS+tEl1MY/eR3mxAE52RtDktQFcI7Tz6wuFaKnew
         KxIjutHWryEyXTJnVrlJl+qt/k2llqO/TyKP1SlbHS7vrlgPo+728goPFE2l0u7VZmQR
         4FNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5SxQ/W4fQ7dzP/hsn63V8CBLGv3LBO6R8zOG1XBAxQg=;
        b=OgsOV4KiKMUOHMVraC1Ib+e0jkxdWC6LvvGV8IoOleyqZE/B7zeA+SYyUgCZ2OOrra
         Trv/8+McB6WPwn1j5/Z2Y9f/jMDzt9aaEcjpkWJLXUK28Bey8UkxwfULFl82pIaUwy19
         +1wuTpxpZaoydendqHdvCBsyicfSQGEVsaI1y4mbNMDfglhDvf9LDDJEOTKb3UxAgxYZ
         NTP5/Yj924RMVdg80mNPgHAaZBCHtw2Nj5q3FqQTq1SSi2qODvs4J7zcRyeROXc6XxtM
         /uSTnNC2vYyde3Yg5Sw0nQoXub+y2xFSsoUZDp1Gi3q5ijnZftTsYB4WMguXSUrvV1m2
         5VNw==
X-Gm-Message-State: AOAM5334LOfARGsG1t2dA0da2R/ck4Nt3V+VkbB8+uCLLhpN7aPkNq/4
        O4ph9J//uw52+o1nPi5NtTjx989P
X-Google-Smtp-Source: ABdhPJzBRccBaPGRXGSWz4vPQ96Ry7hFEM/ut7r0OjTO2ACfWIG5KxOhwrWSNrKXOIGmlDED8jgKYw==
X-Received: by 2002:a17:90a:e981:: with SMTP id v1mr11916618pjy.130.1594499416411;
        Sat, 11 Jul 2020 13:30:16 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x3sm9923306pfn.154.2020.07.11.13.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 13:30:15 -0700 (PDT)
Date:   Sat, 11 Jul 2020 13:30:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 3/8] net: dsa: hellcreek: Add PTP clock support
Message-ID: <20200711203013.GA27467@hoboy>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710113611.3398-4-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:36:06PM +0200, Kurt Kanzenbach wrote:
> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> 
> The switch has internal PTP hardware clocks. Add support for it. There are three
> clocks:
> 
>  * Synchronized
>  * Syntonized
>  * Free running
> 
> Currently the synchronized clock is exported to user space which is a good
> default for the beginning. The free running clock might be exported later
> e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The switch
> also supports cross time stamping for that purpose.
> 
> The implementation adds support setting/getting the time as well as offset and
> frequency adjustments. However, the clock only holds a partial timeofday
> timestamp. This is why we track the seconds completely in software (see overflow
> work and last_ts).
> 
> Furthermore, add the PTP multicast addresses into the FDB to forward that
> packages only to the CPU port where they are processed by a PTP program.
> 
> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Acked-by: Richard Cochran <richardcochran@gmail.com>
