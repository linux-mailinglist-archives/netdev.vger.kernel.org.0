Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C090623C343
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHECFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHECFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 22:05:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B039DC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 19:05:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u185so21808378pfu.1
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 19:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m9dbTCrc5znaizxjNrKUuKFU0zDRtjHpowUMWlyIsZk=;
        b=MYQyYbPrEVnr9PPP1JuH5h77MiSE4WCRx9VD/LQgS8ZtzA+/L/hTlcCYfCOvSsohhn
         i8DjiVInxNiC34L16e7bTRZTQs7zk6zwClc1AhtQ/+Ely+zW0AMvNYvwyr0emsFiOUOb
         RsAVR6BFh8Vb/mfq/iSfyPSR7BReNC0vX1tWa5JzFv2lvb01dSSrhrqmIA+F16NexrHL
         nO6d6TSA+XCd+vF9KNwmcmZ4FMfYNEY9BW3va5zUo6SnZYKzX8u9yfsBkUv/LkMh+APg
         /1u6UWYHAwuATqiydtwEJSbquedf4tirii5UsPR98YrMwbn7xf0z6tysvLnd/BwQUcvN
         5y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m9dbTCrc5znaizxjNrKUuKFU0zDRtjHpowUMWlyIsZk=;
        b=gFBFnY2ytD8u+VZYm3yLjUlYCj/KXPP/VGCqUAtF1/AvPal5ySqQix9NAwrZ5P9uiZ
         8sGbib5iIjCsdWnV3PZy9Ts2hGm0LjvbSuMKFyWbXUtu1v5o5iiWp/XQ/wjgs4v6vUuZ
         75oC3wEQEyE6SAGe3WEopU/imt9Our/KBDib+/D8D9h6+pjXfEkHsLgnp9jprrK+W+ZI
         M1N2JcAOrs8x1ZLn1LQPBvYK8PYmmE8UtduJ1JXjVoLOUu0EmAttuXr6BgtFeN7zmBKp
         KaUeQfoxD075dsyKjs78wMngXwj3Y1AYvZRhavsWGZbXqPoYcLHjkup8vdEr/7a7WQ0B
         kjKw==
X-Gm-Message-State: AOAM533WZlibjzFtY/5fFmE9eb6mdfMC3+UFdUN/1hrwVrAgp0YiLAOH
        U/UE2AF5CfeBLUN3qu5k5Ew=
X-Google-Smtp-Source: ABdhPJz18Pm/2DDKIE5046mA1/xdwE4Pvr8sBbrFIPQ4nXUKIyvUR4CoIBREym7oqoVj0MhZ9tTo/w==
X-Received: by 2002:a63:db46:: with SMTP id x6mr995974pgi.265.1596593144069;
        Tue, 04 Aug 2020 19:05:44 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a2sm669745pfh.152.2020.08.04.19.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 19:05:43 -0700 (PDT)
Date:   Tue, 4 Aug 2020 19:05:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: Re: [PATCH v3 net-next] ptp: only allow phase values lower than 1
 period
Message-ID: <20200805020541.GA1603@hoboy>
References: <20200805001047.1372299-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805001047.1372299-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 03:10:47AM +0300, Vladimir Oltean wrote:
> The way we define the phase (the difference between the time of the
> signal's rising edge, and the closest integer multiple of the period),
> it doesn't make sense to have a phase value equal or larger than 1
> period.
> 
> So deny these settings coming from the user.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
