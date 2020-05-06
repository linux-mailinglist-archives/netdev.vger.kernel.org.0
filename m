Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB31C7CE2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgEFVzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729162AbgEFVza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:55:30 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6712EC061A0F;
        Wed,  6 May 2020 14:55:30 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id u190so846457ooa.10;
        Wed, 06 May 2020 14:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpzmAFpw5GayXZ5m8C2iXQrxfFP2xoFq/e+4IQDtrV4=;
        b=iLvFVWu1VBveyI3AlRiRTOQGLKPvPZi58bCg0SwK1noyhIy9rTZajw3wj3DGj7Nhh4
         uxGqyK8oyAVx95rwrQuYVHQuoGQl/LJFi/c5n52WtDSXAc6cU+E33C5lbjOEN6UWnv/h
         MbFn1ei8hOTkdoxoo31O4VIL9SIG0i9v+5+SnYmB74ZkcrhV7l44Pensn+R4JQ+N+sSF
         kyHCC5/NHz1pqDZZZrokzgekI2jEDwOoSFVjqRBO1chYDJxxtqm+c6fj9f+U1xbmckVc
         JnAx4b1hYWapX/F2BUAe8ZzWSiqLhFYKRmuYro5enhOYoBWOqFnfNSHIq8TgVd8q7BpC
         D4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpzmAFpw5GayXZ5m8C2iXQrxfFP2xoFq/e+4IQDtrV4=;
        b=IGkefnvK9uRSpD62sfRf9rXj4dwc6zefseEdvsk+3dBQ1OidXnoy7KLkXn++mROAzL
         1l9kAa5LcmP6BvxoaOPuQpo0HnT+BjDFuN2ABWoBHAcMwuJYLz3QlBQNFcabrB+REJzN
         IO2tTIT76uXgN1elpN65qgpwSYnuvtgWBUKC9KTDXF/vn6zxszF7L7UnwbwSiFaohjwb
         f0EasIU8nq3pEvcoPyZ26GtYrmZNsuEMXJ0H5P+rI9lyWeJmJbvBscMVLWNpZiG8Va2C
         SJDN8f457tq9dgkyCBtlMVyuaCBTxdE+wD4IMmZAKY4riEyyF2StPCLX2v9d9KPmxZKO
         D2wg==
X-Gm-Message-State: AGi0PuYmFOz2P9XYgg+gHyrKhhtdD+Ng1ZGbt7Pt7ehi/9yxgmMPhUlA
        kn7r3LWnozEZ4TamX5fqjXbx7NmhxTpnjm2KS7M=
X-Google-Smtp-Source: APiQypKRwbJ9C53emtKQZNaB9PMNhWbwk1sp920rT6YxEiuULMzy8KyH1Xg27JujeSld+vpx9M0M0PWOxZdAxgZi1oY=
X-Received: by 2002:a4a:e54c:: with SMTP id s12mr8955384oot.48.1588802129808;
 Wed, 06 May 2020 14:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200506065021.2881-1-dknightjun@gmail.com>
In-Reply-To: <20200506065021.2881-1-dknightjun@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 6 May 2020 14:55:19 -0700
Message-ID: <CAM_iQpVyWmmOiz+x4fvQbeqQJ_u-bbCsY3o=aO4Yp0PmK8bYTg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: fix make target xt_TCPMSS.o error.
To:     Huang Qijun <dknightjun@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, yhs@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        kpsingh@chromium.org, NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 11:52 PM Huang Qijun <dknightjun@gmail.com> wrote:
>
> When compiling netfilter, there will be an error
> "No rule to make target 'net/netfilter/xt_TCPMSS.o'",
> because the xt_TCPMSS.c in the makefile is uppercase,
> and the file name of the source file (xt_tcpmss.c) is lowercase.
> Therefore, change the xt_TCPMSS.c name in the makefile to all lowercase.

This is what you will get when you compile Linux kernel
on a case-insensitive filesystem like MacOS.

Please use a case-sensitive one.
