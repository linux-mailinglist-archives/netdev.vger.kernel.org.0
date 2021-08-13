Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F583EBE80
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhHMXCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbhHMXCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:02:22 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ED0C061756;
        Fri, 13 Aug 2021 16:01:54 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id k11so21723137ybf.6;
        Fri, 13 Aug 2021 16:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T622aBx4EZBmiD+b+MJTaOcu0FTJ3ax/Qm2kvfKquR0=;
        b=ujkwKJmKi2/xhPhwuIwrkaq27vitc0Fiw39McYNYDey79td+Pb/AhFIFWGR0HovTO6
         ++yysIAKIgWh3TxrE8HGgZSLb4QhzCL/7C/ahfreN61tYtjl6kkY6mZuE/uOrglKjAm4
         ZAEP/23Eiv5G43vy8wOTZvQbQ0+URsXitlBtZm41wazOcl9lbUckyO9NogMLoj+1XJhn
         hu+pLAMyB+Cl4eqQKOBN215GlQTggSzul2p0nYtZpeX49fwMyc4OyrIr3V7cnMs9qB+C
         itkBEh0NmMQ6FqrtXIp9H4pVeOog7pZ3WgurCMo6EHAIQpk0werofqy/s1Zk7/iVRxat
         uNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T622aBx4EZBmiD+b+MJTaOcu0FTJ3ax/Qm2kvfKquR0=;
        b=Pk8zjX1eo8sUlK4t5i9J2aLiJLHCg6uTLtF0IrMS0VkCFUBtN2nbNtyh9EOOKp1kx8
         3xW5aGJACNEWOPkaXZYaQ1T6oCip11BTobt24zanfdPUMR2cZAq0uO50uPpqY83bh6iX
         93GYjD1K5TkSzScAHzkv/USW3gmgMggcWp3+0E7YobpVZRndCeqVI0rUQnv6x6+kzm46
         LwoBz506iew0lS//LK3Vo8m7iK04eqWGsbOhQpXph0AAZacF01xdgAP3Lmp8wS73NLzd
         BjkpMud7qqaGXmklsmxktja+PLoxEOfAelvVvm3QEFO94JMrPfB2wXWeB32h+Fud7s7W
         YhpQ==
X-Gm-Message-State: AOAM530I4vxbv0cQsJaHA9jvqWH7cgpNlOtXSrZhbFYpqJHTWvnwVA5M
        xXB6XFa1RZf5MmqviEe5ktMKXsWBHg/6aeEtymY=
X-Google-Smtp-Source: ABdhPJyXy7fYqH1WC+CAl/xJtpt6LO0otCfDPKfVZV7eNKcCDKA/fhs+CDiXgD0C+Yo8m1IfPEiieJ8NqVpQ5wc5XN8=
X-Received: by 2002:a25:5054:: with SMTP id e81mr5766366ybb.510.1628895714219;
 Fri, 13 Aug 2021 16:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210812003819.2439037-1-haoluo@google.com>
In-Reply-To: <20210812003819.2439037-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Aug 2021 16:01:43 -0700
Message-ID: <CAEf4Bzbhtty_XjpPxSjfe4zEHAfWuQ4th15eLgomT2BDHUQ7jw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: support weak typed ksyms.
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 5:40 PM Hao Luo <haoluo@google.com> wrote:
>
> Currently weak typeless ksyms have default value zero, when they don't
> exist in the kernel. However, weak typed ksyms are rejected by libbpf
> if they can not be resolved. This means that if a bpf object contains
> the declaration of a nonexistent weak typed ksym, it will be rejected
> even if there is no program that references the symbol.
>
> Nonexistent weak typed ksyms can also default to zero just like
> typeless ones. This allows programs that access weak typed ksyms to be
> accepted by verifier, if the accesses are guarded. For example,
>
> extern const int bpf_link_fops3 __ksym __weak;
>
> /* then in BPF program */
>
> if (&bpf_link_fops3) {
>    /* use bpf_link_fops3 */
> }
>
> If actual use of nonexistent typed ksym is not guarded properly,
> verifier would see that register is not PTR_TO_BTF_ID and wouldn't
> allow to use it for direct memory reads or passing it to BPF helpers.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Looks good, applied to bpf-next. For the future, please split libbpf
and selftests changes into separate patches, it's nicer to have those
logically separate.

At some point we should probably also improve libbpf error reporting
for such situations, for better user experience. We have a similar
problem with CO-RE relocation, verifier doesn't know about those
concepts, so verifier log is not very helpful, but libbpf can make
sense out of it with some extra BPF verifier log parsing.

> Changes since v2:
>  - Move special handling and warning from find_ksym_btf_id() to
>    bpf_object__resolve_ksym_var_btf_id().
>  - Removed bpf_link_fops3 from tests since it's not used.
>  - Separated variable declaration and statements.
>
> Changes since v1:
>  - Weak typed symbols default to zero, as suggested by Andrii.
>  - Use ASSERT_XXX() for tests.
>
>  tools/lib/bpf/libbpf.c                        | 16 +++---
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 31 ++++++++++
>  .../selftests/bpf/progs/test_ksyms_weak.c     | 56 +++++++++++++++++++
>  3 files changed, 96 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
>

[...]
