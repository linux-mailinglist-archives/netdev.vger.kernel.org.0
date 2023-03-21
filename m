Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF006C2D16
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCUIzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCUIyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:54:47 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECE336462;
        Tue, 21 Mar 2023 01:53:42 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id m20-20020a9d6094000000b0069caf591747so8131808otj.2;
        Tue, 21 Mar 2023 01:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679388692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6g8ZCOL0qBfroGI6HKL/AHMClePzWoKtlB2eOg/vjPU=;
        b=SK3ZTDtVa1I2xB60js5elRDZCZErqnbS9tkXiU4atY22XLjFVkPDCiaIQ4qS9fb/SE
         mtq355JcyNHSq9VAyCvUA8x/vwJBMMqdh6P6UGNR2+UyGaXMX9NtYI5H/NJjuWz8R1c7
         +SB1lYKyPAmZCUkcz7lb9XOLn2YJPdDkGfN3eLjUWxGK3qnPn/Ppnl/qI22fNkbx3fDM
         BYazCH/4xNL2JS/KqHdjSbkxHCZNrTOLtVU4sGeZ7c8xZLgVwoe5/2g24Yb9K6xXoqmB
         Kw++jUsEX/Ew8sUbwIB6zNxdT7+XujkqtKye8dmKASmW4vuLJfnmXj4eU6qOlSf++eUq
         O6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6g8ZCOL0qBfroGI6HKL/AHMClePzWoKtlB2eOg/vjPU=;
        b=eZNgh7qVPHBm/zqemAJrC9FbQNC73T/xJpas4PJJUMuqXWCYWMrGjBpmhPsTLNn4Ms
         73DHt5z0ZCrrwEJyb298tQ2mZmt2ofW+1SgrVjMaN7MWViClF2kNY821MVzYVd88goic
         Ss6XA8Jf2sIpAZrojVGCRC+4iTspsXscIztQywyoKeaW02uWt4oFa/huiWdkZxmuheBs
         VtK9EJlNajgKn8wv8/8IeCaUFmaUpfEkTA0LIPu1JFoQn3YJgra+qJttxPWHT/x6Wx0r
         lymNoA9+jQAigwA+8UC+e08gyCPVRBHOuyp/GuHUlR+sN4UMBpCd4lj47dY5HAD7gNm8
         Trsg==
X-Gm-Message-State: AO0yUKU6Nb8lqtHrF+S49qrr0RshBw37nwqMZQZb6H4qEGlN+KTtPtVw
        0HC2AL/BWNDB+iHH16cBKnicmpGtL7SarW5Brc4=
X-Google-Smtp-Source: AK7set/RyVoEm6XZHT+AY5WK5cUy/4W39dJmufwy7VTHqkL30rYPhO5GpZX0GnBy2VFri+fYxEHvdokgkTWbioUoKmY=
X-Received: by 2002:a9d:6510:0:b0:699:7883:940d with SMTP id
 i16-20020a9d6510000000b006997883940dmr543887otl.7.1679388692321; Tue, 21 Mar
 2023 01:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230210114957.2667963-1-danishanwar@ti.com>
In-Reply-To: <20230210114957.2667963-1-danishanwar@ti.com>
From:   Christian Gmeiner <christian.gmeiner@gmail.com>
Date:   Tue, 21 Mar 2023 09:51:21 +0100
Message-ID: <CAH9NwWdiWtGsbyQRWCPros7iuSZTm_9fzJFPtuyiMoDg3TubuA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Introduce ICSSG based ethernet Driver
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Am Fr., 10. Feb. 2023 um 13:02 Uhr schrieb MD Danish Anwar <danishanwar@ti.com>:
>
> The Programmable Real-time Unit and Industrial Communication Subsystem
> Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
> SoCs. This subsystem is provided for the use cases like the implementation
> of custom peripheral interfaces, offloading of tasks from the other
> processor cores of the SoC, etc.
>
> The subsystem includes many accelerators for data processing like
> multiplier and multiplier-accumulator. It also has peripherals like
> UART, MII/RGMII, MDIO, etc. Every ICSSG core includes two 32-bit
> load/store RISC CPU cores called PRUs.
>
> The above features allow it to be used for implementing custom firmware
> based peripherals like ethernet.
>
> This series adds the YAML documentation and the driver with basic EMAC
> support for TI AM654 Silicon Rev 2 SoC with the PRU_ICSSG Sub-system.
> running dual-EMAC firmware.
> This currently supports basic EMAC with 1Gbps and 100Mbps link. 10M and
> half-duplex modes are not yet supported because they require the support
> of an IEP, which will be added later.
> Advanced features like switch-dev and timestamping will be added later.

What are TI plans to support TI AM642 Silicon Rev 2?

-- 
greets
--
Christian Gmeiner, MSc

https://christian-gmeiner.info/privacypolicy
