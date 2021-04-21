Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52A367351
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbhDUTTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236152AbhDUTTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 15:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619032743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pRVP1W0iITlIP4ujNjLNfbbCnRnIJxXMkOVM3pr1dLA=;
        b=ON3eyGunGIUVBbFaUV2ERqzM1zXAeeHiVtkaE/t88x7nkE/r/RP1/hjKyAWMPzUISY4gIJ
        5ciY+O/8LtLyovLRgyL4Q/qbQHh+VgKMjuIYHvvX8MB7jhp5qPp4ZmmYAI2dQKmXqf0XBp
        y0Hte6A9ynuiChXNrp2rp5pdDu9yLPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-YHSZrK4ENPKkAQhE9xuexw-1; Wed, 21 Apr 2021 15:18:53 -0400
X-MC-Unique: YHSZrK4ENPKkAQhE9xuexw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1829584B9A3;
        Wed, 21 Apr 2021 19:18:51 +0000 (UTC)
Received: from krava (unknown [10.40.195.227])
        by smtp.corp.redhat.com (Postfix) with SMTP id CC7B25C1B4;
        Wed, 21 Apr 2021 19:18:43 +0000 (UTC)
Date:   Wed, 21 Apr 2021 21:18:42 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
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
Message-ID: <YIB6kr1fb5VvK5H4@krava>
References: <20210415170007.31420132@gandalf.local.home>
 <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home>
 <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
 <YH8GxNi5VuYjwNmK@krava>
 <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
 <YIArVa6IE37vsazU@krava>
 <20210421100541.3ea5c3bf@gandalf.local.home>
 <CAEf4BzaYEOqVYBaxVSs8p6Nmy_giztaxTX9DtDk4N77NzsHbDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaYEOqVYBaxVSs8p6Nmy_giztaxTX9DtDk4N77NzsHbDQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:52:11AM -0700, Andrii Nakryiko wrote:
> On Wed, Apr 21, 2021 at 7:05 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 21 Apr 2021 15:40:37 +0200
> > Jiri Olsa <jolsa@redhat.com> wrote:
> >
> 
> [...]
> 
> >
> > >
> > > perhaps this is a good topic to discuss in one of the Thursday's BPF mtg?
> >
> > I'm unaware of these meetings.
> 
> We have BPF office hours weekly meetings every Thursday at 9am PDT.
> There is a spreadsheet ([0]) in which anyone can propose a topic for
> deeper discussion over Zoom. I've already added the topic for the
> discussion in this thread. It would be great if you and Jiri could
> join tomorrow. See the first tab in the spreadsheet for Zoom link.
> Thanks!
> 
>   [0] https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=883029154

great, I can come

thanks,
jirka

> 
> >
> >
> > -- Steve
> 

