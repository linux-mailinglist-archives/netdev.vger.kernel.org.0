Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5825A13C73A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAOPS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:18:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728961AbgAOPS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579101538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O28pugdE3ji8Z7d58Dp1KejMSWnJ7EsYgUczW6n+9NY=;
        b=F69sbxVl2NEsx/ned4ezVnMKCxGPSrNFIiYJ/XZoSnTdymVkEJF/LdY0lMfcbTVUobZo3g
        H0OWjArCJGolmqd/hXkUbqyvFEWjap7E+Cnue/czGNmt5tFitwkBxSErAeB+mmtFKIYLvV
        u381+/3cNNLHk0FNETQoFkxhZATMfqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-q6bYgGs4Pb6_ldebLaXl3g-1; Wed, 15 Jan 2020 10:18:54 -0500
X-MC-Unique: q6bYgGs4Pb6_ldebLaXl3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F20318F8A0F;
        Wed, 15 Jan 2020 15:18:49 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1E6A66842;
        Wed, 15 Jan 2020 15:18:26 +0000 (UTC)
Date:   Wed, 15 Jan 2020 16:18:25 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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
Subject: Re: [PATCH bpf-next v2 07/10] samples/bpf: Use consistent include
 paths for libbpf
Message-ID: <20200115161825.351ebf23@carbon>
In-Reply-To: <157909757639.1192265.16930011370158657444.stgit@toke.dk>
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk>
        <157909757639.1192265.16930011370158657444.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 15:12:56 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> Fix all files in samples/bpf to include libbpf header files with the bpf/
> prefix, to be consistent with external users of the library. Also ensure
> that all includes of exported libbpf header files (those that are exported
> on 'make install' of the library) use bracketed includes instead of quote=
d.
>=20
> To make sure no new files are introduced that doesn't include the bpf/
> prefix in its include, remove tools/lib/bpf from the include path entirel=
y,
> and use tools/lib instead.
>=20
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

I like this change. Maybe the reason so many samples/bpf/ files
still included "libbpf.h" was that once-upon-a-time we had a "eBPF mini
library" in the file samples/bpf/libbpf.h that were included.

The file was removed/renamed in:
 https://git.kernel.org/torvalds/c/8d93045077ae

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

