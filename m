Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404E11FEC0
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 07:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEPFQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 01:16:45 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:42954 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfEPFQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 01:16:45 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hR8ku-00037D-Td; Thu, 16 May 2019 13:16:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hR8kh-0003Nn-3A; Thu, 16 May 2019 13:16:23 +0800
Date:   Thu, 16 May 2019 13:16:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, tgraf@suug.ch, netdev@vger.kernel.org,
        oss-drivers@netronome.com, neilb@suse.com,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] rhashtable: fix sparse RCU warnings on bit lock in
 bucket pointer
Message-ID: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515205501.17810-1-jakub.kicinski@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 01:55:01PM -0700, Jakub Kicinski wrote:
> Since the bit_spin_lock() operations don't actually dereference
> the pointer, it's fine to forcefully drop the RCU annotation.
> This fixes 7 sparse warnings per include site.
> 
> Fixes: 8f0db018006a ("rhashtable: use bit_spin_locks to protect hash bucket.")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

I don't think this is the right fix.  We should remove the __rcu
marker from the opaque type rhash_lock_head since it cannot be
directly dereferenced.

I'm working on a fix to this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
