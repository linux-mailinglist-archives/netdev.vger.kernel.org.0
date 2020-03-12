Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5F818381F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgCLR6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:58:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40483 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgCLR6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:58:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id t24so3428689pgj.7;
        Thu, 12 Mar 2020 10:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5vftAQYq6ID+MRMAVRsymvdTOvg+Bk/OfHtxvYpdPew=;
        b=Vs6hgzvPVOWphjxfjb9I57dUSN+ZJPc4AKWj8gbuJIb7ni+/u6oiqSuvY1+uHU2jeE
         A2+QFKpg4sf4eKmBXlbJ4d8lYzvHQ3OftwfXQcjAm97IZw5qtOSHmf9W1M464tkIoLXl
         J+EJoKcH8I3AcLxuclCXnUeikk32loKG8JxeoQU0Def6PSXEVewKzVubXCInP3QN9Xag
         D60UaThbd/CdWxtC8Qfp1fhKDrIc8Qsj19aLzw9DLOaAqEyuVHV9qj+9WljWN287oKJL
         uwpJprADcYff7DfVQR0Bn0IkywOoti0lLbgV05RcDjwIPiOzGVCj37SWr5o2YGQUmhIj
         kInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5vftAQYq6ID+MRMAVRsymvdTOvg+Bk/OfHtxvYpdPew=;
        b=UTo485vRmX36EGQ7JvFCciAMt3hJtEQ2auu1BBlKbxL7Qjw630whMhK7EIpZXEoo1t
         7fP/0VyasY8avQJa/Bt63b7lejCdmWg0W8KIKavbsK6SOHbTQdvQfFtvuGoaLtGj4a4e
         /Wg7edvcfVYjwNUjMgSUcHPvbxTd8Z6B9xYu7LT1aZmHv8z4JlBzHf6GklGxywHzLeX0
         UWxaFexr9Xcv8AN4jW8gbbJK+x+HlLakg06Yxk9RhK8GLwhF9yJ1JSgvf0S/rUhT1uJI
         9/1OeKkLVLLf3ysapmC9bYZVZYoeXw9LRvhpOQ//T0yDGgi4mYXvcysIigC66NPiXJy6
         IkAQ==
X-Gm-Message-State: ANhLgQ36kgOif1RcSDYv9qADy+UPBBrZhPECK+WtihJMa6EbMpGe1IGm
        5tJDPj3q9dVK0p9ULFYTazI=
X-Google-Smtp-Source: ADFU+vteKakN1iz7/0lK/BXOQkDuYsAQYd8cs4Lmg1M3CJ3dfz+PhGr2o/AJRIhTlTSkLBg3kfvT0A==
X-Received: by 2002:a63:790e:: with SMTP id u14mr8535292pgc.361.1584035912088;
        Thu, 12 Mar 2020 10:58:32 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:2d43])
        by smtp.gmail.com with ESMTPSA id j2sm20647065pfg.169.2020.03.12.10.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 10:58:30 -0700 (PDT)
Date:   Thu, 12 Mar 2020 10:58:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Message-ID: <20200312175828.xenznhgituyi25kj@ast-mbp>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 09:16:34AM +0000, Lorenz Bauer wrote:
> On Thu, 12 Mar 2020 at 01:58, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > we do store the socket FD into a sockmap, but returning new FD to that socket
> > feels weird. The user space suppose to hold those sockets. If it was bpf prog
> > that stored a socket then what does user space want to do with that foreign
> > socket? It likely belongs to some other process. Stealing it from other process
> > doesn't feel right.
> 
> For our BPF socket dispatch control plane this is true by design: all sockets
> belong to another process. The privileged user space is the steward of these,
> and needs to make sure traffic is steered to them. I agree that stealing them is
> weird, but after all this is CAP_NET_ADMIN only. pidfd_getfd allows you to
> really steal an fd from another process, so that cat is out of the bag ;)

but there it goes through ptrace checks and lsm hoooks, whereas here similar
security model cannot be enforced. bpf prog can put any socket into sockmap and
from bpf_lookup_elem side there is no way to figure out the owner task of the
socket to do ptrace checks. Just doing it all under CAP_NET_ADMIN is not a
great security answer.

> Marek wrote a PoC control plane: https://github.com/majek/inet-tool
> It is a CLI tool and not a service, so it can't hold on to any sockets.
> 
> You can argue that we should turn it into a service, but that leads to another
> problem: there is no way of recovering these fds if the service crashes for
> some reason. The only solution would be to restart all services, which in
> our set up is the same as rebooting a machine really.
> 
> > Sounds like the use case is to take sockets one by one from one map, allocate
> > another map and store them there? The whole process has plenty of races.
> 
> It doesn't have to race. Our user space can do the appropriate locking to ensure
> that operations are atomic wrt. dispatching to sockets:
> 
> - lock
> - read sockets from sockmap
> - write sockets into new sockmap

but bpf side may still need to insert them into old.
you gonna solve it with a flag for the prog to stop doing its job?
Or the prog will know that it needs to put sockets into second map now?
It's really the same problem as with classic so_reuseport
which was solved with BPF_MAP_TYPE_REUSEPORT_SOCKARRAY.

> > I think it's better to tackle the problem from resize perspective. imo making it
> > something like sk_local_storage (which is already resizable pseudo map of
> > sockets) is a better way forward.
> 
> Resizing is only one aspect. We may also need to shuffle services around,
> think "defragmentation", and I think there will be other cases as we gain more
> experience with the control plane. Being able to recover fds from the sockmap
> will make it more resilient. Adding a special API for every one of these cases
> seems cumbersome.

I think sockmap needs a redesign. Consider that today all sockets can be in any
number of sk_local_storage pseudo maps. They are 'defragmented' and resizable.
I think plugging socket redirect to use sk_local_storage-like infra is the
answer.
