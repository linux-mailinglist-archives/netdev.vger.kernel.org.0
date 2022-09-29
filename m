Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E0B5EEB03
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiI2Bel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiI2BeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:34:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F3C11D618;
        Wed, 28 Sep 2022 18:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WgYp4kgX3yzN0Gagvg7OxRHJp7EnJoIu8HNLaefuSRI=; b=prISs92iTwutWRn1Fm3DmUw5Fu
        2U1o9LPTgITB8C9gSMMzmcb6DqZMsRADRVEJj4aFKKRt0R0FzPKI/zcCb+2NGvNLIt2Qx12R0YvsM
        2JRT1Oz+2pY/9iqN5VCfU5Qwg35TmA7I1TWmQUsBM25IdKKw2LAC0dkRxlFkQFQ3R0xU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odiR0-000ZNQ-DM; Thu, 29 Sep 2022 03:33:54 +0200
Date:   Thu, 29 Sep 2022 03:33:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: add initial XDP support
Message-ID: <YzT2An2J5afN1w3L@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928152509.141490-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:25:09AM -0500, Shenwei Wang wrote:
> This patch adds the initial XDP support to Freescale driver. It supports
> XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
> support for XDP_TX and Zero Copy features.
> 
> This patch also optimizes the RX buffers by using the page pool, which
> uses one frame per page for easy management. In the future, it can be
> further improved to use two frames per page.

Please could you split this patch up. It is rather large and hard to
review. I think you can first add support for the page pool, and then
add XDP support, for example. 

I would be interesting to see how the page pool helps performance for
normal traffic, since that is what most people use it for. And for a
range of devices, since we need to make sure it does not cause any
regressions for older devices.

	    Andrew
