Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240F15A3E18
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiH1OhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiH1OhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:37:02 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C72314B;
        Sun, 28 Aug 2022 07:36:59 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0E1D59B1;
        Sun, 28 Aug 2022 16:36:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661697418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PX7FBllk+cj5XDth3fcwSHpmqNhOA0Ff5hNRkbJfwhM=;
        b=HRM3E+Ka7cQ3cBsabC1jV/2VqjHV5p2dTJcBx80ZUckS1bEWgbWlS3eTCgcGp5O3M/t/3v
        vi9oOY77RFWMaP5LQ2SeQKvdOTpkumQZzJd6rQ5UgOoQ4vjA5OT+JHnSPzgGynHkoazdkP
        lmwpVmIrUUdq7Qr4x9nGygY92tr9eFGeWRkFrPNHEFFTQDd/sorFow7Dc0DRofYQQ0fvTB
        nTGqCDTNNp/NWRvuyCBRVWEFVxeUfyCnE/q8yiZ2UFdBDT6U8N9atMXyh4GfNn1NGKnG2i
        yN9UD19aB5Zuqhh9OSvUqlzuEqdhDaGyOnPQngvUrFLTY+kfxm5QETSDIEtG/w==
MIME-Version: 1.0
Date:   Sun, 28 Aug 2022 16:36:57 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [RFC PATCH v1 13/14] nvmem: layouts: u-boot-env: add device node
In-Reply-To: <ca7d8fe6-023f-1e2d-da34-c23d0cdc3b03@milecki.pl>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-14-michael@walle.cc>
 <ca7d8fe6-023f-1e2d-da34-c23d0cdc3b03@milecki.pl>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a40fabd8570067426a544bf0b6ece563@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-28 15:55, schrieb Rafał Miłecki:
> On 25.08.2022 23:44, Michael Walle wrote:
>> Register the device node so we can actually make use of the cells from
>> within the device tree.
>> 
>> This obviously only works if the environment variable name can be 
>> mapped
>> to the device node, which isn't always the case. Think of "_" vs "-".
>> But for simple things like ethaddr, this will work.
> 
> We probably shouldn't support undocumented syntax (bindings).

If we only support a predefined list of variables, we can make them
device tree compatible anyway. E.g. we could have a mapping
"serial-number" <-> "serial#"

-michael

> I've identical local patch that waits for
> [PATCH] dt-bindings: nvmem: u-boot,env: add basic NVMEM cells
> https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20220703084843.21922-1-zajec5@gmail.com/
> to be accepted.
