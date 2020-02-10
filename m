Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C63156E20
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 04:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgBJDzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 22:55:46 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34752 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgBJDzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 22:55:46 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so3041328pfc.1;
        Sun, 09 Feb 2020 19:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1hdl3zXQuzvTzOpSwFv0DzMvM3jdmO2wtY8a4ACMwBE=;
        b=AVYS/QCbOgLafxUWR2eo1NN9s4tTx2ZviVKMzGgtueasDtKNHQ4FO/75rWkerTbqhX
         RErWRNKuP1Xlcu5/h8WeeGy+nJYEJ22kUi1yZQ0MfbJO5c4hx4SxQ8fyaJRdTx24mEmQ
         GXLleXnvXZIm1hUf/XQkOpTzVNRMjm0KzFKW9GI/MpXfVl1ldXbsHqtM/9AAl+QQNmsF
         K9VqOwiojjzDuCoApBhhAcM0rYOx+FgALRcXq3W+3xzFuPW2WfVwVdZsWtWqZjq5zFJK
         Dz69mbJfnvMklXaRgQoYlEE7CrK2Mu49wAuepxlo1qCvEPPK3PYgHU7sRSo+ul8qlvWG
         vjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1hdl3zXQuzvTzOpSwFv0DzMvM3jdmO2wtY8a4ACMwBE=;
        b=Q0ipDZHNKEoFfAmMAouH3ZmWz6cCgDuJSrUGuWs/Q+MBV0VM8Rv3ba95iJy5uBXV0e
         mBNloYebfvCkgyeyRP5t1yb+3f5T6Da6gUcLuj4OX2C8w87mkeiCxIkJgRoAzHXS9eE/
         BoxM6XOv7FXahzs3ZuGDqgCkRHHJYJA3d+dqLZ/CopGWfs6Qvm4TyKeNGZwfzpVUdJdz
         biex5hc8xZkVUXmut5D38Y/q4HuioNW7SzZEIfdaCWbwUHkqte9J6hixMl99EyNOm0Y/
         mMTGwDP3aBcdaOLAk7olvcjIkdqPCZOKrJdzPNFP4sB72nYuXabGA6OiJIVVh4e07D5g
         3AsQ==
X-Gm-Message-State: APjAAAVJH6J+vM7N1JrpnGlwmG4NEd3sIgPy79g3P/UYCklzQ5TBzdEQ
        9f7K4RqcmehlMTj01ewR7Yk=
X-Google-Smtp-Source: APXvYqy8Jfd7h9CyCdVNQX4s8gxY3HKuSKQdWUnJ8mbbC6NbOp3Om0CCnu/y/b7ABgRTz+OKj0M+ig==
X-Received: by 2002:a65:5549:: with SMTP id t9mr12188503pgr.439.1581306945446;
        Sun, 09 Feb 2020 19:55:45 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id dw10sm9619048pjb.11.2020.02.09.19.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 19:55:44 -0800 (PST)
Date:   Sun, 09 Feb 2020 19:55:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e40d43715474_2a9a2abf5f7f85c025@john-XPS-13-9370.notmuch>
In-Reply-To: <87eev3aidz.fsf@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-4-jakub@cloudflare.com>
 <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
 <87eev3aidz.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with
 a socket in it
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sun, Feb 09, 2020 at 03:41 AM CET, Alexei Starovoitov wrote:
> > On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> =
wrote:
> >>
> >> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tea=
r
> >> down") introduced sleeping issues inside RCU critical sections and w=
hile
> >> holding a spinlock on sockmap/sockhash tear-down. There has to be at=
 least
> >> one socket in the map for the problem to surface.
> >>
> >> This adds a test that triggers the warnings for broken locking rules=
. Not a
> >> fix per se, but rather tooling to verify the accompanying fixes. Run=
 on a
> >> VM with 1 vCPU to reproduce the warnings.
> >>
> >> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tea=
r down")
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >
> > selftests/bpf no longer builds for me.
> > make
> >   BINARY   test_maps
> >   TEST-OBJ [test_progs] sockmap_basic.test.o
> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_ba=
sic.c:
> > In function =E2=80=98connected_socket_v4=E2=80=99:
> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_ba=
sic.c:20:11:
> > error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in this =
function); did
> > you mean =E2=80=98TCP_REPAIR=E2=80=99?
> >    20 |  repair =3D TCP_REPAIR_ON;
> >       |           ^~~~~~~~~~~~~
> >       |           TCP_REPAIR
> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_ba=
sic.c:20:11:
> > note: each undeclared identifier is reported only once for each
> > function it appears in
> > /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_ba=
sic.c:29:11:
> > error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first use i=
n this function);
> > did you mean =E2=80=98TCP_REPAIR_OPTIONS=E2=80=99?
> >    29 |  repair =3D TCP_REPAIR_OFF_NO_WP;
> >       |           ^~~~~~~~~~~~~~~~~~~~
> >       |           TCP_REPAIR_OPTIONS
> >
> > Clearly /usr/include/linux/tcp.h is too old.
> > Suggestions?
> =

> Sorry for the inconvenience. I see that tcp.h header is missing under
> linux/tools/include/uapi/.

How about we just add the couple defines needed to sockmap_basic.c I don'=
t
see a need to pull in all of tcp.h just for a couple defines that wont
change anyways.

> =

> I have been building against my distro kernel headers, completely
> unaware of this. This is an oversight on my side.
> =

> Can I ask for a revert? I'm traveling today with limited ability to
> post patches.

I don't think we need a full revert.

> =

> I can resubmit the test with the missing header for bpf-next once it
> reopens.

If you are traveling I'll post a patch with the defines.=
