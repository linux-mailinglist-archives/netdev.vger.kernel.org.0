Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830055BD2AA
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiISQzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiISQzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:55:51 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418D2D1D8;
        Mon, 19 Sep 2022 09:55:50 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id c11so21017102qtw.8;
        Mon, 19 Sep 2022 09:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=UVyCxnM3jouCtbTxksKnwKfx6jIA8fImXA8wdF0fVL0=;
        b=QDZgT6XN6rOWQkN7IZ5RY4Ripnx3s0GDn/pUMhseq+MIGYChDdRRYx4/gJgoPHu9vr
         Dg+VW5GrqneFi1uBst61KeF2b7YY/mLzRg2bB23vSarEujBIvFTWTldXrvVc3zo98ODr
         0w+a6bxNeWNnQaZiPwbnfG01gJrQbG4rvB/al5midGsfkMYXnbOuWCSE8Js4PiPuxsA1
         cr4vVyr7j+uKMBYOV2nAv3UKWGE8Ff+tqQO2Zl4aErLi0EtSpPSM5ipuwksyPP12aIhu
         6SqDWL4L2vrKZj7sJHHXo90NcqUfVRFyKPEeIoAJg+OtCjZ27lL9F2COkbduc+BLbIcZ
         QxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=UVyCxnM3jouCtbTxksKnwKfx6jIA8fImXA8wdF0fVL0=;
        b=DO7j6Z4wYx78cVthWcVzUmFCNBx7E2bLfSX+pYk9BmtoNj4e0O3FzYXKnmDxVq8rB4
         dXhcvn8NqdrQV1JRif2UB+UCNzYTptu04n/97j1N3Qn87xKfNfcHvTmw/iXjmxOUcmj1
         YK+gna7EKi//BJNT8sRpjytIvGLAXnI62UUIqZHEhKWf//Bsv7lCGHwRiGalb37FWIyw
         FDAd45JI9gSSsytD7qYlwCRpassYRFBsYIomjh4yL5vby97Xou6U0/cGSejgTaRd2/w9
         r1E0M624u4lS7UHrkmI3K9Jy5Z3QURTvVbkws0Kv4ANJRM9HhU7xzWH/S95xdyTryAd7
         hetQ==
X-Gm-Message-State: ACrzQf0LXkd2Ez2NA5yiSA4JvVeUrFI/FAY/lUB6/1DmGVFT43jDR1/P
        yK8TJPi+xbXQattI9JE6lys=
X-Google-Smtp-Source: AMsMyM5eyr41/y2SfPWzHrgp6POt+G+Sly9EEwSGZfA1s4x7mJAB2WAQrqniy3avaqfdyK60Pf9CKw==
X-Received: by 2002:a05:622a:44:b0:35b:ae69:3a66 with SMTP id y4-20020a05622a004400b0035bae693a66mr15443292qtw.217.1663606549090;
        Mon, 19 Sep 2022 09:55:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d1-20020a05620a240100b006cf14cc6740sm2507363qkn.70.2022.09.19.09.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 09:55:48 -0700 (PDT)
Message-ID: <c7275f8b-6f24-4acf-5899-affd0eddb34d@gmail.com>
Date:   Mon, 19 Sep 2022 09:55:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: ravb: Fix PHY state warning splat during system
 resume
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <8ec796f47620980fdd0403e21bd8b7200b4fa1d4.1663598796.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 07:48, Geert Uytterhoeven wrote:
> Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state"), a warning splat is printed during system
> resume with Wake-on-LAN disabled:
> 
>          WARNING: CPU: 0 PID: 1197 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xc8
> 
> As the Renesas Ethernet AVB driver already calls phy_{stop,start}() in
> its suspend/resume callbacks, it is sufficient to just mark the MAC
> responsible for managing the power state of the PHY.
> 
> Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
