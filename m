Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D674E5609
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 17:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238203AbiCWQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 12:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiCWQKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 12:10:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5A892B249
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648051720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jojw5f7wnm9EHe+O1hZXC5y0oSm+5NVhYv4rzpOxMAw=;
        b=XtvX8PJjdkUpd5aN+xHXH2kxNaBCgb6l1XZfDne31/qfpIhy5Bc19lNqKlJzCvfJOgU5Ul
        2q6W5kIPGnuBYLEeirAjhjNL8aPWw46vwiiaYd3l9ZsMWIUoUJyzl9WrLPupb1m98Z8Ime
        rMnyNqzD9mHnl766SH8pKZd0zxrzmq4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-VI_aV7fENzCPsv_4BgxYyA-1; Wed, 23 Mar 2022 12:08:39 -0400
X-MC-Unique: VI_aV7fENzCPsv_4BgxYyA-1
Received: by mail-pf1-f197.google.com with SMTP id d145-20020a621d97000000b004f7285f67e8so1258352pfd.2
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 09:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jojw5f7wnm9EHe+O1hZXC5y0oSm+5NVhYv4rzpOxMAw=;
        b=PQyYPwwpnQrWxxH/fTQBKPtBgK66Mba2BB/O75R4OqM1JbwrdXrFJkzWLD/92L4L0K
         0z3VIAqcwgpuhegU99J07cMJ9vTL+uSf19Wc1cQzz8uPjyQOuS5f12HlILHiaZnyFLeU
         4omIsHz8LM6unk5PCMcRBrULWroZ3TqrWTGnq8dz0S0PyDnXJA33Kjr+IwUAMijM2Wo/
         YtOARTHFHIDXG8aK1JC7H/lKFr4XOdGBlyplwLirVzb+0M4BdAnLDMVAy+drlAAsODUa
         MA4t5F5GnfB7Kb/QQSTTrPY0Q8aALxkNjau0b89PJK7vw69g6VCvLWJupWfCOzjIFjIf
         QN8w==
X-Gm-Message-State: AOAM530v3UKsG8vkNxOztRzhyO99AnowEEYgAvp2LMY9eVH2bWnaUlja
        U8EChr2pnDQwfkfSq8PjBaIPJ5RQrXJ8kJDBKcKhtxIOa+oTfrHnX8MyrXVM2miqwSU9JjS7OKR
        xZ/n93XhPpeojED+ph+wkuhAn0cD4bYFN
X-Received: by 2002:a05:6a00:2182:b0:4fa:6d20:d95d with SMTP id h2-20020a056a00218200b004fa6d20d95dmr255502pfi.83.1648051717790;
        Wed, 23 Mar 2022 09:08:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXs0W2sqJvvyH5rSFI3YPUX3kkRaojzc998a5Iv1JVOvvGHml++AVdio6zxhwzppY5Sd1fQUrROiDnPqcnr1E=
X-Received: by 2002:a05:6a00:2182:b0:4fa:6d20:d95d with SMTP id
 h2-20020a056a00218200b004fa6d20d95dmr255474pfi.83.1648051717452; Wed, 23 Mar
 2022 09:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-7-benjamin.tissoires@redhat.com> <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
In-Reply-To: <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Wed, 23 Mar 2022 17:08:25 +0100
Message-ID: <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On Tue, Mar 22, 2022 at 11:51 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > +u8 *hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc, unsigned int *size)
> > +{
> > +       int ret;
> > +       struct hid_bpf_ctx_kern ctx = {
> > +               .type = HID_BPF_RDESC_FIXUP,
> > +               .hdev = hdev,
> > +               .size = *size,
> > +       };
> > +
> > +       if (bpf_hid_link_empty(&hdev->bpf, BPF_HID_ATTACH_RDESC_FIXUP))
> > +               goto ignore_bpf;
> > +
> > +       ctx.data = kmemdup(rdesc, HID_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
> > +       if (!ctx.data)
> > +               goto ignore_bpf;
> > +
> > +       ctx.allocated_size = HID_MAX_DESCRIPTOR_SIZE;
> > +
> > +       ret = hid_bpf_run_progs(hdev, &ctx);
> > +       if (ret)
> > +               goto ignore_bpf;
> > +
> > +       if (ctx.size > ctx.allocated_size)
> > +               goto ignore_bpf;
> > +
> > +       *size = ctx.size;
> > +
> > +       if (*size) {
> > +               rdesc = krealloc(ctx.data, *size, GFP_KERNEL);
> > +       } else {
> > +               rdesc = NULL;
> > +               kfree(ctx.data);
> > +       }
> > +
> > +       return rdesc;
> > +
> > + ignore_bpf:
> > +       kfree(ctx.data);
> > +       return kmemdup(rdesc, *size, GFP_KERNEL);
> > +}
> > +
> >  int __init hid_bpf_module_init(void)
> >  {
> >         struct bpf_hid_hooks hooks = {
> >                 .hdev_from_fd = hid_bpf_fd_to_hdev,
> >                 .pre_link_attach = hid_bpf_pre_link_attach,
> > +               .post_link_attach = hid_bpf_post_link_attach,
> >                 .array_detach = hid_bpf_array_detach,
> >         };
> >
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 937fab7eb9c6..3182c39db006 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1213,7 +1213,8 @@ int hid_open_report(struct hid_device *device)
> >                 return -ENODEV;
> >         size = device->dev_rsize;
> >
> > -       buf = kmemdup(start, size, GFP_KERNEL);
> > +       /* hid_bpf_report_fixup() ensures we work on a copy of rdesc */
> > +       buf = hid_bpf_report_fixup(device, start, &size);
>
> Looking at this patch and the majority of other patches...
> the code is doing a lot of work to connect HID side with bpf.
> At the same time the evolution of the patch series suggests
> that these hook points are not quite stable. More hooks and
> helpers are being added.
> It tells us that it's way too early to introduce a stable
> interface between HID and bpf.

I understand that you might be under the impression that the interface
is changing a lot, but this is mostly due to my poor knowledge of all
the arcanes of eBPF.
The overall way HID-BPF works is to work on a single array, and we
should pretty much be sorted out. There are a couple of helpers to be
able to communicate with the device, but the API has been stable in
the kernel for those for quite some time now.

The variations in the hooks is mostly because I don't know what is the
best representation we can use in eBPF for those, and the review
process is changing that.

> We suggest to use __weak global functions and unstable kfunc helpers
> to achieve the same goal.
> This way HID side and bpf side can evolve without introducing
> stable uapi burden.
> For example this particular patch can be compressed to:
> __weak int hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
> unsigned int *size)
> {
>    return 0;
> }
> ALLOW_ERROR_INJECTION(ALLOW_ERROR_INJECTION, ERRNO);
>
> - buf = kmemdup(start, size, GFP_KERNEL);
> + if (!hid_bpf_report_fixup(device, start, &size))
> +   buf = kmemdup(start, size, GFP_KERNEL);
>
> Then bpf program can replace hid_bpf_report_fixup function and adjust its
> return value while reading args.

I appreciate the suggestion and gave it a try, but AFAICT this doesn't
work for HID (please correct me if I am wrong):

- I tried to use __weak to replace the ugly struct bpf_hid_hooks

This struct is in place simply because the HID module can be compiled
in as a kernel module and we might not have the symbols available from
kernel/bpf when it is a separate module.
Either I did something wrong, but it seems that when we load the
module in the kernel, there is no magic that overrides the weak
symbols from the ones from the modules.

- for hid_bpf_report_fixup(), this would mean that a BPF program could
overwrite the function

This is great, but I need to have one program per device, not one
globally defined function.
I can not have a generic report_fixup in the system, simply because
you might need 2 different functions for 2 different devices.

We could solve that by auto-generating the bpf program based on which
devices are available, but that would mean that users will see a
reconnect of all of their input devices when they plug in a new one,
and will also require them to have LLVM installed, which I do not
want.

- for stuff like hid_bpf_raw_event(), I want to have multiple programs
attached to the various devices, and not necessarily the same across
devices.

This is basically the same as above, except that I need to chain programs.

For instance, we could have a program that "fixes" one device, but I
also want to attach a tracing program on top of it to monitor what is
happening.

>
> Similar approach can be done with all other hooks.
>
> Once api between HID and bpf stabilizes we can replace nop functions
> with writeable tracepoints to make things a bit more stable
> while still allowing for change of the interface in the future.
>
> The amount of bpf specific code in HID core will be close to zero
> while bpf can be used to flexibly tweak it.

Again, I like the idea, but I clearly don't see where you want to go.
From what I see, this is incompatible with the use cases I have.

>
> kfunc is a corresponding mechanism to introduce unstable api
> from bpf into the kernel instead of stable helpers.
> Just whitelist some functions as unstable kfunc helpers and call them
> from bpf progs.
> See net/bpf/test_run.c and bpf_kfunc_call* for inspiration.
>

I also like this idea.

However, for hid_hw_raw_request() I can not blindly enable that
function in all program types. This function makes the kernel sleep,
and so we can not use it while in IRQ context.
I think I can detect if we are in IRQ or not, but is it really worth
enabling it across all BPF program types when we know that only
SEC("hid/user_event") will use it?

Also, I am not sure how we can make bpf_hid_get_data() work with that.
We need to teach the verifier how much memory is provided, and I do
not see how you can do that with kfunc.

Cheers,
Benjamin

