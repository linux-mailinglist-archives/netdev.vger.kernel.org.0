Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D65717B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfFZTVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:21:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40189 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZTVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:21:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so1960917pla.7;
        Wed, 26 Jun 2019 12:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NjiOBAgZ5o5AckUXhxHXSV2oj9IdH5jk7jVzEy13FIQ=;
        b=eJ6h59ONAyItQUaibTIyV11/OFIMtmV/Sahp4ibvM/sFwtFgVUqZfptHelZ8hOgqEX
         CnmvnbzoESMQxiphKzFJtHOnLJJnOt1C6eDRWz+PVJlQrs43G09/NMHOmwJs/wOfc4qG
         tx5VDHnTSnmt+Co3Datw4i/HXxdGlqU0FJ0IhngZPV4yqOs37QweSvZYGFTyDzRSXnU9
         O3wsDAZ8RWdvMmR5OKDbO3acC0B+EcGGugy4diPILuE6jI2uemfZIdKVBsynubZBtr6H
         wCq8k6dXNM3FFho2SGYx0VSxGtb0Nwp81MyGtKIjO4281LIHhFqYfuHhaB1aqcLRFxtJ
         N6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NjiOBAgZ5o5AckUXhxHXSV2oj9IdH5jk7jVzEy13FIQ=;
        b=RATRRzpqg0rveTeqXOd6Jir4mwzyAm7rNm+PwjeiuwLWKeJ9YMn51r0x0k12MdDhif
         Gmt/kXYBEI7UUpCQrYfqIGcLRWjYYztmWM9jwqdo+dwzEUI17eS7kZy4C4PxkqiZavRT
         dZDHwASG/94BNBNFcL7azPtHhimmOK6RdA9UFNYHX1t+YZ0gM12IIZwjcTR1x65IMJJi
         xKOVo3qmcCz+nFrE+gmERQ2kXEYZ8A9KFFbgB2n8JgS/lke1NbVsfLqeAJywB+J/1KdX
         OecpnPBzlrNhbV6Pb3fLcKb0JorGHybBLpT6S8raky6xut1Tb8Wz8eBGvbArk5MnLZOW
         41NA==
X-Gm-Message-State: APjAAAWgUDLL1yflFmQmb3JO5LTePXw48UVJqYiiRy5qKw1pkRimgeBF
        damUR6dGGKaH94DBkUMLzK0=
X-Google-Smtp-Source: APXvYqwa4kTGhHhHRJKP1vX78Iu2hF92lsVIKkc/OiXzrn5NkFxQX0WOMWwT64bsljopE0M6VCKdhQ==
X-Received: by 2002:a17:902:2926:: with SMTP id g35mr7292780plb.269.1561576890866;
        Wed, 26 Jun 2019 12:21:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1:6c67])
        by smtp.gmail.com with ESMTPSA id d4sm2517689pju.19.2019.06.26.12.21.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 12:21:30 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:21:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v8 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190626192126.qkwr7hv2leich5tk@ast-mbp.dhcp.thefacebook.com>
References: <20190624162429.16367-1-sdf@google.com>
 <20190624162429.16367-2-sdf@google.com>
 <20190626185420.wzsb7v6rawn4wtzd@ast-mbp.dhcp.thefacebook.com>
 <20190626191021.GB4866@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626191021.GB4866@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:10:21PM -0700, Stanislav Fomichev wrote:
> On 06/26, Alexei Starovoitov wrote:
> > On Mon, Jun 24, 2019 at 09:24:21AM -0700, Stanislav Fomichev wrote:
> > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > > 
> > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > 
> > getsockopt side looks good to me.
> > I tried to convince myself that readonly setsockopt is fine for now,
> > but it feels we need to make it writeable from the start.
> > I agree with your reasoning that doing copy_to_user is no good,
> > but we can do certainly do set_fs(KERNEL_DS) game.
> > The same way as kernel_setsockopt() is doing.
> > It seems quite useful to modify 'optval' before passing it to kernel.
> > Then bpf prog would be able to specify sane values for SO_SNDBUF
> > instead of rejecting them.
> > The alternative would be to allow bpf prog to call setsockopt
> > from inside, but sock is locked when prog is running,
> > so unlocking within helper is not going to be clean.
> > wdyt?
> Sure, I can take a look if you think that it would be useful in general.
> Looks like set_fs should do the trick.

Thanks. I think it's useful.
For example see the recent sack steam issue and Eric's workaround
for older kernel to add 128k to sk_sndbuf.
If we had an ability to do adjust SO_SNDBUF from cgroup-bpf prog
when user space is doing setsockopt we could have mitigated it by
rolling bpf prog instead of patching and rebooting the kernels.
That's a bit of a stretch use case, of course.
My feeling that if not today, but really soon people will find
solid use cases for adjusting sockopt values via cgroup-bpf.

