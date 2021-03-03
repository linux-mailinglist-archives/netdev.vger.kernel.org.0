Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3232C47A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhCDAOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbhCCQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 11:22:33 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C9EC061761
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 08:20:58 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w9so14600744edt.13
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 08:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7oMQzTqAOm2hnQffsTaCOfeTj0G+JUHHCY8d/eydSSY=;
        b=z/W60i9vbwd/cA3kpfvw5073LOzVMbCldbbkRoUuapoRS/tBfyqr/PwXedDrSIthHc
         b4Da17NVABWXlzLU71V4fhM4bcApBUhA0cerpZkRraT8hlzq7dnNVL86rhn35IDDZvM7
         uwM59m8FyOpgHu6PU5eqTaaDRqPmhB76X3lEpicTWV7U+eq/pbKrRiYHWGHKO4caPvGj
         L0q5RpCNgRmvkIbcZcBQeBcp8VPh2yWtGyOypXdVnfXLNs1Vu5q5yrrgyWkv5NmqK2y2
         OSWEKg+WfcidFJ2uLdGucUQw+T3RgWPffmT3AzspSOHQugsHCPrq3A1UjHAp7hQqz2CL
         1OHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7oMQzTqAOm2hnQffsTaCOfeTj0G+JUHHCY8d/eydSSY=;
        b=aZowhhHjKSG67OZkXsHV1VuhgAX3kgt2w9CDa1t9IJD+5XGcK3wfzuhngjovGwz1B2
         WoOXw+C4XiwhuLNiXUh+d6Yucwssc+1k44a5sRHSt20pk+wTNzwoeP8To5EZtbg4U9f/
         q7FHdhxxCofAAJ4pff+d3NkopQ8NzFX3IKsuW3JBO/lyMo7WtWASm79kBQhsPZavXBZG
         w2NLCxvGJwdt3mXr5RRugM2YGm/hV6I6BhSKg7Ftfm9azeQRvRNFyra2OgbVuV6oxuVF
         74cQdfkC1EDa7WhpJ+7P0S+MbdsGO2yhZfZzJrFiE0SLsyHTEn77Cru0qSzwNHVWMTd7
         TSmw==
X-Gm-Message-State: AOAM533QZw/im+vCnxOFg8PefcVSwKku84bxoR6u0ja1s0Ief5fP5XQE
        JhoXa19MIO5KIA4c/h315x4NiH11g6tTFbCoPAcE
X-Google-Smtp-Source: ABdhPJzU43PvP/dKWjNdyFxXOAyjlNYOQrGgrKdkykxmaK2LCh0f1pMajRbc0LraMTOAnpzVkoO04VSwZUj38qXEBas=
X-Received: by 2002:aa7:db4f:: with SMTP id n15mr77541edt.12.1614788457018;
 Wed, 03 Mar 2021 08:20:57 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f022ff05bca3d9a3@google.com>
In-Reply-To: <000000000000f022ff05bca3d9a3@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 3 Mar 2021 11:20:45 -0500
Message-ID: <CAHC9VhT5DJzk9MVRHJtO7kR1RVkGW+WRx8xt_xGS01H3HLm3RA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in cipso_v4_doi_putdef
To:     syzbot <syzbot+521772a90166b3fca21f@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 10:53 AM syzbot
<syzbot+521772a90166b3fca21f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    7a7fd0de Merge branch 'kmap-conversion-for-5.12' of git://..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=164a74dad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=779a2568b654c1c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=521772a90166b3fca21f
> compiler:       Debian clang version 11.0.1-2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+521772a90166b3fca21f@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: use-after-free in atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
> BUG: KASAN: use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
> BUG: KASAN: use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
> BUG: KASAN: use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
> BUG: KASAN: use-after-free in cipso_v4_doi_putdef+0x2d/0x190 net/ipv4/cipso_ipv4.c:586
> Write of size 4 at addr ffff8880179ecb18 by task syz-executor.5/20110

Almost surely the same problem as the others, I'm currently chasing
down a few remaining spots to make sure the fix I'm working on is
correct.

-- 
paul moore
www.paul-moore.com
