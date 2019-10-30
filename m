Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCBBE9A95
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 12:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfJ3LGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 07:06:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726082AbfJ3LGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 07:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572433568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7I2LBO3foUDB/5ZE0ixnicShI637mLGxaYmf81WNPQ=;
        b=IHq16m9/aUjFUPv9mcA18IB44R7q5phqeOhSFSGV3yWS0fJ7DhHYuqZ8dmckoMh4F1CrW3
        h08ruOatbF7OA1TPEInm/pVOSoFQhX7uWmqf8NpPH+NPnizDkF1EBmm+u/Uimj7P8CW/QA
        Ecq4OjrUktjRf4hB5NoFjIabw0gTQJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-17shLM9zMgO_atjVng0yAw-1; Wed, 30 Oct 2019 07:06:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2E751800DFD;
        Wed, 30 Oct 2019 11:06:03 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D715710016DA;
        Wed, 30 Oct 2019 11:05:52 +0000 (UTC)
Date:   Wed, 30 Oct 2019 12:05:51 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: Compile build issues with samples/bpf/ again
Message-ID: <20191030120551.68f8b67b@carbon>
In-Reply-To: <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
References: <20191030114313.75b3a886@carbon>
        <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 17shLM9zMgO_atjVng0yAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 11:53:21 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On Wed, 30 Oct 2019 at 11:43, Jesper Dangaard Brouer <brouer@redhat.com> =
wrote:
> >
> > Hi Maintainers,
> >
> > It is annoy to experience that simply building kernel tree samples/bpf/
> > is broken as often as it is.  Right now, build is broken in both DaveM
> > net.git and bpf.git.  ACME have some build fixes queued from Bj=C3=B6rn
> > T=C3=B6pel. But even with those fixes, build (for samples/bpf/task_fd_q=
uery_user.c)
> > are still broken, as reported by Eric Sage (15 Oct), which I have a fix=
 for.
> > =20
>=20
> Hmm, something else than commit e55190f26f92 ("samples/bpf: Fix build
> for task_fd_query_user.c")?

I see, you already fixed this... and it is in the bpf.git tree.

Then we only need your other fixes from ACME's tree.  I just cloned a
fresh version of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
to check that 'make M=3Dsamples/bpf' still fails.


> > Could maintainers add building samples/bpf/ to their build test scripts=
?
> > (make headers_install && make M=3Dsamples/bpf)
> >
> > Also I discovered, the command to build have also recently changed:
> > - Before : make samples/bpf/   or  simply make in subdir samples/bpf/
> > - new cmd: make M=3Dsamples/bpf  and in subdir is broken
> >
> > Anyone knows what commit introduced this change?
> > (I need it for a fixes tag, when updating README.rst doc)

The make cmdline change is confusing, because the old command
'make samples/bpf/' reports success (remember last '/') ... this could
be why maintainers are not catching this.

See: old make cmd

 $ touch samples/bpf/*kern.c
 $ make samples/bpf/
   CALL    scripts/checksyscalls.sh
   CALL    scripts/atomic/check-atomics.sh
   DESCEND  objtool
 $


New make cmd fails:

$ make M=3Dsamples/bpf
samples/bpf/Makefile:209: WARNING: Detected possible issues with include pa=
th.
samples/bpf/Makefile:210: WARNING: Please install kernel headers locally (m=
ake headers_install).
  AR      samples/bpf/built-in.a
make -C /home/hawk/git/kernel/bpf/samples/bpf/../../tools/lib/bpf/ RM=3D'rm=
 -rf' LDFLAGS=3D srctree=3D/home/hawk/git/kernel/bpf/samples/bpf/../../ O=
=3D
  HOSTCC  samples/bpf/test_lru_dist
  HOSTCC  samples/bpf/sock_example
  HOSTCC  samples/bpf/fds_example.o
  HOSTLD  samples/bpf/fds_example
  HOSTCC  samples/bpf/sockex1_user.o
  HOSTLD  samples/bpf/sockex1
  HOSTCC  samples/bpf/sockex2_user.o
  HOSTLD  samples/bpf/sockex2
  HOSTCC  samples/bpf/bpf_load.o
  HOSTCC  samples/bpf/sockex3_user.o
  HOSTLD  samples/bpf/sockex3
/usr/bin/ld: samples/bpf/bpf_load.o: in function `do_load_bpf_file.part.2':
bpf_load.c:(.text+0x91a): undefined reference to `test_attr__enabled'
/usr/bin/ld: bpf_load.c:(.text+0x1403): undefined reference to `test_attr__=
open'
collect2: error: ld returned 1 exit status
make[1]: *** [scripts/Makefile.host:116: samples/bpf/sockex3] Error 1
make: *** [Makefile:1649: samples/bpf] Error 2

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

