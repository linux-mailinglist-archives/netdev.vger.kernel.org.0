Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2954F45AADF
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbhKWSKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 13:10:39 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:46028 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbhKWSK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 13:10:27 -0500
Received: by mail-ot1-f53.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso89088otf.12;
        Tue, 23 Nov 2021 10:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zISZonE+jfcuqih+VqZkba/z0VBN8Lm0GEq4vywk61c=;
        b=vHMCPzGfzwcCgAHfRHw5HW54Wbuc/3zyOLTpw7yn2rh4aVJG4jUmJA4ajguSKHMQoG
         cykj/JzNLOI0AvVvH/bJQe9iujg3MZsSXL0M2N16ga/8uT/Dt8447iJH7cEXVFq+1D9A
         Vy833nVuON+mY+KURdtgYjjmWSwo/IGgYlb/6f8LYDPIkFf1oHgIfHPHCmesmlM+JS26
         Xm81MJlNCDFsbbbVgdV/Hw4IOzHWuM5oZl94tUSlfjaxoE6LeD+MWYuWb5SWg1rRkdrv
         LroaCq6vL1C8O48dyhqJUp0gtvHPd1JZoOy8ZkoMByVi3zY3rin9P4eEHl8DHC3O15j5
         qzJQ==
X-Gm-Message-State: AOAM532ue9hS1FUHyR8VykxCESrMxaT2rvtRrhM5Q8wBdEMsvZklJdyL
        9EJDM0ec+Y3gQMWNSlHNo3Wnx6sf6U0T1vO0XUw=
X-Google-Smtp-Source: ABdhPJwF2ep52rxDLG6UpRp3xdWO1LK2aeGUp8ki3Y6ep8Od1B4KnhnGqvqMfV3sQKXaxIByEQB9U2fm2A3fPfoMQds=
X-Received: by 2002:a05:6830:1e57:: with SMTP id e23mr6327907otj.16.1637690838752;
 Tue, 23 Nov 2021 10:07:18 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com> <20211119113644.1600-3-alx.manpages@gmail.com>
In-Reply-To: <20211119113644.1600-3-alx.manpages@gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 23 Nov 2021 19:07:07 +0100
Message-ID: <CAJZ5v0jGgxgTWQ-DLehRE_GPoRMz2TnT469uNE8k6TX7NxQdEA@mail.gmail.com>
Subject: Re: [PATCH 02/17] Use memberof(T, m) instead of explicit NULL dereference
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-btrfs@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 12:37 PM Alejandro Colomar
<alx.manpages@gmail.com> wrote:
>
> Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
> Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Corey Minyard <cminyard@mvista.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: John S. Gruber <JohnSGruber@gmail.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Somnath Kotur <somnath.kotur@broadcom.com>
> Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
> Cc: <intel-gfx@lists.freedesktop.org>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: <linux-arm-kernel@lists.infradead.org>
> Cc: <linux-btrfs@vger.kernel.org>
> Cc: <linux-scsi@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: <virtualization@lists.linux-foundation.org>
> ---
>  arch/x86/include/asm/bootparam_utils.h  |  3 ++-
>  arch/x86/kernel/signal_compat.c         |  5 +++--
>  drivers/gpu/drm/i915/i915_utils.h       |  5 ++---
>  drivers/gpu/drm/i915/intel_runtime_pm.h |  2 +-
>  drivers/net/ethernet/emulex/benet/be.h  |  7 ++++---
>  drivers/net/ethernet/i825xx/ether1.c    |  7 +++++--
>  drivers/scsi/be2iscsi/be.h              |  7 ++++---
>  drivers/scsi/be2iscsi/be_cmds.h         |  5 ++++-
>  fs/btrfs/ctree.h                        |  5 +++--
>  include/acpi/actypes.h                  |  4 +++-

The change in actypes.h would need to be submitted to the upstream
ACPICA project via https://github.com/acpica/acpica/

Thanks!

>  include/linux/container_of.h            |  6 +++---
>  include/linux/virtio_config.h           | 14 +++++++-------
>  12 files changed, 41 insertions(+), 29 deletions(-)
