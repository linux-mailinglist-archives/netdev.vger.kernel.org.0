Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B92B54BCF9
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354910AbiFNVtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiFNVtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:49:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CBA515BA;
        Tue, 14 Jun 2022 14:49:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e9so9579406pju.5;
        Tue, 14 Jun 2022 14:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JnppAby++umsNjCD3pKbHZyzqXGEc4aNf76TasCL78M=;
        b=KjGXcBr75g9HUX7cG89maVM9ywrCv//4TXxYWvp4lKhtr8/3p2xpjyAyVnH6XI6Oht
         lCyS5kn8GOk82mhDzYQT3WuUgH4BuzDDpzvUC6sfX5BDUJ308ekG0To+ft5ylZmVvrsn
         gBS2nwMahrdxz5vdpKvHVDvOHOGkvSMPCw7UyLt8AIpzVYDO3OgT03wSRtbz3FkPJooC
         Y0deKide8ELVkkJ2i+oJ423Q/FImS3RgYsZpU1kInRzu3zEqegtr719bzV2TPBUW9qgU
         yKEbWS5Z8cJM0U5Ez8IE1hePLigqPEuk/0KB23HqOGZq4ixkpCau/RGBCbzTMWcbnCXV
         qjAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JnppAby++umsNjCD3pKbHZyzqXGEc4aNf76TasCL78M=;
        b=yyumlHXMKngqX+5MouWOBmNXuIAlDP2vEYdFb7W1qmG9Q9dbjz1mQKLrTvkVdpzjgc
         uMwjkRvoU2USDY2JJHnDxn3UjaUPGOt7hFxSnklXDyK6AipAsP7F2OI/ZAEemQ3uVaSk
         lWqsUbumBW2x3L7NgUW+GHxdeFtRQ10f/LRvufjQOL4h9dUm6thqHGBIIhKMFsXL4+Cq
         f6NODRENkR4PkKTGhIXsHKN65ctS2FTQYGQjAj7unXr/M8yLlH0Beg4iAY7Ritk+2PG7
         DmlyhIMqI7IBtj+qtYqOBukqekGwZavzwJDtkH9yMdOz5jt1F0rCDQrOLGRK9/tCdGrc
         B3vg==
X-Gm-Message-State: AJIora8laPhatgIsHkFaritAJTQs8JB1KBUnknzO1MTX7cJOZWc0BpRz
        ONHL4e+DdN7urUNRfhzo+kY=
X-Google-Smtp-Source: AGRyM1ssR15ccU5hlqg/aCbI1LIPgD89tj8zm0nZAf8OG5gpOcorkn3Gl/QUpvgWtODgQetKM7iJyA==
X-Received: by 2002:a17:902:f70a:b0:153:88c7:774 with SMTP id h10-20020a170902f70a00b0015388c70774mr6140678plo.166.1655243351473;
        Tue, 14 Jun 2022 14:49:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k132-20020a633d8a000000b003fd9e4911f9sm8404374pga.31.2022.06.14.14.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 14:49:10 -0700 (PDT)
Message-ID: <670a18b1-e1f2-0c18-8543-b9ca4b0838bd@gmail.com>
Date:   Tue, 14 Jun 2022 14:49:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RESEND net-next v7 01/16] net: dsa: allow
 port_bridge_join() to override extack message
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
References: <20220610103712.550644-1-clement.leger@bootlin.com>
 <20220610103712.550644-2-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610103712.550644-2-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 03:36, Clément Léger wrote:
> Some drivers might report that they are unable to bridge ports by
> returning -EOPNOTSUPP, but still wants to override extack message.
> In order to do so, in dsa_slave_changeupper(), if port_bridge_join()
> returns -EOPNOTSUPP, check if extack message is set and if so, do not
> override it.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
