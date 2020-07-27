Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C322F878
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgG0Svs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0Svr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:51:47 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758E5C061794;
        Mon, 27 Jul 2020 11:51:47 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l64so9458493qkb.8;
        Mon, 27 Jul 2020 11:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3EJnxWQkYohSZ2rAj4ItXzUJ9TVbm4aLrUteT72d3A=;
        b=eqMFMVdK1n86ImsYfmZKF+aGeu8cwtbedni27lfMUocYxa859h4Yeqsn5BRYaHo1e1
         DwP5thbf5F2OT15ZK1cDWU76YcVUsnZqS/vDD1/I/GbY1NfOR0tc6pKXSqtVy5B7/Kaj
         G7XtfW5XDFYo3gg0ZRdJGHlGeymGO2Hb8pqp/9Raiz4/4V+7HnvKH4WK8MhGPHUsyHsZ
         iFWVrqpmsV44FCSO7UFAh+1y71RgcUw/s2LQroDOCij8mG+ik26gmn2EHf6blcV6D8Ms
         99upSvAMiEkg2TKlCYb6uwfzarV3ibEbVcmpDatvpzI5jchuVyW6y2b+H8rng6Ew+nUR
         rbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3EJnxWQkYohSZ2rAj4ItXzUJ9TVbm4aLrUteT72d3A=;
        b=EgvQteZlMELJimVdOFDoZo21SttOlbSrFn/AkT63uHD4GIGL1CqoXhmnTxcV/d57pI
         1zBGnpPlxncX0PMYcmpsYhgyspasGQhCXcHEK3Co8g3IuVYMDbWMzLNOQyp5zRZ2DWxn
         xs1CP+zJ2PagAmLtGM7QhgT+7bIlDZ1UPYRpAUSrsjuLi5mzfL/X0wUFsBu/9isGHvGe
         NQEoTRa0o3GChXSIuVToiPSIiDmAizJEApcWLtPWGN9TQzTx6adoknqksURAmQ3uicUq
         L0zvLZef1ZJAJ+UQTjW/GKxbSd8mEqYA72QD2bhpzgNoWtPMDLr17sCjR604d6LvJUhQ
         xJpQ==
X-Gm-Message-State: AOAM530n0TEdhlSefcpac2xriSQ49ELAs2hdxGBaDMZ6FN/y38+ryI7h
        guu1IJcV3t3a0aKzRKljbb/46xjF8a8DW3lHciw=
X-Google-Smtp-Source: ABdhPJx9rE+ks+Ak9GzAAif7Jx9Y/4tgo8mmlirrX7LgYuzfpe8T95R1tDEktzABOWa4HQ1vg2GEtKXPOIVyUv6JqKc=
X-Received: by 2002:a37:a655:: with SMTP id p82mr23863195qke.92.1595875906536;
 Mon, 27 Jul 2020 11:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200722064603.3350758-1-andriin@fb.com> <20200722064603.3350758-4-andriin@fb.com>
 <pj41zla6zl88le.fsf@ua97a68a4e7db56.ant.amazon.com>
In-Reply-To: <pj41zla6zl88le.fsf@ua97a68a4e7db56.ant.amazon.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 11:51:35 -0700
Message-ID: <CAEf4Bzb1_mQVxjmLEK0OFBdfnFi8To4fH-=kJTs8nz6xq7zUMw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program
 attachment logic
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 5:08 AM Shay Agroskin <shayagr@amazon.com> wrote:
>
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Further refactor XDP attachment code. dev_change_xdp_fd() is
> > split into two
> > parts: getting bpf_progs from FDs and attachment logic, working
> > with
> > bpf_progs. This makes attachment  logic a bit more
> > straightforward and
> > prepares code for bpf_xdp_link inclusion, which will share the
> > common logic.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  net/core/dev.c | 165
> >  +++++++++++++++++++++++++++----------------------
> >  1 file changed, 91 insertions(+), 74 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 7e753e248cef..abf573b2dcf4 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8815,111 +8815,128 @@ static void dev_xdp_uninstall(struct
> > net_device *dev)
> >       }
> >  }
> >
> > -/**
> > - *   dev_change_xdp_fd - set or clear a bpf program for a
> > device rx path
> > - *   @dev: device
> > - *   @extack: netlink extended ack
> > - *   @fd: new program fd or negative value to clear
> > - *   @expected_fd: old program fd that userspace expects to
> > replace or clear
> > - *   @flags: xdp-related flags
> > - *
> > - *   Set or clear a bpf program for a device
> > - */
> > -int dev_change_xdp_fd(struct net_device *dev, struct
> > netlink_ext_ack *extack,
> > -                   int fd, int expected_fd, u32 flags)
> > +static int dev_xdp_attach(struct net_device *dev, struct
> > netlink_ext_ack *extack,
> > +                       struct bpf_prog *new_prog, struct
> > bpf_prog *old_prog,
> > +                       u32 flags)
> >  {
> > -     const struct net_device_ops *ops = dev->netdev_ops;
> > -     enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> > -     bool offload = mode == XDP_MODE_HW;
> > -     u32 prog_id, expected_id = 0;
> > -     struct bpf_prog *prog;
> > +     struct bpf_prog *cur_prog;
> > +     enum bpf_xdp_mode mode;
> >       bpf_op_t bpf_op;
> >       int err;
> >
> >       ASSERT_RTNL();
> >
> > -     bpf_op = dev_xdp_bpf_op(dev, mode);
> > -     if (!bpf_op) {
> > -             NL_SET_ERR_MSG(extack, "underlying driver does not
> > support XDP in native mode");
> > -             return -EOPNOTSUPP;
> > +     /* just one XDP mode bit should be set, zero defaults to
> > SKB mode */
> > +     if (hweight32(flags & XDP_FLAGS_MODES) > 1) {
>
> Not sure if it's more efficient but running
>     if ((flags & XDP) & ((flags & XDP) - 1) != 0)
>
> returns whether a number is a multiple of 2.
> Should be equivalent to what you checked with hweight32. It is
> less readable though. Just thought I'd throw that in.

so I just preserved what is there in netlink-handling code. It also is
not a performance-critical part. What you propose might work, but
using hweight32 is more explicit about allowing zero or one bits set.


> Taken from
> https://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2
>
> > +             NL_SET_ERR_MSG(extack, "Only one XDP mode flag can
> > be set");
> > +             return -EINVAL;
> > +     }
> > +     /* old_prog != NULL implies XDP_FLAGS_REPLACE is set */
> > +     if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
> > +             NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not
> > specified");
> > +             return -EINVAL;
> >       }
> >

[...]
