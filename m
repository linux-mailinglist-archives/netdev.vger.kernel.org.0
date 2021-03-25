Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC32348659
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbhCYBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbhCYBST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:18:19 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F739C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:18:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h10so519762edt.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Wjc6bBc9cCh47ybvcrOdslczJ3Ls2NAn5JjONz9WhM=;
        b=de4npoZyNEaAgEPzE6MSII88sxYt/Fy3teRpTDuc4yqdr7FYIZkVvgn0NNEGdkwYH0
         O9pq5eDw7PEFfXiqhO9ur3F5+LlOtAss0Tm9/eLnt3GEzsnc6Hhe4e0RngIBtERosF5i
         ObMRIWVtzcrhgQ4nckrM2L6V8BWERcalzn3Aoa6+1gletMVJF+IgJPnF9hsIHWfNHKK1
         O/aaI8hobe1j/kHvD0Qn+TK93JE4YPspswop7HiJPCir5aH7Ei6oCfxp/Ri1gaD+rfVu
         RS+CCSlX+8TQxHe9/j4TkEibMHjcYJ/Q0TgXl45QFnjXWX+wVhwcSnJ06x0SAM1Kb5GP
         GTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Wjc6bBc9cCh47ybvcrOdslczJ3Ls2NAn5JjONz9WhM=;
        b=NN7uNjMi/TQIM/CL6Ao3sjImU+WL6bRks8h+aBDfpTV25JCSatKLRO520EGjPr5TwO
         Yr79XH0DiVGU18y4kPPrS2J2k7Xk4jN2iHgW9RpXQeRcatcL5C7s/hjnXibQPOfeuYY1
         ytZ1+yH12moblSRbcpUSyXHzfPp8/9SSxlqDMYk+61z0NNwmRXHjf+DwwFhISOeM7t0r
         tECIlwExzcnQstF3diBbU3BKM+LMzdxG+VXBibP6lKbCq2GSRB+5vUDo3svBRfQjqaUX
         nwuB/nPWpsn8bj/rS57Eddqh5LVGvT8xYeJ2Z0GCUK/vQqp3Rddq3pPV+JdOpgYMKjmm
         Uk+Q==
X-Gm-Message-State: AOAM533tCgcpzuhNUt+4lwUFK3aOKeErcVqMDHKpOuLyTa4Gx7eqJul2
        U+wC1QOXLhEI/Okmp1wEDLY=
X-Google-Smtp-Source: ABdhPJzeeJ0G5Mp3USEM+fMU+Mt/IoQ2UuMFxfu++5SiJR/rdT87Zp7nlgHEy3qEBh4gpEKwKX/ZxQ==
X-Received: by 2002:a05:6402:2744:: with SMTP id z4mr6428988edd.347.1616635097191;
        Wed, 24 Mar 2021 18:18:17 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v24sm1705842ejw.17.2021.03.24.18.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 18:18:16 -0700 (PDT)
Date:   Thu, 25 Mar 2021 03:18:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
Message-ID: <20210325011815.fj6m4p5k6spbjefc@skbuf>
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
 <20210324222114.4uh5modod373njuh@skbuf>
 <7510c29a-b60f-e0d7-4129-cb90fe376c74@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7510c29a-b60f-e0d7-4129-cb90fe376c74@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 04:07:47PM -0700, Florian Fainelli wrote:
> > What are the benefits of mapping packets to TX queues of the DSA master
> > from the DSA layer?
> 
> For systemport and bcm_sf2 this was explained in this commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d156576362c07e954dc36e07b0d7b0733a010f7d
> 
> in a nutshell, the switch hardware can return the queue status back to
> the systemport's transmit DMA such that it can automatically pace the TX
> completion interrupts. To do that we need to establish a mapping between
> the DSA slave and master that is comprised of the switch port number and
> TX queue number, and tell the HW to inspect the congestion status of
> that particular port and queue.
> 
> What this is meant to address is a "lossless" (within the SoC at least)
> behavior when you have user ports that are connected at a speed lower
> than that of your internal connection to the switch typically Gigabit or
> more. If you send 1Gbits/sec worth of traffic down to a port that is
> connected at 100Mbits/sec there will be roughly 90% packet loss unless
> you have a way to pace the Ethernet controller's transmit DMA, which
> then ultimately limits the TX completion of the socket buffers so things
> work nicely. I believe that per queue flow control was evaluated before
> and an out of band mechanism was preferred but I do not remember the
> details of that decision to use ACB.

Interesting system design.

Just to clarify, this port to queue mapping is completely optional, right?
You can send packets to a certain switch port through any TX queue of
the systemport?
