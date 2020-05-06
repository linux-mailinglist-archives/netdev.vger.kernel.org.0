Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC91C7AD4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgEFT6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgEFT6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:58:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4AFC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 12:58:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so1608940pfx.6
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wtyc00Q0HXrU8VJQEseW+ZTpRVzS2sApnXbSBzzFqHM=;
        b=bkr6OL11icxmHVp/XC5bOiaF8Y3XK8Jb8kjW4MzzGZSV0KagPNSdKOo+SdAgL8TVx5
         WQgaKrCU1a2/RNxzr5el3DnjYMhhkbU+2bp96ku2huPcaLsviOn4RT26VkN+s5wlWgT9
         7YaYHK+5Oi/mo+u4L6qSGwt7zlSeTgPmHt5HcgR9hjnocM58X2XlGytdm8wcj4GTmyOn
         q86c6rOMDPshyiXB1ytq6hDQE2GZxnsGk0CeIbRPF4o2PV6JLiLn5hFaoMuR1wxciDwY
         7LAfCMsmcVp8CkOkQqhN87OZW0h71UllrQdGrMtpOOV0hMVu0VwcewDbdHcya6LCiy4g
         PHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wtyc00Q0HXrU8VJQEseW+ZTpRVzS2sApnXbSBzzFqHM=;
        b=kmU7n10B6T8lewz2y1j47f/L6CKKUku0FuFCuZql93clNxZGJiryDnNmbokisa3OUW
         RYD+S/Q/FBqZGLxuZbT5z2oVsRIJFTZtuAtnK9ysDTIrsclg5NAzF4JD16O9o94HAA1A
         EtYMfy31Zgo8wEWxTIoFxGUCNamAP/jZxvNVtXHXPdKUem3AiwCXFVj6yqdqpJZw2m9N
         KUPMo5X5is75S3mKRPhoRGQvM2r0HXCNlDo36tZMhx+2WDc/RUgmJhUAFPt+xr6O2o09
         BgNNnh8oJWU/mKgzOX8gGc8FEwgDcB6M08/k9d8zT3qOqR30NTPUQnrNT4K35xDtqEus
         nSzA==
X-Gm-Message-State: AGi0Pua9hOmjNHvZ2Q57XMzHsi9duZavbSxPQpCSJcVsvLPwmT7maPh5
        ivHQAR7HPctldfRkU6md9gQ=
X-Google-Smtp-Source: APiQypIKR+L1YXPMCPhp2+ZvGFJeMRCE6nUDxJ03YHGGdcpHhbvefWGQwhXERiZ4+Si8aoaf2lA2qA==
X-Received: by 2002:aa7:9689:: with SMTP id f9mr9823532pfk.24.1588795111195;
        Wed, 06 May 2020 12:58:31 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b16sm2589758pft.191.2020.05.06.12.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 12:58:30 -0700 (PDT)
Date:   Wed, 6 May 2020 12:58:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, christian.herber@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: the PTP_CLK extts input reacts on
 both edges
Message-ID: <20200506195828.GA677@localhost>
References: <20200506174813.14587-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506174813.14587-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 08:48:13PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like the sja1105 external timestamping input is not as generic
> as we thought. When fed a signal with 50% duty cycle, it will timestamp
> both the rising and the falling edge. When fed a short pulse signal,
> only the timestamp of the falling edge will be seen in the PTPSYNCTS
> register, because that of the rising edge had been overwritten. So the
> moral is: don't feed it short pulse inputs.
> 
> Luckily this is not a complete deal breaker, as we can still work with
> 1 Hz square waves. But the problem is that the extts polling period was
> not dimensioned enough for this input signal. If we leave the period at
> half a second, we risk losing timestamps due to jitter in the measuring
> process. So we need to increase it to 4 times per second.
> 
> Also, the very least we can do to inform the user is to deny any other
> flags combination than with PTP_RISING_EDGE and PTP_FALLING_EDGE both
> set.
> 
> Fixes: 747e5eb31d59 ("net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
