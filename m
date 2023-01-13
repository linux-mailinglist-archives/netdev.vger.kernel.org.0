Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32D46691E5
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240979AbjAMIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbjAMIyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:54:09 -0500
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8ED291;
        Fri, 13 Jan 2023 00:54:08 -0800 (PST)
Received: by mail-qt1-f178.google.com with SMTP id fd15so8636792qtb.9;
        Fri, 13 Jan 2023 00:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iHH87Wz4eqdDYk3yPRdInSdOf4/Qu/uaLfX4LZwjHtY=;
        b=hwzdL5Vsnv5tsdZ8kEDfXzBEwiGntRRPfBFxRTU8JmL5JQVZZUk1KrmB3zfpwu/p0g
         NdfONFUxYmNXjmAneiGfqVWoz3OSHrEj9GkIWFBG2w0LZZScN4bBzkrdRYrV1RKZiXSe
         rnkJIFURfoqiSP/u4+Nbcz+ELGYeQQ09PGYzU0DmuNhFm/YzSoTSeqF+sDwZomSS05Ze
         1vQlobxId2dBYvoB5iR0fDeuAcCVAssVjX4ikTv//alfktd4UWT2yr4AYyVMblw1iPi3
         ARENL3s2dc0MAYDu4djO3hjrqDT7mdWTjYLsKG8FyBzlPq7P9XIoCXJM/YEL9jFaD2xd
         jevg==
X-Gm-Message-State: AFqh2kplNBKQhaw/a/OmyptVWHVCWtHJ4dIyFbGxJAf8VYbP4mEOhRlX
        nqT8ADpIk9M+36C0K811Tt/Mm/n0lUYmYg==
X-Google-Smtp-Source: AMrXdXtR3bIR2l/QOAPxyNYAHafBmBqhqqO0MlEWl6UKgCjDJfPp+euSg0P7zcCr/HxpJXbHKodO2w==
X-Received: by 2002:ac8:4552:0:b0:3a8:a1f:6999 with SMTP id z18-20020ac84552000000b003a80a1f6999mr109760180qtn.52.1673600046892;
        Fri, 13 Jan 2023 00:54:06 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id x14-20020ac86b4e000000b003a816011d51sm10247375qts.38.2023.01.13.00.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:54:06 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id d62so5468307ybh.8;
        Fri, 13 Jan 2023 00:54:05 -0800 (PST)
X-Received: by 2002:a25:d095:0:b0:7b6:daae:ad50 with SMTP id
 h143-20020a25d095000000b007b6daaead50mr3261996ybg.89.1673600045570; Fri, 13
 Jan 2023 00:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-20-hch@lst.de>
In-Reply-To: <20230113062339.1909087-20-hch@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 13 Jan 2023 09:53:54 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWLZF3uF8+Bs8FL__x=MyZPPBUqX-Q6XVQS3B08re-vZw@mail.gmail.com>
Message-ID: <CAMuHMdWLZF3uF8+Bs8FL__x=MyZPPBUqX-Q6XVQS3B08re-vZw@mail.gmail.com>
Subject: Re: [PATCH 19/22] fbdev: remove sh7760fb
To:     Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Fri, Jan 13, 2023 at 7:25 AM Christoph Hellwig <hch@lst.de> wrote:
> Now that arch/sh is removed this driver is dead code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!

> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -1861,7 +1861,7 @@ config FB_W100
>  config FB_SH_MOBILE_LCDC
>         tristate "SuperH Mobile LCDC framebuffer support"
>         depends on FB && HAVE_CLK && HAS_IOMEM
> -       depends on SUPERH || ARCH_RENESAS || COMPILE_TEST
> +       depends on ARCH_RENESAS || COMPILE_TEST

Nit: this part should be a separate patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
