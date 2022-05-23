Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154E9531944
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244072AbiEWSS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiEWSSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:18:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B581A7E31
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:57:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w3so7153336plp.13
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M80R9ahYmPBb+o2ZImyyHU08I938Wyk5hTSEiNoCO5I=;
        b=XJyvVhle+dUHqr0/7xjkkK/v8Hvp6aoXxPUzy5uVVh6GIbi4M4C/69jhYMSdBB0P1k
         bL44tSfWeOT7zLn1VMLc2t5MO3JBKk4vueMNJiyqsmcggX/TTX/2pUuA/J/uSPIBqyHp
         12jUzzpLaBrbbRIlt4Uils9JY4W0Uqh/QnQ1GxEmRDXfe1vgmexAj/hp8jTQJLoTXmEC
         ZYc7uLznmEXBFTM7svcTFV9R9JwvpbeeJyAvXCi3WmY+uoEYRLmsbQvgtqLCJAZCSpQd
         ZW2tLL36AXFb79J9iRPu6QgTRphGTeoTnMOZvxiUzdFyVgg2KAo6eYd2UQJdNWJvKto2
         S/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M80R9ahYmPBb+o2ZImyyHU08I938Wyk5hTSEiNoCO5I=;
        b=CldGXTIqyToKaY/oEND0W/9t/Uy5wHJ/UwaxDmnwCEVKG7PyJtOdmZllUNOfr9xHeH
         9TcLwVMOnTGS05Zd4kF+QQ2h+Sj6N/m37lPAgD+s+5g14DgxIy9lP2jieaMHzo5b0Xcc
         xYMCZRq6av8LujMl9kqWsVOhzI4u1V+dhCu/Frgg7xaBBDLGSynXJy6/eAV57PgifCBn
         jEkVISRoGlmftGvfmmAWVOTEnS5twQfq/SqvMNQA8aufA+oYJ21VuHnn4UXOS+pQdpQf
         gzHqqT1jf986CjSfRO1YCm8iRRQTDlm4CGpe82Brqk/TDvEF79qtfAx8HX0aXRYxJCI5
         3rKg==
X-Gm-Message-State: AOAM531dykdESO6rDUN95I+M30HKOkhizBV17g4zK2TSW6jyQxoBuuwc
        yxb8Y+mLyIhn/LvHIpbYb08=
X-Google-Smtp-Source: ABdhPJyxRpJCqEngtVoDlff13ZG7SF1sPPIqs7sklxaoo88OJrXoEnxrBypY3hUmejDE6nom15PVlw==
X-Received: by 2002:a17:902:ea0a:b0:161:fb2f:ef9b with SMTP id s10-20020a170902ea0a00b00161fb2fef9bmr14827650plg.22.1653328593245;
        Mon, 23 May 2022 10:56:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y12-20020a62ce0c000000b0050dc762812esm7580615pfg.8.2022.05.23.10.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:56:32 -0700 (PDT)
Message-ID: <9b493b79-9a48-e6c3-5b96-4ca83bea4466@gmail.com>
Date:   Mon, 23 May 2022 10:56:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 03/12] net: dsa: don't stop at NOTIFY_OK when
 calling ds->ops->port_prechangeupper
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
 <20220523104256.3556016-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-4-olteanv@gmail.com>
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
> dsa_slave_prechangeupper_sanity_check() is supposed to enforce some
> adjacency restrictions, and calls ds->ops->port_prechangeupper if the
> driver implements it.
> 
> We convert the error code from the port_prechangeupper() call to a
> notifier code, and 0 is converted to NOTIFY_OK, but the caller of
> dsa_slave_prechangeupper_sanity_check() stops at any notifier code
> different from NOTIFY_DONE.
> 
> Avoid this by converting back the notifier code to an error code, so
> that both NOTIFY_OK and NOTIFY_DONE will be seen as 0. This allows more
> parallel sanity check functions to be added.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
