Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8165B7742
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiIMRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiIMRFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:05:16 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A20E8169E;
        Tue, 13 Sep 2022 08:55:03 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1274ec87ad5so33357781fac.0;
        Tue, 13 Sep 2022 08:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9js1M1Ii2LBgsHaQvlOo8Knhz7Y350P1S5r7xrIXqTQ=;
        b=EVT5HWXUYM003TARno3IQO4Hi8JaemayLjFweoL6eo5u9hy0Z94/QAe5tkpSLq7jNO
         qYn5rtrkA3B2dp0lkEgiL/Py6VLwKGq9LaSsw6sn8hPDvVXd9sNmRXYo7BVRpKpDxPJV
         KEFdiZm0BU+9wCRDxPwubXA/xkR8ebGI/udNzqaMIWHXmJqLpATMtFK1UL1+jxb1WAw8
         bN36v4vQJ5vgrGZkEn+74ulmam80mpxf4uHGowzhgP57VqasPWL0X2S5lMmVBsg5i/GT
         ljxneJ9trWIp6N0EVbc0CrZUiNhcsMKXFd5NdkoKLq+fm5x72HQgLWLpxgfaU7bRoq+k
         b6BA==
X-Gm-Message-State: ACgBeo1gV49i0rCkR+kekKz5GrtDA6BwLoDMf81h+ZQ32v0RyLPviW/c
        TKTa14kWA6NqjYd2m2X+rw==
X-Google-Smtp-Source: AA6agR6OSLSOn5d1tMnYfRyDMU2tMdpF8Je09Y8xIoPZ+L8vtccd6B7jTMVW9FMSQvYR8s6Xdz1Rmg==
X-Received: by 2002:a05:6870:231e:b0:116:8e04:5d03 with SMTP id w30-20020a056870231e00b001168e045d03mr2158319oao.210.1663084449931;
        Tue, 13 Sep 2022 08:54:09 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l10-20020a0568302b0a00b0063711d42df5sm2875562otv.30.2022.09.13.08.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 08:54:09 -0700 (PDT)
Received: (nullmailer pid 3805949 invoked by uid 1000);
        Tue, 13 Sep 2022 15:54:08 -0000
Date:   Tue, 13 Sep 2022 10:54:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Message-ID: <20220913155408.GA3802998-robh@kernel.org>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
 <b11e86c6-ff35-2103-cebe-ebe5f737d9de@arinc9.com>
 <20220913133122.gzs2uhuk626eazee@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220913133122.gzs2uhuk626eazee@skbuf>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 01:31:22PM +0000, Vladimir Oltean wrote:
> On Tue, Sep 13, 2022 at 11:20:04AM +0300, Arınç ÜNAL wrote:
> > Is there also a plan to remove this from every devicetree on mainline that
> > has got this property on the CPU port?
> > 
> > I'd like to do the same on the DTs on OpenWrt.
> 
> I don't really have the time to split patches towards every individual
> platform maintainer and follow up with them until such patches would get
> accepted. I would encourage such an initiative coming from somebody else,
> though.

You can always do a patch for everyone and ask soc@kernel.org 
maintainers to apply directly.

Rob
