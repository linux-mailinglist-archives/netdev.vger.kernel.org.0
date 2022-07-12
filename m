Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22845712ED
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiGLHRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 03:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiGLHRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 03:17:52 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D75674DD7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:17:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so4246414wmb.5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 00:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=8p7pSjgMH7NDuXnh5+4nZ6el7vUcOBJ2B3VHb/Ta1r8=;
        b=Nr+tZAsKh9TZquzZ03J7EeGDpvclMgYP5LAJjj2xfYKUwKLT9xAnmr3AqsvRseGhpY
         6zMY7Iy+vviuf1WdTho11n3T+bxD9OzLimI+LaI0mhpkRo14HaRcP+j226hbSEUc/xRf
         MDvW9qivtGodfwVWJrnOAXzR5KxFsarx93EiEXUAa02likczJ67+6vFv9akAZRG8sAQj
         1KqoMdllXXGZm4NQ2Qf7v6+PiMe2ww1+Q/LWI73Uz5qakw6eXcfNTBiGsS17EQ4ew88Y
         Q6Hi2GSqFHtsWcX3KI/QI00Q7CLMrizS3F3ula+jUdwj7CJJEHalPOtdtCFl+9t7aaAh
         fyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=8p7pSjgMH7NDuXnh5+4nZ6el7vUcOBJ2B3VHb/Ta1r8=;
        b=dXVaus4CToWIzZflkqNBabQfk6H3uhfis2vh7eeY55Aq9X7O2lMaXun7vDE+htTzDb
         aC/HkA7o6Zkpb1f0sLxmbLiETPP35xW6x38lPJNUcU1uVWUdIgZE6pFtUFXjkO9QcHnY
         NdAL9VHUNx247idaIwTMvmblASCghfZ+y981Rex9mgNYXzJ2qseBeaNuGfj3sV3f6Oib
         EJKIjvOUKkU/KFkyMG1lMHowSq0qCwvwtVB6AidSoBP/PNKhdp6A+sUyVWZn+lhDSDn1
         O+UGWXGupNWOKYz2j+whPDxv/aWHRcBSfjE0yxCCtAEoanp/W2Is7CCOfoELsi2HDXhN
         vF4w==
X-Gm-Message-State: AJIora/FEt8rhV3+QiatQvW1mr7iPOlYK+oJNlYXOgqbvJY89rT7zFcv
        JNIvFqe5WPqHcvTQQstYLExVnQ==
X-Google-Smtp-Source: AGRyM1v4+DusPOwfBDYpf5YL3QpoKU7pzRSsprrd3ia7BEU2m6OPcVXJmj1JK9wfPQWXo7hLoKNFkQ==
X-Received: by 2002:a7b:cb41:0:b0:3a2:d6eb:135d with SMTP id v1-20020a7bcb41000000b003a2d6eb135dmr2371293wmj.150.1657610269715;
        Tue, 12 Jul 2022 00:17:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:6422:a9c9:641f:c60b? ([2a01:e0a:b41:c160:6422:a9c9:641f:c60b])
        by smtp.gmail.com with ESMTPSA id i9-20020a5d6309000000b0021d808826fbsm7560552wru.44.2022.07.12.00.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 00:17:48 -0700 (PDT)
Message-ID: <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
Date:   Tue, 12 Jul 2022 09:17:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
Content-Language: en-US
To:     Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 12/07/2022 à 00:06, Matthias May a écrit :
[snip]
> One thing that puzzles me a bit: Is there any reason why the IPv6 version of ip
> tunnels is so... distributed?
Someone does the factorization for ipv4, but nobody for ipv6 ;-)

> The IPv4 version does everything in a single function in ip_tunnels, while the
> IPv6 delegates some? of the parsing to
> the respective tunnel types, but then does some of the parsing again in
> ip6_tunnel (e.g the ttl parsing).
Note that geneve and vxlan use ip_tunnel_get_dsfield() / ip_tunnel_get_ttl()
which also miss the vlan case.

Regards,
Nicolas
