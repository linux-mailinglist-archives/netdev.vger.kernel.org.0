Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9B76BC0D1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbjCOXYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjCOXYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:24:33 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897B3CA36;
        Wed, 15 Mar 2023 16:24:31 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id n2so56018qtp.0;
        Wed, 15 Mar 2023 16:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678922670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L+/XUg/IzalimXO/qn496/8CAVgsZbcEk4sHUDhLJEw=;
        b=JQfM9tEUYpiKlNt4eoxk39sxVPrldWly2scJs6iZcmGuWluZ3KNzqK6DcE2aKB/r8T
         wUuBZxZCNFwjXu9W9KBda1fkD8OqYF8TTGXsIl6WbTnr+sojsi+BfsgVprlpYR6OmA3u
         rr0/ay5JpNgxTGyLZncCWCGpJ1/oCF0OD3PczZivbLnm8Y12PtDxcPoVlOJ899/kBXPw
         yLaa5D0HL6CAaI47+rlIO/xAuyVAOXSCWAOz9ZQue2CbbaBwg678vJWUHdymWs9ywwrj
         kJREgR81ZkST9+clb4ihWriPfZoZ2aDlxXN/zwZCis9J3FVaAUBT021Sz5fvP/MmxRSO
         oLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678922670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+/XUg/IzalimXO/qn496/8CAVgsZbcEk4sHUDhLJEw=;
        b=VgeRbpfIiKGRfpzTXtoC/MnoMgTv8VO0QVRN8Uia6crGlSEFdAq59ogKzmDwtjkg2A
         l3RLKgrOJchHsZpPL2MmTQ/6H1AMslEGMP39SeruJuoSIOOGq4uZ73JljGxCOY7T9JOd
         +cdFcpVA3Yl9e4eYevBB7GWs4lwyV5W9T3AMnFbjV26ujJOXbPRAqqg8gOLqD3h2b5+j
         zFOavRnjBjEk7RIshXnUF7kuRWzcAxDe5MHyh1Soqj/dM6HMjI4TLD9bK9e5Lms2nHtY
         m0xue94QXFD8581/V3XuulpJH41rzsOYAUeafdoLE6+GWK/lB2iGrJ81MhlUzFuyLokV
         iShQ==
X-Gm-Message-State: AO0yUKXUfcLcJn5cZEI7UOh+CadG4XjT82kYILCVLWZWTOtr6a5w5cnz
        D+4ilDeH1UaydklmcD4rwjs=
X-Google-Smtp-Source: AK7set8739KdPX3AaAIpO3+R9MHd61PnmKgIblrEnn5huSW3lCeTfORP2mzTfbVR0bgF/YHA4cCEAA==
X-Received: by 2002:a05:622a:1348:b0:3bf:be20:544c with SMTP id w8-20020a05622a134800b003bfbe20544cmr3000547qtk.39.1678922670325;
        Wed, 15 Mar 2023 16:24:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c15-20020ac8660f000000b003b86b088755sm4673327qtp.15.2023.03.15.16.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:24:29 -0700 (PDT)
Message-ID: <e18a490e-02cd-ae2a-37ac-e6731e149aa3@gmail.com>
Date:   Wed, 15 Mar 2023 16:23:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net] net: dsa: microchip: fix RGMII delay configuration
 on KSZ8765/KSZ8794/KSZ8795
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org
References: <20230315231916.2998480-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315231916.2998480-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 16:19, Vladimir Oltean wrote:
> From: Marek Vasut <marex@denx.de>
> 
> The blamed commit has replaced a ksz_write8() call to address
> REG_PORT_5_CTRL_6 (0x56) with a ksz_set_xmii() -> ksz_pwrite8() call to
> regs[P_XMII_CTRL_1], which is also defined as 0x56 for ksz8795_regs[].
> 
> The trouble is that, when compared to ksz_write8(), ksz_pwrite8() also
> adjusts the register offset with the port base address. So in reality,
> ksz_pwrite8(offset=0x56) accesses register 0x56 + 0x50 = 0xa6, which in
> this switch appears to be unmapped, and the RGMII delay configuration on
> the CPU port does nothing.
> 
> So if the switch wasn't fine with the RGMII delay configuration done
> through pin strapping and relied on Linux to apply a different one in
> order to pass traffic, this is now broken.
> 
> Using the offset translation logic imposed by ksz_pwrite8(), the correct
> value for regs[P_XMII_CTRL_1] should have been 0x6 on ksz8795_regs[], in
> order to really end up accessing register 0x56.
> 
> Static code analysis shows that, despite there being multiple other
> accesses to regs[P_XMII_CTRL_1] in this driver, the only code path that
> is applicable to ksz8795_regs[] and ksz8_dev_ops is ksz_set_xmii().
> Therefore, the problem is isolated to RGMII delays.
> 
> In its current form, ksz8795_regs[] contains the same value for
> P_XMII_CTRL_0 and for P_XMII_CTRL_1, and this raises valid suspicions
> that writes made by the driver to regs[P_XMII_CTRL_0] might overwrite
> writes made to regs[P_XMII_CTRL_1] or vice versa.
> 
> Again, static analysis shows that the only accesses to P_XMII_CTRL_0
> from the driver are made from code paths which are not reachable with
> ksz8_dev_ops. So the accesses made by ksz_set_xmii() are safe for this
> switch family.
> 
> [ vladimiroltean: rewrote commit message ]
> 
> Fixes: c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii function")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

