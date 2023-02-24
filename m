Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361736A2116
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBXSDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXSDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:03:30 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18991BADA;
        Fri, 24 Feb 2023 10:03:21 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id bh1so274439plb.11;
        Fri, 24 Feb 2023 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wvHk11qF0f603OOJoMN+JIoAZ/PNo0RzhOMf6kxGrNM=;
        b=oziF9nHK8NdokR6g36ypTOBz+wYE7vFr6JVV3oRd8QfFOKiKK5K94qXdKKc//7fJ9O
         zV4uWilqOMcCvN0JDVXNxRhFOTI4i68Q/QhdwkPVHfU1yVUsKv8laiJ+GCWzmbJxyFcQ
         RmF7TzMSl2+aychpbtNypydPNhBBc33uhQqpN+OtSTXWIgO4rwCiecbXiJg+hroj4Vyb
         20pL570/rYzgPlmqYVDH82Nm1VfltHDbDKdBXJQcHwUSknjZMFDJBpdUTTJqbcj0bwM+
         +mK36AgpeZL4zL8WK3kGd+GUSSV3OxCbblzLmgD9/cY/RhTcvj+q9EZU2YBoQ6pjBL1W
         8NXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wvHk11qF0f603OOJoMN+JIoAZ/PNo0RzhOMf6kxGrNM=;
        b=5bm9WFGYbUvg6yj6MylelZHhf5Hrll+MYMUG5qSzzsRnnQ75G6Lptw9JeFFwh25Tsz
         5NOSuCcoMDwp1/ls9eJEcW+VurHgMDQTDbHSA8ZcUwF1vX02+GesJ8g0kpi72T9VjsjR
         cpRSJslXVuyq8pmImxcP4lDkv6s2Cp0NS5R9HdJBJpKbz+JUyR+N8p5LlhH1jij9GFik
         IW/1z3pTCYv81T5/OYr2YANYQ6FQVlzTARKUL+P6mWHK2kzzyFmSkXc0MLA2NnNDSX+k
         4k8AyIjhr8yG16s9K8jbulxDsdIS6+5aIa/tkuwRDDIzcQd3/+kS8m7A0YuVJeGtcyr/
         +uvw==
X-Gm-Message-State: AO0yUKXQ7QghbogxtPnYGlOFoGh0kO0yZVKCWmPxRxWHUOcuVDJJam/Y
        11cDn9FTA4o4z6vcJs7vt+A=
X-Google-Smtp-Source: AK7set/3ugPTZmEm5s6yq1bmhLEbjqx8wxrI12IRqOft8T2nJAwB3c44xV0sHkdk4bhcsiqm+FpIAA==
X-Received: by 2002:a17:903:284:b0:19a:9797:1631 with SMTP id j4-20020a170903028400b0019a97971631mr16431427plr.3.1677261801308;
        Fri, 24 Feb 2023 10:03:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p1-20020a170902bd0100b00198b01b412csm9804499pls.303.2023.02.24.10.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 10:03:20 -0800 (PST)
Message-ID: <db158193-15f9-a2ae-7fda-8c04dfc979a7@gmail.com>
Date:   Fri, 24 Feb 2023 10:03:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC Vb] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20230224134851.18028-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230224134851.18028-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 05:48, Rafał Miłecki wrote:
> While bringing hardware up we should perform a full reset including the
> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
> specification says and what reference driver does.
> 
> This seems to be critical for the BCM5358. Without this hardware doesn't
> get initialized properly and doesn't seem to transmit or receive any
> packets.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> RFC: This is alternative solutionto the
> [PATCH RFC] bgmac: fix *initial* chip reset to support BCM5358
> https://lore.kernel.org/lkml/20230207225327.27534-1-zajec5@gmail.com/T/
> 
> Any comments on the prefered solution? Parameter vs. flag?

Seems to me that the flags have been used to express 
features/quirks/capabilities as much as what you are trying to do here, 
flag would be my preference. LGTM otherwise.
-- 
Florian

