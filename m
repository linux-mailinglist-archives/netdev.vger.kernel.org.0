Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC8652D05A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiESKUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiESKUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:20:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E52A7747
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652955614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uTf4UazsnqFm1w0j9PjtulisgMFh6QzykfXouIHj8FI=;
        b=UHQEavkCYQ2B+KYfbRWaIYLMVNERwWKvnVBrkSywqBUXRYctQO84g2CjEucUEiXdYJQ6jN
        G8VN6P7+SZMQJP0fDox14t3Vn+vaiuAjgd8gf5sUKQZQ2LAiPk2aqU3g62CtWT/10BBrjt
        w6TRbRVVTk1y9V75aTTIWzq3wdrPyoQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-fH-SO1a3PzqRJgI5UFlhYA-1; Thu, 19 May 2022 06:20:13 -0400
X-MC-Unique: fH-SO1a3PzqRJgI5UFlhYA-1
Received: by mail-pf1-f197.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so2495589pfa.22
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uTf4UazsnqFm1w0j9PjtulisgMFh6QzykfXouIHj8FI=;
        b=XDPtvXx96HiC+Dmdyy5lOhztdC6OVOYTQoNo4u25I4srHpbF08OctdmdcommdEDXfz
         MiUPed6REYRsVvcK0/THWVIoV1SXWJkug5JMa5/xdlWgxPlqV9ERV0pqPqJnlo1BZA+N
         9CogowgOI+Q+tcCkT/ZLy1PQA7jwGWhfSjqQB7XvCrq8JQfrbkQ26Ou5JnhF2lLAk6GB
         e+6C5RkuMq02F7iQMfG2TWzbN2uOaqdhY3IXDYNeq29u8zX8nBYM/0iAP7uQLVRXcGTu
         lqY7xBIUdZzZvnuMK3Ri0VU2NWipII2b2xA3BGdxRrUpRfroEGs4JymmPZSXAaBArl6g
         2Xog==
X-Gm-Message-State: AOAM530uR/wSydUfwnnDcSjeQS1pFZjgV5DLtEDrYmh9aMvek5ZgnS7k
        xQKlXWuANkKAv0UQ8H9z/1DXS5BAOgEqP5Vs1mcseGvu/lV0+0+ozsz+A6BnXNfTKN11RkcqIl4
        bazwOuz/2tnZrcFbCejto8qOL/dTjAkcs
X-Received: by 2002:a17:903:22c6:b0:15f:14e1:1518 with SMTP id y6-20020a17090322c600b0015f14e11518mr4080923plg.116.1652955612083;
        Thu, 19 May 2022 03:20:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyu2Gf5VTzOz90w3/G1De6zt6if/VLekZLdOYdtToYtFikUFmLdwo0CCwN8PGggiEKvMyPvE0o9jU6G39mZwzo=
X-Received: by 2002:a17:903:22c6:b0:15f:14e1:1518 with SMTP id
 y6-20020a17090322c600b0015f14e11518mr4080890plg.116.1652955611775; Thu, 19
 May 2022 03:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org> <YoX904CAFOAfWeJN@kroah.com> <YoYCIhYhzLmhIGxe@infradead.org>
In-Reply-To: <YoYCIhYhzLmhIGxe@infradead.org>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Thu, 19 May 2022 12:20:00 +0200
Message-ID: <CAO-hwJL4Pj4JaRquoXD1AtegcKnh22_T0Z0VY_peZ8FRko3kZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
To:     Christoph Hellwig <hch@infradead.org>
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
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:39 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, May 19, 2022 at 10:20:35AM +0200, Greg KH wrote:
> > > are written using a hip new VM?
> >
> > Ugh, don't mention UDI, that's a bad flashback...
>
> But that is very much what we are doing here.
>
> > I thought the goal here was to move a lot of the quirk handling and
> > "fixup the broken HID decriptors in this device" out of kernel .c code
> > and into BPF code instead, which this patchset would allow.

Yes, quirks are a big motivation for this work. Right now half of the
HID drivers are less than 100 lines of code, and are just trivial
fixes (one byte in the report descriptor, one key mapping, etc...).
Using eBPF for those would simplify the process from the user point of
view: you drop a "firmware fix" as an eBPF program in your system and
you can continue working on your existing kernel.

The other important aspect is being able to do filtering on the event
streams themselves.
This would mean for instance that you allow some applications to have
access to part of the device features and you reject some of them. The
main use case I have is to prevent applications to switch a device
into its bootloader mode and mess up with the firmware.

> >
> > So that would just be exception handling.  I don't think you can write a
> > real HID driver here at all, but I could be wrong as I have not read the
> > new patchset (older versions of this series could not do that.)

Well, to be fair, yes and no.
HID-BPF can only talk HID, and so we only act on arrays of bytes. You
can mess up with the report descriptor or the events themselves, but
you don't have access to other kernel APIs.
So no, you can not write a HID-BPF driver that would manually create
LEDs sysfs endpoints, input endpoints and battery endpoints.

However, HID is very versatile in how you can describe a device. And
the kernel now supports a lot of those features. So if you really
want, you can entirely change the look of the device (its report
descriptor), and rely on hid-core to export those LEDs, inputs and
battery endpoints.

But we already have this available by making use of hidraw+uhid. This
involves userspace and there are already projects (for handling
Corsair keyboard for example) which are doing exactly that, with a big
security whole in the middle because the application is reading *all*
events as they are flowing.

One of the most important things here is that this work allows for
context driven behavior. We can now control how a device is behaving
depending on the actual application without having to design and
maintain forever kernel APIs.
For example, the Surface Dial is a puck that can have some haptic
feedback when you turn it. However, when you enable the haptic
feedback you have to reduce the resolution to one event every 5
degrees or the haptic feedback feels just wrong. But the device is
capable of sub-degrees of event notifications. Which means you want
the high resolution mode without haptic, and low res with haptic.

Of course, you can use some new FF capabilities to enable/disable
haptic, but we have nothing to change the resolution on the fly of a
HID device, so we'll likely have to create another kernel API through
a sysfs node or a kernel parameter. But then we need to teach
userspace to use it and this kernel API is not standard, so it won't
be used outside of this particular device.
BPF in that case allows the application which needs it to do the
changes it requires depending on the context. And when I say
application, it is mostly either the compositor or a daemon, not gimp.

>
> And that "exception handling" is most of the driver.
>

Well, it depends. If hardware makers would not make crappy decisions
based on the fact that it somehow works under Windows, we wouldn't
have to do anything to support those devices.
But for half of the drivers, we are doing dumb things to fix those
devices in the kernel.

On the other hand, we do have generic protocols in HID that can not be
replaced by BPF.
For the exercise, I tried to think about what it would take to rewrite
the multitouch logic in eBPF, and trust me, you don't want that. The
code would be a lot of spaghetti and would require access to many
kernel APIs to handle it properly.

Cheers,
Benjamin

