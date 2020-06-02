Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2C1EC131
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 19:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgFBRjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 13:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgFBRjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 13:39:12 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241CC05BD1E;
        Tue,  2 Jun 2020 10:39:11 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c14so12326016qka.11;
        Tue, 02 Jun 2020 10:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggvBLTbgRYnl8y+Dehj+RL3S/6wD8MGqD+aYH9/SFi4=;
        b=oLtSfnZdg6IbisGfewVCJOM26JVOBD4WCVKqPwMq5imrN/f5nNTV3S5u1BLx4Hx5BH
         CZfq2xrExwKXR/k5cz5pbxoUNwKXT6rgB7oDsP4lT6xwI8/MpTQJkhDlrZq5Jwfj49TD
         hfqKIXg0m8u7tlZ3ynpZoVdMzbX79GH5nzTBc32P2FAyNRJWjbKwkks9IN7k0Mn+3Wuz
         5rv3l6FRV9MpJHgWRNViXXhJYCqdl+PRiWKc6Hapbel26dscM6exlcQf1BLaAmTNGc1c
         JAdQceoHWUSO/4lT0vaGwENq81+cV3IUqyc7sYeBVgrjQqfP4Pev2n/CYkKX0F34KuzP
         v+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggvBLTbgRYnl8y+Dehj+RL3S/6wD8MGqD+aYH9/SFi4=;
        b=YOTOvJH+Cea6NVVCpy5FyIlEsd9PGswwq9oK7U80KmVaAhXiU14dte5zqDObXgWDNy
         dhMrepzOFNy0ro6XiHIJQiu9WeBAP4nQQBk0AsAiFMQVyVvLYU/C9x8EvrviG0DljHW8
         TpuytxNHnPvxQSZlMgGaaZWHcXZhEYl7Wse5R0XL9Ohv9U/C5i7q58JpgbTnvXeM5Ugz
         cDyaFZzlMhgQRBgMngNHkfnJ0XseWiK9mQwl8p4wqhjffEhrxMVhF30UUxNP9mmaO05/
         h13B5oSjN5ix7FJytmeoF4mTMwI7sFyspawm1D0JwhqSSDUr+9dqrtvII27k9Qb+BKlu
         e9rA==
X-Gm-Message-State: AOAM531ztMJEreohYLNmDHMNIh5mHMSYGoj6CDd880lJg9EzVk3x2MoX
        pBuVl4A/8lB4AKkpdRaHqYUTbUqs7wb2Oh3tauWeFJo7
X-Google-Smtp-Source: ABdhPJx1DNgsEQy0UtQnVOKbvEEfnxE4ARQmmEvZ8QgnHp62iN6QlbrYTVpM/KBylHqSHTsQ2osN4P3ROum8opbZfXo=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr27607385qkl.437.1591119550678;
 Tue, 02 Jun 2020 10:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com>
 <20200531082846.2117903-5-jakub@cloudflare.com> <CAEf4BzbxPrEJgWyeh_XzQcQ6VwfhC9NzyDNX4JCu86Jj4cCMtA@mail.gmail.com>
 <87ftbd3jci.fsf@cloudflare.com>
In-Reply-To: <87ftbd3jci.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Jun 2020 10:38:59 -0700
Message-ID: <CAEf4BzZ-A8KDc6kh1aezWuTEaO4_7Q0ZO352U-8Egkx6Y9qJdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/12] bpf: Add link-based BPF program
 attachment to network namespace
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 2:30 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Jun 02, 2020 at 12:30 AM CEST, Andrii Nakryiko wrote:
> > On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Extend bpf() syscall subcommands that operate on bpf_link, that is
> >> LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO, to accept attach types tied to
> >> network namespaces (only flow dissector at the moment).
> >>
> >> Link-based and prog-based attachment can be used interchangeably, but only
> >> one can exist at a time. Attempts to attach a link when a prog is already
> >> attached directly, and the other way around, will be met with -EEXIST.
> >> Attempts to detach a program when link exists result in -EINVAL.
> >>
> >> Attachment of multiple links of same attach type to one netns is not
> >> supported with the intention to lift the restriction when a use-case
> >> presents itself. Because of that link create returns -E2BIG when trying to
> >> create another netns link, when one already exists.
> >>
> >> Link-based attachments to netns don't keep a netns alive by holding a ref
> >> to it. Instead links get auto-detached from netns when the latter is being
> >> destroyed, using a pernet pre_exit callback.
> >>
> >> When auto-detached, link lives in defunct state as long there are open FDs
> >> for it. -ENOLINK is returned if a user tries to update a defunct link.
> >>
> >> Because bpf_link to netns doesn't hold a ref to struct net, special care is
> >> taken when releasing, updating, or filling link info. The netns might be
> >> getting torn down when any of these link operations are in progress. That
> >> is why auto-detach and update/release/fill_info are synchronized by the
> >> same mutex. Also, link ops have to always check if auto-detach has not
> >> happened yet and if netns is still alive (refcnt > 0).
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>  include/linux/bpf-netns.h      |   8 ++
> >>  include/linux/bpf_types.h      |   3 +
> >>  include/net/netns/bpf.h        |   1 +
> >>  include/uapi/linux/bpf.h       |   5 +
> >>  kernel/bpf/net_namespace.c     | 244 ++++++++++++++++++++++++++++++++-
> >>  kernel/bpf/syscall.c           |   3 +
> >>  tools/include/uapi/linux/bpf.h |   5 +
> >>  7 files changed, 267 insertions(+), 2 deletions(-)
> >>
> >
> > [...]
> >
> >> +
> >> +static int bpf_netns_link_update_prog(struct bpf_link *link,
> >> +                                     struct bpf_prog *new_prog,
> >> +                                     struct bpf_prog *old_prog)
> >> +{
> >> +       struct bpf_netns_link *net_link =
> >> +               container_of(link, struct bpf_netns_link, link);
> >> +       enum netns_bpf_attach_type type = net_link->netns_type;
> >> +       struct net *net;
> >> +       int ret = 0;
> >> +
> >> +       if (old_prog && old_prog != link->prog)
> >> +               return -EPERM;
> >> +       if (new_prog->type != link->prog->type)
> >> +               return -EINVAL;
> >> +
> >> +       mutex_lock(&netns_bpf_mutex);
> >> +
> >> +       net = net_link->net;
> >> +       if (!net || !check_net(net)) {
> >
> > As is, this check_net() check looks very racy. Because if we do worry
> > about net refcnt dropping to zero, then between check_net() and
> > accessing net fields that can happen. So if that's a possiblity, you
> > should probably instead do maybe_get_net() instead.
> >
> > But on the other hand, if we established that auto-detach taking a
> > mutex protects us from net going away, then maybe we shouldn't worry
> > at all about that, and thus check_net() is unnecessary and just
> > unnecessarily confusing everything.
> >
> > I don't know enough overall net lifecycle, so I'm not sure which one
> > it is. But the way it is right now still looks suspicious to me.
>
> The story behind the additional "!check_net(net)" test (in update_prog
> and in fill_info) is that without it, user-space will see the link as
> defunct only after some delay from the moment last ref to netns is gone
> (for instance, last process left the netns).
>
> That is because netns is being destroyed from a workqueue [0].

Ok, so it's not strictly necessary in terms of correctness, but just
nicer behaviro and it's still safe to access net, even if its refcnt
drops to zero meanwhile. Ok, thanks for elaborating.

>
> This unpredictable delay makes testing the uAPI harder, and I expect
> using it as well. Since we can do better and check the refcnt to detect
> "early" that netns is no good any more, that's what we do.
>
> At least that was my thinking here. I was hoping the comment below the
> check would be enough. Didn't mean to cause confusion.
>
> So there is no race, the locking scheme you suggested holds.
>
> [0] https://elixir.bootlin.com/linux/latest/source/net/core/net_namespace.c#L644
>
> >
> >> +               /* Link auto-detached or netns dying */
> >> +               ret = -ENOLINK;
> >> +               goto out_unlock;
> >> +       }
> >> +
> >> +       old_prog = xchg(&link->prog, new_prog);
> >> +       rcu_assign_pointer(net->bpf.progs[type], new_prog);
> >> +       bpf_prog_put(old_prog);
> >> +
> >> +out_unlock:
> >> +       mutex_unlock(&netns_bpf_mutex);
> >> +       return ret;
> >> +}
> >> +
> >> +static int bpf_netns_link_fill_info(const struct bpf_link *link,
> >> +                                   struct bpf_link_info *info)
> >> +{
> >> +       const struct bpf_netns_link *net_link =
> >> +               container_of(link, struct bpf_netns_link, link);
> >> +       unsigned int inum = 0;
> >> +       struct net *net;
> >> +
> >> +       mutex_lock(&netns_bpf_mutex);
> >> +       net = net_link->net;
> >> +       if (net && check_net(net))
> >> +               inum = net->ns.inum;
> >> +       mutex_unlock(&netns_bpf_mutex);
> >> +
> >> +       info->netns.netns_ino = inum;
> >> +       info->netns.attach_type = net_link->type;
> >> +       return 0;
> >> +}
> >> +
> >> +static void bpf_netns_link_show_fdinfo(const struct bpf_link *link,
> >> +                                      struct seq_file *seq)
> >> +{
> >> +       struct bpf_link_info info = {};
> >
> > initialization here is probably not necessary, as long as you access
> > only fields that fill_info initializes.
>
> True. I figured that better safe than leaking stack contents, if
> bpf_netns_link_fill_info gets broken.
>
> >
> >> +
> >> +       bpf_netns_link_fill_info(link, &info);
> >> +       seq_printf(seq,
> >> +                  "netns_ino:\t%u\n"
> >> +                  "attach_type:\t%u\n",
> >> +                  info.netns.netns_ino,
> >> +                  info.netns.attach_type);
> >> +}
> >> +
> >
> > [...]
