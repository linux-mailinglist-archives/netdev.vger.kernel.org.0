Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866B83198AD
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBLDVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLDVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:21:18 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D14C061574;
        Thu, 11 Feb 2021 19:20:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so4393865plg.13;
        Thu, 11 Feb 2021 19:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KX9BczQ7HP081Zb6fQayQzqKfWFTa3oP2nKnpxD0UUU=;
        b=dobcntpA4hP7ES4I7J3tbO+Dq/F2O2WJKrVGbRVjnR+nJkpwvHXlG5hFMOfyDKoLj6
         bQ51oQqQRYgJW+y00/jFsqUqSc+dYvdqM2Al1jDQxxYhv7mxHDb/OOaHiVpie75VlH/j
         giYQvWVZx9vsnBCC0g8f96MRmsPPJ+X4JIUCxvbg0RkTR/7CGjsSdU4U4ChmzspeFt3t
         BbebdtgH31J6iTgcWIzke6pj4RT3+x57OPpJxCLi3NDZ3LEEHJ3m5YN7FFK8aull5xiW
         ugo241axW1+tn5MHnPbI4ti49BIoNxgCa9c36t3P0naug02hrgeyS0sKSWiav0rAYfTR
         qFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KX9BczQ7HP081Zb6fQayQzqKfWFTa3oP2nKnpxD0UUU=;
        b=YKKK2LbrjBiib+zlMN9o3B4bnaFFnkvaIqd0o9oCW4dwzzgEYDeEgaSDfK2z1gWxAh
         Iuk3LRlQxvWYrHOI3WpbwZIrVQCdlD63k/aeEFFTBI1kkhQbDGdQYW5qCyssAwWUIuZN
         CQsab+QFQnlXeif0NGxiFoWlYt7ZmU39CY7Ez5ghI3qGyC6JVYMkLsg7l7BRetkoTsiR
         Tvx2lfUdeP15wIAs399zv1Gd6LtuKWWz3MCDpaMK26Oo17GJ9/BLvYCz0yvXIEG4Hcx5
         CQlm+xsWR0Fa1ZNRF9kWbNVi53Ccg0VcwTlM64azXQnLvVjflhTRQHfCs+b1CTbcrYEN
         KLVA==
X-Gm-Message-State: AOAM532g4icqnEIzWHsoFbHUK+2XZup/yDBSXOUZ1s5l02fxW92UxPxH
        aupyJcKCKLGg4n0e54Ezvzajk+Bb5xY=
X-Google-Smtp-Source: ABdhPJzNneNORHrgdUQm8rKm5aRrrnkJf1b/jkUvfdeWboyI7AvVfit3Z4uc9I9P3zJ8TNUQY+bymQ==
X-Received: by 2002:a17:90a:da01:: with SMTP id e1mr910471pjv.22.1613100036860;
        Thu, 11 Feb 2021 19:20:36 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u20sm6701624pjy.36.2021.02.11.19.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 19:20:36 -0800 (PST)
Subject: Re: [PATCH v4 net-next 1/9] net: switchdev: propagate extack to port
 attributes
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210212010531.2722925-1-olteanv@gmail.com>
 <20210212010531.2722925-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c559a6fc-b436-fc6f-7226-76490033d94c@gmail.com>
Date:   Thu, 11 Feb 2021 19:20:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212010531.2722925-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/2021 5:05 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a struct switchdev_attr is notified through switchdev, there is no
> way to report informational messages, unlike for struct switchdev_obj.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
