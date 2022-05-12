Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26824525151
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355646AbiELPc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355969AbiELPcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:32:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286F2222C14;
        Thu, 12 May 2022 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mP150j04E/8jQ8B5g/+n8UgWwpaCq5hceVZHtLcU+78=; b=W91vqJCSDahiNvJzDzMjIzXcgX
        3OrdskRDyBToQfzQ9VxpWRoZZZSM3TkqG9OJgLXdU9Ay2q/5VWZZ4+6GozoMSSRxgjz9zp6BMRpQF
        OeXORs7whRYGslWtesZUceCqjI7fs3yHddlPh2wmt+SXfWFkJWS9yQ+gzoDV9ayrpAEc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npAnK-002TL3-6U; Thu, 12 May 2022 17:32:02 +0200
Date:   Thu, 12 May 2022 17:32:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <Yn0ockLQ+5x+gCfl@lunn.ch>
References: <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
 <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
 <20220511093245.3266lqdze2b4odh5@skbuf>
 <YnvJFmX+BRscJOtm@lunn.ch>
 <0ef1e0c2-1623-070d-fbf5-e7f09fc199ca@nbd.name>
 <Ynz/7Wh6vDjR7ljs@lunn.ch>
 <987a1cd5-6f35-d3ac-1d42-5346be7ecb1a@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987a1cd5-6f35-d3ac-1d42-5346be7ecb1a@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess if you guys don't think the issue is worth the price of a very small
> performance hit from padding the packets, I will just have to keep this as
> an out-of-tree patch.

I'm thinking it is worth fixing, but i also wonder if your receiver
has a bug. And if it does have a bug, it will probably come back to
bite you sometime in the future.

     Andrew
