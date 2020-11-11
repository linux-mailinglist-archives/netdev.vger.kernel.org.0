Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A689B2AE79D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgKKEtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKEtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:49:08 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E980DC0613D1;
        Tue, 10 Nov 2020 20:49:06 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id i193so773294yba.1;
        Tue, 10 Nov 2020 20:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGhKnuXKAZIBN7UU5RqHCMQOESVmCKea2plzLKaGYKI=;
        b=oe8yyqzv8RF5OX9FkBiOV0q2mfOECXLwSpsfm3UPGRiLYFc7VTPRravP7it6csoYCR
         c4/Pg2AwWCjJHW/n72v6IygO9r1mB08WRczgO0j5/XTgJM+V5knJiaBrwAl1yt9MkbnV
         6nsLrvRuCBp+xW5okootClnDZnN3dUUsnlmJF0OHJfGtlJ4aEYuzND3ZanNKj87B4woX
         Fp9ZuN1GZClLPj7OMkNoXOt28BxlVTHkQy6/B4PxpYF9RGoA9hX2iFt6DhvsWt4geFp8
         pzuvIRAz5tPj9S21vueYXQofsNl5ja+Ea85xqDHstePjbjspl8s30n8sfj2+MgIhqHAy
         692Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGhKnuXKAZIBN7UU5RqHCMQOESVmCKea2plzLKaGYKI=;
        b=JOGbSFpoVE9JTHF6FqnuJJUvcSE+NRZjngmw/jJi0UVUBf4pgoV23FCnminlSPDlz3
         aYoxPvT2wDPOMvUudT6EGr2AVhXlf97YAuQZfVYE73TquxW3vx6w7KvVLYW4m1VvbZvn
         6dNKLkESBMyPTZV5M1YLIIHwhUs+B2XjTqtT82mUQwVIepmddRQ/3CY8chkkD1iXd4oO
         XjScMHVVCzdptRLCsgqYo9xqGSSK0eGqcW3wrAYZi2immWzBCiK3nL5n5BEhBD2y/6tW
         nkdxTGg/UJMsxp5bOoETibChgUalnMHA6up1DrFNu6RNrPJ683sdwIK1tcKO1ijmWp/3
         Eh8Q==
X-Gm-Message-State: AOAM531Z2YF8HCLwmVAP5pX6e9Docin6WVSib69y2aw5atiwlfl243h2
        2V6YQ0/gtbOWRMqQHcrexDBRNXi6phstXzRpFZvMAuCeXmRxfQ==
X-Google-Smtp-Source: ABdhPJyvz/EfrSBFVn1Pv8d2YkvUEku9oYRNKXMgu/SGexRauFTWOZXT00SrgY4xvh3tqI/ibw7qx/B2WC1mAb2nGTQ=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr19269842ybd.27.1605070146281;
 Tue, 10 Nov 2020 20:49:06 -0800 (PST)
MIME-Version: 1.0
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
In-Reply-To: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 20:48:55 -0800
Message-ID: <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
To:     Santucci Pierpaolo <santucci@epigenesys.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 9:12 AM Santucci Pierpaolo
<santucci@epigenesys.com> wrote:
>
> From second fragment on, IPV6FR program must stop the dissection of IPV6
> fragmented packet. This is the same approach used for IPV4 fragmentation.
>

Jakub, can you please take a look as well?

> Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
> ---
>  tools/testing/selftests/bpf/progs/bpf_flow.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 5a65f6b51377..95a5a0778ed7 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -368,6 +368,8 @@ PROG(IPV6FR)(struct __sk_buff *skb)
>                  */
>                 if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
>                         return export_flow_keys(keys, BPF_OK);
> +       } else {
> +               return export_flow_keys(keys, BPF_OK);
>         }
>
>         return parse_ipv6_proto(skb, fragh->nexthdr);
> --
> 2.29.2
>
