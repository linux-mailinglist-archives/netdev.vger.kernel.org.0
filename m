Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587C755A63D
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiFYCiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiFYCiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:38:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D97E0E5;
        Fri, 24 Jun 2022 19:38:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso4464418pjk.0;
        Fri, 24 Jun 2022 19:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/OijS4SjToI5XwW5E7dZjtKTN0UE09QSJc1Akdu6OIY=;
        b=XOnArdr5kRKtDKf5yewashIU2NvIp+rFn9C1YUbBoj9sK/CzavZVqv3tSD79hhv6Sh
         G/oPWdnuJk2Wd7T2kJ7ZIiuJLpkqh3Cm1SYFda0wbfMJxJLAYMi4f5NTVz6CdjZevvP8
         redK8WBAx+MWiMcAy0N1vWmpKj2d3Xi7/nhxBftsz7nXULqyNUHONpKvVJg+1uWSf4AN
         3Q32GeAyZeoN0ubG/iJPMwZys/VhOdvZODM2YofCUaMCctDhlg4VZ9EYXjdHUsyzfmWs
         Z+5S1QX4gr0RGGvjV4Untw1f8QVabFjnRStnkq9qsj7Rr2KEOpuVKBA9oO1XBLAeuqB/
         dnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/OijS4SjToI5XwW5E7dZjtKTN0UE09QSJc1Akdu6OIY=;
        b=mC9XlXaCHb3BYrDfg9iB/6Kk6sc+bsl8AMOgF4s5/arlx38OE0PjI0GVjXfcD9m3lH
         dKQLFcl6zfXmHvBJOHT0nT6eLXniSiRoqXkoKrkPLYkolH7UX0gO13M9psVX6+rEWvoP
         XCRlDLrq1MuDuKI7uzo3wso71MT7eS+yQbzNS7b37Qi/LxmXaEa8BcSqfbaYERmXhHlm
         W7XiNyxpDC5jBEH0CKpNdxsTJnJSEqxu+qzsBXJ5NcCscXYE9X8Q5ysgtTe71TNPqzmo
         jEDeXZtZhzztL0F8biedzbzJ6F1/vDO/ckUgQM39JjZ/vTRVsWYySU8aeDGfEf+h126E
         i0Ow==
X-Gm-Message-State: AJIora9Dzczy59BFY40JGrWaMK/8CMBl342YvDA1e2Io/0ZKzGby/qpS
        j7LnjVrR2AVrodZ5LkP3CY8=
X-Google-Smtp-Source: AGRyM1uChDO2tvnLqk4atwph57LJSBNhE36Q1FpEGikBojDl2QsDpuTpb7a5OCVsusUT0VM7DIDXpw==
X-Received: by 2002:a17:90b:1d90:b0:1e8:5a44:820e with SMTP id pf16-20020a17090b1d9000b001e85a44820emr2094249pjb.217.1656124680714;
        Fri, 24 Jun 2022 19:38:00 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902c3c400b00163f5028fd6sm2512218plj.5.2022.06.24.19.37.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:38:00 -0700 (PDT)
Message-ID: <5e1d2e91-8e0d-d32e-cbb7-bbe9698fdef4@gmail.com>
Date:   Fri, 24 Jun 2022 19:37:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 09/16] net: dsa: rzn1-a5psw: add FDB support
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220624144001.95518-1-clement.leger@bootlin.com>
 <20220624144001.95518-10-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-10-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2022 7:39 AM, Clément Léger wrote:
> This commits add forwarding database support to the driver. It
> implements fdb_add(), fdb_del() and fdb_dump().
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
