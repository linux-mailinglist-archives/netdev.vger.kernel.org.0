Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791B45E5E77
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiIVJYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIVJX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:23:58 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248554623D;
        Thu, 22 Sep 2022 02:23:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v128so7156059ioe.12;
        Thu, 22 Sep 2022 02:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eq1ulTtXYhBmIV3Hec+MzaFRLDXw1vSRF6+bOMmPhJ4=;
        b=bE2W6qfxPeZ5hG8th9HBte8uWTQjYuCcr36yI1hhiheOM64/zofTi1amyoUC/YRb+J
         NgesQGAjTL00GMSehk4Np33KVgoKvpm/Mh3RSzMdF+EkL5Y4k9K6GB3q17DXyKsUm/6E
         tSUleWEaIUryrEiqLEE56d9SYCS/YFMrs6gU37f7Pqu7tr26K2zmBNy6tAGoGVxQ5f+n
         DlMD1/oSQBrQp/QHyG7CgFktY+50H+Wm33tTFaH8FxMf0iDQdWTe9OU6Ok7FDH/xYrVm
         +Y17qm2jbLBl43Ckz4h9g/NlAB7oNcZMDPJUHArvKPR8Jrr0Y7Jjk4kBCdA2lo60DN3B
         Aphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eq1ulTtXYhBmIV3Hec+MzaFRLDXw1vSRF6+bOMmPhJ4=;
        b=XAbmbADnMx1d4MDhg9mZ+JCOlI8v/mXVbJmgFFJ4Aha0fj2C83T1uAOyMi0keOy7K4
         KC+ensOGk3/jP4BgR2XdHhNAn93UyKOSIEgMf83cKIZKiE2MNlRG5qPZFsUArLGslWsJ
         jF9y/EydOKtZLPkyUu3S3t8e9NfvRnbFuKeMjUE9K0SmjdtHhvMtaEmQ64qmYRHfSENC
         JxESA9v7yr4OtqcwnuPULcp59C6JPo/IoCzGIQerj5Ou60Hvqr8Z9xeZwe9xHPYhI2W6
         DUHUuEJ5Y8NOmpVQYVd0W7p2/s2dveW4DIEGZEKoIC0PSA05aTSG6RSya1vn2/kU+69Z
         L75A==
X-Gm-Message-State: ACrzQf356hDtiQ4/84mEVGMqKbAvLC7HqVZ0tzelr+KA+/rC59b3RnhR
        cty9X7VDst/qGKH/RjuahRI6dGocnqKY98FaYxs=
X-Google-Smtp-Source: AMsMyM4VmAwcaT5Lc+Ww++2Y7GpjHXOf8JO1cC9hLR1vHps4lN+vAXggqFNSedolxw1DncuzKFlDGIHvcmXTBzRY/kM=
X-Received: by 2002:a05:6638:dcc:b0:35a:7ba6:ad51 with SMTP id
 m12-20020a0566380dcc00b0035a7ba6ad51mr1404409jaj.256.1663838637536; Thu, 22
 Sep 2022 02:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220922031013.2150682-1-keescook@chromium.org> <20220922031013.2150682-12-keescook@chromium.org>
In-Reply-To: <20220922031013.2150682-12-keescook@chromium.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 22 Sep 2022 11:23:46 +0200
Message-ID: <CANiq72=m9VngFH9jE3s0RV7MpjX0a=ekJN4pZwcDksBkSRR_1w@mail.gmail.com>
Subject: Re: [PATCH 11/12] slab: Remove __malloc attribute from realloc functions
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hao Luo <haoluo@google.com>, Marco Elver <elver@google.com>,
        linux-mm@kvack.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 5:10 AM Kees Cook <keescook@chromium.org> wrote:
>
> -#ifdef __alloc_size__
> -# define __alloc_size(x, ...)  __alloc_size__(x, ## __VA_ARGS__) __malloc
> -#else
> -# define __alloc_size(x, ...)  __malloc
> -#endif
> +#define __alloc_size(x, ...)   __alloc_size__(x, ## __VA_ARGS__) __malloc
> +#define __realloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__)

These look unconditional now, so we could move it to
`compiler_attributes.h` in a later patch (or an independent series).

Cheers,
Miguel
