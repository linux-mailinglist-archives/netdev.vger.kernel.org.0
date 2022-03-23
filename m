Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1244A4E5901
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 20:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbiCWTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344112AbiCWTSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 15:18:24 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACCB85960
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 12:16:54 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w7so4339250lfd.6
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 12:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FaXnwbXaSXbCX4JA5a0+pq4aaz2a8Xc9Ap8EekKfrJg=;
        b=P9ZcEpik6R5EPT4CggIUIW5sJuzMdcf8B0GMQ57M9+1WIls6aC+OjCSeLSGFKdwBgq
         gDZxv7j9z3xw9CvLBywUXZn41za0VVQ/9nq70BC0iyCUf/T9GlF7P+qvj0GM1CjFfk0Y
         40eaqcCqV0NJJlet/B4OqeaNkITYKUoe+Gn8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FaXnwbXaSXbCX4JA5a0+pq4aaz2a8Xc9Ap8EekKfrJg=;
        b=hdB3FyvrWhjBUJroc7SwAZKL98DLr9YtjgVgE6YQ4el73atcHs9RvRr8Wm/LVT49Gb
         nStlPr16Fzur1QqxV482lZq8bxCzHMb2J+aEBybWDBHctNd8djg+kYJ9aIhiNTFnC7n+
         McifFJ642RAMhoryKzX6s2G52B4+t6ljrCztxOxEYSa21zYlAkDIAIbgWZjZcsypdB6i
         T6ffLjZtSijV8ecmAP0frskqyngegL/1FW1RlSna4UpdxqA6TcK3/hFczXMrQ4g08PYr
         ILo2e1HhVSP9FG+qzHZAzYieIBTQZ9xIknq658vJo4VgUQhK0i5z/DKsWctAA/96ZdEy
         Ib9g==
X-Gm-Message-State: AOAM531/0vGwnM2iDpbmiqt/Ds305YnsTP5KUcCcGeVrwpNTEABZnTWU
        FnWcGmhqTMh8UxmDkxHIM8sMoNpTS0wvSNfIT1Y=
X-Google-Smtp-Source: ABdhPJzKHdz0xB+XwP//drY9z9SJrq7G5dZq9UKqhr3kPPVHEO3uImbJjwCoRL8K+i4xsP6Iu2NwxQ==
X-Received: by 2002:a05:6512:2250:b0:44a:56d2:c24e with SMTP id i16-20020a056512225000b0044a56d2c24emr992874lfu.262.1648063012015;
        Wed, 23 Mar 2022 12:16:52 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id bj15-20020a2eaa8f000000b00246233c02a5sm84141ljb.44.2022.03.23.12.16.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:16:50 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id e16so4301943lfc.13
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 12:16:49 -0700 (PDT)
X-Received: by 2002:a05:6512:2294:b0:448:6c86:3c78 with SMTP id
 f20-20020a056512229400b004486c863c78mr987003lfu.531.1648063009559; Wed, 23
 Mar 2022 12:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
 <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
In-Reply-To: <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Mar 2022 12:16:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
Message-ID: <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 12:06 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2022-03-23 17:27, Linus Torvalds wrote:
> >
> > I'm assuming that the ath9k issue is that it gives DMA mapping a big
> > enough area to handle any possible packet size, and just expects -
> > quite reasonably - smaller packets to only fill the part they need.
> >
> > Which that "info leak" patch obviously breaks entirely.
>
> Except that's the exact case which the new patch is addressing

Not "addressing". Breaking.

Which is why it will almost certainly get reverted.

Not doing DMA to the whole area seems to be quite the sane thing to do
for things like network packets, and overwriting the part that didn't
get DMA'd with zeroes seems to be exactly the wrong thing here.

So the SG_IO - and other random untrusted block command sources - data
leak will almost certainly have to be addressed differently. Possibly
by simply allocating the area with GFP_ZERO to begin with.

              Linus
