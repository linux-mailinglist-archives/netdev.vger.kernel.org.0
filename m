Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EE35FDEE4
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJMRZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJMRZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:25:04 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A414001F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 10:25:02 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id s3so1976166qtn.12
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 10:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j1qTz+oYugF8Lf770mKCIrdepvqmBbCEzwy+EaukMrM=;
        b=RwP93R0i/58OL7LRD+//xbsGSpXEvsNfrhi2GXL/rRnIR0fEBr1hhf0AxtH9ySaIuq
         fxnBUs5tBFF0nv+sS5fXPWTFdyDQIQyfW3oaIHCHCny57nHo+jkN3VT1oW56ATf0pSAn
         /cXKnAs4MWRb/mczWEGT2NYOdgosHqzbcK1Ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1qTz+oYugF8Lf770mKCIrdepvqmBbCEzwy+EaukMrM=;
        b=Dj4G1jkjE5gIHW6ofxpMck6wOHoda7G9udZ3XyFV8SOfs/+y+9nb9vqBYFaeAQRwZb
         jp/ISSJmx3jvv8y+aKwjbIOacFWgYhcFBUOnComaCBAe4TwSDSf6pjhJb6iCUztNBd1v
         e4qJlweTc31lrXbGNqjkmmnlONeDv5OCk6h6y0c1gC1IcbPhzYyB5fjAFgstUe5q0CmR
         OCxf0YlKbzswChAeQiDKocUmnXsMlFmglDWCf6Y3AoCinaH+AcClq92qJ30Fc2RlGwHk
         oVi7aFhBwaBt836HPzbtOXV8lds6Nx96lmDZbT3TRdsYNIH17geJWoTMoLK1D4zfB6zZ
         HZJA==
X-Gm-Message-State: ACrzQf2nGpA9iD0qd/axIHyLkeN/fSUdsCbrKKi8cFUg1okMLSkLMkie
        MDzDEguQ/bEaXJQrnCiG/wZZcH1/hCOf7g==
X-Google-Smtp-Source: AMsMyM6CWgMJj/+lhT5b1BFVEyML97dudpXAfkoP7igROT5dKSFjJPR45KMteiEvkOYE6BpKZN9pgQ==
X-Received: by 2002:a05:620a:d8c:b0:6a7:91a2:c827 with SMTP id q12-20020a05620a0d8c00b006a791a2c827mr733300qkl.407.1665681901510;
        Thu, 13 Oct 2022 10:25:01 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id o5-20020a05620a228500b006ee94c5bf26sm191011qkh.91.2022.10.13.10.25.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 10:25:01 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-3608b5e634aso23912547b3.6
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 10:25:01 -0700 (PDT)
X-Received: by 2002:a05:6830:4421:b0:661:8fdd:81e9 with SMTP id
 q33-20020a056830442100b006618fdd81e9mr528782otv.69.1665681558964; Thu, 13 Oct
 2022 10:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au> <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au> <87edvdm7qg.fsf@mpe.ellerman.id.au>
 <20221012115023-mutt-send-email-mst@kernel.org> <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
 <38893b2e-c7a1-4ad2-b691-7fbcbbeb310f@app.fastmail.com> <20221012180806-mutt-send-email-mst@kernel.org>
 <a35fd31b-0658-4ac1-8340-99cdf4c75bb7@app.fastmail.com>
In-Reply-To: <a35fd31b-0658-4ac1-8340-99cdf4c75bb7@app.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 13 Oct 2022 10:19:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLv3MO0Tvc62zJ+=4yvSfKMK17C0wfpbXBwUJqSjKbYA@mail.gmail.com>
Message-ID: <CAHk-=whLv3MO0Tvc62zJ+=4yvSfKMK17C0wfpbXBwUJqSjKbYA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: fixes, features
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, xiujianfeng@huawei.com,
        kvm@vger.kernel.org, alvaro.karsz@solid-run.com,
        Jason Wang <jasowang@redhat.com>, angus.chen@jaguarmicro.com,
        wangdeming@inspur.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, lingshan.zhu@intel.com,
        linuxppc-dev@lists.ozlabs.org, gavinl@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 11:29 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Oct 13, 2022, at 12:08 AM, Michael S. Tsirkin wrote:
> >
> > Do these two boxes even have pci?
>
> Footbridge/netwinder has PCI and PC-style ISA on-board devices
> (floppy, ps2 mouse/keyboard, parport, soundblaster, ...), RiscPC
> has neither.

It's worth noting that changing a driver that does

        if (dev->irq == NO_IRQ)
                return -ENODEV;

to use

        if (!dev->irq)
                return -ENODEV;

should be pretty much always fine.

Even *if* that driver is then compiled and used on an architecture
where NO_IRQ is one of the odd values, you end up having only two
cases

 (a) irq 0 was actually a valid irq after all

 (b) you just get the error later when actually trying to use the odd
NO_IRQ interrupt with request_irq() and friends

and here (a) basically never happens - certainly not for any PCI setup
- and (b) is harmless unless the driver was already terminally broken
anyway.

The one exception for (a) might be some platform irq code. On x86,
that would be the legacy timer interrupt, of course.

So if some odd platform actually has a "real" interrupt on irq0, that
platform should either just fix the irq number mapping, or should
consider that interrupt to be a platform-specific thing and handle it
very very specially.

On x86, for example, we do

        if (request_irq(0, timer_interrupt, flags, "timer", NULL))

early in boot, and that's basically what then makes sure that no
driver can get that irq. It's done through the platform "timer_init"
code at the "late_time_init()" call.

(And that "late_time_init()" - despite the name - isn't very late at
all. It's just later than the very early timekeeping init - after
interrupts have been enabled at all.

             Linus
