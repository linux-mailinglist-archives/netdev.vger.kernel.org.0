Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5363452F5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCVXXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhCVXW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:22:56 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB21C061574;
        Mon, 22 Mar 2021 16:22:55 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so17715668otn.1;
        Mon, 22 Mar 2021 16:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rEOq8jouDmNbvyAXswJnkUQLH0QL0JMja4dqJ2WDisk=;
        b=ISlrFUnda5jFNUE02BastwVdi6XdZae8P/mpaH9nvAOR20ijhe2+OdQapEP6Z9eHb7
         IUF/zUYkB5cFN1qOIbNj03/x0JDte75+ed0B/71CI+UqPlVpW2tFwKXZ4y1uxioeW88b
         qHhuVpyYMZux5DCEc771CtfmWKrakwBgFHhsCghifKaXRzLkiKGnvNHVR0/HdjtdYBNF
         cwuX53sjCt0bPtrWptfVXi/D2n7gL/DKqpiCTmzWJoFCrWFmMGBetFd6riwSMja6NRuY
         GDxWbNP4kzEC03rTbHgS2ut/BS9KA7ES78LQKEg035BTzUdFrT7SBHwDC76F9nbmFfLC
         OoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rEOq8jouDmNbvyAXswJnkUQLH0QL0JMja4dqJ2WDisk=;
        b=PGE3TwaUUxHobGyF7oGTDalpzpstOeLawStxSN8smj2FYLrrN9b+3iFz/3Yb0xJzT6
         RpN68BmpYsZF75WkUGmdIlnbCufItujLc5yTk78PKDL67l1bnPMLV//W+rMKKhhqT5Nh
         B0YOGYdTBZ+7JuSEQ4T052DgnHnxDbRenQhWrCwp2V6qjW6+wPPN6c6y7eEG0aKfycg9
         JdKjfVyevyqwbQphZNY+ajeQxSGGhViSyl5jsaJP0MFy6IGs7l/jiQpSkOGOIa9cAY/Y
         951y1bZc+40axrPgYhU0lY31o1EiFMiO2/6NwvFJ4+8SLFU3hkSkVRYcd2ymIk1OfEa2
         uMmA==
X-Gm-Message-State: AOAM530opqFkqZmnwrkK7pakL9yPvAgUvmF0J/zBTB8trNXMs1QvoPDK
        fZCWiH3gPcYyfRDArnkTKO28XhOrpdg=
X-Google-Smtp-Source: ABdhPJyF1pL8NGG0KLMccy4wAdLy3VIsJQsZZBUVkdUtyaPEsF9GLXnZOcC1aL/9XW5ArXANFD6fCw==
X-Received: by 2002:a9d:7a44:: with SMTP id z4mr1854880otm.272.1616455374904;
        Mon, 22 Mar 2021 16:22:54 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:e55c:4df0:791b:af23? ([2600:1700:dfe0:49f0:e55c:4df0:791b:af23])
        by smtp.gmail.com with ESMTPSA id z3sm3520787oix.2.2021.03.22.16.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 16:22:54 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: don't assign an error value to tag_ops
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322202650.45776-1-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a838e69d-c286-65ba-2e29-73b9240e7191@gmail.com>
Date:   Mon, 22 Mar 2021 16:22:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322202650.45776-1-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/2021 1:26 PM, George McCollister wrote:
> Use a temporary variable to hold the return value from
> dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
> an error value in dst->tag_ops can result in deferencing an invalid
> pointer when a deferred switch configuration happens later.
> 
> Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
