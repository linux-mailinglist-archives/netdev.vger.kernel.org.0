Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2187C6D217B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjCaN3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjCaN3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:29:46 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4DA1E726
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:29:45 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m8so1971308wmq.5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1680269384;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uYZCzBVfxsWHy2Gs+AB2Zpg/OuKvsK2jYyNdw+fk0QI=;
        b=GaWMch6pYQUM1ckcEZN8g4+j4aYl5PlFtHXwctDPHUVGIlqDy40tkNDKBS0bU3g0GK
         GWx0xTUAWQxrcktQShunATGt67WFxsP8N6BG44IeDuA5bH2LyW3L/Zct1+i78WIDA+8m
         Os28lm9t5PnSXVFwomOGtDeDyBj3RlyTki30UPjEobviN3NwR1d7iheVAvhXQVubgzOo
         +kp6NXhBbPMO3bW3J6zOTLX7lM8yflfmfUfoNCSOE8XJLUYVLaWi1QoGziPBL/6ONP2Q
         UDXZUwb3pYBoEh6oxc76Hc5VMH0Lg0jzAOOphhqydZooMJXjNRyRho3Ysam0j81FeUC6
         Fc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680269384;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYZCzBVfxsWHy2Gs+AB2Zpg/OuKvsK2jYyNdw+fk0QI=;
        b=LvgazBE8Grfrq156lYU82NPp0569AQ1nowLKaKAoAhFKnVRZK9UhyHTIs6kAZXlj6m
         o2KIPDfwoa8FzDouX7TT1jAk3QSa8mCaT/wgMQdh+5Q9n5bHj74AcoQmLFAt+ModwDvA
         m8YV5fXvhAvCQ/4R8h7ociIeOe29ogzsv5aQ3DfcGgLbZ2442pMVoTnStU9f9NHvsSId
         RoXODyEbWtrdPd+Pvg8UwiN+K29Sug955PYAI8m3QePi7OeyF9NLvRHXSNR9hpfpmKdA
         LbcdEqUScpx3ctD6Hx2VFNGI/nSuczrZKWbFYGodvEiAnx3ht79lgwstqB6gzCJNlcxL
         1edQ==
X-Gm-Message-State: AO0yUKXZlaioV2lSZH41pwlZPe0J+fTUXq+Sc1c8XLBe1XVyFWDOJ6Rs
        Tl1zQLucWqn5TmeNiS2VEeKGbA==
X-Google-Smtp-Source: AK7set+KGAfj0BtQKgtctS4DSAim7ThX6scGR+iuNuKHltdFJwWU88zaEt2/T52QDcQBu6TWAYxjbw==
X-Received: by 2002:a1c:7418:0:b0:3ed:cb97:3ad5 with SMTP id p24-20020a1c7418000000b003edcb973ad5mr20735442wmc.21.1680269383979;
        Fri, 31 Mar 2023 06:29:43 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:189f:b19a:6f2a:701e? ([2a01:e0a:b41:c160:189f:b19a:6f2a:701e])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c22c100b003eeb1d6a470sm2707581wmg.13.2023.03.31.06.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 06:29:43 -0700 (PDT)
Message-ID: <dde9340f-4e44-3d51-b1b1-840d0f166b08@6wind.com>
Date:   Fri, 31 Mar 2023 15:29:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2] ip-xfrm: accept "allow" as action in ip xfrm
 policy setdefault
Content-Language: en-US
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
References: <dc8c3fcd81a212e47547ae59ee6857ce25048ddd.1680268153.git.sd@queasysnail.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <dc8c3fcd81a212e47547ae59ee6857ce25048ddd.1680268153.git.sd@queasysnail.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 31/03/2023 à 15:18, Sabrina Dubroca a écrit :
> The help text claims that setdefault takes ACTION values, ie block |
> allow. In reality, xfrm_str_to_policy takes block | accept.
> 
> We could also fix that by changing the help text/manpage, but then
> it'd be frustrating to have multiple ACTION with similar values used
> in different subcommands.
> 
> I'm not changing the output in xfrm_policy_to_str because some
> userspace somewhere probably depends on the "accept" value.
> 
> Fixes: 76b30805f9f6 ("xfrm: enable to manage default policies")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
