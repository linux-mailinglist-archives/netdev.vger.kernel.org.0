Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA0E13FC51
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbgAPWnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:43:55 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40943 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732417AbgAPWny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:43:54 -0500
Received: by mail-qt1-f194.google.com with SMTP id v25so20322462qto.7;
        Thu, 16 Jan 2020 14:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6V4rDJ8GQ9BDhz/SQaLpqohATNzavITKDId73kmv48o=;
        b=n2OjqhSJc8YoIFY9twmO5Z5tXsxdcAZh5Qi6fB3j43J3mTV128YZjiL0eGIudHd4d6
         Ki1uHthOo53TfRpXzq+CASThGj17ABxGtQv7g+CIWOTiI2ap6c6wgFpe6GqtRaZDbvjd
         IwRHkx0wrLFBV7X4cURvaZXykCQb4ajm+OdLusPqa7zhe2aEucczFNw4TGNZl9Ra4+V7
         o/NwphiUivETpcDOvRLsGjyv9PQg6HKoogNx4vtI/gQxyk2/wIGt4d8wG6uga6urD+EC
         36C/t+RYhZ7LK+g/0G11g2YfoadULNmV9hIK1d7Kpld7KxhAJbu7Q8WAlEJc07H0i7zB
         o5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6V4rDJ8GQ9BDhz/SQaLpqohATNzavITKDId73kmv48o=;
        b=DVpbPx6LCq0rTeE1yQzzKRBsvQ1onUexU54SseEk3BdOv5/SMNnT1G6d5VICyXlX2S
         DU+KOayFumfAZcLxwFKFvNND/Qmu1/3rqvKmQC4GFQW8NFf2ImR11tpHt8OIGOrRqGqa
         J5BTRq/W57nEQ2pQZYE/Wc+Lnujd26TU/KKLP+UmevOGlxURwYHg8ppw2kTC/QnKg/lR
         h5eX62mOaOvOeJlX4vaOcPLjE+PLjTuu/44LZoiBR9B4oLZr7B2XGyZdmZJFslLZJRnR
         no1lc0fwSTghuHufIBHf1gShDihKrixcMV8HxfJZ9t4TV0hAIujqHJmvf/Z0LKZt2GoB
         JWBA==
X-Gm-Message-State: APjAAAVcYfmT1mlP77n1Sh9rIMtSUgbJmqiEwSPS/XOSVRsiWwaYimR3
        G+u+JIaqDtxUooavJNGwsjqgLCgibHSTq0+PBXk=
X-Google-Smtp-Source: APXvYqyRayvo4tT12kkQjmEE+9/BQV1hXR5rtzKk0t7oWHkLzEunvItYZ+Yg7d7QGOKguy9IFk/alBlDIDWiuD51Vzk=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr4780186qtj.117.1579214633217;
 Thu, 16 Jan 2020 14:43:53 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918094400.1357254.5646603555325507261.stgit@toke.dk>
In-Reply-To: <157918094400.1357254.5646603555325507261.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:43:42 -0800
Message-ID: <CAEf4BzbckO_J=kYQD0MnxD+k-APYvxth_ARuEenyAx73+LhtKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 11/11] libbpf: Fix include of bpf_helpers.h
 when libbpf is installed on system
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 5:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The change to use angled includes for bpf_helper_defs.h breaks compilatio=
n
> against libbpf when it is installed in the include path, since the file i=
s
> installed in the bpf/ subdirectory of $INCLUDE_PATH. Since we've now fixe=
d
> the selftest Makefile to not require this anymore, revert back to
> double-quoted include so bpf_helpers.h works regardless of include path.
>
> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken f=
rom selftests dir")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 050bb7bf5be6..f69cc208778a 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -2,7 +2,7 @@
>  #ifndef __BPF_HELPERS__
>  #define __BPF_HELPERS__
>
> -#include <bpf_helper_defs.h>
> +#include "bpf_helper_defs.h"
>
>  #define __uint(name, val) int (*name)[val]
>  #define __type(name, val) typeof(val) *name
>
