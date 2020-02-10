Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F34C1585F2
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 00:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBJXH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 18:07:57 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38283 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbgBJXH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 18:07:57 -0500
Received: by mail-ot1-f67.google.com with SMTP id z9so8208584oth.5;
        Mon, 10 Feb 2020 15:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRiq/HHzhlZ9XSHrTt87uvpDh68wK+B7Fb3SKhNR96E=;
        b=mmWthATiZMjQ0XrMTxA59hikIPhEucZP+mt7+oAihEqjXm6Wyb3Lrpq2cG91kOtB34
         1vMY1/Gv1Fh8aafOu36K+ir/jex3cbKsfmLy3JqANBIy+XAXo5KshNmkhi0mkXf3WScm
         6MaW3lQsPdW0Sp60fAq4JW6zTOAHkOoSyMw4hq5X5fp0JORR14wf99EQqdaKTt1wydEl
         KuYsxDRNVWhoxNMtSr/8yWNjpHGWhq1vwGgautz8EAV9UrV9DP2VU+WlttEaWZeEZBxl
         YpMOLF2t1vBgUrQFw9ZCsJCQeL/K6jKwi59Ql41zGvB9cnwytfHoBPd+G+FklCRuIEg+
         Gelw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRiq/HHzhlZ9XSHrTt87uvpDh68wK+B7Fb3SKhNR96E=;
        b=h1Y/8ytBLIQdfZV3c2k0ioyNAkgrza+sXCklg6RpYzlRYzrOgQLZmGhae0YERoIQOD
         iQXHggFRpI+6rpoS4UxSQ4w6eZO0rC551MqKR9ksDxPha8TjUtuAPNXmgzq23EZvnDEk
         645giraU1BdaUDcL7K5E6TKE7xNqH6U6mB4S3QUxI64Q5tnh0pUjHznwxcs85XhI8KSc
         sQ39BSU7c/v8liRHx85yKyeO2KTmGOebyBAGuH0/6sTZMTBetSA2moGCULN4lSvAb5G+
         G1kD+orfC/BbpvwPWOjRWmmk963SAUIKTLJxmTSOxSYJqvMEOdB6Pd1vTkMC+/XkTW6I
         Ok4g==
X-Gm-Message-State: APjAAAXJj++UP4N82ke+ryHMijlWSM+cbuf6fnLm3nZEXKWMumeut6/r
        itlcqEW5zUmoosBaearMputtcMC5xWIwjOnP1nw=
X-Google-Smtp-Source: APXvYqwjMxBgYv9PzzxcHqfZhfSm4YWQLuMPKkkW21qvNdzy/laP5WsI/5fj67N+oxeU/bXXOndxzomwWW/Bs9gWHr4=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr3144957oth.48.1581376076151;
 Mon, 10 Feb 2020 15:07:56 -0800 (PST)
MIME-Version: 1.0
References: <00000000000019ff88059e3d0013@google.com>
In-Reply-To: <00000000000019ff88059e3d0013@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Feb 2020 15:07:45 -0800
Message-ID: <CAM_iQpWaO5C8FtaP6BGRAc3v0CTTOySH-SmTyd21vU8R_LwWCw@mail.gmail.com>
Subject: Re: WARNING: proc registration bug in hashlimit_mt_check_common
To:     syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 10:35 AM syzbot
<syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    2981de74 Add linux-next specific files for 20200210
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=104b16b5e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53fc3c3fcb36274f
> dashboard link: https://syzkaller.appspot.com/bug?extid=d195fd3b9a364ddd6731
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136321d9e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159f7431e00000
>
> The bug was bisected to:
>
> commit 8d0015a7ab76b8b1e89a3e5f5710a6e5103f2dd5
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Mon Feb 3 04:30:53 2020 +0000
>
>     netfilter: xt_hashlimit: limit the max size of hashtable
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a7f25ee00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=11a7f25ee00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a7f25ee00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
> Fixes: 8d0015a7ab76 ("netfilter: xt_hashlimit: limit the max size of hashtable")
>
> xt_hashlimit: size too large, truncated to 1048576
> xt_hashlimit: max too large, truncated to 1048576
> ------------[ cut here ]------------
> proc_dir_entry 'ip6t_hashlimit/syzkaller1' already registered

I think we probably have to remove the procfs file too before releasing
the global mutex. Or, we can mark the table as deleted before actually
delete it, but this requires to change the search logic as well.

I will work on a patch.

Thanks.
