Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18321E70A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 06:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgGNEiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 00:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNEiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 00:38:11 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB69C061755;
        Mon, 13 Jul 2020 21:38:11 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id di5so6892848qvb.11;
        Mon, 13 Jul 2020 21:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y31BNb/eGqFyJBN9GqgydpHsgPuWi+UTnaYm/dyFLoI=;
        b=e9tDNzCI8y6XASca3rMyCwClFiMfEEI33PXc7benargRe/+17u5jsFnueV7HBXITtv
         HW7eiKWN9OyTktMyjHfLdSdu1lFnayYfED8Hc20dYOGvDztyJwrwHA1BZxD/ld+eD1bI
         Tvlzza0S1EufFf7AKFAu7ib8CAw1wrSaQIYgQff15LoL5h+yoAfC//rsneKxzDVEyS0e
         Az/2R3VhPPK3gjIcC4kZn8O6uRVJwUGKLhGFNynZU/09OIisazZUhZFDwZkosLjgvrUY
         z3uHf/da1SZLzfnI+bNcxuos69+KRIvdGNto+jcGoQ//ki3PNsKRUYBMFXPxKhkTjKss
         gATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y31BNb/eGqFyJBN9GqgydpHsgPuWi+UTnaYm/dyFLoI=;
        b=tdWO4Vloi8wHbnsjlmAmj5/rOj7FZ9sC6ayXVv21emrEvvQggCeRKyaadT5yXdd74X
         UwIS+/PHHLJH5SYg90r7d0TavczPxBIXhSntNTonPMcO+hKjShu61YHaZ3MSzcJjtCDC
         5N//o/ZQ8Yzl7qxOGo5bCR9QSUUkZ2u+WZZz1xJvEqaSj18+NgwznC3J6B919bm74cpM
         B3tCsUyFDrsXMBYl6lFEZf0li3zDEE1z/UUYy5ZVCxBgh/hGY3ScUDN6IF+EPjCPpyiC
         JvIn4QvoFa8S42AUxalh0KbE3SOD1RyVU5Sug/yFykafsEmuKxe2UEjDlqJUm6pnOJX0
         kmHw==
X-Gm-Message-State: AOAM530aBxF0QFnFvHLQ6EAIv/UE9w5/x1KebncL3KJ82j7g1Ic7LtbM
        FCnsgHScKmZIj/ooKAeNa5Vul8nPQVSi8zIu+nniYf/B
X-Google-Smtp-Source: ABdhPJwSrv5o8uceS08bCjMWdOKnZPRzCxY5GI1ylSLJd33CSHfFGyaUZTVFHyQzBvK3OsQU7+LYYigmmVcyHbVaA3A=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr2751110qvb.196.1594701489859;
 Mon, 13 Jul 2020 21:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZRGOsTiW3uFWd1aY6K5Yi+QBrTeC5FNOo6uVXviXuX4g@mail.gmail.com>
 <20200714012732.195466-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200714012732.195466-1-yepeilin.cs@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jul 2020 21:37:59 -0700
Message-ID: <CAEf4Bzas-C7hKX=AutcV1fz-F_q2P8+OCnrA37h-nCytLHPn1g@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] bpf: Fix NULL pointer
 dereference in __btf_resolve_helper_id()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 6:29 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
> as NULL. This patch fixes the following syzbot bug:
>
>     https://syzkaller.appspot.com/bug?id=5edd146856fd513747c1992442732e5a0e9ba355
>
> Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Thank you for reviewing my patch! I am new to Linux kernel development; would
> the log message and errno be appropriate for this case?

I think it's good enough, thanks for the fix.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Change in v2:
>     - Split NULL and IS_ERR cases.
>
>  kernel/bpf/btf.c | 5 +++++
>  1 file changed, 5 insertions(+)
>

[...]
