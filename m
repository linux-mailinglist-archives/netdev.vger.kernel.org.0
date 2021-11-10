Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896DF44C66E
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 18:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhKJRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 12:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhKJRvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 12:51:33 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777BAC061225
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 09:48:25 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id d3so5417339wrh.8
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 09:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEOc7+m69jizZAlnXFl3o/n8mpgNRufl6cVFO1xVigA=;
        b=sy7YSYGBR6dBHpVk6Fnuyk/vJ261XG8NuCeSpdS+YRofI2vDC/dTi33bB5EDXDwv9G
         vIB3srE/V/vbVOXAgnrToXvsdV+iUqbfHp8KFDorgtlPBG815xZ4eCBVTR+sUFd79NdI
         1yNOd+N7y9PfJ2UhpBTQMckTDh7EtPs2GSsRfkYy65yxMJxvuiSd3/5MvXp5SG6al3vc
         pvPtjh4qhh0R7ewYu3lJma/pqkKiOKuheMpqJYyQt8kt/ycK6XaKxLw30KlVkG0brLMd
         bO+OubNFSlmwruNL5wUjeKuTyfnTDnsET7Xu/dkkxeXxo1OHuRsitRQG2Kvwh9FEv/Z9
         hAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEOc7+m69jizZAlnXFl3o/n8mpgNRufl6cVFO1xVigA=;
        b=kd5MfbU2gRq4tXiJEzmVT7FxlB6DhomhaRAvc5nzaCxZ5GS5ZdTrdH6nojrdpzaUzY
         y+gS4c0zyh4ffnjhemnGJuPcNXMDZggpzVDITSPXACBULZ3GO9rUBWjUEoHp2L8yqg1D
         LZTvtbn4Zg2oUDCspeZCsIQTdjN5Q8Y0nbrBs8PcGMmhiOMyHXka4LdrOuYQ4t+TNUWa
         9+WGa2HqzgMSH9wpakAJKXLFlVjXoamLgCFn2xR6qu85jMgH/Dr5iNVnOAkOPQ8Jd3cM
         c6d1JKf8u9NHJR/rCBIlQRRoNGYBIXnmVsjipxfPC3jkbTtS2oiKqAui5vrI3nklb0+P
         TkgQ==
X-Gm-Message-State: AOAM530EIq+uIa80BmFEYWiS3v/iSiPEMlOcKkuxPqdJWWiM7WeFQdIC
        R4gXnhq77wS9Zmg4v0BuKIwPvzrFE5J034oXC7zm2g==
X-Google-Smtp-Source: ABdhPJzjmCm/Cdm27H8eWQG+cGJGMYNznKYx/KNYWc6n/AEVwCFXaePw4502mWUCx+tgkPAfUA20fy124uo1X+098EU=
X-Received: by 2002:adf:f40b:: with SMTP id g11mr1027874wro.296.1636566503738;
 Wed, 10 Nov 2021 09:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20211110174442.619398-1-songliubraving@fb.com>
In-Reply-To: <20211110174442.619398-1-songliubraving@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 10 Nov 2021 09:48:11 -0800
Message-ID: <CANn89iJ4r10f0375hoGC-227AWTEqJop88qEZRhOinxQWn7oKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: extend BTF_ID_LIST_GLOBAL with parameter
 for number of IDs
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, Kernel-team@fb.com,
        syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 9:45 AM Song Liu <songliubraving@fb.com> wrote:
>
> syzbot reported the following BUG w/o CONFIG_DEBUG_INFO_BTF
>
> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
>
...
>
> This is caused by hard-coded name[1] in BTF_ID_LIST_GLOBAL (w/o
> CONFIG_DEBUG_INFO_BTF). Fix this by adding a parameter n to
> BTF_ID_LIST_GLOBAL. This avoids ifdef CONFIG_DEBUG_INFO_BTF in btf.c and
> filter.c.
>
> Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
> Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/btf_ids.h | 6 +++---
>  kernel/bpf/btf.c        | 2 +-
>  net/core/filter.c       | 6 +-----
>  3 files changed, 5 insertions(+), 9 deletions(-)

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
