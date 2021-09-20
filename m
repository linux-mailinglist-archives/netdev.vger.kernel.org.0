Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED604114E8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhITMxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbhITMxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:53:30 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32D5C061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 05:52:03 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id m3so65138909lfu.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 05:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=E904xOxlmrAlkCYm3uRuC+Psli2AnMQfVkiRa2z6Iqc=;
        b=Aa/4TC7evj/dtcowvH4DX4JJMaHz3nbiSSqJb+lj8vnMoUQ/AjX0Sgg5Hbl9qwaoJn
         JG+3kq5uq8gNv107vgc3bip6mFLRVpHgwNb/PfE4ip+963YILPFL1YRZcLhEkxY/CdlP
         RKtN9lgOjhOFPsu62Pa5m6ezNFnJ3j4blwALluotOIta71LrMh6laQyDvRoFx6R9evs2
         sLGw7LjWinnQMpVDjlgO1MV2eTa6QV4URHkNIwFzj+JZ6YxWBCs32yMqqWX5mL2jVcTU
         9gzswVYyOyOfS1aDhDd4wSwV2wJZQf3y5n75z/eSJ0csZ5llcipClll/Li4zBMHoKqPV
         oeag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=E904xOxlmrAlkCYm3uRuC+Psli2AnMQfVkiRa2z6Iqc=;
        b=5Z4f8mKv5zSCkKNuq2UfGtTsE4wVjAw8NjoRAgwVOpJYvxw9ltQkXofD2yEExI8vwF
         npo2jsF679bH4piOY1lJNxia4qaIf+tpeAb4vp7GF3PulweKgM5G2OTSEhFiMQGGInAc
         BuNB5dNydmJwfwFj/bPJ6oBUxwFN4VfMJXg/0A+ZKHHIYpsydVor5Q2oGpQhkl8O0blb
         2WzoIq27ifNXAidSUrsRC2YAJbcXYkL6RrhCrfZh4cHMsH26wFOWFkTtwo2rFS38jyzT
         EeZ+dWjCIBjteKEb1lkUCMKQr52P9NsxSwMStHXyJNjqQ9yRdIJx1SnLkxC7zN75VsOH
         54tg==
X-Gm-Message-State: AOAM531/N0BEekG9fCEcpuwLL22Ig4TSBznPAS0zdypVTpPwOg1I90zq
        VTN97BOkDKuW+OtgMj3b81g=
X-Google-Smtp-Source: ABdhPJzX6yz9d/cz1/qiLjw5TKmHockyirf2ttoiObC8FrnSIrvdLycY6/P53DGTPH6Az1wl7/fXMg==
X-Received: by 2002:a2e:b894:: with SMTP id r20mr22360848ljp.291.1632142322194;
        Mon, 20 Sep 2021 05:52:02 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id r3sm1268275lfc.169.2021.09.20.05.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 05:52:01 -0700 (PDT)
To:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Race between "Generic PHY" and "bcm53xx" drivers after -EPROBE_DEFER
Message-ID: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
Date:   Mon, 20 Sep 2021 14:52:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have problem using a switch b53 MDIO driver with an Ethernet bgmac
driver.

bgmac registers MDIO bus before registering Ethernet controller. That
results in kernel probing switch (available as MDIO device) early which
results in dsa_port_parse_of() returning -EPROBE_DEFER.

It's OK so far but then in goes like this:

[    1.306884] bus: 'bcma': driver_probe_device: matched device bcma0:5 with driver bgmac_bcma
[    1.315427] bus: 'bcma': really_probe: probing driver bgmac_bcma with device bcma0:5
[    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS)
[    1.329722] libphy: bcma_mdio mii bus: probed
[    1.334468] bus: 'mdio_bus': driver_probe_device: matched device bcma_mdio-0-0:1e with driver bcm53xx
[    1.343877] bus: 'mdio_bus': really_probe: probing driver bcm53xx with device bcma_mdio-0-0:1e
[    1.353174] bcm53xx bcma_mdio-0-0:1e: found switch: BCM53125, rev 4
[    1.359595] bcm53xx bcma_mdio-0-0:1e: failed to register switch: -517
[    1.366212] mdio_bus bcma_mdio-0-0:1e: Driver bcm53xx requests probe deferral
[    1.373499] mdio_bus bcma_mdio-0-0:1e: Added to deferred list
[    1.379362] bgmac_bcma bcma0:5: Support for Roboswitch not implemented
[    1.387067] bgmac_bcma bcma0:5: Timeout waiting for reg 0x1E0
[    1.393600] driver: 'Generic PHY': driver_bound: bound to device 'bcma_mdio-0-0:1e'
[    1.401390] Generic PHY bcma_mdio-0-0:1e: Removed from deferred list

I can't drop "Generic PHY" driver as it's required for non-CPU switch
ports. I just need kernel to prefer b53 MDIO driver over the "Generic
PHY" one.

Can someone help me fix that, please?

-- 
Rafał
