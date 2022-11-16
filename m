Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2047062C46C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239025AbiKPQ32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238902AbiKPQ3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:29:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C203A5E9FD;
        Wed, 16 Nov 2022 08:23:18 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so2796455pji.1;
        Wed, 16 Nov 2022 08:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=27tC8IXiM4AvJpzfsuZEF5jyq+wtXGGlnypYcMRERZw=;
        b=buK+Hw7hNMt/hnn0pP0nRsrDoQfcVA94Deh4aquQzMD1eM0AuREQhsNHa4giuT7mTw
         o0cPvdem0u8DB6KNe/0u/xto2sSLiQDysSwXB/yWXcR2UCGXISa68Ep1wlwWpANa2kdh
         usMl15F6jAElVC6G/bxPOIuFLOtpHj6HPqZDqOlUamJuVW+TmyDkA3NtA44Wyd2FQmFo
         OcdAbIM6I1ojZVWHvNMnLdcv4G7gIQ4vykRA5+q5i4CE/8pm7nG/nUC2i6ssDpZckhIX
         GKTQAGJqq5UIEgh3EBdk5w4JMRauNMoO7orEffIEFr4jGArNSH3p3zH2IxAg41l9RW/N
         GJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27tC8IXiM4AvJpzfsuZEF5jyq+wtXGGlnypYcMRERZw=;
        b=msd1wLH22EXGZcolk/xOvbiKoqpLT+NqaNcCbSAqXSBlCCkxRSBvXKj6eTvspLKnCO
         D0nZHeTqONr41ABAK4G5SX/SbqsmpvAqB32XKlKXN91cFNJaW1FkwcA7PgVJL2K2oMQ/
         QBGNj8rq9o+43Hg5lAeRfxATSb5mgo/vULaWme2HE7VJ43m2ZpMhFvGIf7qSyZIsvS76
         WkvTTCZtMn0XiXxKy4Hc5s9X1Hj1rtrAZYED51MBPWlqmgoa2imDyyOUGUfhunjF96Cs
         KL1h48/XTroylxcWYVhkSV6wQqpZSKIzew4DcHvWNuZ37LCXfNBlwYonRtU3xDRB86Ib
         GM1w==
X-Gm-Message-State: ANoB5pneAthb2Nnw5oVDtGvfKxwGoRRQklUA+hBph+i11J293EZHtgLd
        a1aBpMKMVKOw0DAviG56n44=
X-Google-Smtp-Source: AA0mqf64sk7TQqJmvrQDzB96SP3oUaKm0LI6Nz1gSJygeNKxzlmGzBZpeH4TQEQZTJIcVJQJCYRMpA==
X-Received: by 2002:a17:90a:4283:b0:218:4953:58aa with SMTP id p3-20020a17090a428300b00218495358aamr4441129pjg.219.1668615798399;
        Wed, 16 Nov 2022 08:23:18 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:9801:5907:5eb0:dd5f? ([2600:8802:b00:4a48:9801:5907:5eb0:dd5f])
        by smtp.gmail.com with ESMTPSA id 98-20020a17090a0feb00b002135fdfa995sm1791392pjz.25.2022.11.16.08.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 08:23:17 -0800 (PST)
Message-ID: <d2f15412-0a16-f1cf-1472-87c2d71f6ffa@gmail.com>
Date:   Wed, 16 Nov 2022 08:23:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 3/3] net: dsa: set name_assign_type to NET_NAME_ENUM
 for enumerated user ports
Content-Language: en-US
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-4-linux@rasmusvillemoes.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221116105205.1127843-4-linux@rasmusvillemoes.dk>
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



On 11/16/2022 2:52 AM, Rasmus Villemoes wrote:
> When a user port does not have a label in device tree, and we thus
> fall back to the eth%d scheme, the proper constant to use is
> NET_NAME_ENUM. See also commit e9f656b7a214 ("net: ethernet: set
> default assignment identifier to NET_NAME_ENUM"), which in turn quoted
> commit 685343fc3ba6 ("net: add name_assign_type netdev attribute"):
> 
>      ... when the kernel has given the interface a name using global
>      device enumeration based on order of discovery (ethX, wlanY, etc)
>      ... are labelled NET_NAME_ENUM.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Florian Fainelli <f.faineli@gmail.com>
-- 
Florian
