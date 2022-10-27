Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC060FCB9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiJ0QMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiJ0QMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:12:52 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B10A18C96E;
        Thu, 27 Oct 2022 09:12:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a13so3683662edj.0;
        Thu, 27 Oct 2022 09:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VUhEj/UUNM1UKeMvsbJCOPRsOzh5/QngbLXbe1y106U=;
        b=nEExxYLrFwaTwYT7xanpb9uKs9QDlkSVvvIAd/MYhrAJ4eyK+ITqU79eM/8EeC7qH4
         1mNHUY2iFtAJWkIHbAS9kqw3bdJ6tun+0+Yqx6K78QNgfkCphESEYQBEwqdp4HSw0++O
         S0GwsFaQN7ftJfF9eY+xl3ugpKx2X/sZAZozAmWe/xf3rJbgR6z0a6Q3mNbVaH/RqtgQ
         7SDHx7lk1Af7w9/80Ei4r89OMxg797lREonpsbXZNYe2B5uAhhBA5TRi9QL7TFwXILC8
         Xj8eAcYdZ4SJiT5NhQzk/e/CDb/97vQAk7YxfmfDl7NW7L6co9FyvDFP1yatlguIajNT
         xgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUhEj/UUNM1UKeMvsbJCOPRsOzh5/QngbLXbe1y106U=;
        b=CRscSMUu/V6ThQ2aKRe6+99Rjf6dxvU8++CZ0hzODyUYOH6+nbhl5dHvyK26hzecMo
         dcV840kctQ74XojD48SnCZNasTNJAyT8ukZy/kNbXXqE50PRVPNhNAd0uNbFtbUYxoi3
         x43JUHxVO0u04n3RKTq9LQ8QQ3w1HTXAbBAZtTyTn1h2GoksRcRf7LAqVTdfAQC4mAk9
         HVlm6j6eymqr/MT5iZln6IZJ6C8WPvEmgI8aUI7LbIAiX5fdwisGyrvMmZWhLtgIt1/i
         mpvq5ZpiCCefTzm1GmCR6xX774aagTJ29hUP8q2/h0fPcuoREP2hDGFXZ8/QNoVgn+ye
         oz/g==
X-Gm-Message-State: ACrzQf3/Ho9QVOlk7+hw3EggjOvWq3kPo2hgYTTunVMl93iHCcFOzcSo
        N+uEb9uaFztfTD9Ps7eqiQw=
X-Google-Smtp-Source: AMsMyM6QImdx4km3nyj8eQrw6nWxbMqLO1m7sA1giDlyRHWccE36WPQ30jLap15DQJK2r24u22EBug==
X-Received: by 2002:a05:6402:1348:b0:461:c056:bf65 with SMTP id y8-20020a056402134800b00461c056bf65mr20863385edw.414.1666887169974;
        Thu, 27 Oct 2022 09:12:49 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id by26-20020a0564021b1a00b004616b006871sm1199336edb.82.2022.10.27.09.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 09:12:49 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:12:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Camel Guo <camelg@axis.com>, Camel Guo <Camel.Guo@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Message-ID: <20221027161247.zlzlp2skydk362cp@skbuf>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
 <d0179725-0730-5826-caa4-228469d3bad4@axis.com>
 <a7f75d47-30e7-d076-a9fd-baa57688bbf7@linaro.org>
 <20221027135719.pt7rz6dnjvcuqcxv@skbuf>
 <b2844341-d334-27e6-bceb-94914e42131c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2844341-d334-27e6-bceb-94914e42131c@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 12:08:06PM -0400, Krzysztof Kozlowski wrote:
> On 27/10/2022 09:57, Vladimir Oltean wrote:
> > Hi Camel,
> > 
> > On Thu, Oct 27, 2022 at 08:46:27AM -0400, Krzysztof Kozlowski wrote:
> >>>  >> +      - enum:
> >>>  >> +          - mxl,gsw145-mdio
> >>>  >
> >>>  > Why "mdio" suffix?
> >>>
> >>> Inspired by others dsa chips.
> >>> lan9303.txt:  - "smsc,lan9303-mdio" for mdio managed mode
> >>> lantiq-gswip.txt:- compatible   : "lantiq,xrx200-mdio" for the MDIO bus
> >>> inside the GSWIP
> >>> nxp,sja1105.yaml:                  - nxp,sja1110-base-t1-mdio
> >>
> >> As I replied to Andrew, this is discouraged.
> > 
> > Let's compare apples to apples, shall we?
> > "nxp,sja1110-base-t1-mdio" is the 100Base-T1 MDIO controller of the
> > NXP SJA1110 switch, hence the name. It is not a SJA1110 switch connected
> > over MDIO.
> 
> Thanks for clarifying. Then this could be fine. Let me then explain what
> is discouraged:
> 1. Adding bus suffixes to the compatible, so for example foo,bar LED
> controller is on I2C bus, so you call it "foo,bar-i2c".
> 
> 2. Adding device types to the compatible, if this is the only
> function/variant of the device, so for example calling foo,bar LED
> controller "foo,bar-led". This makes sense in case of multi functional
> devices (PMICs, SoCs), but not standalone ones.
> 
> So what do we have here? Is it one of the cases above?

We are in agreement about SJA1110 (it's in case 2), this is what I said
about Camel's comparison not being apples to apples. "mxl,gsw145-mdio"
is in case 1, and I've also been recommending people to not add such
suffixes to compatible strings (also see the discussion with Colin
Foster about "mscc,vsc7512-switch" vs "mscc,vsc7512-ext-switch" to
denote an "external" switch which is otherwise the exact same hw but on
a different bus).
