Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2291E48FBC7
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 09:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiAPIqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 03:46:37 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46463 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbiAPIqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 03:46:37 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C9915C0115;
        Sun, 16 Jan 2022 03:46:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 16 Jan 2022 03:46:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=l7H5ny
        lY+/q4IwM8kUw2Wd8rLDvCT2r6K7E1RaKOUiQ=; b=I00Jl2K1L3ywR5CjmiomUp
        +yBsGVM5W4e0A6L6XXGcOH5RLuwNg3vs3OeH3SXjgwraiTS3mZvQQSU9lJDSxVki
        caMOb2238eAs5WqzReKRjv/ybd5z7AsPNmtaeJaZchOJch9DlkaJq2D9v1WMOSqn
        EwwxGhfmJ6ZgA/wp/BpcDLfOZOfDg9ieHd9yJrqMWM98MENctd3FlS9+pXbc27wP
        bUIAE9ayWp5XiW5Gy1IzV6cinA/GuCh+pE84+osNxYFpP6Cx2AMda9Xh0/7KP1+l
        +v4D5bjtovLaYrqp95iXn98RVo6j9gcisUJ1Agrv1eeS2eWm+Lt9xB4rpD663QPw
        ==
X-ME-Sender: <xms:bNvjYTsH4-a73AzpKhnZ90nHg5YcAU6FboF1nTyjx46qtVXJkMZTUQ>
    <xme:bNvjYUcyg2Pa4TUdhAPX7zLlDtjmzjBQfrdfcC-VsCTsmKo-TtqUBQ_HTgM24XJya
    TXelPwVkFtNQME>
X-ME-Received: <xmr:bNvjYWyK3CDaStn4ramMudzc4XbHC6Otw_yYhKTqupUduEYedoglaXxm-lCUbRQSn18nxwZf32l2AE5_qlR5rBQ_T19XQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrtdekgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvffukfhfgggtuggj
    sehttdertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthh
    esihguohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedvtdevgfevveevhfehgfei
    udevueekffelteejgfeltddtffekleduvdefkeegvdenucffohhmrghinhepghhoohhglh
    gvrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bNvjYSNkt6ry8wh6jLSYca-htgC0zSRMC9EPjmiNfsDJX2_XrME4dw>
    <xmx:bNvjYT_ZlFrJZZ2bSb-eQA0vZWKqhDQceboBwYakSJwuYP7Zo-CHCw>
    <xmx:bNvjYSW2ibXfvkK8KNgKJoF5NidXfnVpVi64x5PskS5lREV0cS_MnA>
    <xmx:bNvjYTyx3Hfd66n_V4OlqwXnGQqp4FOtM94pMgSHNVjHsDWlPcyuIQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Jan 2022 03:46:35 -0500 (EST)
Date:   Sun, 16 Jan 2022 10:46:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net] ipv4: make fib_info_cnt atomic
Message-ID: <YePbZ1FBOrZ5RufS@shredder>
References: <20220114153902.1989393-1-eric.dumazet@gmail.com>
 <2f8ea7358c17449682f7e72eaed1ce54@AcuMS.aculab.com>
 <CANn89iKA32qt8X6VzFsissZwxHpar6pDEJT_dgYhnxfROcaqRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKA32qt8X6VzFsissZwxHpar6pDEJT_dgYhnxfROcaqRA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 08:25:04AM -0800, 'Eric Dumazet' via syzkaller wrote:
> On Fri, Jan 14, 2022 at 7:50 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Eric Dumazet
> > > Sent: 14 January 2022 15:39
> > >
> > > Instead of making sure all free_fib_info() callers
> > > hold rtnl, it seems better to convert fib_info_cnt
> > > to an atomic_t.
> >
> > Since fib_info_cnt is only used to control the size of the hash table
> > could it be incremented when a fid is added to the hash table and
> > decremented when it is removed.
> >
> > This is all inside the fib_info_lock.
> 
> Sure, this will need some READ_ONCE()/WRITE_ONCE() annotations
> because the resize would read fib_info_cnt without this lock held.
> 
> I am not sure this is a stable candidate though, patch looks a bit more risky.
> 
> This seems to suggest another issue...
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 828de171708f599b56f63715514c0259c7cb08a2..45619c005b8dddd7ccd5c7029efa4ed69b6ce1de
> 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -249,7 +249,6 @@ void free_fib_info(struct fib_info *fi)
>                 pr_warn("Freeing alive fib_info %p\n", fi);
>                 return;
>         }
> -       fib_info_cnt--;
> 
>         call_rcu(&fi->rcu, free_fib_info_rcu);
>  }
> @@ -260,6 +259,10 @@ void fib_release_info(struct fib_info *fi)
>         spin_lock_bh(&fib_info_lock);
>         if (fi && refcount_dec_and_test(&fi->fib_treeref)) {
>                 hlist_del(&fi->fib_hash);
> +
> +               /* Paired with READ_ONCE() in fib_create_info(). */
> +               WRITE_ONCE(fib_info_cnt, fib_info_cnt - 1);
> +
>                 if (fi->fib_prefsrc)
>                         hlist_del(&fi->fib_lhash);
>                 if (fi->nh) {
> @@ -1430,7 +1433,9 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>  #endif
> 
>         err = -ENOBUFS;
> -       if (fib_info_cnt >= fib_info_hash_size) {
> +
> +       /* Paired with WRITE_ONCE() in fib_release_info() */
> +       if (READ_ONCE(fib_info_cnt) >= fib_info_hash_size) {
>                 unsigned int new_size = fib_info_hash_size << 1;
>                 struct hlist_head *new_info_hash;
>                 struct hlist_head *new_laddrhash;
> @@ -1462,7 +1467,6 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>                 return ERR_PTR(err);
>         }
> 
> -       fib_info_cnt++;
>         fi->fib_net = net;
>         fi->fib_protocol = cfg->fc_protocol;
>         fi->fib_scope = cfg->fc_scope;
> @@ -1591,6 +1595,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>         refcount_set(&fi->fib_treeref, 1);
>         refcount_set(&fi->fib_clntref, 1);
>         spin_lock_bh(&fib_info_lock);
> +       fib_info_cnt++;
>         hlist_add_head(&fi->fib_hash,
>                        &fib_info_hash[fib_info_hashfn(fi)]);
>         if (fi->fib_prefsrc) {

Thanks for the fix. Looks OK to me. The counter is incremented under the
lock when adding to the hash table(s) and decremented under the lock
upon removal. Do you intend to submit this version instead of the first
one?

> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/CANn89iKA32qt8X6VzFsissZwxHpar6pDEJT_dgYhnxfROcaqRA%40mail.gmail.com.
