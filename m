Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03233E82DB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhHJSVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbhHJSV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:21:26 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCBC078345
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 11:02:57 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p145so37714923ybg.6
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 11:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHqo7EILZW+YSdl/5VDjBLKY3WeyT9Im9UwiXpyexBw=;
        b=Sw7EYklMxIPD0A8sP1K+skIL/5d0j4lSfLuBb4r4dyLQKR7LMu5dIWjxonOvY9yyC0
         xGFbH2KRwJBUtg95pOvNgtVRjgGlx8CkxbDMQyLIPQ5hLLFseEHWDwhWO1jkD295A00y
         W6Amka+vQ3u8dcJTfHuhVE02RWlxhCaVmbyA0t7lJSOeYcHiN+NYI+qkL/ucIHInZ4uA
         /xy20aqQ6ORz0/f2n9xTlgE9/KAjKy5Zgjncl1iocDmw/EAkTjeKvoA7U1uk/hNCM5GI
         BSyfN/0T01618F5ABgd5VUWtS3ebBM6W85mKTcGtNtISkaWdUT44hq2y8hRzfoZkYnRn
         5MYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHqo7EILZW+YSdl/5VDjBLKY3WeyT9Im9UwiXpyexBw=;
        b=RpyGkMMmYEkt1Vfn3GBvHeYqH2I6XVG3/CjNeeZyBaNJVEtYCU8pw9mt4fFtFYqrW9
         2Pa98cNAMlNkIisnKHE0d48E2jXe122PBIWua8YMsjtflaUC/uw4wBU5oGfVHPTjWhTH
         lRa5sry9AjCEI1sG5m0IbkTZsLBuHECbJ2Q7hiYlOXYok2ImAtXptlrtJsVa/nj5haKG
         4dLCtwM6Qbj1W97fkUCMuOfCqOR8Zp6yV2W43F9aRYAiqE9pUjEpeoqo0NvLYTkFuh93
         /CQcWRxOIcZIqPyCc7SKG0hWhNJjeRHQKEoVWjQf2mngmMa+9WyOhQYUEuNnsboyYSrQ
         +7rQ==
X-Gm-Message-State: AOAM533c68ogOM6AN+s9AqNUBzME6VLVmbFtqkjur4ZdWn6Jyoi9ZIbO
        qBmmuILkH2ne88JZzQu/dvOI4tAoul4+UhhcnxSPdg==
X-Google-Smtp-Source: ABdhPJwhzD7auOcf0ZhqBy6VIuL8hOMQlMVIgekREU2RxDG23KP2hJm1lqS0l9oHkUCuzeMJy+M5U2zN6NzTtOYTO5o=
X-Received: by 2002:a25:cc44:: with SMTP id l65mr5183317ybf.303.1628618576203;
 Tue, 10 Aug 2021 11:02:56 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006bd0b305c914c3dc@google.com> <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com> <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com> <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
 <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
 <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com> <66417ce5-a0f0-9012-6c2e-7c8f1b161cff@gmail.com>
 <583beba4-2595-5f4c-49a8-f8d999f0ebe7@oracle.com>
In-Reply-To: <583beba4-2595-5f4c-49a8-f8d999f0ebe7@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Aug 2021 20:02:44 +0200
Message-ID: <CANn89iJOFoMa2-Dx+_b8p0-FNNKhYn4DsB3AbtL7zR4bvNR5DA@mail.gmail.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in _copy_to_iter
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 7:50 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>
>
> On 8/10/21 2:19 AM, Eric Dumazet wrote:
> >
> > On 8/9/21 10:31 PM, Shoaib Rao wrote:
> >> On 8/9/21 1:09 PM, Eric Dumazet wrote:
> >>> I am guessing that even your test would trigger the warning,
> >>> if you make sure to include CONFIG_DEBUG_ATOMIC_SLEEP=y in your kernel build.
> >> Eric,
> >>
> >> Thanks for the pointer, have you ever over looked at something when coding?
> >>
> > I _think_ I was trying to help, not shaming you in any way.
> How did the previous email help? I did not get any reply when I asked
> what could be the cause.

Which previous email ? Are you expecting immediate answers to your emails ?
I am not working for Oracle.

> >
> > My question about spinlock/mutex was not sarcastic, you authored
> > 6 official linux patches, there is no evidence for linux kernel expertise.
>
> That is no measure of someones understanding. There are other OS's as
> well. I have worked on Solaris and other *unix* OS's for over 20+ years.
> This was an oversight on my part and I apologize, but instead of
> questioning my expertise it would have been helpful to say what might
> have caused it.


I sent two emails with _useful_ _information_.

If you felt you were attacked, I suggest you take a deep breath,
and read my emails without trying to change their intention and meaning.

If you think my emails were not useful, just ignore them, this is fine by me.
