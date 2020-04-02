Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3BA19CC95
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 23:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389104AbgDBVy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 17:54:58 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:37985 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBVy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 17:54:58 -0400
Received: by mail-pl1-f174.google.com with SMTP id w3so1866206plz.5;
        Thu, 02 Apr 2020 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7F+dYfCQ5OWPWnYJ+4oT6s4iSyTj4WjRWONg/cEd36E=;
        b=JqM4MTbqnbQYNbHDb/Lsa0LtXMRbw+NzgCYA24ggBcNrFXddNHmJAhGZQsJLuKYo4s
         bs0tab/ETqaLdfSTosf9HwRUL5F4a5Pfr3ZspB+NeKfbn7JQFgjwq1E6jijg96qBhIgp
         7GAbOXbilKqRYawJJFmjy9aLjx95L3+tFf1N9VsAgjgO+At467an9uJdpq1Uy/KoniDJ
         bQwEDXY2p+4Mbpl+jQseArL2/BIcFywlIvNqZrAqLd0BlcKvEUufXgnZfS/wkb/cINzk
         DhvVCZRjGhI6rpMJRdkDnU+qcbyFJh1V/Qbk8/g8SZ3kQgbp4RWZ+M0UodlgkQCk0uQx
         FYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7F+dYfCQ5OWPWnYJ+4oT6s4iSyTj4WjRWONg/cEd36E=;
        b=lZlI4MagEOU6qIR/Q4TMgtS6B5Hb8dS2wUwFZoUFGU1sxv+CWaDWZvqbF1nm0BW1b9
         f/NPPZkojbs4omsM7PzILgcdyjyrDyKeQTid3SFvYSbZDX/cGRdifeU2mMF1Y7gcfdb4
         93qnVFk0Igkys4tkfOXvbhDkNHTG0LY8/3rsPTsd+Cjdq8OzPpL303+3myVUNFQn0Ptp
         xlHpJvX9oMUca3vaLgHnfAeSUTp1bVHiq9eQvJw39MGPaLlPQDxW2Pqm6nAsbV3iN2BW
         mApaJTmA0yOJXr81PCoX+eCbi8a84VWMW4d3je9gWhE4hO+4DnMw6gtmM+8LNaFRdg1m
         75pA==
X-Gm-Message-State: AGi0PuZMX63+LUmUgbNs7VWOOnDI++XUPHC3ZG1TdNN4ZQBofZKOhhHD
        HAJdA+1q8CU+aGDPDXpNH2Y=
X-Google-Smtp-Source: APiQypJ97zG5VKuAK+PO5tuBbNLDtn14oB6nlBq/SlFCldX5AX7HHFojs/qNPTvNdRbpC1SrZDeWNQ==
X-Received: by 2002:a17:902:207:: with SMTP id 7mr5034143plc.216.1585864496372;
        Thu, 02 Apr 2020 14:54:56 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b3a4])
        by smtp.gmail.com with ESMTPSA id y7sm4406310pfq.159.2020.04.02.14.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 14:54:55 -0700 (PDT)
Date:   Thu, 2 Apr 2020 14:54:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
 <87o8s9eg5b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8s9eg5b.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 11:23:12PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Fri, Mar 27, 2020 at 12:11:15PM +0100, Toke Høiland-Jørgensen wrote:
> >> 
> >> Current code is in [0], for those following along. There are two bits of
> >> kernel support missing before I can get it to where I want it for an
> >> initial "release": Atomic replace of the dispatcher (this series), and
> >> the ability to attach an freplace program to more than one "parent".
> >> I'll try to get an RFC out for the latter during the merge window, but
> >> I'll probably need some help in figuring out how to make it safe from
> >> the verifier PoV.
> >
> > I have some thoughts on the second part "ability to attach an freplace
> > to more than one 'parent'".
> > I think the solution should be more generic than just freplace.
> > fentry/fexit need to have the same feature.
> > Few folks already said that they want to attach fentry to multiple
> > kernel functions. It's similar to what people do with kprobe progs now.
> > (attach to multiple and differentiate attach point based on parent IP)
> > Similarly "bpftool profile" needs it to avoid creating new pair of fentry/fexit
> > progs for every target bpf prog it's collecting stats about.
> > I didn't add this ability to fentry/fexit/freplace only to simplify
> > initial implementation ;) I think the time had come.
> 
> Yup, I agree that it makes sense to do the same for fentry/fexit.
> 
> > Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
> > It just needs to become a linked list.
> > The api extension could be like this:
> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> > (currently it's just bpf_raw_tp_open(prog_fd))
> > The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
> > to hold the linked_prog and its corresponding btf_id.
> > I'm proposing to extend raw_tp_open with this pair as well to
> > attach existing fentry/fexit/freplace prog to another target.
> > Internally the kernel verify that btf of current linked_prog
> > exactly matches to btf of another requested linked_prog and
> > if they match it will attach the same prog to two target programs (in case of freplace)
> > or two kernel functions (in case of fentry/fexit).
> 
> API-wise this was exactly what I had in mind as well.

perfect!

> > Toke, Andrey,
> > if above kinda makes sense from high level description
> > I can prototype it quickly and then we can discuss details
> > in the patches ?
> > Or we can drill further into details and discuss corner cases.
> 
> I have one detail to discuss: What would the bpf_raw_tp_open() call
> return on the second attachment? A second reference to the same bpf_link
> fd as the initial attachment, or a different link?

It's a different link.
For fentry/fexit/freplace the link is pair:
  // target           ...         bpf_prog
(target_prog_fd_or_vmlinux, fentry_exit_replace_prog_fd).

So for xdp case we will have:
root_link = (eth0_ifindex, dispatcher_prog_fd) // dispatcher prog attached to eth0
link1 = (dispatcher_prog_fd, xdp_firewall1_fd) // 1st extension prog attached to dispatcher
link2 = (dispatcher_prog_fd, xdp_firewall2_fd) // 2nd extension prog attached to dispatcher

Now libxdp wants to update the dispatcher prog.
It generates new dispatcher prog with more placeholder entries or new policy:
new_dispatcher_prog_fd.
It's not attached anywhere.
Then libxdp calls new bpf_raw_tp_open() api I'm proposing above to create:
link3 = (new_dispatcher_prog_fd, xdp_firewall1_fd)
link4 = (new_dispatcher_prog_fd, xdp_firewall2_fd)
Now we have two firewalls attached to both old dispatcher prog and new dispatcher prog.
Both firewalls are executing via old dispatcher prog that is active.
Now libxdp calls:
bpf_link_udpate(root_link, dispatcher_prog_fd, new_dispatcher_prog_fd)
which atomically replaces old dispatcher prog with new dispatcher prog in eth0.
The traffic keeps flowing into both firewalls. No packets lost.
But now it goes through new dipsatcher prog.
libxdp can now:
close(dispatcher_prog_fd);
close(link1);
close(link2);
Closing (and destroying two links) will remove old dispatcher prog
from linked list in xdp_firewall1_prog->aux->linked_prog_list and from
xdp_firewall2_prog->aux->linked_prog_list.
Notice that there is no need to explicitly detach old dispatcher prog from eth0.
link_update() did it while replacing it with new dispatcher prog.
