Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7233598744
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbiHRPSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiHRPSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:18:13 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48892B64
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:18:11 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qn6so3804908ejc.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=kHEZ5/JVF1rwUMZoV/gWAO9PPTyusMxKu++tMCbpwJY=;
        b=Dn/yRRxsmmPVcs1XcLylfUxf1ASFNlzzU7WrguiLLUQShg8HCWxk8/1UO8Svck0yRj
         HzjHsoVXwvMh+MkZ8aZ2990fmkRsOR63uLfLQI4ezz35p3DWFhOEa5O+UPlOxdWQB3Js
         GPGKlKpfZbs5nOV5D/RV7aEgDONLg+OIEEkF5OP0j1ebxQsCksQc9aF3DZyB5x2PoT3v
         NuxC0eS5SfPtsmgdgJ81i5YxfGEfGHwgzdbe04MeQf7ziT2fYsjpDm7hxxX0IJN97mt8
         7yzvTtZd9yUpSrHRelip/Pmop5rqAAgYKqUcHdWtGje8Cpd8rih51uuZ5fzy4YcCaVDR
         zgug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=kHEZ5/JVF1rwUMZoV/gWAO9PPTyusMxKu++tMCbpwJY=;
        b=C4exVbdJyAg7sbwT2K1epOMk4yi2ywybqUtt5HAPogHBrls0Q3TzZSOeDyNwiaoZM6
         ULOgJqRtSZPA3Wx4myYzoTULvPGSXtHXi42DAyAWKanUXsPk6n8ceqKmNptX36o+jSq0
         FBXUBlDkqi6XBH9qudpAJ4ZMkzudZh0eJ382GkF9Ld2gj6yBk70s+2wYN8HQXp7BBX8r
         kXw2TLY9AWoc72Xl1I32pLop6hkIYe7pMOAnoCS6WQoSkPM0qoSM2K42s1LHlyeWetZT
         XIGTM7Yc2c5P8Uh3cS+XDSgcsYtYg9XGAExkibMQhjA1UbFYaiUV1D/1H4DTo7HVqca2
         iA/w==
X-Gm-Message-State: ACgBeo1JcDrNDgvNjSOBZs9WTjhPqcL/fn38+kQuFYzAUtAH1JPPvixj
        JsGTqcYVG8OjNfmh9TbcSVA=
X-Google-Smtp-Source: AA6agR4j5LmM+WhQCYDBrFjztYkjVcn8xv8jxYCAYZuszekWTQUm4Isf0pmHmOA1kCUR2ns7WZV5fw==
X-Received: by 2002:a17:906:7944:b0:73c:838:ac3d with SMTP id l4-20020a170906794400b0073c0838ac3dmr1378275ejo.242.1660835889821;
        Thu, 18 Aug 2022 08:18:09 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id w8-20020a50fa88000000b0043a7134b381sm1291831edr.11.2022.08.18.08.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:18:09 -0700 (PDT)
Date:   Thu, 18 Aug 2022 18:18:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Message-ID: <20220818151806.yv5crkdab6tpkvph@skbuf>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <20220818150644.ic6pf5arbh34lr5z@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220818150644.ic6pf5arbh34lr5z@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 03:06:44PM +0000, Alvin Šipraga wrote:
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Thanks.

> Some quick grepping shows at least a few other drivers which do not set
> PHY_INTERFACE_MODE_GMII for their ports with internal PHY:
> 
>     bcm_sf2
>     ar9331 (*)
>     lantiq_gswip
> 
> Should these be "fixed" too? Or only if somebody reports a regression?
> 
> (*) I note that ar9331 ought not to rely on DSA workarounds, per your
> other patchset, so I there is actually no need to "fix" that one, since
> the new validation you are introducing will require a phy-mode to be
> specified for those switches' ports anyway.

Note that my patch set which you are talking about
https://patchwork.kernel.org/project/netdevbpf/cover/20220818115500.2592578-1-vladimir.oltean@nxp.com/
only enforces phy-mode presence for CPU and DSA ports. Whereas internal
PHYs are more typical on user ports. So the problem is equally
applicable to ar9331, as long as it won't specify a phy-mode but rely on
DSA's assumption that user ports with lacking DT descriptions want to
connect to an internal PHY.

IDK, if I had infinite time I'd go fix every driver. I don't know why
some have GMII and some don't, and I'm not exactly keen to go study
every driver's subtleties unless a problem is reported.
