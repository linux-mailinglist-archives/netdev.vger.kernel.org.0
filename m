Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5BD356B6A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhDGLjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhDGLjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 07:39:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18560C061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 04:38:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p10so4053990pld.0
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 04:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZrAQJPaj0ZkfOYX1RYSkQYLsIQMrrhZ/5wxjY+AG7z8=;
        b=EmDgwAV9FcWj8MoebQCbq667SfNwLsOgztD7/cSI9GIOSf6f47dlh9SJYHn0K8OISd
         O1uK5K0N96gXdBHmrWtfTQKA4GOVWtK7RYBBlt0UhYfOqYV3Xi8w39nQAMWoVwizGeuB
         uCUFow4VXkfckASdK6SFLEZtXGscbfyjGETximoaz/Y29hM7jsADV35dqRxO4eKKLmNz
         I5EzRnjRBl3FrBaR33e7wQDGIzUvd9r3I5DvUgxJAQSbKre50y8Vv3avmdpWoKHqhp8H
         ZSwHQDar5eeHCMKfpbW0yh7Fxx4Y8VAwXq8DtlvCimiHmDhQnIraatfuBd7Ei3qgGDzo
         CNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZrAQJPaj0ZkfOYX1RYSkQYLsIQMrrhZ/5wxjY+AG7z8=;
        b=dXhPYq7e0IaSYDsPB/rT5yJI3rY+Uqm23ecCtxSvzw9tHE6ufraJZ2jmLCbeGvDK81
         Wl1zltSHCaVRI9RQBUdP+Hr+SlqDu9zcrPrg/VbLnHQUsEuQSpprbzOrAMXNuCfY714z
         AE0em+uWfTtxdpTH3nyx9ZfzjXd4JET54Tc+Ty3LzMqn3gxphoG6Py7Fe1BtODUGIkGV
         ZSQu7SYm7Yqr6gEjXVRVtH8F2xBq4t0zRDqLf7f2oOHfqCqfPwvLPHxHgy47f0G191y3
         7UHwQ8qCtaFwY+od5dnXwcbLYG2lNHrlhJ2kWFykUYP2TUroywXSvqoPlXPSnRtZ/onq
         zGXw==
X-Gm-Message-State: AOAM530B7ZxlHWqyGRSRMVmtf7VkTI6Ex4l38Qb1/2PnM2WdzE0UUj8x
        jvHDxPtQMGXVASlU3VN0i93gvwy3H67M6Q==
X-Google-Smtp-Source: ABdhPJw1Qfd0shGand/1r6J9ykfi06mHT4+dJTIOMTK/Pi6QZIieX2JFFfHSqAoKdFKnf6SV/WjPBg==
X-Received: by 2002:a17:90a:d984:: with SMTP id d4mr3040374pjv.20.1617795533309;
        Wed, 07 Apr 2021 04:38:53 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j20sm5216733pjn.27.2021.04.07.04.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 04:38:52 -0700 (PDT)
Date:   Wed, 7 Apr 2021 19:38:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] wireguard: disable in FIPS mode
Message-ID: <20210407113842.GG2900@Leo-laptop-t470s>
References: <20210407104307.3731826-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407104307.3731826-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 06:43:07PM +0800, Hangbin Liu wrote:
> As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> FIPS certified, the WireGuard module should be disabled in FIPS mode.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Ondrej remind that I need to cc linux-crypto. I will resend the patch.

Thanks
Hangbin
