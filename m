Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512E726FA82
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIRKWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgIRKWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600424561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6YHTNcXUDMlGUX4+EWozNlgqZItEXQQ/C2QXIGAw5zg=;
        b=FDOaEJ752s9EwQY1Gd+qDIAdRFIjiRIrpJ044fwaA+z8v/8sPQCOm7wp0rYMd3hMNLM3fH
        ndd09yWZWz5sLJvGCezZKL9xWQ3gqurPDaZuE/A8siD7skUNgTPuZrOm3mOmNClLk6BIPl
        EFuUbXT/dZSroUgL1WgGa4vgLlkpeqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-LdbWP44DP4a_iJLv7Yn2zA-1; Fri, 18 Sep 2020 06:22:37 -0400
X-MC-Unique: LdbWP44DP4a_iJLv7Yn2zA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6680780B702;
        Fri, 18 Sep 2020 10:22:35 +0000 (UTC)
Received: from krava (ovpn-114-24.ams2.redhat.com [10.36.114.24])
        by smtp.corp.redhat.com (Postfix) with SMTP id B70CF5DA30;
        Fri, 18 Sep 2020 10:22:32 +0000 (UTC)
Date:   Fri, 18 Sep 2020 12:22:31 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix stat probe in d_path test
Message-ID: <20200918102231.GE2514666@krava>
References: <20200916112416.2321204-1-jolsa@kernel.org>
 <20200917014531.lmpkorybofrggte4@ast-mbp.dhcp.thefacebook.com>
 <20200917082516.GD2411168@krava>
 <CAADnVQ+o-0hoiJ5SBDXOuJ2MKJkTmsOxh60z61+_ZZ+8_=DhrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+o-0hoiJ5SBDXOuJ2MKJkTmsOxh60z61+_ZZ+8_=DhrA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 02:14:38PM -0700, Alexei Starovoitov wrote:
> On Thu, Sep 17, 2020 at 1:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > > Ideally resolve_btfids would parse dwarf info and check
> > > whether any of the funcs in allowlist were inlined.
> > > That would be more reliable, but not pretty to drag libdw
> > > dependency into resolve_btfids.
> >
> > hm, we could add some check to perf|bpftrace that would
> > show you all the places where function is called from and
> > if it was inlined or is a regular call.. so user is aware
> > what probe calls to expect
> 
> The check like this belongs in some library,
> but making libbpf depend on dwarf is not great.
> I think we're at the point where we need to break libbpf
> into many libraries. This one could be called libbpftrace.
> It would potentially include symbolizer and other dwarf
> related operations.

ok

> Such inlining check would be good to do not only for d_path
> allowlist, but for any kprobe/fentry function.

yes, that's what I meant

jirka

