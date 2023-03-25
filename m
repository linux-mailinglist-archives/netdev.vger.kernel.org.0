Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C76C8F7B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 17:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCYQes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 12:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCYQen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 12:34:43 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FB272B4;
        Sat, 25 Mar 2023 09:34:42 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id jl13so3662157qvb.10;
        Sat, 25 Mar 2023 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679762081;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJzR5HKC/AhvVM1iHc/1xcrdE7qDuWn0YWirlvIPn5c=;
        b=KCnTRcAoJJHfVhZScD5aYf/oWitG1Df7QBG/3Nuok2zWRltnNFRBxJTcdphMiugMct
         7SNIoBNNiXbDPBTiUhEkc3PVNM0Ndf4tRRdik4O9vf/0HoDqYwmpMs8fh0xT14zmDsoj
         j/S4bRejeW/6+7g1noOWaiVFxsOxQN8Q5NEtFbanEhAV0QIdLp8PNtu6gRwXZRNinajv
         S1RLsO9NaxMSUbcgEsJp6lekNajwcMMccsMaqUrPHzaZi7mxFIBeWG/v9nprGHTXUv5V
         uiC/wVc7ZCH8JLn6VENNwkvIa4lc5tSAzlRd6yl3/eQ/MpkX25BV9ImFutNF/7201mp7
         37xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679762081;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJzR5HKC/AhvVM1iHc/1xcrdE7qDuWn0YWirlvIPn5c=;
        b=ng5SoPrFosmSouMphU+fecpQav3bXAFrBpGe1U7hmI1sNHBktBqde44gRMve3Ug4o8
         Y5+4xhueMqUPek+T5fGL+sN+7qlBx8EOSyMH6GEs5H7wWwpmNwoejW3gfoqTlhkFke00
         +smrg7R0HwaYCe+diXrvxe5IUUsNjTR/mkwHYlwmbN85gcrJN4lYdUxluUswhAyyTWXY
         ODfJhYAXpX+btb9/dQkyv5hTUwDguZCCi0vZusfiep3WlH4gLouOJXkjxJNeqNHwnfSY
         URPS21vuE8JwEj999cAM/kddPfsvhnXU4rSbpdqoDq6Eq8MVyFyeXBXT8KoFh3CpJhAV
         RJ1w==
X-Gm-Message-State: AAQBX9fzC+ND+apjb2VTcJlrUZC0bXT6IznnJqXbfcZwSYrEUqzDPgO6
        GQ3wnq9QFOVK99IDDx8t8Aw=
X-Google-Smtp-Source: AKy350ZYMGYODreBpqRHnpo1P/J815UDqnc8684m4bOMwr+nlU1tuSCpslEKv6mPZRybEqcFKg0v0A==
X-Received: by 2002:a05:6214:2028:b0:5b1:9c9f:d4d6 with SMTP id 8-20020a056214202800b005b19c9fd4d6mr13244711qvf.37.1679762081411;
        Sat, 25 Mar 2023 09:34:41 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x16-20020ad440d0000000b005dd8b9345b2sm1575625qvp.74.2023.03.25.09.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Mar 2023 09:34:40 -0700 (PDT)
Message-ID: <7891b1df-8e73-1ae2-f726-804649bb1ef1@gmail.com>
Date:   Sat, 25 Mar 2023 09:34:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: dsa: b53: mmap: add phy ops
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323194841.1431878-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230323194841.1431878-1-noltari@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/2023 12:48 PM, Álvaro Fernández Rojas wrote:
> Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid accessing
> B53_PORT_MII_PAGE registers which hangs the device.
> This access should be done through the MDIO Mux bus controller.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
