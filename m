Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10B4EEDFD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346258AbiDANXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238040AbiDANXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:23:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7434327BC0A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648819313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wvRTn/VN+9CYa+qxYCy3KNgmaSb0Q38arPgawL5F/Fs=;
        b=ehouPV8wkCSaMuKncuK7QQzmrZEipFyo9wKvoOx1f4PfJgRL8GT/gS8eZcuwLtq1/IdAKO
        Z6SDs3BlOGlbvJgOPvmBoRvtl9/s3ScfOOxh2lpgyWbgWhYimEAGTX13e38Nasx+86dl9K
        /rcUjDomtqsjZjOnQW+Q+dLq60UGuLw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-5XP9XPihPAGazBozMeFdfg-1; Fri, 01 Apr 2022 09:21:52 -0400
X-MC-Unique: 5XP9XPihPAGazBozMeFdfg-1
Received: by mail-pf1-f199.google.com with SMTP id x186-20020a627cc3000000b004fa939658c5so1667937pfc.4
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 06:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvRTn/VN+9CYa+qxYCy3KNgmaSb0Q38arPgawL5F/Fs=;
        b=6PoU0YKM+3zb1VAM06xIHT1wtk23HGo2qyEIX1GZEMfUfjP80eDWdadNnYBKv96jWR
         VneeV3NUupsoys1aehc6mpM/7RIqNaSRLTzxzQ46EfeG2UdF0PEaVH4UwAvluEIuCro8
         +9OzU3vhmekhmLq3tB92/XRJ3L7ZtkxHKqcGzLOeRDNo1g3Qr0KI1gxB8QvheRCC2XF+
         wHwb9ArRLl6aL+VgQ+WH2ElYAMWwXl2zNKp7vzNF9pE8Fqw4iMd9ZSnwZYpjptSmS6EW
         tiE6NaF/x0DgBUG09cSwVivx9igkjdn2ugcyTGxtKx8c24sFDo1sO9lJZHw4bFigLOX6
         on1w==
X-Gm-Message-State: AOAM533Pd0SJaAcelW24DcgIahclfQUdOStBOezqb6YSuc/eIcYkIwyJ
        SlHGXhafBKRmYk2zNqOWR6Y3FTTxbsq7TvGa79FdQFJbwSTnzz83mRdPJw9ZgX3pNDmSinBwFoJ
        Nm7cY2H/c1HWFi9xH4EspvoOzG5uYorqj
X-Received: by 2002:a17:90b:224b:b0:1c6:f027:90b1 with SMTP id hk11-20020a17090b224b00b001c6f02790b1mr11883565pjb.173.1648819310110;
        Fri, 01 Apr 2022 06:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE4l2nE/NDBvRR2VtZNGdt+TrsCCIiMnKdIPRWwDuOD18HLkmLN1hyHYY6tzbZPXj2h1mCJBeXw+5oi4DPg88=
X-Received: by 2002:a17:90b:224b:b0:1c6:f027:90b1 with SMTP id
 hk11-20020a17090b224b00b001c6f02790b1mr11883534pjb.173.1648819309710; Fri, 01
 Apr 2022 06:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-7-benjamin.tissoires@redhat.com> <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
 <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
 <CAEf4BzYVu9JVJvKZK3S9HGwpyPiWrwKPGsTz3wXC_+vmRYGdNw@mail.gmail.com>
 <CAO-hwJKPxKCzxCKGpH85j5VG3bQk+7axDYpxYoy-12yL7AQj2w@mail.gmail.com>
 <CAEf4BzZA7Wmg=N42ib_r9Jm8THXuGGR3CPgTqMyw9n2=gd_+Kg@mail.gmail.com> <CAO-hwJKnnVkJPG6wtLJ6t7ojv5=vS0NGt14un6+nRmxzj+xifw@mail.gmail.com>
In-Reply-To: <CAO-hwJKnnVkJPG6wtLJ6t7ojv5=vS0NGt14un6+nRmxzj+xifw@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 1 Apr 2022 15:21:38 +0200
Message-ID: <CAO-hwJL2x-xt2Bc6HN7-BYGPOhNCGnFM0mCwSxwk7tBfL7qoEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 3:53 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Mon, Mar 28, 2022 at 11:35 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, Mar 27, 2022 at 11:57 PM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > On Fri, Mar 25, 2022 at 6:00 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Wed, Mar 23, 2022 at 9:08 AM Benjamin Tissoires
> > > > <benjamin.tissoires@redhat.com> wrote:
> > > > >
> > > > > Hi Alexei,
> > > > >
> > > > > On Tue, Mar 22, 2022 at 11:51 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
> > > > > > <benjamin.tissoires@redhat.com> wrote:
> > > > > > >
> > > > > > > +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
> > > > > > > +{
> > > > > > > +       int ret;
> > > > > > > +       struct hid_bpf_ctx_kern ctx = {
> > > > > > > +               .type = HID_BPF_RDESC_FIXUP,
> > > > > > > +               .hdev = hdev,
> > > > > > > +               .size = *size,
> > > > > > > +       };
> > > > > > > +
> > > > > > > +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
> > > > > > > +               goto ignore_bpf;
> > > > > > > +
> > > > > > > +       ctx.data = kmemdup(rdesc, HID_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
> > > > > > > +       if (!ctx.data)
> > > > > > > +               goto ignore_bpf;
> > > > > > > +
> > > > > > > +       ctx.allocated_size = HID_MAX_DESCRIPTOR_SIZE;
> > > > > > > +
> > > > > > > +       ret = hid_bpf_run_progs(hdev, &ctx);
> > > > > > > +       if (ret)
> > > > > > > +               goto ignore_bpf;
> > > > > > > +
> > > > > > > +       if (ctx.size > ctx.allocated_size)
> > > > > > > +               goto ignore_bpf;
> > > > > > > +
> > > > > > > +       *size = ctx.size;
> > > > > > > +
> > > > > > > +       if (*size) {
> > > > > > > +               rdesc = krealloc(ctx.data, *size, GFP_KERNEL);
> > > > > > > +       } else {
> > > > > > > +               rdesc = NULL;
> > > > > > > +               kfree(ctx.data);
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       return rdesc;
> > > > > > > +
> > > > > > > + ignore_bpf:
> > > > > > > +       kfree(ctx.data);
> > > > > > > +       return kmemdup(rdesc, *size, GFP_KERNEL);
> > > > > > > +}
> > > > > > > +
> > > > > > >  int __init hid_bpf_module_init(void)
> > > > > > >  {
> > > > > > >         struct bpf_hid_hooks hooks = {
> > > > > > >                 .hdev_from_fd = hid_bpf_fd_to_hdev,
> > > > > > >                 .pre_link_attach = hid_bpf_pre_link_attach,
> > > > > > > +               .post_link_attach = hid_bpf_post_link_attach,
> > > > > > >                 .array_detach = hid_bpf_array_detach,
> > > > > > >         };
> > > > > > >
> > > > > > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > > > > > index 937fab7eb9c6..3182c39db006 100644
> > > > > > > --- a/drivers/hid/hid-core.c
> > > > > > > +++ b/drivers/hid/hid-core.c
> > > > > > > @@ -1213,7 +1213,8 @@ int hid_open_report(struct hid_device *device)
> > > > > > >                 return -ENODEV;
> > > > > > >         size = device->dev_rsize;
> > > > > > >
> > > > > > > -       buf = kmemdup(start, size, GFP_KERNEL);
> > > > > > > +       /* hid_bpf_report_fixup() ensures we work on a copy of rdesc */
> > > > > > > +       buf = hid_bpf_report_fixup(device, start, &size);
> > > > > >
> > > > > > Looking at this patch and the majority of other patches...
> > > > > > the code is doing a lot of work to connect HID side with bpf.
> > > > > > At the same time the evolution of the patch series suggests
> > > > > > that these hook points are not quite stable. More hooks and
> > > > > > helpers are being added.
> > > > > > It tells us that it's way too early to introduce a stable
> > > > > > interface between HID and bpf.
> > > > >
> > > > > I understand that you might be under the impression that the interface
> > > > > is changing a lot, but this is mostly due to my poor knowledge of all
> > > > > the arcanes of eBPF.
> > > > > The overall way HID-BPF works is to work on a single array, and we
> > > > > should pretty much be sorted out. There are a couple of helpers to be
> > > > > able to communicate with the device, but the API has been stable in
> > > > > the kernel for those for quite some time now.
> > > > >
> > > > > The variations in the hooks is mostly because I don't know what is the
> > > > > best representation we can use in eBPF for those, and the review
> > > > > process is changing that.
> > > >
> > > > I think such a big feature as this one, especially that most BPF folks
> > > > are (probably) not familiar with the HID subsystem in the kernel,
> > > > would benefit from a bit of live discussion during BPF office hours.
> > > > Do you think you can give a short overview of what you are trying to
> > > > achieve with some background context on HID specifics at one of the
> > > > next BPF office hours? We have a meeting scheduled every week on
> > > > Thursday, 9am Pacific time. But people need to put their topic onto
> > > > the agenda, otherwise the meeting is cancelled. See [0] for
> > > > spreadsheet and links to Zoom meeting, agenda, etc.
> > >
> > > This sounds like a good idea. I just added my topic on the agenda and
> > > will prepare some slides.
> > >
> >
> > Great! Unfortunately I personally have a conflict this week and won't
> > be able to attend, so I'll have to catch up somehow through word of
> > mouth :( Next week's BPF office hours would be best, but I don't want
> > to delay discussions just because of me.
>
> OK. FWIW, I'll have slides publicly available once I'll do a final
> roundup on them. Hopefully that will give you enough context on HID to
> understand the problem.
> If there are too many conflicts we can surely delay by a week, but I
> would rather have the discussion happening sooner :/
>

Follow up on the discussion we had yesterday:

- this patchset should be dropped in its current form, because it's
the "old way" of extending BPF:

The new goal is to extend the BPF core so we work around the
limitations we find in HID so other subsystems can use the same
approach.
This is what Alexei was explaining in his answer in this thread. We
need HID to solely declare which functions are replaced (by abusing
SEC("fentry/function_name") - or fexit, fmod_ret), and also allow HID
to declare its BPF API without having to change a single bit in the
BPF core. This approach should allow other subsystems (USB???) to use
a similar approach without having to mess up with BPF too much.

- being able to attach a SEC("fentry/function") to a particular HID
device requires some changes in the BPF core

We can live without it, but it would be way cleaner to selectively
attach those trampolines to only the selected devices without having
to hand that decision to the BPF programmers

- patch 12 and 13 (the bits access helper) should be dropped

This should be done entirely in BPF, with a BPF helper as a .h that
users include instead of having to maintain yet another UAPI

- Daniel raised the question of a flag which tells other BPF that a bug is fixed

In the case we drop in the filesystem a BPF program to fix a
particular device, and then we include that same program in the
kernel, how can we know that the feature is already fixed?
It's still an open question.

- including BPF objects in the kernel is definitively doable through lskel

But again, the question is how do we attach those programs to a
particular device?

- to export a new UAPI BPF helper, we should rely on kfunc as
explained in Alexei's email

However, the current kfunc and ALLOW_ERROR_INJECTION API doesn't
clearly allow to define which function is sleepable or not, making it
currently hard to define that behavior.
Once the BPF kAPI allows to mark kfunc and ALLOW_ERROR_INJECTION
(_weak) functions to be sleepable or not, we will be able to define
the BPF hooks directly in HID without having to touch the BPF core.

- running a SEC("fentry/...") BPF program as a standalone from
userspace through a syscall is possible

- When defining a SEC("fentry/..."), all parameters are currently read-only

we either need a hid_bpf_get_data() hooks where we can mark the output
as being read-write, or we need to be able to tag the target function
as read-write for (part of) its arguments

(I would lean toward the extra helper that might be much easier to declare IMO).


I think that's it from yesterday's discussion.

Many thanks for listening to me and proposing a better solution.
Now I have a lot to work on.

Cheers,
Benjamin

