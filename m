Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32BF648B85
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLJAFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLJAFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:05:18 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5971B747DC
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:05:18 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id x28so4915799qtv.13
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O3WGFJluYBsmSMJmjtXHpyJNTv/czbRLqRSXWFBOWmc=;
        b=U5Xnnm6eB87cNSDme17a/CX2HpKEMq7a7kQkTNJ1pgsJpZbBEWukkSTFXonBYopxt7
         p5wLrWOIhXBDC6bGBqXKFomprPTZYFX3gifO/cw6GiEHM5DLoti5juENiCjLKuWqouk0
         nkrqEYymg2m4uw49Ob/r115Tw9TuZ+qA3nSEWeR6FHFk0F6PwJZQSK4AuYM3Ja8IhuF0
         m/2DO6nlcgHXq45iGUAmvC41GXJtu3mEuh1FmJ9RQPzi+pjBXsey6Ex3E/AciuMQ6pUG
         +TUybfIu6YSX6ZEkumfYf9eIDqtBskJ3RUn3Te1x15rXPd4szLZOTlrBXQI6DJUF5oax
         m0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3WGFJluYBsmSMJmjtXHpyJNTv/czbRLqRSXWFBOWmc=;
        b=j5T7fvGPQHorcbPge8jGO1Nb3wleYuAGt/yZTgv9lRVRVxVJOhZ16OdS08Lr/aj2o9
         ZrBUTpgwOInV3c9wz0wYJEVl5tpNaCvBaIYv4Ssy6WeU9IBmavlkSPzRQrwgYxesSkaX
         umlgbOkhc3/2GlvEfLVWZKWTgIx/RIgWLIl/MKQ0Wa3H4SqTihujrk8gLzZtT9ZYlJEZ
         jDYiSlZOtVdy5crpR9E4GnC/5DpTJPf9FvRojeq0KNOh25GMGN4WZ2dsSM0ra/EZmFCP
         XxWRq3fl916AZR2URNpuHVHWUBIdWKd739zhpsy0Ekuqv8Dfo/uAPIMsabk5Oo52QV0n
         iBuA==
X-Gm-Message-State: ANoB5pla63fpPRvvQhaQoRKjHVhap2C8e0yFtooe2tnQ6vCF2l4MT2Fg
        dyl3qaZ40UfzXE9kGEHFzzM=
X-Google-Smtp-Source: AA0mqf4shkBLdtY9oTIiM4b2Cgy+l9g1hGTXEjxZVkedWkN4UGJuTTnLMrJGtG2dgqrMRO7p7obTmA==
X-Received: by 2002:a05:622a:4a0d:b0:3a5:3230:5e6f with SMTP id fv13-20020a05622a4a0d00b003a532305e6fmr10881430qtb.8.1670630717368;
        Fri, 09 Dec 2022 16:05:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y8-20020a05620a25c800b006fa8299b4d5sm915941qko.100.2022.12.09.16.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:05:16 -0800 (PST)
Message-ID: <09d11094-9f26-e1cb-9a00-dfd1dafa2fa9@gmail.com>
Date:   Fri, 9 Dec 2022 16:05:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net-next 1/4] net: dsa: mv88e6xxx: remove ATU age out
 violation print
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209172817.371434-2-vladimir.oltean@nxp.com>
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

On 12/9/22 09:28, Vladimir Oltean wrote:
> Currently, the MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT bit (interrupt on
> age out) is not enabled by the driver, and as a result, the print for
> age out violations is dead code.
> 
> Remove it until there is some way for this to be triggered.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

