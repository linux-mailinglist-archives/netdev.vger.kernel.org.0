Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D5689EE1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjBCQFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjBCQFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:05:06 -0500
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F866A2A4C;
        Fri,  3 Feb 2023 08:05:03 -0800 (PST)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-51ba4b1b9feso73909487b3.11;
        Fri, 03 Feb 2023 08:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wIYdPVdo9w8wJeFawgcWpGlCHgpXqP0aU2proD/z4A=;
        b=h7Y+KCF7rYYuzKa23/XVH7EqKMk5LTZnVw2PqeMnOFM+xWLo9NJHdhJ7VXQEzh/jEQ
         43USwhMjApuBXpP8uDT4/9ZWtcfiac4as5JkOYvgtFByz33C36/DfwkQOIfY4SCuqGDK
         Hv9r2B8MXFnnKurrI2YIIpkW+iLxoK+7IxwMN41GkLxe5SYkAMuhmyEdUiIf3h+NbtlV
         Vjrsgdy/0uWZlA6GCyhPVQQLTybtIXlZAYgovWjXFPEmbkXmJ1R6oNLeW1Q9wjp7INOt
         dpYwOYdzkRdvH3M1sRrIE5bOaaFyPkuU4ojNBjyPoq103GnN5D0iyOl6ib+Yx3KeeBsY
         CkPA==
X-Gm-Message-State: AO0yUKUt0cK5Wr875sm9z9U0bJzP+91+5+O4ghRPfaBfRmU8ORcDIFi3
        96J/1/Ux8eteagW4UXGq2OK0nBZCNN5sEw==
X-Google-Smtp-Source: AK7set/a/Eq2gP6R7fciPiamzKQR29gjZ+vbzZcYT0ptMjiTbNLQIWRvobf0piyfY0iq11BERjizRw==
X-Received: by 2002:a0d:d648:0:b0:506:4342:1a2d with SMTP id y69-20020a0dd648000000b0050643421a2dmr7042060ywd.12.1675440302426;
        Fri, 03 Feb 2023 08:05:02 -0800 (PST)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id r195-20020a37a8cc000000b0071ddbe8fe23sm2101905qke.24.2023.02.03.08.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 08:05:02 -0800 (PST)
Received: by mail-yb1-f179.google.com with SMTP id 74so6528236ybl.12;
        Fri, 03 Feb 2023 08:05:01 -0800 (PST)
X-Received: by 2002:a5b:941:0:b0:865:e214:f4e3 with SMTP id
 x1-20020a5b0941000000b00865e214f4e3mr352487ybq.604.1675440301482; Fri, 03 Feb
 2023 08:05:01 -0800 (PST)
MIME-Version: 1.0
References: <20230113062339.1909087-1-hch@lst.de> <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de> <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
 <20230203071423.GA24833@lst.de> <afd056a95d21944db1dc0c9708f692dd1f7bb757.camel@physik.fu-berlin.de>
 <20230203083037.GA30738@lst.de> <d10fe31b2af6cf4e03618f38ca9d3ca5c72601ed.camel@physik.fu-berlin.de>
 <CAMuHMdUitVfW088YOmqYm4kwbKwkwb22fAakHcu6boxv7dXDfQ@mail.gmail.com> <f6a60193-a5d1-c42c-158a-4b0bfe9c7538@infradead.org>
In-Reply-To: <f6a60193-a5d1-c42c-158a-4b0bfe9c7538@infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 17:04:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWJ3XOBewDoU8umAHc6b83hJQge5xjY3Cxx03AvoiR7iQ@mail.gmail.com>
Message-ID: <CAMuHMdWJ3XOBewDoU8umAHc6b83hJQge5xjY3Cxx03AvoiR7iQ@mail.gmail.com>
Subject: Re: remove arch/sh
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On Fri, Feb 3, 2023 at 4:57 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> Is this "sh64" still accurate and applicable? from Documentation/kbuild/kbuild.rst:
>
> But some architectures such as x86 and sparc have aliases.
>
> - x86: i386 for 32 bit, x86_64 for 64 bit
> - sh: sh for 32 bit, sh64 for 64 bit <<<<<<<<<<<<<<<
> - sparc: sparc32 for 32 bit, sparc64 for 64 bit

No, support for sh64 was removed in commit 37744feebc086908
("sh: remove sh5 support") in v5.8.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
