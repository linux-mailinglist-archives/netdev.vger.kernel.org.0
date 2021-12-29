Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FDC481408
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhL2OXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhL2OXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:23:23 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98808C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:23:23 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v11so18917305pfu.2
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CnNiRTBcajiOHYKIJXEhVed60QQzdoSDVZ2kiH3ve1U=;
        b=Z8pSt26pSx13FeJpHFouma+1Aq5g1GjKrsMXwkmtKBLFI4I2wO7E3yx+VEv37dJjcs
         /vla4zZhqy3BF1eBsVF2gPPvNVNs8N2ILfxWPh7to7+bXmHrDbSeMNgj4gIuuL4HtO1x
         vj9FHWEU092bIon8pg2Sv4do+jK4S2wvCLhOuzLb3f67ZYqRXMw1bxwAUXBhB+xCkGuX
         KMdPV1qvcOECyMWJ77O9F2xe285LQkQ7P6p+TkBCJYbiPMM95kH+GkS0c+M02LdpRUQn
         QPihDoH2/hYAWdCwWmmTUEDyr5MLd/Kufvf68SQhfoONUP1wA+GAviEeWbdmv6WjNtJO
         c86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CnNiRTBcajiOHYKIJXEhVed60QQzdoSDVZ2kiH3ve1U=;
        b=PHEwftPXdiRz3f6PbHhYty+i3bVBrKy7jasI/Owzc7itwowW4GswXuCRJM94l0Yifm
         CTGoTxi1hRchzC/6JqeKgoN/0kb2ZeohIZ+LehL7cIge+q15gejQ1cWYYunf9ssnp+pQ
         H7RgCmhzaFh1Ru5sTPaf/ZNlsd5XIQf1xoD8ntYkUCjd1n8G2KVVHAUCJLKIlLUQKANO
         FzZV9lmgowxB6XJspqwDPq3A/we2lVzZbI/sZpcNmD3KtACyh1maZ842WYLStYrmm1nh
         Q/H1X9mT9J4r+c2RF7zWdy5cHX4uCPEwNflbYOt/6Imv33G/tDITJNAZwzj79qPNpPh9
         Degg==
X-Gm-Message-State: AOAM5333ZNdYDgCin4MLjWGVv97YTzBFKbwFYLBt7VWTwxbwrNexw2nx
        how3MbXuNGvXP4V7lSvFq3I=
X-Google-Smtp-Source: ABdhPJyarHxCNGbtC6PO8SgpzJ51bqbCvoYgdnhQN2zUZfXNk2Tu6QuTPmk7TrfXqLuFEzkSWa18EQ==
X-Received: by 2002:a63:3d84:: with SMTP id k126mr22343022pga.410.1640787803112;
        Wed, 29 Dec 2021 06:23:23 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u2sm22532708pjc.23.2021.12.29.06.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:23:22 -0800 (PST)
Date:   Wed, 29 Dec 2021 06:23:19 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: define new flag
 HWTSTAMP_FLAG_BONDED_PHC_INDEX
Message-ID: <20211229142319.GA4912@hoboy.vegasvil.org>
References: <20211229080938.231324-1-liuhangbin@gmail.com>
 <20211229080938.231324-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229080938.231324-2-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 04:09:37PM +0800, Hangbin Liu wrote:
> As we defined the new hwtstamp_config flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
> as enum, it's not easy for userspace program to check if the flag is
> supported when build.
> 
> Let's define the new flag so user space could build it on old kernel with
> ifdef check.
> 
> Fixes: 9c9211a3fc7a ("net_tstamp: add new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
