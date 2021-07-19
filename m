Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67E83CCC36
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGSCXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGSCXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:23:34 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66DC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:20:36 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w194so19058406oie.5
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EsGNcxhUNDjpw3jd2PBLWZrFBrLemsllXRQ5T8XmNN4=;
        b=i/+5sh9nbghabMKPFon1cWSeCuZG+3hzirZxIEbeq1aVY1aSNB5SD/64V/P2ljBLGj
         0TH9h9ViC9rx7AtbR6Qm6zLtvezcyoObd3p78GjXf9qjNBEhGhQUXPPccJhqqQhfmMF0
         Jwn9N0TciYjAkDCYLaUcqZBplJ2qImSZw/AAzASnYHSf0/J6PgO83rWzKlK6YsRP+w6t
         cpXI0KrJ9WGHHSDfelz0EEaQ27mPxsBBE7T/HDHHwiUrBN1QacUTEBrH8YbGEmYJCREw
         C12qyBEEbRl6jPth9ZX2gFrxRXqgSonPBxkFsfaI9fbQx4ePhtX6GjTqQpayA9JC7uP/
         g2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EsGNcxhUNDjpw3jd2PBLWZrFBrLemsllXRQ5T8XmNN4=;
        b=Y2zH6qxABh7TpTtLUGo6m5GQYqAya/bHD0cfVg28SUH8PBF6UrdF+ev+vCozklBGqL
         B5HOhGoDBHJeeXiFGzwOQ6T6ttJh67Wc3qtkMQ0leldbiWwlA58P5ll8lEKyGaO8PZVX
         ZlMoxXwcK6FYy+9Yn9E4Cvze2bO2OzRiqf8Pdz7io+pBDHo6awhgR0XeMQQKI4lT4Pe1
         xh22YSeM8Bi8PTp72AZIxIqUGt5Dr+dFnHUJ4nGVJgH7ciPZ9Ad4eHClh9bPG8tREybD
         yG0eBrHcF94W7vsu06jTEHwKDo6+ZAX4fYcbrPokbnfn5xsgdB7p4TpAcx5RHl8MruZG
         scMQ==
X-Gm-Message-State: AOAM532q7wklFmoPm56Trvfpl2g02EjfA+OUebqOoP13Ax7HMUNs4UHd
        tHOTvJso6Ie73uG56mOrmqY=
X-Google-Smtp-Source: ABdhPJyNFO+4UoyqeKBQQXE1MSOxEiWK5bPw/Goz3ersRXBweXP/wHIYqtXpsjs8PILbS4QZhtbBxw==
X-Received: by 2002:aca:4f57:: with SMTP id d84mr16412279oib.71.1626661235474;
        Sun, 18 Jul 2021 19:20:35 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id k67sm3601668oia.8.2021.07.18.19.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:20:35 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 05/15] net: marvell: prestera: refactor
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <df6e4013-31e4-39f6-3c40-52a897b3b723@gmail.com>
Date:   Sun, 18 Jul 2021 19:20:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> In preparation of adding more code to the NETDEV_PRECHANGEUPPER handler,
> move the existing sanity checks into a dedicated function.
> 
> Cc: Vadym Kochan <vkochan@marvell.com>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
