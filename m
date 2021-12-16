Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0393C477963
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhLPQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbhLPQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:39:22 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835C3C06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 08:39:22 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t26so8924894wrb.4
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kK2E/MMuR3TkQFzlN1U/zL0lQXThXaSDf+DSACr+ZJQ=;
        b=AfZce4hj/OyMTPFe9m4P1A9oJgKDVJr02gvJWBgrr9mxCzJy6ziMLD54MRyS6YJtoa
         tVRUzAvcIBZVrrcbCJt0TNeXIqNi7YZYl2iq/E4Wr5DKYTNT1gZ5GowODw2mZiI36ZKA
         F4B05jb/YWyYD3a1Xpju8YcBzJfiIVJcaRtkKWKGokh5/My2h/YuyhucwAiQ3sjSfMkm
         cAU+NeYYMMfS4JMKyZEvfsMRkVGjlB8bgb5PcsKm66iNo+/rOUb1+FSM3zhIivmr5hv2
         epTvTu+9MFHnJ9UKkaKI800srEM49bWICIEnW7KS1ePCABv3QdHlBFypOntEYI4lrqii
         LOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kK2E/MMuR3TkQFzlN1U/zL0lQXThXaSDf+DSACr+ZJQ=;
        b=z2W3VOsmImkfEJkG5cJfPrPZwZs2NgMDEUKoUqn3Jy0VOXs2T266768ZEU1Hy0Ilj/
         Ou8X3QUCKqguDloH4i7ELPkNhazeouHIF+ZkDGxru2NT0S0AvvJFGp/CjqOWq1HBw6c6
         RzNIVPxBZalw+eC6++2DPB8Sl6bg1vGAsobu42il9tiAXZl49gvkZxOwKlKaXL9Lxgaq
         oCJrZUg82ByyOnpnpWmASx7LQKqZkVhbZtbiYiiDKUWIBk8Czqx8BKDQBLFY0SvtjMvP
         XwxKChzElOHpWHbclJcpocSQMMfJDqj3fmkQgvBHKfhGpX4oirVMVy+ZFveHrpLnqLrG
         JoCw==
X-Gm-Message-State: AOAM530iNN94A6YWLBY31oTW9Zv2Bm/bnF4Axuy9hqxraaGh6laatw1g
        6GpCdh8EAsxftdwfeIaJ3Uoynw==
X-Google-Smtp-Source: ABdhPJwMMy984oVm1mzrWQj70JbEAsHknbyrmdCszQIgnW+xBEUUUWPhHof6vdXHQHq9GGuCuifOFw==
X-Received: by 2002:a5d:5181:: with SMTP id k1mr9883578wrv.681.1639672760937;
        Thu, 16 Dec 2021 08:39:20 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id y3sm3050806wrq.12.2021.12.16.08.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:39:20 -0800 (PST)
Date:   Thu, 16 Dec 2021 16:39:15 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
Message-ID: <Ybtrs56tSBbmyt5c@google.com>
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org>
 <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021, Xin Long wrote:

> On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > > The cause of the resultant dump_stack() reported below is a
> > > dereference of a freed pointer to 'struct sctp_endpoint' in
> > > sctp_sock_dump().
> > >
> > > This race condition occurs when a transport is cached into its
> > > associated hash table followed by an endpoint/sock migration to a new
> > > association in sctp_assoc_migrate() prior to their subsequent use in
> > > sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> > > table calling into sctp_sock_dump() where the dereference occurs.

> in sctp_sock_dump():
>         struct sock *sk = ep->base.sk;
>         ... <--[1]
>         lock_sock(sk);
> 
> Do you mean in [1], the sk is peeled off and gets freed elsewhere?

'ep' and 'sk' are both switched out for new ones in sctp_sock_migrate().

> if that's true, it's still late to do sock_hold(sk) in your this patch.

No, that's not right.

The schedule happens *inside* the lock_sock() call.

So if you take the reference before it, you're good.

> I talked with Marcelo about this before, if the possible UAF in [1] exists,
> the problem also exists in the main RX path sctp_rcv().
> 
> > >
> > >   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
> > >   Call trace:
> > >    dump_backtrace+0x0/0x2dc
> > >    show_stack+0x20/0x2c
> > >    dump_stack+0x120/0x144
> > >    print_address_description+0x80/0x2f4
> > >    __kasan_report+0x174/0x194
> > >    kasan_report+0x10/0x18
> > >    __asan_load8+0x84/0x8c
> > >    sctp_sock_dump+0xa8/0x438 [sctp_diag]
> > >    sctp_for_each_transport+0x1e0/0x26c [sctp]
> > >    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
> > >    inet_diag_dump+0x12c/0x168
> > >    netlink_dump+0x24c/0x5b8
> > >    __netlink_dump_start+0x274/0x2a8
> > >    inet_diag_handler_cmd+0x224/0x274
> > >    sock_diag_rcv_msg+0x21c/0x230
> > >    netlink_rcv_skb+0xe0/0x1bc
> > >    sock_diag_rcv+0x34/0x48
> > >    netlink_unicast+0x3b4/0x430
> > >    netlink_sendmsg+0x4f0/0x574
> > >    sock_write_iter+0x18c/0x1f0
> > >    do_iter_readv_writev+0x230/0x2a8
> > >    do_iter_write+0xc8/0x2b4
> > >    vfs_writev+0xf8/0x184
> > >    do_writev+0xb0/0x1a8
> > >    __arm64_sys_writev+0x4c/0x5c
> > >    el0_svc_common+0x118/0x250
> > >    el0_svc_handler+0x3c/0x9c
> > >    el0_svc+0x8/0xc
> > >
> > > To prevent this from happening we need to take a references to the
> > > to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
> > > until such a time when we know it can be safely released.
> > >
> > > When KASAN is not enabled, a similar, but slightly different NULL
> > > pointer derefernce crash occurs later along the thread of execution in
> > > inet_sctp_diag_fill() this time.
> Are you able to reproduce this issue?

Yes 100% of the time without this patch.

0% of the time with it applied.

> What I'm thinking is to fix it by freeing sk in call_rcu() by
> sock_set_flag(sock->sk, SOCK_RCU_FREE),
> and add rcu_read_lock() in sctp_sock_dump().
> 
> Thanks.
> 
> >
> > Are you able to identify where the bug was introduced? Fixes tag would
> > be good to have here.

It's probably been there since the code was introduced.

I'll see how far back we have to go.

> > You should squash the two patches together.

I generally like patches to encapsulate functional changes.

This one depends on the other, but they are not functionally related.

You're the boss though - I'll squash them if you insist.

> > > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > > index 760b367644c12..2029b240b6f24 100644
> > > --- a/net/sctp/diag.c
> > > +++ b/net/sctp/diag.c
> > > @@ -301,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > >       struct sctp_association *assoc;
> > >       int err = 0;
> > >
> > > +     sctp_endpoint_hold(ep);
> > > +     sock_hold(sk);
> > >       lock_sock(sk);
> > >       list_for_each_entry(assoc, &ep->asocs, asocs) {
> > >               if (cb->args[4] < cb->args[1])
> > > @@ -341,6 +343,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> > >       cb->args[4] = 0;
> > >  release:
> > >       release_sock(sk);
> > > +     sock_put(sk);
> > > +     sctp_endpoint_put(ep);
> > >       return err;
> > >  }
> > >
> >

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
