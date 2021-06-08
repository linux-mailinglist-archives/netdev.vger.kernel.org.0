Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCBB39EC71
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhFHC7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhFHC7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:59:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B02C061787
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 19:57:09 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ba2so21035748edb.2
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 19:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EuJsYuOqrG8SwCz3ljrkwXN4K75nXvxXvYn9NFBNIIk=;
        b=b/Tb/DenmCtu38YpFqyJ5pZcHaHq4/WyfqjMlIGoJNiMNfANIToEi7K3/qi09KX65a
         HRsvOsFx+++DN8XaG4MI5HPv4SMOBayo6cqyJGsiG6aGwNoWgOThbdrCnc1M/kiKTDuw
         +e8aOaNSZer3m2ERgU+iQHrkKM9Ih6pE7oq8p94nEBr5JM3cGp+CaEFXg0uwOaZKTMLi
         VWfNBoB4fieEEYeHmPRvLyGxPP0rDQCj53AfH2C1O8iLMWQYLKlUGZ/IFMgxHPVAYjNV
         Vz/YtPwa1I1AqE2X//PBAtJTAGCg5fSzP+dHq5E3HFtwmfeft43ZUpLKzAyaTKk9fqqT
         Q3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EuJsYuOqrG8SwCz3ljrkwXN4K75nXvxXvYn9NFBNIIk=;
        b=XK4DqhGXwciAYoWTJOT/AJo1/uYJrSWXIbtlx1CQTnBkPwMCBWNNfm3WK3yztvvFab
         bd2EMerkJ3RKltDrrRjje/jaXYUXzfb3pwCHIZKIYu2RMjMNZU5ji0UqMcY15SCXBW9k
         b9g0ZXUiKzwR5U0unEEC5N4HPKie9MtVnRLRrYtViwLdjXxLmBCg4mxKi/FNLu/8HggW
         k1lJUvexltrA9lRHA3ZGqAd99vL1SIqXgb1yoe9tEaDJ8F8uCdMc7pDzn3UGUtqYYvQL
         wMw7TCOmkNr9Uui+7qPJ5nDWp3Jahdqd6VlCzw5FRwspREZfAL3AFIquNO6XwZecdAYx
         AqOg==
X-Gm-Message-State: AOAM530Uga8dan8KGIBZrKwQiDiihyq1xFpBhrABU69M/qIQLRL5uhv5
        aOr4Sfd3kREQ8CxVISLL5ns/fb/Vc8J6hO53ndhx
X-Google-Smtp-Source: ABdhPJxmiiOxK28u0wIUfqakPqSPdOGryiWaqVkUadFKJswOOkz07/rWunWEUHe2KpR3G3nPPsBjc/LJMKVW1pJVeqU=
X-Received: by 2002:a05:6402:1771:: with SMTP id da17mr19127260edb.31.1623121028094;
 Mon, 07 Jun 2021 19:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210608015158.3848878-1-sunnanyong@huawei.com>
 <CAHC9VhTqDjN1VwakrYZznaMVTyqkEKcYLo=bPtHsOXugS_mexQ@mail.gmail.com> <CAD-N9QXFbO_FVBTHN6k+ZPw7GF6bKp+f4wK_LfMQLRsdML=XcA@mail.gmail.com>
In-Reply-To: <CAD-N9QXFbO_FVBTHN6k+ZPw7GF6bKp+f4wK_LfMQLRsdML=XcA@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 7 Jun 2021 22:56:57 -0400
Message-ID: <CAHC9VhQZVOmy7n14nTSRGHzwN-y=E_JTUP+NpRCgD8rJN5sOGA@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: fix memory leak in netlbl_cipsov4_add_std
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 10:31 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> On Tue, Jun 8, 2021 at 9:57 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Jun 7, 2021 at 9:19 PM Nanyong Sun <sunnanyong@huawei.com> wrote:
> > >
> > > Reported by syzkaller:
> > > BUG: memory leak
> > > unreferenced object 0xffff888105df7000 (size 64):
> > > comm "syz-executor842", pid 360, jiffies 4294824824 (age 22.546s)
> > > hex dump (first 32 bytes):
> > > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > > backtrace:
> > > [<00000000e67ed558>] kmalloc include/linux/slab.h:590 [inline]
> > > [<00000000e67ed558>] kzalloc include/linux/slab.h:720 [inline]
> > > [<00000000e67ed558>] netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:145 [inline]
> > > [<00000000e67ed558>] netlbl_cipsov4_add+0x390/0x2340 net/netlabel/netlabel_cipso_v4.c:416
> > > [<0000000006040154>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320 net/netlink/genetlink.c:739
> > > [<00000000204d7a1c>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> > > [<00000000204d7a1c>] genl_rcv_msg+0x2bf/0x4f0 net/netlink/genetlink.c:800
> > > [<00000000c0d6a995>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> > > [<00000000d78b9d2c>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> > > [<000000009733081b>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> > > [<000000009733081b>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> > > [<00000000d5fd43b8>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
> > > [<000000000a2d1e40>] sock_sendmsg_nosec net/socket.c:654 [inline]
> > > [<000000000a2d1e40>] sock_sendmsg+0x139/0x170 net/socket.c:674
> > > [<00000000321d1969>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> > > [<00000000964e16bc>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> > > [<000000001615e288>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
> > > [<000000004ee8b6a5>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
> > > [<00000000171c7cee>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > The memory of doi_def->map.std pointing is allocated in
> > > netlbl_cipsov4_add_std, but no place has freed it. It should be
> > > freed in cipso_v4_doi_free which frees the cipso DOI resource.
> > >
> > > Fixes: 96cb8e3313c7a ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> > > ---
> > >  net/ipv4/cipso_ipv4.c | 1 +
> > >  1 file changed, 1 insertion(+)
> >
> > Nice catch, thanks for fixing this.
> >
> > Acked-by: Paul Moore <paul@paul-moore.com>
> >
> > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > index d6e3a92841e3..099259fc826a 100644
> > > --- a/net/ipv4/cipso_ipv4.c
> > > +++ b/net/ipv4/cipso_ipv4.c
> > > @@ -471,6 +471,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
> > >                 kfree(doi_def->map.std->lvl.local);
> > >                 kfree(doi_def->map.std->cat.cipso);
> > >                 kfree(doi_def->map.std->cat.local);
> > > +               kfree(doi_def->map.std);
> > >                 break;
> > >         }
> > >         kfree(doi_def);
>
> Hi kernel developers,
>
> I doubt this patch may cause invalid free in other functions where
> map.std is not allocated or initialized, such as
> netlbl_cipsov4_add_local, netlbl_cipsov4_add_pass.

It isn't perfectly clear to me if you are implying there is a problem
with the proposed patch or not, so I thought it might help to try and
add some clarity.

The patch above frees the cipso_v4_doi->map.std field, which is only
valid when the cipso_v4_doi->type field is equal to
CIPSO_V4_MAP_TRANS.  This is why the cipso_v4_doi_free() function
checks the type field before freeing the cipso_v4_doi->map related
fields, and why the proposed patch places the new kfree() inside that
conditional code block.

If we look at netlalbel_cipsov4_add_pass() we see that the first thing
it does after allocating a cipso_v4_doi struct is to set the type
field to CIPSO_V4_MAP_PASS.  Any calls to cipso_v4_doi_free after this
point will not end up calling the proposed kfree() addition due to the
cipso_v4_doi->type check.

We see something very similar with netlbl_cipsov4_add_local(),
although in this case the type field is set to CIPSO_V4_MAP_LOCAL.
This type value will also not trigger the proposed kfree().

If you are aware of any other potential issues with this patch please
do let us know, but from what I can see, the two concerns you
presented here are not problems with the current or proposed code.

-- 
paul moore
www.paul-moore.com
