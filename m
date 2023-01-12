Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFF66856B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbjALVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240622AbjALVbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:31:17 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCCF2718D;
        Thu, 12 Jan 2023 13:14:15 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id o63so20359512vsc.10;
        Thu, 12 Jan 2023 13:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9G8E/pbF0yCVEwppEfeZ3APRR94ekY7sl663Hc09EMo=;
        b=CLGQjrQB/cXT4ivLFkBZ2uFfRzV2B4EuZw/fwRZDs/OamGqTfErZRyoEF5zSftNssA
         aXo/J943u3z52xiiyn9ozbhsyoQruIu2fecHP/z+SDB5JICNMpxq0KcptZnYMIhrShBM
         YfC96q6zTGqcqq9hX2DPYulrMchhsuMtmAzxE/31s8E9O7Mmo6W9CLXhI76inUfSWyDe
         +cHCugoc13oZ7d5vWOFEfSgOP8LUmFvg/dNuqBbCgACKDXztYEDpxaveJOoNssA3MPUw
         vfhD6ahNx593rmXHQEFQIlfxRB/Tly17byXrAoAyTruXS4oWhtjl0KJfWf3LFxNyESR/
         QMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9G8E/pbF0yCVEwppEfeZ3APRR94ekY7sl663Hc09EMo=;
        b=lwjcP3LJom48fO1xI6g9ucOsFcUDiY7e9TDNmB0yMoqTXIQ0g/NFPD6Nw8EmKJ8UPR
         B0/amOG1IzkTrJgSAuaF+jdli4a+MdM8b8ms+TsNbig/hd9JHAFLHJRTYyuuZk9TtkOO
         NciDpX/2nKuWLD2eqO4TSWInuvXC9i3/YdICrVBFjN4LDudJyGdpPnaRvqquXN+iUuVn
         M9+YtW7VzVe7Nlu+FBh7apNLWvDTCZeHchaUTNhhoBuRC4x1TI5AYX74qRyM/+hVxGu5
         xnGeQaSQPMUd5yWmKzZBZRtDzvF7w7bX9HVyvss8xvTIBEYrEUnKYNiQkcNcy+FaP3j9
         zPtQ==
X-Gm-Message-State: AFqh2krS2JFMCgndhPoxuBH0FWuORdvREHS7W9bwnSiLHm3g3/qK7+Q0
        AM/cor2P+S94j2iXunX8WxA=
X-Google-Smtp-Source: AMrXdXvqOpDKUMfAeRKnyAEn0jSg0Xdln+Y3NUo/FVdyWNh9GqqApDbAMshix//ZhSV0K8IXOyErgA==
X-Received: by 2002:a05:6102:32d3:b0:3d1:657e:39ff with SMTP id o19-20020a05610232d300b003d1657e39ffmr335281vss.30.1673558054609;
        Thu, 12 Jan 2023 13:14:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u15-20020a37ab0f000000b006f9c2be0b4bsm11202593qke.135.2023.01.12.13.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 13:14:14 -0800 (PST)
Message-ID: <2fd5c783-94f1-1896-c6b9-431a754aec14@gmail.com>
Date:   Thu, 12 Jan 2023 13:13:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 03/10] net: mdio: mux-bcm-iproc: Separate C22 and
 C45 transactions
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Li Yang <leoyang.li@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>
References: <20230112-net-next-c45-seperation-part-2-v1-0-5eeaae931526@walle.cc>
 <20230112-net-next-c45-seperation-part-2-v1-3-5eeaae931526@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230112-net-next-c45-seperation-part-2-v1-3-5eeaae931526@walle.cc>
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

On 1/12/23 07:15, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The MDIO mux broadcom iproc can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new API calls.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> Apparently, in the c45 case, the reg value including the MII_ADDR_C45
> bit is written to the hardware. Looks weird, that a "random" software
> bit is written to a register. Florian is that correct? Also, with this
> patch this flag isn't set anymore.

We should be masking the MII_ADDR_C45 bit because the MDIO_ADDR_OFFSET 
only defines bits 0 through 20 as being read/write and bits above being 
read-only. In practice, this is probably not making any difference or harm.
-- 
Florian

