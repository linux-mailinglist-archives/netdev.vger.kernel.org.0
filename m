Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75B23ADF05
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhFTO04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhFTO0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:26:55 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC89C061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:24:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pf4-20020a17090b1d84b029016f6699c3f2so3654903pjb.0
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 07:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zHYLZ6WO9bDBl0RZLh9aIBcwaTQciAxmA95nYh69dIE=;
        b=r0UC0BqI24iFym4A1KFFn8zbqIby0pvzBFM3uH562CiyZfRnxi8Hb65x8sh4eSC7Up
         V0LNDsXSNrMkau5MnE36sZrxl2xkjq2YCLum7woZnQTh7NRTH5My6lfTY86uDlJ0Ix3J
         K+PkKzuCE4qs4is20/f04FeR02LKH7wWt1Xnjaph9EkOxUD5T29kskOIK8M1uuzq1Hje
         9HeqCXf+rI8pESk0O7tW5GfpwDEulshbCIl98pZhuFeKUcCdU0MYdxhLPizm7CziYimI
         Q6jJtpO5J8gTnHWe72C6WfDqcd7w4QGn4w19gCt5cqDFnlbJWEAHPgEP+2+oJA7MWqmu
         Bn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zHYLZ6WO9bDBl0RZLh9aIBcwaTQciAxmA95nYh69dIE=;
        b=B0od/0kMXPLqp1YKskX8A6+eCYP1uy5F2LXM5G3KdSqEyNEPPXdTQ9dhHeM1RWeY/L
         qsbtXY6/LaTzmZkVaSqXfR581u02l1LPdBDcwXV+iKQw5vhVl+2JWeQUc9UcSevb5H3U
         lB2vZEueDK/bZSdAiBzDi5Tc4SbbvWXulibWeoicXkJGPT/YL1QoCjO6XJEZ16lk/2hL
         qsFX7NjxZuSIwjGghLuE+m5KKZKM29/zCwQ4wG763sQZXDRlkYQpkFEi3rebiboCASR9
         4bTnUFbvnzX2/QrP7rorvfY0PSuPvKzD5G/BPs3ZYQiFfhj0kHW21x7ekkILaT1EaAJy
         svgQ==
X-Gm-Message-State: AOAM531rWyCEQcZm0HpKBYKqekicf7rYlLpMCiASCUfTbuqvyCKo8I9R
        7N1MRoaByOeYOWr9U15ki0k=
X-Google-Smtp-Source: ABdhPJzhK8d7TNC8ABRktPdtlPRGBdJwTHgqnipr8gO55O1lmFt09Uzi7bhxcdDBD1vLvqd94qV/ig==
X-Received: by 2002:a17:90a:66ca:: with SMTP id z10mr3721219pjl.78.1624199082713;
        Sun, 20 Jun 2021 07:24:42 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s125sm2477972pgc.63.2021.06.20.07.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 07:24:42 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] net: dsa: execute dsa_switch_mdb_add only
 for routing port in cross-chip topologies
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <53938405-2ba4-558f-4f2e-b7fbca846636@gmail.com>
Date:   Sun, 20 Jun 2021 07:24:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618183017.3340769-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2021 11:30 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently, the notifier for adding a multicast MAC address matches on
> the targeted port and on all DSA links in the system, be they upstream
> or downstream links.
> 
> This leads to a considerable amount of useless traffic.
> 
> Consider this daisy chain topology, and a MDB add notifier emitted on
> sw0p0. It matches on sw0p0, sw0p3, sw1p3 and sw2p4.
> 
>    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
> [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
> [   x   ] [       ] [       ] [   x   ] [       ]
>                                   |
>                                   +---------+
>                                             |
>    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
> [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
> [       ] [       ] [       ] [   x   ] [   x   ]
>                                   |
>                                   +---------+
>                                             |
>    sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
> [  user ] [  user ] [  user ] [  user ] [  dsa  ]
> [       ] [       ] [       ] [       ] [   x   ]
> 
> But switch 0 has no reason to send the multicast traffic for that MAC
> address on sw0p3, which is how it reaches switches 1 and 2. Those
> switches don't expect, according to the user configuration, to receive
> this multicast address from switch 1, and they will drop it anyway,
> because the only valid destination is the port they received it on.
> They only need to configure themselves to deliver that multicast address
> _towards_ switch 1, where the MDB entry is installed.
> 
> Similarly, switch 1 should not send this multicast traffic towards
> sw1p3, because that is how it reaches switch 2.
> 
> With this change, the heat map for this MDB notifier changes as follows:
> 
>    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
> [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
> [   x   ] [       ] [       ] [       ] [       ]
>                                   |
>                                   +---------+
>                                             |
>    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
> [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
> [       ] [       ] [       ] [       ] [   x   ]
>                                   |
>                                   +---------+
>                                             |
>    sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
> [  user ] [  user ] [  user ] [  user ] [  dsa  ]
> [       ] [       ] [       ] [       ] [   x   ]
> 
> Now the mdb notifier behaves the same as the fdb notifier.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
