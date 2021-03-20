Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECA2342DDB
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCTPjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCTPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:38:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46B7C061574;
        Sat, 20 Mar 2021 08:38:58 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t20so4359102plr.13;
        Sat, 20 Mar 2021 08:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wg8yrfY8Orb7Nenc8qwtk7TJ4R+4DE1IsgvTRhOqrm8=;
        b=XYeGaqBnaFD7qRAzunKxuOwg5kjn4UOLRo2w/2c4VeMno73zLRRywj8QX3a6U41BVX
         j06u/JhxY0pFXPT/bM+YFd0181O+R/a0TyIZ2Yq7FXkRJujL0d8lIvUMNsg60HjzxcmP
         sjWPSYhgJX5cVIDLyRPAiyXdKWwEfbvIBjqkCig8iIYlv/M1aZvGMjUnE4S0gT4qhtFj
         7QNVK2lWlMXrmbgOUY5RMsLay8DxrGwDUNkfN0YrUcFPmXaVJHmOgsVdByOKnpq2j+Po
         vnOInaeRfebIaC3QlQrGdBK1Km1lrUJTrBCR7AHyLyFphGo2/qrbHCwQQW6lFydHUD6o
         3WWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wg8yrfY8Orb7Nenc8qwtk7TJ4R+4DE1IsgvTRhOqrm8=;
        b=p5omX5e8q9PCqgZz+5QN5569A85ENy/3NTQTAh8kZkfQw/a1AbijW/O6YThDyquCJK
         iVUwhzERa0ME9N6RiXsQ2bm+6lcZ3VZ/vThpHG4QtpyuDZpIqcEqLJdzsEfPmwERjIOL
         JvNzD5oI3Wh+Vb3JRUfqVN59tKv6HW4xTrCqsEtBPIOhUevzkUzr7B0qGN4oIvroGymu
         GvZKcXoeN7XmyO36rM3w3anfh97pXBXRU2N/9lGf+ntrBspH2A8Yvv9jkP8eX6Cm1jW5
         d7oHZrjiI0EIQBix0baXAmMQQS18itCrCYblsr8xEb+GdZUQZoCMi7Gt9GvVUghtpyl7
         OK1A==
X-Gm-Message-State: AOAM533zvLcq9ayYyIWE2BkZv6FOnguM8eJ0e0mjizRBbpNX5pAkuoF3
        OP52m+HKofZPAdEhBEgzAyhrnG0p/Oc=
X-Google-Smtp-Source: ABdhPJwm/nIFE28+5hzSB/R3dAw4Z1AQUFIg1YMohE0dxy2AgFvLTHeyYzhjLAwC3BK36sC04gVdjg==
X-Received: by 2002:a17:90a:7a8b:: with SMTP id q11mr4148393pjf.215.1616254738448;
        Sat, 20 Mar 2021 08:38:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:48:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c129sm7400330pfb.141.2021.03.20.08.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:38:57 -0700 (PDT)
Date:   Sat, 20 Mar 2021 08:38:55 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Dipen Patel <dipenp@nvidia.com>,
        Kent Gibson <warthog618@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Networking <netdev@vger.kernel.org>
Subject: Re: GTE - The hardware timestamping engine
Message-ID: <20210320153855.GA29456@hoboy.vegasvil.org>
References: <4c46726d-fa35-1a95-4295-bca37c8b6fe3@nvidia.com>
 <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
 <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 01:44:20PM +0100, Arnd Bergmann wrote:
> Adding Richard Cochran as well, for drivers/ptp/, he may be able to
> identify whether this should be integrated into that framework in some
> form.

I'm not familiar with the GTE, but it sounds like it is a (free
running?) clock with time stamping inputs.  If so, then it could
expose a PHC.  That gets you functionality:

- clock_gettime() and friends
- comparison ioctl between GTE clock and CLOCK_REALTIME
- time stamping channels with programmable input selection

The mentioned applications (robotics and autonomous vehicle, so near
and dear to my heart) surely already use the PHC API for dealing with
network and system time sources, and so exposing the GTE as a PHC
means that user space programs will have a consistent API.

[ The only drawback I can see is the naming of the C language
  identifiers in include/uapi/linux/ptp_clock.h.  If that bothers
  people, then these can be changed to something more generic while
  keeping compatibility aliases. ]

Thanks,
Richard
