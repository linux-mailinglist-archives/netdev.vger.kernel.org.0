Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18E6515033
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378762AbiD2QHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357050AbiD2QHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:07:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE8C64706
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:04:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v10so6837481pgl.11
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OKp/8s58T5r52NG1ZPS4ShIunC5oTSkas0OwO/QV3QY=;
        b=gc0S5VaOWuMg+mQoMt8+ehSIm1pEI4SoVk0XfvG9tTC1fUfCnWKfbHVw90+BTTelvb
         /7Nze3iG6ymGm2DB+tTapFvt9kO+4WQQQuZjx6BXIoLbDmBx/CnMlOPFOcWUQ33LE7Cl
         F/wWiW0zkw/c/829vJEm8waqBaOSCCCjA87fvOmiEv5pLrFntft8+WDPp3aV3paC5NXu
         /8L/soY1e7Iiq+fq5kNjtNOOKGWNxU18rEjP+Z9EGP1NP8U+X18mG162RCuegWLvrBsq
         Z7MwfpYydY7Effvs7FllHZEE8ILVUolntESI4mS8zdH6eWNK7CkaSqpiyh6h+hQrOGPE
         soqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OKp/8s58T5r52NG1ZPS4ShIunC5oTSkas0OwO/QV3QY=;
        b=7EjoRFiaqejujnodZgD2v+4N3iRurzB0lb9pUXEse9ZUCfBVNyXLKRS/UySVmy7i1d
         DiWI6QBvYMKmp/Xcdqnjyhzm31E11tAiADv2CLqVtioA3N3GHztCzJvvE1PPsp5yMrog
         JNR1JeoTlRJkFOFyHU3lFb1kARxa46L2B4zColQYOnSrsbKZREQsgb8nxcd8nmG40X18
         E91zbf3DSWw5PABS3wHxoKFid4XBC+khyEWH8zsFdS2ULOZ1XTH4FMHDX7x6bMNQmMwW
         +OWgUDJD8o7JKBXQe0Oabh9iTiiDq0H2Wj+jwQ0ze6Unul/y5kMT/dJp9a1xto6yanNT
         e4Lw==
X-Gm-Message-State: AOAM533J3wtveFCF6cNNk2tCkino8gACJZ3xpfvRrs754skP6uoRT447
        gTLooAVqt1tkmEn5uTGLLGA=
X-Google-Smtp-Source: ABdhPJw0x3XYO+sE5K9i773DyVJdhyJs0KuCp1PvpZWSvsSOBQL3N+zQoXpn/uy72g0bsDNAK1P5Hg==
X-Received: by 2002:a63:81c6:0:b0:3ab:6167:74b5 with SMTP id t189-20020a6381c6000000b003ab616774b5mr50061pgd.527.1651248253261;
        Fri, 29 Apr 2022 09:04:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm8165063pjl.3.2022.04.29.09.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:04:12 -0700 (PDT)
Message-ID: <2174c895-ad78-76af-a19e-728cb3808516@gmail.com>
Date:   Fri, 29 Apr 2022 09:04:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: mdio: Fix ENOMEM return value in BCM6368 mux bus
 controller
Content-Language: en-US
To:     Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, noltari@gmail.com
References: <20220428211931.8130-1-dossche.niels@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220428211931.8130-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 14:19, Niels Dossche wrote:
> Error values inside the probe function must be < 0. The ENOMEM return
> value has the wrong sign: it is positive instead of negative.
> Add a minus sign.
> 
> Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
