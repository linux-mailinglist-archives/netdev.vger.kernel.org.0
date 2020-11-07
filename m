Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EEB2AA614
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKGPHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgKGPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 10:07:06 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57E0C0613CF;
        Sat,  7 Nov 2020 07:07:06 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id j5so2360197plk.7;
        Sat, 07 Nov 2020 07:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LmB4DYOplEdxdVAp4i/Cv8GxfNmTwSJWFjvTe1z2P1Y=;
        b=I9BygavihvgZRQ25TNZ7bjf1rdXSNWIAnLgtArrdkI6nuWKCWp3yCf0kjKSSkRfrNP
         ouojl3FWa4hTwGSkYKnH/yBo9amHMYwYiTjnhrOiTIa07T11jOCNIxLj/6jKCWdUuIOg
         DbhFsNwAkK8283PTCDebc+xA3R3vUc7Re33z1ustGIj2zXW84WhbCl+uoWJ6Wee717w3
         bITLE5FuP/8lB6uB3T7LuVKaGv4ISyDDOdnDcxX4W/jlkdThke9DvyPXtG7WD1q4/X/q
         BJCqCnekjpv9LeF9IbkHKWToShk8BrrXCgktMDkmHvrnW2ftrGokv0Hd3Sr6ZlMVaR0b
         nWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LmB4DYOplEdxdVAp4i/Cv8GxfNmTwSJWFjvTe1z2P1Y=;
        b=UKaxfWyUn/Jzsi3azXpUAZ9OoWvxdKnFTLPXfII/zX2VLR+no5mVxJmfO/4nWXPNIf
         80uzGMyIb/BkQa+beEeCHIfo2K8bvtg4MVnPIqBgHdkHNHWC4m+Jt0yP2TT4sbAelifU
         pJU83PABAus1tkhnw3TmBJTTDuICcu3ykgGw8lEN5b0boPf0f5E0vtuGEHdlBTZD4T3a
         ZQwDW8Ddw81ETZCpZI3ZHh0adkZ4GhxSZzEYJbrDHaJ3z72MFCOL1vNzO0yvjQEDcK+1
         qCeo8n8Hi4y38hG7rpV4sTx3Q+e5p3cxCxn8Nf3s0v2q/JCQDpm+B6gxdrXNYeQez74X
         w0LQ==
X-Gm-Message-State: AOAM530shSiwSURigAe0KCwwbwv5hkOg2aaNDfKHTJJdJSBh8KJ9W1HL
        vJ5E+9alxOm9OxwmuyVaDDlxvq9KRAo=
X-Google-Smtp-Source: ABdhPJxqqowq4HfM+LqJHk04+FxPE01f32lq7uO1vSTh9wihIW4oEZwq5Pmf1TlkHGt3jck8fkzzGw==
X-Received: by 2002:a17:90a:af82:: with SMTP id w2mr4653201pjq.77.1604761626122;
        Sat, 07 Nov 2020 07:07:06 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v23sm5782190pjh.46.2020.11.07.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 07:07:05 -0800 (PST)
Date:   Sat, 7 Nov 2020 07:07:02 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Message-ID: <20201107150702.GC9653@hoboy.vegasvil.org>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
 <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd46310f-0b4e-ac8b-b187-98438ee6bb60@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 01:34:04PM +0200, Grygorii Strashko wrote:
> And ptp_clock_register() can return NULL only if PTP support is disabled.

Not true in general ...

> In which case, we should not even get here.

only because the Kconfig uses "depends on" instead of "implies"
PTP_1588_CLOCK.

> So, I'd propose to s/IS_ERR_OR_NULL/IS_ERR above,
> and just assign ret = PTR_ERR(cpts->ptp_clock) here.

No, please no -- don't make another bad example for people to
copy/paste.

Thanks,
Richard
