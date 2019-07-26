Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2B97715B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbfGZSkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 14:40:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40876 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387434AbfGZSkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 14:40:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so24905194pfp.7;
        Fri, 26 Jul 2019 11:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bY4xnD9VEBuMVQmfTHfPZt8vwC6Vj5uTPYAbzW3F/j4=;
        b=r2LYzePY0p1lz7qwyh9m7J8u6+UVqedhCQ7BKobVOg1zauDSAKbok5ceFZRuNp2VFf
         lX/4BDr8lMTXFrfSeA0Op5MpsCZYnTg97r/E85vHuBuuKbkvll4YhTyjAU5YtmA0YfYi
         3KN/k8jdDTyKs4BWRUh+VTETT++7zIU/khvMxnp8IjNmpTSFZDwCi7cQAqeyCTdCiegT
         f4oor9KFs6N9V0FWfGlOcVzy0OlGKexfdAmTY8oCDgKlKh+cvcZFhvCJj6/CUG9BLPLb
         nW6VTyq9P/MBwWVndBBdFnXhACkGNtbgaoLicUBHDJrL9AjJjHbTdq0du8q5IIgzqVUa
         MJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bY4xnD9VEBuMVQmfTHfPZt8vwC6Vj5uTPYAbzW3F/j4=;
        b=sVIkUmNTzPdwwd6L/YGQm/fmdc3DV9vaWQx44tOISw352lMJVwHkd0igkwXBoeKbHq
         DgtUCz20X6il+u1yChY5Bexfvhydtc+CPN8ee9TeO/aZlhBd0wmPPcVkSz1f71g/AQno
         WYco9rpsUxBIhSjVXIL2ZHhLjSwUbjRKYYxzKoLXdSamBgcG+107XtIJbRyWKWhYantv
         teBddUPH/j9czeo+d6hC4wuv3oBpDZPkmC88zabQ4gvYkf4q6aRWoqk2f8IiRPPAB/Jf
         3MGrU3n6jhbYahr1Ka0sZKCES1gWMRIzD36Fks0rSqImu/oz4H88WSQPv9LstQ/Gn+Yv
         0cQw==
X-Gm-Message-State: APjAAAVEcb98W1HGpjlRTH6KtsRysmnN6D0xL7kWwjonzs0BYGm6j0Hl
        ZqVJr4h+Mb6lxSvPvww7Z0c=
X-Google-Smtp-Source: APXvYqwAa7f6KrCivJT9i9iP+Ljnbnzh9F83yxbeML6KsVRnVjPFn3zX0egbZMn28CCYbk40FWxZ9w==
X-Received: by 2002:a62:1b0c:: with SMTP id b12mr23337721pfb.17.1564166400088;
        Fri, 26 Jul 2019 11:40:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2eeb])
        by smtp.gmail.com with ESMTPSA id u7sm47886990pgr.94.2019.07.26.11.39.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 11:39:59 -0700 (PDT)
Date:   Fri, 26 Jul 2019 11:39:56 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, kernel-team@android.com
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190726183954.oxzhkrwt4uhgl4gl@ast-mbp.dhcp.thefacebook.com>
References: <20190716213050.GA161922@google.com>
 <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
 <20190717130119.GA138030@google.com>
 <CAADnVQJY_=yeY0C3k1ZKpRFu5oNbB4zhQf5tQnLr=Mi8i6cgeQ@mail.gmail.com>
 <20190718025143.GB153617@google.com>
 <20190723221108.gamojemj5lorol7k@ast-mbp>
 <20190724135714.GA9945@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724135714.GA9945@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 09:57:14AM -0400, Joel Fernandes wrote:
> On Tue, Jul 23, 2019 at 03:11:10PM -0700, Alexei Starovoitov wrote:
> > > > > > I think allowing one tracepoint and disallowing another is pointless
> > > > > > from security point of view. Tracing bpf program can do bpf_probe_read
> > > > > > of anything.
> > > > >
> > > > > I think the assumption here is the user controls the program instructions at
> > > > > runtime, but that's not the case. The BPF program we are loading is not
> > > > > dynamically generated, it is built at build time and it is loaded from a
> > > > > secure verified partition, so even though it can do bpf_probe_read, it is
> > > > > still not something that the user can change.
> > > > 
> > > > so you're saying that by having a set of signed bpf programs which
> > > > instructions are known to be non-malicious and allowed set of tracepoints
> > > > to attach via selinux whitelist, such setup will be safe?
> > > > Have you considered how mix and match will behave?
> > > 
> > > Do you mean the effect of mixing tracepoints and programs? I have not
> > > considered this. I am Ok with further enforcing of this (only certain
> > > tracepoints can be attached to certain programs) if needed. What do
> > > you think? We could have a new bpf(2) syscall attribute specify which
> > > tracepoint is expected, or similar.
> > > 
> > > I wanted to walk you through our 2 usecases we are working on:
> > 
> > thanks for sharing the use case details. Appreciate it.
> 
> No problem and thanks for your thoughts.
> 
> > > 1. timeinstate: By hooking 2 programs onto sched_switch and cpu_frequency
> > > tracepoints, we are able to collect CPU power per-UID (specific app). Connor
> > > O'Brien is working on that.
> > > 
> > > 2. inode to file path mapping: By hooking onto VFS tracepoints we are adding to
> > > the android kernels, we can collect data when the kernel resolves a file path
> > > to a inode/device number. A BPF map stores the inode/dev number (key) and the
> > > path (value). We have usecases where we need a high speed lookup of this
> > > without having to scan all the files in the filesystem.
> > 
> > Can you share the link to vfs tracepoints you're adding?
> > Sounds like you're not going to attempt to upstream them knowing
> > Al's stance towards them?
> > May be there is a way we can do the feature you need, but w/o tracepoints?
> 
> Yes, given Al's stance I understand the patch is not upstreamable. The patch
> is here:
> For tracepoint:
> https://android.googlesource.com/kernel/common/+/27d3bfe20558d279041af403a887e7bdbdcc6f24%5E%21/

this is way more than tracepoint.

> For bpf program:
> https://android.googlesource.com/platform/system/bpfprogs/+/908f6cd718fab0de7a944f84628c56f292efeb17%5E%21/

what is unsafe_bpf_map_update_elem() in there?
The verifier comment sounds odd.
Could you describe the issue you see with the verifier?

> I intended to submit the tracepoint only for the Android kernels, however if
> there is an upstream solution to this then that's even better since upstream can
> benefit. Were you thinking of a BPF helper function to get this data?

I think the best way to evaluate the patches is whether they are upstreamable or not.
If they're not (like this case), it means that there is something wrong with their design
and if android decides to go with such approach it will only create serious issues long term.
Starting with the whole idea of dev+inode -> filepath cache.
dev+inode is not a unique identifier of the file.
In some filesystems two different files may have the same ino integer value.
Have you looked at 'struct file_handle' ? and name_to_handle_at ?
I think fhandle is the only way to get unique identifier of the file.
Could you please share more details why android needs this cache of dev+ino->path?
I guess something uses ino to find paths?
Sort of faster version of 'find -inum' ?

