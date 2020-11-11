Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEAC2AF0AB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKKMcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKKMca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:32:30 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A1AC0613D1;
        Wed, 11 Nov 2020 04:32:28 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id gv24so637983pjb.3;
        Wed, 11 Nov 2020 04:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dTYvfnOluYKgTxdMcxZ/FPGnTnywlshfCqeGlC/4bIw=;
        b=KZeqETg/goR4DpzrRxll6dpNFeDbh3T5LuitxgAFLrZvLFFeP31gTZD8NEXIWIXHQR
         P3oRY0x9yxWloawl+5zQvfBF9b85fWqZW690DxP17o8EVj1IgcSPlfuashAT2CLAJVK5
         jSwmQCTZkUfDE7NGE95Ew0eUzMF8J/oX6qp0xkaW7W0D9vsJaAbiqcwhKyibLpX4Tedt
         Fe3yZbDy6WmDGOe9SDZkL0UZv3jc9zBGdqC4kIRpRIV7XVFxUvFX/cwCFW0w1EsDu5Lf
         KzNpJV83sZ0QSd6/5n5L0aFNZbegxZX+41zaP9jtMKAu03qRQ/6fME1iaoSQ3GC6uonQ
         Vzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dTYvfnOluYKgTxdMcxZ/FPGnTnywlshfCqeGlC/4bIw=;
        b=t8hFEWNQS8ZR2qfTyB6JdPap+XGnFAptywjmfGm+Z8EfPRG3EZWbwFC9nSH3h4dAIS
         OQ1tqSq+CLxZijB8+xPXNEG64V7PzYhB0cmO8EGx5cYqj7qhxQlXrUEPDDuj/lc7BEYX
         6CTgK2ZD+n+tdq3svl6q2f/NYUFDPZtPPXvnyaOpeiouTeHSo6b1MATw2DYzPERdU+cj
         x+IpzHbuXZBxpdTMLoQ5jSQHhH5ZyvKxSneSMMuDOdDqKEdph1QJpC41U1iQW4A+sA4U
         fTzFMpIO3Q14VJW+odYNq+bIIadtNGQoV9Ft4LyiIuxSKjCoNb3ZtrfBEjDktYy4vmFB
         8Eyw==
X-Gm-Message-State: AOAM533eOYEKb5GLNF1skDzTZtAKG6yqBaj5BFabcDogBcf/UkWNc1Fa
        tdlgVZCHk0dTg8rNrPNNTTxOBDTMrX8=
X-Google-Smtp-Source: ABdhPJwBYBPf3hIzlZLO3uZTEVXVkF867c9Le/HTPd2ZAcrQJLs8GBImBHZVSAqC2ag4KZ6ynrEEyg==
X-Received: by 2002:a17:90b:90f:: with SMTP id bo15mr3453831pjb.80.1605097948596;
        Wed, 11 Nov 2020 04:32:28 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r5sm1680554pgi.77.2020.11.11.04.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 04:32:27 -0800 (PST)
Date:   Wed, 11 Nov 2020 04:32:25 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201111123224.GB29159@hoboy.vegasvil.org>
References: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 05:24:41PM +0800, Wang Qing wrote:
> We always have to update the value of ret, otherwise the error value
>  may be the previous one. And ptp_clock_register() never return NULL
>  when PTP_1588_CLOCK enable.

NAK.

Your code must handle the possibility that ptp_clock_register() can
return NULL.  Why?

1. Because that follows the documented API.

2. Because people will copy/paste this driver.

3. Because the Kconfig for your driver can change without warning.

Thanks,
Richard
