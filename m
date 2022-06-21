Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16B553167
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350136AbiFULxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350132AbiFULxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:53:03 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6DC219C;
        Tue, 21 Jun 2022 04:53:02 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lw20so4596675ejb.4;
        Tue, 21 Jun 2022 04:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Euwp5N+3NI2BdvzXjSxZwpJ8MC0XY7297caCI5aXQwc=;
        b=caoosVB+ji/MBF4QNxdPDrMTdE+RUfJFeYCOK51Ypxol8hOyopUeoHDcgG2cbvKL4j
         AQmpw8fYkkLcmWdn7JrNqEJUN1XOFaZNi1WH3u+KUXQs3zS8jmYbIpFoJt8VnvzSFCGa
         v7DB2WqSA1tLqrvbIR/Ku+XBmc6Q4Q/IGU7x6WsGcHltS8tae/crxVqBxvu4Kmhw5PcJ
         HsDB6B4CcR5HmcYiQpX29eNqdhRoho8PxnWbjHWqOdvhLymRaQ8oGcAOGolNNACmwbkQ
         DtXi7l5LbraKTByoHzYTHJiJU8WBEjV5zXDJBjccuJktBSwOEg8+yP08sb2ya3ue2nzy
         NDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Euwp5N+3NI2BdvzXjSxZwpJ8MC0XY7297caCI5aXQwc=;
        b=O0LGx2EoN57icvH5GFSKhjZridzHkI7sDeUxvmkNHBk4hnT7Js5UgyJf2qt6/TEbj7
         84CwlQtkBo+WpRQu3tKeJIAf3wTUllwqSx0XivzLpQHZNIAk4aBLPcBBxPpb72bvCisF
         c88ec8yyiXa1lLUWolDkzK2Q/4bouimWYNGJJoGRl9yeWAFe9LBmQJeFRVVVkiaV/P2k
         jDyOm0A6ilg19lY7FWLL0zyMrKCbKn2pBc4GYc0dv1msNSLniUnPWWs/ZALkGJGdATF+
         wbch0Z1awRQYHtySPuquTRW/8GLX/LlFJ5zyO0uVhF0lvW8x7Qpxb/4bcwmccJ38iXAa
         w0ZA==
X-Gm-Message-State: AJIora/BUO0aC5Yd/8yPTBAzlq/UMsKwZd/4wvjQRwFhvd1VIYuZg8Dg
        nBZFnzTM+Gy0fZguPwhPVWU=
X-Google-Smtp-Source: AGRyM1uWvOjhc8Wie+uhS1amwH9iINJ7y4JcksVrZ5QJ7wQCVhIldTXXHZ1puT3SYqw8WkYWZhe6mQ==
X-Received: by 2002:a17:906:530b:b0:715:7867:1033 with SMTP id h11-20020a170906530b00b0071578671033mr25797519ejo.683.1655812380816;
        Tue, 21 Jun 2022 04:53:00 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id f16-20020a17090631d000b006f3ef214d9fsm7453537ejf.5.2022.06.21.04.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:53:00 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:52:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 14/16] ARM: dts: r9a06g032: describe switch
Message-ID: <20220621115258.grihuonqjncjy7tk@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
 <20220620110846.374787-15-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-15-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:08:44PM +0200, Clément Léger wrote:
> Add description of the switch that is present on the RZ/N1 SoC. This
> description includes ethernet-ports description for all the ports that
> are present on the switch along with their connection to the MII
> converter ports and to the GMAC for the CPU port.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
