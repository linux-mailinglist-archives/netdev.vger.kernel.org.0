Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDB42E774C
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgL3JFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:05:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726408AbgL3JFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609319022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lop/poXyiJNf2yKQyNAGmJKrn/jVxE6AMImof5eHXJw=;
        b=NiRXQqNncJ/JC0emzmygPZ8i1JWXpnS4L1p+7FZYPX8MAqZiH78NmBwBUAgxAfpgfQq/pP
        pgtUBLiOnNOoY6PR+7/EG0BZrNFCqp22Mvm+O2GcWG0BrrM170Tt6syNUsCrlU4HP7GQaf
        PzVKzOpVSbafQ8V3l7L2/xi4lKOPJ7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-IHPATD3ON2CIFLi1vCFgBQ-1; Wed, 30 Dec 2020 04:03:38 -0500
X-MC-Unique: IHPATD3ON2CIFLi1vCFgBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2436107ACE3;
        Wed, 30 Dec 2020 09:03:36 +0000 (UTC)
Received: from krava (unknown [10.40.192.76])
        by smtp.corp.redhat.com (Postfix) with SMTP id 82AE16E53E;
        Wed, 30 Dec 2020 09:03:34 +0000 (UTC)
Date:   Wed, 30 Dec 2020 10:03:33 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201230090333.GA577428@krava>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> Hi Jiri
> 
> On 12/29/20 18:34, Jiri Olsa wrote:
> > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > Hi
> > > 
> > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > stage
> > > 
> > > 	FAILED unresolved symbol udp6_sock
> > > 
> > > I cross compile for arm64. My .config is attached.
> > > 
> > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > 
> > > Have you seen this before? I couldn't find a specific report about this
> > > problem.
> > > 
> > > Let me know if you need more info.
> > 
> > hi,
> > this looks like symptom of the gcc DWARF bug we were
> > dealing with recently:
> > 
> >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > 
> > what pahole/gcc version are you using?
> 
> I'm on gcc 9.3.0
> 
> 	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> 
> I was on pahole v1.17. I moved to v1.19 but I still see the same problem.

I can reproduce with your .config, but make 'defconfig' works,
so I guess it's some config option issue, I'll check later today

jirka

