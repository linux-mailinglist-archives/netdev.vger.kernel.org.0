Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4880D4D56E0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbiCKAmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241590AbiCKAl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:41:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC28A1A1C71;
        Thu, 10 Mar 2022 16:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7870B829A0;
        Fri, 11 Mar 2022 00:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684A1C340EC;
        Fri, 11 Mar 2022 00:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646959255;
        bh=6f/VpDNfNtcOPEtBuCwkj52sxtIeE7x7S45r73hMLC0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DuB8Av+n/DCmgMG2+d0Ge8babQ14sLy+JA/6buy+CQ/GV7pL5dDyMIWrEd6fYv4r6
         665kGUGCxo3BvNFcmXGz/oW09BXLtnn+batBOdcgDha+xMdv7DQKRzM8QIVnF7Ss/2
         t7SdRhDfPubLn8ERhmWA1SLD+Qa7Wxu+NJhTi1DNzeXHMLpKbj9Q1Gy9lsIbucFmqM
         wyfgryD1Q9aW8Igq+y45HO9V585ef1f5+RsS9BIIZbBGpubmr6m4B0wB3IwMoaIfne
         SCZJnMjYXiy/q7tbZ4yByDtMcYukKRVuKkRS+ZMjByG4zK3yJaPRq0bBWfXZOmBydT
         tcF9ReG40m/jA==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2dc242a79beso77431777b3.8;
        Thu, 10 Mar 2022 16:40:55 -0800 (PST)
X-Gm-Message-State: AOAM532LkSMJRkeEMAEtC+9HmrffUSbnTTQ6AOW3A159BPHXBYbqSY31
        ZmMgCFlq4RM9C65bfVLzlBwF1/FYofYY7NCRNU4=
X-Google-Smtp-Source: ABdhPJxUZvE53GSNTeyEUzfQ2hh4brK3X+uA6Cit6VEklqPqhnUNOindaaF3Ny/9eUpv66vbgnEcSOY0gEVuj8bPmHY=
X-Received: by 2002:a81:6c6:0:b0:2dc:616b:468b with SMTP id
 189-20020a8106c6000000b002dc616b468bmr6200266ywg.472.1646959254377; Thu, 10
 Mar 2022 16:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-13-benjamin.tissoires@redhat.com> <YiJdRQxYzfncfTR5@kroah.com>
 <CAO-hwJJ3Yi+JLr40J8nXccjF8PrjiQw1w0Bskz8QHXdNVh1n+A@mail.gmail.com> <YiM/tTYeuAcnz/Xh@kroah.com>
In-Reply-To: <YiM/tTYeuAcnz/Xh@kroah.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 10 Mar 2022 16:40:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Yhpr6jeY8QCCvUcg_1REGWRRy7m5GXZw5Ehtt3eyAHQ@mail.gmail.com>
Message-ID: <CAPhsuW4Yhpr6jeY8QCCvUcg_1REGWRRy7m5GXZw5Ehtt3eyAHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/28] bpf/hid: add hid_{get|set}_data helpers
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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
        lkml <linux-kernel@vger.kernel.org>,
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

On Sat, Mar 5, 2022 at 2:47 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Mar 05, 2022 at 11:33:07AM +0100, Benjamin Tissoires wrote:
> > On Fri, Mar 4, 2022 at 7:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Mar 04, 2022 at 06:28:36PM +0100, Benjamin Tissoires wrote:
> > > > When we process an incoming HID report, it is common to have to account
> > > > for fields that are not aligned in the report. HID is using 2 helpers
> > > > hid_field_extract() and implement() to pick up any data at any offset
> > > > within the report.
> > > >
> > > > Export those 2 helpers in BPF programs so users can also rely on them.
> > > > The second net worth advantage of those helpers is that now we can
> > > > fetch data anywhere in the report without knowing at compile time the
> > > > location of it. The boundary checks are done in hid-bpf.c, to prevent
> > > > a memory leak.
> > > >
> > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > >
> > > > ---
> > > >
> > > > changes in v2:
> > > > - split the patch with libbpf and HID left outside.
> > > > ---
> > > >  include/linux/bpf-hid.h        |  4 +++
> > > >  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++++
> > > >  kernel/bpf/hid.c               | 53 ++++++++++++++++++++++++++++++++++
> > > >  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++++
> > > >  4 files changed, 121 insertions(+)
> > > >
> > > > diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> > > > index 0c5000b28b20..69bb28523ceb 100644
> > > > --- a/include/linux/bpf-hid.h
> > > > +++ b/include/linux/bpf-hid.h
> > > > @@ -93,6 +93,10 @@ struct bpf_hid_hooks {
> > > >       int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > >       void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > >       void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > > +     int (*hid_get_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> > > > +                         u64 offset, u32 n, u8 *data, u64 data_size);
> > > > +     int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> > > > +                         u64 offset, u32 n, u8 *data, u64 data_size);
> > > >  };
> > > >
> > > >  #ifdef CONFIG_BPF
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index a7a8d9cfcf24..4845a20e6f96 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -5090,6 +5090,36 @@ union bpf_attr {
> > > >   *   Return
> > > >   *           0 on success, or a negative error in case of failure. On error
> > > >   *           *dst* buffer is zeroed out.
> > > > + *
> > > > + * int bpf_hid_get_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> > > > + *   Description
> > > > + *           Get the data of size n (in bits) at the given offset (bits) in the
> > > > + *           ctx->event.data field and store it into data.
> > > > + *
> > > > + *           if n is less or equal than 32, we can address with bit precision,
> > > > + *           the value in the buffer. However, data must be a pointer to a u32
> > > > + *           and size must be 4.
> > > > + *
> > > > + *           if n is greater than 32, offset and n must be a multiple of 8
> > > > + *           and the result is working with a memcpy internally.
> > > > + *   Return
> > > > + *           The length of data copied into data. On error, a negative value
> > > > + *           is returned.
> > > > + *
> > > > + * int bpf_hid_set_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> > > > + *   Description
> > > > + *           Set the data of size n (in bits) at the given offset (bits) in the
> > > > + *           ctx->event.data field.
> > > > + *
> > > > + *           if n is less or equal than 32, we can address with bit precision,
> > > > + *           the value in the buffer. However, data must be a pointer to a u32
> > > > + *           and size must be 4.
> > > > + *
> > > > + *           if n is greater than 32, offset and n must be a multiple of 8
> > > > + *           and the result is working with a memcpy internally.
> > > > + *   Return
> > > > + *           The length of data copied into ctx->event.data. On error, a negative
> > > > + *           value is returned.
> > >
> >
> > Quick answer on this one (before going deeper with the other remarks next week):
> >
> > > Wait, nevermind my reviewed-by previously, see my comment about how this
> > > might be split into 4:
> > >         bpf_hid_set_bytes()
> > >         bpf_hid_get_bytes()
> > >         bpf_hid_set_bits()
> > >         bpf_hid_get_bits()
> > >
> > > Should be easier to understand and maintain over time, right?
> >
> > Yes, definitively. I thought about adding a `bytes` suffix to the
> > function name for n > 32, but not the `bits` one, meaning the API was
> > still bunkers in my head.

Do we really need per-bit access? I was under the impression that only
one BPF program is working on a ctx/buffer at a time, so we can just do
read-modify-write at byte level, no?

Thanks,
Song
