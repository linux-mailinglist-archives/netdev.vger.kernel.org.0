Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E36D62B9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbjDDNX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbjDDNXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:23:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8192010DF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hZu+WFcUgP+xiXIXeN6+BMqHUBLizcpt8l0/i1Zxu1k=; b=D9obW1JJoNxUfcDdfMNBvohSR3
        EuJwlEa6aLK/57wH/qNpAiZzZDKmm7HN/FVFEgUdFLkkIZFXFgq23E1xMxO7BXbmKUbTqNFi3n5Xf
        PpikIAR6BiBPddk7o8r4bynuiyuurddGoe0RtwyIs2WTDPJRywymrp5LpqkSwGkBsOgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjgdX-009PCI-I9; Tue, 04 Apr 2023 15:23:47 +0200
Date:   Tue, 4 Apr 2023 15:23:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: fec: make use of MDIO C45 quirk
Message-ID: <9565cb99-2df6-48a1-8d43-2093e992b5b8@lunn.ch>
References: <20230404052207.3064861-1-gerg@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404052207.3064861-1-gerg@linux-m68k.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:22:07PM +1000, Greg Ungerer wrote:
> Not all fec MDIO bus drivers support C45 mode transactions. The older fec
> hardware block in many ColdFire SoCs does not appear to support them, at
> least according to most of the different ColdFire SoC reference manuals.
> The bits used to generate C45 access on the iMX parts, in the OP field
> of the MMFR register, are documented as generating non-compliant MII
> frames (it is not documented as to exactly how they are non-compliant).
> 
> Commit 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
> means the fec driver will always register c45 MDIO read and write
> methods. During probe these will always be accessed now generating
> non-compliant MII accesses on ColdFire based devices.
> 
> Add a quirk define, FEC_QUIRK_HAS_MDIO_C45, that can be used to
> distinguish silicon that supports MDIO C45 framing or not. Add this to
> all the existing iMX quirks, so they will be behave as they do now (*).
> 
> (*) it seems that some iMX parts may not support C45 transactions either.
>     The iMX25 and iMX50 Reference Manuals contain similar wording to
>     the ColdFire Reference Manuals on this.
> 
> Fixes: 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
