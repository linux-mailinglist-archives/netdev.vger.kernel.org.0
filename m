Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A97C5A88FF
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiHaWbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiHaWbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:31:13 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502051F2E6;
        Wed, 31 Aug 2022 15:30:05 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id E54E22126;
        Thu,  1 Sep 2022 00:30:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661985003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5A2fJzkWuA9bifn4MudMipTvJqlngyg+cza0sDoxRl0=;
        b=1WhjYa1SzJ9k71JE6p5vX6/cBxrlqc3zVmEflXmNFqmEOewjxP7vYZ5kejmmfbdUuFffva
        G5MGC5GocP7DeNNm2jloqcbS3K8jEK7+APKukF/on/RZyvWTWlzQ+O2GbnISR6g5HgbBe2
        v/7Gw8TZ/BWs1cK1ugiVP11fu0GG3CYQEiRxSWXQTKD6dcUF2+etuwGRuPN4RQEku0pQi8
        lDK/gKjJ3rrFMpBgFFjiFOCqCIy8HjTEcfHgUX+McVPwmCBkD9mullNKk9yc+pzsVKNa5K
        xhoVWUhDcO/Tc+9roHAPCHg2y8YiwqAJLfdfLAbhY8wXtCijfOrq1muQmyISxw==
MIME-Version: 1.0
Date:   Thu, 01 Sep 2022 00:30:02 +0200
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible
 string
In-Reply-To: <20220831214809.GA282739-robh@kernel.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-9-michael@walle.cc>
 <20220831214809.GA282739-robh@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <60308ba420cdd072ea19e11e2e5e7d4b@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-31 23:48, schrieb Rob Herring:
> On Thu, Aug 25, 2022 at 11:44:17PM +0200, Michael Walle wrote:
>> The "user-otp" and "factory-otp" compatible string just depicts a
>> generic NVMEM device. But an actual device tree node might as well
>> contain a more specific compatible string. Make it possible to add
>> more specific binding elsewere and just match part of the compatibles
>> here.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> In hindsight it looks like we are mixing 2 different purposes of 'which
> instance is this' and 'what is this'. 'compatible' is supposed to be 
> the
> latter.
> 
> Maybe there's a better way to handle user/factory? There's a similar
> need with partitions for A/B or factory/update.

I'm not sure I understand what you mean. It has nothing to with
user and factory provisionings.

SPI flashes have a user programmable and a factory programmable
area, some have just one of them. Whereas with A/B you (as in the
user or the board manufacturer) defines an area within a memory device
to be either slot A or slot B. But here the flash dictates what's
factory and what's user storage. It's in the datasheet.

HTH
-michael
