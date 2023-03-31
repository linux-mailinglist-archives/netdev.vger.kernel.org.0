Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840616D20E9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjCaMvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjCaMup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:50:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F9620607;
        Fri, 31 Mar 2023 05:50:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so23240394pjz.1;
        Fri, 31 Mar 2023 05:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680267000; x=1682859000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vbs1HhSjAg0eM+0oNwNTSGrKrWraD1cwEIxOCu9j9DU=;
        b=fKfpK2fMYdTMJX3uz+qDJmanxioYpuRW97pVn6oqtdjYK8837YfCKIFN2Kd7OS/IQ+
         BIV2Vt6URNwXi/0aFStdaGsLB0AH5b44EgDz1gn/dtGOvRnI44iaEY3fsCecNBiLqw/m
         zLgkUNvF9lR3JlLkMU+plqz0XI4BizdeUtJqYAH05INRvoETW/CmU2K0BfhFNbd9IQUo
         fbCC2XLAp6kRiphM3mhxmv3GQtGjaC2bUDS0FK9SXtE0jz6qxqe5VKIlOYU/ACQbmBif
         Uhme3YNJNo80zCK2g8XMz0nJIgZ63z7++1KEjuT85BhtLtZ7VpLx0egV6+y3hLHKuECX
         aM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267000; x=1682859000;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vbs1HhSjAg0eM+0oNwNTSGrKrWraD1cwEIxOCu9j9DU=;
        b=LoJnY5iSczm9JAbnleJ7LQjbzFu+C40yO2v/X1FQBxBqgJVKldQFXpXwziRGFY4Wvd
         omBnlLde8KSEP33wBPPohEA4kZYnMnJRe1QxLjcrjm4dXnND76k3XCm9h1gi5/PHN1hK
         dR4+JV+jpo3gpkeYO0MeW/jL9NNSnf62xk6T30KX5kDgESpcwEEVHY02H5CBFOG/t0FR
         +nVxCvva5mWMen2hcCYWe9Eh2xCj7aGqPZ9t66N6Q66qs+8BAdRCajVSjDU8vKL9Gr7I
         y7uW21P0fe3t84sj0cDIgrIF+VlaJgJkCZ4g3xk1XFa/bkUgWG+MKzG84OYDYF8Mdtlh
         49GA==
X-Gm-Message-State: AAQBX9fFTp40Eoyf6dTIuUKUX2BMG0Db/D2tg9KZ/oV1/BlbHC3E4Gd/
        qhV8p0Ro5l5sWBIYeeTAQL9hIGktYp0=
X-Google-Smtp-Source: AKy350aKukhvZw1r5O7mUBtl6YSvHe/5pVxM3Cv37qiG4uGNZL1e4z0q0cEyP12ACxaUj7uCV7QdBQ==
X-Received: by 2002:a17:90b:4acf:b0:236:99c4:6096 with SMTP id mh15-20020a17090b4acf00b0023699c46096mr29055250pjb.35.1680267000269;
        Fri, 31 Mar 2023 05:50:00 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:e51f:9935:aaf2:6b7? ([2600:8802:b00:4a48:e51f:9935:aaf2:6b7])
        by smtp.gmail.com with ESMTPSA id v2-20020a17090a0e0200b00240aff612f0sm1437578pje.5.2023.03.31.05.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 05:49:59 -0700 (PDT)
Message-ID: <17c85ba2-10dd-1507-5b90-0233651fc57b@gmail.com>
Date:   Fri, 31 Mar 2023 05:49:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: Reset mv88e6393x force WD
 event bit
Content-Language: en-US
To:     Gustav Ekelund <gustav.ekelund@axis.com>, marek.behun@nic.cz,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@axis.com, Gustav Ekelund <gustaek@axis.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230331084014.1144597-1-gustav.ekelund@axis.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331084014.1144597-1-gustav.ekelund@axis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/2023 1:40 AM, Gustav Ekelund wrote:
> From: Gustav Ekelund <gustaek@axis.com>
> 
> The force watchdog event bit is not cleared during SW reset in the
> mv88e6393x switch. This is a different behavior compared to mv886390 which
> clears the force WD event bit as advertised. This causes a force WD event
> to be handled over and over again as the SW reset following the event never
> clears the force WD event bit.
> 
> Explicitly clear the watchdog event register to 0 in irq_action when
> handling an event to prevent the switch from sending continuous interrupts.
> Marvell aren't aware of any other stuck bits apart from the force WD
> bit.
> 
> Signed-off-by: Gustav Ekelund <gustaek@axis.com>

Would that deserve:

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x 
family")

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
