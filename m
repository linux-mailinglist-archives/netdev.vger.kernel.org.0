Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A96D7CD9
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbjDEMnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbjDEMnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:43:01 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C3811A;
        Wed,  5 Apr 2023 05:43:00 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id cu4so26052689qvb.3;
        Wed, 05 Apr 2023 05:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680698579; x=1683290579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MTAFf4OGc3JS+3A1a6rqMFwtwcsbwdl9NJcd4nNwT+s=;
        b=M7Rcawu2mcuUHH+1YQYc0Qtrca+1bdFMX7VnNA+zmum1wzpEtjkRRW0HBzcsE/1NJ+
         CwY2X4dISP4ImlL4OwVfU5RNqKji+a+eP65Xww9FptlwQQS4H79GsT9p3nMqTGG9gImR
         1KMaFzGnB/mEXDgHKHfdRBZsx8zVUBresVaf24VlKvT51nQbJyWG55I/xWXKEfDWfLKC
         31eutXqXaYOGD9abGXVpqplMXNz5jm1FMUtXw6Hp+TUMl4ddqg7msjfr2xuyqLQagf7K
         IuJ7njMBRZC2RggxQPFUXE2X9UtevTvsKTNfPfq8gHhWADol4jDYmYCOZ6RV39VkLafg
         De5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680698579; x=1683290579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MTAFf4OGc3JS+3A1a6rqMFwtwcsbwdl9NJcd4nNwT+s=;
        b=gJFPGmHV0OkuJIFJ4P1VhDjuJFvKfoKseQhXS5U8u6OhtTXYmW+3GFBx6LosAfID7C
         1ukXZJ15tY2vS8/4F1rHZIJMyQfpi1eslbxTwE/iwUfvKNpDv37TVS5Wh+JUl1HT34Iu
         /3sZfYYFkQ219Esyk8ylf9UtVTKOISvP7ESuaInIOsi/WYnXypTGkWz04n0rjOk8PT/h
         JSO4jm8HT+h/PjDcDfNAIHHdjozAIKNUN0nUq/ckJ7pMMs4hFpvCVBZcBPVOVd4UKoXJ
         Bpx6jEz7D3AD0EGgBlCeGTGAu5pUuyi0fuzV5Tim0ghrvfvYTN8fRBPzOIxj2OPNtBOm
         Up0A==
X-Gm-Message-State: AAQBX9c6sdE2sK8bKh4M78xiKWb6SuZ+Gf8znO9PECXI6oRjKv44qOUv
        SRbsJDR+ZiF3w+LvwoH0S4A=
X-Google-Smtp-Source: AKy350b0BlbXUr9SfFNX2w2ky6/yZz/Q7/m4ca6EQjDQy3eBX2nJgNUvI1TvFwjjn1xi+voc9a6xXQ==
X-Received: by 2002:a05:6214:40c:b0:5e0:63ec:5d7b with SMTP id z12-20020a056214040c00b005e063ec5d7bmr10271651qvx.28.1680698579301;
        Wed, 05 Apr 2023 05:42:59 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j3-20020ad453a3000000b005dd8b9345edsm4145230qvv.133.2023.04.05.05.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:42:58 -0700 (PDT)
Message-ID: <03ed8642-e521-f079-05b8-de9ffa97237a@gmail.com>
Date:   Wed, 5 Apr 2023 05:42:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 00/12] Rework PHY reset handling
Content-Language: en-US
To:     Marco Felsch <m.felsch@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marco,

On 4/5/2023 2:26 AM, Marco Felsch wrote:
> The current phy reset handling is broken in a way that it needs
> pre-running firmware to setup the phy initially. Since the very first
> step is to readout the PHYID1/2 registers before doing anything else.
> 
> The whole dection logic will fall apart if the pre-running firmware
> don't setup the phy accordingly or the kernel boot resets GPIOs states
> or disables clocks. In such cases the PHYID1/2 read access will fail and
> so the whole detection will fail.

PHY reset is a bit too broad and should need some clarifications between:

- external reset to the PHY whereby a hardware pin on the PHY IC may be used

- internal reset to the PHY whereby we call into the PHY driver 
soft_reset function to have the PHY software reset itself

You are changing the way the former happens, not the latter, at least 
not changing the latter intentionally if at all.

This is important because your cover letter will be in the merge commit 
in the networking tree.

Will do a more thorough review on a patch by patch basis. Thanks.

> 
> I fixed this via this series, the fix will include a new kernel API
> called phy_device_atomic_register() which will do all necessary things
> and return a 'struct phy_device' on success. So setting up a phy and the
> phy state machine is more convenient.
> 
> I tested the series on a i.MX8MP-EVK and a custom board which have a
> TJA1102 dual-port ethernet phy. Other testers are welcome :)
> 
> Regards,
>    Marco
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
> Marco Felsch (12):
>        net: phy: refactor phy_device_create function
>        net: phy: refactor get_phy_device function
>        net: phy: add phy_device_set_miits helper
>        net: phy: unify get_phy_device and phy_device_create parameter list
>        net: phy: add phy_id_broken support
>        net: phy: add phy_device_atomic_register helper
>        net: mdio: make use of phy_device_atomic_register helper
>        net: phy: add possibility to specify mdio device parent
>        net: phy: nxp-tja11xx: make use of phy_device_atomic_register()
>        of: mdio: remove now unused of_mdiobus_phy_device_register()
>        net: mdiobus: remove now unused fwnode helpers
>        net: phy: add default gpio assert/deassert delay
> 
>   Documentation/firmware-guide/acpi/dsd/phy.rst     |   2 +-
>   MAINTAINERS                                       |   1 -
>   drivers/net/ethernet/adi/adin1110.c               |   6 +-
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c       |   8 +-
>   drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  11 +-
>   drivers/net/ethernet/socionext/netsec.c           |   7 +-
>   drivers/net/mdio/Kconfig                          |   7 -
>   drivers/net/mdio/Makefile                         |   1 -
>   drivers/net/mdio/acpi_mdio.c                      |  20 +-
>   drivers/net/mdio/fwnode_mdio.c                    | 183 ------------
>   drivers/net/mdio/mdio-xgene.c                     |   6 +-
>   drivers/net/mdio/of_mdio.c                        |  23 +-
>   drivers/net/phy/bcm-phy-ptp.c                     |   2 +-
>   drivers/net/phy/dp83640.c                         |   2 +-
>   drivers/net/phy/fixed_phy.c                       |   6 +-
>   drivers/net/phy/mdio_bus.c                        |   7 +-
>   drivers/net/phy/micrel.c                          |   2 +-
>   drivers/net/phy/mscc/mscc_ptp.c                   |   2 +-
>   drivers/net/phy/nxp-c45-tja11xx.c                 |   2 +-
>   drivers/net/phy/nxp-tja11xx.c                     |  47 ++-
>   drivers/net/phy/phy_device.c                      | 348 +++++++++++++++++++---
>   drivers/net/phy/sfp.c                             |   7 +-
>   include/linux/fwnode_mdio.h                       |  35 ---
>   include/linux/of_mdio.h                           |   8 -
>   include/linux/phy.h                               |  46 ++-
>   25 files changed, 442 insertions(+), 347 deletions(-)
> ---
> base-commit: 054fbf7ff8143d35ca7d3bb5414bb44ee1574194
> change-id: 20230405-net-next-topic-net-phy-reset-4f79ff7df4a0
> 
> Best regards,

-- 
Florian
