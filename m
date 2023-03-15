Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB2E6BA59A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 04:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCOD25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 23:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjCOD2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 23:28:52 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099EEB479;
        Tue, 14 Mar 2023 20:28:49 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h17so2079537wrt.8;
        Tue, 14 Mar 2023 20:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678850927;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uH9GaHvYlPJjSoX0IYviP2OnmjHw1bfzeQs9XHSK3VM=;
        b=RINQimBKgzmPrCNEqdXPn0gDuSOc4JqLKfQrSSD4Hi/t0sRiZ6L2vvPSeT3nEIjqF0
         tbDX29vu3RlCUonOpxO6tpHLcjlTn29VGWQ7/0tJ7/DpTL9bTfZKZhsD6YVOCoGj0+Ru
         0MWoMk8ahU/8pgzCiKmvQxgtFu7pF2kw9SavE4NbJZzPoqT/NWBKKmxVRM4iwt02Du7f
         TmA6lui7YGsVhjhhGG/PzdeSfxNEO+deUDag4wXj0tw3aAiWSkDNwE1Y6tUPETTai7Sa
         xdDL+1KYDPHcQi6kh1djWEiPEsfQz9b/8/fbdkpWPKHr/DyOG/mlpN/VuHogNll72Wqm
         lEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678850927;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uH9GaHvYlPJjSoX0IYviP2OnmjHw1bfzeQs9XHSK3VM=;
        b=wYytWJ+mSOabF8V1IrQFd+j4aSRpNaeDYKA3FH4Pbi9HSgiaV1JuJJ7Lg4HJzRtRlq
         1LcWt7TuMG7JzygGhp3R1rg0HiE5kHaZcoLFBYTEpMCZG7l5La+062fAXSaW46S/tftK
         XcvG2ans4ilhNrjaVK/lizYvZcn9d5mdnxnHvHDRDkGZXhPY6nXUMVgWxW9WSJK+5EHz
         djGbyWvG5iS2QNBqaIANcdXB6QuqMohnUK7VxIySKgigWPUj0h1G+Ov293q5ookTl0Q1
         9eQfm3ps94bDAkuzcwhzUzYxYWYTHeHoU/XH1XVMpUcms2+yrJN3Krgrqf4/tSP8Fawo
         wVnA==
X-Gm-Message-State: AO0yUKWBWB7WvRe9BreMMa4hByDvPedtsii0iotVXQ8sdhYPRXB/au+n
        a781Ja0NjAEcz81xPQY+ves=
X-Google-Smtp-Source: AK7set8zVTAaU2IcCM2AMRczalXeWzQeAuVESTAFjkQ6ZVVK5LgYsCJx6WIZFrOP6tyWMBDmSikG8g==
X-Received: by 2002:a5d:65cc:0:b0:2c8:c667:1bb4 with SMTP id e12-20020a5d65cc000000b002c8c6671bb4mr809782wrw.48.1678850927214;
        Tue, 14 Mar 2023 20:28:47 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id w17-20020adfd4d1000000b002c70ce264bfsm3412850wrk.76.2023.03.14.20.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 20:28:46 -0700 (PDT)
Message-ID: <64113b6e.df0a0220.5405c.6bb4@mx.google.com>
X-Google-Original-Message-ID: <ZBE7bJmf1jLsq5cn@Ansuel-xps.>
Date:   Wed, 15 Mar 2023 04:28:44 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v3 09/14] dt-bindings: net: dsa: dsa-port:
 Document support for LEDs node
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230315005000.co4in33amy3t3xbx@skbuf>
 <afd1f052-6bb6-4388-9620-1adb02e6d607@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afd1f052-6bb6-4388-9620-1adb02e6d607@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:58:23AM +0100, Andrew Lunn wrote:
> On Wed, Mar 15, 2023 at 02:50:00AM +0200, Vladimir Oltean wrote:
> > On Tue, Mar 14, 2023 at 11:15:11AM +0100, Christian Marangi wrote:
> > > Document support for LEDs node in dsa port.
> > > Switch may support different LEDs that can be configured for different
> > > operation like blinking on traffic event or port link.
> > > 
> > > Also add some Documentation to describe the difference of these nodes
> > > compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
> > > regs and the possible intergated PHY doesn't have control on them.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > 
> > Of all schemas, why did you choose dsa-port.yaml? Why not either something
> > hardware specific (qca8k.yaml) or more generic (ethernet-controller.yaml)?
> 
> The binding should be generic. So qca8k.yaml is way to specific. The
> Marvell switch should re-use it at some point.
> 
> Looking at the hierarchy, ethernet-controller.yaml would work since
> dsa-port includes ethernet-switch-port, which includes
> ethernet-controller.
> 
> These are MAC LEDs, and there is no reason why a standalone MAC in a
> NIC could not implement such LEDs. So yes,
> ethernet-controller.yaml.
> 
> Is there actually anything above ethernet-controller.yaml? This is
> about a netdev really, so a wifi MAC, or even a CAN MAC could also use
> the binding....
>

Yes ideally when we manage to do all the things, ath10k would benefits
from this since it does have leds that blink on tx/rx traffic and are
specially controlled...

Don't think there is something above ethernet-controller tho...

-- 
	Ansuel
