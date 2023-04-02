Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA16D37EA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjDBMrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDBMrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:47:41 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4BAA24B
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:47:36 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id nc3so2163430qvb.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680439656; x=1683031656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+QRUcj+4+GZIe2O+QCNN/Dt+RxjFp/plKyJS/nrRaU=;
        b=W6o6Z6XLGGEAn/o4+j0bhr+rAeSVkZNyjEb3vBI4J9tCh/9xG0niM9zXX0wzgcjl9J
         +OfF3koHvT2Mg9YXJan41rWY1XIvzTdAT/iYMdJ+rce4pwoON/MWOoUFBPX4uzoiCgCL
         IbE/EHYRjf9t+//TqbP4XYP8nAyJFLGd/5utkIJSuRqSgPbB5d0GUbZoiBAikq9xypNM
         RtpuIqLA+BfUsacHpXvSbZWYgAG1kuED6FgGINpjmaNvPmob1jAMIoKUo+dGIC/NYgHr
         fsSoTXF11Ue8wmsvovlj2T6OUCn6IQ5GTVXrWlCJCwPJvTsUz1tPdJb7rhUr7hcLbDed
         yRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680439656; x=1683031656;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+QRUcj+4+GZIe2O+QCNN/Dt+RxjFp/plKyJS/nrRaU=;
        b=KyIQnCuoOZFKPdmKYaP6h018czJF0PzWA6Djh8ie0ZQhG3kZObHk4B9FSgstN0DwsP
         n8BuFBZuJyJExhz1Uu7LInsz/S7GokunX1MJb4XflH0oAObWISoZuZZNCxu7tx7n1VWw
         jrWy/fBILoGFmL2tKz+6ix1L65jPev9ksJE80+GSYcgbpflGqDTvB3El3OfCM5kN/o7w
         tYVnNfBPRomd97DbgfPWH1an9KRPdQgV15UhDBSS52waF2o9fSRI9hcDaGmWE8NfVc+c
         3iOJm70V5bW+9pKa89R/WD5Aexoap/Bbb3mhMvbVuOlASdyz5k+ecUP99BDn3Pg5sKAY
         sASQ==
X-Gm-Message-State: AAQBX9dndabTWRCkYgSg1YgbJXl5TOYkaTAfEuZ8piGjFz5bnyBT3XQV
        wvgSXLK0a5fY6rnEfS9J/vQ=
X-Google-Smtp-Source: AKy350bzRLKQQTjOl0xzJWp5aLdYjv1WmJaTsBNHyKlwnyJunhEbeZWDl2jCvqXXISFX4T5eUrwhdw==
X-Received: by 2002:a05:6214:400f:b0:5a2:f1e3:15d0 with SMTP id kd15-20020a056214400f00b005a2f1e315d0mr50427133qvb.3.1680439655774;
        Sun, 02 Apr 2023 05:47:35 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id jh14-20020a0562141fce00b005dd8b9345b6sm1928541qvb.78.2023.04.02.05.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:47:34 -0700 (PDT)
Message-ID: <8f6cbe87-4fc1-9eb2-4c0b-ab790c2c7297@gmail.com>
Date:   Sun, 2 Apr 2023 05:47:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 2/7] net: simplify handling of
 dsa_ndo_eth_ioctl() return code
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2023 5:37 AM, Vladimir Oltean wrote:
> In the expression "x == 0 || x != -95", the term "x == 0" does not
> change the expression's logical value, because 0 != -95, and so,
> if x is 0, the expression would still be true by virtue of the second
> term. If x is non-zero, the expression depends on the truth value of
> the second term anyway. As such, the first term is redundant and can
> be deleted.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
