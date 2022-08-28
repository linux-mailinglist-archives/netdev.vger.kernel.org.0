Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E470E5A3E0F
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiH1OdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiH1OdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:33:08 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4A632DAC;
        Sun, 28 Aug 2022 07:33:05 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 8858222D1;
        Sun, 28 Aug 2022 16:33:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661697183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bwtC9ZIuYAB2A3TteH5zPFKqQJ2DrJO4wxsda0FFBrE=;
        b=KznYoTy9iue5vF7/hSESEctDdioSRs8n4n2hqBIDkzR7gvg4gOF0YLYEo9M5XjBBVFBc/X
        bU11LaqPWiz4z+BoPkufiLDYa+HiuGL2Sq1Fc3j8sG/eGpvcyWAiEKM8oApVhSkmH4mO8f
        8XcTEiX0GMUblPaZ8SNao8Y9aPFl51d8qW7ggOFodL1Uzu1WSo3Yag7EjaYaSZhr93Qsst
        5DBd99KMGwJECymKB9uiNax2rIiQ7zZI8UkzAtyWEZFhZ5hir3Fna0Jtg8oZvrZWM5i16h
        OJE9ct0u+HOyIY5TVijhw2FvVap8jhHovp/qpW8PcVtpFIKSaqkdsDFWtps3bw==
MIME-Version: 1.0
Date:   Sun, 28 Aug 2022 16:33:03 +0200
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
Subject: Re: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
In-Reply-To: <b46d0db0-bd82-9ea3-281d-cc3ee3e9b002@milecki.pl>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-7-michael@walle.cc>
 <b46d0db0-bd82-9ea3-281d-cc3ee3e9b002@milecki.pl>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e62a50dfd968168015dd3e4fab896056@walle.cc>
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

Am 2022-08-28 16:06, schrieb Rafał Miłecki:
> On 25.08.2022 23:44, Michael Walle wrote:
>> For now, the content can be
>> described by a device tree or a board file. But this only works if the
>> offsets and lengths are static and don't change.
> 
> Not really true (see Broadcom's NVRAM and U-Boot's env data).

All except those two drivers don't add cells on their own. And for
these it is not possible to add non static cells, except in board
code maybe. This series make it possible to add this runtime parsing
to any NVMEM device.

-michael
