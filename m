Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632426D327B
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 17:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjDAPzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 11:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjDAPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 11:55:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D252546D;
        Sat,  1 Apr 2023 08:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KFjf9PEaoJi14CUAATwY45BK0qqNZE+cgvT7EX51gUw=; b=UKWmWRSTJKdxjIME6/xKk7QkZG
        ZSePWqucj9TwogJAHYMYQ77bPtOHbSAvKdLXP9fVBz6be3pdidYWDgApPnO7ielCgxIY8yhP3MWdK
        908qsRM7Ncv+JwppwpcnkvGOPgf67yxshUb1zTkHK2BiZ6CuhH2M/c0F3jtOICxrbIM0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pidZn-00994v-Uj; Sat, 01 Apr 2023 17:55:35 +0200
Date:   Sat, 1 Apr 2023 17:55:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <horms@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: use be32 type to store be32
 values
Message-ID: <c7684349-535c-45a4-9a74-d47479a50020@lunn.ch>
References: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 08:43:44AM +0200, Simon Horman wrote:
> Perhaps there is a nicer way to handle this but the code
> calls for converting an array of host byte order 32bit values
> to big endian 32bit values: an ipv6 address to be pretty printed.

Hi Simon

Maybe make a generic helper? I could be used in other places, e.g:

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c#L6773

	Andrew
