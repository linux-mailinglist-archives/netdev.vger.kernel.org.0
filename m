Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA1434258D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCSS6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:58:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhCSS6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616180297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pDVcUSuxN+AGx4nzch+V6p1eawpIf3wS5PvMlDH1DPI=;
        b=XXggucJPAT1NDPdgFflNzzzvjykcHuaO9PIQhOtc0EaEo6y8Iz0cjw9C07Fi693fHvTspf
        75AyJa4wnUTSeED4qvb0DUfjD/li5Gt65Ifhkr1xI9gdhsMEncWQgtW+EEya6hGDAP6iYE
        AQraD4P6ntw7BSbk3XE9ceQoojg8+es=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-36S8nsVTMcqeiOWzlWQ6zw-1; Fri, 19 Mar 2021 14:58:15 -0400
X-MC-Unique: 36S8nsVTMcqeiOWzlWQ6zw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCBE29CC00;
        Fri, 19 Mar 2021 18:58:13 +0000 (UTC)
Received: from krava (unknown [10.40.195.94])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2BD2110016FD;
        Fri, 19 Mar 2021 18:58:12 +0000 (UTC)
Date:   Fri, 19 Mar 2021 19:58:11 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
Message-ID: <YFT0Q+mVbTEI1rem@krava>
References: <20210318194036.3521577-1-andrii@kernel.org>
 <20210318194036.3521577-8-andrii@kernel.org>
 <YFTQExmhNhMcmNOb@krava>
 <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 11:39:01AM -0700, Andrii Nakryiko wrote:
> On Fri, Mar 19, 2021 at 9:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > +
> > > +     return NULL;
> > > +}
> > > +
> > > +static int linker_fixup_btf(struct src_obj *obj)
> > > +{
> > > +     const char *sec_name;
> > > +     struct src_sec *sec;
> > > +     int i, j, n, m;
> > > +
> > > +     n = btf__get_nr_types(obj->btf);
> >
> > hi,
> > I'm getting bpftool crash when building tests,
> >
> > looks like above obj->btf can be NULL:
> 
> I lost if (!obj->btf) return 0; somewhere along the rebases. I'll send
> a fix shortly. But how did you end up with selftests BPF objects built
> without BTF?

no idea.. I haven't even updated llvm for almost 3 days now ;-)

jirka

