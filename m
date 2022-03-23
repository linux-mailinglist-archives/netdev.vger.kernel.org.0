Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA874E5774
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbiCWR3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343573AbiCWR3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:29:11 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D37EA22
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:27:41 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id bu29so3938138lfb.0
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qw+/tGAcqsZzOdIU9mPy0h6XsR9YUgqE/aO4tJnDV/U=;
        b=AsueKvmLHM2nGOpImBUVo8JvIUXQZTPBXUuZ+V1+E3nRTCnp7dAn5Ysn/GIxghzLln
         GZBXO3w4k/UDMjMFwtn/nP7LeVAoXHaabLGMz82QEQoUcyQ2iSJywkoB38HO0fhpi+qm
         ebKixIbEogjW5TDgyVUN+w+sNSt7oNBz0RQ04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qw+/tGAcqsZzOdIU9mPy0h6XsR9YUgqE/aO4tJnDV/U=;
        b=OxoUAMYAbg32Eu+g7B6iR7VqWYbqthhLanneAdJz49C6f93vVtCyyuY7TOGV6TBglH
         cyQWGM2/IqnEv3U3al0cN3/EC+AB2j43pBZRj/RDQ69H7A9QRzRnheHIrCqYrrbbRSgf
         Ucv3OpeJVHulIbKjw/YR4MJsB+005E+A8XIEIGzRMPutdPXMKRf8Z+XWyUNnfa3imGJR
         M0d27aoeOgZOikCoDo+aLYim7BMjtTs39Ocm5JDOqmJPVxd3AbR58U8EAI0mv17wiF9l
         wi9WGuZx4bvQUEZQneqdaSKqlLjWyIt4p/kcSwdUqlwTj2XZ7CNpQ4cqtUoL4ufamY2a
         mCCA==
X-Gm-Message-State: AOAM530xCa5IyNga4kbEZAbughJqpCDd9Ox6T9lyIUsgfdnc6Ysqc8AB
        mEUEnc0e9HeUP02vtQ/i11jq+pQKbZr5ZpHhI6E=
X-Google-Smtp-Source: ABdhPJzCRcp84+S2lAKxDnW1hBFXpnLqFjgZH3PONSoGHQPRNFnYBTvC7ovc/V1sqGu1UTv5yfnC5Q==
X-Received: by 2002:a19:6b03:0:b0:448:54f1:1251 with SMTP id d3-20020a196b03000000b0044854f11251mr695232lfa.674.1648056459074;
        Wed, 23 Mar 2022 10:27:39 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id n13-20020a056512388d00b00443d9064160sm45930lft.125.2022.03.23.10.27.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 10:27:38 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id a26so3839925lfg.10
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:27:37 -0700 (PDT)
X-Received: by 2002:a05:6512:2294:b0:448:6c86:3c78 with SMTP id
 f20-20020a056512229400b004486c863c78mr661692lfu.531.1648056457283; Wed, 23
 Mar 2022 10:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name>
In-Reply-To: <1812355.tdWV9SEqCh@natalenko.name>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Mar 2022 10:27:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
Message-ID: <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
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

On Wed, Mar 23, 2022 at 12:19 AM Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> The following upstream commits:
>
> aa6f8dcbab47 swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
> ddbd89deb7d3 swiotlb: fix info leak with DMA_FROM_DEVICE
>
> break ath9k-based Wi-Fi access point for me. The AP emits beacons, but
> no client can connect to it, either from the very beginning, or
> shortly after start. These are the only symptoms I've noticed (i.e.,
> no BUG/WARNING messages in `dmesg` etc).

Funky, but clearly true:

> These commits appeared in v5.17 and v5.16.15, and both kernels are
> broken for me. I'm pretty confident these commits make the difference
> since I've built both v5.17 and v5.16.15 without them, and it fixed
> the issue.

Can you double-check (or just explicitly confirm if you already did
that test) that you need to revert *both* of those commits, and it's
the later "rework" fix that triggers it?

> So, I do understand this might be an issue with regard to SG I/O
> handling in ath9k, hence relevant people in Cc.

Yeah, almost certainly an ath9k bug, but a regression is a regression,
so if people can't find the issue in ath9k, we'll have to revert those
commits.

Honestly, I personally think they were a bit draconian to begin with,
and didn't limit their effects sufficiently.

I'm assuming that the ath9k issue is that it gives DMA mapping a big
enough area to handle any possible packet size, and just expects -
quite reasonably - smaller packets to only fill the part they need.

Which that "info leak" patch obviously breaks entirely.

So my expectation is that this is something we'll just revert, but it
would be really good to have the ath9k people double-check.

                Linus
