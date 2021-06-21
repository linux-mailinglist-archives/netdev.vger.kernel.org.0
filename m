Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD94E3AF7F3
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhFUVti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbhFUVt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 17:49:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45603C061574;
        Mon, 21 Jun 2021 14:47:12 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y21so3447311plb.4;
        Mon, 21 Jun 2021 14:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UjNYybjriSaiaPFdhHa4SDxjkkYU7938Mu34wZbwP54=;
        b=VbIMdRAjGVcJXQux/m1jlNbeupCJziTFLwgyJI16HnqejqxNMX7Qm+RkmN1A6IDj7F
         d8EGuFBrAL0pOIc+kjJkZzK/WP0qEXAuFssyi8JLaUl4BAw4rVAzBV/EBO1IWtxlARxD
         utbzrg2qfIvJ5xViWev+SggBLS1bj700yamCI7OQ+qnfaZOv4/paR4E9uQK8cpsNYGjg
         OSOdNFZj07hs3aPbaoTWMvrcVtLwIW1DPzdKAgnmHRrxsk62Xlm7USZjYOu15s3nqKZP
         yhSr90ihFmGamU+gNXNpJk7wlz0Qh5wj4honOyDZY3D6H1Fbq09dbRADtaQSXeGys4Sm
         0S3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjNYybjriSaiaPFdhHa4SDxjkkYU7938Mu34wZbwP54=;
        b=Tb6LWoWyR6NdBXIEkXMB7FY7SPJPt0oITLcOF04RLVcVP0iDe1+UA+IY54IC2cDVlR
         l9fckLQddwdXBGePUreeCxXgMrnaJljNhOA9TX4NQkHKcddv11c/JU8g9WeL9JhbvuHQ
         38e00wQeHxQysZO1m+3NeznVIVGeEJWJU1Qeb/ZgJvH1eRK3lfNJPDpHnEes94t33rdY
         X0U5RZh6Bj2rrewixWklsE2tA/beof6IGmWmuYTLD/IoFWXh+KdkEOurzwIrqnRBxLcu
         ipdrgnd+vAgaq/6YHlmq+dDpmaTfhdleBCbTWFBJN2n2Yj5Bzljel9RhQ1qeee7mb/df
         X6KA==
X-Gm-Message-State: AOAM533FwqRa+8RPdDlaWBIa55qluzJgJt3F0wMzbLYhyLSiQqYtm4XV
        rrdp+T72To5k4y829bWuwgo=
X-Google-Smtp-Source: ABdhPJzt6vw3hevQmRaCEgHZbbis3Hnqcn//YXBeuM34oZeIvBr3lOtzbDSgHl+wR3Uxx0ed9skjwQ==
X-Received: by 2002:a17:90a:7641:: with SMTP id s1mr293233pjl.185.1624312031758;
        Mon, 21 Jun 2021 14:47:11 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q27sm6841710pfg.63.2021.06.21.14.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 14:47:11 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jian-Hong Pan <jhp@endlessos.org>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org
References: <20210621103310.186334-1-jhp@endlessos.org>
 <YNCPcmEPuwdwoLto@lunn.ch> <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
 <CALeDE9MjRLjTQ1R2nw_rnXsCXKHLMx8XqvG881xgqKz2aJRGfA@mail.gmail.com>
 <9c0ae9ad-0162-42d9-c4f8-f98f6333b45a@i2se.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <745e7a21-d189-39d7-504a-bdae58cfb8ad@gmail.com>
Date:   Mon, 21 Jun 2021 14:47:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9c0ae9ad-0162-42d9-c4f8-f98f6333b45a@i2se.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 1:15 PM, Stefan Wahren wrote:
> Am 21.06.21 um 18:56 schrieb Peter Robinson:
>> On Mon, Jun 21, 2021 at 5:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>> On 6/21/21 6:09 AM, Andrew Lunn wrote:
>>>> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
>>>>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
>>>>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
>>>>> PHY.
>>>>>
>>>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>>>>> ...
>>>>> could not attach to PHY
>>>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>>>>> uart-pl011 fe201000.serial: no DMA platform data
>>>>> libphy: bcmgenet MII bus: probed
>>>>> ...
>>>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>>>>
>>>>> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
>>>>> a while between each time for mdio-bcm-unimac module's loading and
>>>>> probing.
>>>> Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
>>>> driver again later, by which time, the MDIO bus driver should of
>>>> probed.
>>> This is unlikely to work because GENET register the mdio-bcm-unimac
>>> platform device so we will likely run into a chicken and egg problem,
>>> though surprisingly I have not seen this on STB platforms where GENET is
>>> used, I will try building everything as a module like you do. Can you
>>> see if the following helps:
>> For reference we have mdio_bcm_unimac/genet both built as modules in
>> Fedora and I've not seen this issue reported using vanilla upstream
>> kernels if that's a useful reference point.
> 
> I was also unable to reproduce this issue, but it seems to be a known
> issue [1], [2].
> 
> Jian-Hong opened an issue in my Github repo [3], but before the issue
> was narrowed down, he decided to send this workaround.

The comment about changing the phy-mode property is not quite making
sense to me, except if that means that in one case the Broadcom PHY
driver is used and in the other case the Generic PHY driver is used.

What is not clear to me from the debugging that has been done so far is
whether the mdio-bcm-unimac MDIO controller was not loaded at the time
of_phy_connect() was trying to identify the PHY device.
--
Florian
