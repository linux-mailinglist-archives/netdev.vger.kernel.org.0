Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8763314BBA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBIJfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:35:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhBIJca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:32:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612863064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=viYH64kE+WC0LkmBd6WghQDv2YxKbctUtjEzyPFmzQQ=;
        b=QcC0zYeJFTsGR5rXp8W/CP5LalyUONDCyD3/lh5DSQHZoI3ajH2nRHFAeW+3bvw4O1VKmo
        jaatZpvmyOy9zw2Gy3odOBZAU/p6QcMCZr4iwAPYfNFO0bB+6vakF1V+lIlem9Zdt28U1J
        4SZfARi1SzAe9FIixjkXaVmb9h8eOkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-AYRTBPTpNaCmWw_qqyDD0A-1; Tue, 09 Feb 2021 04:31:00 -0500
X-MC-Unique: AYRTBPTpNaCmWw_qqyDD0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EFC63FD6;
        Tue,  9 Feb 2021 09:30:57 +0000 (UTC)
Received: from krava (unknown [10.40.195.89])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9FE0060CCF;
        Tue,  9 Feb 2021 09:30:53 +0000 (UTC)
Date:   Tue, 9 Feb 2021 10:30:52 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCHv2 bpf-next 0/4] kbuild/resolve_btfids: Invoke
 resolve_btfids clean in root Makefile
Message-ID: <YCJWTCdAjoc+N70A@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <CAEf4Bza09-H+-iE8Ksd15GjXGArDubOrHorvdwBN=yh9TwTpKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza09-H+-iE8Ksd15GjXGArDubOrHorvdwBN=yh9TwTpKA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 09:36:40PM -0800, Andrii Nakryiko wrote:
> On Fri, Feb 5, 2021 at 4:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > resolve_btfids tool is used during the kernel build,
> > so we should clean it on kernel's make clean.
> >
> > v2 changes:
> >   - add Song's acks on patches 1 and 4 (others changed) [Song]
> >   - add missing / [Andrii]
> >   - change srctree variable initialization [Andrii]
> >   - shifted ifdef for clean target [Andrii]
> >
> > thanks,
> > jirka
> >
> >
> > ---
> > Jiri Olsa (4):
> >       tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
> >       tools/resolve_btfids: Check objects before removing
> >       tools/resolve_btfids: Set srctree variable unconditionally
> >       kbuild: Add resolve_btfids clean to root clean target
> >
> >  Makefile                            |  7 ++++++-
> >  tools/bpf/resolve_btfids/.gitignore |  2 --
> >  tools/bpf/resolve_btfids/Makefile   | 44 ++++++++++++++++++++++----------------------
> >  3 files changed, 28 insertions(+), 25 deletions(-)
> >
> 
> I've applied the changes to the bpf-next tree. Thanks.
> 
> Next time please make sure that each patch in the series has a v2 tag
> in [PATCH] section, it was a bit confusing to figure out which one is
> the actual v2 version. Our tooling (CI) also expects the format [PATCH
> v2 bpf-next], so try not to merge v2 with PATCH.
> 

will do, thanks

jirka

