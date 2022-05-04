Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD651A478
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352773AbiEDPyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352768AbiEDPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:53:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF43445ADE;
        Wed,  4 May 2022 08:50:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id a1so2186173edt.3;
        Wed, 04 May 2022 08:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AQRpkAKdmMVu+dxnCv15cqtIIRdmFX29YU78FmgJGcY=;
        b=nKalCAdDTn07PS0s6063sjEr9mYVxTH0OajN50A2rG1dHFNwmivIfD8rQIRKcqZQzl
         XzIWuLPkOR7vwuDjvxJFyAVUP3nyxxNkDXngMaBPKkivrDOG798A3/6Bc9cLqrNKvq22
         1bjJe9NlBguS6/DJAmhrbdWY+OtisuOEttkpzr+hxLp9aVwxBNmOzn+oQuqoG85zACxl
         BrJc+TqxWHVWSWEoKrNYkxiCuSdj8ymXZur6d4fgHx//FtFbLN1zOcMYVxcZmq2iziOz
         X+Nf1uVVCQ6UX8HDDqRpMZG6kxVKNhVqD5v2OHRHqIeADtmGfwASbH4gxoKgHEJ6WvOe
         kVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AQRpkAKdmMVu+dxnCv15cqtIIRdmFX29YU78FmgJGcY=;
        b=0att+phr04bCtXhBYPnzQ8dDPIx8CmnKVaSgc/JpsSl9gUMU0vYulUjs0MCehMBsnk
         /vMCnFe4rWKS9wLPohcyStVZ6JgzhQ9GT9QAMtFmIFNNutOPYnWBVhPAdRpgE/PAT3wV
         o8PsG5k1DZ2+PPedtwhOi2P2k6xW5EoCZ15vN0U4zXrG6PhuIyZLaa7sSKNczxPcwCpv
         w35MUSxskHTswSE+AxTJ+NY2Oti+WJDaJPPPFMWHkEVucq/AP7rrtTK0sL1dL+QZc1Nh
         9qFn9tDRtRrsTrKASVroRXdeiNoM8eNiQf8kiJktwBunsDbJ6K+NmZ/D6mLEWHGFhiXA
         IyoQ==
X-Gm-Message-State: AOAM532QIqVxyJyvsaRr0fthSay8nVEWtKtZnxoraNOPe3Q7Kbynr11U
        6uEQlSt5llAwtLp3onbL2Es=
X-Google-Smtp-Source: ABdhPJz7SjEh/9cuYXaPkz32A7SwymkAVKIUX89xZAQyFqh2lG8HAWMCwwNtgxbot4j94EFxYP4QJg==
X-Received: by 2002:a05:6402:1a2a:b0:428:1be3:51bd with SMTP id be10-20020a0564021a2a00b004281be351bdmr2207943edb.267.1651679407269;
        Wed, 04 May 2022 08:50:07 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id en9-20020a056402528900b00425ff691a32sm9036295edb.0.2022.05.04.08.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:50:06 -0700 (PDT)
Date:   Wed, 4 May 2022 18:50:04 +0300
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 01/12] net: dsa: add support for ethtool
 get_rmon_stats()
Message-ID: <20220504155004.ftwcmoe77mgvnm75@skbuf>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
 <20220504093000.132579-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220504093000.132579-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:29:49AM +0200, Clément Léger wrote:
> Add support to allow dsa drivers to specify the .get_rmon_stats()
> operation.
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
