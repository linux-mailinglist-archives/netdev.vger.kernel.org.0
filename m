Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B9F3828C8
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbhEQJuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbhEQJuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:50:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0398C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:48:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v5so6073921edc.8
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5mb37F9ApueE2CdQ57xVOGM61xKCDM/x3iWcZMRkMpM=;
        b=EsdSVTZuove0kp8uehfnj1iWXyRQ432Uw5dRPqR2hSmWO53LEBt6gvCRw0BY44ChwL
         ITKd2BOf9V7K2HHd/Pmkz38Kp+xkjUq/rk9FtkFOTPlyGzIy8RGrVlKrfWf+Ibkpu6MS
         zW2hQn9fVSkbHTygNnPrir4IJ36XOPkG4H55iiz5/2gGYWM4iPvC31Pagat1FoDhBjtd
         sTwBDBNW8Mon0XIcvvjf3Lmze36ONVRlD48g9WDVbgjZYKIk7jjoszkiwG0hgZ2iM3jo
         C1xK1tFY4KlJsyej15n+vyR/qN2j9D8kz7N8gNuIdYlewJdQbiiD27Cba01b3d8KTWUw
         L4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5mb37F9ApueE2CdQ57xVOGM61xKCDM/x3iWcZMRkMpM=;
        b=A94qbF5bt+GB6hJfY7usVc0OkeKuM6Qcp/S1bUE/TY1OUfDluWV3CS0sKElwx+uH2E
         Va+UbAqJHDHvt9KrLj1If1JFS4G4dxw0QMeaFcVCiRiIpstnZlDuwVhUv1sCWwm8wAVe
         BWOxUTkI24LMYGit7Csp08LQHIlshGW9tMmKTgaGx3Co14Wsbh2XzewEtIZtcTHLXR0D
         hrQ9vYPLXse56befb0iABTwyqIYzDY6iVCkeRaNR8J8CDW05HeynqNnkqYuzVexmkHG6
         hQzT6gOpgRKsQQMIYVVEQgQ1s382dbNWRyiXOYWUSPBVaFHCSNLjm2LtFOUKI1/gFYap
         JPdA==
X-Gm-Message-State: AOAM533qwI8UdN1/zr4aYUd10KlNXjRNJ9oFjUkIyaLFTrF2QNp/lV9i
        Pv65HJtnHzqBS+u/LsnsMyvhyw==
X-Google-Smtp-Source: ABdhPJzxF67I0+LRm+nHo+MRoZa/d94e+kmAoqCYV+rHgmjfOsfNXtnw6ytiO3tgiaP0V0s5QHWa/w==
X-Received: by 2002:aa7:c488:: with SMTP id m8mr7868459edq.193.1621244931441;
        Mon, 17 May 2021 02:48:51 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id bm24sm3996752edb.45.2021.05.17.02.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:48:51 -0700 (PDT)
Date:   Mon, 17 May 2021 11:48:50 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, tglx@linutronix.de, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, oss-drivers@netronome.com,
        bigeasy@linutronix.de
Subject: Re: [PATCH net-next 2/2] nfp: use napi_schedule_irq()
Message-ID: <20210517094849.GB17134@netronome.com>
References: <20210514222402.295157-1-kuba@kernel.org>
 <20210514222402.295157-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514222402.295157-2-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 03:24:02PM -0700, Jakub Kicinski wrote:
> NFP uses MSI-X and has the most trivial IRQ handler possible.
> Perfect candidate for napi_schedule_irq().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)


I understand there is some discussion around the merit of PATCH 1/2.
But if that approach is accepted then this patch looks good to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>
