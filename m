Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9D25EA70
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgIEUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEUmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 16:42:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A0C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 13:42:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v23so11834922ljd.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 13:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0TjMg+H4n4Mtk7IDrkZ3duB88XWTjQ347I2g9xibVG0=;
        b=LdQl2s+5fpivlARAzbvQOyhLF5WBKWBZLc7wqLX6ZG45TrTCIHI6xaHgKbpIUl6kt8
         2yYCFBGmubZvcJpikc66b62VVAlhNi/jSslMgPvv9MJ4dEXmba0woDvCw2V4u/XuQAm9
         kVSdEVXXzjpfYdeq7QEjx93VG8GvhIJKtJ9RHpMAb/T+n4CXYTeJcZaQC+ubuU/j9fHj
         Z2tti52u8J2GL+MDGgHxWvYKXX+MJpjX19QlK158qGFCjvqvk9VwgPBdh7V9+LQI8okD
         28AL6hIoDuUf7zxTk2FD59rDonzXGmt2aHLgAn6Uv1oPYX+UhL4ZIol1sXgZlnr+Y9bG
         yDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0TjMg+H4n4Mtk7IDrkZ3duB88XWTjQ347I2g9xibVG0=;
        b=mo2cC5JLNbfDmk8GRrJ3xqsW2YVIdEiyoVddvRENjf4MwXaWpZaANAZQunODU+J9WL
         KWx7EYf0FiOl+gmI2Y95m0P4cjB4RBdvlmSwnBTOPRu684rn3vzvPwVQoXhGixSb1Jbi
         IepRVHTOl9Dim3fKjFhN5ydJUEGOWcmtYdm8YK+BuICYPYMBUSfpZQGw+2HmPMW2iasj
         Jn5Y+oeF3BK60AIW0DJveqfGeY1ROjFvidN4MY0FNwYCZqOeG+Gmcqh1WOX92yuYZJ8V
         yzSKcEh4w+wzW1kIiJAQTAVkptrfL3l9fOjEFpD9UbZ1w5WpJl08sfcd45Psz3Va4tju
         x46A==
X-Gm-Message-State: AOAM531gEFbUpaVJEAlTuFCzZvM7PBXaBS77LTEKn7ANp3rhLzMY9KE1
        e397KKMJYx4RhBMbCtVlFbIfY0KqtF9izECckCLWd7LyXyw=
X-Google-Smtp-Source: ABdhPJyF86Z2zRkKz9b960HfG/Br4HoqWRZqMSMAJ0DwD4EIjCcs/T7112OCGyvFMQNgy/aiRwq6dGZE3m8SAPKj5gY=
X-Received: by 2002:a2e:4e01:: with SMTP id c1mr6561471ljb.144.1599338519050;
 Sat, 05 Sep 2020 13:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200905104530.29998-1-linus.walleij@linaro.org> <20200905155052.GI3164319@lunn.ch>
In-Reply-To: <20200905155052.GI3164319@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 5 Sep 2020 22:41:48 +0200
Message-ID: <CACRpkdYJvVwRgjJyP9AYcp1rppCi_BB4SAge-7Liknv2FM_qzw@mail.gmail.com>
Subject: Re: [net-next PATCH] net: gemini: Try to register phy before netdev
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 5:50 PM Andrew Lunn <andrew@lunn.ch> wrote:

> The PHY handling in this driver is all a bit odd.
>
> gmac_open() will also try to connect the PHY if it has not already
> been found. gmac_stop() does not seem to have a symmetrical
> phy_disconnect. However, gmac_uninit does?
>
> I do wonder if more cleanup should be done while you are at it?

OK I send a new more invasive version :)

Thanks,
Linus Walleij
