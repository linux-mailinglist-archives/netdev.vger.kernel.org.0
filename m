Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3942A7009
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgKDV7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:59:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731816AbgKDV5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604527050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E5IqHrH37CcWuZxfcN+Bbgnd4Rr8d3Jv0MOGStlqrgg=;
        b=BVy36e/ozp2T9bS71aKmWfc5FLM83uVU6VAERx/uFr7V8/Z6aWWmZUpmYfeQy+Y6pGd5wL
        EqIPvEklEiWMONO7VcfeW18Fh0Gf/YZZUUW5TcAKX1gKTE8+1CqXjGRHv1sD1YKxFmNORe
        qEoHgvvPV7JBDSbuIJiBixWKgnA2H5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-ZvviV608OBCMdFNMZgxWIg-1; Wed, 04 Nov 2020 16:57:28 -0500
X-MC-Unique: ZvviV608OBCMdFNMZgxWIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B1FD184214D;
        Wed,  4 Nov 2020 21:57:26 +0000 (UTC)
Received: from krava (unknown [10.40.192.71])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4BD326266E;
        Wed,  4 Nov 2020 21:57:24 +0000 (UTC)
Date:   Wed, 4 Nov 2020 22:57:23 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
Message-ID: <20201104215723.GL3861143@krava>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
 <20201013195622.GB1305928@krava>
 <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
 <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
 <561A9F0C-BDAE-406A-8B93-011ECAB22B1C@fb.com>
 <20201104164215.GH3861143@krava>
 <CAEf4BzacV0TpXSk4giLKmLBCvARH-Jpgp6Pa5br2wHO3_A2-9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzacV0TpXSk4giLKmLBCvARH-Jpgp6Pa5br2wHO3_A2-9w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 12:50:25PM -0800, Andrii Nakryiko wrote:
> On Wed, Nov 4, 2020 at 8:46 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 15, 2020 at 06:09:14AM +0000, Song Liu wrote:
> > >
> > >
> > > > On Oct 13, 2020, at 2:56 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > [...]
> > >
> > > >
> > > > I'd go with Kconfig + bpf_core_enum_value(), as it's shorter and
> > > > nicer. This compiles and works with my Kconfig, but I haven't checked
> > > > with CONFIG_CGROUP_PIDS defined.
> > >
> > > Tested with CONFIG_CGROUP_PIDS, it looks good.
> > >
> > > Tested-by: Song Liu <songliubraving@fb.com>
> >
> > hi,
> > I still need to apply my workaround to compile tests,
> > so I wonder this fell through cracks
> 
> 
> The fix was already applied ([0]). Do you still see issues?
> 
>   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201022202739.3667367-1-andrii@kernel.org/

nope, it's working now, I was on the wrong branch, sry for noise

thanks,
jirka

