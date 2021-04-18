Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87DB363645
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhDRPG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhDRPG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 11:06:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D60C06174A;
        Sun, 18 Apr 2021 08:06:27 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 10so12628706pfl.1;
        Sun, 18 Apr 2021 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0cvPAtRazPr1MmZXsoX7YqIfZ+lNH/A/5U1Atc0qJpU=;
        b=EzJlwhsX+5DgbNJuTTWVtyIxYP01BkINjrDlzsm/ekMP6TFvQsrgbqqNVKAf02atIe
         q6tRZnewWFAZ+UZhujchdpj+rUC0fe5rgtvCwhVgJhrLN4l0s4tqTi3XwpMOyTVI8OUu
         5KZF2NEdp9ebqsp6PcNL90RCUoa8Si/kYS61gnjI3IFfV+2/61quelk73d4jzBlmlNxe
         exy80rmY6Srdid7gelaOHjUnL6Yn2ZLa6qNB6R6m1/O8IE/0RA5Eagn4SQ8cCjhSMiwZ
         rELlxqJyRqRgEfjqKujYy5TSniGSMQBJuSpbTmdxc/c8sDSZIztvfZ98uOkL8WDwTBwg
         EG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0cvPAtRazPr1MmZXsoX7YqIfZ+lNH/A/5U1Atc0qJpU=;
        b=VlTscHdXoh+aaqrPACJm6J2WM33xxqc0kl0OvMz4HPfelFEvOpWZIs7u8kP52HXwkN
         29Ee2wrp1wXabxrPkHoWmaBYGwknUVSraJu8K3MMD5Gb54dVgbkjjnqFbLGIfnqSjehW
         vQyOWjpDTATeN9QCg8CJ5h6zf4sAnm1juwOmGtaMzrf2oOQoyobCtHJKTChuRMk+T86B
         3SFf7VhmTFs0MWa6oaZlzJAN871SK3aGUXW5vuRXUa247zTNJlEcHBdFJioNbOEaEVK4
         glOFK/hLZGjiGJYshCXgqFj62eXgPcEh9T/HUE2k1jcnPs3Exo3PUH7LJXvxxezvfL7P
         zhuA==
X-Gm-Message-State: AOAM530ZeDdwzyO7wOIzhmZmBJsyFyiMFutY5e06WOlJp6JNuR5yXT7B
        lfRjCvpBg1cChgcYNzKjMww=
X-Google-Smtp-Source: ABdhPJy9vYLzp0+GymeHfFud/ExyRY2RN7iYUeldLHm2sGbIUquBXk3oLqzq50I87u2eQRbgtyYH+A==
X-Received: by 2002:a63:5322:: with SMTP id h34mr7860602pgb.182.1618758386219;
        Sun, 18 Apr 2021 08:06:26 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d4sm8220115pfv.76.2021.04.18.08.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 08:06:25 -0700 (PDT)
Date:   Sun, 18 Apr 2021 08:06:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Message-ID: <20210418150623.GA24506@hoboy.vegasvil.org>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416123655.42783-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 08:36:53PM +0800, Yangbo Lu wrote:
> Optimization could be done on dsa_skb_tx_timestamp(), and dsa device
> drivers should adapt to it.
> 
> - Check SKBTX_HW_TSTAMP request flag at the very beginning, instead of in
>   port_txtstamp, so that most skbs not requiring tx timestamp just return.
> 
> - No longer to identify PTP packets, and limit tx timestamping only for PTP
>   packets. If device driver likes, let device driver do.
> 
> - It is a waste to clone skb directly in dsa_skb_tx_timestamp().
>   For one-step timestamping, a clone is not needed. For any failure of
>   port_txtstamp (this may usually happen), the skb clone has to be freed.
>   So put skb cloning into port_txtstamp where it really needs.

This patch changes three things ^^^ at once.  These are AFAICT
independent changes, and so please break this one patch into three for
easier review.

Thanks,
Richard
