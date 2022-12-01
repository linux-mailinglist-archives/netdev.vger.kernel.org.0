Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9B63F986
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiLAVCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiLAVCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:02:02 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CD7BA62A;
        Thu,  1 Dec 2022 13:01:50 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 4so2854763pli.0;
        Thu, 01 Dec 2022 13:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezWuOdbnTJ9YYhIzrIidfA39LKIVBfCeP6aAua1c40E=;
        b=U0RqtprrbQ4BCa45vSG/366wB4NZaCTHCX0AEyQcVW480HyPFvE0L/jQgvJPDXnLrI
         OljG8/RwG57No3bVbdvlpLXWbT6qcPLnkl8CUkg7gsLE/St1CiG3VJNggWEUgDelh6qe
         5JHmDvYrucBo3U9NmR3DDE33RKkGjTB1eF5la/l26Am0vW68ZVnSiV4FwTDaWB0KvfSb
         haAMfcFaie7ESR2qAe7j7eR+6rKnBj0+tqSM4P+1/O4Xuc950vHDwxU5wL+/5J4WwIC8
         0UUu5PWyTjr2bo0TTKoCqHws6iBclzGHTLhrpzRBqfi+4nBV4FXO0gmwVfmV8TLZc0uz
         M28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezWuOdbnTJ9YYhIzrIidfA39LKIVBfCeP6aAua1c40E=;
        b=mWH9x9bPfWh1wVSGqY5LtJXfj2wrFqTse1n2Uy0Hk59cd66LKebwgr9b1Ujs6V0qtd
         umZSsdeL6MGdoURqAXCAmMgTTE4yiYRYIFN8y/qUA/iZpV+RsRClGKnF+LPOkONWhKnY
         kNg0LDWeRfKrvsYwfgBFuReD+f+gZNz02E6PnsiUFiNbqqTdpADv07ss0xCqDQ6qZKpr
         oo8NgeYALkogG0GNTEa2ta8OCf1sv7agSLygjY1AlAOcFKGPBt846nq1OqRE/XkcQ3qv
         oA5Ogn7jxxFFUCRplK/J4XOyE80PWJjAN6iwgSUkEVaY7a/aAM1AGYS0ynaQyeZfCpuZ
         Oq9Q==
X-Gm-Message-State: ANoB5pnv4CbHaJlEliw3ISTLCXvEiCmrEnClDEBWmjUmxxxPFT++9+Vc
        bFsJmN0ME0u8Rc4tI6paWZ4=
X-Google-Smtp-Source: AA0mqf7kr16BV0VQy7gjP5o2kdtFMaLEFgTB/zMj71XL13GDMbvqDDCl7Kmo9kyIMyzG2DK5ZMZN4w==
X-Received: by 2002:a17:903:2013:b0:189:ba1f:b16e with SMTP id s19-20020a170903201300b00189ba1fb16emr492746pla.62.1669928510096;
        Thu, 01 Dec 2022 13:01:50 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:edbb:db52:d3ff:52f? ([2600:8802:b00:4a48:edbb:db52:d3ff:52f])
        by smtp.gmail.com with ESMTPSA id z32-20020a17090a6d2300b002190eabb890sm5273761pjj.25.2022.12.01.13.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 13:01:49 -0800 (PST)
Message-ID: <68d0d276-576a-b77f-1d24-a3e0f0be5801@gmail.com>
Date:   Thu, 1 Dec 2022 13:01:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 3/3] net: dsa: sja1105: Check return value
Content-Language: en-US
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20221201140032.26746-1-artem.chernyshev@red-soft.ru>
 <20221201140032.26746-3-artem.chernyshev@red-soft.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221201140032.26746-3-artem.chernyshev@red-soft.ru>
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



On 12/1/2022 6:00 AM, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum() in
> sja1110_rcv_inband_control_extension()
> 
> Fixes: 4913b8ebf8a9 ("net: dsa: add support for the SJA1110 native tagging protocol")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
