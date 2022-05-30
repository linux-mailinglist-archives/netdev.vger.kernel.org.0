Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348155385A3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242644AbiE3P6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242326AbiE3P6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:58:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3E2811177
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653925812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LHfTPjbR/ocaEKI2euekEd9CUNVAA+DZiRkvQmDrTN0=;
        b=cWj2qW6em3UkLnL8lLF3h+s109+cTNhCSf29FcUozL2YwjAgEnMugiBl9yCd+MBLKBOFJv
        hkdUqdhFFDmTzdek+9+P9VKllpYNLiE++BGH/XKbQIuSVZZUdWaCLsssGqIWxE3+lpodsz
        lLvDDirTVxvPR5oqnuxjiBcv8r36ChU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-vwVA18kTMTOa9_58itkvlA-1; Mon, 30 May 2022 11:50:11 -0400
X-MC-Unique: vwVA18kTMTOa9_58itkvlA-1
Received: by mail-pg1-f200.google.com with SMTP id w32-20020a631620000000b003fbb0d4d3ffso3165234pgl.21
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHfTPjbR/ocaEKI2euekEd9CUNVAA+DZiRkvQmDrTN0=;
        b=aBkX6sjAboCjN/OncHAo6SvdoRGIvTt5snEsuzGZBt4sSEr+kQIS4MzMr0xi1ogNNP
         51j7KwQslDMiSjSRWis17n3w1pW4OWGmHeqOl5GL7qCMin/si3XSjokhVEnuEzuayI6+
         pSTkWkFRul+5ngshWeWDVjiO5wggyOe/K/BRLPgp2rQSbtedy34UAg1JH1HJngOd3gQ+
         0/XKtl8PQwfv/7OOZWa2aIs6441v8oS8rRdB974C/vC7/7vvfTqKlqacYEqVyTj01107
         5f5RXNiN8E5VhBKh98QKLrYaKCIrfSvdi80/R9Ri5hh0QQTRwD4QS3Gzc7LYEmMiQypU
         Hxzw==
X-Gm-Message-State: AOAM533UMJcSjxfpOd1oV6nE6pnvR2EykEdnWLffy4eX5N3QQW8L4DOE
        rtIR3lI9xQmhPbLE1ba+7Jhrsi1drq+3Zjg63u91uahQIHsI5FCRIF5qDK7fWlsW7BPDKBCB0tM
        didWCfKdaE5lcld73CZmXn9ANEgt2o/0o
X-Received: by 2002:a17:902:c412:b0:161:af8b:f478 with SMTP id k18-20020a170902c41200b00161af8bf478mr57106613plk.67.1653925809332;
        Mon, 30 May 2022 08:50:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwt/D2VuCWPTO7sVCA8hoMuQ8Fn3PJTSQG33YbBFyxoNdQnbLzbKX3nn4EZ/Unmr7KcDDyuk40Jn4yLRKcdgdY=
X-Received: by 2002:a17:902:c412:b0:161:af8b:f478 with SMTP id
 k18-20020a170902c41200b00161af8bf478mr57106583plk.67.1653925809012; Mon, 30
 May 2022 08:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com> <799ae406-ce12-f0d4-d213-4dd455236e49@linux.intel.com>
In-Reply-To: <799ae406-ce12-f0d4-d213-4dd455236e49@linux.intel.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 30 May 2022 17:49:57 +0200
Message-ID: <CAO-hwJJwznZqLgeULJ+fksH0VfJ4Jjszut_+zZgi2KEUyPCdbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
To:     Tero Kristo <tero.kristo@linux.intel.com>
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
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tero,

On Fri, May 27, 2022 at 9:26 AM Tero Kristo <tero.kristo@linux.intel.com> wrote:
>
> Hi Benjamin,
>
> I noticed a couple of issues with this series, but was able to
> fix/workaround them locally and got my USI program working with it.
>
> 1) You seem to be missing tools/include/uapi/linux/hid_bpf.h from index,
> I wasn't able to compile the selftests (or my own program) without
> adding this. It is included from
> tools/testing/selftests/bpf/prog_tests/hid.c: #include <linux/hid_bpf.h>

Hmm... I initially thought that this would be "fixed" when the kernel
headers are properly installed, so I don't need to manually keep a
duplicate in the tools tree. But now that you mention it, I probably
need to do it the way you mention it.

>
> 2) The limitation of needing to hardcode the size for hid_bpf_get_data()
> seems somewhat worrying, especially as the kernel side limits this to
> the ctx->allocated_size. I used a sufficiently large number for my
> purposes for now (256) which seems to work, but how should I handle my
> case where I basically need to read the whole input report and parse
> certain portions of it? How does the HID subsystem select the size of
> the ctx->allocated_size?

The allocated size is based on the maximum size of the reports allowed
in the device. It is dynamically computed based on the report
descriptor.

I also had the exact same issue you mentioned (dynamically retrieve
the whole report), and that's why I added a couple of things:
- struct hid_bpf_ctx->allocated_size which gives the allocated size,
so you can use this as an upper bound in a for loop
- the allocated size is guaranteed to be a multiple of 64 bytes.

Which means you can have the following for loop:

for (i = 0; i * 64 < hid_ctx->allocated_size && i < 64; i++) {
  data = hid_bpf_get_data(hid_ctx, i * 64, 64);
  /* some more processing */
}

("i < 64" makes an upper bound of 4KB of data, which should be enough
in most cases).

Cheers,
Benjamin

>
> -Tero
>
> On 18/05/2022 23:59, Benjamin Tissoires wrote:
> > Hi,
> >
> > And here comes the v5 of the HID-BPF series.
> >
> > I managed to achive the same functionalities than v3 this time.
> > Handling per-device BPF program was "interesting" to say the least,
> > but I don't know if we can have a generic BPF way of handling such
> > situation.
> >
> > The interesting bits is that now the BPF core changes are rather small,
> > and I am mostly using existing facilities.
> > I didn't managed to write selftests for the RET_PTR_TO_MEM kfunc,
> > because I can not call kmalloc while in a SEC("tc") program to match
> > what the other kfunc tests are doing.
> > And AFAICT, the most interesting bits would be to implement verifier
> > selftests, which are way out of my league, given that they are
> > implemented as plain bytecode.
> >
> > The logic is the following (see also the last patch for some more
> > documentation):
> > - hid-bpf first preloads a BPF program in the kernel that does a few
> >    things:
> >     * find out which attach_btf_id are associated with our trace points
> >     * adds a bpf_tail_call() BPF program that I can use to "call" any
> >       other BPF program stored into a jump table
> >     * monitors the releases of struct bpf_prog, and when there are no
> >       other users than us, detach the bpf progs from the HID devices
> > - users then declare their tracepoints and then call
> >    hid_bpf_attach_prog() in a SEC("syscall") program
> > - hid-bpf then calls multiple time the bpf_tail_call() program with a
> >    different index in the jump table whenever there is an event coming
> >    from a matching HID device
> >
> > Note that I am tempted to pin an "attach_hid_program" in the bpffs so
> > that users don't need to declare one, but I am afraid this will be one
> > more API to handle, so maybe not.
> >
> > I am also wondering if I should not strip out hid_bpf_jmp_table of most
> > of its features and implement everything as a BPF program. This might
> > remove the need to add the kernel light skeleton implementations of map
> > modifications, and might also possibly be more re-usable for other
> > subsystems. But every plan I do in my head involves a lot of back and
> > forth between the kernel and BPF to achieve the same, which doesn't feel
> > right. The tricky part is the RCU list of programs that is stored in each
> > device and also the global state of the jump table.
> > Anyway, something to look for in a next version if there is a push for it.
> >
> > FWIW, patch 1 is something I'd like to get merged sooner. With 2
> > colleagues, we are also working on supporting the "revoke" functionality
> > of a fd for USB and for hidraw. While hidraw can be emulated with the
> > current features, we need the syscall kfuncs for USB, because when we
> > revoke a USB access, we also need to kick out the user, and for that, we
> > need to actually execute code in the kernel from a userspace event.
> >
> > Anyway, happy reviewing.
> >
> > Cheers,
> > Benjamin
> >
> > [Patch series based on commit 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
> > in the bpf-next tree]
> >
> > Benjamin Tissoires (17):
> >    bpf/btf: also allow kfunc in tracing and syscall programs
> >    bpf/verifier: allow kfunc to return an allocated mem
> >    bpf: prepare for more bpf syscall to be used from kernel and user
> >      space.
> >    libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
> >    HID: core: store the unique system identifier in hid_device
> >    HID: export hid_report_type to uapi
> >    HID: initial BPF implementation
> >    selftests/bpf: add tests for the HID-bpf initial implementation
> >    HID: bpf: allocate data memory for device_event BPF programs
> >    selftests/bpf/hid: add test to change the report size
> >    HID: bpf: introduce hid_hw_request()
> >    selftests/bpf: add tests for bpf_hid_hw_request
> >    HID: bpf: allow to change the report descriptor
> >    selftests/bpf: add report descriptor fixup tests
> >    samples/bpf: add new hid_mouse example
> >    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
> >    Documentation: add HID-BPF docs
> >
> >   Documentation/hid/hid-bpf.rst                 | 528 ++++++++++
> >   Documentation/hid/index.rst                   |   1 +
> >   drivers/hid/Kconfig                           |   2 +
> >   drivers/hid/Makefile                          |   2 +
> >   drivers/hid/bpf/Kconfig                       |  19 +
> >   drivers/hid/bpf/Makefile                      |  11 +
> >   drivers/hid/bpf/entrypoints/Makefile          |  88 ++
> >   drivers/hid/bpf/entrypoints/README            |   4 +
> >   drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  78 ++
> >   .../hid/bpf/entrypoints/entrypoints.lskel.h   | 782 ++++++++++++++
> >   drivers/hid/bpf/hid_bpf_dispatch.c            | 565 ++++++++++
> >   drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
> >   drivers/hid/bpf/hid_bpf_jmp_table.c           | 587 +++++++++++
> >   drivers/hid/hid-core.c                        |  43 +-
> >   include/linux/btf.h                           |   7 +
> >   include/linux/hid.h                           |  29 +-
> >   include/linux/hid_bpf.h                       | 144 +++
> >   include/uapi/linux/hid.h                      |  12 +
> >   include/uapi/linux/hid_bpf.h                  |  25 +
> >   kernel/bpf/btf.c                              |  47 +-
> >   kernel/bpf/syscall.c                          |  10 +-
> >   kernel/bpf/verifier.c                         |  72 +-
> >   samples/bpf/.gitignore                        |   1 +
> >   samples/bpf/Makefile                          |  23 +
> >   samples/bpf/hid_mouse.bpf.c                   | 134 +++
> >   samples/bpf/hid_mouse.c                       | 157 +++
> >   tools/lib/bpf/skel_internal.h                 |  23 +
> >   tools/testing/selftests/bpf/config            |   3 +
> >   tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
> >   tools/testing/selftests/bpf/progs/hid.c       | 222 ++++
> >   30 files changed, 4593 insertions(+), 44 deletions(-)
> >   create mode 100644 Documentation/hid/hid-bpf.rst
> >   create mode 100644 drivers/hid/bpf/Kconfig
> >   create mode 100644 drivers/hid/bpf/Makefile
> >   create mode 100644 drivers/hid/bpf/entrypoints/Makefile
> >   create mode 100644 drivers/hid/bpf/entrypoints/README
> >   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
> >   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
> >   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
> >   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
> >   create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
> >   create mode 100644 include/linux/hid_bpf.h
> >   create mode 100644 include/uapi/linux/hid_bpf.h
> >   create mode 100644 samples/bpf/hid_mouse.bpf.c
> >   create mode 100644 samples/bpf/hid_mouse.c
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
> >
>

