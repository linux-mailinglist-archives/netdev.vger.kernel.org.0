Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2BA24A169
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgHSOMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHSOMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:12:14 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF594C061343
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:12:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id m22so26421783eje.10
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Js4y14Ghs6Bq4zdQYDVHKruVAGVzHlKISQN4bMebSg=;
        b=dV/u8lgzRJf9R13RTyQNVA0z7K0gpop908KdbH7mh1lom7wOwawyDuMH4lJJUnAt3N
         ER1Hz91rD7vCxhZyzb6LHpsKYbaB2LKK6Ns95j0nfjmJX5hZXauljIjL3//YJqgWaxRv
         97QHf+SgHVXKKphnPxr8+LnwmzFET6Ce2ARqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Js4y14Ghs6Bq4zdQYDVHKruVAGVzHlKISQN4bMebSg=;
        b=D/JAOXht20S74X/mqHgdOOcaQPTCQirGUyXkys6Y/1F7F4qiTpQpGBm0sM+oVZbt8T
         a4WmEAz9fFzk2+9AWElrr1cCybbMK5wotCF3PSkLdiHygLKkgZeQQkXxnL+5aVcEkHHm
         S0kw+Qt5SZmDtUJo58Vl/g2DlxWYGWr6H2F+g/a/nFmkBGrYjJATlAEtRzLwlaIQIrAP
         BX/IhwqM55ROBnRy1mt8dyugesro+ojdtoKLRuL7wouU7m0vtC+axudURoh0c1pp2TBA
         tpEWTrN9rPoGXRn5/I/SQp372X/CFMYrM065VWfVCejY2qyi6ERCSHbbpIj5/uHK1B3/
         c5rw==
X-Gm-Message-State: AOAM532+phWTZckTC4PD7FtjRwYmofDtAajpT+OMjjp83NmEoTuo75j8
        8D+aRXpVhUoQ6z7t6DvzG6xgK+WO6Bfz+g==
X-Google-Smtp-Source: ABdhPJwlbrDzZdIpJTBZr7qS2OHYiXPocJkjoiErYXhdknGRSoinPQIdujO82YpEIrDJc5qbf4dwJQ==
X-Received: by 2002:a17:907:104a:: with SMTP id oy10mr25292178ejb.267.1597846331992;
        Wed, 19 Aug 2020 07:12:11 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id v23sm13425120ejh.84.2020.08.19.07.12.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 07:12:11 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id z18so21665421wrm.12
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:12:10 -0700 (PDT)
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr24104550wrn.385.1597846328915;
 Wed, 19 Aug 2020 07:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200819065555.1802761-1-hch@lst.de> <20200819065555.1802761-6-hch@lst.de>
 <CAAFQd5COLxjydDYrfx47ht8tj-aNPiaVnC+WyQA7nvpW4gs=ww@mail.gmail.com>
 <62e4f4fc-c8a5-3ee8-c576-fe7178cb4356@arm.com> <CAAFQd5AcCTDguB2C9KyDiutXWoEvBL8tL7+a==Uo8vj_8CLOJw@mail.gmail.com>
 <20200819135738.GB17098@lst.de>
In-Reply-To: <20200819135738.GB17098@lst.de>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 19 Aug 2020 16:11:52 +0200
X-Gmail-Original-Message-ID: <CAAFQd5BvpzJTycFvjntmX9W_d879hHFX+rJ8W9EK6+6cqFaVMA@mail.gmail.com>
Message-ID: <CAAFQd5BvpzJTycFvjntmX9W_d879hHFX+rJ8W9EK6+6cqFaVMA@mail.gmail.com>
Subject: Re: [PATCH 05/28] media/v4l2: remove V4L2-FLAG-MEMORY-NON-CONSISTENT
To:     Christoph Hellwig <hch@lst.de>
Cc:     Robin Murphy <robin.murphy@arm.com>, alsa-devel@alsa-project.org,
        linux-ia64@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        nouveau@lists.freedesktop.org, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-scsi@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pawel Osciak <pawel@osciak.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 3:57 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Aug 19, 2020 at 02:49:01PM +0200, Tomasz Figa wrote:
> > With the default config it doesn't, but with
> > CONFIG_DMA_NONCOHERENT_CACHE_SYNC enabled it makes dma_pgprot() keep
> > the pgprot value as is, without enforcing coherence attributes.
>
> Which isn't selected on arm64, and that is for a good reason.
>
> > AFAIK dma_cache_sync() isn't the only way to perform the cache
> > synchronization.
>
> Yes, it is the only documented way to do it.  And if you read the whole
> series instead of screaming you'd see that it provides a proper way
> to deal with non-coherent memory which will also work with arm64.
> instead of screaming
>

I'm sorry if I have offended you in any way, but would also appreciate
it if a less aggressive tone was directed towards me as well.

I have valid reasons to object to this patch, as stated in my previous
emails. The fact that the original feature has problems is of course
another story and, as I mentioned too, I'm willing to look into fixing
them.

I'm of course happy to review the rest of the series and even more
happy to help migrating this code to whatever is added there, as long
as the functionality is preserved.

> > By the way, as a videobuf2 reviewer, I'd appreciate being CC'd on any
> > series related to the subsystem-facing DMA API changes, since
> > videobuf2 is one of the biggest users of it.
>
> The cc list is too long - I cc lists and key maintainers.  As a reviewer
> should should watch your subsystems lists closely.

Well, I guess we can disagree on this, because there is no clear
policy. I'm listed in the MAINTAINERS file for the subsystem and I
believe the purpose of the file is to list the people to CC on
relevant patches. We're all overloaded with work and having to look
through the huge volume of mailing lists like linux-media doesn't help
and thus I'd still appreciate being added on CC.

Best regards,
Tomasz
