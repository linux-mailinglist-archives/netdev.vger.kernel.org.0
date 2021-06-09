Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E53A1FA2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhFIWCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFIWCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:02:41 -0400
X-Greylist: delayed 553 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Jun 2021 15:00:46 PDT
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239E8C06175F
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:00:46 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1623275486; bh=dOF4yl8SDWfB55KBb84FHywUrOJ3LNZB/SNnL6wi/xQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FRB28L9cg7dfWAYisj3uPg7SKiML8DeTSnizK8DZECP8d1ogFjXAzdvzWV+AZzDLY
         MOxWFTNREdI41UC5N5smLUc/yRiXcAL2zBlms8jy6+SR6iRsbUj9A5I/ChJQ0xo7bt
         yuleXplDUxk1jbU+BgTTpuuXpxZLRLLnam7zq80/7eC1hYQNMhuRvwiQKKDi3dvaLW
         WR6k2b4fX1gpfHx4FW+ClO/y2m9cCqE6CmZPEGd+y4lpcEq4vSWI8dk+nCbJLEv8kF
         h10S+B1YmiNzuKBPuLVfhK2a9Yi0Jx15uLJV9sELWozZw4bv1w0UyUP+nyfjcircdc
         Pq6UK1IKW6MKg==
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Young Xiao <92siuyang@gmail.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net 3/3] sch_cake: Fix out of bounds when parsing TCP
 options
In-Reply-To: <20210609142212.3096691-4-maximmi@nvidia.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
 <20210609142212.3096691-4-maximmi@nvidia.com>
Date:   Wed, 09 Jun 2021 23:51:23 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h7i6n1us.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy <maximmi@nvidia.com> writes:

> The TCP option parser in cake qdisc (cake_get_tcpopt and
> cake_tcph_may_drop) could read one byte out of bounds. When the length
> is 1, the execution flow gets into the loop, reads one byte of the
> opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
> one more byte, which exceeds the length of 1.
>
> This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
> out of bounds when parsing TCP options.").
>
> Cc: Young Xiao <92siuyang@gmail.com>
> Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>

Thanks for fixing this!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
