Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7551A04A1
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDGBpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:45:01 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:39383 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDGBpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:45:01 -0400
Received: by mail-qk1-f180.google.com with SMTP id b62so151116qkf.6;
        Mon, 06 Apr 2020 18:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NggrQUhazO137ux8faKO/YjQPeO/hVW++bf4nbV8Dug=;
        b=TWOB1bmgM65TTlDb+FICN4fsLq82Pd+fpyI6eOud08w1y7J4mKPxzyk+9ibTlnFNKV
         n7YbjixxHTISqIsr8Y+eMQUO1q6X92ernNn/iLMTRol84d6azAuMacLdU2GqzR1QvR2T
         bagWiwX1h3yeO4YiHFNKLxVhlgFJ8uX10r83VnvAO9IwmYQHAywPkUrOGK1N0ivhFGJk
         WWnlwWbk/Lt9/estG+VKidtdQK6u2FedlqFiy7X7KJf8y3EK2qtY/4C8ykVO4t0wMQwK
         NW5yGRSEBzl2YE9OBCyS/j1nA+Ajxeo1Nzs//nKE/nUCmKIKJVNz3bStlVhC+djGmWcW
         Svxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NggrQUhazO137ux8faKO/YjQPeO/hVW++bf4nbV8Dug=;
        b=pSMya9wjAKxi9W6cC8L4uhVQfbyf0pyYYGZUTB0GPSnG1rrh7mwtj2/Ncqyyo8LJAp
         9MJJxFr/A8bfRdjhVsM5mI8FbBWylRwvVt64wxUBR2IvVfR+/mFUhywrttWruTsnd7vJ
         SvfYXQd1ptv9Gi76L9/PVJ1Iwr8KwFYmBmhwZBktTDJcBgb4kYgJLoNrx+2IF1GCF0Rs
         uVcFnirB5evW/qEUgCaNrYsb2vMzUblWl2aGhn+rilJhtEOlyMCHyKvIyeohJp12POBK
         FJIGz5XTNm3wnp0WycXgbyyjESCh2BfhZB2Z+9Db+FCA664fc0koHL2ZNGQwdK/oNUV+
         0mwQ==
X-Gm-Message-State: AGi0PuZwgULpAH56AFiGr5ESGBmSYxqjLCr2o2XKhWucE7777NCezAJA
        Cc1dmVLfHoomyxEh7/rx3Nk=
X-Google-Smtp-Source: APiQypIzVJihzS4VXWcOxKweg3CURC91hAQrCk2m4O24YXSnhFTSTfXGAHehx+5DI7h/qCpOgqWPYg==
X-Received: by 2002:a37:a5d6:: with SMTP id o205mr12183158qke.7.1586223899622;
        Mon, 06 Apr 2020 18:44:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c091:480::84df])
        by smtp.gmail.com with ESMTPSA id e5sm50198qtp.83.2020.04.06.18.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:44:58 -0700 (PDT)
Date:   Mon, 6 Apr 2020 18:44:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200407014455.u7x36kkfmxcllqa6@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
 <87o8s9eg5b.fsf@toke.dk>
 <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
 <87ftdldkvl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ftdldkvl.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 10:38:38AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > It's a different link.
> > For fentry/fexit/freplace the link is pair:
> >   // target           ...         bpf_prog
> > (target_prog_fd_or_vmlinux, fentry_exit_replace_prog_fd).
> >
> > So for xdp case we will have:
> > root_link = (eth0_ifindex, dispatcher_prog_fd) // dispatcher prog attached to eth0
> > link1 = (dispatcher_prog_fd, xdp_firewall1_fd) // 1st extension prog attached to dispatcher
> > link2 = (dispatcher_prog_fd, xdp_firewall2_fd) // 2nd extension prog attached to dispatcher
> >
> > Now libxdp wants to update the dispatcher prog.
> > It generates new dispatcher prog with more placeholder entries or new policy:
> > new_dispatcher_prog_fd.
> > It's not attached anywhere.
> > Then libxdp calls new bpf_raw_tp_open() api I'm proposing above to create:
> > link3 = (new_dispatcher_prog_fd, xdp_firewall1_fd)
> > link4 = (new_dispatcher_prog_fd, xdp_firewall2_fd)
> > Now we have two firewalls attached to both old dispatcher prog and new dispatcher prog.
> > Both firewalls are executing via old dispatcher prog that is active.
> > Now libxdp calls:
> > bpf_link_udpate(root_link, dispatcher_prog_fd, new_dispatcher_prog_fd)
> > which atomically replaces old dispatcher prog with new dispatcher prog in eth0.
> > The traffic keeps flowing into both firewalls. No packets lost.
> > But now it goes through new dipsatcher prog.
> > libxdp can now:
> > close(dispatcher_prog_fd);
> > close(link1);
> > close(link2);
> > Closing (and destroying two links) will remove old dispatcher prog
> > from linked list in xdp_firewall1_prog->aux->linked_prog_list and from
> > xdp_firewall2_prog->aux->linked_prog_list.
> > Notice that there is no need to explicitly detach old dispatcher prog from eth0.
> > link_update() did it while replacing it with new dispatcher prog.
> 
> Yeah, this was the flow I had in mind already. However, what I meant was
> that *from the PoV of an application consuming the link fd*, this would
> lead to dangling links.
> 
> I.e., an application does:
> 
> app1_link_fd = libxdp_install_prog(prog1);
> 
> and stores link_fd somewhere (just holds on to it, or pins it
> somewhere).
> 
> Then later, another application does:
> 
> app2_link_fd = libxdp_install_prog(prog2);
> 
> but this has the side-effect of replacing the dispatcher, so
> app1_link_fd is now no longer valid.
> 
> This can be worked around, of course (e.g., just return the prog_fd and
> hide any link_fd details inside the library), but if the point of
> bpf_link is that the application could hold on to it and use it for
> subsequent replacements, that would be nice to have for consumers of the
> library as well, no?

link is a pair of (hook, prog). I don't think that single bpf-link (FD)
should represent (hook1, hook2, hook3, prog). It will be super confusing to the
user space when single FD magically turns into multi attach. If you really need
one object to represent multiple bpf_links where the same program is attached
to multiple location such abstraction needs to be done by user space library.
At the end it's libbpf job. I think it's fine for libbpf to have
'struct bpf_multi_link' where multiple 'struct bpf_link' can be aggregated.
From task point of view they are all FDs and will get autoclosed and such.

There is also a way to update dispatch prog without introducing bpf_multi_link.
My understanding that you don't want libxdp to work as a daemon.
So app1 does libxdp_install_prog(prog1) and gets back
'struct bpf_link *' (which is FD internally).
App2 wants to refresh dispatcher prog.
It loads new prog. Finds bpf_link of app1 (ether in bpffs or via bpf_link idr).
Queries app1_prog_id->fd.
app1_link2_fd = bpf_raw_tp_open(app1_prog_fd, new_dispatch_prog, new_btf_id);
// now app1_prog is attached to two dispatcher progs

bpf_link_update(root_link, old_dispatcher_prog, new_dispatcher_prog);
// now traffic is going to app1 prog via new dispatcher

bpf_link_update_hook(app1_link1_fd, app1_link2_fd);
here I'm proposing a new operation that will close 2nd link and will update
hook of the first link with the hook of 2nd link if prog is the same.
Conceptually it's a similar operation to bpf_link_update() which replaces bpf
prog in the hook. bpf_link_update_hook() can replace the hook while keeping the
program the same.

Note it cannot be called earlier. app2 still need to attach app1 prog to
two dispatcher progs, replace dispatcher and only then switch the hook
in bpf_link internals. Otherwise app1 traffic will stop while new dispatcher
is not yet active.
