Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9498D22A026
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgGVT3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 15:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGVT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:29:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F20FC0619DC;
        Wed, 22 Jul 2020 12:29:46 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 11so3181187qkn.2;
        Wed, 22 Jul 2020 12:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xZj4a1I1eoyM6Eu5QvWwElnSzcPfRXheoyGGEEAS7yA=;
        b=CiCgvQ04KP5JoST/NTymvcMU9DC1TEPbToADh0TV5cPuEt3S2mPtDTgL9EmUU3EFca
         XgAIPzhK3vUTbUaZq/EfUg35p2gkyjlsbNJB1RP9YxcWSEn45Mo+p44CazzoEcEYTpGZ
         P2hKs7DZz5ib9GWkGb04KyALjuE6MTRzRbJ8qUh97Mb3sDyMVvd1Q63txn3J+tuW7kt6
         aDQzxC9LywwmPxB3JvXIWn8CFB2Yg2dGAcgyiWdFETSvg3oPS8JvUJTeLJAZADMWLBBC
         fotoMNFMcyEMM3eiF1O1dgQxVf4/BBXI3quHhAMqWx4k44udaWOcrDyy4XQK4MchDPtN
         yLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xZj4a1I1eoyM6Eu5QvWwElnSzcPfRXheoyGGEEAS7yA=;
        b=XCRIgNb6QrSrpUb8/3M20Czx7izC3BgGoIHCm85dk+TWDolm7NUIS9N2uwDlyRK4Qd
         fOqDl61FxsFH4GohYDmvFajAURUQobYxbTkmE8xyzpjeqQsJykupJrydemVYAfj/CdZs
         uj5MLIS6OR6GZivzntgxthj6EfXCg/S376lpPqH0jmvlcMV1/Wm8zqlyvVcMKvNCeuwG
         vylmGArmQl3DlL7eXmas9FtXsyohAceUFIjvf+McugaySN6T5ov8NQWF/p6sK8+ucOd2
         79Li9u9qsvjqh1MSoi/zmzEhwtVqm9W+BjfH+XLZfyS12KimO/q4iFEzZE6/VNvz7sNh
         QvDw==
X-Gm-Message-State: AOAM531XmeTyAlTgxWxDrMbhCz2N7Drx5A8n4fnmUHhMKlBe2MtRf9Fd
        H8cyH868YA4zhgln9rhVZ1z6ao7SjcBcCUOC3sw=
X-Google-Smtp-Source: ABdhPJytrg0sX78is8hzMVBvt5+KZaNRZZb2BSnc+c9z1f30kn3alz0B6IoSgprjUpyf3cGEGmUZ7dko/8GJfbGwhfY=
X-Received: by 2002:a37:7683:: with SMTP id r125mr1632754qkc.39.1595446185649;
 Wed, 22 Jul 2020 12:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200722064603.3350758-1-andriin@fb.com> <20200722064603.3350758-4-andriin@fb.com>
 <20200722191320.GC8874@ranger.igk.intel.com>
In-Reply-To: <20200722191320.GC8874@ranger.igk.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Jul 2020 12:29:34 -0700
Message-ID: <CAEf4BzZ-YVaj1rkZGjAe5Fc=rQKUzWCTpiCgRLNhuWmfDXRwUQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program
 attachment logic
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

On Wed, Jul 22, 2020 at 12:18 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Jul 21, 2020 at 11:45:56PM -0700, Andrii Nakryiko wrote:
> > Further refactor XDP attachment code. dev_change_xdp_fd() is split into two
> > parts: getting bpf_progs from FDs and attachment logic, working with
> > bpf_progs. This makes attachment  logic a bit more straightforward and
> > prepares code for bpf_xdp_link inclusion, which will share the common logic.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  net/core/dev.c | 165 +++++++++++++++++++++++++++----------------------
> >  1 file changed, 91 insertions(+), 74 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 7e753e248cef..abf573b2dcf4 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8815,111 +8815,128 @@ static void dev_xdp_uninstall(struct net_device *dev)
> >       }
> >  }
> >
> > -/**
> > - *   dev_change_xdp_fd - set or clear a bpf program for a device rx path
> > - *   @dev: device
> > - *   @extack: netlink extended ack
> > - *   @fd: new program fd or negative value to clear
> > - *   @expected_fd: old program fd that userspace expects to replace or clear
> > - *   @flags: xdp-related flags
> > - *
> > - *   Set or clear a bpf program for a device
> > - */
> > -int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> > -                   int fd, int expected_fd, u32 flags)
> > +static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack,
> > +                       struct bpf_prog *new_prog, struct bpf_prog *old_prog,
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
>
> couldn't we rely on caller's rtnl assertion? dev_change_xdp_fd() already
> has one.

dev_xdp_attach() is also used from the bpf_link attaching function
(dev_xdp_attach_link() in the later patch). I can remove ASSERT_RTNL()
from dev_change_xdp_fd(), though, it doesn't have to do that check, if
dev_xdp_attach() does it already.

[...]

> > -
> > -             if (prog->expected_attach_type == BPF_XDP_CPUMAP) {
> > -                     NL_SET_ERR_MSG(extack,
> > -                                    "BPF_XDP_CPUMAP programs can not be attached to a device");
> > -                     bpf_prog_put(prog);
> > +             if (new_prog->expected_attach_type == BPF_XDP_CPUMAP) {
> > +                     NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached to a device");
>
> bpf_prog_put() missing?
>

Nope, program putting on error is handled outside the
dev_xdp_attach(), either by bpf() LINK_CREATE handling logic or by
dev_change_xdp_fd().

> >                       return -EINVAL;
> >               }
> > +     }
> >

[...]
