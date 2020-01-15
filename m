Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC013B69C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 01:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOAqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 19:46:13 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43237 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728795AbgAOAqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 19:46:13 -0500
Received: by mail-qt1-f196.google.com with SMTP id d18so14280122qtj.10;
        Tue, 14 Jan 2020 16:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4r1q77v2s7ZfbF1lFyj2jG69/QqX8a/sPqCqv9z2TU=;
        b=Q+w4ML/ESIMWpC1fZG7nIOe9piH9hK34vUOcI8ptwCey5nH6SbQlk5tHgbWYxIaFOv
         V7gl3m21RueWZT/+6K3zxOzv+g1Q/CbFb7YcmeGFkFBUW4yGpHZO2uqml3CbqmLc8mKE
         +45q0e7j+uk3TJhBWYg7SU3+qQRuCW9Rbd5V39xiXv0+waCDCU17Fa3jkx8RZ85cgMKh
         /nmYxaOvN1XOrKKTNnmyBXYw1Ab55YCi5ebqHhJcgKQ91oo3/ekSmzt0Omn5ZL9Vthx6
         n400S3wrTWTGB/Unai40vvgO/cLKUVFu6vqccktt4w43/Z0RhK7QKuF0HRBgcynxLZai
         WRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4r1q77v2s7ZfbF1lFyj2jG69/QqX8a/sPqCqv9z2TU=;
        b=c/Al6pOm4PeiwtjilhM9mrzgoXXKQtn4bCKRXpgK+27Radz8bmUsTcC70GVNhL928q
         IFw/RgRai+cY5JJ0H4beLpjIZKjUbAZokZzi7bymqzW8yARaIFKLmbp8ETW62JoX+ZrP
         apMaoxlz5oVMv3sXPCkiepvjUn873NLaryyIxCV+rq2kDIh4N/e0TFKIJoSjkO6ZFoX6
         h2jDaIGnyfLFM6qTyDKYZZ+ZqiPqmUZ8OSXTYO29Zec0gFVcusgH57bpeN++6Fx1ihfR
         EBQaAJTfQHdTa9p4kUPxm1E1PDW/ykVgu8FDwD87wguw+rQoMAJqU5vPmzBHcqV+Ln8j
         PkKw==
X-Gm-Message-State: APjAAAVTy1kPKi9KzYnNohjMAezX8N5V452ZJxXYOccJKYDjw85Lwr5q
        ulFnXZz/R5pulJpo+4fpDXj9HX3HHyPuwj+W0D8=
X-Google-Smtp-Source: APXvYqzYhDU86soYONX1MrheBhLVTkosBXTthKd8IDn4NsNllcFetjABmRkonlmp4ewmsuRyXXZHOrRnMJcUgkIpLbc=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr1212274qtj.59.1579049171812;
 Tue, 14 Jan 2020 16:46:11 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-11-brianvv@google.com>
In-Reply-To: <20200114164614.47029-11-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 16:46:00 -0800
Message-ID: <CAEf4BzZvtHTJFQ1_Qdb+VFpaZmLqX+-Nd9g06qsXRC1cgBA5oA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 8:46 AM Brian Vazquez <brianvv@google.com> wrote:
>
> Tested bpf_map_lookup_batch() and bpf_map_update_batch()
> functionality.
>
>   $ ./test_maps
>       ...
>         test_array_map_batch_ops:PASS
>       ...
>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../bpf/map_tests/array_map_batch_ops.c       | 131 ++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
>
> diff --git a/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> new file mode 100644
> index 0000000000000..05b7caea6a444
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <errno.h>
> +#include <string.h>
> +
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#include <test_maps.h>
> +
> +static void map_batch_update(int map_fd, __u32 max_entries, int *keys,
> +                            int *values)
> +{
> +       int i, err;
> +
> +       DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,

Here, below, and in other patch: DECLARE_LIBBPF_OPTS declares a local
variable, so it shouldn't be separated from all the other variable
declarations.


> +               .elem_flags = 0,
> +               .flags = 0,
> +       );
> +

[...]
