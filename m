Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB16E7CF1
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjDSOig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbjDSOid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:38:33 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8137C3C17;
        Wed, 19 Apr 2023 07:38:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so1568822wmb.3;
        Wed, 19 Apr 2023 07:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681915110; x=1684507110;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pRLB4jafvDSF5N3zbFXDTvNqa3CWokYQT7DnSmldu+s=;
        b=B6s2epmCAFJBrmAoB93mRJYd/ff0qly363oyJkb5paDWH4zH4tdPVJFuITaSc1N72l
         U4HOTyjY88hj/udELRS4uSsrNpX5Vpe17ZUdi4PI3fI7mxs93bxsNH/lHXhAtxTrYF3X
         i9RchJQa5d4MWGxMb7ZxqdEbEsXlWy5QyUpsoiS9jq/wk84HwkYHCeDhdlaDpOvN+Htu
         Oxt4nxTx6igTQpl1D/YjYYQFslkA/GlMXAAK6XWyLulRa2HfeYEP30j0TSAF5jggaNRw
         6jP7dxN14tx+r8E/mw9Lp7VGwEfMhTVokzsg46F+eIHoMyLbe57euwMka7/nx7vlLAPc
         jXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681915110; x=1684507110;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRLB4jafvDSF5N3zbFXDTvNqa3CWokYQT7DnSmldu+s=;
        b=T8aSBHJlNG46OLRHSqbty/MNf1skaCeraAf5Gj1QKZ1ejAn711d925OQOGQNvaotd4
         rjZWk2P3l4MwODynOxEwNvLS3nzzhqHkzY49W7p2D8+TnUJmZKQYyhvfTEO56csGOpcR
         zOfjdFA3fHBovzzbjD+9JmZPniH3U5eucbJUCDvomI3AudahbXzzkVbMMrU+La5Qxf80
         Rvwcy8SWmEou1UhbmkonlSzTtiXJXkfXmvyt9VVlxt+6l18Rjmi+3ui2+OyLtMx45oLq
         vPy8KFOxUXXYO2FcTTEp9R6HakeZ6Z9Nt8jlk8NxOocP/Vu7R98H6O/FnX96q9fiZRy3
         DP6A==
X-Gm-Message-State: AAQBX9c74N46jhIt65zZs2arG+tYdbr/WgTfRKP8BjCK6qg0JkOPBO3J
        Ly1/3oknkxNEy93hHssl6Jo=
X-Google-Smtp-Source: AKy350aAVpJgiBuQowINe7K2XwUMEspk5c7HruQFKHK8h6zPcSaAvxR/p4r/S6XEU+mKmXvjSgNJ6w==
X-Received: by 2002:a1c:4c02:0:b0:3f1:78a7:6bd2 with SMTP id z2-20020a1c4c02000000b003f178a76bd2mr5488015wmf.27.1681915109688;
        Wed, 19 Apr 2023 07:38:29 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id m14-20020a056000008e00b002c71b4d476asm15911066wrx.106.2023.04.19.07.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:38:28 -0700 (PDT)
Message-ID: <643ffce4.050a0220.73dcc.1bec@mx.google.com>
X-Google-Original-Message-ID: <ZD/84vlr8Pe7ntT2@Ansuel-xps.>
Date:   Wed, 19 Apr 2023 16:38:26 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>
Subject: Re: [net-next PATCH v7 13/16] ARM: dts: qcom: ipq8064-rb3011: Add
 Switch LED for each port
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
 <20230417151738.19426-14-ansuelsmth@gmail.com>
 <289b7604-d32d-49d9-8f06-87147d6fd473@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <289b7604-d32d-49d9-8f06-87147d6fd473@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 02:53:45PM +0200, Krzysztof Kozlowski wrote:
> On 17/04/2023 17:17, Christian Marangi wrote:
> > Add Switch LED for each port for MikroTik RB3011UiAS-RM.
> > 
> > MikroTik RB3011UiAS-RM is a 10 port device with 2 qca8337 switch chips
> > connected.
> > 
> > It was discovered that in the hardware design all 3 Switch LED trace of
> > the related port is connected to the same LED. This was discovered by
> > setting to 'always on' the related led in the switch regs and noticing
> > that all 3 LED for the specific port (for example for port 1) cause the
> > connected LED for port 1 to turn on. As an extra test we tried enabling
> > 2 different LED for the port resulting in the LED turned off only if
> > every led in the reg was off.
> > 
> > Aside from this funny and strange hardware implementation, the device
> > itself have one green LED for each port, resulting in 10 green LED one
> > for each of the 10 supported port.
> > 
> > Cc: Jonathan McDowell <noodles@earth.li>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 120 ++++++++++++++++++++++
> 
> Please do not send the DTS patches to the net-next, but to the Qualcomm
> SoC maintainers. The DTS must not be mixed with driver code.
> 

Hi,

sorry for the mess, it was asked to give an user of the LED feature for
qca8k so I was a bit confused on where to include it and at the end I
decided to put it in this series.

What was the correct way? 2 different series and reference the DT one in
the net-next? (or not targetting net-next at all?)



-- 
	Ansuel
