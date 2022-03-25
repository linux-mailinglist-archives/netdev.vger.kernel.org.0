Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD424E7C9D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiCYTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiCYTtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:49:24 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD23840426E
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:33:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lr4so8869551ejb.11
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c98skZ0BjUMamIjtZ5imiZLVO/gl8DuHYbRwakJRogU=;
        b=Suev8BbZiQARkSS4t03OA365leJb0pqRURfN9ENchEyRkWs2YFj9yYWgBOyB03AwTX
         YhQZoZ7id1LSxPtVADVUj2io0XoJ1lCVLAHAHk2KnNq1hnonb7XuA9aYxWYlTBAgFBqO
         RtHXpHxhqkzfBGrkr/vstccVIywh2CCLpuHps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c98skZ0BjUMamIjtZ5imiZLVO/gl8DuHYbRwakJRogU=;
        b=KAIe3rO2GfbkeBsu/t+bgTeq1v2slZWbqn+Ua5Ngzm44c4c+wS2d/U1t5t7hbbM5LK
         qXTeH7esgxrSn02CoD3t1ZEE2IecdcdEanP4kK6QiYhnQ74smP1QXTub578gQBHmY+5A
         2DgfzqoHAKmC9VR0ATFMjgHdVs/mILGFR2SBGFqH5vdhqzEoSAjD2Wy7qchkqRqhpQeC
         g3E6KkrFJjAcNqf8ULR42YjRXA2Ob/sv63S84ye4Y7VqlIOkv4ydoA/aNq1pK7BsHZ3H
         TCELY6M3Tu2XFhuKPF6L70muZ7GGXzKnz/X7Py5LZRLakFLP6eZJJ0DnIIPrB9N/tmK4
         zFgQ==
X-Gm-Message-State: AOAM532Htxrk18Foqb4X5I2c+DR2zRdi+9BWhQhEC+DqhThFgapK5tcx
        okRRHBsjMxCs9oBYzAo6tqZK0ks3KYWX+Ytsqik=
X-Google-Smtp-Source: ABdhPJxY41pbmK8cbSzigMltVquImy1T4bXTyvJpyRw8q867zUAxFOYIB0wTd9x20QxoVSr5nvyf5g==
X-Received: by 2002:a17:907:3f29:b0:6df:7eac:7fa4 with SMTP id hq41-20020a1709073f2900b006df7eac7fa4mr13444129ejc.391.1648236788472;
        Fri, 25 Mar 2022 12:33:08 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id c14-20020a170906340e00b006ce98f2581asm2623098ejb.205.2022.03.25.12.33.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 12:33:08 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id lr4so8869382ejb.11
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 12:33:07 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr9229114lfj.449.1648236479896; Fri, 25
 Mar 2022 12:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com> <12981608.uLZWGnKmhe@natalenko.name>
In-Reply-To: <12981608.uLZWGnKmhe@natalenko.name>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Mar 2022 12:27:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
Message-ID: <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 12:26 PM Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> On p=C3=A1tek 25. b=C5=99ezna 2022 19:30:21 CET Linus Torvalds wrote:
> > The reason the ath9k issue was found quickly
> > is very likely *NOT* because ath9k is the only thing affected. No,
> > it's because ath9k is relatively common.
>
> Indeed. But having a wife who complains about non-working Wi-Fi printer d=
efinitely helps in finding the issue too.

Well, maybe we should credit her in the eventual resolution (whatever
it ends up being).

Although probably not using that exact wording.

        Linus
