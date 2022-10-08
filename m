Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BB15F887C
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 01:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiJHXfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 19:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJHXfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 19:35:53 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A330D360AB;
        Sat,  8 Oct 2022 16:35:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ot12so18297996ejb.1;
        Sat, 08 Oct 2022 16:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=naZGIakCqjFr1/icJG2tTqwOVE0S7L9ImSn041t4cwA=;
        b=lDL2BKsNcv5q90D9fRbCPc7ZaSmja/NORn77v2NOyjXndZPXYea20aqmw4KCuPgx6N
         mI7p3jHfTYqPnkV7NI8ffSpLzkKbiuuXDMRxZFMUq2oDOgZXParwMYxjfmgHcoy4R+FJ
         sqdya1LyovHwN07XS5UeFfr1anoMpbUQo9nVfI3TWLTA4oZhk6vtVPf6sHEWhDSWZzzE
         RxKN3yxGNADp3my938DiytLToNP14/oWH/EKBQ59evKI/DqTgUVxOEn0fI8uRdIej96G
         WgsK6nZniZb/JwJPBkUGWefqJEj+K1D9W2MSZm4iETgj51s1DeN/zmhZMgTTzDBZ1IEB
         MmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=naZGIakCqjFr1/icJG2tTqwOVE0S7L9ImSn041t4cwA=;
        b=PYQVhQ3xdqDLqMmCaI2FRZUzJXphzK8TB/kL7asPYnBG4KQaSrrDyvPuY6//TVZKf0
         ZfRBqCdUxJr3nejdHFW9AtTJQPHQAGLkAgRf04jug9EAm1ALbz5dLGiVORdes5ZOqDgQ
         WVSICWifFC0jX1f73aPCg5AQbEkWcpjdjS4MXlryzwDQMd/aUVbNhBntUV/FLP4y8dKn
         X087kLy93g9iIL8MYqhcGNy8DP2grlEk0QN4sHtdvjh6cGnrmX+J+Iy+33Rkzc0042Px
         ef9y9Sm86upTFBXPCpJbGTbO0yvX0WeRbSBk81l7oqiZcxL80xI2+M3cN6V3HzAFA5V1
         780A==
X-Gm-Message-State: ACrzQf2o8Ggx6oredQphcv+gmjVO045zK3p5E8f7FDJ2q3B/ZdHaCT+z
        hKpIz0zcVRPd3UoCq67q9tM=
X-Google-Smtp-Source: AMsMyM4f6gea8/aOK64a4TtIdZxC3Nt2n/9MxmRFyos2+sYNwD0Slw2RxcZSCNqiDVQuX6FQC/swfg==
X-Received: by 2002:a17:907:2bda:b0:78d:9144:fb6d with SMTP id gv26-20020a1709072bda00b0078d9144fb6dmr4776417ejc.238.1665272150162;
        Sat, 08 Oct 2022 16:35:50 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id lb9-20020a170907784900b0076ff600bf2csm3325173ejc.63.2022.10.08.16.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 16:35:49 -0700 (PDT)
Date:   Sun, 9 Oct 2022 02:35:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: Re: [RFC v4 net-next 00/17] add support for the the vsc7512 internal
 copper phys
Message-ID: <20221008233546.355nunskag34gb43@skbuf>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-1-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 11:51:35AM -0700, Colin Foster wrote:
> The only warning I know about is about the reg array being too long:
> /Documentation/devicetree/bindings/net/dsa/mscc,ocelot.example.dtb: soc@0: ethernet-switch@0:reg: [[1895890944, 65536], [1896022016, 65536], [1896349696, 256], [1896742912, 65536], [1897791488, 256], [1897857024, 256], [1897922560, 256], [1897988096, 256], [1898053632, 256], [1898119168, 256], [1898184704, 256], [1898250240, 256], [1898315776, 256], [1898381312, 256], [1898446848, 256], [1904214016, 524288], [1904738304, 65536], [1896087552, 65536], [1896153088, 65536], [1896218624, 65536]] is too long
> 
> Also I know there is still ongoing discussion regarding what the documentation
> should reflect. I hope I'm not getting ahead of myself by submitting this
> RFC at this time.

This is because 'reg' is longer than the schema was told it would be.
net/dsa/mscc,ocelot.yaml defines 'reg' with maxItems: 1, whereas
net/mscc,vsc7514-switch.yaml lists out all targets.

At this stage I wonder whether it wouldn't be better for you to patch up
net/mscc,vsc7514-switch.yaml with support for your compatible string and
reference dsa.yaml, rather than net/dsa/mscc,ocelot.yaml which should
perhaps be rebranded to make it clear it only applies to NXP
integrations of Microchip switches.

I also expressed something along these lines yesterday
https://lore.kernel.org/netdev/20221007231009.qgcirfezgib5vu6y@skbuf/
and I'd wait for a little bit more, to give Krzysztof a chance to
respond and share his thoughts.
