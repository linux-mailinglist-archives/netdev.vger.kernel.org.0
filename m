Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6F60F05E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiJ0Gf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiJ0GfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:35:25 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182F995ADD;
        Wed, 26 Oct 2022 23:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1666852522;
  x=1698388522;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=b5A2GFSPAKlPXSyQ/35gbyiEt3fO3+/e4osgD5ldbUQ=;
  b=PHJNiL8E7KZGVPds5HjkYQsXAEH9vPkRjHKpnEqJC0AW5lwhuZKc4cQH
   +/dKYs9c62+NUilPjaJvnHdaP2Jpzy3DQlEgf0fqo1CGerAnzVOBhG3sa
   oqEVXfIOg06ixlzUwa70JBNIdHPF/cHHhRzVUW5S1zZB16YDAhgIHuCNn
   Jcejlq1+ymZmo3ye0hszYC2moFLU2HVQ6Mi7dWPz6yH60eYcD6PpR+SJs
   H9NnJ8rVHKfHAgYhBLwot77yurTjFPIGDdAUpKVsGXJ6uRNA+QeHicoRV
   pipKXu68PhcKP7cNC50Dudg/V45RF37YxE5lKUFauPi2xpemTxMunvIPP
   g==;
Message-ID: <128467d6-8249-9f25-21a7-777fff9854d9@axis.com>
Date:   Thu, 27 Oct 2022 08:35:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
From:   Camel Guo <camelg@axis.com>
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
To:     Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Camel Guo <Camel.Guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
 <d942c724-4520-4a7b-8c36-704032c68a36@linaro.org> <Y1f5HU9crkPGX3SB@lunn.ch>
Content-Language: en-US
In-Reply-To: <Y1f5HU9crkPGX3SB@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: se-mail06w.axis.com (10.20.40.12) To se-mail03w.axis.com
 (10.20.40.9)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/22 16:56, Andrew Lunn wrote:
>> > +EXPORT_SYMBOL(gsw1xx_shutdown);
>> 
>> 1. EXPORT_SYMBOL_GPL
>> 2. Why do you do it in the first place? It's one driver, no need for
>> building two modules. Same applies to other places.
> 
> At some point, there is likely to be SPI and UART support. The
> communication with the chip and the core driver will then be in
> separate modules. But i agree this is not needed at the moment when it
> is all linked into one.

Do you suggest that currently we put the content of gsw1xx_core.c and 
gsw1xx_mdio.c into one file and split them later at the time when 
another management mode (e,g: spi) is added?

Actually I kinda hope this piece of code (gsw1xx_core.c) can be reused 
in lantiq_gswip in short future.

I tried to use the logic in lantiq_gswip directly on the gsw145 chip. 
Unfortunately it did not work. It seems that the GSWIP part changes a lot.

> 
>     Andrew

