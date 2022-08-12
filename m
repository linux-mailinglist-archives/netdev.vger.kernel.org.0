Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0772D59140F
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiHLQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiHLQi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:38:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C59B0B12
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kLtLgjkarr2EZv4fy2uYeJIcbBcu2ZKxhZYkF4IDlw4=; b=hYKBOZfsYYj0nsl5v0AMVoLD6S
        xOsonl48318uwHaq1xys1CGdcvNH7KTi9gl/s7zYDs1XaSbwz4n8ZqYeUS3lx+EmsHtdS2uB7H3OC
        hYb+4Ec3+B/XPfMNNTMMo8j/XSblvgHjJ+oopGMjxbpKzw7f/mbagDSrKtHufpQ6Djs8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oMXgJ-00D99r-50; Fri, 12 Aug 2022 18:38:43 +0200
Date:   Fri, 12 Aug 2022 18:38:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guobin Huang <huangguobin4@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: moxa: inherit DMA masks to make dma_map_single()
 work
Message-ID: <YvaCE0lqfOi+tE5X@lunn.ch>
References: <20220812154820.2225457-1-saproj@gmail.com>
 <YvZ8NwzGV/9QDInR@lunn.ch>
 <CABikg9wm=8rbBFP0vaVHpGBJfXOi4k0bvwK7F+agMXEPfFn2RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wm=8rbBFP0vaVHpGBJfXOi4k0bvwK7F+agMXEPfFn2RQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 07:35:43PM +0300, Sergei Antonov wrote:
> On Fri, 12 Aug 2022 at 19:13, Andrew Lunn <andrew@lunn.ch> wrote:
> > > +     /* Inherit the DMA masks from the platform device */
> > > +     ndev->dev.dma_mask = p_dev->dma_mask;
> > > +     ndev->dev.coherent_dma_mask = p_dev->coherent_dma_mask;
> >
> > There is only one other ethernet driver which does this. What you see
> > much more often is:
> >
> > alacritech/slicoss.c:   paddr = dma_map_single(&sdev->pdev->dev, skb->data, maplen,
> > neterion/s2io.c:                                dma_map_single(&sp->pdev->dev, ba->ba_1,
> > dlink/dl2k.c:                       cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
> > micrel/ksz884x.c:               dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,
> 
> Also works. Do you recommend to create a v2 of the patch?

Yes please. It makes things easier to maintain if every driver does
the same thing.

    Andrew
