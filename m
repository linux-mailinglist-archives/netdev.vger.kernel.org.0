Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7222E8A8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG0JQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:16:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:42126 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgG0JQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:16:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EFC4520573;
        Mon, 27 Jul 2020 11:16:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lv4V5M2H6jHU; Mon, 27 Jul 2020 11:16:28 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8CC29201E4;
        Mon, 27 Jul 2020 11:16:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 27 Jul 2020 11:16:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 27 Jul
 2020 11:16:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9C2193184651;
 Mon, 27 Jul 2020 11:16:27 +0200 (CEST)
Date:   Mon, 27 Jul 2020 11:16:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     David Miller <davem@davemloft.net>, <ayush.sawal@chelsio.com>,
        <netdev@vger.kernel.org>, <secdev@chelsio.com>, <lkp@intel.com>
Subject: Re: [PATCH net V2] Crypto/chcr: Registering cxgb4 to xfrmdev_ops
Message-ID: <20200727091627.GX20687@gauss3.secunet.de>
References: <20200724084124.21651-1-ayush.sawal@chelsio.com>
 <20200724.170108.362782113011946610.davem@davemloft.net>
 <20200725062034.GA19493@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200725062034.GA19493@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 04:20:34PM +1000, Herbert Xu wrote:
> On Fri, Jul 24, 2020 at 05:01:08PM -0700, David Miller wrote:
> > 
> > Please start submitting chcr patches to the crypto subsystem, where it
> > belongs, instead of the networking GIT trees.
> 
> Hi Dave:
> 
> I think this patch belongs to the networking tree.  The reason is
> that it's related to xfrm offload which has nothing to do with the
> Crypto API.

Hm, I think some of this code is just misplaced under drivers/crypto.
All functions in 'drivers/crypto/chelsio/chcr_ipsec.c' implement
networking (IPsec). So it should be under drivers/net, then it
can be merged via the net or net-next tree as usual for network
drivers.

> Do xfrm offload drivers usually go through the networking tree or
> would it be better directed through the xfrm tree?

The drivers go through the networking trees, and I think it should
stay like this. Otherwise we would create needless merge conflicts.

