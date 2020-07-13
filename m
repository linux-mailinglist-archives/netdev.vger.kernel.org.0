Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D371421E311
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGMWeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGMWeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:34:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B70C061755;
        Mon, 13 Jul 2020 15:34:05 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so11373263qtg.4;
        Mon, 13 Jul 2020 15:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UE6STKd0GRhj0BglhJdZ9+Z6NYLGTgJAWgyGnmVH5sI=;
        b=VioH/sV+zNwOtxMxEl0VfR+HB+aDzNdw4C6kf5k80xNRUXULh+Pg6FX1+67+Gz3M86
         pVdKrRNSzvTNt/iUCFUUTlfvaARQ0RGjugy1dx4vdRMLfM05icKqANOaWMn1xzalocfe
         DLqdlX72RhCfRzFLUOShAOxWEsrtL8PHF5CkRKpKH7hCQApLmUyo1LooBJSjKmr3PwKl
         1x75CRMcwdXR/yGS2lYPGYQo1Ip88Yw5A/c7yAjrdEXEUzn6gDJJFhlsbS3wjVtgzNqr
         H4jEuVm42ApQmwD6jsox9KF1XoxuZNQL/yGHaXwRk8Hbd/f2j9JMfQXqC0Ki1mwCtB6i
         2IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UE6STKd0GRhj0BglhJdZ9+Z6NYLGTgJAWgyGnmVH5sI=;
        b=TqKH/1UsPJmjW3tvCB8T8IUMSl+3s9nVbHNli/IibuucwzKciEwwF1679BzcCl6AF5
         OjPkvmbtDsqTtgzhEuvyA4eEhPmfmJY+4msPEByRcyDtK7gOtv1OZ0rVTfHetCYRvOqV
         ukIdBv9TabJTOlVRh8Mi1+uoF/ziG5RfvwXoe6V0O9HmqPv+gmgHhis5fX+8HMqlRxZK
         Kr/N31GAWPjotgWyBZO/FJsqQZJg8S+iU4H1SijFd1Xal7OflnghcuiDRTR+SBXxJYlu
         i356yU32xY9J08kpluwhNBwLJbOv/T3053OAKyodA+0Z96g/4bsJoYpkvmzWkhHhAm3h
         BP1w==
X-Gm-Message-State: AOAM531WbH8PipOYbHGMpgUom/QJi2f/gS0j2Oc4r/nEFrcRV1w3Cjgi
        5oDnRhyK9RGdPJMK1SnteBRettTCxcodM0AqosA=
X-Google-Smtp-Source: ABdhPJyQwUi4kFkgWm4SkpqtyQVta4J6neh+A/BoMfXqCPr3vBK9UZCIZj6qJqiuNTa8lBmywRgVgNfy3V1TPOkAl1c=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr1602740qtj.93.1594679645135;
 Mon, 13 Jul 2020 15:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <58dd821b-c9b2-ac45-d47a-e5f75aec3d68@gmail.com>
In-Reply-To: <58dd821b-c9b2-ac45-d47a-e5f75aec3d68@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jul 2020 15:33:54 -0700
Message-ID: <CAEf4BzZg2tmNV7LxmcHarZeB+AVmgZW-afzcOUqc7K-5N4NE4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 7:19 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/10/20 4:49 PM, Andrii Nakryiko wrote:
> > Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program through
> > BPF_LINK_CREATE command.
> >
> > bpf_xdp_link is mutually exclusive with direct BPF program attachment,
> > previous BPF program should be detached prior to attempting to create a new
> > bpf_xdp_link attachment (for a given XDP mode). Once link is attached, it
> > can't be replaced by other BPF program attachment or link attachment. It will
> > be detached only when the last BPF link FD is closed.
> >
> > bpf_xdp_link will be auto-detached when net_device is shutdown, similarly to
> > how other BPF links behave (cgroup, flow_dissector). At that point bpf_link
> > will become defunct, but won't be destroyed until last FD is closed.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/netdevice.h |   6 +
> >  include/uapi/linux/bpf.h  |   7 +-
> >  kernel/bpf/syscall.c      |   5 +
> >  net/core/dev.c            | 385 ++++++++++++++++++++++++++++----------
>
> That's big diff for 1 patch. A fair bit of is refactoring / code
> movement that can be done in a separate refactoring patch making it
> cleaer what changes you need for the bpf_link piece.

Ok, I'll do another refactoring patch for prog attach logic only.

>
>
> >  4 files changed, 301 insertions(+), 102 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index d5630e535836..93bcd81d645d 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -886,6 +886,7 @@ struct bpf_prog_offload_ops;
> >  struct netlink_ext_ack;
> >  struct xdp_umem;
> >  struct xdp_dev_bulk_queue;
> > +struct bpf_xdp_link;
> >
> >  enum bpf_xdp_mode {
> >       XDP_MODE_SKB = 0,
> > @@ -896,6 +897,7 @@ enum bpf_xdp_mode {
> >
> >  struct bpf_xdp_entity {
> >       struct bpf_prog *prog;
> > +     struct bpf_xdp_link *link;
> >  };
> >
> >  struct netdev_bpf {
> > @@ -3824,6 +3826,10 @@ typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> >                     int fd, int expected_fd, u32 flags);
> >  u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
> > +
> > +struct bpf_xdp_link;
>
> already stated above.

oh, right, will drop

>
> > +int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
> > +
> >  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> >
> >  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 548a749aebb3..41eba148217b 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -227,6 +227,7 @@ enum bpf_attach_type {
> >       BPF_CGROUP_INET6_GETSOCKNAME,
> >       BPF_XDP_DEVMAP,
> >       BPF_CGROUP_INET_SOCK_RELEASE,
> > +     BPF_XDP,
>
> This really does not add value for the uapi. The link_type uniquely
> identifies the type and the expected program type.

Yes, but that's how PROG_ATTACH/LINK_CREATE is set up. We had a
similar discussion for SK_LOOKUP recently. The only downside right now
is increasing struct cgroup_bpf size, but I think we have a plan for
mitigating it, similarly how netns bpf_link does it.

>
> >       __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > @@ -239,6 +240,7 @@ enum bpf_link_type {
> >       BPF_LINK_TYPE_CGROUP = 3,
> >       BPF_LINK_TYPE_ITER = 4,
> >       BPF_LINK_TYPE_NETNS = 5,
> > +     BPF_LINK_TYPE_XDP = 6,
> >
> >       MAX_BPF_LINK_TYPE,
> >  };

[...]

> > +     /* Drivers assume refcnt is already incremented (i.e, prog pointer is
> > +      * "moved" into driver), so they don't increment it on their own, but
> > +      * they do decrement refcnt when program is detached or replaced.
> > +      * Given net_device also owns link/prog, we need to bump refcnt here
> > +      * to prevent drivers from underflowing it.
> > +      */
> > +     if (prog)
> > +             bpf_prog_inc(prog);
>
> Why is this refcnt bump not needed today but is needed for your change?

Previously driver/generic_xdp_install "owned" this program and assumed
an already incremented ref_cnt, but dropped that count when the
current program was replaced with a new one (or NULL). Now, net_device
*also* owns prog (in xdp_state[mode].prog), in addition to whatever
book-keeping driver does internally. So there needs to be extra
refcnt.

But you are right that this should have been part of refactoring in
patch #1, I'll move it there.

>
> >       err = bpf_op(dev, &xdp);
> >       if (err)
> >               return err;
>
> and the error path is not decrementing it.

yep, great catch, thanks!

>
> > @@ -8756,39 +8811,221 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
> >

[...]

> >
> > -     if (dev_xdp_prog_id(dev, XDP_MODE_DRV)) {
> > -             WARN_ON(dev_xdp_install(dev, XDP_MODE_DRV, ndo_bpf,
> > -                                     NULL, 0, NULL));
> > -             dev_xdp_set_prog(dev, XDP_MODE_DRV, NULL);
> > +     /* link supports only XDP mode flags */
> > +     if (link && (flags & ~XDP_FLAGS_MODES))
> > +             return -EINVAL;
>
> everyone of the -errno returns needs an extack message explaining why

sure
