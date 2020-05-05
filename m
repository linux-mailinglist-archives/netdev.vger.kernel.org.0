Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65B1C4CA0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEEDWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:21:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1CDC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:21:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d184so222874pfd.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i7qYpwp4+d5IKKn5sC/ZwqohQmlzrUM7gOOsS09Gab8=;
        b=QB/hYENOdgb6G9HmBorrzphpwjSusPtKF/z0I8ADsR6JSPe5I5KsaOXnR172rwHArY
         VnaBoLD/g4m8yAHpvnw7uCuJ7VbKW9STDnNljpeMBe9IHgZV0U6FEYq5ZBhsV46Eem9/
         tacaCrabmvOCVwTKuvbVF0Nw2rY8POJDWGU/2U6zAxHJlrQDAQvy2xKML4A8QOJ6AoC5
         rCQt5cD60O5GFVxttUFdn4+Hnm2+QWW0sFcZKb/TzMV3oaUyu39PWGITGcS11gqDDGF8
         PrlYRiIByql1ApjXstlJmbe9maZjSiW++j816IB/RPkiy6W32hX5ASSajwBzYQCeYBy2
         8dKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i7qYpwp4+d5IKKn5sC/ZwqohQmlzrUM7gOOsS09Gab8=;
        b=dyDD8kiE/3OfibQ9rzsEwf4bxSHZ33gfuFsagqkZ1afNFPC1BH1/t3vk737oLs/Nmd
         Z9fspweZu6YX6H9jA2X4ZL+vt1FjPZ8KRKrqgkthLafaLabUHsjldDM/guTks5TkqiND
         rK/SMx70dtmKuAbM73cTeSb7C0ebwzBajOmd7k/klEo6g52Z0Ek5CU7NTPdOq9Gl8I6b
         y2k9SWwFdWYCGkmezZGhdU7LnZCOGdyH7qjhbsupAIv0CGezIEwHMwXcpdg7TmeoSRyu
         89HzP6EGmkIVTh7JfsNU6QSnx2sUXFiTA1Q4ZSgTj3osJ5u0WVaaVxEnypBWPirMvTfW
         Yexw==
X-Gm-Message-State: AGi0PualOy6yRO9f8X/EqWWyxeOcmdIKUVYIhGKuqPAwiQxV1PpQ7EUO
        qtHIfh+6sgsdsgsMtJQrmFY=
X-Google-Smtp-Source: APiQypKfERFxncIbIsqbTe8d8mbtbYKGMnmhQnK6dfnSLIXyo8CLfvXiKBpHNhj8+9yIj7EbsoTPYA==
X-Received: by 2002:a63:ed08:: with SMTP id d8mr1237468pgi.309.1588648919178;
        Mon, 04 May 2020 20:21:59 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m14sm386645pgk.56.2020.05.04.20.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:21:58 -0700 (PDT)
Subject: Re: [PATCH net-next v2 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-7-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <39dff91c-a8c7-50e0-bbbc-959ef3112bf0@gmail.com>
Date:   Mon, 4 May 2020 20:21:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-7-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Provide infrastructure for PHY drivers to report the cable test
> results.  A netlink skb is associated to the phydev. Helpers will be
> added which can add results to this skb. Once the test has finished
> the results are sent to user space.
> 
> When netlink ethtool is not part of the kernel configuration stubs are
> provided. It is also impossible to trigger a cable test, so the error
> code returned by the alloc function is of no consequence.
> 
> v2:
> Include the status complete in the netlink notification message
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
