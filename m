Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD78603184
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJRRWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 13:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJRRWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 13:22:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487D7B284;
        Tue, 18 Oct 2022 10:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+lx9x1aBs73wQJ1eXRkFz6NzXliI7mOsNGmfOLIinDE=; b=hp7wQfz81qaCucS5LKO4ChU+yV
        31u3gwLt06Z403XWPBtsD0es8r1R9skImqXL/mHTHhJMUMNeoqavynw89CWuN9k+O8vIveRSGYsmW
        SPKtrONeJ75hDHXjY5XJtmQQZxBlmXe1NOEb+mA4YbJqbxy5aeuFHibc36sQLbthJeDM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1okqHx-002Mwa-1T; Tue, 18 Oct 2022 19:22:01 +0200
Date:   Tue, 18 Oct 2022 19:22:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Message-ID: <Y07guYuGySM6F/us@lunn.ch>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017162807.1692691-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
> For whatever reason, the address of the MAC is exposed to userspace in
> several places. We need to use the physical address for this purpose to
> avoid leaking information about the kernel's memory layout, and to keep
> backwards compatibility.

How does this keep backwards compatibility? Whatever is in user space
using this virtual address expects a virtual address. If it now gets a
physical address it will probably do the wrong thing. Unless there is
a one to one mapping, and you are exposing virtual addresses anyway.

If you are going to break backwards compatibility Maybe it would be
better to return 0xdeadbeef? Or 0?

       Andrew
