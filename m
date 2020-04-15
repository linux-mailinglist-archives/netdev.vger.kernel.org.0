Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41CB1AAE9E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416222AbgDOQqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416219AbgDOQqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:46:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC45C061A0C;
        Wed, 15 Apr 2020 09:46:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u9so208642pfm.10;
        Wed, 15 Apr 2020 09:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xk2jighx9JiHvd7VvJooQA7iX7mzZawcFCLCxrDuv44=;
        b=iOIx9Yr6HSIN1+8RUMF12Vo54Qjfl4uc3xdPwBZmU+Sq/OfXOqB594qFHgaymCaJLL
         ct0cC3cw5bG9eBRV21II87z6FeNuPDJ8gLgBUPiD6e2JYxn8j/r6MfGPpv/+712NFaz7
         RProMzobaw8Qfa3rDLCbeAlwhUFcvfXGqWdxkym2jfdCcfgg659e0Na8JTqv+AsLJrfi
         ONwiApA2hUrjyremxTAegejbjBnv4TjlKLCXH1mmUPTmkcMNdbuhpnS4difi0esSRmKc
         BUBv1HOOkFGIehG5CZEdP8qFau6ErTf6wXw3dY6MjzbYXhphvsFX+ovsWQJrsO3pstGL
         uxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xk2jighx9JiHvd7VvJooQA7iX7mzZawcFCLCxrDuv44=;
        b=EIPyXT3Mbu9b0MypQuq/W4IHJw8/2E6w2JZelfHFlIC8zi+L0mUzf2tiXJSYbUdEvX
         l8iX3AWWNecnPpT+j5OCxAZJwymQOfu8wioCA8jUsAOckKGEAU+60KrReo72kb/UUr9s
         zz0vMFSFQMN/g7+Omc+6mSGPiaGLv+7X2t01a/nghIc/tib0JnsLLYxXhoNBtUZD4eEm
         AQU+c0ys1DDvjx5Zo3MKrbNIoz74UIy2ltWdIg3mpLVWEHEBwkpx/hsRf0J+2XsTXHTO
         1R+1UUYok/rNXBlXTE+TxZLppDPWnHJPXh63pR25JgLr9vNquDVbpjGwf8z7hn6xNvbT
         Vs5g==
X-Gm-Message-State: AGi0PubpjCwRNaHq7cCEQHA5aDMksX32S42FFFRqifvN2lLHEArBXG9B
        CXKYIgud/WBIR5gCx1BUKoHAg0Gx
X-Google-Smtp-Source: APiQypIAdnrhWplB2+SV4yaozEDj4kJBKfcRqbCgAcgNw43SON2Gzw7FvY7A+us9et1bSAm3jSnBwg==
X-Received: by 2002:a63:f658:: with SMTP id u24mr26784804pgj.357.1586969204758;
        Wed, 15 Apr 2020 09:46:44 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:40b6])
        by smtp.gmail.com with ESMTPSA id o9sm60244pje.47.2020.04.15.09.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 09:46:43 -0700 (PDT)
Date:   Wed, 15 Apr 2020 09:46:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200415164640.evaujoootr4n55sc@ast-mbp>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
 <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 09:45:08PM -0700, Andrii Nakryiko wrote:
> >
> > > FD is closed, dumper program is detached and dumper is destroyed
> > > (unless pinned in bpffs, just like with any other bpf_link.
> > > 3. At this point bpf_dumper_link can be treated like a factory of
> > > seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
> > > illustration purposes) command, that accepts dumper link FD and
> > > returns a new seq_file FD, which can be read() normally (or, e.g.,
> > > cat'ed from shell).
> >
> > In this case, link_query may not be accurate if a bpf_dumper_link
> > is created but no corresponding bpf_dumper_open_file. What we really
> > need to iterate through all dumper seq_file FDs.
> 
> If the goal is to iterate all the open seq_files (i.e., bpfdump active
> sessions), then bpf_link is clearly not the right approach. But I
> thought we are talking about iterating all the bpfdump programs
> attachments, not **sessions**, in which case bpf_link is exactly the
> right approach.

That's an important point. What is the pinned /sys/kernel/bpfdump/tasks/foo ?
Every time 'cat' opens it a new seq_file is created with new FD, right ?
Reading of that file can take infinite amount of time, since 'cat' can be
paused in the middle.
I think we're dealing with several different kinds of objects here.
1. "template" of seq_file that is seen with 'ls' in /sys/kernel/bpfdump/
2. given instance of seq_file after "template" was open
3. bpfdumper program
4. and now links. One bpf_link from seq_file template to bpf prog and
  many other bpf_links from actual seq_file kernel object to bpf prog.
  I think both kinds of links need to be iteratable via get_next_id.

At the same time I don't think 1 and 2 are links.
read-ing link FD should not trigger program execution. link is the connecting
abstraction. It shouldn't be used to trigger anything. It's static.
Otherwise read-ing cgroup-bpf link would need to trigger cgroup bpf prog too.
FD that points to actual seq_file is the one that should be triggering
iteration of kernel objects and corresponding execution of linked prog.
That FD can be anon_inode returned from raw_tp_open (or something else)
or FD from open("/sys/kernel/bpfdump/foo").

The more I think about all the objects involved the more it feels that the
whole process should consist of three steps (instead of two).
1. load bpfdump prog
2. create seq_file-template in /sys/kernel/bpfdump/
   (not sure which api should do that)
3. use bpf_link_create api to attach bpfdumper prog to that seq_file-template

Then when the file is opened a new bpf_link is created for that reading session.
At the same time both kinds of links (to teamplte and to seq_file) should be
iteratable for observability reasons, but get_fd_from_id on them should probably
be disallowed, since holding such FD to these special links by other process
has odd semantics.

Similarly for anon seq_file it should be three step process as well:
1. load bpfdump prog
2. create anon seq_file (api is tbd) that returns FD
3. use bpf_link_create to attach prog to seq_file FD

May be it's all overkill. These are just my thoughts so far.
