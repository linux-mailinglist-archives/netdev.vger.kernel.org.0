Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBDF2E028F
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLUWeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUWeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 17:34:00 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD4EC0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:33:20 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d2so7277838pfq.5
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 14:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQsU3BG2+gjYwjHD91HA1V5TCapqExwzb83x74TB6lg=;
        b=YIqUyvpEmrr9FCTKmfOu44g9Tykj4AK6S0mPvksnjsDKmJeuXLxaDek+qK2AVtWpH4
         nVgprAywiRG2sTK/+C0dtbnE2Ww7c8vUJ52OMjrxcvYPiSQfJs1/KQ6RofWrwSqmU62+
         DwXw9BAJnqScvlh2ZY+9GGvf56JDemgNgM6fyznu+MvZYoeuwepaf3uYC0gykKjK9OIr
         1acY+UHekTGgtvIiveAMfkeFjGmbJtYvfz7/S2X5hrwd+f1k+9Wzza7BioDzpLMfqUOp
         gAKsiKjKvjUO+mN8nbYs8k20xZN71c3exgAdH+zwLAO2Wxy3R7gi11YHYEgVkOHFJfXq
         TzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQsU3BG2+gjYwjHD91HA1V5TCapqExwzb83x74TB6lg=;
        b=PA46tX6DlOuHO+hyu73VFJaOI3aCVx0wj5rIwe7EnWhYBVO/aiFKNCD5pwP8M+AFAn
         8KUbTTqUPmHXI00TuYL6y74fJC50PBHkwpRl7ku41Nvzl9BMtjizrq8sj8fEKsultd5+
         zFatLCBZPD4GnZY1je0y1iNfdXCDXuoGIzrsgNQn4VjaBQkQkNXAaa7NOBsEj2wiU3QQ
         7C8K3qMq2Ewc8jMZ6rQs0ehxo/C//d8SKwN1sXFQmvgoaFGqAdSc3cabzBAEkkYypXEz
         vx110JFjZFPesAQrIN5JDEBC59IiSjxT1tcQbScF2l6Uqa8wih942wTmtiipX4FXd5Xs
         BczA==
X-Gm-Message-State: AOAM533mhuvA+eTCteJXgjiUySQFHHOeYHNe6A/dKewaJkq3YrzOlbft
        I1lqvttb+s1s4U30fixK7Lx3sCGxFZc=
X-Google-Smtp-Source: ABdhPJyuzfxwztV8Kr7UDGCXL1WsxkPBUTE89ISRLWaQqM+OXvqXJzi2GzdnqgTYjFfY6S5LXjZqow==
X-Received: by 2002:a63:5014:: with SMTP id e20mr16899391pgb.152.1608589999172;
        Mon, 21 Dec 2020 14:33:19 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t25sm17689596pgv.30.2020.12.21.14.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 14:33:18 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
 <20201219121237.tq3pxquyaq4q547t@skbuf>
 <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
Message-ID: <9bc9ff1c-13c5-f01c-ede2-b5cd21c09a38@gmail.com>
Date:   Mon, 21 Dec 2020 14:33:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/2020 8:53 PM, Florian Fainelli wrote:
> 
> The call to netif_set_real_num_tx_queues() succeeds and
> slave_dev->real_num_tx_queues is changed to 4 accordingly. The loop that
> assigns the internal queue mapping (priv->ring_map) is correctly limited
> to 4, however we get two calls per switch port instead of one. I did not
> have much time to debug why we get called twice but I will be looking
> into this tomorrow.

There was not any bug other than there are two instances of a SYSTEMPORT
device in my system and they both receive the same notification.

So we do need to qualify which of the notifier block matches the device
of interest, because if we do extract the private structure from the
device being notified, it is always going to match.

Incremental fixup here:

https://github.com/ffainelli/linux/commit/0eea16e706a73c56a36d701df483ff73211aae7f

and you can add Tested-by: Florian Fainelli <f.fainelli@gmail.com> when
you resubmit.

Thanks, this is a really nice cleanup.
-- 
Florian
