Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F4A1FFCBB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbgFRUk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732312AbgFRUku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:40:50 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB1DC06174E;
        Thu, 18 Jun 2020 13:40:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id t9so8724724ioj.13;
        Thu, 18 Jun 2020 13:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CVfEDBcb6P1X9UPlG8iy7eKwin490vsgsKNHIJnNkzk=;
        b=m5mKOPplUNdO+yrGpP+GLCFZ4eZY1ytfeCiJf1ndJz4xs0GgkSWxZuNOmK915BXp47
         sI/xJZGA8pKZM09TWX1zIwCvfv8VvoPpRcZ6teBtrksuNwm0wAmrebQ2WZWrnWAILsxu
         9+RDgDspLdm2q/vTs6bnIUTDal5qvCjfoDuZ5lTGkeA0vfVKN3P4LoAEmSKofPV/WGWP
         USgnk8caV6F1BQ1sem+jMXjV4V7iXQqvI78TyE3H4mWIscj7AJ9kSKnZzY2hVi4FWX0p
         PylgoAForxJgtMXJL1O4btEUuZCu0FJmQVivsI9Whb6qjJW51P7/1dcLnZWEwmdGncDu
         wZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CVfEDBcb6P1X9UPlG8iy7eKwin490vsgsKNHIJnNkzk=;
        b=TWyRy172niqTrLfjaO6vnqC62LhNzY+MB0IWg5YF06BklFs9/iIz8KUDM/DpKadjVv
         hB+4tBmovTPbFKqXcMKYAodS6i6oABB8/j9//AbOHHKGXm8TPJwzIvNOja+artjpw7wA
         1qi7sxqfASDAO9Skr7QLXOU1HJdsojnZuZOmZfh6nh1kchwEBb116YFi2a4EqoA5cJ4P
         W3eLkWGtzx2EXCCAjFeMvQ3p5OMOlKQMVhR09j24AnJyyUhkaUc+lCGwVgsfzxLvd7qL
         mzp1uH99VVI/bPAR8SXN8d/XVCt9AMGMezY1HXttBgseMmQh0/hXsLxjePSMu+cXgDn1
         iQfQ==
X-Gm-Message-State: AOAM531RidXqBPe2zcnquCQymQpTmDRw95S8B5a/ZUtjgbk/u7BONCuP
        SEItxAj9MpdPGhpZPuAVHyk=
X-Google-Smtp-Source: ABdhPJyG+eHEb4WVHXY5HOBhhe2R4cY2/6gIo69dDbDHFg62DcMD/c1NyNzZW0yi3F41Ug7LQlgsCg==
X-Received: by 2002:a02:3908:: with SMTP id l8mr408111jaa.121.1592512849282;
        Thu, 18 Jun 2020 13:40:49 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h13sm2047362ile.18.2020.06.18.13.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 13:40:48 -0700 (PDT)
Date:   Thu, 18 Jun 2020 13:40:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <5eebd1486e46b_6d292ad5e7a285b817@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616100512.2168860-3-jolsa@kernel.org>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-3-jolsa@kernel.org>
Subject: RE: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> The btfid tool will be used during the vmlinux linking,
> so it's necessary it's ready for it.
> =

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile           | 22 ++++++++++++++++++----
>  tools/Makefile     |  3 +++
>  tools/bpf/Makefile |  5 ++++-
>  3 files changed, 25 insertions(+), 5 deletions(-)

This breaks the build for me. I fixed it with this but then I get warning=
s,

diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
index 7cdf39bfb150..3697e8ae9efa 100644
--- a/tools/bpf/btfid/btfid.c
+++ b/tools/bpf/btfid/btfid.c
@@ -48,7 +48,7 @@
 #include <errno.h>
 #include <linux/rbtree.h>
 #include <linux/zalloc.h>
-#include <btf.h>
+#include <linux/btf.h>
 #include <libbpf.h>
 #include <parse-options.h>

Here is the error. Is it something about my setup? bpftool/btf.c uses
<btf.h>. Because this in top-level Makefile we probably don't want to
push extra setup onto folks.

In file included from btfid.c:51:
/home/john/git/bpf-next/tools/lib/bpf/btf.h: In function =E2=80=98btf_is_=
var=E2=80=99:
/home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: error: =E2=80=98BTF_K=
IND_VAR=E2=80=99 undeclared (first use in this function); did you mean =E2=
=80=98BTF_KIND_PTR=E2=80=99?
  return btf_kind(t) =3D=3D BTF_KIND_VAR;
                        ^~~~~~~~~~~~
                        BTF_KIND_PTR
/home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: note: each undeclared=
 identifier is reported only once for each function it appears in
/home/john/git/bpf-next/tools/lib/bpf/btf.h: In function =E2=80=98btf_is_=
datasec=E2=80=99:
/home/john/git/bpf-next/tools/lib/bpf/btf.h:259:24: error: =E2=80=98BTF_K=
IND_DATASEC=E2=80=99 undeclared (first use in this function); did you mea=
n =E2=80=98BTF_KIND_PTR=E2=80=99?
  return btf_kind(t) =3D=3D BTF_KIND_DATASEC;
                        ^~~~~~~~~~~~~~~~
                        BTF_KIND_PTR
mv: cannot stat '/home/john/git/bpf-next/tools/bpf/btfid/.btfid.o.tmp': N=
o such file or directory
make[3]: *** [/home/john/git/bpf-next/tools/build/Makefile.build:97: /hom=
e/john/git/bpf-next/tools/bpf/btfid/btfid.o] Error 1
make[2]: *** [Makefile:59: /home/john/git/bpf-next/tools/bpf/btfid/btfid-=
in.o] Error 2
make[1]: *** [Makefile:71: bpf/btfid] Error 2
make: *** [Makefile:1894: tools/bpf/btfid] Error 2=
