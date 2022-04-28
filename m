Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288C8513ED9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiD1XK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiD1XK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:10:56 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DA6852E9
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:07:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l7so12383194ejn.2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Pa2BHqlt1GUIzmEhYv5YpJrz85AJ/RChiLAhZ2w7Wrs=;
        b=PhPEAqoovBpv8gkBxoauL+Ff3vJ6XfGFJ1cnu/svp2cQKNKBDP9ASqoypRk2kXiGEf
         wb53VjoyWDlC8A6Xoz4MT+A6LWPAPeodGMUSyXRJQqevs8taEy4+aBasT6pVSJXOnTo9
         pLgWf3jwx7tkQGmW179ayqU4Zb6t8ZiXDsRJWFKnbIbe2gxPtE3LCiJ11QvsBGuxBodV
         LBBYyMmxvIx7eJsB3m+4HIuwqRiMzbZqg/7D4sAITH+6Cl6Nx5GiHeXa+tJfq8pQwuyW
         Tniu5E4HHB94gI4O8XZuV5OlnF2oyNx2CrnvEloP9GBHYLXP9r/o5/n90jGEdyPTsstf
         HhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pa2BHqlt1GUIzmEhYv5YpJrz85AJ/RChiLAhZ2w7Wrs=;
        b=ikpMJENJh9njKeQejsFaBXaB8pB4M5rVA3sIJIfa6CiCUZPjgRnirjSTHHvBXFAUX3
         S7jjOngYN7dAUf7YkYeqlNtFHeiUCvoQnNZZsQVHooMmNpbpO8egIoMhpcOuEunMo6cN
         ARBna9GQ3z1ffbdxKx/vlPMZvE+srLFfZFIBwr96j4ywO8DOIdPGmpL61SHqBoG7A7vl
         qYX7kvEW9TP2wLXu40FVoLVOXCY18PRz7Gc7bG4qx7QB6SDkDv9Kt6sXL6QDrK2MuI+c
         dnaN+85/cAZszirJ1BhMk2d+vae3V4EMtu8aSM6RQcZC0dvLCTYDRDr7IIWE09S8UVoL
         SMag==
X-Gm-Message-State: AOAM533DjrW8rPPKpLOdmrM16HE0GetESL8iNklehP6U86LwYXIB5V9z
        N6t1y0WRucZ4L28fMa/GNfg=
X-Google-Smtp-Source: ABdhPJzPKEukZO0ltIzZ8ZHsqc3YS7Af/uk8XplgwgXO7glFCBXcL0R4w74HkVav1ah1c2W1Ul4Rjw==
X-Received: by 2002:a17:906:3104:b0:6ce:6b85:ecc9 with SMTP id 4-20020a170906310400b006ce6b85ecc9mr32912884ejx.339.1651187258365;
        Thu, 28 Apr 2022 16:07:38 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id l23-20020aa7c3d7000000b0042617ba6396sm2210704edr.32.2022.04.28.16.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 16:07:37 -0700 (PDT)
Message-ID: <84d36568-266a-15e9-1597-790a18389b51@gmail.com>
Date:   Fri, 29 Apr 2022 01:07:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: mdio: Fix ENOMEM return value in BCM6368 mux bus
 controller
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, noltari@gmail.com
References: <20220428211931.8130-1-dossche.niels@gmail.com>
 <YmsbipglEOK/ODW7@lunn.ch>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <YmsbipglEOK/ODW7@lunn.ch>
Content-Type: text/plain; charset=UTF-8
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

On 29/04/2022 00:56, Andrew Lunn wrote:
> On Thu, Apr 28, 2022 at 11:19:32PM +0200, Niels Dossche wrote:
>> Error values inside the probe function must be < 0. The ENOMEM return
>> value has the wrong sign: it is positive instead of negative.
>> Add a minus sign.
>>
>> Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
>> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Niels
> 
> If you find any more issues like this in the network stack and its
> drivers, please take a read of
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

Hi Andrew

Thanks for the review.
My apologies, I will make sure to correctly tag the tree in the subject in the future.

Kind regards
Niels

> 
>     Andrew
