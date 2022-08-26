Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D2D5A22BF
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343572AbiHZIQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343595AbiHZIQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:16:15 -0400
X-Greylist: delayed 37897 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Aug 2022 01:16:14 PDT
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCFDD11F0;
        Fri, 26 Aug 2022 01:16:13 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 1844F402B;
        Fri, 26 Aug 2022 10:16:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661501772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYNkW/xHpAgk1nrcO4FJOnWLgD0dwYS942MxgxMADVg=;
        b=ibgQnPuJQxdddEiyOpCPcp4EyUM2+ItJGhAR5Few5nDl3ZN3BqFPu5zY/DNhwiMT/FKHsj
        5HvGF9JPOF75j+aWyLNd0FPKSCtC3yzpow9736CofUZ8/1g5LKPyWn6zS3yBKb3DsyK7PM
        IrG9Z5U/ksvzbOcCwz+KC8vqqaWwglw0x+1Jpcs8M8v6i9epMKl4Cud8Od+JndP96zt94F
        ojltn7kqvYNEzVkWfSHYehDnrv3ZTqEaQqR0u/WKTONGdY02CL1+qgvyj/bDyLWs4JLblH
        JZxS6oBkpsFwXmhkLFor/k6QCq4nPKOKOyh38fF0QNJNt7AyqzEY5q+jVMA+IA==
MIME-Version: 1.0
Date:   Fri, 26 Aug 2022 10:16:11 +0200
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
In-Reply-To: <20220825214423.903672-7-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-7-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <51cbe913705a6d4484bca640f591ecec@walle.cc>
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

Am 2022-08-25 23:44, schrieb Michael Walle:

> +struct nvmem_layout {
> +	const char *name;
> +	const struct of_device_id *of_match_table;
> +	int (*add_cells)(struct nvmem_device *nvmem, struct nvmem_layout 
> *layout);

This must be:
int (*add_cells)(struct device *dev, struct nvmem_device *nvmem, struct 
nvmem_layout *layout);

> +	struct list_head node;
> +};
> +
