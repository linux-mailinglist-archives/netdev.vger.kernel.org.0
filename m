Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B843498038
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbiAXNAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiAXNAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:00:15 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1E5C06173B;
        Mon, 24 Jan 2022 05:00:15 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id y15so40794059lfa.9;
        Mon, 24 Jan 2022 05:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHXDNawBJLq0H1Ii/ahl9brsS3WPDA+iilcuuxor1JA=;
        b=fuboRRqywCiSDbp6ipvJZHJXyiKEPVKZFZuKLBri+oR4dlqAC8XuG2PEmQvbzvpKqi
         1Xq4zijJslw8w2LuN58q/gBeG+jsLKXz47inujmKqZih3NIWQB4y4SQeA+efprBcxuHt
         /lFXhMp6cWRIO2ToDBKmMIyua1QFpMmv+yO8rvUJaGZOWLd5sQJDXdCFxgTCj0avTVKf
         /Y71XFiqRUtJhQELIN3Api+GtxRuO9tdvaa4sbUHMlKKSgFyLW3XX8F5TN1wNWDFJRiW
         uiaE+LZYy6QfVJnvzEl+MkBxIGjj61o+Rgl3EZME8wZP61ODQO+SvD3xvYkGkblPsdsL
         5JWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHXDNawBJLq0H1Ii/ahl9brsS3WPDA+iilcuuxor1JA=;
        b=biuf5qOPDCRgJSB5xi3EnBlY2Qpqk88aXDaRZ9GVCOqe7iPLd+tk0Xg9iPcMmDgFHk
         lVg3KYT+JtZRdOtSKnamIOPAmBX94067M9oZYfMsRCicx6hldoYxylP6ioIMKY0XwVwR
         mVAk70ZBZ6+xc2AJPddqH6z78QXLAG3MyQf6NCWavPbtUBDkRd4sfq/yYLHdRJfLoDsm
         9d7TfX9JjptQj7p2P9DMuqbR6/vX7A6TSlNr0CbuZgG4HZ3ATChB1/E+DDZUVbv7tZZW
         P/av6F0qsW7ylkHkfFhWP9558csVlQ2mJgfcmANnjE3eslOf6rxS1KwAg9UMHEV9CYQZ
         T5rQ==
X-Gm-Message-State: AOAM5330IvyRP7Flb2Gk9RUCoUTQQ73Jm9anh26qlwvYqOoNVUpmeEmD
        pE7YFXUIR0+lgAgUjEal8jVTdhacgAy9pFIr7Kk=
X-Google-Smtp-Source: ABdhPJzTHtUYGliUWXKQsx7KpchvBCjC0ABXft1jdLdC9AabPks7FtrbI+KXJ0yD+SnAoBLxY1uFdquw/vUHSqrJLfE=
X-Received: by 2002:a05:6512:230c:: with SMTP id o12mr5081114lfu.341.1643029213847;
 Mon, 24 Jan 2022 05:00:13 -0800 (PST)
MIME-Version: 1.0
References: <000000000000cdb89d05ca134e47@google.com>
In-Reply-To: <000000000000cdb89d05ca134e47@google.com>
From:   Vegard Nossum <vegard.nossum@gmail.com>
Date:   Mon, 24 Jan 2022 14:00:01 +0100
Message-ID: <CAOMGZ=FdNnYS8wa8gViXiMrvtrESzPURfW8Pofx0y9BNk+PEZw@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in unix_shutdown
To:     syzbot <syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com>
Cc:     Rao.Shoaib@oracle.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, cong.wang@bytedance.com, daniel@iogearbox.net,
        "David S. Miller" <davem@davemloft.net>, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        Al Viro <viro@zeniv.linux.org.uk>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Aug 2021 at 17:19, syzbot
<syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    9803fb968c8c Add linux-next specific files for 20210817
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1727c65e300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=681282daead30d81
> dashboard link: https://syzkaller.appspot.com/bug?extid=cd7ceee0d3b5892f07af
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fb6ff9300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15272861300000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000

Looks like this was only ever hit in linux-next and fixed before it
got to mainline? Anyway, I can confirm the following patch fixes the
issue:

#syz fix: af_unix: Fix NULL pointer bug in unix_shutdown


Vegard
