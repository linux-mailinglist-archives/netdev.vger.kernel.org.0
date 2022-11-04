Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F074F619EC1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiKDRb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDRb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:31:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F458260D;
        Fri,  4 Nov 2022 10:31:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ud5so15121844ejc.4;
        Fri, 04 Nov 2022 10:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZ0izagsWsWpZ2eRmetpEcRkpCuUlicVMhHGefzebh0=;
        b=YbNyMXSka7FRytIouv7tfbb6N7z89pGJO4T/iUbSkft8jqa3wdJrTLk4YoUh3D9B+J
         G/9zF02FZOLSHJSHf0lYMSQ0b563hLY5yINDvyLUMfuRvmcePBACGAMG+jyWVTMp3U7H
         kJYvDuGhftrSTjQIvtMlbrhO1iLwFYVj5rR/4TwU6U5RgLc9BVLAVbW+WnERxREtQNja
         JoQx89avoufoRoA2dpNNgElcDetlvBTOnRKOM9gakzIURVJY4t5arp1j22WmIWfQfnxe
         /We67ju9yTUSUpDVuNKH9h6zHM8C7LtsNvGsl4F2I+U9P5HgbCwL1xTYBcaEXZnSztkY
         ixLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZ0izagsWsWpZ2eRmetpEcRkpCuUlicVMhHGefzebh0=;
        b=3yPhEicy9Sy78hERIJ0/qGYa3FKTQyEN27CrVjieNQ8g5T4FbIj0lvXNRWRRYghy9k
         RlmGtFE+n/YLDzlCx3cdMooGXom2ZmJbR4cMSxgvqJguPAUl+Rd7o4E4L5D7AurrYFl8
         2WFzeRljW4kAFwrOtiVL1PsqAs6hNyYLz9gLu1UFWW1ynK7aFezUibFoWqyzHCXqNct5
         sMaB1CTBlN2cij/XclRJ4nfY7FTsMkuZkfJ1B0g8McuprjJ92XPFXMyxONBN0CBf2Qmn
         4J0vJjAkEN7tScy1Z5ETmDE6ZhppRLlfcpsv9kXjJ1OW+6dsi0wbwkw0TpINaMSZoa4z
         Nqpg==
X-Gm-Message-State: ACrzQf2WlsQuB/JdSESivwtPZUffT31pPztJsPIlqXu1eZVzkt5RQoQe
        5nMkwYVQkcmw3wTphF6vqgo=
X-Google-Smtp-Source: AMsMyM4LiMQV9yN6h4mkyapS1m6VnkL8UnT/CgIhxokQePY8xhhIosglBIdpc9HcgPhCCxjNQITFtQ==
X-Received: by 2002:a17:906:5dcc:b0:78d:e76a:ef23 with SMTP id p12-20020a1709065dcc00b0078de76aef23mr34272171ejv.317.1667583083516;
        Fri, 04 Nov 2022 10:31:23 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id n28-20020a5099dc000000b004619f024864sm2221083edb.81.2022.11.04.10.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:31:23 -0700 (PDT)
Date:   Fri, 4 Nov 2022 19:31:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221104173120.ho6a624lqnzboz2g@skbuf>
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
 <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
 <20221104020326.4l63prl7vxgi3od7@skbuf>
 <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
 <20221104165230.oquh3dzisai2dt7e@skbuf>
 <61945062-4261-ba3d-0d39-8c1cc46ad33b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61945062-4261-ba3d-0d39-8c1cc46ad33b@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:13:34PM -0400, Krzysztof Kozlowski wrote:
> On 04/11/2022 12:52, Vladimir Oltean wrote:
> > Ok, then this patch is not correct either. The "nxp,sja1105*" devices
> > need to have only "spi-cpha", and the "nxp,sja1110*" devices need to
> > have only "spi-cpol".
> 
> Sure, I'll add allOf:if:then based on your input.

No, actually my input is that removing such core properties as spi-cpol/
spi-cpha from spi-peripheral-props.yaml challenges the whole purpose of
that schema fragment.

I can go back at it and complain all day that my peripheral doesn't need
spi-cs-high, spi-lsb-first, spi-rx-bus-width, spi-tx-bus-width,
stacked-memories, parallel-memories and what not. Or that the SJA1105
switch will never need the properties of nvidia,tegra210-quad-peripheral-props.yaml#,
because the former speaks SPI and the latter speaks QSPI (for flashes).
By this logic, eventually that schema will be reduced to nothing.

Yet I don't believe that including just the intersection of properties
that actually lead to functional hardware for all peripherals was the
*intention* of that schema. Just the properties which are semantically
valid, and cpol/cpha are absolutely semantically valid.
The justification that cpol/cpha are "not valid" for some peripherals
(or correctly said, those peripherals only work in mode 0) is very weak
to begin with, and restricting the SPI modes to only those that
physically work should IMO be the duty of the hardware schema and not
the common schema. The common schema just provides the type and
description, the hardware gives the valid ranges.
