Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5652345E89
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCWMvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhCWMvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 08:51:38 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF8C061574;
        Tue, 23 Mar 2021 05:51:38 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v186so11590561pgv.7;
        Tue, 23 Mar 2021 05:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W73swV/Q5he3Tzf+ydT8yObURaAc6JinvwZwIKuuRdE=;
        b=dZYXUHWijoTrxu0O/MxB9jXvMLnVbXkMw04Grjg2u6tC73cWCd8bN/k1W5QL2SA9TK
         cgk1feBNa6NS3UvdpbsMJ+DbgsNB8z8G0GstjudfCuoar/PO+v/Ww8KsqUyu6acBZFzH
         Ldg3koMQYMCKTWI+iaZd5e787+InPTq/NOlAIQ6PaY0tCww0/kZpSwCL4orjxRzVQF1g
         sNiTTiNnJMEaXQ/bK5gM04dVcwSm8uqXe+pFE2TO3BwrNCQWvq8VryHylHzqmJNJMOWd
         DEzimEf9EhRHfj9NNaNtIVjBHCxU9lCge5e++yYmYQc0lAOGvMRmTkPkcvmwNvpBnuE8
         KYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W73swV/Q5he3Tzf+ydT8yObURaAc6JinvwZwIKuuRdE=;
        b=RR5JpdlHPN3PD4VZoqpNfd/9PzFBnkwJjf+zpDOEIa4cuKHyvqTnzKdbP16wrvPsQj
         QwXRUI9sV2Vl/MRMMqG66cSEpBAahcc/jN6vbxBv9ThjMPLKTJuO0/MTYbuYb6UsoFka
         AwwrpaQQ3HvpNHKmo+1AyvnAdgwwMwcp2Y2EmAR4Ehgv5YuRXazVwBeMdCND50wJe29N
         Yq5XQL7yGYIO+IqVXoC573pRb1295BD0ZYpgJKxZKgCax3mgjZVwxgZlGWRGt0ECp5fo
         0mxqMX4x+L/Ozm4/yA0G66pLIABb1Wsr4FPnhuyykAy+6GDwUBSyEUGbYDtzIg/HtNC6
         +Mtg==
X-Gm-Message-State: AOAM532DoIT99ztzWsqGeQJJYtm7QkJ5Y6DbkytrYtWtw4+X45sgIocF
        kxpDkj9PkJsBAAyXanfndL4=
X-Google-Smtp-Source: ABdhPJxuDrAKy3Uzblr2IjLqiyBW2NhHdIddKeLQBGKEakqaTrgX3vmub48+0gOuMI8FfEBcbk/uSA==
X-Received: by 2002:a17:903:3053:b029:e6:5cde:bef with SMTP id u19-20020a1709033053b02900e65cde0befmr5320783pla.81.1616503897889;
        Tue, 23 Mar 2021 05:51:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:48:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d6sm16606592pfq.109.2021.03.23.05.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 05:51:37 -0700 (PDT)
Date:   Tue, 23 Mar 2021 05:51:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Dipen Patel <dipenp@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kent Gibson <warthog618@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Networking <netdev@vger.kernel.org>
Subject: Re: GTE - The hardware timestamping engine
Message-ID: <20210323125134.GA29209@hoboy.vegasvil.org>
References: <4c46726d-fa35-1a95-4295-bca37c8b6fe3@nvidia.com>
 <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
 <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
 <20210320153855.GA29456@hoboy.vegasvil.org>
 <a58a0ec2-9da8-92bc-c08e-38b1bed6f757@nvidia.com>
 <YFmu1pptAFQLABe3@orome.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFmu1pptAFQLABe3@orome.fritz.box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 10:03:18AM +0100, Thierry Reding wrote:
> I agree. My understanding is the the TSC is basically an SoC-wide clock
> that can be (and is) used by several hardware blocks. There's an
> interface for software to read out the value, but it's part of a block
> called TKE (time-keeping engine, if I recall correctly) that implements
> various clock sources and watchdog functionality.

...

> Anyway, I think given that the GTE doesn't provide that clock itself but
> rather just a means of taking a snapshot of that clock and stamping
> certain events with that, it makes more sense to provide that clock from
> the TKE driver.

It sounds like TKE + GTE together act like a PHC, and GTE doesn't
need/want its own SW interface.

Thanks,
Richard
