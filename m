Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6204EEA8A
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 11:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344663AbiDAJjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344670AbiDAJjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 05:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDBF126B3B0
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 02:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648805840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0M8G++tCAQg6E5BcGRGJH27i6pTcxL9PU4K81djE3PY=;
        b=RWlgAC5DDbvO8XcoUraZDurzFrNMUCswGFji3Tdivpxm851Gqkg32o5QrHaoYboDUZ8NN3
        Cf9SHXKAd55TT9tffa6cHVljv22yB+W+h3o8v9n1Z5XPvT8RXY/tHZYcuw71ZZyZ+jXOor
        5wySFY+Yr4vSQHZtMsH6YerQiiBz4iI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-AIqIrIK6N0mjv2vBZEbVJQ-1; Fri, 01 Apr 2022 05:37:20 -0400
X-MC-Unique: AIqIrIK6N0mjv2vBZEbVJQ-1
Received: by mail-pf1-f198.google.com with SMTP id k7-20020aa79727000000b004fdc86d9b79so1358156pfg.8
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 02:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0M8G++tCAQg6E5BcGRGJH27i6pTcxL9PU4K81djE3PY=;
        b=e5KYadxWMDCtdsDb/4k+qb7HAg8sioeFn2lkodcqCQXHlq2Aie4xtHmBqgCnZml7EI
         P8B5W7/abmVu6NtiVSauFU/CwpFDoCzZn1w2YzgQrNPI8z4KVC1SPDIYIR6iFZz0s1Oj
         2AX+7ua2SBq1EU6t33WD/hyABc1nqhVrIVrAqVmhSb5ZnksxH00JRax+nQk8le6sK9wY
         AEUNeMNqnzhbYblE8TvAQWfmlBYh43h6sntbQ+Fq/QUyH8bmGYhHoGs0iHkQZhhD1hxA
         w8u+loFRa4IoEWdvbDDL8zF0zTh6CNJAUhlO4CaB5EpyuTyvJmmU2y3ZYGJy1itctq/g
         qWgA==
X-Gm-Message-State: AOAM531PtLgVpmIR3y0uxNIUaXQ5SrcvdwdTthqBnaiySEsHbvoJW7lQ
        nNGSfsVCHr7ofrXovFrlXVL/NPr6jkN48aYtAO6uMyMJdNmKTjP21BnBQbWnCXYFdjakIc0YRPb
        RfJ5MtdFf5PTHUfpITMxVot3V5ZG+5NU8
X-Received: by 2002:a63:416:0:b0:386:66e:33d9 with SMTP id 22-20020a630416000000b00386066e33d9mr14527108pge.146.1648805838545;
        Fri, 01 Apr 2022 02:37:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNl+VbItEjD1pMRpgDlFu7TBQ5+iIqlAzQoVMfN+lwbwix5VCsshPmNK4HcxorDlicGYEtlxZYENovQ3UeUKk=
X-Received: by 2002:a63:416:0:b0:386:66e:33d9 with SMTP id 22-20020a630416000000b00386066e33d9mr14527085pge.146.1648805838169;
 Fri, 01 Apr 2022 02:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <0a30942b-e6c9-72fb-d012-4b8a6a16ae42@linux.intel.com>
In-Reply-To: <0a30942b-e6c9-72fb-d012-4b8a6a16ae42@linux.intel.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 1 Apr 2022 11:37:06 +0200
Message-ID: <CAO-hwJKTxPGc3BO0g2ui5MiN6J9aWybuyRnhyZPWBntnF5ng8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/17] Introduce eBPF support for HID devices
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tero,

On Tue, Mar 29, 2022 at 3:04 PM Tero Kristo <tero.kristo@linux.intel.com> wrote:
>
> Hi Benjamin,
>
> I tested this iteration of the set, and I faced couple of problems with it.
>
> 1) There were some conflicts as I could not figure out the correct
> kernel commit on which to apply the series on. I applied this on top of
> last weeks bpf-next (see below) with some local merge fixes.

Right, there was a new conflict in bpf-next, but you managed it :)

>
> commit 2af7e566a8616c278e1d7287ce86cd3900bed943 (bpf-next/master,
> bpf-next/for-next)
> Author: Saeed Mahameed <saeedm@nvidia.com>
> Date:   Tue Mar 22 10:22:24 2022 -0700
>
>      net/mlx5e: Fix build warning, detected write beyond size of field
>
> 2) hid_is_valid_access() causes some trouble and it rejects pretty much
> every BPF program which tries to use ctx->retval. This appears to be
> because prog->expected_attach_type is not populated, I had to apply
> below local tweak to overcome this problem:
>
> diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
> index 30a62e8e0f0a..bf64411e6e9b 100644
> --- a/kernel/bpf/hid.c
> +++ b/kernel/bpf/hid.c
> @@ -180,8 +180,7 @@ static bool hid_is_valid_access(int off, int size,
>          case offsetof(struct hid_bpf_ctx, retval):
>                  if (size != size_default)
>                          return false;
> -               return (prog->expected_attach_type == BPF_HID_USER_EVENT ||
> -                       prog->expected_attach_type == BPF_HID_DRIVER_EVENT);
> +               return true;
>          default:
>                  if (size != size_default)
>                          return false;
>
> Proper fix would probably be to actually populate the
> expected_attach_type, but I could not figure out quickly where this
> should be done, or whether it is actually done on some other base commit.

Hmm, this is not what I would have expected. Anyway, "return true"
would be a valid solution too, but...

>
> With those, for the whole series:
>
> Tested-by: Tero Kristo <tero.kristo@linux.intel.com>

Thanks a lot. Unfortunately, if you saw the discussion with Alexei in
patch 6/17, you'll see that there is a push toward a slightly
different implementation.

I had a meeting with Alexei, and a few other BPF folks yesterday, and
they convinced me that this series is implementing a BPF feature the
"old way", and that we should aim at having HID using standard BPF
facilities instead of having HID messing up with bpf-core.

This will be beneficial in the long term as we won't depend on BPF to
be able to add new UAPI, being BPF calls or functions.

I'll reply in more detail on 6/17.

Cheers,
Benjamin

>
> On 18/03/2022 18:15, Benjamin Tissoires wrote:
> > Hi,
> >
> > This is a followup of my v1 at [0] and v2 at [1].
> >
> > The short summary of the previous cover letter and discussions is that
> > HID could benefit from BPF for the following use cases:
> >
> > - simple fixup of report descriptor:
> >    benefits are faster development time and testing, with the produced
> >    bpf program being shipped in the kernel directly (the shipping part
> >    is *not* addressed here).
> >
> > - Universal Stylus Interface:
> >    allows a user-space program to define its own kernel interface
> >
> > - Surface Dial:
> >    somehow similar to the previous one except that userspace can decide
> >    to change the shape of the exported device
> >
> > - firewall:
> >    still partly missing there, there is not yet interception of hidraw
> >    calls, but it's coming in a followup series, I promise
> >
> > - tracing:
> >    well, tracing.
> >
> >
> > I think I addressed the comments from the previous version, but there are
> > a few things I'd like to note here:
> >
> > - I did not take the various rev-by and tested-by (thanks a lot for those)
> >    because the uapi changed significantly in v3, so I am not very confident
> >    in taking those rev-by blindly
> >
> > - I mentioned in my discussion with Song that I'll put a summary of the uapi
> >    in the cover letter, but I ended up adding a (long) file in the Documentation
> >    directory. So please maybe start by reading 17/17 to have an overview of
> >    what I want to achieve
> >
> > - I added in the libbpf and bpf the new type BPF_HID_DRIVER_EVENT, even though
> >    I don't have a user of it right now in the kernel. I wanted to have them in
> >    the docs, but we might not want to have them ready here.
> >    In terms of code, it just means that we can attach such programs types
> >    but that they will never get triggered.
> >
> > Anyway, I have been mulling on this for the past 2 weeks, and I think that
> > maybe sharing this now is better than me just starring at the code over and
> > over.
> >
> >
> > Short summary of changes:
> >
> > v3:
> > ===
> >
> > - squashed back together most of the libbpf and bpf changes into bigger
> >    commits that give a better overview of the whole interactions
> >
> > - reworked the user API to not expose .data as a directly accessible field
> >    from the context, but instead forces everyone to use hid_bpf_get_data (or
> >    get/set_bits)
> >
> > - added BPF_HID_DRIVER_EVENT (see note above)
> >
> > - addressed the various nitpicks from v2
> >
> > - added a big Documentation file (and so adding now the doc maintainers to the
> >    long list of recipients)
> >
> > v2:
> > ===
> >
> > - split the series by subsystem (bpf, HID, libbpf, selftests and
> >    samples)
> >
> > - Added an extra patch at the beginning to not require CAP_NET_ADMIN for
> >    BPF_PROG_TYPE_LIRC_MODE2 (please shout if this is wrong)
> >
> > - made the bpf context attached to HID program of dynamic size:
> >    * the first 1 kB will be able to be addressed directly
> >    * the rest can be retrieved through bpf_hid_{set|get}_data
> >      (note that I am definitivey not happy with that API, because there
> >      is part of it in bits and other in bytes. ouch)
> >
> > - added an extra patch to prevent non GPL HID bpf programs to be loaded
> >    of type BPF_PROG_TYPE_HID
> >    * same here, not really happy but I don't know where to put that check
> >      in verifier.c
> >
> > - added a new flag BPF_F_INSERT_HEAD for BPF_LINK_CREATE syscall when in
> >    used with HID program types.
> >    * this flag is used for tracing, to be able to load a program before
> >      any others that might already have been inserted and that might
> >      change the data stream.
> >
> > Cheers,
> > Benjamin
> >
> >
> >
> > [0] https://lore.kernel.org/linux-input/20220224110828.2168231-1-benjamin.tissoires@redhat.com/T/#t
> > [1] https://lore.kernel.org/linux-input/20220304172852.274126-1-benjamin.tissoires@redhat.com/T/#t
> >
> >
> > Benjamin Tissoires (17):
> >    bpf: add new is_sys_admin_prog_type() helper
> >    bpf: introduce hid program type
> >    bpf/verifier: prevent non GPL programs to be loaded against HID
> >    libbpf: add HID program type and API
> >    HID: hook up with bpf
> >    HID: allow to change the report descriptor from an eBPF program
> >    selftests/bpf: add tests for the HID-bpf initial implementation
> >    selftests/bpf: add report descriptor fixup tests
> >    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
> >    selftests/bpf: add test for user call of HID bpf programs
> >    samples/bpf: add new hid_mouse example
> >    bpf/hid: add more HID helpers
> >    HID: bpf: implement hid_bpf_get|set_bits
> >    HID: add implementation of bpf_hid_raw_request
> >    selftests/bpf: add tests for hid_{get|set}_bits helpers
> >    selftests/bpf: add tests for bpf_hid_hw_request
> >    Documentation: add HID-BPF docs
> >
> >   Documentation/hid/hid-bpf.rst                | 444 +++++++++++
> >   Documentation/hid/index.rst                  |   1 +
> >   drivers/hid/Makefile                         |   1 +
> >   drivers/hid/hid-bpf.c                        | 328 ++++++++
> >   drivers/hid/hid-core.c                       |  34 +-
> >   include/linux/bpf-hid.h                      | 127 +++
> >   include/linux/bpf_types.h                    |   4 +
> >   include/linux/hid.h                          |  36 +-
> >   include/uapi/linux/bpf.h                     |  67 ++
> >   include/uapi/linux/bpf_hid.h                 |  71 ++
> >   include/uapi/linux/hid.h                     |  10 +
> >   kernel/bpf/Makefile                          |   3 +
> >   kernel/bpf/btf.c                             |   1 +
> >   kernel/bpf/hid.c                             | 728 +++++++++++++++++
> >   kernel/bpf/syscall.c                         |  27 +-
> >   kernel/bpf/verifier.c                        |   7 +
> >   samples/bpf/.gitignore                       |   1 +
> >   samples/bpf/Makefile                         |   4 +
> >   samples/bpf/hid_mouse_kern.c                 | 117 +++
> >   samples/bpf/hid_mouse_user.c                 | 129 +++
> >   tools/include/uapi/linux/bpf.h               |  67 ++
> >   tools/lib/bpf/libbpf.c                       |  23 +-
> >   tools/lib/bpf/libbpf.h                       |   2 +
> >   tools/lib/bpf/libbpf.map                     |   1 +
> >   tools/testing/selftests/bpf/config           |   3 +
> >   tools/testing/selftests/bpf/prog_tests/hid.c | 788 +++++++++++++++++++
> >   tools/testing/selftests/bpf/progs/hid.c      | 205 +++++
> >   27 files changed, 3204 insertions(+), 25 deletions(-)
> >   create mode 100644 Documentation/hid/hid-bpf.rst
> >   create mode 100644 drivers/hid/hid-bpf.c
> >   create mode 100644 include/linux/bpf-hid.h
> >   create mode 100644 include/uapi/linux/bpf_hid.h
> >   create mode 100644 kernel/bpf/hid.c
> >   create mode 100644 samples/bpf/hid_mouse_kern.c
> >   create mode 100644 samples/bpf/hid_mouse_user.c
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
> >
>

