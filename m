Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22851284211
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 23:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgJEVVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJEVVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 17:21:48 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B8BC0613CE;
        Mon,  5 Oct 2020 14:21:48 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f142so13999785qke.13;
        Mon, 05 Oct 2020 14:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=084pxrU/pIlMwzpfzpJDzcoYD6a5cykCb0YXSztaIfc=;
        b=ketHZbs18fAuaNJbCrDKaOaZs+2wuxecDCCthxpzm0n3O+OXsNTfDdCjFU3Q0vgXCW
         kms+JQuF8ULCuMVOxAayLp5ZqO9L6ORfzWRKeVUC6c6RX649DCZfCBH8Msbl72WztGZd
         xei3ZxrbYZI6INFjAZJ1E0m1TxT35Q6VFJu4ZMPNt1PAai5n2X4ej5QrvZ2zmOXd0GRS
         5lTdNsJH82StpKMwCu1mCS0NEInuwfBmjV/tSEJcyf9HACexKp0FWO64cRcXhF3TS75J
         W8TBJfoh/7m3lIj+T9ekduzoHKAEU58GS0sqPYb5LOIXmNd3gcgIYiCRi6AGwkzRX1F2
         Zpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=084pxrU/pIlMwzpfzpJDzcoYD6a5cykCb0YXSztaIfc=;
        b=IM4fGYSx6rMIEABn9wgCgRzN5TmJmJVPM+wDZsjhyW0ujQHJmEa3hGod5hjqFKe25G
         +EZEU9wtUgyWVvyZL/GftJHg3PbslS+T/bjnqbkZ6empoJaC/CI1MfmDT1t3+DP9Kzvw
         mEMANavUNslyqTAg46wYz8waD0kRbOP2PK8K9NVeaXoppcDT1IXO7PTidkFwYGKibW/W
         d6i/MarDtQVLmYnAdSC7zXCACi/hjEB2E0gXPm+V8GnvHw8MGvuzqWgczzpUB9N95gxM
         EocHaApqNWwLwW27p515pzG0a7bQ6c8TsvjjJ9HXI+/2/tV5H0ry9L6zjXIFNoQW1AVV
         mXWQ==
X-Gm-Message-State: AOAM530bObkfrSERyMUW9GLW8NLKQ/j0B6Jven33aq74XsH/ootzguu2
        8SeHCSXULQUVIP6LgrmCTPhoboPSUO2LEfcdGHY=
X-Google-Smtp-Source: ABdhPJx1X/xt7fiPZ7SYCJxNdcOCvM1CZy00nv7ftzgoABpK7rRz13MLiERuuGeG91K8x0e5w7TPI9CvNwx0VIb2jfI=
X-Received: by 2002:a25:6644:: with SMTP id z4mr2677017ybm.347.1601932907388;
 Mon, 05 Oct 2020 14:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com> <20201003085505.3388332-2-liuhangbin@gmail.com>
In-Reply-To: <20201003085505.3388332-2-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 5 Oct 2020 14:21:36 -0700
Message-ID: <CAEf4Bzb55Ho7dJ8VTSp9gATqgfTV-rsF5b5Mqrg5VNOLMQDykQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 1/3] libbpf: close map fd if init map slots failed
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 1:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Previously we forgot to close the map fd if bpf_map_update_elem()
> failed during map slot init, which will leak map fd.
>
> Let's move map slot initialization to new function init_map_slots() to
> simplify the code. And close the map fd if init slot failed.
>
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

LGTM, thanks for the fix!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 55 ++++++++++++++++++++++++++----------------
>  1 file changed, 34 insertions(+), 21 deletions(-)
>

[...]
