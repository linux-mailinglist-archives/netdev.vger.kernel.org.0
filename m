Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06001388C9D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 13:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349944AbhESLVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 07:21:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53888 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346140AbhESLVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 07:21:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ljKFc-0002QF-0q; Wed, 19 May 2021 19:20:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ljKFZ-00074i-49; Wed, 19 May 2021 19:20:29 +0800
Date:   Wed, 19 May 2021 19:20:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     sharathv@codeaurora.org
Cc:     tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: Internal error: Oops  from inet_frag_find, when inserting a IP
 frag into a rhashtable
Message-ID: <20210519112029.3jbw74fuqe4p2tjm@gondor.apana.org.au>
References: <997dfef63f2bd14acc2e478758bfc425@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <997dfef63f2bd14acc2e478758bfc425@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 12:52:27AM +0530, sharathv@codeaurora.org wrote:
>
>   784.185172:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754415]@2
> __get_vm_area_node.llvm.17374696036975823682+0x1ac/0x1c8
>    784.185179:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754422]@2
> __vmalloc_node_flags_caller+0xb4/0x170
>    784.185189:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754432]@2
> kvmalloc_node+0x40/0xa8
>    784.185199:   <2>  (2)[71:kworker/2:1][20210408_17:01:54.754442]@2
> rhashtable_insert_rehash+0x84/0x264

Something very fishy is going on here.

The code path in rhashtable_insert_rehash cannot possibly trigger
vmalloc because it uses GFP_ATOMIC.  Is this a pristine upstream
kernel or are there patches that may change things?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
