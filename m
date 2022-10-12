Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43DE5FC9D5
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJLRWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJLRWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:22:30 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110B733A08
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:22:26 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso20212498fac.6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRYFk+9yyHZHAcB/2rwgdrsgnigrvHFKirKgHeDmUno=;
        b=AE8z8KD6uwSVMiRp4ABm0Kn9UkMq8P+bk8+Y1ITmg3vl1hYmjp6k8LU6URk5HzGGQF
         2/fqw2HhcOa/gTcb1tS3SQgcP9XK2z4BjeVToHve1GXn4ay7pgmzQA+nKS017UcVgGKS
         Udydt9y4k+dIUSNMddvtmXX3tSMn7byJOqVUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRYFk+9yyHZHAcB/2rwgdrsgnigrvHFKirKgHeDmUno=;
        b=e9w5W/q2qukkGMd/Fm41Hsy/D0l2mhf/G4SELCyafaHayyzwXuJe2jJQ2dvR1ghFzR
         WcBs4pXJhrSG5aH7hgET106ovr/R/e3W7lWupnbD0ZvdlqO+31Fjxl+znY5aXhJwi3tK
         YbqDCWDAd77mOIFqFZnMpkQHQ3hl0xsQoZh5bqjlLm520d8E9mfk0mkpW0P+DBg8hNia
         QFDfttqqHj2/aXTBUuunJqWs93FwYpeizqEKP2Zb8GCuFhP8tIgnari4tSLBZORiut9f
         iULPWwW0uGBvL6girmKsPd9oASjoEdwii06/pYWqXKlduOQZsvSGpg4s4rp19TemwgAg
         pnyw==
X-Gm-Message-State: ACrzQf1bATigGKl07K54e61iv6bP0Yzz9HYfUxWbRHKR1k8tDd1U3032
        viKas0KI/rF4AXNFvtnu7fELmh6SGlP28A==
X-Google-Smtp-Source: AMsMyM4ItfjNgrs2p5Ul80JadgzZNVRprcbCxLbzGhqijPDoCI/cCOB9qyzs56GFqr7mJ47Kw0SbDA==
X-Received: by 2002:a05:6870:2046:b0:136:faac:de1f with SMTP id l6-20020a056870204600b00136faacde1fmr1708270oad.57.1665595345402;
        Wed, 12 Oct 2022 10:22:25 -0700 (PDT)
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com. [209.85.160.48])
        by smtp.gmail.com with ESMTPSA id i12-20020a056820012c00b004805e9e9f3dsm1194284ood.1.2022.10.12.10.22.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 10:22:24 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso20212394fac.6
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 10:22:24 -0700 (PDT)
X-Received: by 2002:a05:6870:c0c9:b0:127:c4df:5b50 with SMTP id
 e9-20020a056870c0c900b00127c4df5b50mr3072194oad.126.1665595344160; Wed, 12
 Oct 2022 10:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au> <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au> <87edvdm7qg.fsf@mpe.ellerman.id.au> <20221012115023-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221012115023-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Oct 2022 10:22:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
Message-ID: <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: fixes, features
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alvaro.karsz@solid-run.com,
        angus.chen@jaguarmicro.com, gavinl@nvidia.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, wangdeming@inspur.com,
        xiujianfeng@huawei.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 8:51 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Are you sure?

MichaelE is right.

This is just bogus historical garbage:

> arch/arm/include/asm/irq.h:#ifndef NO_IRQ
> arch/arm/include/asm/irq.h:#define NO_IRQ       ((unsigned int)(-1))

that I've tried to get rid of for years, but for some reason it just won't die.

NO_IRQ should be zero. Or rather, it shouldn't exist at all. It's a bogus thing.

You can see just how bogus it is from grepping for it - the users are
all completely and utterly confused, and all are entirely historical
brokenness.

The correct way to check for "no irq" doesn't use NO_IRQ at all, it just does

        if (dev->irq) ...

which is why you will only find a few instances of NO_IRQ in the tree
in the first place.

The NO_IRQ thing is mainly actually defined by a few drivers that just
never got converted to the proper world order, and even then you can
see the confusion (ie some drivers use "-1", others use "0", and yet
others use "((unsigned int)(-1)".

                   Linus
