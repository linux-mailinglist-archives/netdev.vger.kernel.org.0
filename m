Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8223C6874
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 04:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhGMCXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 22:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhGMCXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 22:23:50 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2351AC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:00 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o8so858383plg.11
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 19:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VZLJ586W2PwJd2sivbAeLi0nlzQsGfkkjBmYbr9j5wA=;
        b=Q0dC9RzGsj902Tzs5OsHXueHNW2RKcNs1HQ6Il/WazTI2aiM2ms7l3cK01aB96VdWx
         9S2TFUFphF+bSA8temDFhBxnSYpTzgBF7UCTQkniXEW4SrMZUh9MO9yfDjtvGaa+7aCp
         pa4/rl7ZG3mdkVYhTiYMxRU37sSfOiIQQDMBBpcp881Oo3/9M8yk5bQxGj+/xoMp/V28
         u+4RzGx5ydEW5vjnbsmuR83bVbMr9SfgYYMtX3nSVU/jWOaOnLcApUsp9O6gbjOFsLkH
         zWt/1FBzDMAYnMyD7CToaD6JK42cpAAVeoxpcSoZ5gM2yj2bnHhAoac/ooY4XEn+Unky
         aIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZLJ586W2PwJd2sivbAeLi0nlzQsGfkkjBmYbr9j5wA=;
        b=PdTu2kBos0iFsqyFkVP4W0modQHnA8lVb0d9hhmZSaYpHTExCtEtvvjIEdsPcleKc5
         oEU/czRA3Mli4JEWgh4qjTMDX3GdhhsGlECMhDc3olvPkFaEtgc1cBsKrV4/DzrWwZF0
         VjqkaTMoKuTBEjg3bDI4VOU4wQFoWqF5Th9S6R3qMlUlGB8uMZ4viVyYOGMibwg/zdyl
         Y1Ti/XclHSJ81RvyGUQ9PhkIFb0pT2ddrajB6QIEECzZ0hRk5uZdKi+9y6Rzwh5eBv9C
         k6XQ34mFlPFJ4YcVXlgYy4uLoTUqkbpbEYFw4IjXKo9xoRIyVTJ/soBheBeklnNZL7gr
         e8VA==
X-Gm-Message-State: AOAM531eczp7LsKu9e6lfxDyj/q9PpghZaflodWnR+iF9Q3n9mZdaPY4
        UYTTZKcD6Xh8fLOvbraWkVY=
X-Google-Smtp-Source: ABdhPJyUgrqMFgqZNONlaVEwlZpKh/s3ChU9ACp+R/iFqYeMrs3IOD4hwEjq0vY+VuX7Q82UQMTHEg==
X-Received: by 2002:a17:902:7085:b029:114:eb3f:fe29 with SMTP id z5-20020a1709027085b0290114eb3ffe29mr1589101plk.40.1626142859666;
        Mon, 12 Jul 2021 19:20:59 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n33sm18812875pgm.55.2021.07.12.19.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:20:59 -0700 (PDT)
Subject: Re: [RFC PATCH v3 net-next 01/24] net: dpaa2-switch: use extack in
 dpaa2_switch_port_bridge_join
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
 <20210712152142.800651-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <48103d5c-9d2e-2cd8-727a-658b0bbab663@gmail.com>
Date:   Mon, 12 Jul 2021 19:20:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712152142.800651-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/2021 8:21 AM, Vladimir Oltean wrote:
> We need to propagate the extack argument for
> dpaa2_switch_port_bridge_join to use it in a future patch, and it looks
> like there is already an error message there which is currently printed
> to the console. Move it over netlink so it is properly transmitted to
> user space.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
