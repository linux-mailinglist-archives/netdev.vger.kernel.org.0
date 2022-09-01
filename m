Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8818F5AA079
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiIATyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIATyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:54:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623216A48E;
        Thu,  1 Sep 2022 12:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00D8FB82934;
        Thu,  1 Sep 2022 19:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AE0C433D6;
        Thu,  1 Sep 2022 19:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662062071;
        bh=YH1Y50y+aIWGJPESEAGpE11vQpdK/FiX3f4PxACu/lI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e190hmZgGNV2kzXNTjhOh2R6yto1hDszS2MYqhvM6ISoM0OPu9sbZ/iuGKKqgyNya
         MQcWNnE74qWqj5l3/Pi2imRO4m7CZwKvlxpXfhITNrBKwLhMW7JWqnU/188cyR8NHY
         /JM/oj6AKmbanv/4zUjhtU3ArZoeyjN8ddZ1T7rQrWq+83wlHMnD1FCQT+IDssDR7N
         vGyp3L0v2aKmeeiu1iV8lKCw3VMcKLceBJYxNU5Sh5+kmhkcM7tIhDelv6TlOGRJSz
         b9E1wcKKQbl1OJbrMcEUQxxxlf47tNK/0CziKvOeLe1DCfFJ4PvlqxGtVJoZ7kL6j1
         Gx2rxo97L+EOg==
Date:   Thu, 1 Sep 2022 12:54:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 01/14] net: add helper eth_addr_add()
Message-ID: <20220901125430.5dd9e586@kernel.org>
In-Reply-To: <1682967feab905d06402d0f8402799a8@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
        <20220825214423.903672-2-michael@walle.cc>
        <1682967feab905d06402d0f8402799a8@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 01 Sep 2022 18:26:39 +0200 Michael Walle wrote:
> Am 2022-08-25 23:44, schrieb Michael Walle:
> > Add a helper to add an offset to a ethernet address. This comes in 
> > handy
> > if you have a base ethernet address for multiple interfaces.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>  
> 
> Would it be possible to get an Ack for this patch, so I don't have
> to repost this large (and still growing) series to netdev every time?
> 
> I guess it would be ok to have this go through another tree?

Andrew's ack is strong enough, but in case there's any doubt:

Acked-by: Jakub Kicinski <kuba@kernel.org>
