Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4683C6876
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhGMCYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhGMCYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:24:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C812C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so1153131pju.1
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b+O/hTBAU4c7+jLOai3Zz6MaQKuBMbZ0EUKpHZHXDNE=;
        b=e7zsc5BS3yHMk+8OPMv0qI6y+OWRBhRSm9i4Z6fPvikbFTRhq40T75sktruWKK4MRv
         02bn5jxlqz/eHoCUNgJRR8QMbBqBNDfFWnLnbkfJVR60XqW33M5Ususy+oa2+ROi7u8U
         ZwE0oXRa5n3+zbTRZh7EfXN6XkPNlYYG1J/xlBN0TA8xOJhocNwHyqJ6xcmnRB+GODFT
         nBxBu5DuIU/87/cx7RrDYtffl6KoYqWVpgXW0BvGBO5fnR2gaUhSSbGpkcvLO0226FKH
         LR/mGBD9VBb6FS9etFtAL6/0Wk3JVnLT++0gvmLP5P0WvTszhHpDXy0g8H9dzVhy36Tb
         3TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b+O/hTBAU4c7+jLOai3Zz6MaQKuBMbZ0EUKpHZHXDNE=;
        b=hCatKzm2nBhb6XjyO1iBsPQT0MK37V+cI481Xlj3GYHNPMsZNmOAmoZEIkU0ix6XNi
         mqjemUaK9kY2iVRTUJnWShtgQ98fX6qkO7qTp7EApu6PQXE1m9wedcMEA8m2UGH0yMsb
         tkh6QGdSOhnmREXKH+c+/Lt2wYAt9t/KJecILYhNot9cAIzT/unuiFWkDtmhJhV9Tbv9
         fycnCQvE5SbqzWyOxBIcl3AelkFhDtfI/HOn8J8EBVneGxZ+EBfLOfTyoeetPR/dC4E3
         OTNjPxuD8dPnaIdupVPnZ06gj9LfWC2eLhTGW3lwc8OHxUxE9VOdkpl8X5TUY0UbakrW
         Sqaw==
X-Gm-Message-State: AOAM531YgmqsHjdQwZ41KEtAZBAL2UoVcteTMcrbQYurtRrDhoLk/aZD
        dSmY+0WBU64v/+b/h5ZLWMU=
X-Google-Smtp-Source: ABdhPJw4cy3VVuixyaJ8cZn4nsskfjydQgU3ZOOKoUTGaZDxetTkSJ3PEAm6x5PaQXaswLHhry/soQ==
X-Received: by 2002:a17:90a:af88:: with SMTP id w8mr1914042pjq.74.1626142879597;
        Mon, 12 Jul 2021 19:21:19 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x13sm14497645pjh.30.2021.07.12.19.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:21:19 -0700 (PDT)
Subject: Re: [RFC PATCH v3 net-next 02/24] net: dpaa2-switch: refactor
 prechangeupper sanity checks
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
 <20210712152142.800651-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <20515ce3-7286-931a-e086-1778dfafa7a1@gmail.com>
Date:   Mon, 12 Jul 2021 19:21:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712152142.800651-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2021 8:21 AM, Vladimir Oltean wrote:
> Make more room for some extra code in the NETDEV_PRECHANGEUPPER handler
> by moving what already exists into a dedicated function.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
