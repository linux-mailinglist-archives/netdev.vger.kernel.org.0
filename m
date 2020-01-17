Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3B1405AE
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 09:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAQI5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 03:57:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727531AbgAQI5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 03:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579251462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wGVm7vGifojmQs18rmKxAMnZ1ofaqDbsZAnJ2KgVM8=;
        b=Hpa1waJg3pWgyJUUwnFoVgr+6YPLUlNAa3TUfN1efXEe9fEgcPWx6lZkQBLm74gDbjlTJn
        h8RS9O3FJm6D0fFz9w+noq3LrNU1uf5jDZUVR/r5NKVhnIWORBTmqEu11q8NRLIV9mvJE2
        PUo2yZGDKMleomRLLHm3MBlrgrvRzMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-bAqU4dETMIa9LQgbw4bJAg-1; Fri, 17 Jan 2020 03:57:40 -0500
X-MC-Unique: bAqU4dETMIa9LQgbw4bJAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F022BDB60;
        Fri, 17 Jan 2020 08:57:36 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A8219C5B;
        Fri, 17 Jan 2020 08:57:24 +0000 (UTC)
Date:   Fri, 17 Jan 2020 09:57:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 00/11] tools: Use consistent libbpf include
 paths everywhere
Message-ID: <20200117095721.0030f414@carbon>
In-Reply-To: <20200117041431.h7vvc32fungenyhg@ast-mbp.dhcp.thefacebook.com>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
        <20200117041431.h7vvc32fungenyhg@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 20:14:32 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Jan 16, 2020 at 02:22:11PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > The recent commit 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.=
h are
> > taken from selftests dir") broke compilation against libbpf if it is in=
stalled
> > on the system, and $INCLUDEDIR/bpf is not in the include path.
> >=20
> > Since having the bpf/ subdir of $INCLUDEDIR in the include path has nev=
er been a
> > requirement for building against libbpf before, this needs to be fixed.=
 One
> > option is to just revert the offending commit and figure out a differen=
t way to
> > achieve what it aims for.  =20
>=20
> The offending commit has been in the tree for a week. So I applied Andrii=
's
> revert of that change. It reintroduced the build dependency issue, but we=
 lived
> with it for long time, so we can take time to fix it cleanly.
> I suggest to focus on that build dependency first.
>=20
> > However, this series takes a different approach:
> > Changing all in-tree users of libbpf to consistently use a bpf/ prefix =
in
> > #include directives for header files from libbpf. =20
>=20
> I'm not sure it's a good idea. It feels nice, but think of a message we're
> sending to everyone. We will get spamed with question: does bpf community
> require all libbpf users to use bpf/ prefix ? What should be our answer?

The answer should be: Yes. When libbpf install the header files the are
installed under bpf/ prefix.  It is very confusing that samples and
selftests can include libbpf.h without this prefix. Even worse
including "bpf.h" pickup the libbpf version bpf/bpf.h, which have
caused confusion.  The only reason for the direct "libbpf.h" include is
historical, as there used-to-be a local file for that.


> Require or recommend? If require.. what for? It works as-is. If recommend=
 then
> why suddenly we're changing all files in selftests and samples?
> There is no good answer here. I think we should leave the things as-is.

I strongly believe we should correct this.  It doesn't make sense that
someone copying out a sample or selftests, into a git-submodule libbpf
(or distro installed libbpf-devel) have to understand that they have to
update the include path for all the libbpf header files.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

