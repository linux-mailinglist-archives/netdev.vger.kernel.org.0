Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5565795D
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiL1PAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 10:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiL1PAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 10:00:10 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71912ADA;
        Wed, 28 Dec 2022 07:00:04 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 396A61691;
        Wed, 28 Dec 2022 16:00:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672239601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7X5I37Wqlz1lzMJ3mdpNrFggiiHaWpWuH+NMxL853Q=;
        b=QTJFGZr4N5l37GryGQO0dE0UZSmqDUwyMUsGmGZ868uS8fDZMw7OB7oYvdEEHTH77X/TV8
        uX4OMJO6L3wTTApqmFw33hUf5FCJZXw7uKYAk811opDw5KtTd0Ry6Cbg9KeNx/dxx0Nxoy
        quzawcv+3mkMwUUWXB1eMSskfAvDtyJZYPGfBpRdWSyvZLDJukrT4cGmmp5Lk/4C5JMufB
        Fjc3d7W3K0BitaC1/Wn9Bfe8YwbKbuEBcICoZWfnL0Km8+6YPWi3bx4t+YOM8t0MZaCetM
        OuH4kweutrU12UqnhopbmHUDEw/BsnlMGsmHCswfnBG1Cx3BkyUBWCseugna4w==
MIME-Version: 1.0
Date:   Wed, 28 Dec 2022 16:00:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <20221205212924.GA2638223-robh@kernel.org>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <f70deb0226581bf4f385a6d55ada3da1@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +
>> +      Affected PHYs (as far as known) are GPY215B and GPY215C.
>> +    type: boolean
>> +
>> +dependencies:
>> +  maxlinear,use-broken-interrupts: [ interrupts ]

Btw. I'd presume that the tools will also allow interrupts-extended, but 
that
doesn't seem to be the case. Do I need some kind of anyOf here?

>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    ethernet {
>> +        #address-cells = <1>;
>> +        #size-cells = <0>;
>> +
>> +        ethernet-phy@0 {
>> +            reg = <0>;
>> +            interrupts-extended = <&intc 0>;
>> +            maxlinear,use-broken-interrupts;
> 
> This is never actually checked by be schema because there is nothing to
> match on. If you want custom properties, then you need a compatible.

I can add an unwanted compatible here, or skip the example altogether. 
But
what puzzles me is that this schema pulls in the ethernet-phy.yaml. The 
latter
then has a custom select statement on the $nodename and even a comment:

# The dt-schema tools will generate a select statement first by using
# the compatible, and second by using the node name if any. In our
# case, the node name is the one we want to match on, while the
# compatible is optional.

Why doesn't that work?

-michael
