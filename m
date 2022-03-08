Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37C24D0D1A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344148AbiCHA6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344216AbiCHA6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:58:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334551155;
        Mon,  7 Mar 2022 16:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF68B8175C;
        Tue,  8 Mar 2022 00:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A38C340F7;
        Tue,  8 Mar 2022 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646701029;
        bh=je9wh1jfc8vKoLFB/XMs5xZvr+6tezIiCo7tP89tgpY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RtO0co1gSFJwkq5vXNLxKNXO9f+Lqdl/mTUmq3ywOT33iUb4fS3ofFh/GNVp3Qjw+
         +uzyYNtR5S34pDPFvE4ay2DXgKx2v1Cko9Re1wcy5Ov6cNEVTgmu/A3mEHiUSo8lvZ
         nycf7fbdhQ5/WKRcp9H+y3P+Pnn/jffuuYCmfsNg/r9k6l6c/Yvl3MZmOwyWd8+ycx
         /PaAZcNPWQ9UNuvfgUENYGupOJ4rLXnVV+/knXC57CkiHPMTee7WloB3QvyXWpMWv5
         VOtax9kU/mu2L4xvOPP36dLjxchYBMp7CYManYIXd/f5W/MkTRrZSz16q34atGJ0xm
         gjoieoE60I1Gw==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2dc242a79beso174466237b3.8;
        Mon, 07 Mar 2022 16:57:09 -0800 (PST)
X-Gm-Message-State: AOAM531+Xug1aIvWcWQ7dnvy0PBoOEpw99I0r/RvTmHukYfGLwH5SEaz
        nA/PVsLf9fc9biRWgGvJs6kYjoFmdl2r1sBDyqg=
X-Google-Smtp-Source: ABdhPJw5iu98Yx0WOcx2dkiKYmMKSq7PTAddXcLAeBR9h8z6v4BOKZMtV6hsGVJoY6yvheeO6z4E3FZsWGXfPBMxJBI=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr11184300ywf.447.1646701028244; Mon, 07
 Mar 2022 16:57:08 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-3-benjamin.tissoires@redhat.com> <CAPhsuW5CYF9isR4ffRdm3xA_n_FBoL+AGFkzNn4dn2LgRaQQkg@mail.gmail.com>
 <CAO-hwJKFE4Ps962BBubn8=1K0k9mC2qi8VerFbZo1sqpp6yekg@mail.gmail.com>
In-Reply-To: <CAO-hwJKFE4Ps962BBubn8=1K0k9mC2qi8VerFbZo1sqpp6yekg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Mar 2022 16:56:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5mZQ-N7RCndxP0RNi669RU5Tbu-Uu0M-KW2-mPYZbbng@mail.gmail.com>
Message-ID: <CAPhsuW5mZQ-N7RCndxP0RNi669RU5Tbu-Uu0M-KW2-mPYZbbng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/28] bpf: introduce hid program type
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 10:39 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Sat, Mar 5, 2022 at 1:03 AM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > HID is a protocol that could benefit from using BPF too.
> >
> > [...]
> >
> > > +#include <linux/list.h>
> > > +#include <linux/slab.h>
> > > +
> > > +struct bpf_prog;
> > > +struct bpf_prog_array;
> > > +struct hid_device;
> > > +
> > > +enum bpf_hid_attach_type {
> > > +       BPF_HID_ATTACH_INVALID = -1,
> > > +       BPF_HID_ATTACH_DEVICE_EVENT = 0,
> > > +       MAX_BPF_HID_ATTACH_TYPE
> >
> > Is it typical to have different BPF programs for different attach types?
> > Otherwise, (different types may have similar BPF programs), maybe
> > we can pass type as an argument to the program (shared among
> > different types)?
>
> Not quite sure I am entirely following you, but I consider the various
> attach types to be quite different and thus you can not really reuse
> the same BPF program with 2 different attach types.
>
> In my view, we have 4 attach types:
> - BPF_HID_ATTACH_DEVICE_EVENT: called whenever we receive an IRQ from
> the given device (so this is net-like event stream)
> - BPF_HID_ATTACH_RDESC_FIXUP: there can be only one of this type, and
> this is called to change the device capabilities. So you can not reuse
> the other programs for this one
> - BPF_HID_ATTACH_USER_EVENT: called explicitly by the userspace
> process owning the program. There we can use functions that are
> sleeping (we are not in IRQ context), so this is also fundamentally
> different from the 3 others.
> - BPF_HID_ATTACH_DRIVER_EVENT: whenever the driver gets called into,
> we get a bpf program run. This can be suspend/resume, or even specific
> request to the device (change a feature on the device or get its
> current state). Again, IMO fundamentally different from the others.
>
> So I'm open to any suggestions, but if we can keep the userspace API
> being defined with different SEC in libbpf, that would be the best.

Thanks for this information. Different attach_types sound right for the use
case.

>
> >
> > [...]
> >
> > > +struct hid_device;
> > > +
> > > +enum hid_bpf_event {
> > > +       HID_BPF_UNDEF = 0,
> > > +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> > > +};
> > > +
> > > +struct hid_bpf_ctx {
> > > +       enum hid_bpf_event type;        /* read-only */
> > > +       __u16 allocated_size;           /* the allocated size of data below (RO) */
> >
> > There is a (6-byte?) hole here.
> >
> > > +       struct hid_device *hdev;        /* read-only */
> > > +
> > > +       __u16 size;                     /* used size in data (RW) */
> > > +       __u8 data[];                    /* data buffer (RW) */
> > > +};
> >
> > Do we really need hit_bpf_ctx in uapi? Maybe we can just use it
> > from vmlinuxh?
>
> I had a thought at this context today, and I think I am getting to the
> limit of what I understand.
>
> My first worry is that the way I wrote it there, with a variable data
> field length is that this is not forward compatible. Unless BTF and
> CORE are making magic, this will bite me in the long run IMO.
>
> But then, you are talking about not using uapi, and I am starting to
> wonder: am I doing the things correctly?
>
> To solve my first issue (and the weird API I had to introduce in the
> bpf_hid_get/set_data), I came up to the following:
> instead of exporting the data directly in the context, I could create
> a helper bpf_hid_get_data_buf(ctx, const uint size) that returns a
> RET_PTR_TO_ALLOC_MEM_OR_NULL in the same way bpf_ringbuf_reserve()
> does.
>
> This way, I can directly access the fields within the bpf program
> without having to worry about the size.
>
> But now, I am wondering whether the uapi I defined here is correct in
> the way CORE works.
>
> My goal is to have HID-BPF programs to be CORE compatible, and not
> have to recompile them depending on the underlying kernel.
>
> I can not understand right now if I need to add some other BTF helpers
> in the same way the access to struct xdp_md and struct xdp_buff are
> converted between one and other, or if defining a forward compatible
> struct hid_bpf_ctx is enough.
> As far as I understand, .convert_ctx_access allows to export a stable
> uapi to the bpf prog users with the verifier doing the conversion
> between the structs for me. But is this really required for all the
> BPF programs if we want them to be CORE?
>
> Also, I am starting to wonder if I should not hide fields in the
> context to the users. The .data field could be a pointer and only
> accessed through the helper I mentioned above. This would be forward
> compatible, and also allows to use whatever available memory in the
> kernel to be forwarded to the BPF program. This way I can skip the
> memcpy part and work directly with the incoming dma data buffer from
> the IRQ.
>
> But is it best practice to do such a thing?

I think .convert_ctx_access is the way to go if we want to access the data
buffer without memcpy. I am not sure how much work is needed to make
it compatible with CORE though.

To make sure I understand the case, do we want something like

bpf_prog(struct hid_bpf_ctx *ctx)
{
    /* makes sure n < ctx->size */
    x = ctx->data[n]; /* read data */
    ctx->data[n] = <something>; /* write data */
    ctx->size = <something <= n>; /* change data size */
}

We also need it to be CORE, so that we may modify hid_bpf_ctx by
inserting more members to it before data.

Is this accurate?

Song
