Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A442CA580
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgLAOX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:23:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729220AbgLAOX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606832551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESjPrFn6/56RO9QASZ5fwdS/xXKYooC0i6rzr8ADqJ4=;
        b=dB+kUfIRJlXz+Duf23Ed31aRD0GqtTSHH7McyZWoyxBFPacJBoDHDwVTkzqGJoMV6LMuwp
        1O9zIv90SmNPf+hyM3C4YyuxeND3DLaGmpgF80JkNC4QLiP+g/hgVzSGdHMvaSTci90TyZ
        NGyLVW/HH5z7F0icaHKFxn29Gz6JcWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-q2JmaAgUP0q7mu_kcplpQw-1; Tue, 01 Dec 2020 09:22:27 -0500
X-MC-Unique: q2JmaAgUP0q7mu_kcplpQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45E8880B71B;
        Tue,  1 Dec 2020 14:22:25 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CF5560BD8;
        Tue,  1 Dec 2020 14:22:15 +0000 (UTC)
Date:   Tue, 1 Dec 2020 15:22:14 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201201152214.1a3fb47b@carbon>
In-Reply-To: <08071e1e-497f-f53e-916a-8b519fdd1e0f@gmail.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
        <20201128221635.63fdcf69@hermes.local>
        <08071e1e-497f-f53e-916a-8b519fdd1e0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020 12:41:49 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 11/28/20 11:16 PM, Stephen Hemminger wrote:
> > Luca wants to put this in Debian 11 (good idea), but that means:
> > 
> > 1. It has to work with 5.10 release and kernel.
> > 2. Someone has to test it.
> > 3. The 5.10 is a LTS kernel release which means BPF developers have
> >    to agree to supporting LTS releases.
> > 
> > If someone steps up to doing this then I would be happy to merge it now
> > for 5.10. Otherwise it won't show up until 5.11.  
> 
> It would be good for Bullseye to have the option to use libbpf with
> iproute2. If Debian uses the 5.10 kernel then it should use the 5.10
> version of iproute2 and 5.10 version libbpf. All the components align
> with consistent versioning.
> 
> I have some use cases I can move from bpftool loading to iproute2 as
> additional testing to what Hangbin has already done. If that goes well,
> I can re-send the patch series against iproute2-main branch by next weekend.
> 
> It would be good for others (Jesper, Toke, Jiri) to run their own
> testing as well.

I have tested this on a Ubuntu 20.04.1 LTS.

I had to compile tc my own "old" version (based it on iproute2 git
tree), because Ubuntu vendor tc util version didn't even support loading
BPF-ELF objects... weird!

Copy-pasted by compile instruction below signature (including one
failure, that people can find via Google search).

I tested difference combinations old vs. new loader with map pinning
and reuse of maps (as instructed by Toke over IRC), all the cases
worked.

I took it one step further and implemented tc libbpf detection:
 https://github.com/netoptimizer/bpf-examples/commit/048c960756eb65

So, my EDT-pacing code[1] now support BTF-maps, via configure detection
and code gets compiled with support, which allows me to inspect the
content really easily (data from production system):

$ bpftool map lookup id 1351 key 0x10 0x0 0x0 0x0
{
    "key": 16,
    "value": {
        "rate": 0,
        "t_last": 3299496947649930,
        "t_horizon_drop": 0,
        "t_horizon_ecn": 0,
        "codel": {
            "first_above_time": 3299496641781522,
            "drop_next": 3299497041788432,
            "count": 9,
            "dropping": 1
        }
    }
}

[1] https://github.com/netoptimizer/bpf-examples/tree/master/traffic-pacing-edt
- - 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


Very recently iproute2 got support for using libbpf as BPF-ELF loader.

Testing this on Ubuntu 20.04.1 LTS.

Currently avail is iproute2-next tree:
- https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/
- git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git


First get libbpf:
  git clone https://github.com/libbpf/libbpf.git
  cd libbpf

Build libbpf and install it locally:

  cd ~/git/libbpf/
  mkdir build
  cd ~/git/libbpf/src
  DESTDIR=../build make install
  DESTDIR=../build make install_headers


Attempt#1: Try to get iproute2 compiling against:

  cd ~/git/iproute2-next
  $ LIBBPF_DIR=../libbpf/build/ ./configure 
  TC schedulers
   ATM	no
  
  libc has setns: yes
  SELinux support: no
  libbpf support: yes
  	libbpf version 0.3.0
  ELF support: yes
  libmnl support: yes
  Berkeley DB: no
  need for strlcpy: no
  libcap support: no

Make fails:
  $ make

  lib
      CC       bpf_libbpf.o
  bpf_libbpf.c:20:10: fatal error: bpf/libbpf.h: No such file or directory
     20 | #include <bpf/libbpf.h>
        |          ^~~~~~~~~~~~~~
  compilation terminated.


The problem is use of "relative path" in LIBBPF_DIR (../libbpf/build/), as
the Makefile enter subdir 'lib' and have these include path CFLAGS:

  CFLAGS += -DHAVE_LIBBPF  -I../libbpf/build//usr/include

Attempt#2 works: Try to get iproute2 compiling against:

  cd ~/git/iproute2-next
  $ LIBBPF_DIR=~/git/libbpf/build/ ./configure
  make


Install as stow version:

  export STOW=/usr/local/stow/iproute2-libbpf-next-git-c29f65db34
  make
  make PREFIX=$STOW SYSCONFDIR=$STOW CONFDIR=$STOW/etc/iproute2 SBINDIR=$STOW/sbin -n install
  make PREFIX=$STOW SYSCONFDIR=$STOW CONFDIR=$STOW/etc/iproute2 SBINDIR=$STOW/sbin install

Current state:
  $ tc -V
  tc utility, iproute2-5.9.0, libbpf 0.3.0

