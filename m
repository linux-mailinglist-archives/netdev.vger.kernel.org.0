Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A560245E9D5
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359752AbhKZJGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:06:37 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:43190
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376257AbhKZJEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:04:36 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 31EC33F225
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637917281;
        bh=JSDkQxEaFeO4Aa8CU5V1RSZd3JdJHwQwA3XYeu58L54=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=D8idFLkyy6NiQjr57fzJYJK7QbMdIc3v5nW0Z33wcLVK+IOhVb3bPJUa6CZYxKT2G
         dc8gBah51WcYSHYB/r7fZAMqTkfrAxyzNucz9kSTcyHfP/S0UpmrUT/E4fF/m4lMXE
         XWEkPRIHNBkboEBLEF2rblSWDHSCqBcR4A/RJtXB30ZDca0SKq1OL0il16H+XGLmgt
         TllzPyDmZFq7BaxjV846RZGuXdL3F+nYZ67nNl4SHyuiOuYh7mb/LrFMoOGGBw0Ss1
         OtTssg4wPWKAjwY1itKglwKNWOTJImIQdHc3CiJ3+1zXqB1IlbK6JfscXhaaAaYMh+
         9B5EaGEBldipQ==
Received: by mail-ed1-f72.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so7460000edo.5
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 01:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JSDkQxEaFeO4Aa8CU5V1RSZd3JdJHwQwA3XYeu58L54=;
        b=i8d6NX6F0ioSvHJO+KwZxkGPS2AxRcSKBUpAdanzY4Nu7k+d7+3Bypzoy4q6aCRbrB
         jMrt+GuS71+JHf+oh4FFt2rTXZCFspYWyL5s8uL5sseEAgD/X1FrU3IfKvCW2uTGgb+d
         0bgXH/HvL6Y4oYtC8lo7pqFZOjifccyFeU2YROeT+dfpMoqHOd82gYnOpeispzm85r7u
         CZCCgQ/lDQsGwoKe8gip20cVKafbhiFjETK/hvZ41VG3NMNubd5EObWMcyuN5RIdsYGv
         pCH4JsM79uUHfGo6UoU/vD0tsSyKcHt2fZxp5Fv/3kj3II5AI0Rf003UNNckZzN4Couw
         QZww==
X-Gm-Message-State: AOAM531sjqleXVhmELlg2yZz3fdKrugjGgTyel6H4PALrA4oLOfal7LC
        XtIW2igALharnh12uSOydolHn+YM6+oz1sXDAiFOzI2c99tU07HkWmCsflJPlbo/eainzeYxwtJ
        zulwygG72hKFY+XhqZMalyeyWDZCgrYz4DQ==
X-Received: by 2002:a05:6402:11d2:: with SMTP id j18mr45510565edw.318.1637917280837;
        Fri, 26 Nov 2021 01:01:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxA/gPOhfwr63nIN4QqNwMF4BDsoXBkVZzPKhinuy/tb4GYEkRp4MHzCZGHTX+pLz5/8jbGgQ==
X-Received: by 2002:a05:6402:11d2:: with SMTP id j18mr45510536edw.318.1637917280547;
        Fri, 26 Nov 2021 01:01:20 -0800 (PST)
Received: from localhost ([2001:67c:1560:8007::aac:c1b6])
        by smtp.gmail.com with ESMTPSA id e4sm3026588ejs.13.2021.11.26.01.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 01:01:19 -0800 (PST)
Date:   Fri, 26 Nov 2021 10:01:19 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/seccomp: fix check of fds being assigned
Message-ID: <YaCiX+ypndYf/0QP@arighi-desktop>
References: <20211115165227.101124-1-andrea.righi@canonical.com>
 <202111180933.BE5101720@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202111180933.BE5101720@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 09:37:03AM -0800, Kees Cook wrote:
> On Mon, Nov 15, 2021 at 05:52:27PM +0100, Andrea Righi wrote:
> > There might be an arbitrary free open fd slot when we run the addfd
> > sub-test, so checking for progressive numbers of file descriptors
> > starting from memfd is not always a reliable check and we could get the
> > following failure:
> > 
> >   #  RUN           global.user_notification_addfd ...
> >   # seccomp_bpf.c:3989:user_notification_addfd:Expected listener (18) == nextfd++ (9)
> 
> What injected 9 extra fds into this test?
> 

We run the kselftest inside a framework (bash/python scripts basically)
and this is what I see (I added a simple `ls -l /proc/pid/fd` in
seccomp_bpf.c after memfd is created):

11/26 08:50:08 DEBUG|     utils:0153| [stdout] # #  RUN           global.user_notification_addfd ...
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # total 0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 0 -> /dev/pts/0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 1 -> pipe:[28844]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 10 -> /dev/pts/0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 11 -> /dev/pts/0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 12 -> /home/ubuntu/autotest/client/results/default/ubuntu_kernel_selftests.seccomp:seccomp_bpf/debug/ubuntu_kernel_selftests.seccomp:seccomp_bpf.DEBUG
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 13 -> /home/ubuntu/autotest/client/results/default/ubuntu_kernel_selftests.seccomp:seccomp_bpf/debug/ubuntu_kernel_selftests.seccomp:seccomp_bpf.INFO
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 14 -> /home/ubuntu/autotest/client/results/default/ubuntu_kernel_selftests.seccomp:seccomp_bpf/debug/ubuntu_kernel_selftests.seccomp:seccomp_bpf.WARNING
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 15 -> /home/ubuntu/autotest/client/results/default/ubuntu_kernel_selftests.seccomp:seccomp_bpf/debug/ubuntu_kernel_selftests.seccomp:seccomp_bpf.ERROR
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 16 -> pipe:[27608]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 17 -> pipe:[27609]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 2 -> pipe:[28844]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 3 -> pipe:[27803]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 4 -> pipe:[26387]
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 5 -> /home/ubuntu/autotest/client/results/default/debug/client.WARNING
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # l-wx------ 1 root root 64 Nov 26 08:50 6 -> /home/ubuntu/autotest/client/results/default/debug/client.ERROR
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 7 -> /dev/pts/0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 8 -> /memfd:test (deleted)
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # lrwx------ 1 root root 64 Nov 26 08:50 9 -> /dev/pts/0
11/26 08:50:08 DEBUG|     utils:0153| [stdout] # # seccomp_bpf.c:3993:user_notification_addfd:Expected listener (18) == nextfd++ (9)
11/26 08:50:09 DEBUG|     utils:0153| [stdout] # # user_notification_addfd: Test terminated by assertion
11/26 08:50:09 DEBUG|     utils:0153| [stdout] # #          FAIL  global.user_notification_addfd

As we can see memfd has been allocated in a hole (fd=8) and listener
will get fd=18, so checking for sequential fd numbers is not working in
this case.

> >   # user_notification_addfd: Test terminated by assertion
> > 
> > Simply check if memfd and listener are valid file descriptors and start
> > counting for progressive file checking with the listener fd.
> 
> Hm, so I attempted to fix this once already:
> 93e720d710df ("selftests/seccomp: More closely track fds being assigned")
> so I'm not sure the proposed patch really improves it in the general
> case.

I agree that my patch doesn't fix 100% of the cases, we may still have
fd holes.

> 
> > Fixes: 93e720d710df ("selftests/seccomp: More closely track fds being assigned")
> > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> > ---
> >  tools/testing/selftests/seccomp/seccomp_bpf.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > index d425688cf59c..4f37153378a1 100644
> > --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> > +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> > @@ -3975,18 +3975,17 @@ TEST(user_notification_addfd)
> >  	/* There may be arbitrary already-open fds at test start. */
> >  	memfd = memfd_create("test", 0);
> >  	ASSERT_GE(memfd, 0);
> > -	nextfd = memfd + 1;
> >  
> >  	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> >  	ASSERT_EQ(0, ret) {
> >  		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
> >  	}
> >  
> > -	/* fd: 4 */
> >  	/* Check that the basic notification machinery works */
> >  	listener = user_notif_syscall(__NR_getppid,
> >  				      SECCOMP_FILTER_FLAG_NEW_LISTENER);
> > -	ASSERT_EQ(listener, nextfd++);
> > +	ASSERT_GE(listener, 0);
> > +	nextfd = listener + 1;
> 
> e.g. if there was a hole in the fd map for memfd, why not listener too?
> 
> Should the test dup2 memfd up to fd 100 and start counting there or
> something? What is the condition that fills the fds for this process?

How about getting the allocated fd numbers from /proc/pid/fd and
figuring out the next fd number taking also the holes into account?

Thanks,
-Andrea
