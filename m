Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EEA2E7A2D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgL3PGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:06:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbgL3PGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 10:06:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609340679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZIXZvnYFXxS/me1jrkJ7b6mDqrcu//hDM6B6mG0eeg=;
        b=JlXLmWN3tCG2LY7O6WNNB+FJHMHsHW0FohbasyWWX9UeNrGMLq41yfXV8D3U58oNmG78qh
        bATuYOSn7vRXCFyB4LuNwuWSywZ82APy461HAZ6sm9JUO8EwK+/aZ+JsBdAy2+LGxo0RZ9
        5sc6FUw5U8JtPOzgk3NU+Om3TpJho0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-mjACzZMjMGuoINdeD4oG3A-1; Wed, 30 Dec 2020 10:04:35 -0500
X-MC-Unique: mjACzZMjMGuoINdeD4oG3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43FF4801AC0;
        Wed, 30 Dec 2020 15:04:34 +0000 (UTC)
Received: from krava (unknown [10.40.192.27])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2379B5D9CC;
        Wed, 30 Dec 2020 15:04:31 +0000 (UTC)
Date:   Wed, 30 Dec 2020 16:04:31 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201230150431.GA587975@krava>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
 <20201230090333.GA577428@krava>
 <20201230132759.GB577428@krava>
 <20201230132852.GC577428@krava>
 <20201230141936.GA3922432@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230141936.GA3922432@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 11:19:36AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 30, 2020 at 02:28:52PM +0100, Jiri Olsa escreveu:
> > On Wed, Dec 30, 2020 at 02:28:02PM +0100, Jiri Olsa wrote:
> > > On Wed, Dec 30, 2020 at 10:03:37AM +0100, Jiri Olsa wrote:
> > > > On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> > > > > Hi Jiri
> > > > > 
> > > > > On 12/29/20 18:34, Jiri Olsa wrote:
> > > > > > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > > > > > Hi
> > > > > > > 
> > > > > > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > > > > > stage
> > > > > > > 
> > > > > > > 	FAILED unresolved symbol udp6_sock
> > > > > > > 
> > > > > > > I cross compile for arm64. My .config is attached.
> > > > > > > 
> > > > > > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > > > > > 
> > > > > > > Have you seen this before? I couldn't find a specific report about this
> > > > > > > problem.
> > > > > > > 
> > > > > > > Let me know if you need more info.
> > > > > > 
> > > > > > hi,
> > > > > > this looks like symptom of the gcc DWARF bug we were
> > > > > > dealing with recently:
> > > > > > 
> > > > > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> > > > > >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > > > > > 
> > > > > > what pahole/gcc version are you using?
> > > > > 
> > > > > I'm on gcc 9.3.0
> > > > > 
> > > > > 	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> > > > > 
> > > > > I was on pahole v1.17. I moved to v1.19 but I still see the same problem.
> 
> There are some changes post v1.19 in the git repo:
> 
> [acme@five pahole]$ git log --oneline v1.19..
> b688e35970600c15 (HEAD -> master) btf_encoder: fix skipping per-CPU variables at offset 0
> 8c009d6ce762dfc9 btf_encoder: fix BTF variable generation for kernel modules
> b94e97e015a94e6b dwarves: Fix compilation on 32-bit architectures
> 17df51c700248f02 btf_encoder: Detect kernel module ftrace addresses
> 06ca639505fc56c6 btf_encoder: Use address size based on ELF's class
> aff60970d16b909e btf_encoder: Factor filter_functions function
> 1e6a3fed6e52d365 (quaco/master) rpm: Fix changelog date
> [acme@five pahole]$
> 
> But I think these won't matter in this case :-\

yep, it did not.. I used the latest dwarves code

jirka

