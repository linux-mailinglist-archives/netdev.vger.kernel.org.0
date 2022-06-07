Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860C8540FE6
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 21:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355092AbiFGTOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 15:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355221AbiFGTNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 15:13:43 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9C61BE86;
        Tue,  7 Jun 2022 11:07:18 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id 68so5369292qkk.9;
        Tue, 07 Jun 2022 11:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sk8ELHtWexUUrH4wjT93cWzy6OVcezs2TB9a8yknN/0=;
        b=ZY8XgDnctz/8netL6z9v5S10UThuLgBHLFZwKYW/5ZJSmRtABx+rT5/KM2IDyJ6L+P
         rgB+D1HvkgvET8jbAj9q+U9JPh8KZa5DV1ROMzsJ3VujA7lobVVYvJdzWCSUvzBdpsJO
         b9xAgmS7U1FqmcB79UnCsi14KSkmCTqArcaPRMC8ctxTpaOdB3ZjPFUo4PHWd2kpwJMB
         8fXCmKtsPtUKTpemW/G2eMewz/ADBq4Zi8yAUlNdXUcwlLYwUdd6DL+1P04bM1L7ETRX
         3hVfrZSKoU5IJgTgHkwsC20P9mBjO3vnGWrxJF502q9Ma5aCbXFIjnIBlE8KKfP95pF7
         aGqA==
X-Gm-Message-State: AOAM5322kH5ms+mG2/yDNV56xKRP9E5fIu78ph9TaJGq2DxWEp1G2Jq9
        QPBfCGlxn3y6A7VdNsus8uuJqBOZQ5ck0A==
X-Google-Smtp-Source: ABdhPJyrSZfXRPGcpX9jEvPRajECGV0n/8UcXrxwXjYg0zhDvmVOvtw1b9sHqW71cOsF8wHFEvbdtA==
X-Received: by 2002:a05:620a:3184:b0:6a5:8e2e:766d with SMTP id bi4-20020a05620a318400b006a58e2e766dmr19977273qkb.482.1654625237130;
        Tue, 07 Jun 2022 11:07:17 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id f23-20020ac84717000000b002fcb0d95f65sm9433530qtp.90.2022.06.07.11.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 11:07:16 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id p13so32449632ybm.1;
        Tue, 07 Jun 2022 11:07:16 -0700 (PDT)
X-Received: by 2002:a05:6902:120e:b0:634:6f29:6b84 with SMTP id
 s14-20020a056902120e00b006346f296b84mr32057546ybu.604.1654625235683; Tue, 07
 Jun 2022 11:07:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
In-Reply-To: <20220601070707.3946847-1-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Jun 2022 20:07:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
Message-ID: <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] deferred_probe_timeout logic clean up
To:     Saravana Kannan <saravanak@google.com>
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
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jun 1, 2022 at 12:46 PM Saravana Kannan <saravanak@google.com> wrote:
> This series is based on linux-next + these 2 small patches applies on top:
> https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
>
> A lot of the deferred_probe_timeout logic is redundant with
> fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> a few cases.
>
> This series tries to delete the redundant logic, simplify the frameworks
> that use driver_deferred_probe_check_state(), enable
> deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> case.
>
> The overall idea of this series is to replace the global behavior of
> driver_deferred_probe_check_state() where all devices give up waiting on
> supplier at the same time with a more granular behavior:
>
> 1. Devices with all their suppliers successfully probed by late_initcall
>    probe as usual and avoid unnecessary deferred probe attempts.
>
> 2. At or after late_initcall, in cases where boot would break because of
>    fw_devlink=on being strict about the ordering, we
>
>    a. Temporarily relax the enforcement to probe any unprobed devices
>       that can probe successfully in the current state of the system.
>       For example, when we boot with a NFS rootfs and no network device
>       has probed.
>    b. Go back to enforcing the ordering for any devices that haven't
>       probed.
>
> 3. After deferred probe timeout expires, we permanently give up waiting
>    on supplier devices without drivers. At this point, whatever devices
>    can probe without some of their optional suppliers end up probing.
>
> In the case where module support is disabled, it's fairly
> straightforward and all device probes are completed before the initcalls
> are done.
>
> Patches 1 to 3 are fairly straightforward and can probably be applied
> right away.
>
> Patches 4 to 6 are for fixing the NFS rootfs issue and setting the
> default deferred_probe_timeout back to 10 seconds when modules are
> enabled.
>
> Patches 7 to 9 are further clean up of the deferred_probe_timeout logic
> so that no framework has to know/care about deferred_probe_timeout.
>
> Yoshihiro/Geert,
>
> If you can test this patch series and confirm that the NFS root case
> works, I'd really appreciate that.

Thanks, I gave this a try on various boards I have access to.
The results were quite positive. E.g. the compile error I saw on v1
(implicit declation of fw_devlink_unblock_may_probe(), which is no longer
 used in v2) is gone.

However, I'm seeing a weird error when userspace (Debian9 nfsroot) is
starting:

    [  OK  ] Started D-Bus System Message Bus.
    Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000
    Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000
    Mem abort info:
      ESR = 0x0000000096000004
    Mem abort info:
      ESR = 0x0000000096000004
      EC = 0x25: DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EC = 0x25: DABT (current EL), IL = 32 bits
      EA = 0, S1PTW = 0
      FSC = 0x04: level 0 translation fault
      SET = 0, FnV = 0
    Data abort info:
      ISV = 0, ISS = 0x00000004
      EA = 0, S1PTW = 0
      FSC = 0x04: level 0 translation fault
      CM = 0, WnR = 0
    user pgtable: 4k pages, 48-bit VAs, pgdp=000000004ec45000
    [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
    Data abort info:
    Internal error: Oops: 96000004 [#1] PREEMPT SMP
    CPU: 0 PID: 374 Comm: v4l_id Tainted: G        W
5.19.0-rc1-arm64-renesas-00799-gc13c3e49e8bd #1660
      ISV = 0, ISS = 0x00000004
    Hardware name: Renesas Ebisu-4D board based on r8a77990 (DT)
    pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
      CM = 0, WnR = 0
    pc : subdev_open+0x8c/0x128
    lr : subdev_open+0x78/0x128
    sp : ffff80000aadba60
    x29: ffff80000aadba60 x28: 0000000000000000 x27: ffff80000aadbc58
    x26: 0000000000020000 x25: ffff00000b3aaf00 x24: 0000000000000000
    x23: ffff00000c331c00 x22: ffff000009aa61b8 x21: ffff000009aa6000
    x20: ffff000008bae3e8 x19: ffff00000c3fe200 x18: 0000000000000000
    x17: ffff800076945000 x16: ffff800008004000 x15: 00008cc6bf550c7c
    x14: 000000000000038f x13: 000000000000001a x12: ffff00007fba8618
    x11: 0000000000000001 x10: 0000000000000000 x9 : ffff800009253954
    x8 : ffff00000b3aaf00 x7 : 0000000000000004 x6 : 000000000000001a
    x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000001
    x2 : 0000000100000001 x1 : 0000000000000000 x0 : 0000000000000000
    Call trace:
     subdev_open+0x8c/0x128
     v4l2_open+0xa4/0x120
     chrdev_open+0x78/0x178
     do_dentry_open+0xfc/0x398
     vfs_open+0x28/0x30
     path_openat+0x584/0x9c8
     do_filp_open+0x80/0x108
     do_sys_openat2+0x20c/0x2d8
    user pgtable: 4k pages, 48-bit VAs, pgdp=000000004ec53000
     do_sys_open+0x54/0xa0
     __arm64_sys_openat+0x20/0x28
     invoke_syscall+0x40/0xf8
     el0_svc_common.constprop.0+0xf0/0x110
     do_el0_svc+0x20/0x78
     el0_svc+0x48/0xd0
     el0t_64_sync_handler+0xb0/0xb8
     el0t_64_sync+0x148/0x14c
    Code: f9405280 f9400400 b40000e0 f9400280 (f9400000)
    ---[ end trace 0000000000000000 ]---

This only happens on the Ebisu-4D board (r8a77990-ebisu.dts).
I do not see this on the Salvator-X(S) boards.

Bisection shows this starts to happen with "[PATCH v2 7/9] driver core:
Set fw_devlink.strict=1 by default".

Adding more debug info:

    subdev_open:54: file v4l-subdev1
    Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000
    subdev_open:54: file v4l-subdev2
    Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000

Matching the subdev using sysfs gives:

    /sys/devices/platform/soc/e6500000.i2c/i2c-0/0-0070/video4linux/v4l-subdev1
    /sys/devices/platform/soc/e6500000.i2c/i2c-0/0-0070/video4linux/v4l-subdev2

The i2c device is the adi,adv7482 at address 0x70.
But now I'm lost...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
