Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCC36EA636
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbjDUItD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjDUIs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:48:26 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F531B757
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:46:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CA1D9207BE;
        Fri, 21 Apr 2023 10:46:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oUfkAk3Vazst; Fri, 21 Apr 2023 10:46:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 55B4E205ED;
        Fri, 21 Apr 2023 10:46:17 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 504BF80004A;
        Fri, 21 Apr 2023 10:46:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 10:46:17 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 21 Apr
 2023 10:46:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 99D013182A59; Fri, 21 Apr 2023 10:46:16 +0200 (CEST)
Date:   Fri, 21 Apr 2023 10:46:16 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
Message-ID: <ZEJNWK4Ku5RohNjV@gauss3.secunet.de>
References: <cover.1681906552.git.leon@kernel.org>
 <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
 <CANn89i+3SDjwYb=0CAuGgUyGieCqHKso9cHCf=iSKYhV3rdi=Q@mail.gmail.com>
 <20230420170447.GD4423@unreal>
 <CANn89iJ1q5+uyy=L_v2szsLg2D12=HZtnqo7j3KFeoH_O2j1aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJ1q5+uyy=L_v2szsLg2D12=HZtnqo7j3KFeoH_O2j1aA@mail.gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 07:33:14PM +0200, Eric Dumazet wrote:
> On Thu, Apr 20, 2023 at 7:05 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Apr 20, 2023 at 06:51:52PM +0200, Eric Dumazet wrote:
> > > On Wed, Apr 19, 2023 at 2:19 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Failure to add offloaded policy will cause to the following
> > > > error once user will try to reload driver.
> > > >
> > > > Unregister_netdevice: waiting for eth3 to become free. Usage count = 2
> > > >
> > > > This was caused by xfrm_dev_policy_add() which increments reference
> > > > to net_device. That reference was supposed to be decremented
> > > > in xfrm_dev_policy_free(). However the latter wasn't called.
> > > >
> > > >  unregister_netdevice: waiting for eth3 to become free. Usage count = 2
> > > >  leaked reference.
> > > >   xfrm_dev_policy_add+0xff/0x3d0
> > > >   xfrm_policy_construct+0x352/0x420
> > > >   xfrm_add_policy+0x179/0x320
> > > >   xfrm_user_rcv_msg+0x1d2/0x3d0
> > > >   netlink_rcv_skb+0xe0/0x210
> > > >   xfrm_netlink_rcv+0x45/0x50
> > > >   netlink_unicast+0x346/0x490
> > > >   netlink_sendmsg+0x3b0/0x6c0
> > > >   sock_sendmsg+0x73/0xc0
> > > >   sock_write_iter+0x13b/0x1f0
> > > >   vfs_write+0x528/0x5d0
> > > >   ksys_write+0x120/0x150
> > > >   do_syscall_64+0x3d/0x90
> > > >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > > >
> > > > Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > >
> > > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > >
> > > While reviewing this patch, I also saw xfrm_dev_policy_add() could use
> > > GFP_KERNEL ?
> >
> > netdev_tracker_alloc(...) line was copied from commit e1b539bd73a7
> > ("xfrm: add net device refcount tracker to struct xfrm_state_offload")
> >
> > Thanks
> 
> Then I guess Steffen can fix both call sites...

Sure, will do a patch.

Thanks!
