Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA002D7D73
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392884AbgLKRyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392465AbgLKRyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:54:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E59C0613D3;
        Fri, 11 Dec 2020 09:53:35 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p21so2119768pjv.0;
        Fri, 11 Dec 2020 09:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qJMuReBBloytY5lBy9ILiGRjMb37kF5Bm1u/sykMtGI=;
        b=pbcP9ZyMd8cecm/Ac29HxHof8LYE8oIxJsfNxtiP4g+O1ufaXL9wqRka/RSo4Tovrl
         0+y5AKL9oCVabUsoTOFqz/Yq9QfdTj0Typ4F+2X8XEQKxDDPDKl8NptHh9zo30qru18d
         QGlaxM7GEPdID0olwlCiRofo+G16Jl5uy1wTEIGaTXATmtYB0SKJ7RfAvwDsjDcWrkzF
         kKjuZM4tWxnD1BBGBwlxpereCqs+GnyIsKzQ1aCY79/NwQxDiafuQ2m4U5xGO28vG9vA
         fsrh/72iZb6gHAJp4ifwj1MfQl9QfYGQYjUntoAEcq5P8hce+uphA5O/Y7Ku0HiAUL7i
         H9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJMuReBBloytY5lBy9ILiGRjMb37kF5Bm1u/sykMtGI=;
        b=OfMGmrKWTdgRG3fArWX/z+zJgrEqHuNbCVUjyKZauzrb61nvgkCzaSBwqD0hhTU4sa
         musaRuA8qShew7YQwxfm9hN/sjxDsf4QBHsNvgKgkFe/SjDgk+cr13+zVX65VxJ6AJPI
         AvWJqwrUZn713AeD7kHAvehQ17hZOtT5gh/KzDF1i6e8n6bSrFKRTBjYev5iLaEULPds
         qQ3Zf8SJ9weCihTpe3u+cRYq9ErPF6hKgAQ3ZHApJaRCDTYQFvFyow8myyEs0ZuSqQUG
         7kBqZFd87C/CgRPxMWNHcNkhZv3oGKTJ8GjOnBdS/G/J54/+9xVWuczkCtFnfrEyI//A
         8Z3g==
X-Gm-Message-State: AOAM531x0VBWbdZvVmI85ny79uEVbY7VVrasorSRIC/XdQbFK9xrmP3D
        Lj5xb0wJ8fTSDM6pb8BJNDtud2C+7sdwcN01MeY=
X-Google-Smtp-Source: ABdhPJzHUDKz30vqqKYAobJsngcYE8DjK4RijmUtwtDAm93E/clqz0VBoWDrwvzZzwrJPWtEJfA5ahq579HFtI6a1+g=
X-Received: by 2002:a17:90a:34cb:: with SMTP id m11mr14313128pjf.181.1607709215341;
 Fri, 11 Dec 2020 09:53:35 -0800 (PST)
MIME-Version: 1.0
References: <20201210192536.118432146@linutronix.de> <20201210194042.860029489@linutronix.de>
In-Reply-To: <20201210194042.860029489@linutronix.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 11 Dec 2020 19:53:07 +0200
Message-ID: <CAHp75Vc-2OjE2uwvNRiyLMQ8GSN3P7SehKD-yf229_7ocaktiw@mail.gmail.com>
Subject: Re: [patch 03/30] genirq: Move irq_set_lockdep_class() to core
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 10:14 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> irq_set_lockdep_class() is used from modules and requires irq_to_desc() to
> be exported. Move it into the core code which lifts another requirement for
> the export.

...

> +       if (IS_ENABLED(CONFIG_LOCKDEP))
> +               __irq_set_lockdep_class(irq, lock_class, request_class);

Maybe I missed something, but even if the compiler does not warn the
use of if IS_ENABLED() with complimentary #ifdef seems inconsistent.

> +#ifdef CONFIG_LOCKDEP
...
> +EXPORT_SYMBOL_GPL(irq_set_lockdep_class);
> +#endif


-- 
With Best Regards,
Andy Shevchenko
