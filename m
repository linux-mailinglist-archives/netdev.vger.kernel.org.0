Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B605F131A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiI3UFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiI3UFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:05:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73918DD369;
        Fri, 30 Sep 2022 13:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3wBAxhax4uWBF7eHB1eqflHZ4cetLSZp3Uc2jtSpOag=; b=x3x61AMxA1kRtzrCpZ2242ZDAG
        0WlkEYPLDNmJ5oVUPtsBT4y6Sls/ZFbxLwJtC0OM5XIL5EwVfzJQ77XxST6Be81BU7LxKvA45qVO/
        KhE+SotUt+7uAZjOqQ8jM+9hPTMKqzDjS3EF5y0Bw1ch9s4ZH1mG7GFkP6784wM7YGcc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oeMFo-000jtR-Kq; Fri, 30 Sep 2022 22:05:00 +0200
Date:   Fri, 30 Sep 2022 22:05:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: using page pool to manage RX buffers
Message-ID: <YzdL7EbnULEA75/s@lunn.ch>
References: <20220930193751.1249054-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930193751.1249054-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> -			       struct bufdesc *bdp, u32 length, bool swap)
> +static bool __maybe_unused
> +fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> +		   struct bufdesc *bdp, u32 length, bool swap)
>  {

Why add __maybe_unused? If its not used, remove it. We don't leave
dead functions in the code.

     Andrew
