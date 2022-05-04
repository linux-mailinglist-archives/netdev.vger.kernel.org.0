Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0D51AEBE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377890AbiEDUOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377885AbiEDUOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:14:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD331E3E1;
        Wed,  4 May 2022 13:10:46 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i19so4954775eja.11;
        Wed, 04 May 2022 13:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/PlwbvOtURwtl9z/lk8xpVSo2Q5w/YGzOE4YN1J2kZw=;
        b=KgmbzCLs8y06h9+7Diio3uxLZi2ruqKCcqBU5JKpScTPDo7PV/TCeYtBlJD3o+Eqjw
         Gh0jCyRqX+uowcyu/q48o6XY2tXqycLa5R3ncp6JsdYCMqNsFrxSRnVMGpJJdfhYqGOT
         b2LDymj5Nv3zfOHbtboKlbdKeuEzGoaWmLun+oU/AiaRL0v8veWEHAz18r3T9mwldMeR
         /CA7z+zeExfWgvrFlSllEYvxhs6I1/Iv+BxNk5TEoMdul68CxkBIiMFHNPMMZ66GBuTC
         pXWs6iE0/0kxQKPluldzbCoXkWkOouUFU+of+NoO5I2TQK+mKnh7Vmx/DZWOxGaAS202
         UsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/PlwbvOtURwtl9z/lk8xpVSo2Q5w/YGzOE4YN1J2kZw=;
        b=d9gHP1R7bHIjDxMrbod4GVEVy5K4pkXxAX+1i9t6YLobbcBzEzC80nnOsIIOe3MuTx
         9xWTfQH3OHkrLlfPs0mC6fEU6thajKuK4XS6H4yIgcfYc4VUJQbdYesws1hbNDIiCM22
         FLpJW6hmQlbmga/CDVxNqiVPrVegg2HwN77p/xDH6J/1qBkVyr8Rr2c5BHGMrkj/CRH7
         hx+BRjCGpAdK8dDfJZ4GdpTZrcILaYd34+Aj+bok6U6d55gVOBFI02x8LSAngeG4HhIU
         cHQKouFEdRDIIGSRgMmpCFxLfXHAwEUGOSj2A2lqvIf3JROlE21GZzVADwxuM7zZCW6L
         eyaw==
X-Gm-Message-State: AOAM530K6F8dfTJo1lNtcqmzrHg5mdmuZYu551OZLXNxqouXkuUgkA94
        dZhGoxRz5qjtk6YOpDl90CM=
X-Google-Smtp-Source: ABdhPJyZxvoLx0bo84CS4KTszwuKwy2m4Uhsmq9PaI6fKWYgF/dlBRuUDRK7fDE7NNlCW4toDJb18A==
X-Received: by 2002:a17:907:8a0b:b0:6f4:4899:db98 with SMTP id sc11-20020a1709078a0b00b006f44899db98mr15861058ejc.622.1651695044556;
        Wed, 04 May 2022 13:10:44 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b006f3ef214e6csm6057632ejy.210.2022.05.04.13.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:10:43 -0700 (PDT)
Date:   Wed, 4 May 2022 23:10:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [Patch net-next v13 08/13] net: dsa: microchip: add support for
 MTU configuration and fast_age
Message-ID: <20220504201042.7fvqzc5my4qkzrng@skbuf>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
 <20220504151755.11737-9-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504151755.11737-9-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:47:50PM +0530, Arun Ramadoss wrote:
> This patch add the support for port_max_mtu, port_change_mtu and
> port_fast_age dsa functionality.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
