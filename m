Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF673AF136
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhFURD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhFURDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:03:53 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A969AC014DB2;
        Mon, 21 Jun 2021 09:37:13 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q192so7512316pfc.7;
        Mon, 21 Jun 2021 09:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ksmjuf2lO5rsabImfxDbW9ZKprqaUCO6K3fPn8qsbjo=;
        b=NEpIpD/SR7y4Xw+5YiQ9kL44Cs+jBS40hwa7qLpO5ue23AxGwarIa0lkIz4hl2P30q
         STWOs1dqcOX5r3zVBcrIlSCu0+knzcd+DHE/JUY/RNhKwzA6F1ohhFMnECwuroXEqQIj
         GBbdDuf3h9THWm5iNtsy8Gk0FrBujFhpj2ZLuKHwbN1Odkx9HwQ9/kyOJQZxsruNHzYN
         PhYLyo/3k2yQk2Ry2Hk+bF2/OfgXZiwdqiJ+s7xgwhFV+CTYbTZr80g8P/76rHmqrGwK
         9tNViaZHm3f0RUpXGUnuf0rAgMMjJVIAqydVMGzYP4q47uK2nmDbyk8ccWj4/2JRyHue
         ZS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ksmjuf2lO5rsabImfxDbW9ZKprqaUCO6K3fPn8qsbjo=;
        b=CwoRJA7GvlFfG14bFfhhq4j/IftDP/3+BGGRjCvZqzmgw2/ES7VxqQngM8c8zKUMuD
         daMBhMR+pJ6d7M07KFV7Pu4upfsWKolHDw6asTxvfbl6cbeuNRw5iw+SKKM9NUbMzjQQ
         u7xIONk0wDg+Ps9Nh7tNjg1fqvpmme0ntjDdL/uE1OprcbPZVVlF8hJqILzpfbJz6V3G
         fejK9Y9nGx4f6JVwG4WmbzpjV6sI4WVLOkDD+elHWIuFXEySc42W5cHkvW0MNZlgxrn1
         uh5iNy9IZHYpB8FE8x3JDS6V0G1cz/q5NOWeRc0VOLvIgCWmivv6WNOwpdlPhi8MkYXf
         LiuA==
X-Gm-Message-State: AOAM531Qx9EJCIaV1wOQTvnYnqGKUszB8aOgQDdqTK9Nt8SeNyBoKhyr
        da4gYv6x7y8lus2nv562dc0=
X-Google-Smtp-Source: ABdhPJwJlyG94f9GMPHQTvmctX71O9QZfYH+KSYi8goDEm7rd0vHtOKCnueAR1t0flvym91kQzljnA==
X-Received: by 2002:a63:561d:: with SMTP id k29mr24674374pgb.335.1624293433208;
        Mon, 21 Jun 2021 09:37:13 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q4sm17733745pgg.0.2021.06.21.09.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:37:12 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Andrew Lunn <andrew@lunn.ch>, Jian-Hong Pan <jhp@endlessos.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org
References: <20210621103310.186334-1-jhp@endlessos.org>
 <YNCPcmEPuwdwoLto@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
Date:   Mon, 21 Jun 2021 09:37:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YNCPcmEPuwdwoLto@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 6:09 AM, Andrew Lunn wrote:
> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
>> PHY.
>>
>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>> ...
>> could not attach to PHY
>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>> uart-pl011 fe201000.serial: no DMA platform data
>> libphy: bcmgenet MII bus: probed
>> ...
>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>
>> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
>> a while between each time for mdio-bcm-unimac module's loading and
>> probing.
> 
> Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
> driver again later, by which time, the MDIO bus driver should of
> probed.

This is unlikely to work because GENET register the mdio-bcm-unimac
platform device so we will likely run into a chicken and egg problem,
though surprisingly I have not seen this on STB platforms where GENET is
used, I will try building everything as a module like you do. Can you
see if the following helps:

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c
b/drivers/net/mdio/mdio-bcm-unimac.c
index bfc9be23c973..d1844ef3724a 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -351,6 +351,7 @@ static struct platform_driver unimac_mdio_driver = {
                .pm = &unimac_mdio_pm_ops,
        },
        .probe  = unimac_mdio_probe,
+       .probe_type = PROBE_FORCE_SYNCHRONOUS,
        .remove = unimac_mdio_remove,
 };
 module_platform_driver(unimac_mdio_driver);
-- 
Florian
