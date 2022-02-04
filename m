Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB94A9236
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356594AbiBDCHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356589AbiBDCHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:07:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5554C061714;
        Thu,  3 Feb 2022 18:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A707261A38;
        Fri,  4 Feb 2022 02:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D2CC340E8;
        Fri,  4 Feb 2022 02:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643940428;
        bh=8Rfsm2X26f+cpjyggcPus8upMsnUdue/pwlCemZkV8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DJBvgPeTEdCw9GQ0xjyvKlA7HR67qV6rchLqmK9Zq6MZhs40m577x1ONkMvfuto0F
         vGU1TuPpA9aM0whxuTTyYcQ50C0oY/DnRs6WCJJAtzFKJEijqVPZvaoZHdda+LE4sJ
         JNweqVJTu42yrLIb5TBspUedRcgGbYvFlOcEbrAdtZJ28YxmVtF1JWSrZFjToPfklj
         fH8skN+FMFHph0DnMqRybjryo1qldkssk8oM27/ZxksHWwSkZu1g8Cun1JvSKJ1D9v
         cSgfzF6fQoe+H8VqipVU9BvafmOVNYWEpkQz5HardNHRE87PbJdCJopZk9otSljkiy
         XQ758Gyogf4yg==
Date:   Fri, 4 Feb 2022 11:07:04 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-Id: <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
In-Reply-To: <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
References: <20220202135333.190761-1-jolsa@kernel.org>
        <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
        <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 17:34:54 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Feb 3, 2022 at 4:46 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > I thought What Alexei pointed was that don't expose the FPROBE name
> > to user space. If so, I agree with that. We can continue to use
> > KPROBE for user space. Using fprobe is just for kernel implementation.
> 
> Clearly that intent is not working.

Thanks for confirmation :-)

> The "fprobe" name is already leaking outside of the kernel internals.
> The module interface is being proposed.

Yes, but that is only for making the example module.
It is easy for me to enclose it inside kernel. I'm preparing KUnit
selftest code for next version. After integrated that, we don't need
that example module anymore.

> You'd need to document it, etc.

Yes, I've added a document of the APIs for the series.  :-)

> I think it's only causing confusion to users.
> The new name serves no additional purpose other than
> being new and unheard of.
> fprobe is kprobe on ftrace. That's it.

No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
transparently.

> Just call it kprobe on ftrace in api and everywhere.
> Please?

Hmm, no, I think that's the work for who provide user-interface, isn't it?.
Inside kernel, IMHO, the interface named from the programing viewpoint, and
from that viewpoint, fprobe and kprobe interface are similar but different.

I'm able to allow kprobe-event (of ftrace) to accept "func*" (yeah, that's
actually good idea), but ftrace interface will not export as fprobe. Even if
it internally uses fprobe, I don't call it fprobe. It's kprobes from the
viewpoint of ftrace user. (Yeah, I think it should be called as 
"dynamic-probe-event-for-kernel" but historically, it is called as kprobe-event.)

Thank you, 

-- 
Masami Hiramatsu <mhiramat@kernel.org>
