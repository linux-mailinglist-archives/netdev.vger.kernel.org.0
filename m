Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C01D205E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgEMUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgEMUpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:45:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA50DC061A0C;
        Wed, 13 May 2020 13:45:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x2so260477pfx.7;
        Wed, 13 May 2020 13:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l6ZLkPS67detVrS1iN0u9LMW9GQtxKcoSH1TzpnGCwI=;
        b=UWesIGRWAZe0a7acWQCPku0H11pFvlcJZNVIbPoVCFuSg9skXHcQhQ25NPDXRkEPZU
         PHYHBS+/LT920IwPGccjQZBZpAPf6mZgv74OsRcwn64ZZIDBKNLcCvnbvqeUCx1Nb7Bt
         lrD0ZiGggUfitfpWt/rFs0LXKe39QJz0uuGjBDq8aCUG59vFDGqFxbj5blWO/a7Gd0Wz
         7cYEuf/pN9R8EiJr9QPKGamVFRkatDasZ73j0mJnU4xR9xx0PvB7tfXzIUvNStGDzCbc
         2YQ7gTunFdyQQxNbqrcpm9jT4OATzQH0lTauFHdfT8xmsgK+v7on3DeX2Ie5Fjt5eE/0
         zW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l6ZLkPS67detVrS1iN0u9LMW9GQtxKcoSH1TzpnGCwI=;
        b=MiVpSzWMAcxKAiZI83SQU+9ipCYBRsWfcHw/xyBW3+8Cu60eD7pYpy/sI7BsIvonC0
         xCBx9pyRWN19CaINjfgIyzJvQRGIsoQmO00YHb33hWaKj9Fg7CQ1Zqd40eFETWY5BGQD
         ypSLv5PIjhGVVLxuFlzPsLCYt73EqUqGbUbU7Ifcp3C+IkO9nfcgHtNmYKsidzP8KxYH
         t6VLLgiEbAt0ya9/avF801E6IM4vmGtdY46hhuyZsqlZK53iab5O97HBMjMLnwpmKsTE
         IJ0Hbt/W4atcZERo+UAdn1WIAkMEnnIhZq4N/paXuwK1LPQLeWMfdVG5pk7DogNkZGqo
         iJnQ==
X-Gm-Message-State: AOAM531pJrrZpkF+1xjZYtHMMi0QsTisceDcQqP1nYb7wgkyUq/nH1Fr
        v9im9+On3N4xI6kF4SjYwwg=
X-Google-Smtp-Source: ABdhPJzruo4puhQnKAqOr8huVzuILNEn9hHm++oNLkHP9cN4cjGHgmsFWFNIzUbMq9fWlnUOHdRsSg==
X-Received: by 2002:a63:2244:: with SMTP id t4mr975976pgm.375.1589402731188;
        Wed, 13 May 2020 13:45:31 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h9sm378700pfo.129.2020.05.13.13.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 13:45:30 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: phy: at803x: add cable diagnostics
 support
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>
References: <20200513203807.366-1-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1b8547f7-4cda-e1d9-f2e4-2d6032fd6fb4@gmail.com>
Date:   Wed, 13 May 2020 13:45:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513203807.366-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 1:38 PM, Michael Walle wrote:
> The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
> driver support is straightforward, so lets add it.
> 
> The PHY just do one pair at a time, so we have to start the test four
> times. The cable_test_get_status() can block and therefore we can just
> busy poll the test completion and continue with the next pair until we
> are done.
> The time delta counter seems to run at 125MHz which just gives us a
> resolution of about 82.4cm per tick.
> 
> 100m cable, A/B/C/D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: Open Circuit
>   Pair: Pair A, fault length: 107.94m
>   Pair: Pair B, result: Open Circuit
>   Pair: Pair B, fault length: 104.64m
>   Pair: Pair C, result: Open Circuit
>   Pair: Pair C, fault length: 105.47m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 107.94m
> 
> 1m cable, A/B connected, C shorted, D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short within Pair
>   Pair: Pair C, fault length: 0.82m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 0.82m
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
