Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF935316EF
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbiEWS2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244515AbiEWS0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:26:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635E41F60C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:59:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so13768272plr.9
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xDqbXgbQnWkuzyoSHcpShXlc3j40MaIF1+PDiU4OQwc=;
        b=UMQ+Ru4au7N2zIA9oFdCwHg5PVqTLjw6V5372+EsKz/jHQKh/AJBIS2pSqsSKm8tD9
         V+GWX2FN12jWiuYFfXvTY4YepvYh5bEx6EvfL9M8SKTkekKqdwtSiUzILqAJu8pHMI0/
         vrlsHoXYSuKdlRn431z0GEbpEkevOJB/D+1ud52g4iwY2Fs3zxaQh8CK0D/l3ZFDtFx4
         0NRu8s2ASZZbPoemgpbvTtPocM/3uZdKOqY12t61OKuqPDtf+mlFzSdnRreJeL+zJDGA
         zObb2XfFu8+dt9WJsyb8G/qrRNLFmf5Aoq3GXZYkK3rN9aYtXt4V9O4zt3YLBr7VTaD/
         QzHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xDqbXgbQnWkuzyoSHcpShXlc3j40MaIF1+PDiU4OQwc=;
        b=pcp2U2w55F8YtXl1YeLShbiTXxRMT3YyTgZXA9NkOwpSyb0AanEIuyctg+xUiza7Tt
         OS8zwwP5pTDR7o0PfIQO/nKTGb3Xqg4wItUV2lPKKtOlvzXD8MU2gTaAeYQ+CjGrEdQP
         bQpJzYwlhs5HiBVjY6asKoYPywqekzTMkDX3AxvhknnY+ElMXMCFZvmSMUN0e4IK1/Hk
         MRvVbCch4GCsJxAJ+0bdv5eMlMkJCMFYZcngNuvYXgjZ0zryaOVPo7+okBjv93Ya+jmg
         dng2mjOY4HVMBFTzEya1Z7PxdWdbBmR0SMPcDMrp5GnGO8gX2Mq8+jyLBfUyrdGTDKZ8
         liXw==
X-Gm-Message-State: AOAM533PEeL2KYrCma1s6Lv+c2MbLHcFE49aCBPivKWTRGpBGmzbx54L
        vbmLfJ8/dVs5JTjUITwWNtQ=
X-Google-Smtp-Source: ABdhPJxRjbqM6H9kQkOAA0y7ASFT2opYBSjzyDFwtsQAh3cjICsFgQIsDEGtrlnC1fS49jIjoBwBqg==
X-Received: by 2002:a17:902:a502:b0:151:8289:b19 with SMTP id s2-20020a170902a50200b0015182890b19mr23750854plq.149.1653328744844;
        Mon, 23 May 2022 10:59:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c2-20020a17090a108200b001e02073474csm4963120pja.36.2022.05.23.10.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:59:04 -0700 (PDT)
Message-ID: <a77a6aa4-f038-a5c7-d6e7-36069989782f@gmail.com>
Date:   Mon, 23 May 2022 10:59:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 06/12] net: dsa: only bring down user ports
 assigned to a given DSA master
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
 <20220523104256.3556016-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-7-olteanv@gmail.com>
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
> This is an adaptation of commit c0a8a9c27493 ("net: dsa: automatically
> bring user ports down when master goes down") for multiple DSA masters.
> When a DSA master goes down, only the user ports under its control
> should go down too, the others can still send/receive traffic.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
