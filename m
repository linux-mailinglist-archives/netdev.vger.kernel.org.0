Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D703242359B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhJFBv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbhJFBvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 21:51:25 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9C7C061749;
        Tue,  5 Oct 2021 18:49:34 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id a14so906293qvb.6;
        Tue, 05 Oct 2021 18:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fQ9EdtlFbMNZW7d1JDqllRocmUr8d9EXw0BFRt75PyM=;
        b=YhK7kdZLB2I8Wwd1Ncg/Xzf4aw6BZaHUALeh1k88KWf5Cmfqj6seK5vylLGBSDNCcH
         8Y1PGkn96QZwBmy9Yy2ZQpcebOAeon8tCmzjmTNIfd9LdzG5uUkG9ZHv2D2Pd2KlEsI8
         QXNZQOhrDs8XU5igT5C457XtVrKc3v5bQJu74dE4kaQxzTehdoGIqKdduPHnCI6gJT2K
         oQNGGsHKPAuRymLV4h6G1d0uD96SjNG0I03RfOk0Pmc8JC5gydFJuxkRfMog0X9dWU4W
         2n77OKeZYRrxBN9DwEfCoE/3LqmkPLX/MIFy+ky9oL045tLAzfBNj0uz7OobisINoMEc
         64Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fQ9EdtlFbMNZW7d1JDqllRocmUr8d9EXw0BFRt75PyM=;
        b=teBfmuKGdDq80ZgEFTYe6B39wmK0OJtIpL5Vcmb1gsGLx0xxU68hBNeXTQEiPH0Wgi
         KM6LH80qm8ER+lEThRxhzUViB1LylBEEO1zGkio795+2gbltoqWDt8CBVq5l9Kwiw+7X
         Q8X9wqK3PZ0eL9suy36bjnksC0Rlv76BB2rN/Hu6QTOG1wLmUv2ekDibKAz58mV7L9lM
         LGdrcL/nYJr1fqrQwD6ZBfxLJDzdFNPTFQjaOoMhFIE7f9rk+JpUyvSX3djbZEmgkwVg
         iggCAUNrr/PQCpR75kb6bQZdXP/Srds7f8N4IfvTGx8gQSIgEX/7b7AElOrLVLM7IhLb
         CdCg==
X-Gm-Message-State: AOAM530Be4Xgtp1rJgT7cAp4mvAl9IW/3FfT0eNBreesWwFqLW+tazqq
        B6Vku4+kkZNwVEmw6PGvkMg=
X-Google-Smtp-Source: ABdhPJxSz+vGjWVs7Q7tpoB/E273JnFfn4pntKku9vllE08XJa7Xf6XbYPCVOfnOeuA6vQNH/5lIvA==
X-Received: by 2002:ad4:4252:: with SMTP id l18mr1966433qvq.60.1633484973438;
        Tue, 05 Oct 2021 18:49:33 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c86a:e663:3309:49d7? ([2600:1700:dfe0:49f0:c86a:e663:3309:49d7])
        by smtp.gmail.com with ESMTPSA id 188sm10420395qkm.21.2021.10.05.18.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 18:49:33 -0700 (PDT)
Message-ID: <213d4043-63fd-eb86-21b6-a86b223c719f@gmail.com>
Date:   Tue, 5 Oct 2021 18:49:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH V2 net-next 1/2] net: bgmac: improve handling PHY
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211002175812.14384-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211002175812.14384-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2021 10:58 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1. Use info from DT if available
> 
> It allows describing for example a fixed link. It's more accurate than
> just guessing there may be one (depending on a chipset).
> 
> 2. Verify PHY ID before trying to connect PHY
> 
> PHY addr 0x1e (30) is special in Broadcom routers and means a switch
> connected as MDIO devices instead of a real PHY. Don't try connecting to
> it.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
