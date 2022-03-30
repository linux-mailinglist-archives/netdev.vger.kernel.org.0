Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39FD4ECECB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351217AbiC3V3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiC3V3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:29:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C644747;
        Wed, 30 Mar 2022 14:27:14 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x31so13450773pfh.9;
        Wed, 30 Mar 2022 14:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tNpJ5Wp3g9qLmfmWDDWFXCwZdVqr76NxjlK+EkTDsUE=;
        b=lEisIQQ8NkZDjFI04IeUbqVRNXz8mEJXiM2w5qCn/v6isXda0A5o3rtlMaFs8BXBrj
         /9SItqnxfdDoCsj5EoAthdhMEZH6wLOOxBvvXLaJIRMVSlPieRUYR+gol+wuXLk6Rmow
         1WOhELGOOq5tpn3aRPeqSH0T4W3tPd+IZdHxtFWKRE2D1LQSZOKfLVXAg6skFtYZAegW
         B3mScsxteen1R1X0teejTHJWWlAkt26FmZbQ7CzKeDolm0L/J3ch5uROhedUT4q1hL8S
         WOPZu2sP0hWWXIZ3r4//biHsv4admaAFtudDtQGD+vaGsyNHOtKG4lpNDRtmlOVKMsC7
         RC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tNpJ5Wp3g9qLmfmWDDWFXCwZdVqr76NxjlK+EkTDsUE=;
        b=Eyd4ZhTJRmqurUI1SECUNC5LH99GJ6T4io1HP++QXKO81xeW8Omk53Sgw4N+AwJof2
         oQDvKj6Qd4nvRD+YFFy49IoVEhRvESh6P70dgCs7/8LtpXe97JXyKp+RcAPf74b46LPZ
         S2gXWDV5c/TqFiCWYf7lwbh5Wtf+x+hmGj/msXK7u3gG4o21gdXUfyiGq9TvrtmVGxXB
         k97EDgQrunU3L5dkxpSINm0thOLBUZrK/7h7p0BnEsAbWzp6mkWy2DnGdsjHVhy6u3hg
         0nn8WrCJWF5CF3ItjZxWfI2vC7CrzlPkWEkJ84HEs9wOr90T23k/XV3JTQ7GJh0/aviq
         pv3g==
X-Gm-Message-State: AOAM531eUNijaVVd9aEQ4zqbTjcp3vMTrf5oGtqFBgWBULMlyVkChCpb
        AYWB7O4rPvcye67ClGd9nP8=
X-Google-Smtp-Source: ABdhPJzXZipcBVSePl6qxrEsG59gZGosBgV2kvbFHEVhGP6w5ADkZKG8xwDNoANpsMDxot0qnQVqWQ==
X-Received: by 2002:a63:290:0:b0:386:5374:b8b5 with SMTP id 138-20020a630290000000b003865374b8b5mr7682497pgc.528.1648675633648;
        Wed, 30 Mar 2022 14:27:13 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:500::1:e77])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm25273090pfk.8.2022.03.30.14.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 14:27:13 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:27:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/17] HID: allow to change the report
 descriptor from an eBPF program
Message-ID: <20220330212709.6bpfhnmvon4dd7xc@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
 <20220318161528.1531164-7-benjamin.tissoires@redhat.com>
 <CAADnVQLvhWxEtHETg0tasJ7Fp5JHNRYWdjhnxi1y1gBpXS=bvQ@mail.gmail.com>
 <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJJXR3jtAvLF1phUa5pKZzVkDxAAHO5+7R50hL-fVhDYyA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 05:08:25PM +0100, Benjamin Tissoires wrote:
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
> 
> > We suggest to use __weak global functions and unstable kfunc helpers
> > to achieve the same goal.
> > This way HID side and bpf side can evolve without introducing
> > stable uapi burden.
> > For example this particular patch can be compressed to:
> > __weak int hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
> > unsigned int *size)
> > {
> >    return 0;
> > }
> > ALLOW_ERROR_INJECTION(ALLOW_ERROR_INJECTION, ERRNO);
> >
> > - buf = kmemdup(start, size, GFP_KERNEL);
> > + if (!hid_bpf_report_fixup(device, start, &size))
> > +   buf = kmemdup(start, size, GFP_KERNEL);
> >
> > Then bpf program can replace hid_bpf_report_fixup function and adjust its
> > return value while reading args.
> 
> I appreciate the suggestion and gave it a try, but AFAICT this doesn't
> work for HID (please correct me if I am wrong):
> 
> - I tried to use __weak to replace the ugly struct bpf_hid_hooks
> 
> This struct is in place simply because the HID module can be compiled
> in as a kernel module and we might not have the symbols available from
> kernel/bpf when it is a separate module.

why is that? The kernel modules should be compiled with BTF and
bpf infra can attach to those functions the same way.
__weak suggestion in the above is not to override it by the module.
It's there to prevent compiler from inlining it.
__weak int hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
   unsigned int *size) {...}
Will be only one.
Either in kernel proper or in kernel module. It's up to HID subsystem.

> Either I did something wrong, but it seems that when we load the
> module in the kernel, there is no magic that overrides the weak
> symbols from the ones from the modules.
> 
> - for hid_bpf_report_fixup(), this would mean that a BPF program could
> overwrite the function
> 
> This is great, but I need to have one program per device, not one
> globally defined function.
> I can not have a generic report_fixup in the system, simply because
> you might need 2 different functions for 2 different devices.

That's fine. Take a look at how libxdp is doing the chaining.
One bpf prog is attached to a main entry point and it does
demux (or call other progs sequentially) based on its own logic.
For example you have bpf prog that does:
SEC("fentry/hid_bpf_report_fixup")
int main_hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
   unsigned int *size)
{
  if (hdev->id == ..)
    another_bpf_prog();
}

Or call another bpf prog via bpf_tail_call.

There are lots of option to connect them.

You can also have N bpf progs. All look like:
SEC("fentry/hid_bpf_report_fixup")
int first_hid_bpf_report_fixup(struct hid_device *hdev, u8 *rdesc,
   unsigned int *size)
{
  if (hdev->id != mine_id)
    return 0;
  // do work;
}

And attach them all as fmod_ret type bpf prog to the same
kernel hid_bpf_report_fixup() function.
The bpf trampoline will call them sequentially.

> 
> We could solve that by auto-generating the bpf program based on which
> devices are available, but that would mean that users will see a
> reconnect of all of their input devices when they plug in a new one,
> and will also require them to have LLVM installed, which I do not
> want.

Of course. No need to regenrated them with LLVM on the fly.

> - for stuff like hid_bpf_raw_event(), I want to have multiple programs
> attached to the various devices, and not necessarily the same across
> devices.
> 
> This is basically the same as above, except that I need to chain programs.

Chaining is already available for fentry/fexit/fmod_ret programs.
 
> For instance, we could have a program that "fixes" one device, but I
> also want to attach a tracing program on top of it to monitor what is
> happening.

That's also possible.
You can have a main bpf prog as entry point that calls global functions
of this bpf program. Later you can install another bpf prog that
will replace one of the previously loaded global bpf functions.
So fully programmable and arbitrary chaining is available.

> >
> > Similar approach can be done with all other hooks.
> >
> > Once api between HID and bpf stabilizes we can replace nop functions
> > with writeable tracepoints to make things a bit more stable
> > while still allowing for change of the interface in the future.
> >
> > The amount of bpf specific code in HID core will be close to zero
> > while bpf can be used to flexibly tweak it.
> 
> Again, I like the idea, but I clearly don't see where you want to go.
> From what I see, this is incompatible with the use cases I have.
> 
> >
> > kfunc is a corresponding mechanism to introduce unstable api
> > from bpf into the kernel instead of stable helpers.
> > Just whitelist some functions as unstable kfunc helpers and call them
> > from bpf progs.
> > See net/bpf/test_run.c and bpf_kfunc_call* for inspiration.
> >
> 
> I also like this idea.
> 
> However, for hid_hw_raw_request() I can not blindly enable that
> function in all program types. This function makes the kernel sleep,
> and so we can not use it while in IRQ context.
> I think I can detect if we are in IRQ or not, but is it really worth
> enabling it across all BPF program types when we know that only
> SEC("hid/user_event") will use it?

There are sleepable and non-sleepable fmod_ret/fentry/fexit programs.
The hid subsystem would need to white list all ALLOW_ERROR_INJECTION
kernel functions approriately.
So that sleepable bpf prog won't attach to a hook where IRQs are disabled.

> Also, I am not sure how we can make bpf_hid_get_data() work with that.
> We need to teach the verifier how much memory is provided, and I do
> not see how you can do that with kfunc.

If there is anything missing in the verifier let's extend that.
Everyone will benefit.

PS
Sorry for delay. Looks like your emails are going into some sort
of queue in my gmail and receive them later. Or some other odd
filtering is going on. Maybe it's related to giant cc list in your patches.
