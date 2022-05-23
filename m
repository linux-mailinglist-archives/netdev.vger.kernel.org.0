Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E0F531C03
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243936AbiEWSSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245457AbiEWSRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:17:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0001D302
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:56:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so14417077pju.1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BCJGteQb4/4LCC7nq7EXH1VCXs5qkEgmqMqMG91/CHs=;
        b=dMQ0jxNud/jF172oJRe6Zn1tolJ4B5Q/wIZFm0p5VY2b4UmVXZWcJNA/K9NqGU4jB4
         cS9rjE6xqAjhyJtbulEGF5dhiUQF3kcLekEphvb4k+Cor4ahHzEkRhWI5TGaOfWpvZfK
         4seNV4w8Th65xsklKu0cFIXfAelSrKboLb4bYNKOzntYitKZzvpOX1K55k4mkY74RjAh
         U1FZIPbkCNU8XAeet/SkxbxwUEgr6EijpZVjTANcQMJxh4YXDjrzd7fYi+RVYInBqHLB
         0qT8t6ll1x15sVwbj/N9pAypsvS6USBGYHLrV98eWQv7A+TWsCOOQGacc1hfYibM3Q1B
         i/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BCJGteQb4/4LCC7nq7EXH1VCXs5qkEgmqMqMG91/CHs=;
        b=mJ2rsSNsU3EyXMVDce7zb1CWSkH/N25xKpdWHZARmIdh2ulGuQYOZ2s1Zj1md2TD3v
         m8fbl6fAiHzJ8T9UBrdUuCLNfm5XRfbvy2rM8ZJM1CoAKA2q0NTNvP/lbHdFc0B0bIbv
         eDAkqyVVD1bgqvZAEGaTxl7GnoqcMt1Gly7rnkPjQO4aLoVvY1cz7buBWKInEyz8ppAw
         0XN4KnnBr7yDoIvK0npOJncJaaWyuY5RQZrl+AHd9Ffor+JXjp65NZhJpQpnJqD6Z6JM
         1PQA43fANv448OSK1knTAby89Y4w12npSkq7xMdcT2zJXty1Kz2tH+HmGBaMYQGfYlqn
         /KFA==
X-Gm-Message-State: AOAM531giH0y/smj3vpLa30hJpapQgyVoOCqEWJiM7g92J2F0I5yscSH
        mJfjrNZ/APY4c/2l4HBuY8U=
X-Google-Smtp-Source: ABdhPJz6cp/TyXS4Lgvcphkte6MOYcHwXhSyzZoo78rXv08GTNMkUmCPikgaIoBIm9UFzUk+Rrgl4A==
X-Received: by 2002:a17:903:22d1:b0:161:ac9e:60bc with SMTP id y17-20020a17090322d100b00161ac9e60bcmr23665601plg.13.1653328447472;
        Mon, 23 May 2022 10:54:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l20-20020a170903005400b0015e8d4eb2b4sm5367691pla.254.2022.05.23.10.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:54:06 -0700 (PDT)
Message-ID: <19b45ab0-eb92-d739-e1bb-651c9648d779@gmail.com>
Date:   Mon, 23 May 2022 10:54:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 01/12] net: introduce iterators over synced
 hw addresses
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-2-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some network drivers use __dev_mc_sync()/__dev_uc_sync() and therefore
> program the hardware only with addresses with a non-zero sync_cnt.
> 
> Some of the above drivers also need to save/restore the address
> filtering lists when certain events happen, and they need to walk
> through the struct net_device :: uc and struct net_device :: mc lists.
> But these lists contain unsynced addresses too.
> 
> To keep the appearance of an elementary form of data encapsulation,
> provide iterators through these lists that only look at entries with a
> non-zero sync_cnt, instead of filtering entries out from device drivers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
