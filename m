Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE4682090
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjAaAU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjAaAUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DDB1BDB;
        Mon, 30 Jan 2023 16:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B747EB818C7;
        Tue, 31 Jan 2023 00:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD92C433D2;
        Tue, 31 Jan 2023 00:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675124442;
        bh=f0WFrBoNisBu4HeLhCYksUS7yduuDKSx/ZePuzgqPVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uawK88ZnmfjpDQge6p3uXopoAXViRqFHNl+3GssRAXWdwJQEvCy5ioPRRfs12CVV1
         zLquWpzub6UliGLnQ9uGTOk+cQ6BKdYf/rXtY7faYroYXD5hWs9uFTglMW3WxMmHnB
         kMY4sdL9lv6rBqdE62RUZuRMAhYnyEDUKi61rUxn4W04dz+vzS5FxnOvMG8AN8R8og
         mlyYwYk4IS7QZJS+2i2SDnLyJDw6NgVENnW+bFmTIS+aKUkUmbfyYenLnNrYxVWMWx
         JPhnzHNQxLAmTaaCCbk1Yh+NSf8PZNMb4bKJ9uUSjpqMb73WNkrdzoadviRbuzqJgB
         hNpHUhwACUhLw==
Date:   Mon, 30 Jan 2023 16:20:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jonas Suhr Christensen <jsc@umbraculum.org>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        esben@geanix.com
Subject: Re: [PATCH 1/2] net: ll_temac: fix DMA resources leak
Message-ID: <20230130162041.556b34b3@kernel.org>
In-Reply-To: <810730f9-5097-4fb1-bea0-13e3e7084f9c@wanadoo.fr>
References: <20230126101607.88407-1-jsc@umbraculum.org>
        <810730f9-5097-4fb1-bea0-13e3e7084f9c@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 22:56:04 +0100 Christophe JAILLET wrote:
> > -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> > +
> > +		bd = &lp->rx_bd_v[1];  
> 
> Hi,
> just a naive question from s.o. who knows nothing of this code:
> 
> Is really [1] ([one]) expected here?
> [i] would look more "standard" in a 'for' loop.

Wow, good eye. 
