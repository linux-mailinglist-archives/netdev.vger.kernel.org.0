Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24FD4E7994
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 18:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377001AbiCYRCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 13:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiCYRCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 13:02:10 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781E24D264;
        Fri, 25 Mar 2022 10:00:35 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d62so9551148iog.13;
        Fri, 25 Mar 2022 10:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ko4mIxnXaw4yoPYh8PjrmsoS3HvZSH7ww79WhJnpMH4=;
        b=RZcwA6fQAdjrf7FF2zVeX7H/SIgQ1V7SEWgnpQS/0BC3ukM/0D/WwG6gGAbQG5ImZc
         UGmTvS87mlznXBvJ1kVI3hPtKqXgHOm0ptW8ycyayeL6iwlw++KIQrcRrAkOdqdTwBzr
         alue6QBo0GDPgl00OiuO0Qx5tERXuLtAYW9RqQ5LR9KCGpkaqAPpcAD1wmEK9OIeQgHK
         0Pva+Bl+da6MTyOaVyi9vgELNuIQBy6rUBK2Foqor5PgKGQPEPphLzveoreHurQ28Rxn
         p6A472lXQuuSwzJVR6xaiWkMF2V9eAIf3VItaO3j6u22XpTetxZwZ9YfAFKzka+BEErN
         XTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ko4mIxnXaw4yoPYh8PjrmsoS3HvZSH7ww79WhJnpMH4=;
        b=yjJCq26Tysas8gvKBu9614Xwjj8vuqiJzwifNceVnNlXtOt/A1uazSKgBFjOspoguT
         +qi9AeFR/dCVxV711L3+O0UHSPzC1cO9+8ruVzUvnZBOmgZxGZANWAf3+Ex2eWJKqORq
         yJk8ApDMokTerOdy79afxGpl2DfvAz77U2qqxwQWKU44VCsQVOgFd6QLyLf1lCOKaQQs
         UL2+DPUlGX5yWsxP80u4r7uz07l9jGcfxEO6MUUFocDzR7NgYVOZVR9hLxcd1W8NqRM3
         8KcZ1SlFlFlAV72rt9Zyoph738XwNNZlmci1c5/RJ/m3tZ23x1mgbwc1IpU4W5kpfoSg
         hQJw==
X-Gm-Message-State: AOAM533IlxBEkN6mHmA5yKoRoXIkNi70lLyDSLNHnn8prI4XUJmhExie
        +JGpPJsUDiILE9iOY/x35TyrA5aO0KhU+7oX4YA=
X-Google-Smtp-Source: ABdhPJwtmZHUYpe+l+4rcOPjK1FPYXhd0eg1b12cJ7I7RJnY7A8ZlX9X9KSb+nUZXQfEUq4sX7mt2noF9X8EP60JQSk=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr6152428ioi.154.1648227634763; Fri, 25
 Mar 2022 10:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-7-benjamin.tissoires@redhat.com> <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
 <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
In-Reply-To: <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Mar 2022 10:00:23 -0700
Message-ID: <CAEf4BzYVu9JVJvKZK3S9HGwpyPiWrwKPGsTz3wXC_+vmRYGdNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 9:08 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi Alexei,
>
> On Tue, Mar 22, 2022 at 11:51 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
> > > +{
> > > +       int ret;
> > > +       struct hid_bpf_ctx_kern ctx = {
> > > +               .type = HID_BPF_RDESC_FIXUP,
> > > +               .hdev = hdev,
> > > +               .size = *size,
> > > +       };
> > > +
> > > +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
> > > +               goto ignore_bpf;
> > > +
> > > +       ctx.data = kmemdup(rdesc, HID_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
> > > +       if (!ctx.data)
> > > +               goto ignore_bpf;
> > > +
> > > +       ctx.allocated_size = HID_MAX_DESCRIPTOR_SIZE;
> > > +
> > > +       ret = hid_bpf_run_progs(hdev, &ctx);
> > > +       if (ret)
> > > +               goto ignore_bpf;
> > > +
> > > +       if (ctx.size > ctx.allocated_size)
> > > +               goto ignore_bpf;
> > > +
> > > +       *size = ctx.size;
> > > +
> > > +       if (*size) {
> > > +               rdesc = krealloc(ctx.data, *size, GFP_KERNEL);
> > > +       } else {
> > > +               rdesc = NULL;
> > > +               kfree(ctx.data);
> > > +       }
> > > +
> > > +       return rdesc;
> > > +
> > > + ignore_bpf:
> > > +       kfree(ctx.data);
> > > +       return kmemdup(rdesc, *size, GFP_KERNEL);
> > > +}
> > > +
> > >  int __init hid_bpf_module_init(void)
> > >  {
> > >         struct bpf_hid_hooks hooks = {
> > >                 .hdev_from_fd = hid_bpf_fd_to_hdev,
> > >                 .pre_link_attach = hid_bpf_pre_link_attach,
> > > +               .post_link_attach = hid_bpf_post_link_attach,
> > >                 .array_detach = hid_bpf_array_detach,
> > >         };
> > >
> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 937fab7eb9c6..3182c39db006 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1213,7 +1213,8 @@ int hid_open_report(struct hid_device *device)
> > >                 return -ENODEV;
> > >         size = device->dev_rsize;
> > >
> > > -       buf = kmemdup(start, size, GFP_KERNEL);
> > > +       /* hid_bpf_report_fixup() ensures we work on a copy of rdesc */
> > > +       buf = hid_bpf_report_fixup(device, start, &size);
> >
> > Looking at this patch and the majority of other patches...
> > the code is doing a lot of work to connect HID side with bpf.
> > At the same time the evolution of the patch series suggests
> > that these hook points are not quite stable. More hooks and
> > helpers are being added.
> > It tells us that it's way too early to introduce a stable
> > interface between HID and bpf.
>
> I understand that you might be under the impression that the interface
> is changing a lot, but this is mostly due to my poor knowledge of all
> the arcanes of eBPF.
> The overall way HID-BPF works is to work on a single array, and we
> should pretty much be sorted out. There are a couple of helpers to be
> able to communicate with the device, but the API has been stable in
> the kernel for those for quite some time now.
>
> The variations in the hooks is mostly because I don't know what is the
> best representation we can use in eBPF for those, and the review
> process is changing that.

I think such a big feature as this one, especially that most BPF folks
are (probably) not familiar with the HID subsystem in the kernel,
would benefit from a bit of live discussion during BPF office hours.
Do you think you can give a short overview of what you are trying to
achieve with some background context on HID specifics at one of the
next BPF office hours? We have a meeting scheduled every week on
Thursday, 9am Pacific time. But people need to put their topic onto
the agenda, otherwise the meeting is cancelled. See [0] for
spreadsheet and links to Zoom meeting, agenda, etc.

  [0] https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU

[...]
