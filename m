Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D94918397D
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCLTcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:32:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46265 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgCLTcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:32:35 -0400
Received: by mail-pl1-f195.google.com with SMTP id w12so3045052pll.13;
        Thu, 12 Mar 2020 12:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=izv74EIFJAd5AGmNCfghT95FAJ1SApIUXkaNrYzmzNU=;
        b=V72R2UfI/HtBVr73JBp7RFz09yYtu7V79vcpak1u5VXEjzE+fTvR8N+9uSYd4AlekA
         MRmcFJaTyg4gUWhfEv2PotPscZbwiYNgfc8OlcvKg0KKLlG0ocXJzEuH/Ycry66X0UUh
         mBsFEzDKQD9Oc/f3jGLLXaIQKcrChZVAx+PUDmqb9QSqHQF6Fxw7vLVlkphBJfbKOOKs
         1IcDzEMhg7XQLXlnRC00B2vQx/Mn2TbZ+JyS1YUWE+oOD/vay+sWiLlXmAkQ2SfAYbl8
         MYRwTqaePpj0KeikQaCyfbm8wAIRPZH6x8CmuWKJrZFsjP7mnrMN+T5i8zXFqvwrhKqC
         ORNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=izv74EIFJAd5AGmNCfghT95FAJ1SApIUXkaNrYzmzNU=;
        b=dMzMuv3DrcYOB9kkT4IZXCeecx5IPLkjLPTvssm9LX5A/lSt2d1F2pIPMpVqJkE4Tz
         iGGvVRMG4CZLUuCrX8bwVCGHWRNpkItv0CPkQpLxalLIurWtp307axSfewqyuGCvBe+h
         M7Aeh+K/7N78lyoObjeULqf+6kveZdf62+zqLgs/1hnBZK0wRjI/mpXGTBY+AxELzHBc
         0B7tL4bfFL7HvwavLTKJtw7BnlHmFl0AfOzoZ5mxtDjFL5cKdyIXtnI6GqfkV/1lJfb2
         rYUO/E2o+FqR7UHFxo4Dw+7QXz9+44yrJ4E0mhjp5piHNnFYpFl60OPIEE11ftdVCMg7
         N7mg==
X-Gm-Message-State: ANhLgQ2jxnImsrDjcaGH439/VPEo00kKigdyVgFE2h4y6E2Rdy4NBFn5
        KscOrSbqYG/fcAfSA3Au8js=
X-Google-Smtp-Source: ADFU+vs/thMaidWm8SAkag15zpbiWeks3p8yJ1ks9X7Q+F/T+dlE7GFglqsr8tQLozxHbLrltCvA8g==
X-Received: by 2002:a17:90a:345:: with SMTP id 5mr5725700pjf.134.1584041552178;
        Thu, 12 Mar 2020 12:32:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 23sm55813139pfh.28.2020.03.12.12.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 12:32:31 -0700 (PDT)
Date:   Thu, 12 Mar 2020 12:32:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5e6a8e48240a9_6a322aac933b85c029@john-XPS-13-9370.notmuch>
In-Reply-To: <20200312175828.xenznhgituyi25kj@ast-mbp>
References: <20200310174711.7490-1-lmb@cloudflare.com>
 <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Thu, Mar 12, 2020 at 09:16:34AM +0000, Lorenz Bauer wrote:
> > On Thu, 12 Mar 2020 at 01:58, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > we do store the socket FD into a sockmap, but returning new FD to that socket
> > > feels weird. The user space suppose to hold those sockets. If it was bpf prog
> > > that stored a socket then what does user space want to do with that foreign
> > > socket? It likely belongs to some other process. Stealing it from other process
> > > doesn't feel right.
> > 
> > For our BPF socket dispatch control plane this is true by design: all sockets
> > belong to another process. The privileged user space is the steward of these,
> > and needs to make sure traffic is steered to them. I agree that stealing them is
> > weird, but after all this is CAP_NET_ADMIN only. pidfd_getfd allows you to
> > really steal an fd from another process, so that cat is out of the bag ;)
> 
> but there it goes through ptrace checks and lsm hoooks, whereas here similar
> security model cannot be enforced. bpf prog can put any socket into sockmap and
> from bpf_lookup_elem side there is no way to figure out the owner task of the
> socket to do ptrace checks. Just doing it all under CAP_NET_ADMIN is not a
> great security answer.
> 
> > Marek wrote a PoC control plane: https://github.com/majek/inet-tool
> > It is a CLI tool and not a service, so it can't hold on to any sockets.
> > 
> > You can argue that we should turn it into a service, but that leads to another
> > problem: there is no way of recovering these fds if the service crashes for
> > some reason. The only solution would be to restart all services, which in
> > our set up is the same as rebooting a machine really.
> > 
> > > Sounds like the use case is to take sockets one by one from one map, allocate
> > > another map and store them there? The whole process has plenty of races.
> > 
> > It doesn't have to race. Our user space can do the appropriate locking to ensure
> > that operations are atomic wrt. dispatching to sockets:
> > 
> > - lock
> > - read sockets from sockmap
> > - write sockets into new sockmap
> 
> but bpf side may still need to insert them into old.
> you gonna solve it with a flag for the prog to stop doing its job?
> Or the prog will know that it needs to put sockets into second map now?
> It's really the same problem as with classic so_reuseport
> which was solved with BPF_MAP_TYPE_REUSEPORT_SOCKARRAY.
> 
> > > I think it's better to tackle the problem from resize perspective. imo making it
> > > something like sk_local_storage (which is already resizable pseudo map of
> > > sockets) is a better way forward.
> > 
> > Resizing is only one aspect. We may also need to shuffle services around,
> > think "defragmentation", and I think there will be other cases as we gain more
> > experience with the control plane. Being able to recover fds from the sockmap
> > will make it more resilient. Adding a special API for every one of these cases
> > seems cumbersome.
> 
> I think sockmap needs a redesign. Consider that today all sockets can be in any
> number of sk_local_storage pseudo maps. They are 'defragmented' and resizable.
> I think plugging socket redirect to use sk_local_storage-like infra is the
> answer.

socket redirect today can use any number of maps and redirect to any sock
in any map. There is no restriction on only being able to redirect to socks
in the same map. Further, the same sock can be in the multiple maps or even
the same map in multiple slots. I think its fairly similar to sk local
storage in this way.

The restriction that the maps can not grow/shrink is perhaps limiting a
bit. I can see how resizing might be useful. In my original load balancer
case a single application owned all the socks so there was no need to
ever pull them back out of the map. We "knew" where they were. I think
resize ops could be added without to much redesign. Or a CREATE flag could
be used to add it as a new entry if needed. At some point I guess someone
will request it as a feature for Cilium for example. OTOH I'm not sure
off-hand how to use a dynamically sized table for load balancing. I
should know the size because I want to say something about the hash
distribution and if the size is changing do I still know this? I really
haven't considered it much.

As an aside redirect helper could work with anything of sock type not just
socks from maps. Now that we have BTF infra to do it we could just type
check that we have a sock and do the redirect regardless of if the sock
is in a map or not. The map really provides two functions, first a
way to attach programs to the socks and second a stable array to hash
over if needed.

Rather than expose the fd's to user space would a map copy api be
useful? I could imagine some useful cases where copy might be used 

 map_copy(map *A, map *B, map_key *key)

would need to sort out what to do with key/value size changes. But
I can imagine for upgrades this might be useful.

Another option I've been considering the need for a garbage collection
thread trigger at regular intervals. This BPF program could do the
copy from map to map in kernel space never exposing fds out of kernel

Thanks.
