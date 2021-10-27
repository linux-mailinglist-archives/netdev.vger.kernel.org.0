Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507D843D088
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhJ0SUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhJ0SUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:20:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7E0C061570;
        Wed, 27 Oct 2021 11:17:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa4so2696672pjb.2;
        Wed, 27 Oct 2021 11:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k+J8bFq2fo19uN4FjC4jMXaiLDf48GwgQzg1X0SlSu4=;
        b=BE/HhNsn0w+Ww7jLgz4xRgpW9aInj1fztmrdwk1POIisOyLzN7gya2a50ZELhfZcSk
         z4pTZhVrbSlF4WlNNR/cPozj3cApO1O14AEm97sxxI2l/vKhzBhHAR160MvoW1DIqlmH
         w9qD3OV5Ud3m5MEIcU/V4PGTsAYb/bnVhb9vgk3pShXxPMa06OicKhim5MiCFVnBHk1q
         OgcTd3X0UGaJbmqGwNpbTIEdbG4nfy3yRJekS6E7fPn6yfQOLnFjNIaoNpAlLne1qei9
         Q2N5lFLiC2eGoKGaJyPjc1zru2vFok5Tqdc4425gMU8sa8YIXeJ5VhNCh7EUokeSqiaV
         SVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k+J8bFq2fo19uN4FjC4jMXaiLDf48GwgQzg1X0SlSu4=;
        b=hf0MgVBXJoBg2/6tZc3nShJxEx9OVf+cAn89iEsedE15m0Yh7Qzqr0UX+JwKu9PB65
         xnCPDWyVD95/7RHug76fCN4y1AOSI/zIve0c2nXGuol6JQOKWhDArtm64JlFmjYRuJBH
         SzXBVMCB+tMb+ohF9bNzdRywlBdKaB10fJE3MPY3rSKZ3iNi/OGAm9qZ8ze86SH0oNuX
         8KaF+YEti5wsIw9k301qEW8FKY1wTYoXvMARYD99SiqkwICkJSAHUGwhBbxLF298xqDm
         vP9N29F2v4nl93c+vgIOOuT9A8dDXWPegWnVMBAKwjRhQ6sisRFKZ0ed0Tso0Mc4L58L
         sJ1Q==
X-Gm-Message-State: AOAM531G0U3slwahfM7mvZpBdh4xHKEnH6Eus0oIKVSr41W4YWb11rj1
        Xxze/iKrDoqOupUUuu+laHmIjGJ0K+cMjbAlqZ/mKfi7
X-Google-Smtp-Source: ABdhPJzT8SjZaK3s0eKyVWEHZqAUQ6D3Brfwkmd97BuTjaciNwnx00I86MQmhA/moaHEjMiIbnJzOthg++Dj0+PQVAo=
X-Received: by 2002:a17:902:ea09:b0:13f:ac2:c5ae with SMTP id
 s9-20020a170902ea0900b0013f0ac2c5aemr29659450plg.3.1635358677198; Wed, 27 Oct
 2021 11:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211026214133.3114279-1-eric.dumazet@gmail.com>
In-Reply-To: <20211026214133.3114279-1-eric.dumazet@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Oct 2021 11:17:46 -0700
Message-ID: <CAADnVQKwkN_+eQN1=jDBu+GzyCsqVXiP_wPx5OMHp-B-qT5JhA@mail.gmail.com>
Subject: Re: [PATCH V2 bpf-next 0/3] bpf: use 32bit safe version of u64_stats
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 2:41 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Two first patches fix bugs added in 5.1 and 5.5
>
> Third patch replaces the u64 fields in struct bpf_prog_stats
> with u64_stats_t ones to avoid possible sampling errors,
> in case of load/store stearing.

Applied to bpf-next. Thanks!
