Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF5420A586
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406471AbgFYTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405969AbgFYTQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:16:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A31FC08C5C1;
        Thu, 25 Jun 2020 12:16:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57BED129D29E7;
        Thu, 25 Jun 2020 12:16:08 -0700 (PDT)
Date:   Thu, 25 Jun 2020 12:16:05 -0700 (PDT)
Message-Id: <20200625.121605.1198833456036514480.davem@davemloft.net>
To:     ardb@kernel.org
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, stable@vger.kernel.org,
        ebiggers@google.com
Subject: Re: [PATCH v2] net: phy: mscc: avoid skcipher API for single block
 AES encryption
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625071816.1739528-1-ardb@kernel.org>
References: <20200625071816.1739528-1-ardb@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 12:16:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 25 Jun 2020 09:18:16 +0200

> The skcipher API dynamically instantiates the transformation object
> on request that implements the requested algorithm optimally on the
> given platform. This notion of optimality only matters for cases like
> bulk network or disk encryption, where performance can be a bottleneck,
> or in cases where the algorithm itself is not known at compile time.
> 
> In the mscc case, we are dealing with AES encryption of a single
> block, and so neither concern applies, and we are better off using
> the AES library interface, which is lightweight and safe for this
> kind of use.
> 
> Note that the scatterlist API does not permit references to buffers
> that are located on the stack, so the existing code is incorrect in
> any case, but avoiding the skcipher and scatterlist APIs entirely is
> the most straight-forward approach to fixing this.
> 
> Fixes: 28c5107aa904e ("net: phy: mscc: macsec support")
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Applied and queued up for -stable, thanks.

Please never CC: stable for networking changes, I handle the submissions
by hand.

Thank you.
