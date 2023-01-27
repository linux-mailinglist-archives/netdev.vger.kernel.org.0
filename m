Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD5167EE5B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjA0Tj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjA0TjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:39:02 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A522BF06;
        Fri, 27 Jan 2023 11:38:11 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id q15so4998407qtn.0;
        Fri, 27 Jan 2023 11:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w1aEl95AJYjffXRdxsqmJWBXw55TlbGY6xDVHq3famI=;
        b=Ul2BzwmSPjznejO2ag3lQdUvwfAOcbW5G2w8KilBPxPif6AB1QoFBUhnHngQrQQgtS
         aRpF4VQ+QZnsBcNyBTCCX/gOihGMNAzourTg0ae3vuzCEtOFeVx00my5rp0x6STvQoRA
         2s8LPH4X/bFAYgduOnz6MBvODTvetCKDIVh3KQ8M0EVB70AmOBJh9hDBFvd3ILOv+E4L
         kMPBKUvyXL3TfKEG8o1HLs4mW+e5DwN98phaKzzG6QFVjc+2mRwbWOmswIf1COW7+mFF
         CothVt6ofu67NsR4KmRJBQaORcdbUKbEl5kw/J4ZrkIm8FKGOW9orTprHGRHc+zZI3xo
         XWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w1aEl95AJYjffXRdxsqmJWBXw55TlbGY6xDVHq3famI=;
        b=lVT2FYCvY2XK1DwoC5LgdcLUXGoySDOyNwNZHDcfxaaSvHS0RJFBiwOYkn+9rJLWwA
         MATOw68+FnGobdvkzJwT598bVtPy13ymm73sF86b0xsA4fpFoLzyXwKom+fjOZMIvCty
         COl/jVLwKTvVfbMClqKgC3oye58yvV2RJL0PL4obE4wXwuAeII3i+k8JYfy9qcjyY/Rn
         wHTe01g8AiWrXo/jUQFgH78aG0AcvawWHELfd3LS2g8jUBPCTByrwQbYCLRexcrGH9hn
         +K6x14pOy3tBymTt5TFWjhl7ElC4+5CLJ1ehUfo48wGj+uQnW59/fwGhXL99DV4ra6ZG
         MhLQ==
X-Gm-Message-State: AO0yUKVQU697NeJSa0D3jevSxlKqP+CfsUzqsmcXizWTS+qkLnVXSxzu
        ZevbWdRbgkz+wtKORqAdL9smdi04YQQKAg==
X-Google-Smtp-Source: AK7set9E4TD4QHRWMfOWVqB/822pNG/iU0dnoy2007Qoy+t4dqCrr7WizLhdpvEG+Amu+0WgvzfpQg==
X-Received: by 2002:ac8:5d94:0:b0:3b8:2dc2:9fad with SMTP id d20-20020ac85d94000000b003b82dc29fadmr2982170qtx.49.1674848278911;
        Fri, 27 Jan 2023 11:37:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l190-20020a3789c7000000b006cfc9846594sm3430274qkd.93.2023.01.27.11.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:37:58 -0800 (PST)
Message-ID: <c3974009-f585-0f51-e747-123392080a93@gmail.com>
Date:   Fri, 27 Jan 2023 11:37:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 01/13] net: mscc: ocelot: expose ocelot wm
 functions
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-2-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-2-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> Expose ocelot_wm functions so they can be shared with other drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
