Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDA5334A5C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhCJWBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbhCJWA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:00:59 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F435C061574;
        Wed, 10 Mar 2021 14:00:59 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id m9so19530061ybk.8;
        Wed, 10 Mar 2021 14:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/StaUZQ+CAb4VUH79k623QJzl3pky5FxKv1ddOiOQpE=;
        b=TSBfW9KWLinAtMJySInVFkMQpYc7Zskg3TzMkYSt8AGVi29yDbMmsVyVcbSY4rlLmx
         FUL10OBKURvcrIL9Kv0RR0RWpafEU5bJ0fxbeOnYDW2j0Ke9OjrnJHecfFE2b5VG/PrT
         PIZcnw1I/ScsHcMhhBP/5DMJ3/gV37b/7a4XWhkxGO8VsuxIkdM5tkjRzXh0xa+XZ01W
         qNeprI/D2ahfKPojm35F168QhMMBKq0HvU8ssNt82zBNG+40Z7sH80BRC+LBURm8sL1n
         vyltoDG00hDtSyStfqriB8TzpoNo2aMv9NtBoZSdV4O0pWXKptD+A5pzjmIQjte+/aIh
         pI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/StaUZQ+CAb4VUH79k623QJzl3pky5FxKv1ddOiOQpE=;
        b=fZKt55YdsVK5SnuUy6nXvnGHiF9TlzCJpgz5vkLthsB/ukTJpVuP3/TIEAKfoW5htC
         265yA9t9Dzk/WL2a+GLZKG5SZQmRPzq8ZL1T7kYGoi9GIr1OlcDOzepweAQLxNskARIR
         VB1yUDV8RwfO8nqAULyZ+jGpHd+RTsVCsixwM+SzAlMW7xDlRRHvA8Dlo5ciEF4VXEsQ
         s2ATpmHJXcsaYdGqIth4XdlmZAP58cpWa4Fd5E2398QFgX7Vdid0RKTnR8LGIQRYRgCE
         HEEesBk/P+QiixKV21tlnyFzJkE1sPuoSQbjN2qr3y6OlFPATbB/anSmswr/HxXw06tu
         2bSA==
X-Gm-Message-State: AOAM530jwJixIx5oGMXQatI5yP60IK7oPjo6HxoKB7YFuWnIIx9gnUW3
        of905VdGZgyPNpY+mMdR9Ejr6ArTDdoChVKqweE=
X-Google-Smtp-Source: ABdhPJzDtTZ1xjvGkQfnIr2ZgoWqj82t19wyzQzCXfJcXVcfy2FJR4ez+9oNxXQFxYAECCKuQqUbjWj4IyYAh/StABE=
X-Received: by 2002:a25:37c4:: with SMTP id e187mr7442658yba.347.1615413658911;
 Wed, 10 Mar 2021 14:00:58 -0800 (PST)
MIME-Version: 1.0
References: <20210310080929.641212-1-bjorn.topel@gmail.com> <20210310080929.641212-3-bjorn.topel@gmail.com>
In-Reply-To: <20210310080929.641212-3-bjorn.topel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Mar 2021 14:00:48 -0800
Message-ID: <CAEf4BzYPDF87At4=_gsndxof84OiqyJxgAHL7_jvpuntovUQ8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] libbpf: xsk: move barriers from
 libbpf_util.h to xsk.h
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 12:09 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The only user of libbpf_util.h is xsk.h. Move the barriers to xsk.h,
> and remove libbpf_util.h. The barriers are used as an implementation
> detail, and should not be considered part of the stable API.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  tools/lib/bpf/Makefile      |  1 -
>  tools/lib/bpf/libbpf_util.h | 82 -------------------------------------
>  tools/lib/bpf/xsk.h         | 68 +++++++++++++++++++++++++++++-
>  3 files changed, 67 insertions(+), 84 deletions(-)
>  delete mode 100644 tools/lib/bpf/libbpf_util.h
>

[...]

> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index a9fdea87b5cd..1d846a419d21 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -4,6 +4,7 @@
>   * AF_XDP user-space access library.
>   *
>   * Copyright(c) 2018 - 2019 Intel Corporation.

Couldn't unsee ^this mismatch. Added space there.

Also, removing libbpf_util.h caused incremental build failure for the
kernel due to cached dependency files. make clean solved the issue. So
just FYI for everyone.

Applied to bpf-next, thanks.

> + * Copyright (c) 2019 Facebook
>   *
>   * Author(s): Magnus Karlsson <magnus.karlsson@intel.com>
>   */
> @@ -13,15 +14,80 @@
>
>  #include <stdio.h>
>  #include <stdint.h>
> +#include <stdbool.h>
>  #include <linux/if_xdp.h>
>
>  #include "libbpf.h"
> -#include "libbpf_util.h"
>
>  #ifdef __cplusplus
>  extern "C" {
>  #endif
>

[...]
