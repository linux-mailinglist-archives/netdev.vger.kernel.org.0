Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098184A923E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356624AbiBDCM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiBDCMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:12:23 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3797C061714;
        Thu,  3 Feb 2022 18:12:22 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so4848864pjb.1;
        Thu, 03 Feb 2022 18:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fLtyLI7w0F+067AJk95vN7vO4SSzI3DgtmjUEdow9Ec=;
        b=ScABi76HI6EMk7snBw0N2+/wJ8lYQ7I6QNhJIWai/xL2NzV0UyEkrjbvLi5w751+jW
         jJ1mbGqupyK7aDO+AwR1pkk7kjdkCl3tvsDedwBGzSlS+3Mu6w2LwymVuBr4k7JonOC9
         Z1Vk/iOeVR9KHPvRMiLXi3nmdVkGvHEvJQvKHvrtr632FnDrot56fLOXQCThWWeF9QUC
         82Y6iNuhxKDbnWQFDQLVMmMyVq9/UfDPU2ADjo2sFB9wdyIS7gX4ezav2RjpRZODGAAC
         djwo3Fb24wkkkiTT0/lb33N1CqRE/N5tFNSL5OhV+sCRXonCiIMhHhrT1AlENdVHglTy
         OZsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fLtyLI7w0F+067AJk95vN7vO4SSzI3DgtmjUEdow9Ec=;
        b=AaOECB0+VK4PRqRLyBg912npVNVwt27IkFXFeE8TIqnsOiRVSzPvRvHV0L7RyBkrwR
         00G9dpOcbVj6Pw5d391+6gLWpPTb2/EUysyO06UBMxbLVD6mqkzqlTw50B9BNIkYtcva
         iYQRVkGHVC6ADXHRqWWhg5Z4yE/Mh/gFTu9DKSi+4giVZ714XF6qnoHPSpS1ENCbIocy
         alNoLf4eGbz6SEPvl5XypfpN2ULdgCrtgxbtnlL8kvVlIGbeooCq6qAchiuWeZVpap+C
         sTe648EkuCTzqf6oSdflvp4b0RhYjJItBiAIVBN7s7Xa1rkBIVFDatXkezs06UPWnfYS
         O4Mw==
X-Gm-Message-State: AOAM532pxPwbboLZfClj16ZiokvKlyzR82LIV8JkEGlYwxg1vd73RS6i
        NOUvpvSOOZfkpUA9v5j8vBVNK1bgi5Z/obd9/JQ=
X-Google-Smtp-Source: ABdhPJwmRuvJNX/PK/nXbx+2/aqxqYEMjgDMYy8l39eeDFeH8eT4Ec2POz2xu/+sCJvnkrgSbxynYOH46yDuYuUFQBY=
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr801290pls.126.1643940742341;
 Thu, 03 Feb 2022 18:12:22 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
 <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com> <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
In-Reply-To: <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 18:12:11 -0800
Message-ID: <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 6:07 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Thu, 3 Feb 2022 17:34:54 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Thu, Feb 3, 2022 at 4:46 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > I thought What Alexei pointed was that don't expose the FPROBE name
> > > to user space. If so, I agree with that. We can continue to use
> > > KPROBE for user space. Using fprobe is just for kernel implementation.
> >
> > Clearly that intent is not working.
>
> Thanks for confirmation :-)
>
> > The "fprobe" name is already leaking outside of the kernel internals.
> > The module interface is being proposed.
>
> Yes, but that is only for making the example module.
> It is easy for me to enclose it inside kernel. I'm preparing KUnit
> selftest code for next version. After integrated that, we don't need
> that example module anymore.
>
> > You'd need to document it, etc.
>
> Yes, I've added a document of the APIs for the series.  :-)
>
> > I think it's only causing confusion to users.
> > The new name serves no additional purpose other than
> > being new and unheard of.
> > fprobe is kprobe on ftrace. That's it.
>
> No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> transparently.

Not true.
fprobe is nothing but _explicit_ kprobe on ftrace.
There was an implicit optimization for kprobe when ftrace
could be used.
All this new interface is doing is making it explicit.
So a new name is not warranted here.

> from that viewpoint, fprobe and kprobe interface are similar but different.

What is the difference?
I don't see it.
