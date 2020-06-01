Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F511EB1D2
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgFAWmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:42:16 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB71DC061A0E;
        Mon,  1 Jun 2020 15:42:15 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id y9so870412qvs.4;
        Mon, 01 Jun 2020 15:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwhzR8RmMestUZjdHXFXyR/5Gz7ZzMKNhkGGSqWytPU=;
        b=WCdcJdWew+9eWEjq4IIOfHRZ646kpaUQMNP0kCQ4dAqYjf776Dkq17tabijrk8ELsr
         Ug+JIR8PLWdO4WzrurHnnSnPwxkVIg+jFirvaQAb8wXSUMxWi77Erj1XMGSN1ZySXqz/
         pC3kvBW6VDOKj+BNmKFWMAEDyPqdMNHQ6AFyvTBx2jc03HMEs8FPC0/NeSSgjyFS6r8j
         SrCI0VP60puSnLqgo0IYgxNWg9E9G6T+ciaO9+kTa9R/GgvS10mEea+1YlRqi6IBt/o8
         ZOxvCi2asefBAh4YFuls/vO5oUF0M6ysUJocDaZXszYOR3dkUPypWByyuQxB5Z+/BCEy
         /BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwhzR8RmMestUZjdHXFXyR/5Gz7ZzMKNhkGGSqWytPU=;
        b=Qs/t1frlWR3/j23bSXUflcS8552SSjhM3wm8aqWa+CGiyzdZkVIvdKgfTGPsHEydHd
         5sncAIi/7iwGgpdN8oeNKzznPRbKbtA5BvkMxsWSeByAsQhOJzPr980DIqYMvANXYWXq
         1cvesPJiCkPLu36CG/obOQ35m5ZSz1AyrTwNDDqy4hcgZvgjo1xh8QtraRyNaySshoA9
         e4HN5JQDUm3wELkR1Jp45IDa0QInYOQckLtEth6SMsnC4GC9m4GFS0BMWSx3iZotm2tI
         CF0MNcmBn1hXaqFhKK22D2GFl7ac3iK+UqcStTFCsjuutaK9eHFnbqVdndlABhPfuY99
         pv5g==
X-Gm-Message-State: AOAM533Xz68GBn3Ex0Br4ne47h4DBiiRRBXhTpzXm0k55b6hEXItxiHm
        V7aisqJlkpwkKZlaRS7iWJw9ohJ0kTUerw871bQ=
X-Google-Smtp-Source: ABdhPJxNvAtFCuRBT/38OtAo9aw6nyCKIDuMbDvEhYWYJg45HDi+dTM4aLYRBbrkDDlsI1dgRvyYkLWFZPT9Ex2VIJg=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr10663027qvb.196.1591051334976;
 Mon, 01 Jun 2020 15:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-12-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-12-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:42:04 -0700
Message-ID: <CAEf4BzbBRNCTxZvtn2s3uN+JG-Z6BpHvgbovi6abaQi6rSeBbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/12] selftests/bpf: Convert
 test_flow_dissector to use BPF skeleton
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Switch flow dissector test setup from custom BPF object loader to BPF
> skeleton to save boilerplate and prepare for testing higher-level API for
> attaching flow dissector with bpf_link.
>
> To avoid depending on program order in the BPF object when populating the
> flow dissector PROG_ARRAY map, change the program section names to contain
> the program index into the map. This follows the example set by tailcall
> tests.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/flow_dissector.c | 50 +++++++++++++++++--
>  tools/testing/selftests/bpf/progs/bpf_flow.c  | 20 ++++----
>  2 files changed, 55 insertions(+), 15 deletions(-)
>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 9941f0ba471e..de6de9221518 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -20,20 +20,20 @@
>  #include <bpf/bpf_endian.h>
>
>  int _version SEC("version") = 1;
> -#define PROG(F) SEC(#F) int bpf_func_##F
> +#define PROG(F) PROG_(F, _##F)
> +#define PROG_(NUM, NAME) SEC("flow_dissector/"#NUM) int bpf_func##NAME
>
>  /* These are the identifiers of the BPF programs that will be used in tail
>   * calls. Name is limited to 16 characters, with the terminating character and
>   * bpf_func_ above, we have only 6 to work with, anything after will be cropped.
>   */
> -enum {
> -       IP,
> -       IPV6,
> -       IPV6OP, /* Destination/Hop-by-Hop Options IPv6 Extension header */
> -       IPV6FR, /* Fragmentation IPv6 Extension Header */
> -       MPLS,
> -       VLAN,
> -};

not clear why? just add MAX_PROG after VLAN?

> +#define IP             0
> +#define IPV6           1
> +#define IPV6OP         2 /* Destination/Hop-by-Hop Options IPv6 Ext. Header */
> +#define IPV6FR         3 /* Fragmentation IPv6 Extension Header */
> +#define MPLS           4
> +#define VLAN           5
> +#define MAX_PROG       6
>
>  #define IP_MF          0x2000
>  #define IP_OFFSET      0x1FFF
> @@ -59,7 +59,7 @@ struct frag_hdr {
>
>  struct {
>         __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> -       __uint(max_entries, 8);
> +       __uint(max_entries, MAX_PROG);
>         __uint(key_size, sizeof(__u32));
>         __uint(value_size, sizeof(__u32));
>  } jmp_table SEC(".maps");
> --
> 2.25.4
>
