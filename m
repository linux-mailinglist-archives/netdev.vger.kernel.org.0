Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255B077205
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbfGZTS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:18:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39966 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388525AbfGZTS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:18:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so25217699pgj.7
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aaLCO9rquW8zOfKrWz3ON/6AgObn6JUEqFdlb0biVXs=;
        b=t7xuzeqrfaBvKuIzgMGqiBiJ+bNKXpm0hav9D4RB0YlIt0j3Ja5TcPtOdARR8OOKXv
         R8skIXSww2dlvw1KwWGssW8pAcTrO0mxapnzlplUyC+8320bpsICCvBR4p/oYgIW/hxO
         TWmLmhivSt+2Q5v6AU6uj2TpMtH6HN72fyR+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aaLCO9rquW8zOfKrWz3ON/6AgObn6JUEqFdlb0biVXs=;
        b=HUJf6QABcMCaSWqG4FEJovmo6yOpbp08cwIc6c3n6uKufH1/aLRGTSZhLigxXJRWnV
         kMBcry3/FzpRr5q/FFhN7u+4bfrxfKmXHEMl4IAzxWkyqbFmQG7vw6Zf1dcBAdG3jxU4
         rQx3QdDMkWEOnAiiEJJu0gF5CVPTIt1D1QjFXos2N+OzyiEEq/H1l9x+iC+ypAlooM/C
         rSjSjPNcDuOXHHWl7nTNO1sLgqw0Hr53jwfr3nnkBqgTmhX4SgZOgynhq7izzzjAeZTL
         M1bOo7plByBUKjiocOSQQMrMZfFAuK4luzqkxNXSO0629/e4Acy5iQKmoP5OuYIQbzWJ
         N3fA==
X-Gm-Message-State: APjAAAXpkSwDPFaf1FRjl7yPKHbbmOrK42BM3DSdEhwYh5uukZKKix2u
        2NMegIw/jhf+IvXO5HoDzHk=
X-Google-Smtp-Source: APXvYqzchn27cAzocnBFE1KDl/j92iJMV04GePHVAx4gM5q3wTu5qdEQzK08hGWd1BxpCIg6dSLdxQ==
X-Received: by 2002:a65:5b8e:: with SMTP id i14mr91573307pgr.188.1564168736216;
        Fri, 26 Jul 2019 12:18:56 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id j12sm45814793pff.4.2019.07.26.12.18.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 12:18:55 -0700 (PDT)
Date:   Fri, 26 Jul 2019 15:18:53 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, kernel-team@android.com
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190726191853.GA196514@google.com>
References: <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
 <20190717130119.GA138030@google.com>
 <CAADnVQJY_=yeY0C3k1ZKpRFu5oNbB4zhQf5tQnLr=Mi8i6cgeQ@mail.gmail.com>
 <20190718025143.GB153617@google.com>
 <20190723221108.gamojemj5lorol7k@ast-mbp>
 <20190724135714.GA9945@google.com>
 <20190726183954.oxzhkrwt4uhgl4gl@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726183954.oxzhkrwt4uhgl4gl@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 11:39:56AM -0700, Alexei Starovoitov wrote:
[snip]
> > > > 1. timeinstate: By hooking 2 programs onto sched_switch and cpu_frequency
> > > > tracepoints, we are able to collect CPU power per-UID (specific app). Connor
> > > > O'Brien is working on that.
> > > > 
> > > > 2. inode to file path mapping: By hooking onto VFS tracepoints we are adding to
> > > > the android kernels, we can collect data when the kernel resolves a file path
> > > > to a inode/device number. A BPF map stores the inode/dev number (key) and the
> > > > path (value). We have usecases where we need a high speed lookup of this
> > > > without having to scan all the files in the filesystem.
> > > 
> > > Can you share the link to vfs tracepoints you're adding?
> > > Sounds like you're not going to attempt to upstream them knowing
> > > Al's stance towards them?
> > > May be there is a way we can do the feature you need, but w/o tracepoints?
> > 
> > Yes, given Al's stance I understand the patch is not upstreamable. The patch
> > is here:
> > For tracepoint:
> > https://android.googlesource.com/kernel/common/+/27d3bfe20558d279041af403a887e7bdbdcc6f24%5E%21/
> 
> this is way more than tracepoint.

True there is some code that calls the tracepoint. I want to optimize it more
but lets see I am ready to think more about it before doing it this way,
based on your suggestions.

> > For bpf program:
> > https://android.googlesource.com/platform/system/bpfprogs/+/908f6cd718fab0de7a944f84628c56f292efeb17%5E%21/
> 
> what is unsafe_bpf_map_update_elem() in there?
> The verifier comment sounds odd.
> Could you describe the issue you see with the verifier?

Will dig out the verifier issue I was seeing. I was just trying to get a
prototype working so I did not go into verifier details much.

> > I intended to submit the tracepoint only for the Android kernels, however if
> > there is an upstream solution to this then that's even better since upstream can
> > benefit. Were you thinking of a BPF helper function to get this data?
> 
> I think the best way to evaluate the patches is whether they are upstreamable or not.
> If they're not (like this case), it means that there is something wrong with their design
> and if android decides to go with such approach it will only create serious issues long term.
> Starting with the whole idea of dev+inode -> filepath cache.
> dev+inode is not a unique identifier of the file.
> In some filesystems two different files may have the same ino integer value.
> Have you looked at 'struct file_handle' ? and name_to_handle_at ?
> I think fhandle is the only way to get unique identifier of the file.
> Could you please share more details why android needs this cache of dev+ino->path?

I will follow-up with you on this by email off the list, thanks.

thanks,

 - Joel

