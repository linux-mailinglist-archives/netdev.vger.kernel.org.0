Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF725A45D8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiH2JPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiH2JPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:15:31 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDFF1F60E
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:15:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l3so7363825plb.10
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=c2aVBxBljQXidJEz2M/qSg2TNcMr2Aeqd2eXQhCFr4s=;
        b=6wmYOAiKVs6nUifInbm25cqk4YlfMSI6+BHj5u9ADBOiQlhEBM+9YdD6iMnsWLWIgA
         HCZs0V9NQMQZ+ELge0gSH3tXO0Awk8jYClI0DCOjB69NTKhJY9LVEs6q5e4p0ked9WBd
         qqBE4WAAZg6uJlSx/ngDQDcjl+xp9hQkuvGWA2FRlvXjFcLts0U6nFB4bqZfhU28QU7g
         4daxyde6+zajWqNWjGytUgqfXWFCFdyUrYvZvoKgJIv2TGks5d6xQcZnNwm24lGKDdfW
         Wslh1C/Rmk7wdYOj0pr4i8J85bp4vJV0a+QsVFl9Iq5ylhtsxL/fels20DpbGiQ2mpLU
         qbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=c2aVBxBljQXidJEz2M/qSg2TNcMr2Aeqd2eXQhCFr4s=;
        b=Eksca1xO13TsKWApWWlgEhxlroOX/oHNlEEMul8mhSAstEPMnazQB6xiem8FmfYpvf
         qt16GGFD54uhyCludMOhoq2/SZa7M9oxChhg4iVli9lDN6s7BZ6ae4UF5g1uGwBCTCgT
         lQWkojgpUVMUk/P6gXtdf3NP0IG/FRB2UE2QhPd5+CJl6oq1GJ4b7kjcnXiFrF34tStJ
         n8JrMeUQcCKRxIVizozbX0ka/iunMPuCUt40bd3GS1JV7uqBXwHQU2NPFPIutVIj1g0O
         oVP/YddWyng0KVtHqLQLvtkU5+yOULTixAib/3boguobNsEatcJ1q+o4NLuGODPsqK6r
         z5yg==
X-Gm-Message-State: ACgBeo0IW0z4+iFtAAtOO65Kos/igudlc8ebvtD8h/Bg+5F1bt6e6+PJ
        zBunQxoMY0od9j0qtxobAwfU1EARiYjIcFqMjaaETg==
X-Google-Smtp-Source: AA6agR5Sha+EIRqE/XunuVY/bkUKuQg1/6F/zoVoEdAepTG8x+S5kkIyZQxjmMOkkyLQMMH9yOHvN48aYpVucFtg2d4=
X-Received: by 2002:a17:902:ea02:b0:16f:11bf:f018 with SMTP id
 s2-20020a170902ea0200b0016f11bff018mr15440953plg.150.1661764530085; Mon, 29
 Aug 2022 02:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com> <1661762805.8266613-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1661762805.8266613-1-xuanzhuo@linux.alibaba.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Mon, 29 Aug 2022 12:14:54 +0300
Message-ID: <CAJs=3_A6hLcTUj_KCG=n+DH9TA0-BaJ0m_CsXgObWjraE0cbeA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We are very interested in this, and I would like to know what other plans you
> have in the future? Such as qemu, vhost-uer, vhost-net. And further development
> work in the kernel.

Hi Xuan,
I'm actually working on a VirtIO compatible DPU, no virtualization at
all, so I wasn't planning on implementing it in qemu or vhost.

I have some more development plans for the VirtIO spec and for the
linux kernel in virtio-net (and maybe virtio-blk).
Adding a timeout to the control vq is one example (needed with
physical VirtIO devices).

I would of course help to implement the notifications coalescing
feature in qemu/vhost if you need.

Alvaro
