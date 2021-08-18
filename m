Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F093F09D5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhHRRDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHRRDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:03:38 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C194FC061764;
        Wed, 18 Aug 2021 10:03:03 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bo18so3114528pjb.0;
        Wed, 18 Aug 2021 10:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1o10C31aHLd2LPSTgzakMlhMfOFkU5VCGEeKjx0nPj4=;
        b=Oz4jx0x5Zs5js4ubmLVJ93OgoPftLIzNNp92aDmbjtmwiIVYKdtH0pl+GeIz+AQ0FK
         BibOcAC7ory9WvtJ6QOdFLKB3llcVylHrLkbIh+ifvxVWPN7Wh7GypJZtZSkLqEB+KN3
         7ywn2EGk8KfSn/eTRUYxWp1wtBCv3V9h0X7pgsiv+LEjtIVglR7AHXrscuQY4wH8IOi0
         lWt48YngVxL+hCU52uoiIfOVzMBZBh1RHv0UjGcsQ1xBjC5Cu1xg93Q0heHzrNFqCAbZ
         w3lV9Qv/DMxxZA+sBNzNWgvh8jPlDh4Od0EGcgsT4HloEnC17JkKXx66t5xZ9NVXRuPU
         Jk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1o10C31aHLd2LPSTgzakMlhMfOFkU5VCGEeKjx0nPj4=;
        b=uXuqmGIuli0PbrOMvlKztrL9z4g+pFDDbCAljnvpYwGEYR4p8rfmGqz5ldTB0IzFu8
         T9s+cxaVT0ZdKZlb+xx2D35PcftP1NqyXidAp2wIwaqZq6WM/pmwCjYEZbYKeU0y5AXy
         tBAu6XKFlOybr8CNfHilE225NAdb4FRM4x2Uf6UUpsWxJF0mIM23Jp1sO7ZnjoeKGPYM
         Mg6j/TNjp5+uhbZiewLyFznKFn3XXLJuAvsKBVhHwc73f0mKEQoJJr0ke6+AJh2lyCZk
         3keNMCDT0oQuVjI2h0R4sCDrxIR6cMLodXSlkoDpEH4BTeCJuq/IzzRUXm56c5Lk8edg
         sZsw==
X-Gm-Message-State: AOAM530Yp4tXJrtNcpt3eu78dYsw1ap/rS4iPsB6luBXznvUzfLVSUk2
        FpTY9r7nBrjt41celq7aDNs=
X-Google-Smtp-Source: ABdhPJzblPlYhVkYncUYxJqGiFndkjCTu6Kjut7fbo8TeEzaUAEhaz7bly4Jv5B7DA/K/0xxbdLOIQ==
X-Received: by 2002:a17:90a:6f61:: with SMTP id d88mr10619309pjk.139.1629306183311;
        Wed, 18 Aug 2021 10:03:03 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h20sm330192pfc.32.2021.08.18.10.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:03:02 -0700 (PDT)
Date:   Wed, 18 Aug 2021 10:02:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Message-ID: <20210818170259.GD9992@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 09:41:49AM +0000, Machnikowski, Maciej wrote:

> The logic behind adding the DPLL state to the PTP subsystem is that SyncE DPLL on Network adapters, in most cases, drive the PTP timer.

So what?  The logic in the HW has nothing to do with the proper user
space interfaces.  For example, we have SO_TIMESTAMPING and PHC as
separate APIs, even though HW devices often implement both.

> Having access to it in the PTP subsystem is beneficial, as Telco
> standards, like G.8275.1/2, require a different behavior depending
> on the SyncE availability and state.

Right, but this does say anything about the API.

> Multiport adapters use a single PLL to drive all ports. If we add
> the PLL interface to the PTP device - a tool that would implement
> support for Telco standards would have a single source of
> information about the presence and state of physical sync.

Not really.  Nothing guarantees a sane mapping from MAC to PHC.  In
many systems, there a many of each.

> Moreover, it'll open the path for implementing PLL state-aware
> ext_ts that would generate events only when the PLL device is locked
> to the incoming signals improving the quality of external TS
> events. I.e. an external PLL can be used to monitor incoming 1PPS
> signal and disable event generation when its frequency drifts off
> 1Hz by preset margins.

I don't see how this prevents using RTNL (or something else) as the
API for the SyncE configuration.

> If we bind it to the Network port, a tool would need to find the
> port that owns the PLL and read the state from a different place,
> which sounds suboptimal.

This is exactly how it works in ptpl4 today.  Some information comes
from the PHC, some from RTNL (link state), some from ethtool
(phc-interface mapping and time stamping abilities).

> Additionally we'll lose ability to rely on external HW to monitor
> external TS events.

Sorry, I can't see that at all.

Please do NOT tack this stuff onto the PHC subsystem just because you
can.

Thanks,
Richard
