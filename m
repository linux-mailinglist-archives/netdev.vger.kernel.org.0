Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BC34E337A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiCUWvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiCUWvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:51:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C08765AD;
        Mon, 21 Mar 2022 15:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F3D7612AF;
        Mon, 21 Mar 2022 21:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DBAC340E8;
        Mon, 21 Mar 2022 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899522;
        bh=4QhNB4U5yqvJwvu7RDkVWcIdf4LcwWmmFOFLShPBW6o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gFMSq3ffEzu1h8hOXbIVCubQny+yp3noE6EgcB47LCCaUdKyDUCjM/Gb7S9loYWXR
         Dy9A7xXkoC9lKQUEgP4RUVZ9QwiZOot99c+H4DpG0lIJVawEbpgaG5bVI6hQkK8V9X
         ZLFS1MmC0zVnDIiWCjBVQ0HUbCxFjhgId0GiaocHq4/a23g95OLokdjaJLHPzSCnUn
         VX47VlafdEwFzcEQCtLgbopLbP0f57Q4O3rUZ755wf1FBF+n8gd79anPOLJF7BAzFf
         BMUKcH8Txef+aUKhnwdkOLEdav9sE9we0HiwkmIWhfU3T8mYyCA1zNUSyVocsWIuVy
         TN7T4qJwBb/6w==
Received: by mail-yb1-f177.google.com with SMTP id t11so30522809ybi.6;
        Mon, 21 Mar 2022 14:52:02 -0700 (PDT)
X-Gm-Message-State: AOAM5323YyW49WrPS8Lp+sNrfSAUm1CNYR7VSRUzJLVLgipmp7L0yfdU
        KPW/jUGXcgOgyGoTyKTqgqyaX0PzTZJh17FkS6M=
X-Google-Smtp-Source: ABdhPJxjGIOAMCTeBOhtLKMEA7eHCjAjE7I4xUoxWVAUgKRZLQc4bIwIq4yvPoes8lioBv1QfOq4MXGYC+JLAx43Ug4=
X-Received: by 2002:a25:40d3:0:b0:633:bb21:2860 with SMTP id
 n202-20020a2540d3000000b00633bb212860mr16895055yba.9.1647899521925; Mon, 21
 Mar 2022 14:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-3-benjamin.tissoires@redhat.com> <CAPhsuW5qseqVs4=hz3VvSJ2ObqB2kTbKXoaOCh=5vjoU_AXnKQ@mail.gmail.com>
 <CAO-hwJ+WSi645HhNV_BYACoJe2UTc4KZzqH0oHocfnBR8xUYEQ@mail.gmail.com>
In-Reply-To: <CAO-hwJ+WSi645HhNV_BYACoJe2UTc4KZzqH0oHocfnBR8xUYEQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Mar 2022 14:51:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4+b66Keh_f+UoApM8UenhnJ5wD_SaatAFDms9=g7ENyw@mail.gmail.com>
Message-ID: <CAPhsuW4+b66Keh_f+UoApM8UenhnJ5wD_SaatAFDms9=g7ENyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: introduce hid program type
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 9:07 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi Song,
>
> many thanks for the quick response.
>
> On Fri, Mar 18, 2022 at 9:48 PM Song Liu <song@kernel.org> wrote:
[...]
> >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >
> > We need to mirror these changes to tools/include/uapi/linux/bpf.h.
>
> OK. I did that in patch 4/17 but I can bring in the changes there too.

Let's keep changes to the two files in the same patch. This will make
sure they are back ported together.

[...]
> > > +enum hid_bpf_event {
> > > +       HID_BPF_UNDEF = 0,
> > > +       HID_BPF_DEVICE_EVENT,           /* when attach type is BPF_HID_DEVICE_EVENT */
> > > +       HID_BPF_RDESC_FIXUP,            /* ................... BPF_HID_RDESC_FIXUP */
> > > +       HID_BPF_USER_EVENT,             /* ................... BPF_HID_USER_EVENT */
> >
> > Why don't we have a DRIVER_EVENT type here?
>
> For driver event, I want to have a little bit more of information
> which tells which event we have:
> - HID_BPF_DRIVER_PROBE
> - HID_BPF_DRIVER_SUSPEND
> - HID_BPF_DRIVER_RAW_REQUEST
> - HID_BPF_DRIVER_RAW_REQUEST_ANSWER
> - etc...
>
> However, I am not entirely sure on the implementation of all of those,
> so I left them aside for now.
>
> I'll work on that for v4.

This set is already pretty big. I guess we can add them in a follow-up set.

>
> >
> > >
> > [...]
> > > +
> > > +BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
> > > +{
> > > +       if (!size)
> > > +               return 0UL;
> > > +
> > > +       if (offset + size > ctx->allocated_size)
> > > +               return 0UL;
> > > +
> > > +       return (unsigned long)(ctx->data + offset);
> > > +}
> > > +
> > > +static const struct bpf_func_proto bpf_hid_get_data_proto = {
> > > +       .func      = bpf_hid_get_data,
> > > +       .gpl_only  = true,
> > > +       .ret_type  = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> > > +       .arg1_type = ARG_PTR_TO_CTX,
> > > +       .arg2_type = ARG_ANYTHING,
> > > +       .arg3_type = ARG_CONST_ALLOC_SIZE_OR_ZERO,
> >
> > I think we should use ARG_CONST_SIZE or ARG_CONST_SIZE_OR_ZERO?
>
> I initially tried this with ARG_CONST_SIZE_OR_ZERO but it doesn't work
> for 2 reasons:
> - we need to pair the argument ARG_CONST_SIZE_* with a pointer to a
> memory just before, which doesn't really make sense here
> - ARG_CONST_SIZE_* isn't handled in the same way
> ARG_CONST_ALLOC_SIZE_OR_ZERO is. The latter tells the verifier that
> the given size is the available size of the returned
> PTR_TO_ALLOC_MEM_OR_NULL, which is exactly what we want.

I misread the logic initially. It makes sense now.

>
> >
> > > +};
> > > +
> > > +static const struct bpf_func_proto *
> > > +hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > > +{
> > > +       switch (func_id) {
> > > +       case BPF_FUNC_hid_get_data:
> > > +               return &bpf_hid_get_data_proto;
> > > +       default:
> > > +               return bpf_base_func_proto(func_id);
> > > +       }
> > > +}
> > [...]
> > > +
> > > +static int hid_bpf_prog_test_run(struct bpf_prog *prog,
> > > +                                const union bpf_attr *attr,
> > > +                                union bpf_attr __user *uattr)
> > > +{
> > > +       struct hid_device *hdev = NULL;
> > > +       struct bpf_prog_array *progs;
> > > +       bool valid_prog = false;
> > > +       int i;
> > > +       int target_fd, ret;
> > > +       void __user *data_out = u64_to_user_ptr(attr->test.data_out);
> > > +       void __user *data_in = u64_to_user_ptr(attr->test.data_in);
> > > +       u32 user_size_in = attr->test.data_size_in;
> > > +       u32 user_size_out = attr->test.data_size_out;
> > > +       u32 allocated_size = max(user_size_in, user_size_out);
> > > +       struct hid_bpf_ctx_kern ctx = {
> > > +               .type = HID_BPF_USER_EVENT,
> > > +               .allocated_size = allocated_size,
> > > +       };
> > > +
> > > +       if (!hid_hooks.hdev_from_fd)
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       if (attr->test.ctx_size_in != sizeof(int))
> > > +               return -EINVAL;
> >
> > ctx_size_in is always 4 bytes?
>
> Yes. Basically what I had in mind is that the "ctx" for
> user_prog_test_run is the file descriptor to the sysfs that represent
> the HID device.
> This seemed to me to be the easiest to handle for users.
>
> I'm open to suggestions though.

How about we use data_in? ctx for test_run usually means the program ctx,
which is struct hid_bpf_ctx here.

Thanks,
Song
