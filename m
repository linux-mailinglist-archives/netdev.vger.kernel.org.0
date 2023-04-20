Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8336E9AD5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjDTRd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjDTRd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:33:56 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FD04ECE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:33:27 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-32b1c8ff598so9429695ab.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682012007; x=1684604007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fb4Gpo5zq5er7+dGwPDNGiOOC6qGu9DglFNN9UvkD+k=;
        b=07noDTKnUHfMnjUbvmEfaeakE5ADvLJ1m2Qvx1OlSJ9pyfauXUE7G7VEDqX3yKyips
         qBLItrdRyeiEQ5X4RqgIClZBq67kUWDMQgQuarqQ9onxkzGGx34ixawbhzqBQIlin3l6
         dvHsfkMCPlYMA29QnXfOz/dRpeuIyd7Y1j+2qhW00DZ6o9GEOf1Fa60slq/H/tBmwtz8
         l3lD0RA5mTyjiv2dgF5t6Ul+Jk5mxM/Ynq/wWURwrjWisAKMzzYe0QGeXVuuty8JyS3U
         7nXunQaxhyDdZjpLG4+qhCRC9KrnIm/By8GaHcoFBLuSCScl29nsn6eca0n54TeXrcVz
         2/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682012007; x=1684604007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fb4Gpo5zq5er7+dGwPDNGiOOC6qGu9DglFNN9UvkD+k=;
        b=kPsbgynUdve9YhfOYJdiIesKQDRxiwxgo0qlnPMShxbPq9RcQUefFLfWtPqdM/+wh7
         fIvt3yn+cK4lUZKRE5ou/quaw8X1hskLNqFqy3BFmWdXju/dksUbV56RBBEiqxygy6t3
         pxA+6dL8fNJIXEZnl4dCizvWO/UMNgc+QiJkRKO9CWPKbEvY3h0+ZOfCbS1wjQLOcHka
         Qs5TcNYVBsZbAQ/aEhvgHyNDh6wZGpiFKgFCk3gXA5Lrz9TPYve/Xg2T1k7+JgSYodhV
         E4JbZx8z9aVvPoVp/mQbOxqb8UQVGEnBQllGleb/+z7AB855PSTq/Z7KoPbwJ5Rpy1kW
         abjQ==
X-Gm-Message-State: AAQBX9cRNZLmGsCYr9dLBGZbUnJFrEODac3zAPVriCTvbG0pJE5Fvv4s
        TLqRvkYEEH44uiKMjyya+3gysMOmHogmdP/hAlfvSQ==
X-Google-Smtp-Source: AKy350ZSKRrsu5/c6PupGxMTU7pV6rGMgIzy8IOhutugHYNFOD4O6HjNERUmi/O5LCiS2YBAFYWw/uFcqkKEwx1MQQY=
X-Received: by 2002:a92:d40d:0:b0:32c:87c5:e737 with SMTP id
 q13-20020a92d40d000000b0032c87c5e737mr1113686ilm.6.1682012006993; Thu, 20 Apr
 2023 10:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681906552.git.leon@kernel.org> <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
 <CANn89i+3SDjwYb=0CAuGgUyGieCqHKso9cHCf=iSKYhV3rdi=Q@mail.gmail.com> <20230420170447.GD4423@unreal>
In-Reply-To: <20230420170447.GD4423@unreal>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Apr 2023 19:33:14 +0200
Message-ID: <CANn89iJ1q5+uyy=L_v2szsLg2D12=HZtnqo7j3KFeoH_O2j1aA@mail.gmail.com>
Subject: Re: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 7:05=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Thu, Apr 20, 2023 at 06:51:52PM +0200, Eric Dumazet wrote:
> > On Wed, Apr 19, 2023 at 2:19=E2=80=AFPM Leon Romanovsky <leon@kernel.or=
g> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Failure to add offloaded policy will cause to the following
> > > error once user will try to reload driver.
> > >
> > > Unregister_netdevice: waiting for eth3 to become free. Usage count =
=3D 2
> > >
> > > This was caused by xfrm_dev_policy_add() which increments reference
> > > to net_device. That reference was supposed to be decremented
> > > in xfrm_dev_policy_free(). However the latter wasn't called.
> > >
> > >  unregister_netdevice: waiting for eth3 to become free. Usage count =
=3D 2
> > >  leaked reference.
> > >   xfrm_dev_policy_add+0xff/0x3d0
> > >   xfrm_policy_construct+0x352/0x420
> > >   xfrm_add_policy+0x179/0x320
> > >   xfrm_user_rcv_msg+0x1d2/0x3d0
> > >   netlink_rcv_skb+0xe0/0x210
> > >   xfrm_netlink_rcv+0x45/0x50
> > >   netlink_unicast+0x346/0x490
> > >   netlink_sendmsg+0x3b0/0x6c0
> > >   sock_sendmsg+0x73/0xc0
> > >   sock_write_iter+0x13b/0x1f0
> > >   vfs_write+0x528/0x5d0
> > >   ksys_write+0x120/0x150
> > >   do_syscall_64+0x3d/0x90
> > >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > >
> > > Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> >
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> >
> > While reviewing this patch, I also saw xfrm_dev_policy_add() could use
> > GFP_KERNEL ?
>
> netdev_tracker_alloc(...) line was copied from commit e1b539bd73a7
> ("xfrm: add net device refcount tracker to struct xfrm_state_offload")
>
> Thanks

Then I guess Steffen can fix both call sites...
