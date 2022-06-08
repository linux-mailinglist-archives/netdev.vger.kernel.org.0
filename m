Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B30054269B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbiFHDrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiFHDpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:45:11 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013DD22CBCA
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:55:43 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id r82so33874389ybc.13
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0eDnZ7I6mO5HIGKZ+f0UxkdVyF2auRBoobbCKlqgPAQ=;
        b=JRO2H/wErVGZXWcbW+zNZ+nvh17H9KRevHibogV1hEKUtKNV+dHJedZUCcmsLRFsbr
         GiORDL1v/+yoLQGYD2iqfRuGZ9U7QtizhqJI3wyOzjcbWw7nc3V/pPExvNPUW2BfUFmh
         AGI3jVlmHwn1urkMrfPgLZun0si5RfPJ3OcK8P1tHu6tn0+7VzGJiRNsraCSC/oByMin
         0S3hNucR2Nz1YSV4sS+c0ltRQRrlCvopskDBlBE6Uoo2zLOC6uWuDgdJvH7yYH3PtBm/
         6v9ZuHGAPJE5S91uErDhqXltzDX0iZKPF0O2ILrt1wXCb3DnWFa0oK29hKP99H9jDk45
         96vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0eDnZ7I6mO5HIGKZ+f0UxkdVyF2auRBoobbCKlqgPAQ=;
        b=I9RllYFYMawUlXUqHkyXtq0MP1r0I2dJv2Zn1R644e7cjkRFMAvv2610idPCtZFjS2
         HhO10So/8PG/ZI1f+eETw7huRAp6u1AIQt7Au4ItHtEnTzBpLSMWDSam4vZmcEiAAZ6O
         StXUrF5CT8xULmoU+cp3NuhIjXQsVo1Q96lM5jo/qqaYE225DfZVjGq5Abz8pNnhXw8D
         jK4DOszrHtGnkjkfrynNumVUBjY4jkNZfOrVokNswfTbNIjlSWdq+GWLkKoQNTbrESWY
         +/45m3W0CSHQCZp8aVFHziHegwZZjvVPIN73ts86YNpGOvUJmi55t5GgOJr8na6gapwH
         DzYQ==
X-Gm-Message-State: AOAM533JY211DCJ7u4Sp43MKQMPzIahZidqmI5jtBPR62ZgAhygMBYW9
        n2rLl11UUoqSnvVPGIy09nPcky3iOAMKZqHG0mpCng==
X-Google-Smtp-Source: ABdhPJxpHy6/BJUWcDUdY5g10qH+All8zVtFTrAjp9C2q7jQcgGq/aMyju7q5MQTaob+8+AA8TcKSUB4ul1s7iBVhoM=
X-Received: by 2002:a25:fe0d:0:b0:64d:915f:e73e with SMTP id
 k13-20020a25fe0d000000b0064d915fe73emr33071960ybe.447.1654649742822; Tue, 07
 Jun 2022 17:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com> <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
In-Reply-To: <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 7 Jun 2022 17:55:06 -0700
Message-ID: <CAGETcx9f0UBhpp6dM+KJwtYpLx19wwsq6_ygi3En7FrXobOSpA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] deferred_probe_timeout logic clean up
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-Hideaki -- their email keeps bouncing.

On Tue, Jun 7, 2022 at 11:13 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> On Wed, Jun 1, 2022 at 12:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > This series is based on linux-next + these 2 small patches applies on top:
> > https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
> >
> > A lot of the deferred_probe_timeout logic is redundant with
> > fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> > a few cases.
> >
> > This series tries to delete the redundant logic, simplify the frameworks
> > that use driver_deferred_probe_check_state(), enable
> > deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> > case.
> >
> > The overall idea of this series is to replace the global behavior of
> > driver_deferred_probe_check_state() where all devices give up waiting on
> > supplier at the same time with a more granular behavior:
> >
> > 1. Devices with all their suppliers successfully probed by late_initcall
> >    probe as usual and avoid unnecessary deferred probe attempts.
> >
> > 2. At or after late_initcall, in cases where boot would break because of
> >    fw_devlink=on being strict about the ordering, we
> >
> >    a. Temporarily relax the enforcement to probe any unprobed devices
> >       that can probe successfully in the current state of the system.
> >       For example, when we boot with a NFS rootfs and no network device
> >       has probed.
> >    b. Go back to enforcing the ordering for any devices that haven't
> >       probed.
> >
> > 3. After deferred probe timeout expires, we permanently give up waiting
> >    on supplier devices without drivers. At this point, whatever devices
> >    can probe without some of their optional suppliers end up probing.
> >
> > In the case where module support is disabled, it's fairly
> > straightforward and all device probes are completed before the initcalls
> > are done.
> >
> > Patches 1 to 3 are fairly straightforward and can probably be applied
> > right away.
> >
> > Patches 4 to 6 are for fixing the NFS rootfs issue and setting the
> > default deferred_probe_timeout back to 10 seconds when modules are
> > enabled.
> >
> > Patches 7 to 9 are further clean up of the deferred_probe_timeout logic
> > so that no framework has to know/care about deferred_probe_timeout.
> >
> > Yoshihiro/Geert,
> >
> > If you can test this patch series and confirm that the NFS root case
> > works, I'd really appreciate that.
>
> Thanks, I gave this a try on various boards I have access to.
> The results were quite positive. E.g. the compile error I saw on v1
> (implicit declation of fw_devlink_unblock_may_probe(), which is no longer
>  used in v2) is gone.

Thanks a lot for testing these.

> However, I'm seeing a weird error when userspace (Debian9 nfsroot) is
> starting:
>
>     [  OK  ] Started D-Bus System Message Bus.
>     Unable to handle kernel NULL pointer dereference at virtual
> address 0000000000000000
>     Unable to handle kernel NULL pointer dereference at virtual
> address 0000000000000000
>     Mem abort info:
>       ESR = 0x0000000096000004
>     Mem abort info:
>       ESR = 0x0000000096000004
>       EC = 0x25: DABT (current EL), IL = 32 bits
>       SET = 0, FnV = 0
>       EC = 0x25: DABT (current EL), IL = 32 bits
>       EA = 0, S1PTW = 0
>       FSC = 0x04: level 0 translation fault
>       SET = 0, FnV = 0
>     Data abort info:
>       ISV = 0, ISS = 0x00000004
>       EA = 0, S1PTW = 0
>       FSC = 0x04: level 0 translation fault
>       CM = 0, WnR = 0
>     user pgtable: 4k pages, 48-bit VAs, pgdp=000000004ec45000
>     [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
>     Data abort info:
>     Internal error: Oops: 96000004 [#1] PREEMPT SMP
>     CPU: 0 PID: 374 Comm: v4l_id Tainted: G        W
> 5.19.0-rc1-arm64-renesas-00799-gc13c3e49e8bd #1660
>       ISV = 0, ISS = 0x00000004
>     Hardware name: Renesas Ebisu-4D board based on r8a77990 (DT)
>     pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>       CM = 0, WnR = 0
>     pc : subdev_open+0x8c/0x128
>     lr : subdev_open+0x78/0x128
>     sp : ffff80000aadba60
>     x29: ffff80000aadba60 x28: 0000000000000000 x27: ffff80000aadbc58
>     x26: 0000000000020000 x25: ffff00000b3aaf00 x24: 0000000000000000
>     x23: ffff00000c331c00 x22: ffff000009aa61b8 x21: ffff000009aa6000
>     x20: ffff000008bae3e8 x19: ffff00000c3fe200 x18: 0000000000000000
>     x17: ffff800076945000 x16: ffff800008004000 x15: 00008cc6bf550c7c
>     x14: 000000000000038f x13: 000000000000001a x12: ffff00007fba8618
>     x11: 0000000000000001 x10: 0000000000000000 x9 : ffff800009253954
>     x8 : ffff00000b3aaf00 x7 : 0000000000000004 x6 : 000000000000001a
>     x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000001
>     x2 : 0000000100000001 x1 : 0000000000000000 x0 : 0000000000000000
>     Call trace:
>      subdev_open+0x8c/0x128
>      v4l2_open+0xa4/0x120
>      chrdev_open+0x78/0x178
>      do_dentry_open+0xfc/0x398
>      vfs_open+0x28/0x30
>      path_openat+0x584/0x9c8
>      do_filp_open+0x80/0x108
>      do_sys_openat2+0x20c/0x2d8
>     user pgtable: 4k pages, 48-bit VAs, pgdp=000000004ec53000
>      do_sys_open+0x54/0xa0
>      __arm64_sys_openat+0x20/0x28
>      invoke_syscall+0x40/0xf8
>      el0_svc_common.constprop.0+0xf0/0x110
>      do_el0_svc+0x20/0x78
>      el0_svc+0x48/0xd0
>      el0t_64_sync_handler+0xb0/0xb8
>      el0t_64_sync+0x148/0x14c
>     Code: f9405280 f9400400 b40000e0 f9400280 (f9400000)
>     ---[ end trace 0000000000000000 ]---
>
> This only happens on the Ebisu-4D board (r8a77990-ebisu.dts).
> I do not see this on the Salvator-X(S) boards.

Ok. I don't know much about either of these boards. Are they supposed
to be very similar?

> Bisection shows this starts to happen with "[PATCH v2 7/9] driver core:
> Set fw_devlink.strict=1 by default".

So in the series, by this point, the previous patches would have
deferred probe timeout set to 10s (it can get extended on new driver
additions of course) and once the timer expires suppliers without
drivers will no longer block any consumers. The only difference
fw_devlink.strict=1 should cause is iommus and dmas dependency being
treated as mandatory till the timeout expires.

In this instance, do you have iommu drivers and dma drivers compiled
in or loaded as modules or not available at all? In all these case,
the list of devices that would end up probing eventually should be the
same with or without fw_devlink.strict=1. The only difference would be
some reordering of probes.

So this looks to me like improper error handling/assumption in the
driver for this subdev device. I'm guessing one of the suppliers to
this subdev has a direct/indirect dependency on iommus and this subdev
driver is assuming that the supplier would have probed by the time
it's probed.

>
> Adding more debug info:
>
>     subdev_open:54: file v4l-subdev1
>     Unable to handle kernel NULL pointer dereference at virtual
> address 0000000000000000
>     subdev_open:54: file v4l-subdev2
>     Unable to handle kernel NULL pointer dereference at virtual
> address 0000000000000000
>
> Matching the subdev using sysfs gives:
>
>     /sys/devices/platform/soc/e6500000.i2c/i2c-0/0-0070/video4linux/v4l-subdev1
>     /sys/devices/platform/soc/e6500000.i2c/i2c-0/0-0070/video4linux/v4l-subdev2
>
> The i2c device is the adi,adv7482 at address 0x70.

I'm guessing the fix would be somewhere in this driver, but I haven't
dug into it. Any guesses on which of its suppliers might have a
direct/indirect dependency on an iommu/dma? You could also enable the
debug log in fw_devlink_relax_link() and see if it relaxes any link
where the supplier is an iommu/dma device. That might give us some
hints.

-Saravana

> But now I'm lost...
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
