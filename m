Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56C8414DC4
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 18:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbhIVQLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 12:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhIVQLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 12:11:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D8AC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:09:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so3164121pgl.10
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bHh2Za28PeMojXn9oXDmm/zoC9aXU0QMePLCni8+liA=;
        b=OJ+kHp5b272SSZyubU8owtHZUyKEsuaGOnjQzoUpuhRoKpcQa8zGjmM4LJgvIP+rFf
         8weln69+ZL+SeQb/jzbk5AJINwMl5iB3l8MBlwU9UxFqol5gGjxqWLSb5uLd+zRYHRXX
         FV759a+34WEHoCf8Oz7mW/4tFC2s1uhCXfqfPSUm9q5YW8InU0nuIlJz3yCmJwPiaAPH
         BqrBrKMpdKC4SbtUI9h/Ct6tMLR/F5k9sN0lhg1ELXTcmTVonP0rXAubaBoGT3VC4hGX
         4PShuoKK4xncwM6Sa88bxsHZh3VHwGY0ZuA3FO03JDXD0FPp9unUGCAvcMF6dhl53cal
         AhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bHh2Za28PeMojXn9oXDmm/zoC9aXU0QMePLCni8+liA=;
        b=011Fbup4qZweNiOBGjuHo0qxkDowbSdp2UfomOPHxL0yjBBfgnuu5sYPTDUkyCvten
         KcKcwO05fdXuWwV41n076VtHj/Hnao6bLxymE1upTi+VzgjK5LVq4mNsBcGoiJ4PVasA
         Spw1yuX44KjxCVxa59QZ7Aa7kUjVQ2UPij0EBfkq+GDQUQNgKLEhaqyOQlEQ8hA1nDJ9
         EarHkrtiOKdWKM8nvf/jzJjYm3PM1+rq4/Zk8B/0iWTmtMYUWJ68E2FX7l4Y1CKmJReJ
         ynUKvPFhshYdAk1B4k/+DjjIx5AifSe3Aw9RZxoDhc0p3k1svecBQdnJnR2JfL4HTO6T
         dEQQ==
X-Gm-Message-State: AOAM532sTLEani+uGksYKv98HjuYjhz/a1Mfsr2Lw5aRUnVkxFiV3oAa
        TQRnafaXSVu8Ll5+ege6Rj0=
X-Google-Smtp-Source: ABdhPJwnpDl70iIP3r9ctxMiwwLhYyC3B6Fuj3Lj6og4KGGmI0Ifxmcunh/u+8oK+XTW7TtJNRgSdw==
X-Received: by 2002:aa7:83d0:0:b029:3c6:7261:ecb with SMTP id j16-20020aa783d00000b02903c672610ecbmr137945pfn.61.1632326977007;
        Wed, 22 Sep 2021 09:09:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12sm4155823pjr.2.2021.09.22.09.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:09:36 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: don't keep a persistent
 reference to the reset GPIO
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210922151029.2457157-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2b6795ec-fb42-9dba-4e3e-7b140341aa95@gmail.com>
Date:   Wed, 22 Sep 2021 09:09:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922151029.2457157-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 8:10 AM, Vladimir Oltean wrote:
> The driver only needs the reset GPIO for a very brief period, so instead
> of using devres and keeping the descriptor pointer inside priv, just use
> that descriptor inside the sja1105_hw_reset function and then let go of
> it.
> 
> Also use gpiod_get_optional while at it, and error out on real errors
> (bad flags etc).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
