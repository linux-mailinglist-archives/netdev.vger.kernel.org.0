Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6305521EEFB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 13:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGNLRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 07:17:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbgGNLP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 07:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594725356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wo3b72+f5d0wE/+LGqBGg/pHVyxAvNtZLrUUPiNVkWE=;
        b=UlfzeEpU+F3xiCwOvGbX6JlNs8IDz4m03ydvaPUE1xMHjW5bQqXQ+xG3gosc8KMhjvDPjw
        cTfCx/A+HqEr4w9FF9OIF8tJCRhBAsGjR9OpF9cCL0iUAlZaKCiDI12Q/iKPHN8bKHhLA8
        +/JGQCvKrqnYUI739jllFovnehEEkBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-JAf95g9fOGa8PNJBi69ewg-1; Tue, 14 Jul 2020 07:15:50 -0400
X-MC-Unique: JAf95g9fOGa8PNJBi69ewg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E931100A61D;
        Tue, 14 Jul 2020 11:15:49 +0000 (UTC)
Received: from krava (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3ADFA1CA;
        Tue, 14 Jul 2020 11:15:46 +0000 (UTC)
Date:   Tue, 14 Jul 2020 13:15:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20200714111545.GI183694@krava>
References: <20200714121608.58962d66@canb.auug.org.au>
 <20200714090048.GG183694@krava>
 <20200714203341.4664dda3@canb.auug.org.au>
 <20200714104702.GH183694@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714104702.GH183694@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 12:47:02PM +0200, Jiri Olsa wrote:
> On Tue, Jul 14, 2020 at 08:33:41PM +1000, Stephen Rothwell wrote:
> 
> SNIP
> 
> > > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > > index 948378ca73d4..a88cd4426398 100644
> > > --- a/tools/bpf/resolve_btfids/Makefile
> > > +++ b/tools/bpf/resolve_btfids/Makefile
> > > @@ -16,6 +16,20 @@ else
> > >    MAKEFLAGS=--no-print-directory
> > >  endif
> > >  
> > > +# always use the host compiler
> > > +ifneq ($(LLVM),)
> > > +HOSTAR  ?= llvm-ar
> > > +HOSTCC  ?= clang
> > > +HOSTLD  ?= ld.lld
> > > +else
> > > +HOSTAR  ?= ar
> > > +HOSTCC  ?= gcc
> > > +HOSTLD  ?= ld
> > > +endif
> > > +AR       = $(HOSTAR)
> > > +CC       = $(HOSTCC)
> > > +LD       = $(HOSTLD)
> > > +
> > >  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> > >  
> > >  LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> > > 
> > 
> > Thanks for the quick response.  However, in the mean time the bpf-next
> > tree has been merged into the net-next tree, so these fixes will be
> > needed there ASAP.
> 
> I just posted it

ugh, you said net-next..

David, do you need me to repost with net-next tag?
  https://lore.kernel.org/bpf/20200714102534.299280-1-jolsa@kernel.org/T/

jirka

