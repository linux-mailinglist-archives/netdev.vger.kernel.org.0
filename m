Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3D03BF43A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 05:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhGHDNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 23:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhGHDNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 23:13:34 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1E0C061574;
        Wed,  7 Jul 2021 20:10:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u18so10481571lff.9;
        Wed, 07 Jul 2021 20:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNgZ72sUUZCWJIsDrS4mJIaf//FCuWEsLk2Ji0orB2Y=;
        b=EFGe4SR3dcmL9nD3pgmEYdGyaeZraZmE8NR/1B3y3gv+udGz44/HWmthLtV5WBlohs
         ytCr+uYLhxoMLINX/ITKu0npsYOMSjWfuk8tdptM4LhEowl3Ma63d5qc/+yxGBcTBRUJ
         TAym4YBz6+gT2tvdZJ7oP+zlemCJpjSm/7sgIDNWfYk04egekmb+f+Oh4U4fjaMsjKKZ
         El9/ak9+O4xbJnYdmGLlbuKOznqh6bYzmDSFIKjm+uRPk2rVJcjLM3HpjSGkXhGJIb+M
         oy7BAB8wpZB75yjQt1ZDb7/8blk/LejACz7WIZJFrJzwIqkXIWru13tynTWNj3GTid8v
         tknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNgZ72sUUZCWJIsDrS4mJIaf//FCuWEsLk2Ji0orB2Y=;
        b=od5EpVDiQo5C+f1DaK1iQ6LfUOyAWXF4THzns+fK3zxghOeO7C5tNVJH9S6gGURDtE
         aIpcEdF7fOKC46fkGL15grijBtArOM3CDV+USROec5sV5bxFN61UTu8W5VfCLCUJHg/x
         cw7NECRDRJT7bW90hlpwGhdeOdOUjPh476jC/y5Q1m/2vBsAlcD8+ahqpW/Dk7xthtjc
         +NH9rq512sVZLDaY4EAZTHwEpL1dcQkfGDsV/8TJnj8ImRLFYKMFGZRF+WbTxQY63xmp
         E2OYp/vzOc6/nxXYTAGqc2US44Uijsw7UvSoFVWz7Wn4WZPnSB0HdtmNH1Hnzd/lDPhm
         mHGw==
X-Gm-Message-State: AOAM5333zJlJkr42YbH76fPN864BSt5m7urZxJ0dljOl+7Mlzk/lrGal
        hPxLVpXBMTYRzkejcO/iiOC4JW8c0ovmcq+WSrs=
X-Google-Smtp-Source: ABdhPJz6Amdt0GGaruxWLBehqdSG0c2PrphxnQQNdbaYyHbm2Hg/jijb8k2z6U7u1GtbbH3q0uajnmjkJbHKuignr08=
X-Received: by 2002:a2e:b80e:: with SMTP id u14mr8483686ljo.204.1625713851792;
 Wed, 07 Jul 2021 20:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210702111825.491065-1-memxor@gmail.com>
In-Reply-To: <20210702111825.491065-1-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Jul 2021 20:10:40 -0700
Message-ID: <CAADnVQKk-KvVzozdrOOAo8vZqKYcHuzeU32ths+DJ6oLfPCcTw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 0/5] Generic XDP improvements
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 4:20 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> This small series makes some improvements to generic XDP mode and brings it
> closer to native XDP. Patch 1 splits out generic XDP processing into reusable
> parts, patch 2 adds pointer friendly wrappers for bitops (not have to cast back
> and forth the address of local pointer to unsigned long *), patch 3 implements
> generic cpumap support (details in commit) and patch 4 allows devmap bpf prog
> execution before generic_xdp_tx is called.
>
> Patch 5 just updates a couple of selftests to adapt to changes in behavior (in
> that specifying devmap/cpumap prog fd in generic mode is now allowed).
>
> Changelog:
> ----------
> v5 -> v6
> v5: https://lore.kernel.org/bpf/20210701002759.381983-1-memxor@gmail.com
>  * Put rcpu->prog check before RCU-bh section to avoid do_softirq (Jesper)

Applied. Thanks
