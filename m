Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1651436B375
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhDZMs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:48:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49566 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232795AbhDZMs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 08:48:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lb0er-0008Cs-KL; Mon, 26 Apr 2021 20:48:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lb0ek-0000lg-Dq; Mon, 26 Apr 2021 20:48:06 +0800
Date:   Mon, 26 Apr 2021 20:48:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, roopa@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net 2/2] net: bridge: fix lockdep multicast_lock false
 positive splat
Message-ID: <20210426124806.4zqhtn4wewair4ua@gondor.apana.org.au>
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-3-ap420073@gmail.com>
 <ed54816f-2591-d8a7-61d8-63b7f49852c1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed54816f-2591-d8a7-61d8-63b7f49852c1@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 07:45:27PM +0300, Nikolay Aleksandrov wrote:
>
> Ugh.. that's just very ugly. :) The setup you've described above is by all means invalid, but
> possible unfortunately. The bridge already checks if it's being added as a port to another
> bridge, but not through multiple levels of indirection. These locks are completely unrelated
> as they're in very different contexts (different devices).

Surely we should forbid this? Otherwise what's to stop someone
from creating a loop?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
