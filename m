Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BA75BD2B0
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiISQ43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiISQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:56:19 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCF438441;
        Mon, 19 Sep 2022 09:56:14 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id u28so17967419qku.2;
        Mon, 19 Sep 2022 09:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=L3VLCiIuu2QtRF2usLH4Yr+4/9+bBwP+dMGRVINQnT0=;
        b=Ux/ooIZr2cPsebSbPjlA6qKVB5oGSdZwBlCWliA0jkuCngyxXifXwOoX5M04A+Qsdm
         wZkzJLHvJgmMS/RxAufnxWcuAroZC5MJ9S0Vu1WfI/P2E3n+6JbjJ8C8RP6xShexFHEc
         ISP1BEIu6cute/tm6D+f+puJateqsIh0Wvmuh8tBisz66J04OlNEplkML+bKFdfvLuly
         TZTcHIygOI+mMOE19Xb4wT9F6iESui1spXhlw6y3cJ3J4gv3CTtT1cNaQm04nu41tZtg
         0WoXs6Lynd4KN6hflzgPKmdkcsPA/AQRQnWToMa+FOixc5luM25RfAgd+po6sle0tpWc
         UqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=L3VLCiIuu2QtRF2usLH4Yr+4/9+bBwP+dMGRVINQnT0=;
        b=TZfw+J+ZV1PR6rqP+AQ3fV90ehGMSW8DW6DkU8R25977YDFq51tTwd/PDGBSwBpNbm
         rnQwa9epThF4OPTM9UfDMGwcpcpCzFCyggDf9wO4NX3P8UiMCoQi8m5daU99rpsMSU73
         +jYplJDpokFTzqtNdeRvMTs0GqLuv3FXFt0oG6/uaYd5FcnCQbrDxcUZXTvGFZORdYLH
         iwlEz90EqlZ8MkeynT+ImNMc1DmrdiQadgpXgYbJQIiTFYKKMoKyar7Kklm4hU3+1KOC
         EmPMxkFRVLZch13+54jI7GWVd1ZmNiHYTsU/1Qg7spk0jQ6YsyhZe60ZBrT/ORaUJq4i
         DAEw==
X-Gm-Message-State: ACrzQf3vKMGlb0XBjDWw5+Mjbla8+TNsrMI54UiPQzP00XucPuBG/qdC
        7jJojzU1c/rmWFRxjhOYP/M=
X-Google-Smtp-Source: AMsMyM5z7SJFTesrc0ORSWgSYk/DUy6lDZHCp3BuzNNJE0mkMCeAtrrdsQABAjscQSYvs1JQsMbZWg==
X-Received: by 2002:a05:620a:2b86:b0:6ce:ee47:f733 with SMTP id dz6-20020a05620a2b8600b006ceee47f733mr6991717qkb.398.1663606573745;
        Mon, 19 Sep 2022 09:56:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fz16-20020a05622a5a9000b00359961365f1sm10552848qtb.68.2022.09.19.09.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 09:56:13 -0700 (PDT)
Message-ID: <0bee971d-ad4a-b7fa-56c7-80ca2b58edc7@gmail.com>
Date:   Mon, 19 Sep 2022 09:56:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: sh_eth: Fix PHY state warning splat during system
 resume
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <c6e1331b9bef61225fa4c09db3ba3e2e7214ba2d.1663598886.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 07:48, Geert Uytterhoeven wrote:
> Since commit 744d23c71af39c7d ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state"), a warning splat is printed during system
> resume with Wake-on-LAN disabled:
> 
> 	WARNING: CPU: 0 PID: 626 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0xbc/0xe4
> 
> As the Renesas SuperH Ethernet driver already calls phy_{stop,start}()
> in its suspend/resume callbacks, it is sufficient to just mark the MAC
> responsible for managing the power state of the PHY.
> 
> Fixes: fba863b816049b03 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
