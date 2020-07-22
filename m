Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B59229655
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgGVKhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:37:05 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:40910 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgGVKhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:37:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 161552018D;
        Wed, 22 Jul 2020 12:37:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AZz90R83hv-J; Wed, 22 Jul 2020 12:37:01 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9E18C20185;
        Wed, 22 Jul 2020 12:37:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 22 Jul 2020 12:37:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 22 Jul
 2020 12:37:01 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D2240318471A;
 Wed, 22 Jul 2020 12:37:00 +0200 (CEST)
Date:   Wed, 22 Jul 2020 12:37:00 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Mark Salyzyn <salyzyn@android.com>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@android.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: af_key: pfkey_dump needs parameter validation
Message-ID: <20200722103700.GP20687@gauss3.secunet.de>
References: <20200721132358.966099-1-salyzyn@android.com>
 <20200722093318.GO20687@gauss3.secunet.de>
 <2ae16588-2972-a797-9310-4f9d56b7348b@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2ae16588-2972-a797-9310-4f9d56b7348b@android.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 03:20:59AM -0700, Mark Salyzyn wrote:
> On 7/22/20 2:33 AM, Steffen Klassert wrote:
> > On Tue, Jul 21, 2020 at 06:23:54AM -0700, Mark Salyzyn wrote:
> > > In pfkey_dump() dplen and splen can both be specified to access the
> > > xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
> > > when it calls addr_match() with the indexes.  Return EINVAL if either
> > > are out of range.
> > > 
> > > Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> > > Cc: netdev@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: kernel-team@android.com
> > > ---
> > > Should be back ported to the stable queues because this is a out of
> > > bounds access.
> > Please do a v2 and add a proper 'Fixes' tag if this is a fix that
> > needs to be backported.
> > 
> > Thanks!
> 
> Confused because this code was never right? From 2008 there was a rewrite
> that instantiated this fragment of code so that it could handle
> continuations for overloaded receive queues, but it was not right before the
> adjustment.
> 
> Fixes: 83321d6b9872b94604e481a79dc2c8acbe4ece31 ("[AF_KEY]: Dump SA/SP
> entries non-atomically")
> 
> that is reaching back more than 12 years and the blame is poorly aimed
> AFAIK.

This is just that the stable team knows how far they need to backport
it. If this was never right, then the initial git commit is the right
one for the fixes tag e.g. 'Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")'

