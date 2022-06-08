Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC94D543BB8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiFHSrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiFHSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:47:51 -0400
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E83955365;
        Wed,  8 Jun 2022 11:47:50 -0700 (PDT)
Received: by mail-qk1-f172.google.com with SMTP id k6so13121005qkf.4;
        Wed, 08 Jun 2022 11:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cCx4uVeqQeSUmVm0iqQB2vFXf1PboEGJhslplIjAGsc=;
        b=TJqV7fzzDU9w7+AJrBGLLjYSJ8hmFRr81LI/DC6KsqmGZNz2yRLNmfTDwQxRg37/bO
         ba7RFBEnIxWhsyLdGB72v52NQ0oMt+9pkheBzvmKy/gM1gNK+YzEte//ASOSBKH19Qe+
         GESQBiEbTYAgzEnj2235r3jdRaxBNe4CKQaArBdXn68oG73+PmbAZTla2xpFNT2KyMBg
         WIsAoVQ0mAR1pXoDTIokH4aBviu3YsfAx2pSjTkB9WS+7I9hzWfNa3IlGNr11/s4EwRY
         Hifp3UxZE4cCplHTzjA5vWTgPxU05Aaf/fKA23XaJiNxSl1JQX/XhDhdI3jPp3nI6gjk
         L9Zg==
X-Gm-Message-State: AOAM5335xLTr3ZL0t4t5y+ir5Wa6U+MGA1UzqgvLNohCy51RRm8AeXbQ
        DDQefOv6UZK9zHBAlEui8FhC8xh8+osMcA==
X-Google-Smtp-Source: ABdhPJzc/ORM8GGBI29tjlSFStybvgxYar63zFoTbShoSlq/iV8cI5JOCLGaMDCmPC7O0P5Bhmg1eg==
X-Received: by 2002:a05:620a:12e6:b0:6a6:a5b9:1c57 with SMTP id f6-20020a05620a12e600b006a6a5b91c57mr17865292qkl.393.1654714069233;
        Wed, 08 Jun 2022 11:47:49 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id g22-20020ac870d6000000b00304e0245d88sm10868542qtp.48.2022.06.08.11.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 11:47:48 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id w2so38002867ybi.7;
        Wed, 08 Jun 2022 11:47:48 -0700 (PDT)
X-Received: by 2002:a05:6902:124c:b0:663:9db4:671c with SMTP id
 t12-20020a056902124c00b006639db4671cmr16391806ybu.543.1654714068446; Wed, 08
 Jun 2022 11:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
 <CAGETcx9f0UBhpp6dM+KJwtYpLx19wwsq6_ygi3En7FrXobOSpA@mail.gmail.com>
 <CAGETcx8VM+xOCe7HEx9FUU-1B9nrX8Q=tE=NjTyb9uX2_8RXLQ@mail.gmail.com>
 <CAMuHMdXzu8Vp=a7fyjOB=xt04aee=vWXV=TcRZeeKUGYFFZ1CA@mail.gmail.com> <CAGETcx_Nqo4ju7cWwO3dP3YM2wpCb0jx23OHOReexOjpT5pATA@mail.gmail.com>
In-Reply-To: <CAGETcx_Nqo4ju7cWwO3dP3YM2wpCb0jx23OHOReexOjpT5pATA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 8 Jun 2022 20:47:36 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
Message-ID: <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
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
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_HEX autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jun 8, 2022 at 8:13 PM Saravana Kannan <saravanak@google.com> wrote:
> On Wed, Jun 8, 2022 at 3:26 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Jun 8, 2022 at 6:17 AM Saravana Kannan <saravanak@google.com> wrote:
> > > On Tue, Jun 7, 2022 at 5:55 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > On Tue, Jun 7, 2022 at 11:13 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > > On Wed, Jun 1, 2022 at 12:46 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > > This series is based on linux-next + these 2 small patches applies on top:
> > > > > > https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
> > > > > >
> > > > > > A lot of the deferred_probe_timeout logic is redundant with
> > > > > > fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> > > > > > a few cases.
> > > > > >
> > > > > > This series tries to delete the redundant logic, simplify the frameworks
> > > > > > that use driver_deferred_probe_check_state(), enable
> > > > > > deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> > > > > > case.
> > > > > >
> > > > > > The overall idea of this series is to replace the global behavior of
> > > > > > driver_deferred_probe_check_state() where all devices give up waiting on
> > > > > > supplier at the same time with a more granular behavior:
> > > > > >
> > > > > > 1. Devices with all their suppliers successfully probed by late_initcall
> > > > > >    probe as usual and avoid unnecessary deferred probe attempts.
> > > > > >
> > > > > > 2. At or after late_initcall, in cases where boot would break because of
> > > > > >    fw_devlink=on being strict about the ordering, we
> > > > > >
> > > > > >    a. Temporarily relax the enforcement to probe any unprobed devices
> > > > > >       that can probe successfully in the current state of the system.
> > > > > >       For example, when we boot with a NFS rootfs and no network device
> > > > > >       has probed.
> > > > > >    b. Go back to enforcing the ordering for any devices that haven't
> > > > > >       probed.
> > > > > >
> > > > > > 3. After deferred probe timeout expires, we permanently give up waiting
> > > > > >    on supplier devices without drivers. At this point, whatever devices
> > > > > >    can probe without some of their optional suppliers end up probing.
> > > > > >
> > > > > > In the case where module support is disabled, it's fairly
> > > > > > straightforward and all device probes are completed before the initcalls
> > > > > > are done.
> > > > > >
> > > > > > Patches 1 to 3 are fairly straightforward and can probably be applied
> > > > > > right away.
> > > > > >
> > > > > > Patches 4 to 6 are for fixing the NFS rootfs issue and setting the
> > > > > > default deferred_probe_timeout back to 10 seconds when modules are
> > > > > > enabled.
> > > > > >
> > > > > > Patches 7 to 9 are further clean up of the deferred_probe_timeout logic
> > > > > > so that no framework has to know/care about deferred_probe_timeout.
> > > > > >
> > > > > > Yoshihiro/Geert,
> > > > > >
> > > > > > If you can test this patch series and confirm that the NFS root case
> > > > > > works, I'd really appreciate that.
> > > > >
> > > > > Thanks, I gave this a try on various boards I have access to.
> > > > > The results were quite positive. E.g. the compile error I saw on v1
> > > > > (implicit declation of fw_devlink_unblock_may_probe(), which is no longer
> > > > >  used in v2) is gone.
> > > >
> > > > Thanks a lot for testing these.
> > > >
> > > > > However, I'm seeing a weird error when userspace (Debian9 nfsroot) is
> > > > > starting:

> > Setting fw_devlink_strict to true vs. false seems to influence which of
> > two different failures will happen:
> >   - rcar-csi2: probe of feaa0000.csi2 failed with error -22
> >   - rcar-vin: probe of e6ef5000.video failed with error -22
> > The former causes the NULL pointer dereference later.
> > The latter existed before, but I hadn't noticed it, and bisection
> > led to the real culprit (commit 3e52419ec04f9769 ("media: rcar-{csi2,vin}:
> > Move to full Virtual Channel routing per CSI-2 IP").
>
> If you revert that patch, does this series work fine? If yes, are you
> happy with giving this a Tested-by?

Sure, sorry for forgetting that ;-)

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
