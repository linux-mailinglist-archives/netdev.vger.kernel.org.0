Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B7B4964DE
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380793AbiAUSP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242836AbiAUSP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:15:27 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0367FC06173B;
        Fri, 21 Jan 2022 10:15:27 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id i82so11745820ioa.8;
        Fri, 21 Jan 2022 10:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRkcyoT84nrcNfWbOC6Wu/HIKRFlU4vvaFal17BgFYc=;
        b=apy3wiu/cpDitQ3oBlc6taobtHHigmIrxKbYpaKIay6l+532f6AZvIXw7ywKqiK1bo
         cz19O5SaJEjzOvX9pDxRem/NBR27MBdTHFe/oSldHOEkgf3BMSmln51U7LXEBUz+6mDT
         u7Bn/7dh0ntU+LHeavD1O7xRB5wfgzJxy8F+Wz4ZETgwBjaY8gM15MIgKPwUYNoRBFSn
         VHKj9QepPY5TYupkS0je17gyd6auy/fhrSCGbEeF3s5wt8CBonhPFIROnP5AOjozTIYm
         KiHRZQfC1qQMX1CjifXCnTYQ+m5oP8nyePiiX829VnvnHT02RzZdhR/bi6iH9/7AwZuo
         h9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRkcyoT84nrcNfWbOC6Wu/HIKRFlU4vvaFal17BgFYc=;
        b=YfC3qh/KcYc4uvGCSGM4F5QRLER4o6WlLKzpXBmVmBww73XG4Y/Z0yXVhrHhVrytS4
         5A8s6CjlDfyUSC4g54rtZ+KcwMxXVAkhMmIk6WFylTBVzXkmdmLG+e0JJsQ+P9Az4jAq
         qUmzPxBPK5BkxouHdtyAd5aD0tqHdkpH5EOFAIcYwc6Yt2gY0QnNOldXOA/92L+vgA7Z
         XSxdfY1IevQJ7+DdO0LfJ7LwfRjK5BzXChlLzyoT4OIPc7ui+4ocHV+RYw93jDVdVwjJ
         7HixWMSwxZfVobDd57MFEruuZOrmRwA88MPsdhGvnb8DOeB0KvyQ2oaLi7/xPp/m+mrU
         JDBA==
X-Gm-Message-State: AOAM533l1YrdkzF+chZqRaZVURvH7E81PbHfyw43VFNnDuqz0j4oO9dJ
        8hKvDJzMxLfWkgyBORz9AZ6nS9aNbOfeWUpbVTqx93Xi
X-Google-Smtp-Source: ABdhPJxtwunEfyuvGdXe9ugivhglFaDVQ1lQUe4nMHeNRlky1X5Iq5Q5/LSclnDSJ3gTYUS9DpBnBuqqO2H69FdNMjo=
X-Received: by 2002:a05:6638:2a7:: with SMTP id d7mr2284994jaq.93.1642788926386;
 Fri, 21 Jan 2022 10:15:26 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com>
In-Reply-To: <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 10:15:15 -0800
Message-ID: <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 5:44 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > This patch series is a refinement of the RFC patchset [1], focusing
> > on support for attach by name for uprobes and uretprobes.  Still
> > marked RFC as there are unresolved questions.
> >
> > Currently attach for such probes is done by determining the offset
> > manually, so the aim is to try and mimic the simplicity of kprobe
> > attach, making use of uprobe opts to specify a name string.
> >
> > uprobe attach is done by specifying a binary path, a pid (where
> > 0 means "this process" and -1 means "all processes") and an
> > offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> > and that name is searched for in symbol tables.  If the binary
> > is a program, relative offset calcuation must be done to the
> > symbol address as described in [2].
>
> I think the pid discussion here and in the patches only causes
> confusion. I think it's best to remove pid from the api.

It's already part of the uprobe API in libbpf
(bpf_program__attach_uprobe), but nothing really changes there.
API-wise Alan just added an optional func_name option. I think it
makes sense overall.

For auto-attach it has to be all PIDs, of course.

> uprobes are attached to an inode. They're not attached to a pid
> or a process. Any existing process or future process started
> from that inode (executable file) will have that uprobe triggering.
> The kernel can do pid filtering through predicate mechanism,
> but bpf uprobe doesn't do any filtering. iirc.
> Similarly "attach to all processes" doesn't sound right either.
> It's attached to all current and future processes.
