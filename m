Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A9624DCF
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiKJWvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiKJWvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:51:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4294351C3F;
        Thu, 10 Nov 2022 14:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D5Vr6fIp6/HlluKXLw5TEN16Jml8Tm1cOoODbF1AYq4=; b=KH27mkB4rujg4Bur/91fXq53dt
        RgMew+8vGJWo/4WYUXuCPsPGpq9Mw7Z34824Cs4c6xYduceXrnooKKuyY9r5l1iXTRE28voap8CMP
        rFze6Tr7GL2abpmdseQaFJvn9QZtWVsn3qaRrV2OcMXSZQGHD4roboe5Q5ZlDQ0a7cfA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otGO8-0024eZ-QD; Thu, 10 Nov 2022 23:51:12 +0100
Date:   Thu, 10 Nov 2022 23:51:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Message-ID: <Y22AYAqqY+U1IlNT@lunn.ch>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
 <20221110111747.1176760-1-alexandr.lobakin@intel.com>
 <Y20DT2XTTIlU/wbx@lunn.ch>
 <20221110162148.3533816-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110162148.3533816-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 05:21:48PM +0100, Alexander Lobakin wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Thu, 10 Nov 2022 14:57:35 +0100
> 
> > > Nice stuff! I hear time to time that XDP is for 10G+ NICs only, but
> > > I'm not a fan of such, and this series proves once again XDP fits
> > > any hardware ^.^
> > 
> > The Freescale FEC recently gained XDP support. Many variants of it are
> > Fast Ethernet only.
> > 
> > What i found most interesting about that patchset was that the use of
> > the page_ppol API made the driver significantly faster for the general
> > case as well as XDP.
> 
> The driver didn't have any page recycling or page splitting logics,
> while Page Pool recycles even pages from skbs if
> skb_mark_for_recycle() is used, which is the case here. So it
> significantly reduced the number of new page allocations for Rx, if
> there still are any at all.

When reviewing new drivers we should be pushing them towards using the
page pool API. It seems to do better than the average role your own
implementation.

	Andrew
