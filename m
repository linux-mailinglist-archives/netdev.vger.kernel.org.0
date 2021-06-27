Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9183B50D7
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 04:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhF0C7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 22:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhF0C7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 22:59:04 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6114FC061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:56:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u190so12105263pgd.8
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5K3Z9PlDkYH5BFqBYV3N7wulKTjLE4+UqXM5JIiKSF8=;
        b=jcaJKmXMy/Bm3CpsedDWG4QpmjKCiiU9cZeS6jEH+Kz8q8JXGBRAJZKIOLZ6+xog8K
         IC0W5f8m0FrxnDhm1TleV8i6Wh2Hh7OJ9Bul1MRUE+ZSdOT+Erb+QEH2fZMWYMnWowf6
         +aoxZsgRLw6gr6Qrc+Omird8WdhUFJrsJfSDhhxrwQ+YFiz/OLQiTwgTgrDDSNnky4GL
         YchleAKPNMmAg4zE8fUKsoyoyfujmZF7QcLPy1hH4gIfXImVUDrnjzUb/tqT80fPQa/H
         ySXCy+MTdtZkoJrPgmVRiksn+Y61bQZSQCpM1yEdeRIjIvXRk+mCPlBCwkzh65tFsEJZ
         8p8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5K3Z9PlDkYH5BFqBYV3N7wulKTjLE4+UqXM5JIiKSF8=;
        b=FvStKtdhdZM5LQxeoHej2m1JtzTg/gbjQQz8A++/1VHVAalcJhuv6qTVQk1CUvxsLS
         RpRKJGpUYVVWCuMPghSSl4DbUMw7gFOaV/xQcPD06iGITzCPsZhYk2PkiZoLK45RMnQH
         bQuH1YVvPfQNIuyFgLm98gEvBbbLgd0Nc86KItOX3YSxMJQin9aaIla6VZ6s+MKft9K8
         rUdbfRgYx7xR9I1lTSYtu3w8wjJwp8v/5LiwnKwfo6dACFhsnea+BTBUe6LmBf79cqxA
         Mkg3FPTZhBFWu8OO0KKDsHiYtgkp9EQxZ073BTaA5MtxHm5sDmfMFXO3l9jrUudJspuX
         BAAQ==
X-Gm-Message-State: AOAM531yfdu2A4NsUC01x0Qlrmv/42zy5IcJh6yDJJmkBDDpgwPlcFl8
        3X8XqSK6yaMlhiaHv8ZBe1M=
X-Google-Smtp-Source: ABdhPJwBZJx6BBvgsRa+QilernCCnWFFcpvrLh5PAm5NUeEP+F5eEoA2SU+HFbDk1NyULShFsd/6cg==
X-Received: by 2002:a62:e908:0:b029:2db:8791:c217 with SMTP id j8-20020a62e9080000b02902db8791c217mr18609578pfh.28.1624762600965;
        Sat, 26 Jun 2021 19:56:40 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id i3sm10692094pgc.92.2021.06.26.19.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 19:56:40 -0700 (PDT)
Subject: Re: [PATCH net-next 5/7] net: bridge: constify variables in the
 replay helpers
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e3e85fde-3cc4-4672-66ad-268671bf544c@gmail.com>
Date:   Sat, 26 Jun 2021 19:56:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some of the arguments and local variables for the newly added switchdev
> replay helpers can be const, so let's make them so.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
