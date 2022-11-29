Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8F63B86F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiK2DCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiK2DCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:02:11 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEEF4840B;
        Mon, 28 Nov 2022 19:02:09 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d3so7124509plr.10;
        Mon, 28 Nov 2022 19:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5y8VxsuoWAT41bJFc9/f/BWVt8VNU1c8IIUnBvWCjgQ=;
        b=ZfvrMdm2xPI+uCfX9B5/HEd600OW2M6oJz+63pZ1+M5ZntCI7YMBqPjyxD42x3JWWU
         uyZFkzyp3GezwMCmAh7WMl33UgOe0lhNLRT5KP2XU+uS5xf/TpyNfaMAPTbLXEFYqAwF
         FyitgmPs0Z2+aqPUfcA4W2sQDSCBMmJz/7Gkw0vBM5mSa3gYJGSOchaGyvbdOQP1pRk1
         L50gvBBJGBNo8ES21hpkbbKJKdsjS6W6u1SeQkAwLybJsyz/0vG5L6Xaqm/ArDP2tFtf
         ssiK6GwnKPjGb1EaD5kH47SIvLOU9Zip0WZ6/jfqV0BU/kkJtGYIi2YtPHXlHVUf3i50
         TZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5y8VxsuoWAT41bJFc9/f/BWVt8VNU1c8IIUnBvWCjgQ=;
        b=iqOig+xXvHDyF8yx7POjoY47a5ybhT7dV0LBDJ2YJICXseKJ8mPfXDsE7Uvq/njrmy
         GRg1jFmBZQQiv7pvFciYHSn6cgmoEcPEhsezvPW4IjjlNhcbiNEanZ7a+HJ0Urvchcpn
         YyuUWJLq4S7FMynQVbvaKGl7HmDvj178UWSizeomzTh18vGrT7Rhp0RaoIJgWeF96PoU
         DVqKWsawTR8v4RSHo/r3dAZZC9VS9hu8KzZfFMh7dWjwGFqxR5PgXRbG/yfGgyqF6zAL
         hnaKij/FGRtSwa4zYecDp1UGAR1y154PF8Cil1RqZgGo2rKPD9djsRLZz8P/C0IYGoxu
         X/0g==
X-Gm-Message-State: ANoB5pnDl4Cpo+zod/NNOWVODODJVQX4lDtxG5rxkEl4fRDDsXbCRx7V
        F/9RjgFVMl4XZcvHy+yKaHE=
X-Google-Smtp-Source: AA0mqf616aZdkXjG5nv5h3UQpJ8i4Er4n8WcSN6VDdFnFCs9TyKFg+bM5k1fgFosMRbvgX67ysa6FQ==
X-Received: by 2002:a17:902:b416:b0:186:a22a:177e with SMTP id x22-20020a170902b41600b00186a22a177emr34597826plr.163.1669690928999;
        Mon, 28 Nov 2022 19:02:08 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:f1fc:63fc:c03e:8357? ([2600:8802:b00:4a48:f1fc:63fc:c03e:8357])
        by smtp.gmail.com with ESMTPSA id v6-20020a170902b7c600b00187197c4999sm9541176plz.167.2022.11.28.19.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 19:02:08 -0800 (PST)
Message-ID: <fb21391f-3395-730b-c858-7ec39e764d02@gmail.com>
Date:   Mon, 28 Nov 2022 19:02:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
 <e1c8ef9c-5dce-485e-e363-abba3c1178a9@gmail.com>
 <20221128190002.0cc0fc95@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221128190002.0cc0fc95@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 7:00 PM, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 13:05:09 -0800 Florian Fainelli wrote:
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks! Is this for next or for net?

I would play it safe and schedule it for net-next so we can be made 
aware of possible regressions, if any. Platforms affected like the one 
Xiaolei worked on would likely get this back ported into $vendor tree.
-- 
Florian
