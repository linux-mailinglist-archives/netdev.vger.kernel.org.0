Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A5418591
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 04:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhIZCWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 22:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhIZCWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 22:22:52 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E60AC061570;
        Sat, 25 Sep 2021 19:21:16 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 11so8899766qvd.11;
        Sat, 25 Sep 2021 19:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GIx+rSjxW/q6WpBhwC+tPZq1+myuly18nCZ9De5udkw=;
        b=VOVxynHNZM9TAKcgH7Kr1qWH7M/LZZzUAhyQwgkZUn5BhYAkqpXbREgMimJy345ouJ
         xvsIkI/CR+KRLvJN+nkjaT4xuXTb7lt6pQ3awRP3Dy/eR/i8w1DSVwQSaaxkD8NezEl5
         80Sk+go1id7FmEP7L0vzlN8Sk2aPEThV77Uvji/gINo8ra/pXw7BYgCB1nHJu6SxglPO
         QIRtalXAe/J9mX8KrwWizuczMN9zJRqXjtnmcL/FeL2eyvYgGhZoGL/7PEZRxKblavBT
         QRAaq5hW4V8g7kHxtSQS6X5F8FS18o4q1A5zkKheOpso3jiUZrsNf9euFcIggfdi4c8p
         WRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GIx+rSjxW/q6WpBhwC+tPZq1+myuly18nCZ9De5udkw=;
        b=y7ymFLJbixtgT8bDzGbweJNnRQ2IIN2rJ9aqQ0j9ZCdcygJxIw9kIPVg5M6Xps+svF
         L4FYs1+rmFNOWRgni8h0paIzgz4LgL1RSeqli0CMY8PASQ8EemopYO7bwa+aRsKrdBmx
         DpfCbdKODkIkvTVUFs9OAo8uUuArgQUotHq2rOu0ZASArXWgRuogpP5+eYh5rNn1Pily
         UWz30GXPz9z5VY+Zw+BM+wI3Ssk3ajknC6h0pizhvtnKXZ13oqhbEbdWxuqSQOWmckC6
         S0ZemIkwPCsAJFtaKF8qKZc5S0IpTvSVfq5H7miZV+U7rbZnkPLDCyurkQMgsOJWSA1U
         ie0Q==
X-Gm-Message-State: AOAM532mrqrLhLi4I+593R7ZPDtBvs+Z4rTXyt+f4dN6ziAv1yVnv2cW
        03M4wdkKUwz/f2IJiHdO09k=
X-Google-Smtp-Source: ABdhPJxE3HUPH44ibMZCt4AsnUMO2FTSWl3D0M1gK68DrjOEvF+0Bi4RxBMz9jj0vkMdIBeaUGmycA==
X-Received: by 2002:a05:6214:3ac:: with SMTP id m12mr17851616qvy.9.1632622875721;
        Sat, 25 Sep 2021 19:21:15 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e? ([2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e])
        by smtp.gmail.com with ESMTPSA id g19sm9315384qki.58.2021.09.25.19.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 19:21:15 -0700 (PDT)
Message-ID: <05f4baaf-24cc-da1a-a23d-7f033ba528f1@gmail.com>
Date:   Sat, 25 Sep 2021 19:21:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 1/2] net: bgmac-platform: handle mac-address deferral
Content-Language: en-US
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210925113628.1044111-1-mnhagan88@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210925113628.1044111-1-mnhagan88@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2021 4:36 AM, Matthew Hagan wrote:
> This patch is a replication of Christian Lamparter's "net: bgmac-bcma:
> handle deferred probe error due to mac-address" patch for the
> bgmac-platform driver [1].
> 
> As is the case with the bgmac-bcma driver, this change is to cover the
> scenario where the MAC address cannot yet be discovered due to reliance
> on an nvmem provider which is yet to be instantiated, resulting in a
> random address being assigned that has to be manually overridden.
> 
> [1] https://lore.kernel.org/netdev/20210919115725.29064-1-chunkeey@gmail.com
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
