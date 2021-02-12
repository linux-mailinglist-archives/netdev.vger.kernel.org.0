Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B9131A43E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhBLSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhBLSH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:07:58 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A5C061574;
        Fri, 12 Feb 2021 10:07:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m6so9044pfk.1;
        Fri, 12 Feb 2021 10:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jzL26zkMdAnOD2IACVtEn2EhF+H59r0z5RTwLn52Y3M=;
        b=GGYIq9OqvYpdw/0qjHnAVD0LJTXFfZcF0KciroJWpaauQnVLdTBpp/glr+Vy5rULBz
         9VQOkY+RSQu4SXh0pD54mneZPEI8+KptrYQxXK2wDgIv7dRYwDkvBbXidHT29ddo2i9u
         QMWmiWE3Clmpx/3DFGzuaaDPXA8xVqFM8kqIKuoDLbSdppwy39dQhLw6H33A/7tjNqRf
         0rrqJegRUUHMsrSQu0qKnuVbRY376nmZlbdGeyrM4WjUol11Z91O6oXU8BJKwaOIkEeT
         IhbGpgQV/Ev8g2EZ5l6XtPPUyZU1vOrrxCilIU3WEk6hoi9TFj5Gs0+sBMLGJyD7GuOM
         9pEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jzL26zkMdAnOD2IACVtEn2EhF+H59r0z5RTwLn52Y3M=;
        b=pyndGLkzRYUFjGWiYmcO1t/RthGX9uadM0M8VBYQue9aPDVGPoz3oFRA9j+8/ECG76
         nFiC2sd022yPVMdgwyYMJcUdwmhn3Fp7o0UvLWInNNJqZvdekew2z/cgG/Sc8b7Mc6Dk
         JK8rXtA4ErB4Z8osaCwk4/cGkAdtTmrlNmuA2oo4RjhSOj61kt6ZmmmNGulFApvOwQMz
         iesEkidxiROPr6JJtDKycaICqiwh2ghjnME+C6OB5Fe2nd6MYTvhPiYDeRfzzcaIOt80
         o0hTQuCT/4+KghiqUb7zQTlzI+RwSDQgccQNsChQsClE/qxw0MKN42ibdnaNyAUZSmk1
         Y8pw==
X-Gm-Message-State: AOAM532RJMPw2Eio/Ol0byTBHkd5SXMC6NWVFn9ITHNPJZv3zpieV8XN
        kjYv3nRzZn5A9Cx9uWeD46EuKv2tHT8=
X-Google-Smtp-Source: ABdhPJwEtkuYl4IEjrY3K94aY/JomFbslkQgXIBduPK1tbo89twwiU07e/yZ3gbwrmhbKdxwSu/FAw==
X-Received: by 2002:a63:4405:: with SMTP id r5mr4272320pga.168.1613153237967;
        Fri, 12 Feb 2021 10:07:17 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e21sm9422315pgv.74.2021.02.12.10.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:07:17 -0800 (PST)
Subject: Re: [PATCH v5 net-next 03/10] net: bridge: don't print in
 br_switchdev_set_port_flag
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
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6097810e-9b74-df81-ccc4-3a4b47b94b67@gmail.com>
Date:   Fri, 12 Feb 2021 10:07:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 7:15 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> For the netlink interface, propagate errors through extack rather than
> simply printing them to the console. For the sysfs interface, we still
> print to the console, but at least that's one layer higher than in
> switchdev, which also allows us to silently ignore the offloading of
> flags if that is ever needed in the future.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I suppose the slight "loss" of information on which port failed the
operation is okay since it was implied by either the path (sysfs) or the
bridge command.
-- 
Florian
