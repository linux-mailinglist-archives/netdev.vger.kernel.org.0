Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42054A8D3
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiFNFk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiFNFk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B1A3818A;
        Mon, 13 Jun 2022 22:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E789761656;
        Tue, 14 Jun 2022 05:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF593C3411D;
        Tue, 14 Jun 2022 05:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655185255;
        bh=8+SZwi6ZZQOdOLhjzNsGV38OcJEcLt3L/iI4gfDuoy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vCXSnJ9YgN0pYz/fA6s3HEkpkE0UVedd9pCcfJ7jd5bPmTsvzqBtyD5OD/cjyvhZM
         wDtzGITCZJG/EHC2S/LmYOvCL1QxkFEzbyLBUzidronfSdUO3kAGMs+VnCGDcE1KIX
         dtQQjPo8FH9B9F1eUHZ4XnxyRTs+qWBbSKnGISs6DaimaaJzA0juSfJZl+aqEJpqMc
         PYsSkwRDiahPdlH7rCRJxHu3et+Bnhras5HAcdeeuJkqF8yBIi5j8xEX/Vf42pUTEZ
         6aki+hsu0dcoxRcS3SloMRvjrrR9OBGJXZzJ5j+qFNqenOMg+UwWitwyLdmeZZHrwz
         G4wU3g5np/q6Q==
Date:   Mon, 13 Jun 2022 22:40:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dt-bindings: dp83867: add binding for
 io_impedance_ctrl nvmem cell
Message-ID: <20220613224053.078f573c@kernel.org>
In-Reply-To: <29ddcecb-18d3-b92e-10fb-d5ea278886d6@rasmusvillemoes.dk>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
        <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
        <Yp54aOPqd5weWnFt@lunn.ch>
        <29ddcecb-18d3-b92e-10fb-d5ea278886d6@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 13:54:30 +0200 Rasmus Villemoes wrote:
> On 06/06/2022 23.58, Andrew Lunn wrote:
> >> There is no documented mapping from the 32 possible values of the
> >> IO_IMPEDANCE_CTRL field to values in the range 35-70 ohms  
> > 
> > There have been a few active TI engineers submitting patches to TI PHY
> > drivers. Please could you reach out to them and ask if they can
> > provide documentation.
> >
> > Having magic values in DT is not the preferred why to use it. Ideally
> > you should store Ohms in the cell and convert to the register value.  
> 
> We've already asked TI for more detailed information, but apparently the
> data sheet already says all there is to know. I should have worded the
> commit message differently. Something like
> 
>   There is no fixed mapping from register values to values in the range
>   35-70 ohms; it varies from chip to chip, and even that target range is
>   approximate.

The series was waiting for Andrew to come back but it ended up getting
marked as Changes Requested in PW. Would you mind reposting with the
modification to the commit message?
