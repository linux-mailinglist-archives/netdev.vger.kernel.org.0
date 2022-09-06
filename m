Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C1A5AE49E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiIFJps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiIFJpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:45:46 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172E572FC3
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 02:45:44 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c10so2172384ljj.2
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 02:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=x3XyvxYTPay75Odx2z56uSBSyZ0GNuroYu0FKbzM3PU=;
        b=PInCWvoADAjEt/GvuyC8I7yg6b1qBHqoEY1c9xLWjkaip99ZD5F+f2IV3GfULMjaYm
         qsjEdNTkYmHeDJUsnK9nW99uyoQJb4UeKEqaIFUZyzgBaV4YZpQPu+FTLsc95yXQH7Y5
         HClEa/pz63VYOPvafTCkQCBTSvOvfozAN8sgLcE3D/NnGRUAmBhSEwmPLUTba3U5AVRo
         MiBAZmBIs9WmyrVlO8oY7hvAAHfLrUY0rZu2l9MDLCVB/kVwM0ofSkUo00/hkEDl7ueL
         y+rlkmQ6L5Uc61c3ndsghsMAxq3TJyPJuDWHK/ClXoudvpo2t0Ck1Ht/fz+6GvxR0vgp
         he1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=x3XyvxYTPay75Odx2z56uSBSyZ0GNuroYu0FKbzM3PU=;
        b=eCEW0SSlRfEBeI2iAHwA0/LetN3suHLLi14kmvlsLKqi+hp/n8s0xD3BOxrjezkwVl
         83Aj9zYOoSXMaGRlBoPfBhsMEfsUeRzCo9+L0vnyb+tqPtgF9yBTM3qfN3dERGxQz/d2
         KGESvHWSVTBo/k4gDSLCLYuU7G6r+jyBM2R2qeLur0wwxeTLkdEa6p2zQ9nkpDHICtwQ
         H1uSI7n+Im+DPRBdlYyNX6nSWFuwg+KPyD2gpmJ9LirYzlcO+cSAazAZYBFrrouyr53b
         9nGJaJ1b19PLfbHPDuWShADLdoa6Dsu7CCXNXmFJGHXPMbeXdsRenkylIqFCIJVvxBwF
         GFRA==
X-Gm-Message-State: ACgBeo0PrNmhTnQEd2lqS/oDKvgpsRAW3SgRWsFcK6F3uGPQZdRzafUQ
        HLcuff7SsyvJPPizk/nO1CM=
X-Google-Smtp-Source: AA6agR4399I/UERB0dr5GBpHPiRIU+J96qJSDRjBVSJHGndzEi+PUTq6CTb6zgWUrXvC0wLJJ3GxTw==
X-Received: by 2002:a05:651c:451:b0:263:7cfc:1c0b with SMTP id g17-20020a05651c045100b002637cfc1c0bmr12348898ljg.94.1662457542876;
        Tue, 06 Sep 2022 02:45:42 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id g3-20020a056512118300b00494903a1f5dsm1627732lfr.187.2022.09.06.02.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 02:45:42 -0700 (PDT)
Message-ID: <951d7336-ab24-1fc3-bb63-837145a7f043@gmail.com>
Date:   Tue, 6 Sep 2022 11:45:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 0/6] net: dsa: mv88e6xxx: qca8k: rmon: Add RMU
 support
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906100732.775d0fe1@dellmb>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220906100732.775d0fe1@dellmb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-06 10:07, Marek Behún wrote:
> Nitpick: in subject, the order of components separated by ':' infers
> hierarchy, so your subject
>   net: dsa: mv88e6xxx: qca8k: rmon: Add RMU support
> means:
>   component net
>     subcompoment dsa
>       subcomponent mv88e6xxx
>         subcomponent qca8k (this is wrong since qca8k is separate
>                             driver, not a subcomponent of mv88e6xxx)
> 
> You should use ',' to separate mv88e6xxx and qca8k, something like
>   net: dsa: mv88e6xxx, qca8k: rmon: Add RMU support
> 
> Since this is not an actual patch, but instead a cover letter only,
> it's not a problem (at least not for me). But please try not to do it
> in actual patches.
> 
> Marek

Ah, ok I see your point. Thanks.

/Mattias
