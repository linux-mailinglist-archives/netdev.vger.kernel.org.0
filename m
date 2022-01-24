Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96A4497E2B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 12:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237830AbiAXLmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 06:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiAXLma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 06:42:30 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6648BC06173B;
        Mon, 24 Jan 2022 03:42:30 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id n23so10652408ljg.1;
        Mon, 24 Jan 2022 03:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fK9aIW3UzZKCiVlPcUGVx7E5P904jn6nRwrBK6XG390=;
        b=SHY2Esua8OM6IcNOWmZSipT6NmfJ5XXVc6fq772y50OV7AwoMaMlaZtUuWflyZN/ks
         I1V53kzPMUIX/Q74lBSdrjNa6Ea+vN9cewBpEDS7gHNhZv+Eod2x5lbIiGYa/alwoDFH
         iavIL6VuEXyTreUbYUmTIx3rguCEG1DAbzU/jDYdxwrNEMCQjqoNljxSjSvWQ1JpHIo9
         TglGoCJMtcyq21wR+Ea+YGauvKsj6vRjb6h8NcgfdePQSxqxJjMykG23sP0KD1kpT5js
         7ETNe1ryFgT8Su6djjj816kIMTonGHyxe7P2Y7xp4zHrKrsrjU3d64UBs1H3IT2TijwY
         KKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fK9aIW3UzZKCiVlPcUGVx7E5P904jn6nRwrBK6XG390=;
        b=JAfs2CT/7gzIDW6iJrl5NgkyWSGWVo2zI0TU8Sq8xYhQKlC3Yq6BtY5yKcx49s2JnK
         +472rJpIzjqg0m7GovenpdM2Hkm1ATMypePsCE5OYu7XZSOcRWDvhr8bHzVWrPbogHZX
         oEmcfFlxU0C1vJaUbNeG7ttrNozguexlcasv7OsqPs+EmXmY8doI7pPw81DEtkIA/5Pk
         0GqS170KJrTGVbNtKnDla8vHe8LoxCI1w6AAheyD6AcR/VSifpa7OVGRvpp2gxPlU/Ee
         sWvBLyO60bJrhDg0FaiHutZWggoAiUakUidJF6Vkm8qsFtKfnREKDRrichVrU5VxDNPJ
         vf8w==
X-Gm-Message-State: AOAM5315ZnhtDzoDwhZ2j+BmRAPMxfPvKdVK7pxD470gupJ+nlvyQIAv
        1tGFszPXxJjR1pPpaupOcpu6banYaIpdJ7IUTXh5nAtmIjiUXQ==
X-Google-Smtp-Source: ABdhPJygjNVUHkoE8BDdEVfMhS670G5P+BPcwj16DBpSv47hRzzoonZhVcPwh2uM6ogAzS3ZF5ftkeOF9pTJYZdpWKM=
X-Received: by 2002:a2e:b747:: with SMTP id k7mr11089297ljo.182.1643024548694;
 Mon, 24 Jan 2022 03:42:28 -0800 (PST)
MIME-Version: 1.0
References: <000000000000367c2205d2549cb9@google.com> <0000000000009fa8ee05d60428f1@google.com>
In-Reply-To: <0000000000009fa8ee05d60428f1@google.com>
From:   Vegard Nossum <vegard.nossum@gmail.com>
Date:   Mon, 24 Jan 2022 12:42:16 +0100
Message-ID: <CAOMGZ=E9Gmv6Fb_pi4p9RhQ_MvJVYs_6rkf37XfG0DYEMFNbNA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in __bpf_prog_put
To:     syzbot <syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, "David S. Miller" <davem@davemloft.net>,
        fgheet255t@gmail.com, hawk@kernel.org, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lmb@cloudflare.com, Linux Netdev List <netdev@vger.kernel.org>,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 at 15:17, syzbot
<syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 218d747a4142f281a256687bb513a135c905867b
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Tue Jan 4 21:46:45 2022 +0000
>
>     bpf, sockmap: Fix double bpf_prog_put on error case in map_link

I can confirm the above commit fixes the issue, but it references a
slightly different report. Looks like the only difference is
__bpf_prog_put instead of bpf_prog_put:

KASAN: vmalloc-out-of-bounds Read in __bpf_prog_put
KASAN: vmalloc-out-of-bounds Read in bpf_prog_put

However, looking at the stack traces for the two bugs shows that
__bpf_prog_put() is really the location for both reports, see:

https://syzkaller.appspot.com/bug?id=797cd651dd0d9bd921e4fa51b792f5afdc3f390f
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450 mm/kasan/report.c:450
 __bpf_prog_put.constprop.0+0x1dd/0x220 kernel/bpf/syscall.c:1812
kernel/bpf/syscall.c:1812
 bpf_prog_put kernel/bpf/syscall.c:1829 [inline]
 bpf_prog_put kernel/bpf/syscall.c:1829 [inline] kernel/bpf/syscall.c:1837

vs.

https://syzkaller.appspot.com/bug?extid=bb73e71cf4b8fd376a4f
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
 __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
 __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
 bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829

Looks to me like the compiler's inlining decision caused syzbot to see
__bpf_prog_put() instead of bpf_prog_put(), but I can't tell if it's
because it got inlined or because of the .constprop.0 suffix... I
guess syzbot skips the [inline] entries when deciding which function
to report the bug in?

In any case:

#syz dup: KASAN: vmalloc-out-of-bounds Read in bpf_prog_put


Vegard
