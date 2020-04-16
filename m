Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63091ACE56
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392863AbgDPREU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732667AbgDPRES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 13:04:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FA4C061A0C;
        Thu, 16 Apr 2020 10:04:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b72so1916429pfb.11;
        Thu, 16 Apr 2020 10:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MnHUG3sYN0XjABSI1C/gKnaSqQCEr+itBkFar5vTREM=;
        b=KHG9x1plXo5za5TBKhCIdcSCRblbc2amDqQlGjFpgwGdPmpTfByliaBCh7kUYkUjh7
         1z/kLSSG6u4DUaIJCfobCNw6S8xhm3H8hHhm7vgpPYVH2Dt7KmMVvBNS7r3NW6GlX7f3
         P8PuIAdX22av1TOwzD5vEbG4i5OK/OH9B4DNHzHXEClwe8rtrO/jo/p9FjYY42GWHBEM
         y/tDs0tIKhmHDpEm+xQoEniLJYhbOL7LuRnrjZTGpQ3C3g9C4ul4SNxVTLIquCaIirnO
         30KZnGutRMvH/F5xJYOFy6xLCACvo9pSYiGbgzvXAhRZi0izAYJMCHKVzZETOu0MBaMd
         6yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=MnHUG3sYN0XjABSI1C/gKnaSqQCEr+itBkFar5vTREM=;
        b=WeaA0boJyJ3SXYkKteBNq/76kri9ODtHy/h9P+7I0rwf+lx4FgxlNSfUhWiYnd/Yiw
         yVIIXmLZhavKOQ4Gt/l6Z3L3UtZnM5CFBV8nlUMyjOeVnRjJhUG8GTBhj/3rj+c9zXGf
         fbhRa62K4Z1ab9KZ7S3lTfsw7I07vb6+rCX4DKsCDmSbgFLu9tZe4hJ65jo5uXvwqAxE
         WT/g8NUUFg/962/y/87BkdotJmvaMLargzh7BbnndRVOMAPG5JUmvBDpjJ8N6myRhKVp
         rVVo0VItX1yMi+8qutbKwLcSMKWtPyM4Wdd7cIzH9M0rIfcu5d9l2ppVHhK9uCUUkTeH
         fKTQ==
X-Gm-Message-State: AGi0PuYTajrU9e7T79msoNikhcSw8QMpp3peeyZ0nNfwasflv99l0WWR
        XMcWimqO884ahMUE0vGpR5g=
X-Google-Smtp-Source: APiQypJKlcEPMn7hQdOP5iQTSe/hoYhvvdz+v9yyzFM5bot6WifLs0XUPi2As2wMvcrUGESl/t7VoQ==
X-Received: by 2002:a63:1846:: with SMTP id 6mr24795096pgy.394.1587056658255;
        Thu, 16 Apr 2020 10:04:18 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4aab])
        by smtp.gmail.com with ESMTPSA id 128sm6157732pfx.187.2020.04.16.10.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 10:04:17 -0700 (PDT)
Date:   Thu, 16 Apr 2020 10:04:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200416170414.ds3hcb3bgfetjt4v@ast-mbp>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
 <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp>
 <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 06:48:13PM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 15, 2020 at 9:46 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 14, 2020 at 09:45:08PM -0700, Andrii Nakryiko wrote:
> > > >
> > > > > FD is closed, dumper program is detached and dumper is destroyed
> > > > > (unless pinned in bpffs, just like with any other bpf_link.
> > > > > 3. At this point bpf_dumper_link can be treated like a factory of
> > > > > seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
> > > > > illustration purposes) command, that accepts dumper link FD and
> > > > > returns a new seq_file FD, which can be read() normally (or, e.g.,
> > > > > cat'ed from shell).
> > > >
> > > > In this case, link_query may not be accurate if a bpf_dumper_link
> > > > is created but no corresponding bpf_dumper_open_file. What we really
> > > > need to iterate through all dumper seq_file FDs.
> > >
> > > If the goal is to iterate all the open seq_files (i.e., bpfdump active
> > > sessions), then bpf_link is clearly not the right approach. But I
> > > thought we are talking about iterating all the bpfdump programs
> > > attachments, not **sessions**, in which case bpf_link is exactly the
> > > right approach.
> >
> > That's an important point. What is the pinned /sys/kernel/bpfdump/tasks/foo ?
> 
> Assuming it's not a rhetorical question, foo is a pinned bpf_dumper
> link (in my interpretation of all this).

It wasn't rhetorical question and your answer is differrent from mine :)
It's not a link. It's a template of seq_file. It's the same as
$ stat /proc/net/ipv6_route
  File: ‘/proc/net/ipv6_route’
  Size: 0         	Blocks: 0          IO Block: 1024   regular empty file

> > Every time 'cat' opens it a new seq_file is created with new FD, right ?
> 
> yes
> 
> > Reading of that file can take infinite amount of time, since 'cat' can be
> > paused in the middle.
> 
> yep, correct (though most use case probably going to be very short-lived)
> 
> > I think we're dealing with several different kinds of objects here.
> > 1. "template" of seq_file that is seen with 'ls' in /sys/kernel/bpfdump/
> 
> Let's clarify here again, because this can be interpreted differently.
> 
> Are you talking about, e.g., /sys/fs/bpfdump/task directory that
> defines what class of items should be iterated? Or you are talking
> about named dumper: /sys/fs/bpfdump/task/my_dumper?

the latter.

> 
> If the former, I agree that it's not a link. If the latter, then
> that's what we've been so far calling "a named bpfdumper". Which is
> what I argue is a link, pinned in bpfdumpfs (*not bpffs*).

It cannot be a link, since link is only a connection between
kernel object and bpf prog.
Whereas seq_file is such kernel object.

> 
> For named dumper:
> 1. load bpfdump prog
> 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> bpf_link anon FD back
> 3. pin link in bpfdumpfs (e.g., /sys/fs/bpfdump/task/my_dumper)
> 4. each open() of /sys/fs/bpfdump/task/my_dumper produces new
> bpfdumper session/seq_file
> 
> For anon dumper:
> 1. load bpfdump prog
> 2. attach prog to bpfdump "provider" (/sys/fs/bpfdump/task), get
> bpf_link anon FD back
> 3. give bpf_link FD to some new API (say, BPF_DUMP_NEW_SESSION or
> whatever name) to create seq_file/bpfdumper session, which will create
> FD that can be read(). One can do that many times, each time getting
> its own bpfdumper session.

I slept on it and still fundamentally disagree that seq_file + bpf_prog
is a derivative of link. Or in OoO terms it's not a child class of bpf_link.
seq_file is its own class that should contain bpf_link as one of its
members, but it shouldn't be derived from 'class bpf_link'.

In that sense Yonghong proposed api (raw_tp_open to create anon seq_file+prog
and obj_pin to create a template of named seq_file+prog) are the best fit.
Implementation wise his 'struct extra_priv_data' needs to include
'struct bpf_link' instead of 'struct bpf_prog *prog;' directly.

So evertime 'cat' opens named seq_file there is bpf_link registered in IDR.
Anon seq_file should have another bpf_link as well.

My earlier suggestion to disallow get_fd_from_id for such links is wrong.
It's fine to get an FD to such link, but it shouldn't prevent destruction
of seq_file. 'cat' will close named seq_file and 'struct extra_priv_data' class
should do link_put. If some other process did get_fd_from_id then such link will
become dangling. Just like removal of netdev will make dangling xdp links.
