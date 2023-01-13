Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004056690A4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjAMIXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbjAMIWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:22:36 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9D22022;
        Fri, 13 Jan 2023 00:19:48 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id j15so13047252qtv.4;
        Fri, 13 Jan 2023 00:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MowQaQp0G9uX2jhG1rQLtIGSPC7S+MJhKLN+g9WmpVM=;
        b=el2XoDs9Rx15fpn1LkUmpizUAlrQktSLBbXWFPUan3PrdWaITXGPK4gXy5odfK/be2
         xYV5v/6RF3GbIz0QDmX8Hgl+dZExurKd0xQT+/IbvMyJ0qrxL3A+RpLtldiM9OLgR1cq
         hvrdRRJBDQGAFrdmpCh+KDMSxmG0GhIBYXUPC4EiQPkAoDDOldcNKRgPNvaGewXZLWmk
         9gFrnL6/WRbWFSHEIm/Ixj4xPZ4NsQnTgbwP/XdEElRtYEam4hlECmj/dIL99tgFaZme
         DCGS+eJh10LKslT207MZuVAQGBCvh7fqEa/DrZOh4UQ109fS4DcYVI97RuRPa/buQoSV
         IiMw==
X-Gm-Message-State: AFqh2krWXEOYU1LKIBgksuqgpuGjN2QdZrxD9D4EfoSlrRUgYTGPUd3o
        ssVr/XINvnR/maM1Enm0TJcmL2Po8Z6EbA==
X-Google-Smtp-Source: AMrXdXt2A3y0C7fYLdtAO5xHmkf9XuWzBkFjZ07LasgooqTk66dX7n7EUkumqmFKc7fjlBxZxWui1g==
X-Received: by 2002:ac8:4a97:0:b0:3a8:1ca1:b489 with SMTP id l23-20020ac84a97000000b003a81ca1b489mr94322090qtq.60.1673597987448;
        Fri, 13 Jan 2023 00:19:47 -0800 (PST)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id bq25-20020a05622a1c1900b003a57a317c17sm10211765qtb.74.2023.01.13.00.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:19:46 -0800 (PST)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-4c24993965eso268088687b3.12;
        Fri, 13 Jan 2023 00:19:46 -0800 (PST)
X-Received: by 2002:a05:690c:313:b0:37e:6806:a5f9 with SMTP id
 bg19-20020a05690c031300b0037e6806a5f9mr3489142ywb.47.1673597985912; Fri, 13
 Jan 2023 00:19:45 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-2-hch@lst.de>
 <Y8EMZ0GI5rtor9xr@pendragon.ideasonboard.com> <Y8EOWGVmwEElKGE4@pendragon.ideasonboard.com>
In-Reply-To: <Y8EOWGVmwEElKGE4@pendragon.ideasonboard.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:19:34 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXRkUu3AuLs7X30ki1votAQfBU3HWvWB6qMQJBSUEr6WA@mail.gmail.com>
Message-ID: <CAMuHMdXRkUu3AuLs7X30ki1votAQfBU3HWvWB6qMQJBSUEr6WA@mail.gmail.com>
Subject: Re: [PATCH 01/22] gpu/drm: remove the shmobile drm driver
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 8:55 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Fri, Jan 13, 2023 at 09:46:49AM +0200, Laurent Pinchart wrote:
> > On Fri, Jan 13, 2023 at 07:23:18AM +0100, Christoph Hellwig wrote:
> > > This driver depends on ARM && ARCH_SHMOBILE, but ARCH_SHMOBILE can only be
> > > set for each/sh, making the driver dead code except for the COMPILE_TEST
> > > case.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > No objection from me.
> >
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> To expand a little bit on this, ARCH_SHMOBILE used to be set for the
> ARM-based shmobile SoCs too, until
>
> commit 08e735233ea29b17bfec8e4cb302e799d9f920b8
> Author: Geert Uytterhoeven <geert+renesas@glider.be>
> Date:   Tue Aug 28 17:10:10 2018 +0200
>
>     ARM: shmobile: Remove the ARCH_SHMOBILE Kconfig symbol
>
>     All drivers for Renesas ARM SoCs have gained proper ARCH_RENESAS
>     platform dependencies.  Hence finish the conversion from ARCH_SHMOBILE
>     to ARCH_RENESAS for Renesas 32-bit ARM SoCs, as started by commit
>     9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS").
>
>     Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>     Acked-by: Arnd Bergmann <arnd@arndb.de>
>     Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>
> merged in v4.20. The DRM shmobile driver's Kconfig entry wasn't updated,
> making it dead code indeed.

Note that it wasn't updated because this driver was not used on Renesas
ARM platforms, due to the lack of DT bindings and DT support, so it
didn't make sense to make it selectable.

> I haven't tested this driver in ages, hence my lack of objection, but
> someone may want to keep it for the pre-R-Car ARM SoCs.

Indeed, this driver should work with the R-Mobile A1 (which made it
into orbit, so we could call it the first member of R-Space ;-) and
SH-Mobile AG5 SoCs.  The major blocker is the lack of DT bindings.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
