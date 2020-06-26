Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACDC20BA55
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFZUb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:31:26 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6078CC03E979;
        Fri, 26 Jun 2020 13:31:26 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id k18so9996637qke.4;
        Fri, 26 Jun 2020 13:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eof9kMs8jL4m6B3bkkxpZJKoV0jcxriCOuihfNwFNd4=;
        b=lKs7Yj5TTaUb/bnWA/wULWR+8YSUEeOQr5UrhO/xgYSsHqOX0nYxHPz6keCoVia5/h
         WNNx4YCxtG8VyZjeCNB7pId/tCAiWkO86GHIQeD9T+1Pv5ePa+PSDtquYQBgoRFk1foS
         aMIHmzyPbdcls1Qwlo1FvimEwM8T98X7q3WWri0SW8LgtiFFf0YVlfnJre02MPjiUyT4
         7wW8kHPpcRUtD+rkhaY9Pr9z6OsXRFcJmsJ5xGJgyHUkKVkU3qLGGjO2EtvPABgNTmlE
         OXyn/WSGyFTIwvzCNhMXPQYb2FA43uscMt5AVrai00Zp7kClKdBH8t8RzHRXqTPIwVUO
         l0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eof9kMs8jL4m6B3bkkxpZJKoV0jcxriCOuihfNwFNd4=;
        b=osmjgoWSDiggL091NY9jDY6h80D7sBcg5dGp3LLBVJ72OftsFxSsFtXFE7mjALXql/
         HVmMlJiQKptaeWwmx4vTC2gKn52OOVpgM8ZjLWApSggWq27LWL7rDQWpVeTs0RnwukUK
         QoxAI6HQqr/9RKZCBeLQw8fs1OJzer0/Ee+iTXHQb1yfEYLsGv5WjJfiePOI9MnrNOyC
         d/CjK8ok6vzasKit4drVsgt+h8VFCvsHEq1aDDjouZyVJRsvfIZT1XbA43gh3TSHDoU8
         F2wsHKP5Yzrj6Pu1JUbIaBzJSCamiSpbwBquXHH5uonROOhfo/W2gz5DzfTFw/S7T32x
         n+gw==
X-Gm-Message-State: AOAM531U0A8NJ6X/QmP+p8HusQr1cp04AC0attEvkmZbiM0S1Ql/DrOG
        r38FpwiUSyDv29Zu0EXicXJ6XfVQEvZIPcHjvqI=
X-Google-Smtp-Source: ABdhPJwSTUcuWAacrwFuB4AP+cYQGpDPOywV5LAg6WsL/QbIqPW/Ilu7CZqPntflaUh+6RVoU4/GJ2ed48uCMj4/nCg=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr4668453qkl.437.1593203485628;
 Fri, 26 Jun 2020 13:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com>
In-Reply-To: <20200626081720.5546-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:31:14 -0700
Message-ID: <CAEf4Bzamp+H7ea28JhaCV2O+c=0nA8Dv1Cs4-4XiX1jOKuSztg@mail.gmail.com>
Subject: Re: [PATCH 1/3] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, BPF programs with kprobe/sys_connect does not work properly.
>
> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> This commit modifies the bpf_load behavior of kprobe events in the x64
> architecture. If the current kprobe event target starts with "sys_*",
> add the prefix "__x64_" to the front of the event.
>
> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> solution to most of the problems caused by the commit below.
>
>     commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
>     pt_regs-based sys_*() to __x64_sys_*()")
>
> However, there is a problem with the sys_connect kprobe event that does
> not work properly. For __sys_connect event, parameters can be fetched
> normally, but for __x64_sys_connect, parameters cannot be fetched.
>
> Because of this problem, this commit fixes the sys_connect event by
> specifying the __sys_connect directly and this will bypass the
> "__x64_" appending rule of bpf_load.
>
> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/map_perf_test_kern.c         | 2 +-
>  samples/bpf/test_map_in_map_kern.c       | 2 +-
>  samples/bpf/test_probe_write_user_kern.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>

[...]
