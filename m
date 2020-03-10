Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DBC17EEA4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCJCek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:34:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:43698 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgCJCek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:34:40 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jBUiy-0003fK-Am; Tue, 10 Mar 2020 13:34:29 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Mar 2020 13:34:28 +1100
Date:   Tue, 10 Mar 2020 13:34:28 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rohit Maheshwari <rohitm@chelsio.com>, borisp@mellanox.com,
        netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        varun@chelsio.com
Subject: Re: [PATCH net-next v4 1/6] cxgb4/chcr : Register to tls add and del
 callback
Message-ID: <20200310023428.GB18504@gondor.apana.org.au>
References: <20200307143608.13109-1-rohitm@chelsio.com>
 <20200307143608.13109-2-rohitm@chelsio.com>
 <20200309160526.26845f55@kicinski-fedora-PC1C0HJN>
 <20200309161021.0e58ee24@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309161021.0e58ee24@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 04:10:21PM -0700, Jakub Kicinski wrote:
>
> And the driver lives in drivers/crypto for some inexplicable reason.

Indeed, and this driver scares me :)

I believe it was added to drivers/crypto because it contained
code that hooks into the crypto API to provide crypto algorithms.
At the same time the driver also provides higher-level offload
directly through the network stack.

The problem with this arrangement is that a lot of network-related
code gets into the driver with almost no review.

I think it would make much more sense to move the whole driver
(back) into drivers/net.  There is no reason why it couldn't
continue to provide crypto API implementations from drivers/net.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
