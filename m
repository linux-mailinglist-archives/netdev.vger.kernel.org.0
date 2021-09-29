Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A7541C77E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344840AbhI2O5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344808AbhI2O5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:57:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DE1C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 07:55:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso2242048pjb.0
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FB6NLUh4JJVnIhDxC5d6Tj1LUuUYWinV0RGhYHlDEWY=;
        b=eaS/qdTLGp55Uhi3vGiSgrPQMgey9kiY/18JKnR1N8kF5lQ0HOw6P/OfJ10nzp4TCa
         jAWT/2e7EjYeKG3y67U3mtRdK9fnG8nFa3tGyd71c9GvxekTAMQ3IdyxP+hr4ax80jzO
         9odfvhe6rbqAKqNJJvNC7WlycCmaOTWfj9HMoFoZ4VgDccXUmH43Ch62RFctPCAKg5CF
         bYqlQMIDhH7V/BgNqbK+0Gcvny+A/bLP/wDS95jBgSgBwNcKMYkDCnf4SqWqXIPFCULu
         JsbZBy6qLRx/7uF/farseQK+lqEkME6u9DRNz5/hZGhDjgCfUWB846h2dzUSDP67g0Qv
         GDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FB6NLUh4JJVnIhDxC5d6Tj1LUuUYWinV0RGhYHlDEWY=;
        b=X28dAyHy9UWqwRLh8rZiN4v/GoPD3x8s1CP0ISex9nPRRd6dyNQPR7gjBNt/Q6CUEE
         Z8N62aeCx/NVTZIVVexP+GOIW4Pnsqy9R2xppsBdF1fEGhW2TlXO5LgeyTvmeJECsAQc
         0HUZXrQnNFi6qEFYnBgiSknaAG9+ottlksZEhc2Xj2tU2ENKzsNf4meJFaNVRy52Tghw
         QZ5szx0VklaxwRXSBoTtNxx1RDuTcGRpm88tkORloJqSN+FLE0+Vks+tYYrfQnf8izHp
         7apw2DACdAmG0LkHiktrrQioSMpaG/yCFp7ZW4ws7arW3oNS4cXuKc/+u9yiuswqPgZv
         ywOg==
X-Gm-Message-State: AOAM530gUagog72jXa/DqeHiLEiNl2/Yvbe/rQZN/xkzuPLIvkwit0gX
        7RwnvwDnD7R7r14ifxlBnUc=
X-Google-Smtp-Source: ABdhPJwPQv8ItB7feoFmkpYzAmRImRXLHDE/L56P3/P/hjQTzYpNBZ9yIXM+J45R/yPNcHPmjTWsGQ==
X-Received: by 2002:a17:903:124f:b0:13e:25e6:f733 with SMTP id u15-20020a170903124f00b0013e25e6f733mr384988plh.42.1632927338271;
        Wed, 29 Sep 2021 07:55:38 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j24sm128595pfh.65.2021.09.29.07.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 07:55:37 -0700 (PDT)
Date:   Wed, 29 Sep 2021 07:55:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: macb: ptp: Switch to gettimex64() interface
Message-ID: <20210929145535.GA29729@hoboy.vegasvil.org>
References: <20210929120739.22168-1-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929120739.22168-1-lars@metafoo.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 02:07:39PM +0200, Lars-Peter Clausen wrote:
> The macb PTP support currently implements the `gettime64` callback to allow
> to retrieve the hardware clock time. Update the implementation to provide
> the `gettimex64` callback instead.
> 
> The difference between the two is that with `gettime64` a snapshot of the
> system clock is taken before and after invoking the callback. Whereas
> `gettimex64` expects the callback itself to take the snapshots.
> 
> To get the time from the macb Ethernet core multiple register accesses have
> to be done. Only one of which will happen at the time reported by the
> function. This leads to a non-symmetric delay and adds a slight offset
> between the hardware and system clock time when using the `gettime64`
> method. This offset can be a few 100 nanoseconds. Switching to the
> `gettimex64` method allows for a more precise correlation of the hardware
> and system clocks and results in a lower offset between the two.
> 
> On a Xilinx ZynqMP system `phc2sys` reports a delay of 1120 ns before and
> 300 ns after the patch. With the latter being mostly symmetric.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Please put me on CC for future PTP patches, thanks.

Acked-by: Richard Cochran <richardcochran@gmail.com>
