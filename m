Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034CA19D25E
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 10:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbgDCIir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 04:38:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58235 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727774AbgDCIir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 04:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585903126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MwWGdFus6RcsojSPJf8dandZUpGf7sV7QjhW4kAmQmk=;
        b=K31sU/QXhEfLA5+z1jnkKBwpSMivONaYV6hODIKCSS97GUbIi30XHRNNd2zTl0iP41kOUY
        QbgWEQngAlzWl15tkeuZm+xYJr8GPJZOv7r2+J1sYQxxqMiu/DQlU0wROYeX2oaAy2V5Ph
        0Vc+ctvIrFf4ijF/wk8Sz3sdvIoiTL0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-vAb-xXNoNxacO0cdnl_BvQ-1; Fri, 03 Apr 2020 04:38:44 -0400
X-MC-Unique: vAb-xXNoNxacO0cdnl_BvQ-1
Received: by mail-lf1-f69.google.com with SMTP id p8so2159665lfc.8
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 01:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MwWGdFus6RcsojSPJf8dandZUpGf7sV7QjhW4kAmQmk=;
        b=RbHe4u5L+2NxmQUQwOVwejbu2oG+uk1ZIf9/0qbSJwQCEiW7y9mmStR+FvU0szoj2Q
         CP3SwhpRYU4nGOSaSupaSTGYGiUmCRMIEob5ECxqpKQJLsj14f7L6MvjPWXxhwXKXZl3
         2nNQDpWFfxGPrrtW3CXowAUlqB3cmtZDsVj49lvwYaRaeaFtCE5xiHdvoiQXmnMGsHVK
         48LS0J+lGGTn7qvS7MLyqNHxh931ktg0KRTcDBeVdgXxgZjZefzo3MWxyUCMGqTAWUR/
         aanM8L1/oS8VvpEKtglYnAtOfwOxLYCi0jpoKkJ0Yz75+RLtzWL8Pr5i1UtztPmio25O
         5ZVQ==
X-Gm-Message-State: AGi0PuZa3jwbodkjeeE7PHe3KToLFNly6eb/KsgZI6u+VTJwH8zssF9c
        xetQoUBNSmuB+KLdnyMURRzC7+uetegyIL9FJNUJExzY99zX+NFn4E7q8iat9fK9SbNqRS2MiZT
        vDb/FfpkxyxTuWet+
X-Received: by 2002:a2e:9bd7:: with SMTP id w23mr4497487ljj.47.1585903122282;
        Fri, 03 Apr 2020 01:38:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJnnyi7t4elwruh/VzpO7DuUWm6GQguQs6qCXfDGi1ZzPcIhbeC+r5zYX+l2A9HAQjbM7Kv5w==
X-Received: by 2002:a2e:9bd7:: with SMTP id w23mr4497472ljj.47.1585903121917;
        Fri, 03 Apr 2020 01:38:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q30sm6289192lfn.18.2020.04.03.01.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 01:38:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 36A7718158C; Fri,  3 Apr 2020 10:38:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Apr 2020 10:38:38 +0200
Message-ID: <87ftdldkvl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> It's a different link.
> For fentry/fexit/freplace the link is pair:
>   // target           ...         bpf_prog
> (target_prog_fd_or_vmlinux, fentry_exit_replace_prog_fd).
>
> So for xdp case we will have:
> root_link = (eth0_ifindex, dispatcher_prog_fd) // dispatcher prog attached to eth0
> link1 = (dispatcher_prog_fd, xdp_firewall1_fd) // 1st extension prog attached to dispatcher
> link2 = (dispatcher_prog_fd, xdp_firewall2_fd) // 2nd extension prog attached to dispatcher
>
> Now libxdp wants to update the dispatcher prog.
> It generates new dispatcher prog with more placeholder entries or new policy:
> new_dispatcher_prog_fd.
> It's not attached anywhere.
> Then libxdp calls new bpf_raw_tp_open() api I'm proposing above to create:
> link3 = (new_dispatcher_prog_fd, xdp_firewall1_fd)
> link4 = (new_dispatcher_prog_fd, xdp_firewall2_fd)
> Now we have two firewalls attached to both old dispatcher prog and new dispatcher prog.
> Both firewalls are executing via old dispatcher prog that is active.
> Now libxdp calls:
> bpf_link_udpate(root_link, dispatcher_prog_fd, new_dispatcher_prog_fd)
> which atomically replaces old dispatcher prog with new dispatcher prog in eth0.
> The traffic keeps flowing into both firewalls. No packets lost.
> But now it goes through new dipsatcher prog.
> libxdp can now:
> close(dispatcher_prog_fd);
> close(link1);
> close(link2);
> Closing (and destroying two links) will remove old dispatcher prog
> from linked list in xdp_firewall1_prog->aux->linked_prog_list and from
> xdp_firewall2_prog->aux->linked_prog_list.
> Notice that there is no need to explicitly detach old dispatcher prog from eth0.
> link_update() did it while replacing it with new dispatcher prog.

Yeah, this was the flow I had in mind already. However, what I meant was
that *from the PoV of an application consuming the link fd*, this would
lead to dangling links.

I.e., an application does:

app1_link_fd = libxdp_install_prog(prog1);

and stores link_fd somewhere (just holds on to it, or pins it
somewhere).

Then later, another application does:

app2_link_fd = libxdp_install_prog(prog2);

but this has the side-effect of replacing the dispatcher, so
app1_link_fd is now no longer valid.

This can be worked around, of course (e.g., just return the prog_fd and
hide any link_fd details inside the library), but if the point of
bpf_link is that the application could hold on to it and use it for
subsequent replacements, that would be nice to have for consumers of the
library as well, no?

-Toke

