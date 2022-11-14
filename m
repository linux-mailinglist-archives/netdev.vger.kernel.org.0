Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E898628A43
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiKNUQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbiKNUQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:16:07 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F312BD6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:16:04 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id c129so12683996oia.0
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZ4DceovIvniI/E7qgKtkp+mPXifQZS21MtlnZ7xnPs=;
        b=KI63xJmFi3GEaRs6lSZAeHLr3CTF5DF8CLWsAwCOawP3h7eLV/aX5rkfqg7SAI7yrz
         Ytj/i10DoFbe1O9NHtwb8fhHuQ8Rl5lBNhb/5YkETrkzowz2e7tPzbnlvmC8S4Rihiqc
         0l2/lBQqKE+xGmfodZxaZss5DIaG2oPE9kNDWYb3kO0MEGrVX0FYy+m5R29ZMb/JsHCE
         sd4t5RJI0LFRECpwAguxhiHpjLHIN0VeTZV1CYEQkvhxdN2oHMdav8JAVpdFl4Ap8wN/
         /BKrHDBDbwZSObmHC5OuMKyn29KXmX0SsZxl/eU+XaTdPL5H6Ts5HGQKgJ3i0WK8Na26
         V68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZZ4DceovIvniI/E7qgKtkp+mPXifQZS21MtlnZ7xnPs=;
        b=Fc8Y40CZoLkQrO08lgG2qxkFcjS1JRtemE33fTmbCkEjQd+2TzMQqMb96RHV7FKXPt
         8RhEGY/Q9I9JXuLhgmLbee8Zw4Hhb8uomlaBpXu7jIp5kBTE4WUA30OdduGQ3JQ/qjcc
         basROys2+3aGWZeQquR1Mds5rOEJyVZxUibn2i8dtGZasys+kUX4D6A7ZPpJOAPtB0rl
         zKf3lmWBDvnpYlZWxkwbxxR+S78KO+yKpsZehQDCiw4SGYN7qWdKnGOjvFAenUh7LZ7e
         bl3pmu5noIi+mQf1sPxAPP/S4FQClyCDhkGh9iVth6dmwR8L85Hec1LKRHw0Jxzny/k7
         imbw==
X-Gm-Message-State: ANoB5pkOlPc06Rkh9uZxLKep3MbrurTfwO1Oc8rI7OcZ6EQfbmSXT9Fn
        WtfUTnaWVYn2JVxS0jFW1uRW/2RFqOcDEjgbZtMPoQ==
X-Google-Smtp-Source: AA0mqf6NXAYFJNCUyD3mZ+1ZXmQUxVXXOwtemxrUobtj0DML/MLAUW5C9IeaYdL6bdRlxky7GuvlEVrQHrNwjleHB3k=
X-Received: by 2002:a05:6808:3011:b0:35a:7e1d:3d72 with SMTP id
 ay17-20020a056808301100b0035a7e1d3d72mr6809975oib.233.1668456963311; Mon, 14
 Nov 2022 12:16:03 -0800 (PST)
MIME-Version: 1.0
References: <00000000000061fe2205ed6300fa@google.com> <Y3KU5kwa2XGS9gyy@hoboy.vegasvil.org>
In-Reply-To: <Y3KU5kwa2XGS9gyy@hoboy.vegasvil.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 14 Nov 2022 21:15:51 +0100
Message-ID: <CACT4Y+ZqTQ1gy7Vu8Hsy8tmXa+EC43jYaNxG40biNy3d-rmMmg@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in smack_inode_permission
To:     Richard Cochran <richardcochran@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com>,
        casey@schaufler-ca.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 at 20:20, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Sun, Nov 13, 2022 at 04:05:47PM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    56751c56c2a2 Merge branch 'for-next/fixes' into for-kernelci
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11fc8b0e880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=606e57fd25c5c6cc
> > dashboard link: https://syzkaller.appspot.com/bug?extid=0f89bd13eaceccc0e126
> > compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a691fa880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733c5b9880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/cf4668c75dea/disk-56751c56.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/e1ef82e91ef7/vmlinux-56751c56.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/3dabe076170f/Image-56751c56.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com
>
> Why was this email addressed to me?

Hi Richard,

You are listed as maintainer for the file this crash was attributed to:

$ ./scripts/get_maintainer.pl -f security/smack/smack_lsm.c
...
Richard Cochran <richardcochran@gmail.com> (maintainer:PTP HARDWARE
CLOCK SUPPORT)
...

Also see:
https://lore.kernel.org/all/Y279BqPNYAr+5OxC@sol.localdomain/
