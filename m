Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1608551508D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378956AbiD2QSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiD2QSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:18:40 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B2271A2F;
        Fri, 29 Apr 2022 09:15:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s137so6877236pgs.5;
        Fri, 29 Apr 2022 09:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9xL8PaHwz5MgDJNkVdahqqsBfcYoMA9CfapW0s4XE9Y=;
        b=c+05atKavyLYJhd7Pzw5YK0mfkFuAuGKs7STMnvIyS26HNYi7YjJqVABrnt+bpxjJf
         PrU5PZDExnbQhuOrHdt5vaF44pINrLVaLwP74d2gllexhDkC/vz20xjshlZS+6NZI1Bf
         cIyy8qn6iwLXxR+9rbvaW5hhjU8mQsFfnRtiCqEJXolsLQ1avrdRcri0PqKtS7kS9Y4V
         xIo/MhAzBzr5ubIpu2GUD67fVu+3CXuva61ReXcUrXcWP6MWS1JEnvzyCxFHf1IrzAcd
         BM56P2Ytj9IXmhx4v+ay5SkMVoUKsIh2/Ia/I83TcuGVQyftoro8PsaXn9p3mQrzEj22
         PUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9xL8PaHwz5MgDJNkVdahqqsBfcYoMA9CfapW0s4XE9Y=;
        b=6ixvZZpuwj0f02zWqJlE9xTtl1frCDcG8VWbpzBxDnaFVI3WmLy4x06d/XIisqKJQ3
         HFlVB8uEzXLjcJ/sCjCcQtTwlXTEcRIcHxqM5tRoao+RJcxwixrmcMY28UIuBeUQnm2n
         6veQf7+K8rpvsKLyRJ9hOzTusrjSVbqx6/DXrGSXxmPunekfBs8sFvIl8icbLxJa62ze
         PoOVny1rAuqH8aT5OkoUcrioUUNJSWoKAzm5ifXvdqDrXcDlOId+pYtgyXVhNRKkfG23
         9q+CMdoB4y4G1DbIFCUcqonS1MK/dR0pbHgjeviZlYf88dc2k5p7LBBrDTpg91ZCFq+4
         S0Pw==
X-Gm-Message-State: AOAM531RCj+ivL5s/AUl1j1f/Oq/xT0gi35weCXHKbm/NditqMJwpnnC
        m0FRxsHFR75I1ru4KSY83Mo=
X-Google-Smtp-Source: ABdhPJyAoccAw9mCetgaoEn0bft/uSGJLQZaFTX3g+Op6murSnULlf6/e3kLMrDqhxhbcOv7TZGrbA==
X-Received: by 2002:a05:6a02:114:b0:381:4931:1f96 with SMTP id bg20-20020a056a02011400b0038149311f96mr100830pgb.331.1651248920728;
        Fri, 29 Apr 2022 09:15:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c12-20020a65618c000000b003c14af5061asm6519783pgv.50.2022.04.29.09.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:15:20 -0700 (PDT)
Message-ID: <a0a5a288-36ef-8f8e-46d9-49e4df7d53e3@gmail.com>
Date:   Fri, 29 Apr 2022 09:15:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [net-next v2 01/12] net: dsa: add support for ethtool
 get_rmon_stats()
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220429143505.88208-1-clement.leger@bootlin.com>
 <20220429143505.88208-2-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220429143505.88208-2-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/22 07:34, Clément Léger wrote:
> Add support to allow dsa drivers to specify the .get_rmon_stats()
> operation.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
