Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA92E5847E3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 23:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiG1V5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 17:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiG1V5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 17:57:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B40C57201;
        Thu, 28 Jul 2022 14:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sMIxOu+PrFYUqj1aEIeto3MFIRATAzf9C/roIOkAwJs=; b=XrxaKDPdlZQDhXzU9BGINT2PFE
        e4etlWAMey34nndhmHg5rkZHcuhZuY/TpMvg5jTY+2UWuUiVB1CmRA7v8tzgY29W6VwCpEl4brjIJ
        iG/MTeU6uiHDyBS4z/4vbDSMn2NZFXRRgOQvhs0C1ViAaK0d9DWfdsPYy5nK9vwJIdEs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHBVC-00BqUv-6g; Thu, 28 Jul 2022 23:57:06 +0200
Date:   Thu, 28 Jul 2022 23:57:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH] octeontx2-pf: Reduce minimum mtu size to 60
Message-ID: <YuMGMiFv8TAiUI11@lunn.ch>
References: <20220728123812.21974-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728123812.21974-1-naveenm@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 06:08:12PM +0530, Naveen Mamindlapalli wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> PTP messages like SYNC, FOLLOW_UP, DELAY_REQ are of size 58 bytes.
> Using a minimum packet length as 64 makes NIX to pad 6 bytes of
> zeroes while transmission. This is causing latest ptp4l application to
> emit errors since length in PTP header and received packet are not same.
> Padding upto 3 bytes is fine but more than that makes ptp4l to assume
> the pad bytes as a TLV. Hence reduce the size to 60 from 64.

Please Cc: the PTP maintainer for changes like this.

I also don't follow your explanation. At least for the original 802.3,
you had to pad packets shorter than 64 bytes, otherwise CSMA/CD did
not work. So i would expect PTP messages should be padded to 64?

Or is you hardware doing the padding wrong, and this is a workaround
for that bug?

    Andrew
