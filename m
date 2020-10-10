Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ACF28A4A8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgJJX4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgJJX4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:56:39 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EF0C0613D0;
        Sat, 10 Oct 2020 16:56:39 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x20so10340134ybs.8;
        Sat, 10 Oct 2020 16:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXLuilCJr1RW1byBqMvIVGVnL8GVaGMkrx1VY2TWsaU=;
        b=NXIDCQrQ5pQGn2eriRo0lenes8eyU2JiHnDJkbrR1Gh7lzomdOyZfbC7AN6RAomywQ
         S5YtwK9BuOVs/Z2vWEa5AVD95iOvFQq14+TvG0E1nAFvCtOb/vtbEutqX1y2HwIRiW7G
         AhNNFmT3VSu5BH2018DS4Ip9OzThE5q9CuZ6zq9piHSyeivjGDOk4vPc2t1JC/o+QNRV
         00MQYTFWV+Ujpy8X36iwy8m//mAqENPut9KkC8x99utjl/+0b4odQCD8Z1+rRAgs7Xb5
         NjX28ZMkvJFM5z8w5K3OzbMjX5ynMT7BVrzfqZEB0EZZERUjsDu6xbyzzs3j0DKsyu63
         Gglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXLuilCJr1RW1byBqMvIVGVnL8GVaGMkrx1VY2TWsaU=;
        b=DZJ18Z9UvKiVcPge9o6wwBI9xIe9jwwxW9KfSgsfxA8okQfO4nVPZLkWihoB+nQupu
         hxLlBQX3YuB7cppzcsVQ8U4ujztp6/rfSOC4IZTjiX/Hk6R3IUnS2lzeEZhWVR3hXwo7
         3vJFGhezjnG49coW5Koh4oGSNN9ncfVr2xvbDQSd+DNsCVk8rM1KC6u7fQFhmLjX6oCc
         dqSAm2OovIz0iMDH16rD18eufGuam1FvDZ/d7eeVSqRVKzs4C49JlnVmBW9cF8drYG9E
         Qrv0JFAjo3SS8Rv3XR5dA0e/m5OmngBrfU3EFGNOGfpyZ+aKxYIxnHqYNChi2IsoBRoX
         CZ4Q==
X-Gm-Message-State: AOAM530IS68LNI2bd8PIcLWuo0WO8R5+X7NPLDFT7TY94sdB+V0yNQ1a
        4m1/SChv+k1b4YzaFc9+jLxnTHm3Vp84aynQbEk=
X-Google-Smtp-Source: ABdhPJwdXn94V0+jHc/SF+7B2v4z2b5BAX+kq5vzXGcq0uwULmUbBptDWT5DLZ8KtDZodCXdKERXcZ5tQUxRRBIhddc=
X-Received: by 2002:a25:5f08:: with SMTP id t8mr1555012ybb.260.1602374198981;
 Sat, 10 Oct 2020 16:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201010181734.1109-1-danieltimlee@gmail.com> <20201010181734.1109-2-danieltimlee@gmail.com>
In-Reply-To: <20201010181734.1109-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 10 Oct 2020 16:56:27 -0700
Message-ID: <CAEf4BzZw3Se=qa=hjrtLtL4AEq7UQcmS-ZdKqo=qAHO1Kn=SGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] samples: bpf: Refactor xdp_monitor with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:17 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> To avoid confusion caused by the increasing fragmentation of the BPF
> Loader program, this commit would like to change to the libbpf loader
> instead of using the bpf_load.
>
> Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
> program is much easier. bpf_program__attach_tracepoint manages the
> enable of tracepoint event and attach of BPF programs to it with a
> single interface bpf_link, so there is no need to manage event_fd and
> prog_fd separately.
>
> This commit refactors xdp_monitor with using this libbpf API, and the
> bpf_load is removed and migrated to libbpf.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> Changes in v2:
>  - added cleanup logic for bpf_link and bpf_object
>  - split increment into seperate satement
>  - refactor pointer array initialization
>
>  samples/bpf/Makefile           |   2 +-
>  samples/bpf/xdp_monitor_user.c | 159 +++++++++++++++++++++++++--------
>  2 files changed, 121 insertions(+), 40 deletions(-)
>

[...]
