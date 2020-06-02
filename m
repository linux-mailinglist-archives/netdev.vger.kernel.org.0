Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CAB1EB71A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFBINw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:13:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725811AbgFBINw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591085631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jKAG7zojW7jlju7CxcnAk+lwgOINaIpv7z+cKAhjErs=;
        b=aNi1/+/ZmKhZ5A7hSAWx4jNmuC+kS9K0Znl4oziWj8Ogj/AgwmAwvWolxG1UzX4zzvRRNj
        qgMjcQWXj+H8q+GmqT0fJQNCCfUnXOIPnZsOpFfJRRu6aFRCPnuLmGkYbUvGRguPbjOPpV
        7Wq1EzOkIbTcuh2hbR77rinuINUlB7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-LYYUxxwnMoO3sfugYEMIzQ-1; Tue, 02 Jun 2020 04:13:46 -0400
X-MC-Unique: LYYUxxwnMoO3sfugYEMIzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E85DE461;
        Tue,  2 Jun 2020 08:13:43 +0000 (UTC)
Received: from krava (unknown [10.40.195.39])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5417C7E7E6;
        Tue,  2 Jun 2020 08:13:40 +0000 (UTC)
Date:   Tue, 2 Jun 2020 10:13:39 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpf: Use tracing helpers for lsm programs
Message-ID: <20200602081339.GA1112120@krava>
References: <20200531154255.896551-1-jolsa@kernel.org>
 <CAPhsuW7HevOVgEe-g3RH_OmRqzWedXzGkuoNNzJfSwKhtzGxFw@mail.gmail.com>
 <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJquAF=XOjbyj-xmKupyCa=5O76QXWf6Pjq+j+dTvaEpg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 03:12:13PM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 1, 2020 at 12:00 PM Song Liu <song@kernel.org> wrote:
> >
> > On Sun, May 31, 2020 at 8:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Currenty lsm uses bpf_tracing_func_proto helpers which do
> > > not include stack trace or perf event output. It's useful
> > > to have those for bpftrace lsm support [1].
> > >
> > > Using tracing_prog_func_proto helpers for lsm programs.
> >
> > How about using raw_tp_prog_func_proto?
> 
> why?
> I think skb/xdp_output is useful for lsm progs too.
> So I've applied the patch.

right, it's also where d_path will be as well

> 
> > PS: Please tag the patch with subject prefix "PATCH bpf" for
> > "PATCH bpf-next". I think this one belongs to bpf-next, which means
> > we should wait after the merge window.

I must have missed info about that,
thanks for info

> 
> +1.
> Jiri,
> pls tag the subject properly.

will do, sry

thanks,
jirka

