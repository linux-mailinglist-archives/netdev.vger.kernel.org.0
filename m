Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF8B5BA6E9
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 08:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiIPGhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 02:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPGhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 02:37:54 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1042A2873
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 23:37:53 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r12so23301475ljg.10
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 23:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=V7a7DmLJePV6Oy8QTu0208RWWmWReJ/1f2el+0ICliw=;
        b=pbUFZonz+Sz4E1SgqZSM005AHGAa2legXgitPSor5Hwe8jIcnTHl9Qt1QaEb6fIqk4
         ehuQBV/Zen1UO/rliaoWX/xeGToLw9pF8KfDfUvpKiHw4GvnW/wT7ufty6oCvjvPQYAI
         Ftj6PwvTiEfGOYzRpjiBeaBWXwEVl0GgaYInoOC+PM9r+iQUK1UHMDfja2oBEK7Oe9Di
         NDYjlNw8hXG4xTj5h1kJIxQfQHpVfd2uAeUVc8pCAMGKefL5rGTJozi+4I2baFXN/LHf
         9hhP3RzcfgqAjc9uVOBZPnvr4UOFmmanEovQty4RLO6ppS3ioWxdd8YUTHPCqzZIbfiJ
         LLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=V7a7DmLJePV6Oy8QTu0208RWWmWReJ/1f2el+0ICliw=;
        b=yl3frLc4VtMBO7QLijNsZxEXleBrSSeQib+gBggOCdAzDwedpTe4Qcf7OJWRYIlG/u
         dcHMNiZBtSSCmZqOdn6gmY3lHWlXg4waeDwlJj3Xx2wELN3UUeDZ2v6Nza09ECaJXJgI
         n/OHrAjkmFYWJvb6lL3TVh7aMltwTOhLHYjJHSs4Jjalst87Q3FN8GC0nZYx1FMY0E0e
         5Fki/SqeaGhSmzTD605C8YVXWh0JHuM/DpxbNUTVSimNPv9CbkpPcVVZQeRtoe1pSsmv
         eTWQ72IIrJ9TufvWQ3T34CE/dB+o+J4IYCeYjYpFD8l6EaCEqZ08E5hs6fueBnpscYHA
         m6TQ==
X-Gm-Message-State: ACrzQf1LvCGa9/k/VxLhguMjC7zDQMrAV9j++jMYtsTR8Z7uQEOZZ96K
        7Im/hdbTl/ofyDLcU6U/WLpD+5xVXB2C3eOc7I4=
X-Google-Smtp-Source: AMsMyM5sUelFcgUA1XPNrIQ/NOtptKQYcSAKXX6GoyrfQSv+KjH0nOF9F6yPJIkXv2e1ASZuG7hCqA==
X-Received: by 2002:a2e:bd84:0:b0:261:e43c:bac3 with SMTP id o4-20020a2ebd84000000b00261e43cbac3mr1055052ljq.198.1663310272241;
        Thu, 15 Sep 2022 23:37:52 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id v19-20020ac258f3000000b00494747ba5f7sm3331080lfo.272.2022.09.15.23.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 23:37:51 -0700 (PDT)
Message-ID: <86100715-7db4-7ea6-09c2-345ae5693e9d@gmail.com>
Date:   Fri, 16 Sep 2022 08:37:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v12 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-6-mattias.forsblad@gmail.com>
 <22592ab8-ad68-0aca-c23c-72954b043ac0@gmail.com>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <22592ab8-ad68-0aca-c23c-72954b043ac0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-15 22:11, Florian Fainelli wrote:
> On 9/15/22 07:36, Mattias Forsblad wrote:
>> Use the Remote Management Unit for efficiently accessing
>> the RMON data.
>>
>> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> 
> Seems a bit wasteful to add a rmu_reg field for each statistics member when there are only 6 STATS_TYPE_PORT that could be read over RMU.
> 
> Maybe what you could do is that the offset in the "reg" member could be split into a lower half that is used to encore the existing offset, and you use the upper half to encode the RMU-offset.

As it's only three port statistics counter, I'll make a switch statement per Andrew suggestion. Thanks.

/Mattias


