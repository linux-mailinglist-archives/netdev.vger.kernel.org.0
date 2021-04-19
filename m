Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75339364C9C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242602AbhDSUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243545AbhDSUwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 16:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618865532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vIlLaTW2HU8DsnJAEsVpsAdmhbeVPpHFEcppC+CVot4=;
        b=FeOdIuK7DR3l/K6eZj/BgZTeKTAlaV3pFfGQn7nvQQWgsSetFF9gq1yDnN5Qla3YH7HXc/
        AZ6CPdolSAO5xTc5QIDSoVzuLz9sNbLONAT3cTXLZpdne2fOLp5JJeY8N2bac/d1JWYf4V
        2O9EL3VIy0PhvyUsAzNmGITNQWSbkWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-yVwC0uY_O-WiFFu19q4LZg-1; Mon, 19 Apr 2021 16:52:10 -0400
X-MC-Unique: yVwC0uY_O-WiFFu19q4LZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B06F107ACC7;
        Mon, 19 Apr 2021 20:51:51 +0000 (UTC)
Received: from krava (unknown [10.40.195.124])
        by smtp.corp.redhat.com (Postfix) with SMTP id 99F655D74B;
        Mon, 19 Apr 2021 20:51:47 +0000 (UTC)
Date:   Mon, 19 Apr 2021 22:51:46 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YH3tYorim6orajgT@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
 <YHh6YeOPh0HIlb3e@krava>
 <20210415141831.7b8fbe72@gandalf.local.home>
 <20210415142120.7427b4bd@gandalf.local.home>
 <YHi09yyqVEkZsn7p@krava>
 <20210415193032.34aec994@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415193032.34aec994@oasis.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 07:30:32PM -0400, Steven Rostedt wrote:
> On Thu, 15 Apr 2021 23:49:43 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> 
> > right, I quickly checked on that and it looks exactly like
> > the thing we need
> > 
> > I'll try to rebase that on the current code and try to use
> > it with the bpf ftrace probe to see how it fits
> > 
> > any chance you could plan on reposting it? ;-)
> 
> I'm currently working on cleaning up code for the next merge window,
> but I did go ahead and rebase it on top of my for-next branch. I didn't
> event try to compile it, but at least it's rebased ;-)
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> 
> Branch: ftrace/fgraph-multi

works nicely (with small compilation fixes)

I added support to call bpf program on the function exit using fgraph_ops
and it seems to work

now, it looks like the fgraph_ops entry callback does not have access
to registers.. once we have that, we could store arguments for the exit
callback and have all in place.. could this be added? ;-)

thanks,
jirka

