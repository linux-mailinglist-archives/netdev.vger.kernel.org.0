Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DF0AE169
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 01:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbfIIXOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 19:14:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37975 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732679AbfIIXOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 19:14:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id p9so2719558plk.5;
        Mon, 09 Sep 2019 16:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnPYup0xw3Eb5njOd3rYqtDRxyOzB44nVNWIjyYBJh0=;
        b=Dmb9B1P8407Yq8mUXGe89Uq8Ku8ZcvzXs4tEcEaovNwr6s+lHFcDXeccKwQnnxh7CN
         LfQkcvWU9YcS5Gc/Tk9cdc7ZWs4OeTMTQFrbJCyJA3CVfArBJQg1NXvpUSmj3WV+hxeK
         4zykZjo7x6k+QOHF7pVsW0GfGubPSnrNXLajBWs0hhNU6+DDsqBQfrxwi/Fxz30t3M7h
         XScrwyUaICb+Q6J2exNFzEKD8o6Hz6mqc/MeWbIaKPt37RbvhTkAr3zlWjDKl5ksKlgJ
         q05QYYNZzr8Orr8C9ixoYsRo4ko9OrHR+jOvZfXIDjmcRRE5r4xndEbINyf1QcORn4pT
         6VTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wnPYup0xw3Eb5njOd3rYqtDRxyOzB44nVNWIjyYBJh0=;
        b=D8GsgtZnCcEhnZYSA2DC6AQuRkeS65Z1VYTR1xpzZ8EDXfVbypfWhTHiu8ignERi8Y
         iSfCU1FzRyFU2vbg2gyFSOVDaSq83IUXsZ6sXJ3vdVLCILVwaneOPj+w8/hKmOpEKPoy
         rant101HQYHScpFPM+Ka8eNOM5YeYzNbDFcYzLcBHJQdwJRhgfS7bCV33ZVVdLTJrNpq
         hch3ygZ+nYHDt3sKnO6GdgTnUChwlY5wjqHJh6Eiti34YwA5KsWFbNxZ8CmQ1CP+8c8V
         dLr4r4euXzB3/JBZ34qKD1sOASnL+ad9mzbhJadg+p2dWKrYdKOx84fYJ69Ntg093bS6
         +P/g==
X-Gm-Message-State: APjAAAXDVZD+UgBBaNQ3gzeKlqnSq4/nfRtJ1NiuL4Iy9ImwU/gV/k6o
        DCaaDlbwrNobQrSluGOB8ydrZ1PDNKlFJB7RBvA=
X-Google-Smtp-Source: APXvYqz/dAFZoyxZcRVZkheUZFz5AmaNatRrB+scZ01HX2m6bfaguo4wejgOrISJ2KaJSjBB4EX8ysDUynbeRywGRFU=
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr26041646plq.316.1568070887973;
 Mon, 09 Sep 2019 16:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000df42500592047e0a@google.com> <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
In-Reply-To: <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 9 Sep 2019 16:14:36 -0700
Message-ID: <CAM_iQpU2Z0s8pJAa3AAMbq6S=MeuAAOVqRopVpmDnFLn9xU=UA@mail.gmail.com>
Subject: Re: general protection fault in qdisc_put
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 8, 2019 at 10:19 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I see two solutions:
>
>  (a) move the
>
>         q->qdisc = &noop_qdisc;
>
>      up earlier in sfb_init(), so that qdisc is always initialized
> after sfb_init(), even on failure.
>
>  (b) just make qdisc_put(NULL) just silently work as a no-op.
>
>  (c) change all the semantics to not call ->destroy if ->init failed.
>
> Honestly, (a) seems very fragile - do all the other init routines do
> this? And (c) sounds like a big change, and very fragile too.
>
> So I'd suggest that qdisc_put() be made to just ignore a NULL pointer
> (and maybe an error pointer too?).

I think (a) is the best solution here.

(c) changes too much, we already rely on this behavior.

(b) is not bad either, just very slightly more risky.

Alternatively, we can add a quick NULL check inside
sfb_destroy().

I can send out a patch if you don't.

Thanks for looking at this!
