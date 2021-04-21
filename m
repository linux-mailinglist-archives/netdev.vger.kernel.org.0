Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837CA367040
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbhDUQdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbhDUQdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:33:16 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72F4C06174A;
        Wed, 21 Apr 2021 09:32:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m12so9672419pgr.9;
        Wed, 21 Apr 2021 09:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dbbH5mU0eZQOvfNmncVtsU5aW1qxNpTR7xNLktkxO/8=;
        b=r2pyaVk2t6foNEjWeJgrpPuyNXGzX/dF+DIu22dYUss19nfc4lBaUxn8OQ7azwSplI
         nX0gqVnTVlg1Us4NtxIYike5JKI8ygpel1bfLgzbjgKWHP86RfWJwIFVWCEIGpfHMMen
         YSJ8fR20KjjLk761nB5Dh9Z5TpXopTYm1z9A+YSNH7rWN0FwIBk/c5x8UmyZpIEoRODx
         2m6aBQSr+UxyCfr0cPeKKQgmonBo9iNxhzYfECMVWEI8ZqTf58H4wuJ/BiU9/ZwPvOSO
         6aMPDMlnpWANyfXqvjOwsfzd2ak8rZOIK9LfFnmI4MC/LWPZv2B7nKoEMZvFeCsPEHd7
         qW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dbbH5mU0eZQOvfNmncVtsU5aW1qxNpTR7xNLktkxO/8=;
        b=Rv5CrSZ5cenWSj0f63jb3CMTDooPHVjADd3/XJfbC33AIeT54XXz75WCNkbMR5njti
         USBeIrufxe7B4Xo6LMUj6vzqkVMjaAtdXAdq2h3tGvGn6tgmTnKBdfe9RxMvJx+pC8zJ
         eEj0ViQUFU2+6/i1D5c8IuFSwVjmsBeHS+BR7U65u3KVkTARzEwTQyHWH1VOFTbMtWVU
         hQDKIjlGWSgkxujWex2Xa2k36Mlrfdkz/es4fymas9Yh3Sb5vYrn9/ttdERCAWifJjjQ
         ddy77Gn2pPMglkEBE4QD0nCLZ62EO9jtsHEqMjik5l5ZPR6qCw6Hcl33urHIeFr3XQds
         5quQ==
X-Gm-Message-State: AOAM5319luzG+hHKZEfO7goTMHIm/GH/w7e0ymPsNHRCrnBMBKEnHlC1
        431mvgUmFVt2saNtfD+4Oqfr56Y/sk4=
X-Google-Smtp-Source: ABdhPJx6glrHRUC62q7tOtGWilSy1urFZAUxX7xDjf+r/jBBvgSwUma1em94Dza3fRJUG5e63dF7xQ==
X-Received: by 2002:a17:90a:c209:: with SMTP id e9mr12234306pjt.104.1619022762408;
        Wed, 21 Apr 2021 09:32:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s22sm2630721pjs.42.2021.04.21.09.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 09:32:41 -0700 (PDT)
Subject: Re: [PATCH net-next v1] net: dsa: fix bridge support for drivers
 without port_bridge_flags callback
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210421130540.12522-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d1b615ef-4a0d-2bdb-b41e-e4dcec8fe14c@gmail.com>
Date:   Wed, 21 Apr 2021 09:32:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421130540.12522-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2021 6:05 AM, Oleksij Rempel wrote:
> Starting with patch:
> a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> 
> drivers without "port_bridge_flags" callback will fail to join the bridge.
> Looking at the code, -EOPNOTSUPP seems to be the proper return value,
> which makes at least microchip and atheros switches work again.
> 
> Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
