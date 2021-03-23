Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2828B345962
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCWIOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:14:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48866 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhCWINz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:13:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8A43420185;
        Tue, 23 Mar 2021 09:13:54 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EHVO46SgRBPQ; Tue, 23 Mar 2021 09:13:54 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 11A8F20534;
        Tue, 23 Mar 2021 09:13:54 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 09:13:53 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 23 Mar
 2021 09:13:53 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0D3A33180449; Tue, 23 Mar 2021 09:13:53 +0100 (CET)
Date:   Tue, 23 Mar 2021 09:13:53 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <sebastian.siewior@linutronix.de>
Subject: Re: [PATCH v1 0/2] net: xfrm: Use seqcount_spinlock_t
Message-ID: <20210323081353.GM62598@gauss3.secunet.de>
References: <20210316105630.1020270-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210316105630.1020270-1-a.darwish@linutronix.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 11:56:28AM +0100, Ahmed S. Darwish wrote:
> Hi,
> 
> This is a small series to trasform xfrm_state_hash_generation sequence
> counter to seqcount_spinlock_t, instead of plain seqcount_t.
> 
> In general, seqcount_LOCKNAME_t sequence counters allows to associate
> the lock used for write serialization with the seqcount. This enables
> lockdep to verify that the write serialization lock is always held
> before entering the seqcount write section.
> 
> If lockdep is disabled, this lock association is compiled out and has
> neither storage size nor runtime overhead.
> 
> The first patch is a general mainline fix, and has a Fixes tag.
> 
> Thanks,
> 
> 8<----------
> 
> Ahmed S. Darwish (2):
>   net: xfrm: Localize sequence counter per network namespace
>   net: xfrm: Use sequence counter with associated spinlock

Applied to the ipsec tree, thanks a lot!
