Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D8C440B96
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 22:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhJ3UJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 16:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhJ3UJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 16:09:53 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70E0C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 13:07:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r28so13352723pga.0
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cyc43r8GdPRIRNRzw0no3zbXsiEelKCLzckzNGDsC6s=;
        b=b82oDSTzxfv98G672X0/DEzxrahh5Mz/q3bRp6zpJaskF3JiguWUYKdAMpmDihTZqi
         k/emgjqMl9bbCjn93a5OoB92FemMiqhis6t4Me94ssuoIuBuvphYARMkxGhTEs4STc8B
         7pQTnl/GnPMo6aA+c6cU8KdZ2H3zZyGxAppFMtcdCT7oQF8QUlZ1WuvmyOkHsBZ3Ko+h
         3rxZcBVB+HKyGXqJX853j/rzqEv6wl28Aw65iCZfJBwGDo+m5cnSome5PfQgDybVKmZB
         32ByL0nDZJHwDi1H/2Qsz3akZQyVwihjaxBL3jDRJ2e5tfv/Qs1p49r8NLqVAoUBynAt
         5yyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cyc43r8GdPRIRNRzw0no3zbXsiEelKCLzckzNGDsC6s=;
        b=Lu9rW4HBP2LnHPHy+3kiSnLB0MP1DRcZqFt/kupn24lYl0EG+jH61BBrLflocUkpwV
         ycQZ4SqMHu4YaiCDKXkPmGyxUx0tF3ob7CoN8Rj8pBXb5JX+iLe4TOVUDWdofaNxLKj0
         gJQ2mxxriOQNzCLLIibLICMFddL9ZaWbXACqHHaivfbbnma1f7+hudraM5luEQbhEXpy
         2oYWtkejNuBxu3OX2TLHX5CbI87ZfROZwjG5i3dyBLOja/KEl2ZYa7K0HpraP0B9Pf5d
         ZX7bEo+efY8FwiWzRWX3zqHcnSyJC8lia13iRmm+ImeUvzit/VCZEN42Hv5QMDh7QoZN
         3Akw==
X-Gm-Message-State: AOAM533cJbs8v0my9KXdR24u6w2kwgz1/HgHacUGegXBZGFGOTlXVw4u
        2lo1CHecQaYcHwVQCxwm0sY7Bg==
X-Google-Smtp-Source: ABdhPJw1+SO+sO4sXJozBZNr5KL4BvxlQY4xSjZVKQGmgSAXJ5bN1iMCPtgRGu6CS7IXrqyZY6sptw==
X-Received: by 2002:a63:348d:: with SMTP id b135mr14129383pga.87.1635624441806;
        Sat, 30 Oct 2021 13:07:21 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id ne7sm5039241pjb.36.2021.10.30.13.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 13:07:21 -0700 (PDT)
Date:   Sat, 30 Oct 2021 13:07:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        wei.liu@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, shacharr@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com
Subject: Re: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
 argument in mana_init_port()
Message-ID: <20211030130718.3471728c@hermes.local>
In-Reply-To: <20211030005408.13932-2-decui@microsoft.com>
References: <20211030005408.13932-1-decui@microsoft.com>
        <20211030005408.13932-2-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Oct 2021 17:54:05 -0700
Dexuan Cui <decui@microsoft.com> wrote:

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 1417d1e72b7b..4ff5a1fc506f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1599,7 +1599,8 @@ static int mana_init_port(struct net_device *ndev)
>  	err = mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
>  				   &num_indirect_entries);
>  	if (err) {
> -		netdev_err(ndev, "Failed to query info for vPort 0\n");
> +		netdev_err(ndev, "Failed to query info for vPort %d\n",
> +			   port_idx);

Shouldn't port_idx have been unsigned or u16?
It is u16 in mana_port_context.
