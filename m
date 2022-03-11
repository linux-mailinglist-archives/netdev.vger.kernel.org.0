Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1514D6451
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348548AbiCKPJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348511AbiCKPJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:09:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7D401B50F4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647011333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F/08TVTeX7qJdWIo3uuJ3+sRiIGvopv0E/DcuimI5Vg=;
        b=A5M8jWZzAIB9ji5a5Zrc8ZIQjKMMTBCLHmuls3Kr3zAimYd92o3yAAQAmCDxfyfxn2pPlq
        0Qjk+LzL+/R0kSWpkOKAlq4e0LMWCto+WvSjKhdw007tk4tFEu10Yjg4GBw+Y+2kvUbHhu
        8GvpYW2pICIS6O9FpPy4K3c4yinIUYg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-lcvSJPuLMMOs6cKFUhqAXA-1; Fri, 11 Mar 2022 10:08:51 -0500
X-MC-Unique: lcvSJPuLMMOs6cKFUhqAXA-1
Received: by mail-pg1-f197.google.com with SMTP id u4-20020a63b544000000b0037c62d8b0ecso4983961pgo.13
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:08:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F/08TVTeX7qJdWIo3uuJ3+sRiIGvopv0E/DcuimI5Vg=;
        b=wmKLHacEvs0p7Kr2qraohc6gSOTib+m8srvMuXlSyUulHZNziP/8vbRne784wTnipU
         yj5l0NjZzr1gx1nzE80Q2oWB/h0/DrsQWmEoYzu1sdlQFG+toM1ck4yV9VhIN+9FvvsQ
         gzpAtvM5zlTuY4YBQ1c+VwdYm3q57vQHU4a0INuJHhnppX702KBpjV5PSN+YGTUKgFjf
         YcxaLL48G0g6kmpZmv3TktmoEMia6swfYIb7DFkNnZWp9gn5b4SJZoPZB4zRFhQQWB/+
         ON2FE1BFNISM0J1ht9umtik4wripDkwbwVGRcfJTvdDoTyCC/ycJOUoHL4LFjFiBHOJ1
         QiqA==
X-Gm-Message-State: AOAM531uW9Hr87WdAJKL/z4qsZ7r7Kq+/JT9Lh1FggxsMnDKGnRX15Zj
        3rF8lAbNaPWeEgE8/frCFijP3hgKLdWWgF6qAFwgINK7Eocia5mOHsc7eGsXwibF9osrUCEoJpf
        ldIVgY4Pu1h0vzeKO2YrVklC5SHxvm5e7
X-Received: by 2002:a17:902:e051:b0:151:b485:3453 with SMTP id x17-20020a170902e05100b00151b4853453mr10676976plx.116.1647011329127;
        Fri, 11 Mar 2022 07:08:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP66U88wrg4Uba/sXa89zRWh8cpyDVryV2J34r/lzVwh1XrWMHAvI+0SP9yFnM0v3WNYY/Auphd33L2Zn2V7A=
X-Received: by 2002:a17:902:e051:b0:151:b485:3453 with SMTP id
 x17-20020a170902e05100b00151b4853453mr10676930plx.116.1647011328721; Fri, 11
 Mar 2022 07:08:48 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-13-benjamin.tissoires@redhat.com> <YiJdRQxYzfncfTR5@kroah.com>
 <CAO-hwJJ3Yi+JLr40J8nXccjF8PrjiQw1w0Bskz8QHXdNVh1n+A@mail.gmail.com>
 <YiM/tTYeuAcnz/Xh@kroah.com> <CAPhsuW4Yhpr6jeY8QCCvUcg_1REGWRRy7m5GXZw5Ehtt3eyAHQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4Yhpr6jeY8QCCvUcg_1REGWRRy7m5GXZw5Ehtt3eyAHQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 11 Mar 2022 16:08:37 +0100
Message-ID: <CAO-hwJ+BuTsSJdH=dmtyNKcQw-vJ4up+MzZRcbN2E+aa=9iPnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/28] bpf/hid: add hid_{get|set}_data helpers
To:     Song Liu <song@kernel.org>
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
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 1:41 AM Song Liu <song@kernel.org> wrote:
>
> On Sat, Mar 5, 2022 at 2:47 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Mar 05, 2022 at 11:33:07AM +0100, Benjamin Tissoires wrote:
> > > On Fri, Mar 4, 2022 at 7:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Fri, Mar 04, 2022 at 06:28:36PM +0100, Benjamin Tissoires wrote:
> > > > > When we process an incoming HID report, it is common to have to account
> > > > > for fields that are not aligned in the report. HID is using 2 helpers
> > > > > hid_field_extract() and implement() to pick up any data at any offset
> > > > > within the report.
> > > > >
> > > > > Export those 2 helpers in BPF programs so users can also rely on them.
> > > > > The second net worth advantage of those helpers is that now we can
> > > > > fetch data anywhere in the report without knowing at compile time the
> > > > > location of it. The boundary checks are done in hid-bpf.c, to prevent
> > > > > a memory leak.
> > > > >
> > > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > >
> > > > > ---
> > > > >
> > > > > changes in v2:
> > > > > - split the patch with libbpf and HID left outside.
> > > > > ---
> > > > >  include/linux/bpf-hid.h        |  4 +++
> > > > >  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++++
> > > > >  kernel/bpf/hid.c               | 53 ++++++++++++++++++++++++++++++++++
> > > > >  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++++
> > > > >  4 files changed, 121 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> > > > > index 0c5000b28b20..69bb28523ceb 100644
> > > > > --- a/include/linux/bpf-hid.h
> > > > > +++ b/include/linux/bpf-hid.h
> > > > > @@ -93,6 +93,10 @@ struct bpf_hid_hooks {
> > > > >       int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > > >       void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > > >       void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> > > > > +     int (*hid_get_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> > > > > +                         u64 offset, u32 n, u8 *data, u64 data_size);
> > > > > +     int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> > > > > +                         u64 offset, u32 n, u8 *data, u64 data_size);
> > > > >  };
> > > > >
> > > > >  #ifdef CONFIG_BPF
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index a7a8d9cfcf24..4845a20e6f96 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -5090,6 +5090,36 @@ union bpf_attr {
> > > > >   *   Return
> > > > >   *           0 on success, or a negative error in case of failure. On error
> > > > >   *           *dst* buffer is zeroed out.
> > > > > + *
> > > > > + * int bpf_hid_get_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> > > > > + *   Description
> > > > > + *           Get the data of size n (in bits) at the given offset (bits) in the
> > > > > + *           ctx->event.data field and store it into data.
> > > > > + *
> > > > > + *           if n is less or equal than 32, we can address with bit precision,
> > > > > + *           the value in the buffer. However, data must be a pointer to a u32
> > > > > + *           and size must be 4.
> > > > > + *
> > > > > + *           if n is greater than 32, offset and n must be a multiple of 8
> > > > > + *           and the result is working with a memcpy internally.
> > > > > + *   Return
> > > > > + *           The length of data copied into data. On error, a negative value
> > > > > + *           is returned.
> > > > > + *
> > > > > + * int bpf_hid_set_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
> > > > > + *   Description
> > > > > + *           Set the data of size n (in bits) at the given offset (bits) in the
> > > > > + *           ctx->event.data field.
> > > > > + *
> > > > > + *           if n is less or equal than 32, we can address with bit precision,
> > > > > + *           the value in the buffer. However, data must be a pointer to a u32
> > > > > + *           and size must be 4.
> > > > > + *
> > > > > + *           if n is greater than 32, offset and n must be a multiple of 8
> > > > > + *           and the result is working with a memcpy internally.
> > > > > + *   Return
> > > > > + *           The length of data copied into ctx->event.data. On error, a negative
> > > > > + *           value is returned.
> > > >
> > >
> > > Quick answer on this one (before going deeper with the other remarks next week):
> > >
> > > > Wait, nevermind my reviewed-by previously, see my comment about how this
> > > > might be split into 4:
> > > >         bpf_hid_set_bytes()
> > > >         bpf_hid_get_bytes()
> > > >         bpf_hid_set_bits()
> > > >         bpf_hid_get_bits()
> > > >
> > > > Should be easier to understand and maintain over time, right?
> > >
> > > Yes, definitively. I thought about adding a `bytes` suffix to the
> > > function name for n > 32, but not the `bits` one, meaning the API was
> > > still bunkers in my head.
>
> Do we really need per-bit access? I was under the impression that only
> one BPF program is working on a ctx/buffer at a time, so we can just do
> read-modify-write at byte level, no?
>

Yes, we really need per-bit access, and yes only one BPF program is
working on a ctx/buffer at a time.

The per-bit access is a HID requirement and a much more convenient way
of accessing data in the buffer. Well, there is another advantage too
that I'll add later.

Basically, in the HID world, HW makers are trying to 'compact' the
reports their device is sending to a minimum value.

For instance, when you have a 3 buttons + wheel mouse you may need:
3 bits of information for the 3 buttons
4 bits for the wheel
16 bits for X
16 bits for Y.

This usually translates almost verbatim in the report (we can add one
bit of padding between buttons and wheel), which means that accessing
the wheel data requires the user to access the offset 4 (bits) of size
4 bits in the report.

Some HW vendors are not even bothering aligning the data, so this can
be messy from time to time with just plain byte access.
All in all, the HID report descriptor gives you that information, and
internally, the HID stack stores the offset in bits and the sizes in
bits to access them without too much trouble.

The second advantage I have with these 2 accessors is that it allows
me to not know statically the offset and size values. Because the
helper in the kernel checks them for me, I can use registers values
that are unknown to the verifier and can basically have:

```
__u64 offsetX = 0;
__u64 offsetY = 0;
__u32 sizeX = 0;
__u32 sizeY = 0;

SEC("hid/device_event")
int invert_xy(struct hid_bpf_ctx *ctx)
{
  __u16 x, y;

  if (sizeX == 16) {
    x = bpf_hid_get_bits(ctx, offsetX, sizeX);
    bpf_hid_set_bits(ctx, offsetX, -x);
  }
  if (sizeY == 16) {
    y = bpf_hid_get_bits(ctx, offsetY, sizeY);
    bpf_hid_set_bits(ctx, offsetY, -y);
  }
  return 0;
}
```

Then, I have my userspace program parse the report descriptor, set the
correct values for size{X|Y} and offset{X|Y} and I can have this
program compiled once and redistributed many times.

Cheers,
Benjamin

