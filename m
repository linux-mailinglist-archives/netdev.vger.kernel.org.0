Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71E624490
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiKJOnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiKJOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:43:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734CA2C67A;
        Thu, 10 Nov 2022 06:43:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u6so1523913plq.12;
        Thu, 10 Nov 2022 06:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dx9Bi6iY9mxmn1O18gi6zgWDIoquBunnLdm9wuBtprA=;
        b=lRZZx5h6X+vXmxfPORkbofXfmHdIPTjZCmSYfkmmZlYrlt8PA794rc0BGpACiWGJkr
         x8gdxb9aedhOfiIoThbJmnB9ILE8f63KPhVIZbKYyo61pizubVdLtQgywc3bV7WMaTlg
         nA/yaMhYWEJapU3G+gDRC9XyaRyJbu7rqxsaw+iEVG3m1JL2N4E7S4++g9Ju1ddeYZFD
         SGsnfON7LPKvDTG321jcSvXt6Ek3j+6SNfYrE/Dzsenk+v14BUt9J1icGk8wolXeP1hR
         Z9WY4b1dZkcd8c/u7wB4SB4tJPBBtWCSZLQB+ithbe1KS4/+ts8Usil2/EaTa5EQwHhh
         tnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dx9Bi6iY9mxmn1O18gi6zgWDIoquBunnLdm9wuBtprA=;
        b=pFA6eGUkq7Ykx4Udxdu0atkSlrYbJEMAfiukbeNd5KANMe8qWDIBVRG3+3Lk2P1Bts
         bGPgiqpwA9Qx5CnpWEOuEwEsTDhZY5ZWv/LFfrXBdL8UAgn3d24YWdpJS9JzFLQfVHd0
         fqhIE3m2wl5qZ/XDA3z/q3dSZe9hQMUWklWn4j25CtcTcUyQ++tE0p5QstUNPKShv30Q
         KRNmWsofQCymKobXozOvY7kUuVBu7NwQYMOloBWPHRrZKm0BpVW/6VF9OXUdsXDTdhc5
         7tZS9dOvC+wP818V9AhyXY9JtkbKZ/INW8DHV7S1SG8kpEjrdip4J68IxUGLxISywQ8V
         Nu7w==
X-Gm-Message-State: ANoB5pn887tO+xvvAD1gBMOXykQhCEEmyKC3cxM4MkhVtwC5s6oDwpM0
        1ctVc4s1vuGUmxCBBKgTLBo=
X-Google-Smtp-Source: AA0mqf76CueN1miKrjuvcBdXzA1UVoSNsv3koL91x8i5V1G2zoE9q5N9tfclmQww4jttMLNm7GpJOw==
X-Received: by 2002:a17:902:8a97:b0:188:8cad:f8ca with SMTP id p23-20020a1709028a9700b001888cadf8camr10767968plo.84.1668091430966;
        Thu, 10 Nov 2022 06:43:50 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d? ([2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d])
        by smtp.gmail.com with ESMTPSA id j2-20020a625502000000b0056bd4ec964csm10250751pfb.194.2022.11.10.06.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:43:50 -0800 (PST)
Message-ID: <75394de2-44ca-7a65-3dce-7c583b514e0a@gmail.com>
Date:   Thu, 10 Nov 2022 06:43:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 4/4] net: dsa: microchip: ksz8: add MTU
 configuration support
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221110122225.1283326-5-o.rempel@pengutronix.de>
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



On 11/10/2022 4:22 AM, Oleksij Rempel wrote:
> Make MTU configurable on KSZ87xx and KSZ88xx series of switches.
> 
> Before this patch, pre-configured behavior was different on different
> switch series, due to opposite meaning of the same bit:
> - KSZ87xx: Reg 4, Bit 1 - if 1, max frame size is 1532; if 0 - 1514
> - KSZ88xx: Reg 4, Bit 1 - if 1, max frame size is 1514; if 0 - 1532
> 
> Since the code was telling "... SW_LEGAL_PACKET_DISABLE, true)", I
> assume, the idea was to set max frame size to 1532.
> 
> With this patch, by setting MTU size 1500, both switch series will be
> configured to the 1532 frame limit.
> 
> This patch was tested on KSZ8873.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
