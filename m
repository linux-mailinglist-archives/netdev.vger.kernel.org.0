Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0CA3AF14D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFURGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFURG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:06:28 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F8BC056FF0;
        Mon, 21 Jun 2021 09:47:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso363553pjb.4;
        Mon, 21 Jun 2021 09:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q/aogRoYjz7srJceTDB8IGm87OdNiaC0/Cp+w+FZ+AU=;
        b=K2dc2OxAAtya4JmAYFlXUW/rpEsxZiTgEi8k0tRpw8kGMPCKmwjpQMLGS4fRi+dA61
         UhrsEcxIRcb/wmBfshFTTBIgyYRmURsv3Bbxu5YeDdDZUjwYxZiJgwYTkFkvO2LroLd9
         vd/CTKdaWODnO0am60lHg0Zhle9QUwurKC1LN13Ch4THU8rQFiBgdxvAuYW1LYvD1KgP
         pd0DuWdtNBWktlGSJCf2PswBJDWiivL2hL40Fq28DcEDU6/6MvES+MeF8xR7pX7NgWv6
         PNjoVS3S37kZX0F+BOg2DqqEbRCl4ll09MHKO8Qa0sP0Zkajp6gn5+1h7uTJRjebWMUd
         OWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q/aogRoYjz7srJceTDB8IGm87OdNiaC0/Cp+w+FZ+AU=;
        b=EjCQuXfJhA9kizmGfBuhkrfUX6yrureAwwCqF3fUWfyj0OdMvGjAjRyqDSVTOJBY6l
         AejC+5vO/FPlnnWCnf6WJ88KinN4mUTB1arBhsuUxfLnikwMcLPKW4wcEOVdtcmh6iPs
         528SRjVZGwhlUxEd/sGNrp9B5pqUYwRQIirczBSdbqORuxXZoD/uhGRSrB9KfYbqvoyG
         tLDbLIyEGeCZX//eHSr0XDLy8RGYlnKAyGDQzLr4SyKvWiEPUcDWCtKeJtc6eblL/VMn
         FJkAD2GfDfZvcgxLKXeMFBIpLOZ8zjQ4HAKM7ypEVMoFAgLFcPGcIhRxl5p61/Wrjulb
         oLPg==
X-Gm-Message-State: AOAM530CCCOu5+F+a58J/IO8KPh+laZzdFvHF2rWkIMa8KaAsR5QrkB3
        X2Mtdj9s1OXdiLFQiZ96Xhc=
X-Google-Smtp-Source: ABdhPJwW2xXZmm67zRjl51Y1b3QXjFAf8DdQJLKD0r2BTqqZ9EZAmEQqS8bj87xyUaXXDZs67vWlxw==
X-Received: by 2002:a17:90b:1295:: with SMTP id fw21mr28246672pjb.147.1624294043503;
        Mon, 21 Jun 2021 09:47:23 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f12sm1739409pfc.100.2021.06.21.09.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 09:47:23 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jian-Hong Pan <jhp@endlessos.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org
References: <20210621103310.186334-1-jhp@endlessos.org>
 <YNCPcmEPuwdwoLto@lunn.ch> <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
Message-ID: <0f0b2647-ba50-a247-3b6e-aed1e1c77f67@gmail.com>
Date:   Mon, 21 Jun 2021 09:47:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <35f4baae-a6e1-c87d-279c-74f8c18bb5d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 9:37 AM, Florian Fainelli wrote:
> On 6/21/21 6:09 AM, Andrew Lunn wrote:
>> On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
>>> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
>>> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
>>> PHY.
>>>
>>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>>> ...
>>> could not attach to PHY
>>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>>> uart-pl011 fe201000.serial: no DMA platform data
>>> libphy: bcmgenet MII bus: probed
>>> ...
>>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>>
>>> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
>>> a while between each time for mdio-bcm-unimac module's loading and
>>> probing.
>>
>> Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
>> driver again later, by which time, the MDIO bus driver should of
>> probed.
> 
> This is unlikely to work because GENET register the mdio-bcm-unimac
> platform device so we will likely run into a chicken and egg problem,
> though surprisingly I have not seen this on STB platforms where GENET is
> used, I will try building everything as a module like you do. Can you
> see if the following helps:
> 
> diff --git a/drivers/net/mdio/mdio-bcm-unimac.c
> b/drivers/net/mdio/mdio-bcm-unimac.c
> index bfc9be23c973..d1844ef3724a 100644
> --- a/drivers/net/mdio/mdio-bcm-unimac.c
> +++ b/drivers/net/mdio/mdio-bcm-unimac.c
> @@ -351,6 +351,7 @@ static struct platform_driver unimac_mdio_driver = {
>                 .pm = &unimac_mdio_pm_ops,
>         },
>         .probe  = unimac_mdio_probe,
> +       .probe_type = PROBE_FORCE_SYNCHRONOUS,
>         .remove = unimac_mdio_remove,
>  };
>  module_platform_driver(unimac_mdio_driver);

This won't build try this instead:

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c
b/drivers/net/mdio/mdio-bcm-unimac.c
index bfc9be23c973..53fecb53cd65 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -349,6 +349,7 @@ static struct platform_driver unimac_mdio_driver = {
                .name = UNIMAC_MDIO_DRV_NAME,
                .of_match_table = unimac_mdio_ids,
                .pm = &unimac_mdio_pm_ops,
+               .probe_type = PROBE_FORCE_SYNCHRONOUS,
        },
        .probe  = unimac_mdio_probe,
        .remove = unimac_mdio_remove,
-- 
Florian
