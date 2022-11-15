Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52FD62A006
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiKORM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKORM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:12:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD59F175AB;
        Tue, 15 Nov 2022 09:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HT0pmrQ9nKiRSy0684bpSN9Np5hhj3VvrPzQFQl+VOM=; b=UBG50IXmzx/yfY6fDXl2dUFSl5
        a+B7ALVpVATw6u7MxryqOtW6NnoxJ4DVWXsVQBFFcQ9tUtJKTu+UIsUOKW96He4orcVO6lVZ0w/d1
        O4KZgbUtHI600TXwMr6GhedIGROIL4gwuEHNqTrDK9jw/pmuG7mgMaw2mkhNjm5tKxrI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouzTe-002TpO-6a; Tue, 15 Nov 2022 18:12:02 +0100
Date:   Tue, 15 Nov 2022 18:12:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats definition
Message-ID: <Y3PIYg+VsuBxq5cW@lunn.ch>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
 <20221115155744.193789-2-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115155744.193789-2-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 09:57:43AM -0600, Shenwei Wang wrote:
> The definition of the 'struct page_pool_stats' is required even when
> the CONFIG_PAGE_POOL_STATS is not defined. Otherwise, it is required
> the drivers to handle the case of CONFIG_PAGE_POOL_STATS undefined.

I agree the API is broken, but i think there is a better fix.

There should be a stub of page_pool_get_stats() for when
CONFIG_PAGE_POOL_STATS is disabled.

Nothing actually dereferences struct page_pool_stats when you have
this stub. So it might be enough to simply have

struct page_pool_stats{
};

       Andrew
