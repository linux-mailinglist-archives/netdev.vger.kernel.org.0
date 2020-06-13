Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF111F8432
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgFMQDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 12:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgFMQDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 12:03:42 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E837C03E96F
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 09:03:42 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so14385535ljv.5
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 09:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/07B8VBrY9dx2b+nvEtQZF8YJfWZ/zNGmrpqGO1fpYQ=;
        b=vAF6Nfc6yOR+w1Yc6S9vzGTNICwtnb+gKbummNGSd+8kaL62em58T4Geux+sQfL+oD
         1FLEwkhbjfac6jJKVfTE9oXcxXMlFbt4mnNr+6uxkAmiYDFEBdiCFTeUr8VDpr92R6YQ
         62qDMRxF4CGk++wS6XFzKhdpRBjJAjGkXZU4pcLlucL/TO95S9RyCtBqsth/6mBixEfB
         Ci2YbkXs6cBXoTZQ3YcuPK562lOuo8n1k+/NaoTX/G/JlkZtl05TyQzmfcSKmbbJTcxj
         HMOUohIQjthE2jvdxVTjQC6/Fu+lemRRwx4gK4M533znLdVt0w41VmmOXIDvA2zzCfzK
         Ug3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/07B8VBrY9dx2b+nvEtQZF8YJfWZ/zNGmrpqGO1fpYQ=;
        b=jkfi8ZSIOtZeIsMR41R1QplTNHCuS1wcSY7aLxOTN2HE+CDkK/jfcWJ7ryv8bR6c5L
         +dhACeqeU8AafYP/mYfoLqv6STepreO07I0ywSq3AVb65T/7HqZS/eeFiA4KamA5kWdk
         S9TnZLYJDiZYWTLc59etUdlTlh4+U/Pr2ohDO/ErSjSjo1BleujWVKKd7kzcWBbQDxc5
         8+eVGitSQdpQtD/n32yXxgeiM1wjqz7IRCH7ssQV3zjA4bXCzCFtofoEGT83KX0ADqm3
         knPURMIXLdSVDAiMbOnyg6uSfr+3UM7Rl0QvzkaLTvNVRp9HSpyixBVzH0RBkKZjZpha
         1Ebw==
X-Gm-Message-State: AOAM532e49oa6gxnkmRDryPnwDGpf/p2cu2w7HULGI3axsW6Zex8BtuX
        qQbqnkJMZefXXxtNidKRZGEDH6aUqnv8mn+LcHo=
X-Google-Smtp-Source: ABdhPJyHvVLjrUnI7+eG3qKf6BwVfsfz5eoTC+8OmQkCYh/uBdfLzSiyn9M1jKXETSJSs6koZqOT4BXPJGJXqyENbU4=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr9668894ljj.283.1592064220512;
 Sat, 13 Jun 2020 09:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CAMArcTUmqCqyyfs+vNtxoh_UsHZ2oZrcUkdWp8MPzW0tb6hKWA@mail.gmail.com> <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com>
In-Reply-To: <CAM_iQpWM5Bxj-oEuF_mYBL9Qf-eWmoVbfPCo7a=SjOJ0LnMjAA@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 14 Jun 2020 01:03:28 +0900
Message-ID: <CAMArcTV6ZtW24CscBUt=OdRD4HdFnAYEJ-i6h5k5J8m0rfwnQA@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 at 08:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong :)

> On Wed, Jun 10, 2020 at 7:48 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Tue, 9 Jun 2020 at 06:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> >
> > Hi Cong,
> > Thank you for this work!
> >
> > > The dynamic key update for addr_list_lock still causes troubles,
> > > for example the following race condition still exists:
> > >
> > > CPU 0:                          CPU 1:
> > > (RCU read lock)                 (RTNL lock)
> > > dev_mc_seq_show()               netdev_update_lockdep_key()
> > >                                   -> lockdep_unregister_key()
> > >  -> netif_addr_lock_bh()
> > >
> > > because lockdep doesn't provide an API to update it atomically.
> > > Therefore, we have to move it back to static keys and use subclass
> > > for nest locking like before.
> > >
> >
> > I'm sorry for the late reply.
> > I agree that using subclass mechanism to avoid too many lockdep keys.
>
> Avoiding too many lockdep keys is not the real goal of my patch,
> its main purpose is to fix a race condition shown above. Just FYI.
>

Thank you for notifying me.

>
> > But the subclass mechanism is also not updated its subclass key
> > automatically. So, if upper/lower relationship is changed,
> > interface would have incorrect subclass key.
> > It eventually results in lockdep warning.
>
> So dev->lower_level is not updated accordingly? I just blindly trust
> dev->lower_level, as you use it in other places too.
>
> > And, I think this patch doesn't contain bonding and team module part.
> > So, an additional patch is needed.
>
> Hmm, dev->lower_level is generic, so is addr_list_lock.
>
> Again, I just assume you already update dev->lower_level each time
> the topology changes. I added some printk() to verify it too for my
> simple bond over bond case. So, I can't immediately see what is
> wrong with dev->lower_level here. Do you mind to be more specific?
> Or I misunderstand your point?
>

> > > +       lockdep_set_class_and_subclass(&dev->addr_list_lock,
> > > +                                      &vlan_netdev_addr_lock_key,
> > > +                                      subclass);

In this patch, lockdep_set_class_and_subclass() is used.
As far as I know, this function initializes lockdep key and subclass
value with a given variable.
A dev->lower_level variable is used as a subclass value in this patch.
When dev->lower_level value is changed, the subclass value of this
lockdep key is not changed automatically.
If this value has to be changed, additional function is needed.

>>>        netif_addr_lock_bh(from);
In this function, internally spin_lock_bh() is used and this function
might use an 'initialized subclass value' not a current dev->lower_level.
At this point, I think the lockdep splat might occur.

+static inline void netif_addr_lock_nested(struct net_device *dev)
+{
+       spin_lock_nested(&dev->addr_list_lock, dev->lower_level);
+}
In this patch, you used netif_addr_lock_nested() too.
These two subclass values could be different.
But I'm not sure whether using spin_lock_nested with two different
subclass values are the right way or not.

If I misunderstood the lockdep and this logic, please let me know!

Thanks :)
