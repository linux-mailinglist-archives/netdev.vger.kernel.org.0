Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA51CDE8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfENRYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:24:53 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46859 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENRYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:24:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id z19so11016772qtz.13;
        Tue, 14 May 2019 10:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+Qki/cOt3rUWKkyisq6jLq04uEf7/vxIcM+9rApuAc=;
        b=pOI5aD8pU/k974s5e6YRPmT/umw7gCIqbSynQnmGIMFgnWDnh330uDSZDsmYI0u82W
         vl8MPdgE1AqWhW3Lrr2WfuBySSP/DDHO7ipbwRhOMZvmiwDGumGnen3GbjmEb7Lm/7ll
         BSPfvEGinDHKo6waR0YjFjqp4vedFBC0QUh9KU71Tbi87zKMtrmTP+Ze8gaAbYj7FMIa
         xeRFtpDVfalgmwzpPCxrVj276RtD8Au4ZVmH4EEgakd8gESF9er+il1PfCsQbDkD7qky
         AcJ3bFopkD1dfi37bz5aayVvjJgTLgS635Tl38XwTRPCMswkKn1ttCBgf6/4owJ0ArR0
         S5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+Qki/cOt3rUWKkyisq6jLq04uEf7/vxIcM+9rApuAc=;
        b=RgU++90CAZBhAY9Zmo9BEyT5+a7na42PCu9evkTUROxVqtjEBn+R3Knyi0zcCgcTJu
         TuBOGfKaIJf0EksjKXCkMnlo2KOs6AqnlkwLl4+pgyBevfHpPLOEaxe2rm7ga+brtUEn
         4b/6XGiCmMjP7fxdvPmWrWat4nykuXkRpZjfKwtf/xTX+r49p1fOe5oxcyiLxTFofcHj
         m3e/wUTGSeqYypH+PSi5YnBEkSbEgxrtAFFCHurgHLvuKkgy8HoKX4NXw9VjmO0MdkYZ
         QhxBU5o/g1nEsvsuRKwfjat4Y/mBu30A4QhVlKwCpiOve43bQeoxJqIq7PVNKEZ4YluC
         wBSQ==
X-Gm-Message-State: APjAAAVSxYuDTrt9Kq30waktutw0cuEFAj83U+jFDfY3/aPCo9/+/IU3
        fWTmEdNQSgJdIf627wG4Zxu5tiAuyJtxl/X5KrA=
X-Google-Smtp-Source: APXvYqyUaraGpZWm+zaz3fA/A8P2VLnIiplSrf/0WoG8OK8Ldzap9EKBQ3Tuntz/19ah0YTaBMB43LRwr4/37hdaEiI=
X-Received: by 2002:ac8:3f75:: with SMTP id w50mr31932106qtk.27.1557854689958;
 Tue, 14 May 2019 10:24:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1557789256.git.daniel@iogearbox.net>
In-Reply-To: <cover.1557789256.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 May 2019 10:24:38 -0700
Message-ID: <CAEf4BzaSj9Nh+2gcEJyBDzwgbaYWAUiQ7JWAez9+jDneCA6ZFQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/3] BPF LRU map fix
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 4:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This set fixes LRU map eviction in combination with map lookups out
> of system call side from user space. Main patch is the second one and
> test cases are adapted and added in the last one. Thanks!
>
> Daniel Borkmann (3):
>   bpf: add map_lookup_elem_sys_only for lookups from syscall side
>   bpf, lru: avoid messing with eviction heuristics upon syscall lookup
>   bpf: test ref bit from data path and add new tests for syscall path
>
>  include/linux/bpf.h                        |   1 +
>  kernel/bpf/hashtab.c                       |  23 ++-
>  kernel/bpf/syscall.c                       |   5 +-
>  tools/testing/selftests/bpf/test_lru_map.c | 288 +++++++++++++++++++++++++++--
>  4 files changed, 297 insertions(+), 20 deletions(-)
>
> --
> 2.9.5
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
