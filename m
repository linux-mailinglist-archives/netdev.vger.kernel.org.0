Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA075A5EA9
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 02:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfICAkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 20:40:19 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38967 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfICAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 20:40:18 -0400
Received: by mail-lf1-f67.google.com with SMTP id l11so11470062lfk.6;
        Mon, 02 Sep 2019 17:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSQFUN1coayi0r+Ppbl2xZFji31Lku8zDRkb/tqLDLs=;
        b=hNzT8WmJEHpUaWq5ajCUt4ts0i1mBZAty+lnrinYXgD9UpDMSVbG3pE7NeT7IJsFLr
         a3twoAKCwrMipHh6dNc34wKDG0R+n/QhtLUX3wFFA8JyEURKZOmOdd9MEHhFT8DWD4nK
         wZRSdXl61IcieLPViNLlp/nSyrhv9dCIrAZTHkyEUAC6v3GfAgxdW15uro0XFxsyeOUN
         aRTGsb2TR5beCPzmyYpSjXsigm/ed7nulQtIQ7vHWo9A1nm/3namJGPueoqljvm3/3gP
         j6XBlw/iP1agffwhV/0k9POXncUyXRyBkG2RUKJrIQxxALRUDi5M7pmbmq+3BaMooyCe
         dktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSQFUN1coayi0r+Ppbl2xZFji31Lku8zDRkb/tqLDLs=;
        b=Gf5IoxlM3VOTcOstKtqDa325fyAhiz99WPKhYVj7ZQ/uzPy8aBk1fo4XWOztKHN/p6
         S6fbU8K4rDccnOkp0uIHVUKT3xyZvh+zGHFZKMzg6CwJMgnyvy+dYuvMnXFLVQjLRnm/
         Lsra18ZMxkEMyWChOQj/gdSth+OEAk9Tp/HFSZgTS2FlUvDHV0iHU6ScldBA4xgXRIqA
         0c6k1fuyO8ygluuZGrTlNZsl8291d4laaWZW1K3CJU0n+lsXhq5vdSNKtPZa9gTd1DPj
         qd5mMeXYrNGkvIo6eYrseQl2YNKGGy0MbTgR4+Ds7zqZ5xyrPzFg76UjcEvLoyjBE5Sj
         H4NQ==
X-Gm-Message-State: APjAAAU2LG08BLLJhgubFVcV9Anwfzr3fjQJAZSL6JAj4JA1Pi8I4yms
        O0iBmdt8d31edHR6KVV1BCt3FYYWUkqK7LuoUPA=
X-Google-Smtp-Source: APXvYqy5kE9O2Jan7U9vxS0ZTewxmsAg7826lqvePlXMeh3gDJnJzjAv0vw0VESDtMPloET/9U9ILVj+Y1z89IxILJQ=
X-Received: by 2002:a19:5503:: with SMTP id n3mr6680272lfe.6.1567471216399;
 Mon, 02 Sep 2019 17:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b7a14105913fcca8@google.com>
In-Reply-To: <000000000000b7a14105913fcca8@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 2 Sep 2019 17:40:04 -0700
Message-ID: <CAADnVQJQuF671uCqFGwcD+M5Wn92uFEAkMr4rLQnrSDfb4+gkQ@mail.gmail.com>
Subject: Re: WARNING in __mark_chain_precision (2)
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 4:28 AM syzbot
<syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    47ee6e86 selftests/bpf: remove wrong nhoff in flow dissect..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16227fa6600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=c8d66267fd2b5955287e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d26ebc600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127805ca600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c8d66267fd2b5955287e@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> verifier backtracking bug
> WARNING: CPU: 0 PID: 8795 at kernel/bpf/verifier.c:1782
> __mark_chain_precision+0x197a/0x1ea0 kernel/bpf/verifier.c:1782

fyi
I found some time to debug it.
The following program will be incorrectly rejected
due to precision tracking bug.
(b7) r2 = 0
(bf) r3 = r10
(16) if w3 == 0xf6fffdfd goto pc+0
(7a) *(u64 *)(r3 -16) = -8
(79) r4 = *(u64 *)(r10 -16)
(b7) r6 = -1
(2d) if r4 > r6 goto pc+5

Still thinking how to fix it cleanly.
