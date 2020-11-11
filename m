Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152B22AF2AF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKKN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgKKN4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:56:21 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94D1C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:56:20 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id t5so1307060qtp.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=evZbUdrURWWK6jTDz/cmjF+w+/X7iHus1/DoYC2u9UA=;
        b=a0DBaJ2HEKw0FC98SNnye2BrU+cNqW9pHh1S+swacH79hJmgEHBFLyk9q2nm2dC1yA
         Hb0z5ZUGTP+9rmjvNdgNInng6+XFX/thbrAhPf+9r7ABU+zBaIO0lru1pJYBJF+Zz50I
         ojCFWxZX9D5hNuXxxD2X3R/NssE4VYONhR/2S0Udr6P0LFIreA/y9aIgSX4oLAPme6Uh
         oeGlrBjzLsYZJS98fzqy57d3iwtKkt0U9nfMAk3BR7QcvnHpf2bNqxYumSGFEinYzC1W
         pQcs8JuQtjLXLqqwNu8Qjy4zgAhQcxpbnGd72LkPLfH/Ip5ZF0hGD4aXCJHbjJXMulrl
         +5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=evZbUdrURWWK6jTDz/cmjF+w+/X7iHus1/DoYC2u9UA=;
        b=jWaNeB0zc2hrZYP9+FTOKMJqCFIY0XseFpdxRrf/lKQvmFVPXoI3O/NkpH1d/P2gUv
         8GfHJ5539XCLrQih41xJ34goIAn9OFJIoO5xJ1oGlTfPk90Qin9F7EKVaebz/Rehc8ty
         Mjrp/2alAWzZfp58hlukv1wAieAA/xSKutZq/QqMEfAM+/hYwl1jo4P8bp5zIs4DvX78
         euAXiLh95Sbv25l991Bukh1Wx76rr8rM288zWDVEbCmP4OEEBWa16J9+T6JbHHQD/pWh
         jWu29RMJeOrOV8fTcf94ZmUy+M4u2kyR+Y/So+8OZC4ow++bFazLAdif4e/YuhkkjICu
         /WHg==
X-Gm-Message-State: AOAM5311eZGYhRn+h2ulIhLvQberQCWvWiTMD4BQ37QafbXQ/41F6ptb
        Nh82mR9qtSVZZRPCR30xqmhH9/4Uj1VinTD5lS7SlA==
X-Google-Smtp-Source: ABdhPJyrNEIhOrLFHAYIfT6DWtmA/Vg0M2tT/I39jtmCGDiPjEfzWAjUpA0scY14KAoRJBzPWW1US6PRxuP3VgZ2Z0I=
X-Received: by 2002:ac8:37f2:: with SMTP id e47mr23244398qtc.290.1605102979855;
 Wed, 11 Nov 2020 05:56:19 -0800 (PST)
MIME-Version: 1.0
References: <000000000000eb3fa9057cbc2f06@google.com> <00000000000031842b05af43b363@google.com>
In-Reply-To: <00000000000031842b05af43b363@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:56:08 +0100
Message-ID: <CACT4Y+YhiJOsvfbnVE5j6r1pcMwh3SpbyGHmuGeK0Zpj1zxonA@mail.gmail.com>
Subject: Re: INFO: task hung in ctrl_getfamily
To:     syzbot <syzbot+36edb5cac286af8e3385@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 12:43 PM syzbot
<syzbot+36edb5cac286af8e3385@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 47733f9daf4fe4f7e0eb9e273f21ad3a19130487
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Sat Aug 15 23:29:15 2020 +0000
>
>     tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f287b3900000
> start commit:   f5d58277 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
> dashboard link: https://syzkaller.appspot.com/bug?extid=36edb5cac286af8e3385
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=139f101b400000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
