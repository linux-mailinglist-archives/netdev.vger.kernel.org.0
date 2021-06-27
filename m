Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8723B50D5
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 04:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhF0C57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 22:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhF0C54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 22:57:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365A8C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:55:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i4so6853808plt.12
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PMyYlkVwRHQ9DUEr8ngi8UQn9GVr2wePG86nkiL2lzE=;
        b=h53LOynHitcTvixuxfqSb6+jVhGNfIY5S2Mp6d6ZLxXBMROSaOW9tzkZlvHK6IoZmm
         jnYbyrecNypu12SWhHoS2WDBxh84GKIB0pTo9HY4oYaVQ6Esmr7KD1OzUYfcSDLCVIO+
         NCK3jMpjbXS1IAFjEpUh2wE8/7+7KVd4c5L7VglMwrP893QECi7A7oZ6CCp8QNLXkIVX
         +EX/DblPQp8xDgaRZeNyTZ6I9fiKbnluP75m9UoX20PmHk5Cj9nGelOg/5DmMMKAgoez
         VMYgctUE2B2+45RLxxERxmw9pSgmIb9yvz+7skxW0imKT/OeqBIzGPuQ49p+RmX3fnoJ
         90MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PMyYlkVwRHQ9DUEr8ngi8UQn9GVr2wePG86nkiL2lzE=;
        b=IuXxNVjuOYYi1fGQFIyohkZ7Q+RXjcwwsOzOuKM0gUq8AVj+B1BlUGCkNowGde114Q
         6geWRu0T8elEQNJjYNpQXxtK6177iEqWxfjubMm88MEEW8WFekQr7Mg5GZMpYPH2yS4C
         u2Hf31w/NAxj7BQL9tLyY5zXQyogBhB3hge06vPR+jC/JSFCpX3uUAtQs9oLiLsXP7Cz
         AkM2CsKBuP4nn7vmTElzXmPXAdKoItNBm1jySwU+zqWItpz62tqftjzclpdT48QhgeS7
         wLsyoPzF3E3maKogq9aDHeCKBl5B03JroogWZN30FmolEPEOb2ebeKrvwr/MhAt2EQ8X
         SUVQ==
X-Gm-Message-State: AOAM530hw8DT++3IP2dheSigwW82kcCHesEdnfTspxYWGooy4iodhv93
        9NbhoIPwus41LYr5Tcv6a60=
X-Google-Smtp-Source: ABdhPJyvO9b3D7LOk3utvQv2I3VKZXEUbuybTRtclOLGngI/AbgDY7kjtYNsIA/8Zbl99DcvEgV4Pw==
X-Received: by 2002:a17:902:f1cb:b029:120:768f:5b46 with SMTP id e11-20020a170902f1cbb0290120768f5b46mr15882530plc.3.1624762531649;
        Sat, 26 Jun 2021 19:55:31 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n6sm9805185pgt.7.2021.06.26.19.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 19:55:30 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: bridge: include the is_local bit in
 br_fdb_replay
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
 <20210625185321.626325-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a13657a8-d8bf-fe46-4061-60b093074059@gmail.com>
Date:   Sat, 26 Jun 2021 19:55:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since commit 2c4eca3ef716 ("net: bridge: switchdev: include local flag
> in FDB notifications"), the bridge emits SWITCHDEV_FDB_ADD_TO_DEVICE
> events with the is_local flag populated (but we ignore it nonetheless).
> 
> We would like DSA to start treating this bit, but it is still not
> populated by the replay helper, so add it there too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
