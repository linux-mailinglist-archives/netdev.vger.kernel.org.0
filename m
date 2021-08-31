Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9D23FCED9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhHaU4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 16:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241334AbhHaU4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 16:56:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36942C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 13:55:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id c6so422543pjv.1
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 13:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WKe98VVmCy9oaHnU75p0Z6C6SZAVPAKr0OsFvr7IPMI=;
        b=LAaTebQpJT3ENH+LGiYZsU6h4KNAvsDcKoTQOqHVchtS6mOY8C4wuNBiZCZvB7aYRF
         lMtv9Ca/IMSAw55pLH/oSUmtvLiqrwU/lfg4vGHigXFa1q3LzsraGATJboVUtktb5zyV
         ZWzJdxpIUzvYMXbqUMXg1WkwyEJyzzOK5V3y4Xi7xoQm0r6BXqqXDAcj9CEVFHZSDQSn
         fUF/Bk+Rmf0pGTBSiJBdofBnnUOmrhtq3ezSpKutqKOzDrPRUhLiamsYIxzKGulI8O+z
         KP6eyncngpnpfADEpYJ6LJczxiztyeqPw6dhmgdC6+BdlVT/qx0QXHESQ/NyKQdJEnD+
         Rs+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WKe98VVmCy9oaHnU75p0Z6C6SZAVPAKr0OsFvr7IPMI=;
        b=bKw2HWM7VjDviHgI9DAfde1mapPLvdC48Xv9qnVlOsDqD+TJqDHXO6JViSliyLc5z3
         D8dHaT0K2ybDCHxu43OcORlR0wB00hEvde7fKcO4KJoUyLLkD6OE95Z+MFTWmYdZtJAB
         /fJyAHSPdyi5JkkRLzfXEK6NUjMedRS97Gkdkx07CLjyrjEuZanAdy5UmX1nxrHjTDBX
         as/rDctmT6/Xb4zpt4A7PnCYrCrgz0dOb0W7bDdVeuv2XKTA9tJkkTa0pUqaPeHUluX5
         1D5LLrObCZwUOb9rER6G5AU0sKFSWx7Fkegle4kn+omyFJ6a632peHh0c8ehVKBJZw3A
         thyQ==
X-Gm-Message-State: AOAM531BX0J2q2mxW7siyI8PXG9YciRDkOB6RzET7qDh+8c68HKbY8WG
        /ekzx5tSIc6nBCc2hQBhEIOqOIEGchw=
X-Google-Smtp-Source: ABdhPJylK98AMJhk0J8PVTRvmUq9MYgen4KpOKjB9BR7EIlkTCwSyqn8htQQAb5b7ruBqJCQ6dWxww==
X-Received: by 2002:a17:90a:9289:: with SMTP id n9mr7410976pjo.27.1630443309629;
        Tue, 31 Aug 2021 13:55:09 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x26sm18324242pfm.77.2021.08.31.13.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 13:55:08 -0700 (PDT)
Message-ID: <2d04bd22-3d04-e75c-71ff-f1b67339b22e@gmail.com>
Date:   Tue, 31 Aug 2021 13:55:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net v2] net: dsa: tag_rtl4_a: Fix egress tags
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210831185050.435767-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210831185050.435767-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/2021 11:50 AM, Linus Walleij wrote:
> I noticed that only port 0 worked on the RTL8366RB since we
> started to use custom tags.
> 
> It turns out that the format of egress custom tags is actually
> different from ingress custom tags. While the lower bits just
> contain the port number in ingress tags, egress tags need to
> indicate destination port by setting the bit for the
> corresponding port.
> 
> It was working on port 0 because port 0 added 0x00 as port
> number in the lower bits, and if you do this the packet appears
> at all ports, including the intended port. Ooops.
> 
> Fix this and all ports work again. Use the define for shifting
> the "type A" into place while we're at it.
> 
> Tested on the D-Link DIR-685 by sending traffic to each of
> the ports in turn. It works.
> 
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
