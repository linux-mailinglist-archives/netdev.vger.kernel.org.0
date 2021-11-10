Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881BD44BD97
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKJJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhKJJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 04:09:08 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E205C061764;
        Wed, 10 Nov 2021 01:06:21 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id bk22so1847021qkb.6;
        Wed, 10 Nov 2021 01:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImnqB797AKnJuD4oPIYf8Tox3YCxcvXVphwHiRaIbIY=;
        b=oMfCBYvauO8zRBwa2KehEw6l9I/gVh/IsHK2ianpEu/xIihkSVB/V6SY3F/ttzaM9E
         nezbT4CmBgHKehn2yU5PaH/ZIe37KBZYxptntmlE84NkrCX9sBVx5fvOJ97WuHyjLu81
         ySMip7zDVDJzC8Ud+eLEDqMIyFDT68YJu/vMGfrUMMkvIb9Gy3UDZ9KieYePa59ndf9w
         2iNH/0Swtlcmca7uxTSVZ6+cgn0aA6kyAsyRtDOUv343TMFcvYUnDbmDYL36Evv24Use
         DEXFPEpNZYt0Ltjw511zdD5Yt5ts2oQXhSF1bjzx+hLVoi83rzncSdyXWjhsWQZSkQMW
         9DAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImnqB797AKnJuD4oPIYf8Tox3YCxcvXVphwHiRaIbIY=;
        b=ZHPMhG1+eAE+XkQoyRl7mhWJuUqqVqyiabOx+0COCv+ahau8SNoIei1BkhJyn2eeot
         1YIkXijJhN9Ln70UBrF31t4+Z4LjdJGA3F1qzThf0RlEJ4v5RFtpjhQch4gLc/v0agiu
         3EiGG5g3VEU3+8n/CJfREpxT2pFNL8jCcnDgBbKsVAMhFYzceBM+vcErw9JDFMHesUf9
         LqaUG1f2s+kDSd9KWQ+RGOlrrg7HYlm9BuRMA8xHwV8bfY7zRumokPUA3s3YI/LKq/sx
         g/JYDrxWjzr/ecqV5dhBWbjBTq6Yt/Av17ngtpdYOS5l4gvIUcXnsZXYJlusSJLg/lN6
         sCtg==
X-Gm-Message-State: AOAM531D3c52Gu8LD0gPKcS8wwpSsqrtLyYN5fbPMu8bEOQtyae8VYBQ
        EaoPcF8GYwcUbVyOnb7f9my+n8QMiZYGdxqp+Gk=
X-Google-Smtp-Source: ABdhPJxecwxlgh5Be+apIVbyhK9b5EOBmc1BMU6ZqqxInFojT85GAhLJhs4ImfIMb89COAJxX42mTS13PbNiDO5tpM0=
X-Received: by 2002:a37:e97:: with SMTP id 145mr11499308qko.116.1636535180801;
 Wed, 10 Nov 2021 01:06:20 -0800 (PST)
MIME-Version: 1.0
References: <20211108083840.4627-1-laoar.shao@gmail.com> <20211108083840.4627-2-laoar.shao@gmail.com>
 <c3571571-320a-3e25-8409-5653ddca895c@redhat.com>
In-Reply-To: <c3571571-320a-3e25-8409-5653ddca895c@redhat.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 10 Nov 2021 17:05:44 +0800
Message-ID: <CALOAHbCexkBs7FCdmQcatQbc+RsGTSoJkNBop0khsZX=g8Ftkg@mail.gmail.com>
Subject: Re: [PATCH 1/7] fs/exec: make __set_task_comm always set a nul
 terminated string
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 08.11.21 09:38, Yafang Shao wrote:
> > Make sure the string set to task comm is always nul terminated.
> >
>
> strlcpy: "the result is always a valid NUL-terminated string that fits
> in the buffer"
>
> The only difference seems to be that strscpy_pad() pads the remainder
> with zeroes.
>
> Is this description correct and I am missing something important?
>

In a earlier version [1], the checkpatch.py found a warning:
WARNING: Prefer strscpy over strlcpy - see:
https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
So I replaced strlcpy() with strscpy() to fix this warning.
And then in v5[2], the strscpy() was replaced with strscpy_pad() to
make sure there's no garbade data and also make get_task_comm() be
consistent with get_task_comm().

This commit log didn't clearly describe the historical changes.  So I
think we can update the commit log and subject with:

Subject: use strscpy_pad with strlcpy in __set_task_comm
Commit log:
strlcpy is not suggested to use by the checkpatch.pl, so we'd better
recplace it with strscpy.
To avoid leaving garbage data and be consistent with the usage in
__get_task_comm(), the strscpy_pad is used here.

WDYT?

[1]. https://lore.kernel.org/lkml/20211007120752.5195-3-laoar.shao@gmail.com/
[2]. https://lore.kernel.org/lkml/20211021034516.4400-2-laoar.shao@gmail.com/

> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> > Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Petr Mladek <pmladek@suse.com>
> > ---
> >  fs/exec.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/exec.c b/fs/exec.c
> > index a098c133d8d7..404156b5b314 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1224,7 +1224,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
> >  {
> >       task_lock(tsk);
> >       trace_task_rename(tsk, buf);
> > -     strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> > +     strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
> >       task_unlock(tsk);
> >       perf_event_comm(tsk, exec);
> >  }
> >
>
>
> --
> Thanks,
>
> David / dhildenb
>


-- 
Thanks
Yafang
