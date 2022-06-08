Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3247543E3C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbiFHVIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiFHVIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:08:24 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121532271B9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:08:22 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-30c2f288f13so222180897b3.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 14:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5ReOqAs2o3gzeqG3OL7V4il5yL5akHyIyGPxcacfBA=;
        b=Ba4mwhCNe1k/SVYGgiax1RHLVYaE16PYm+5fiQboXFgD/ag+N5cvz705MN4rVjpIPI
         20mqv9SEpUPx3PtChBxCddPxC3gpwz6N5PF+G0ZElhJAMs7eaWr/Z+J8nMSxF5pOKofY
         CLFQyzIeUPghYqThB66mUFHJcWTC93ASqEVRt3LVLl9QPXBD+PYs/yU2uLqcxreGwdik
         4HASNcsIvuV/mOpjIf/knlk/2pymeg4ut2QXPF/hi4finuKXsMk29G9quSLgCq5XjL9S
         aWkJqkdgxfW8i8wPGvE0N8YcrI2ZFizB9Lbxi1u9CnGJusfu9M2jfO6bciIlSU/xqWwh
         708Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5ReOqAs2o3gzeqG3OL7V4il5yL5akHyIyGPxcacfBA=;
        b=wq4ZL3AEsh/fq8c0foS4k8DKESCNr2hMLqmXbHDgHTFHmECB0FP6jq/74IpSwzAnAI
         /86QNqZiIdyY5wcyfpEUaAF9cOjTy097MWLvj1YlfaIMwhBR6vK/6JgtHB8pAGRxCeMn
         NpMhgzG5TSdmt2CZyi1Uf5aocFZayoQEBeJQdD77miTgWmY25C01oe0OLyamZYS2a2NU
         9K9IsF7yvrANuNSxc85o3zIZZkKzSp/9pfU5YDGpml2wXoH/BbmBWfaYBlbRP1WSmJIB
         PZoeeS+KMsvr1QYTYwEw1hUtL4gPqCKJOWVhTH95+H1/Ktmj3XBQZeH89IY474fj5UNS
         byCA==
X-Gm-Message-State: AOAM5334igTb8n5dcqvQn5T3hegvnRLcbwLYc4jqkWy5vChBW+xf/RA+
        KLHJiHmOOfjW6mJ5xJEEGsR7U+sB13a4diBbVADlbA==
X-Google-Smtp-Source: ABdhPJwApqB8Aa/s/hWKyN1cGMg0w6J6U6ZpPLsgPu6Z8rVbvyvZo/4KRS+qCvxDCZ36rJaIIDOHULExfT8EFh33Nno=
X-Received: by 2002:a0d:c984:0:b0:30c:c95c:21d0 with SMTP id
 l126-20020a0dc984000000b0030cc95c21d0mr41306613ywd.218.1654722500963; Wed, 08
 Jun 2022 14:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
 <CAGETcx9f0UBhpp6dM+KJwtYpLx19wwsq6_ygi3En7FrXobOSpA@mail.gmail.com>
 <CAGETcx8VM+xOCe7HEx9FUU-1B9nrX8Q=tE=NjTyb9uX2_8RXLQ@mail.gmail.com>
 <CAMuHMdXzu8Vp=a7fyjOB=xt04aee=vWXV=TcRZeeKUGYFFZ1CA@mail.gmail.com>
 <CAGETcx_Nqo4ju7cWwO3dP3YM2wpCb0jx23OHOReexOjpT5pATA@mail.gmail.com> <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
In-Reply-To: <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 8 Jun 2022 14:07:44 -0700
Message-ID: <CAGETcx8UO=4mk31tU4QaWU3RaNM_myA9woe0idBp6p7+X5AEgg@mail.gmail.com>
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
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_HEX,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:54 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> On Wed, Jun 8, 2022 at 8:13 PM Saravana Kannan <saravanak@google.com> wrote:
> > On Wed, Jun 8, 2022 at 3:26 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, Jun 8, 2022 at 6:17 AM Saravana Kannan <saravanak@google.com> wrote:
> > > > On Tue, Jun 7, 2022 at 5:55 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > On Tue, Jun 7, 2022 at 11:13 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > > > On Wed, Jun 1, 2022 at 12:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > > > This series is based on linux-next + these 2 small patches applies on top:
> > > > > > > https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
> > > > > > >
> > > > > > > A lot of the deferred_probe_timeout logic is redundant with
> > > > > > > fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> > > > > > > a few cases.
> > > > > > >
> > > > > > > This series tries to delete the redundant logic, simplify the frameworks
> > > > > > > that use driver_deferred_probe_check_state(), enable
> > > > > > > deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> > > > > > > case.
> > > > > > >
> > > > > > > The overall idea of this series is to replace the global behavior of
> > > > > > > driver_deferred_probe_check_state() where all devices give up waiting on
> > > > > > > supplier at the same time with a more granular behavior:
> > > > > > >
> > > > > > > 1. Devices with all their suppliers successfully probed by late_initcall
> > > > > > >    probe as usual and avoid unnecessary deferred probe attempts.
> > > > > > >
> > > > > > > 2. At or after late_initcall, in cases where boot would break because of
> > > > > > >    fw_devlink=on being strict about the ordering, we
> > > > > > >
> > > > > > >    a. Temporarily relax the enforcement to probe any unprobed devices
> > > > > > >       that can probe successfully in the current state of the system.
> > > > > > >       For example, when we boot with a NFS rootfs and no network device
> > > > > > >       has probed.
> > > > > > >    b. Go back to enforcing the ordering for any devices that haven't
> > > > > > >       probed.
> > > > > > >
> > > > > > > 3. After deferred probe timeout expires, we permanently give up waiting
> > > > > > >    on supplier devices without drivers. At this point, whatever devices
> > > > > > >    can probe without some of their optional suppliers end up probing.
> > > > > > >
> > > > > > > In the case where module support is disabled, it's fairly
> > > > > > > straightforward and all device probes are completed before the initcalls
> > > > > > > are done.
> > > > > > >
> > > > > > > Patches 1 to 3 are fairly straightforward and can probably be applied
> > > > > > > right away.
> > > > > > >
> > > > > > > Patches 4 to 6 are for fixing the NFS rootfs issue and setting the
> > > > > > > default deferred_probe_timeout back to 10 seconds when modules are
> > > > > > > enabled.
> > > > > > >
> > > > > > > Patches 7 to 9 are further clean up of the deferred_probe_timeout logic
> > > > > > > so that no framework has to know/care about deferred_probe_timeout.
> > > > > > >
> > > > > > > Yoshihiro/Geert,
> > > > > > >
> > > > > > > If you can test this patch series and confirm that the NFS root case
> > > > > > > works, I'd really appreciate that.
> > > > > >
> > > > > > Thanks, I gave this a try on various boards I have access to.
> > > > > > The results were quite positive. E.g. the compile error I saw on v1
> > > > > > (implicit declation of fw_devlink_unblock_may_probe(), which is no longer
> > > > > >  used in v2) is gone.
> > > > >
> > > > > Thanks a lot for testing these.
> > > > >
> > > > > > However, I'm seeing a weird error when userspace (Debian9 nfsroot) is
> > > > > > starting:
>
> > > Setting fw_devlink_strict to true vs. false seems to influence which of
> > > two different failures will happen:
> > >   - rcar-csi2: probe of feaa0000.csi2 failed with error -22
> > >   - rcar-vin: probe of e6ef5000.video failed with error -22
> > > The former causes the NULL pointer dereference later.
> > > The latter existed before, but I hadn't noticed it, and bisection
> > > led to the real culprit (commit 3e52419ec04f9769 ("media: rcar-{csi2,vin}:
> > > Move to full Virtual Channel routing per CSI-2 IP").
> >
> > If you revert that patch, does this series work fine? If yes, are you
> > happy with giving this a Tested-by?
>
> Sure, sorry for forgetting that ;-)
>
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

+few folks who I forgot to add.

Geert,

Thanks for the extensive testing!

Linus W, Ulf, Kevin, Will, Rob, Vladimir,

Can I get your reviews for the deletion of
driver_deferred_probe_check_state() please? We can finally remove it
and have frameworks not needing to know about it.

Greg, Rafael,

Can you review the wait_for_init_devices_probe() patch and the other
trivial driver core changes please?

David/Jakub,

Do the IP4 autoconfig changes look reasonable to you?

Thanks,
Saravana


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
