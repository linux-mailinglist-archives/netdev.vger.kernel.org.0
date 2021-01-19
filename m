Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD0D2FBD48
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391077AbhASROx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391042AbhASROr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 12:14:47 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50BCC061573;
        Tue, 19 Jan 2021 09:14:06 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n7so13362665pgg.2;
        Tue, 19 Jan 2021 09:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIi+68R0qSMBbGSJO7W8fkMua1ZXrc1HDXWlI1bhjx4=;
        b=Wgi/das/CWwwvez9LmHVsy2c+ShJMuicfh9WKzifYXc6ZO94t9ZT5Sy6j0hhsJiEUm
         1/7jYuEH9eYH8n90t4Ds6A8XtOC4ZPTE9W3p0YUhe4PzNWdY5sA8MFd5kV4OgQpgh8GI
         gi1xFXYsaP1dBZn82xWAMo2p1QqgsVh8tOg32dwnxOpaiOpBmU73zRULGkLOwgBVAWYH
         qt3QTArDN7neDJEoshj6sbwfe1KCM4WgfSQCN8i9LscAwqqE0E6Ej4Mjo7AVZJ+eylKz
         5m1hmH4119adfLeh/gZ5aqU+ZfpReHCBKl+gLBTHaE1zlvttz7f0ay3yu5QeCn0Z61no
         MXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIi+68R0qSMBbGSJO7W8fkMua1ZXrc1HDXWlI1bhjx4=;
        b=FL5MkJQ1NWhzxbtV2oLkdMH6yPKhvG5LVQn9Z3oC/qUfEEWdmzYPFGArpuiAIRfKkq
         Ih7pjDFNzw1X+hyQP4YFYcNKOTNIws+9Pznuv1p7If58O37Gzv3ljfYd4/OZOtXT8Kiy
         GA1LPtBmOdENletXF0YlMRb9wxqLj8zEVLvt0fO6xTIrqOCYSJuzsU8K3u6+T0v6Xjvd
         dSe+ruaeOhgCs+vhYlSBoOxJ+PjlufHuXY8dqivH1oGSJC3i0/vs0shwMjjivOWPMAt4
         Vizbu8sPZ/w6oA5RwvflR6jgyhDegx7nVWuxXlJiOStOS47/R9euW+mZsr1iQ3C75Yax
         Zk4A==
X-Gm-Message-State: AOAM530imMsr9XoMbaLffHdB2GmO4zDALXQU02FZ4I+cUZjuRiAJQFCB
        JKCwWl/DJTzM0kZxTozICz2po2rB+xE=
X-Google-Smtp-Source: ABdhPJy9vDcbdahg630YpK3RvD5hSKR7tkvlrck4HNE5YAyJpW1MlplLmsYMOcuhqpVCBtroX5UwjA==
X-Received: by 2002:a62:17d0:0:b029:19e:5cf9:a7f6 with SMTP id 199-20020a6217d00000b029019e5cf9a7f6mr5047983pfx.0.1611076446055;
        Tue, 19 Jan 2021 09:14:06 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm19458295pfg.107.2021.01.19.09.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 09:14:04 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: b53: fix an off by one in checking
 "vlan->vid"
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YAbxI97Dl/pmBy5V@mwanda>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <44c35bd8-b7c3-49be-3a67-e9b1c8a02617@gmail.com>
Date:   Tue, 19 Jan 2021 09:14:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAbxI97Dl/pmBy5V@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2021 6:48 AM, Dan Carpenter wrote:
> The > comparison should be >= to prevent accessing one element beyond
> the end of the dev->vlans[] array in the caller function, b53_vlan_add().
> The "dev->vlans" array is allocated in the b53_switch_init() function
> and it has "dev->num_vlans" elements.
> 
> Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
