Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD72632E04
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiKUUfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKUUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:35:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8657682BD9
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:35:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q96-20020a17090a1b6900b00218b8f9035cso3213926pjq.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=66UneHgx/Sw1/5XxL7k3XRxeJFLF8Bbz/g361gCO4Fs=;
        b=HJ2vzGzvac1E631KILxHPtR9j31CkxQmmC0GHDjrs3UUH0ISlKAiDSKy5bpbpZ9JwE
         7+7cam0np8wmgxDntE8tG4hhIgVBOdmj7mVEFOqKG8KrwwHRcWhTD5wiqBuihCDA/Nu1
         pP8G8+Y7RmdVOXIG0tXjMQ+b4glK0/T9KbN7bzcxI5bvw1HxPJHVeqBXmRd9JmpRX57J
         I3MK2OeewBe2bMa9vqEPz+G53FIuwUL6UFJIxknIWlbaDWmQFJnembpHPb62MLMotxdQ
         WyFqWYgOHwifmr8nhcE39gpvdaI1mvI2u9ClHbHEaU4prJEOQTODzNnTr+lnpIq694n4
         Y0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66UneHgx/Sw1/5XxL7k3XRxeJFLF8Bbz/g361gCO4Fs=;
        b=3L5zidq+8Ua68MLPRd75U70qx31jEYLg92zGks8wi5z0DRZxXCOaeEL43hyU0WyLZv
         wQqM5lbb+SUPOM3ozvwIN7h6e+H2+U89KwWJFHN5AJG0SjM1zJ2KcExeG0MMyXZb6CSQ
         HGkOqqvIRqnAiV1X7q4FjGsH1+TZifsOisZDlOOpB2tSwRFawZIlydbVr49T7cKi+wAv
         cIZVEonrMnCqjtc6XdgAdsR3hZbMt1cJaMl0ol2CqLspXIquN4/+opcLTBHiwCfd+pYI
         C9f06XizQE1SI0z3QhWFBW3Hho2M4GKg+wcJxmF6+D2UEbQz67VsCq7R0B9hIF19lW9f
         vH1Q==
X-Gm-Message-State: ANoB5pl1nMvSVc+yBt+vtds5Pr5bPQFxFZC2tLo1bGqeI9560Lo8fAka
        oLiOtUTZY04C2F4TOTogozDB8xPhKDU=
X-Google-Smtp-Source: AA0mqf7QfuV1iybL6EuFdrBI6Pp5CTl4pA7//lpqkQFCSOLOTftaHpHH15HhjnME4LRm0pi+K4qUVA==
X-Received: by 2002:a17:90a:460b:b0:218:8a84:aeca with SMTP id w11-20020a17090a460b00b002188a84aecamr16331443pjg.63.1669062929867;
        Mon, 21 Nov 2022 12:35:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n12-20020a170902e54c00b0018862bb3976sm10275685plf.308.2022.11.21.12.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:35:29 -0800 (PST)
Message-ID: <653efa6c-ceca-d2ae-b1cf-295714b2dfa4@gmail.com>
Date:   Mon, 21 Nov 2022 12:35:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 12/17] net: dsa: move notifier definitions to
 switch.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-13-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-13-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 11/21/22 05:55, Vladimir Oltean wrote:
> Reduce bloat in dsa_priv.h by moving the cross-chip notifier data
> structures to switch.h.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

