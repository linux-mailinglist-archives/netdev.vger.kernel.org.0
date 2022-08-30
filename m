Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E2A5A66CD
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiH3PCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiH3PCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:02:06 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B6DB6D41;
        Tue, 30 Aug 2022 08:02:04 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A76331CBC;
        Tue, 30 Aug 2022 17:02:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661871722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1vcpi0+dohS3zcOPf9MT0OVkwJKzxxkawnTI2q960E=;
        b=NLD+FYiLhcyxBJltX0QvzzIxv4DVz/IYFKMxMWdUbH0IBXO5fwF9/JKkEJXPC5qS+mhHvb
        3tE7b4QYKQRgQu+eV24CG9OjIRq+A3vHI/REGCjk4f1Z21StOuHE6G/Yddu0r8KEUk2CST
        Delj68jyIU/V3ygPhYnVnw9u8lCP+ROjAIc++zx5VywIla2hmj+KQKpOi3oEsdfI3glrWe
        1Zc39XEYnDjkphKki5ep+u1XX18iKc18K0aX7C9XNnVlYinXPefW4gwajD0/r+dg8GlAAC
        69392pt1s9kpAbvWVfJb8MhOwMWMGS6FRy0WJtGx4iUSp2+Oqb9N5bEsc1WlUA==
MIME-Version: 1.0
Date:   Tue, 30 Aug 2022 17:02:02 +0200
From:   Michael Walle <michael@walle.cc>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
Subject: Re: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
In-Reply-To: <815f8e22-3a23-ebdb-7476-14682d0b3287@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-7-michael@walle.cc>
 <e2d91011-583e-a88d-94f9-beb194416326@linaro.org>
 <ae27e9d300a9c9eca4e9ec0c702b5e0a@walle.cc>
 <815f8e22-3a23-ebdb-7476-14682d0b3287@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c2e3a05339d54123de539fd124e874bb@walle.cc>
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

Am 2022-08-30 16:43, schrieb Srinivas Kandagatla:

>>>> diff --git a/drivers/nvmem/layouts/Makefile 
>>>> b/drivers/nvmem/layouts/Makefile
>>>> new file mode 100644
>>>> index 000000000000..6fdb3c60a4fa
>>>> --- /dev/null
>>>> +++ b/drivers/nvmem/layouts/Makefile
>>>> @@ -0,0 +1,4 @@
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +#
>>>> +# Makefile for nvmem layouts.
>>>> +#
>>>> diff --git a/include/linux/nvmem-provider.h 
>>>> b/include/linux/nvmem-provider.h
>>>> index e710404959e7..323685841e9f 100644
>>>> --- a/include/linux/nvmem-provider.h
>>>> +++ b/include/linux/nvmem-provider.h
>>>> @@ -127,6 +127,28 @@ struct nvmem_cell_table {
>>>>       struct list_head    node;
>>>>   };
>>>>   +/**
>>>> + * struct nvmem_layout - NVMEM layout definitions
>>>> + *
>>>> + * @name:        Layout name.
>>>> + * @of_match_table:    Open firmware match table.
>>>> + * @add_cells:        Will be called if a nvmem device is found 
>>>> which
>>>> + *            has this layout. The function will add layout
>>>> + *            specific cells with nvmem_add_one_cell().
>>>> + * @node:        List node.
>>>> + *
>>>> + * A nvmem device can hold a well defined structure which can just 
>>>> be
>>>> + * evaluated during runtime. For example a TLV list, or a list of 
>>>> "name=val"
>>>> + * pairs. A nvmem layout can parse the nvmem device and add 
>>>> appropriate
>>>> + * cells.
>>>> + */
>>>> +struct nvmem_layout {
>>>> +    const char *name;
>>>> +    const struct of_device_id *of_match_table;
>>> 
>>> looking at this, I think its doable to convert the existing
>>> cell_post_process callback to layouts by adding a layout specific
>>> callback here.
>> 
>> can you elaborate on that?
> 
> If we relax add_cells + add nvmem_unregister_layout() and update
> struct nvmem_layout to include post_process callback like
> 
> struct nvmem_layout {
> 	const char *name;
> 	const struct of_device_id *of_match_table;
> 	int (*add_cells)(struct nvmem_device *nvmem, struct nvmem_layout 
> *layout);
> 	struct list_head node;
> 	/* default callback for every cell */
> 	nvmem_cell_post_process_t post_process;
> };
> 
> then we can move imx-ocotp to this layout style without add_cell
> callback, and finally get rid of cell_process_callback from both
> nvmem_config and nvmem_device.
> 
> If layout specific post_process callback is available and cell does
> not have a callback set then we can can be either updated cell
> post_process callback with this one or invoke layout specific callback
> directly.
> 
> does that make sense?

Yes I get what you mean. BUT I'm not so sure; it mixes different
things together. Layouts will add cells, analogue to
nvmem_add_cells_from_of() or nvmem_add_cells_from_table(). With
the hook above, the layout mechanism is abused to add post
processing to cells added by other means.

What is then the difference to the driver having that "global"
post process hook?

The correct place to add the per-cell hook in this case would be
nvmem_add_cells_from_of().

-michael
