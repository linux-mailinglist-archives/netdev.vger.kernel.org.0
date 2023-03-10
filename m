Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C466B384A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCJIOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCJIOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:14:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1218DABA0;
        Fri, 10 Mar 2023 00:14:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id da10so17234597edb.3;
        Fri, 10 Mar 2023 00:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678436058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HTrJQYUd7w6GLVy6Pd6YkyxSkzxKW9NUVtx6qQW7j7c=;
        b=WD6Gy/U6lBcO8zhRbaPvvQnZQc6NDyeETd4G7SR2OYqkTrHZs9fdrpkbjV3ymMJV4J
         R+PaOarBPpSgNlRMndtDmj/D+xvd7u4q2QUGzLdVOWqFJ0XcxgqoOT9d3nyEQPMm31r9
         ytwVGqMyJot3Ty0zEhdtjAw6lH1eNcaD7Hc+jJnqB0bzKYjGGe96C4Pg+nI9xJ4cUysw
         zlYdbEkPVvZtsVaRprYarm5BUwFiN6IdCQEJuhuVvBhlTfuX+n3OUhyL/hH4ed26HiVj
         2+p3Gzb8ZpCL0F9CggyRDcNEyD3jgy7znJiEnMDYBA1kp9QvLfrQXVPnwTEv9VavbQBs
         y0aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678436058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HTrJQYUd7w6GLVy6Pd6YkyxSkzxKW9NUVtx6qQW7j7c=;
        b=inJWkfTuYejF6UPSISy2iMbnCyHPk7gj111lAdBR4/BPlrknJVxRb4jLJhCoObQhzE
         LhGprh7BAw5DU0qJfuBlduqoLO/T3wveBVaGkF1GMJgthNYnj8gZk3dlK+F1gnZhWOa8
         WRHRCYunDNbVIxZ3sBMqiHDETZYIlcO6+sWBAtBgocegovKTrWBos9e13zyGE1WGMCag
         ezm14HnKWVPbZWu793OybTirwJKWefJ+lRYCuBw0NtRUO8tldwJiErt0UP+14UFQyHCg
         hduvuTCNl73rqzuzi56S+mlJmyK7cG2+HLuIjFmaVdOlN3YoiY9RrXU2XTzx8piG3zIJ
         fJtg==
X-Gm-Message-State: AO0yUKWbJDtMyz3zMQC3yYbiKCGp60yvDkYHhhUqPvjkhgfL/W5fjEwp
        7YUUZUHzEP09mt1APQRMFnM=
X-Google-Smtp-Source: AK7set/5swYgXTdVO5X7sJyrvGNo7ExkbBTQRI4vu4JDKeLjUjRVMays9X2uvBHlHLbS/h0IZEh4zQ==
X-Received: by 2002:a17:907:7f09:b0:8b1:7e21:f0e9 with SMTP id qf9-20020a1709077f0900b008b17e21f0e9mr30768797ejc.18.1678436058196;
        Fri, 10 Mar 2023 00:14:18 -0800 (PST)
Received: from tom-HP-ZBook-Fury-15-G7-Mobile-Workstation (net-188-217-49-172.cust.vodafonedsl.it. [188.217.49.172])
        by smtp.gmail.com with ESMTPSA id mh21-20020a170906eb9500b008f89953b761sm656639ejb.3.2023.03.10.00.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:14:17 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:14:15 +0100
From:   Tommaso Merciai <tomm.merciai@gmail.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/5] add dts for yt8521 and yt8531s, add
 driver for yt8531
Message-ID: <ZArm11JCCD5ymspR@tom-HP-ZBook-Fury-15-G7-Mobile-Workstation>
References: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Frank,

On Thu, Feb 02, 2023 at 11:00:32AM +0800, Frank Sae wrote:
>  Add dts for yt8521 and yt8531s, add driver for yt8531.
>  These patches have been verified on our AM335x platform (motherboard)
>  which has one integrated yt8521 and one RGMII interface.
>  It can connect to daughter boards like yt8531s or yt8531 board.

Thanks for this series.
I test on my jh7110-starfive-visionfive-2-v1.3b
Great job!

Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>

Regards,
Tommaso

> 
>  v5:
>  - change the compatible of yaml
>  - change the maintainers of yaml from "frank sae" to "Frank Sae"
> 
>  v4:
>  - change default tx delay from 150ps to 1950ps
>  - add compatible for yaml
> 
>  v3:
>  - change default rx delay from 1900ps to 1950ps
>  - moved ytphy_rgmii_clk_delay_config_with_lock from yt8521's patch to yt8531's patch
>  - removed unnecessary checks of phydev->attached_dev->dev_addr
> 
>  v2:
>  - split BIT macro as one patch
>  - split "dts for yt8521/yt8531s ... " patch as two patches
>  - use standard rx-internal-delay-ps and tx-internal-delay-ps, removed motorcomm,sds-tx-amplitude
>  - removed ytphy_parse_dt, ytphy_probe_helper and ytphy_config_init_helper
>  - not store dts arg to yt8521_priv 
> 
> Frank Sae (5):
>   dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
>   net: phy: Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet
>     phy
>   net: phy: Add dts support for Motorcomm yt8521 gigabit ethernet phy
>   net: phy: Add dts support for Motorcomm yt8531s gigabit ethernet phy
>   net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
> 
>  .../bindings/net/motorcomm,yt8xxx.yaml        | 117 ++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   1 +
>  drivers/net/phy/Kconfig                       |   2 +-
>  drivers/net/phy/motorcomm.c                   | 553 +++++++++++++++---
>  5 files changed, 597 insertions(+), 78 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> 
> -- 
> 2.34.1
> 
