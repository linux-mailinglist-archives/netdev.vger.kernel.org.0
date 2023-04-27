Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1946F059F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243386AbjD0MSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243457AbjD0MSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:18:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DACBE4F;
        Thu, 27 Apr 2023 05:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r5QXg/9AtSVl/Tw840+NDh2cYcaAeKxEYGzgsmfbrkc=; b=UoFJsBgyLucFWLe80aMz/DU2vt
        /pv4krndrw7+YFRWF2++1GKJbtqjQ3Lt7D0/jX0omxxCvPkrvSBMd0IzvEbOeUYPdI2ch0kvcxlqx
        3By/Snba4aO5i52DPp5CeuyzaTloINFJrht40OuEO6zbuo2g6nlyg8srJqyHKFSK5uQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps0aB-00BLln-73; Thu, 27 Apr 2023 14:18:43 +0200
Date:   Thu, 27 Apr 2023 14:18:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] r8152: fix flow control issue of RTL8156A
Message-ID: <152dcf8d-16c5-4cbb-881f-9c7e85409ca7@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230427121057.29155-405-nic_swsd@realtek.com>
 <20230427121057.29155-406-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427121057.29155-406-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:10:55PM +0800, Hayes Wang wrote:
> The feature of flow control becomes abnormal, if the device sends a
> pause frame and the tx/rx is disabled before sending a release frame. It
> causes the lost of packets.
> 
> Set PLA_RX_FIFO_FULL and PLA_RX_FIFO_EMPTY to zeros before disabling the
> tx/rx. And, toggle FC_PATCH_TASK before enabling tx/rx to reset the flow
> control patch and timer. Then, the hardware could clear the state and
> the flow control becomes normal after enabling tx/rx.
> 
> Besides, remove inline for fc_pause_on_auto() and fc_pause_off_auto().
> 
> Fixes: 195aae321c82 ("r8152: support new chips")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
