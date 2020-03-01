Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B9E174EF7
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 19:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgCASbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 13:31:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726146AbgCASbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 13:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583087508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KDH61zEqTkfSRUoPHaRxUIdXy1ZoZJl+/pi5nX+flFM=;
        b=cnVhI0QwT9xGX7xIg5TQ/AK6cqshkaJYguQ8mGqCgZgYFI3Aayab/tB9k6SK17ay0Uvrnz
        BhF0oqR5XjOKl3zcTQiAVpLWznp29Ahhkt1IAmE3Kti1ortWjosp7StxX7k5UDCnIufhZ4
        zmbAtRqPEAuElpvL4/k2msDehyMQKJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-5IMCXbJRO121tFcv9_PgTA-1; Sun, 01 Mar 2020 13:31:45 -0500
X-MC-Unique: 5IMCXbJRO121tFcv9_PgTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAF55100550E;
        Sun,  1 Mar 2020 18:31:42 +0000 (UTC)
Received: from krava (ovpn-204-60.brq.redhat.com [10.40.204.60])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAF7B399;
        Sun,  1 Mar 2020 18:31:32 +0000 (UTC)
Date:   Sun, 1 Mar 2020 19:31:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 04/18] bpf: Add name to struct bpf_ksym
Message-ID: <20200301183130.GA165525@krava>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-5-jolsa@kernel.org>
 <CAPhsuW5u=6MEWKU4-Cfdr3VfYn+NuTgX6SezC_W33WZsM3j8ng@mail.gmail.com>
 <20200227085002.GC34774@krava>
 <CAPhsuW78oZ=g51B55z0etMzYyotztFC+4kMaYPOUaMVD-=mOvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW78oZ=g51B55z0etMzYyotztFC+4kMaYPOUaMVD-=mOvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 10:59:57AM -0800, Song Liu wrote:
> On Thu, Feb 27, 2020 at 12:50 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Feb 26, 2020 at 01:14:43PM -0800, Song Liu wrote:
> > > On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding name to 'struct bpf_ksym' object to carry the name
> > > > of the symbol for bpf_prog, bpf_trampoline, bpf_dispatcher.
> > > >
> > > > The current benefit is that name is now generated only when
> > > > the symbol is added to the list, so we don't need to generate
> > > > it every time it's accessed.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >
> > > The patch looks good. But I wonder whether we want pay the cost of
> > > extra 128 bytes per bpf program. Maybe make it a pointer and only
> > > generate the string when it is first used?
> >
> > I thought 128 would not be that bad, also the code is quite
> > simple because of that.. if that's really a concern I could
> > make the changes, but that would probably mean changing the
> > design
> 
> I guess this is OK. We can further optimize it if needed.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
>

ok, thanks for the review, I still have to make some changes,
so I'll keep your acked-by on patches that won't be changed,
please scream otherwise ;-)

thanks,
jirka

