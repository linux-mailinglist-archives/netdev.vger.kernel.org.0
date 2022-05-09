Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E692052073A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiEIV7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiEIV7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:59:14 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B02527EBBD;
        Mon,  9 May 2022 14:54:39 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f2so16761384ioh.7;
        Mon, 09 May 2022 14:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2gKEf1K/klYrJyTBLhHt9tQtEtlx9ldLFqYI6nEIOvQ=;
        b=XcZKRoX+lymV2C8Zv5rp86FfnoLjOqd+o1D6F2SdNBbl+FLeHC1FeQVJg+NZw3Qac/
         u4xU5Bv9yMjJIUusyvHDxDe6LHqw1snrI05IrBrhBYwkCtXLLBhlxbamXc6ZZFTV5DjT
         tSKG7CKGv+0eEeOH94RxWGJ+7dQIiMFFeBVrCoDRmwVoVDLwQCZaR2KvAitbdoLSinT4
         lyERvG11n/0fRQnse6/ZYUXRnHeb1QixBfrY7pi1Lm98kFDv2s7rKsKoO2A54eIkgARI
         c2q292ZnsbUCknl9oM/hIqFUujbN3xxl94w/nXKIW8Bl8J2Z2pt4oCj/NELf89ylHIsO
         6SeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2gKEf1K/klYrJyTBLhHt9tQtEtlx9ldLFqYI6nEIOvQ=;
        b=40f+3Ktw8m7S6RGVoDw+Xf09WWXesC/BRmcmdelBHX08tBc68DZ555sFTjk1i9QvCO
         9mALiabiRL+x3/DNCH9ESxlYT6huH0vg6HqlqpnB64EpG6lPIkA1TsB677GNFIO+3jA3
         tBY2ZMbcrsNAifXgAMgBPrG4Qr8EvsjJuKK7YjbId1f7NkCZi1sLqTRLv1WWkC+axGhc
         slD7s4lFYK5ocBKwtUBfFhuNdA2FVApubKd/L3H34Au11uYdEZG8jX9OsowVOAbISZNR
         HjDr8ViGWl9kb9/Jsffe1mGjPGc2VVVXQs4JvBFJHIcGuN4mSrpTm4X3qj+08ZCwdSFG
         hxRw==
X-Gm-Message-State: AOAM53073bbzhsKIFmM+nPlEqf29RaPt8aPfgPsskrnMvLoYyjl41FGW
        EqJkDs771bDggmZyBXyc3+GD57X72hhS0E/CU4w=
X-Google-Smtp-Source: ABdhPJwNOPvkyRb+yhI3LZasEJl30Pg3VSAthyuZSbvrrCWntNoctsWJXaQQ7BV4tA8mER0sw81rUHLFBxSHeIzqJQc=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr8245475jav.93.1652133278860; Mon, 09
 May 2022 14:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-11-sdf@google.com>
In-Reply-To: <20220429211540.715151-11-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 14:54:28 -0700
Message-ID: <CAEf4BzY3Nd2pi+O-x4bp41=joFgPXU2+UFqBusdjR08ME62k5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 10/10] selftests/bpf: verify lsm_cgroup struct
 sock access
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 2:16 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> sk_priority & sk_mark are writable, the rest is readonly.
>
> Add new ldx_offset fixups to lookup the offset of struct field.
> Allow using test.kfunc regardless of prog_type.
>
> One interesting thing here is that the verifier doesn't
> really force me to add NULL checks anywhere :-/
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 54 ++++++++++++++++++-
>  .../selftests/bpf/verifier/lsm_cgroup.c       | 34 ++++++++++++
>  2 files changed, 87 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/lsm_cgroup.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/verifier/lsm_cgroup.c b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> new file mode 100644
> index 000000000000..af0efe783511
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/lsm_cgroup.c
> @@ -0,0 +1,34 @@
> +#define SK_WRITABLE_FIELD(tp, field, size, res) \
> +{ \
> +       .descr = field, \
> +       .insns = { \
> +               /* r1 = *(u64 *)(r1 + 0) */ \
> +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */ \
> +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0), \
> +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */ \
> +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, 0), \
> +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */ \
> +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, 0), \
> +               BPF_MOV64_IMM(BPF_REG_0, 1), \
> +               BPF_EXIT_INSN(), \
> +       }, \
> +       .result = res, \
> +       .errstr = res ? "no write support to 'struct sock' at off" : "", \
> +       .prog_type = BPF_PROG_TYPE_LSM, \
> +       .expected_attach_type = BPF_LSM_CGROUP, \
> +       .kfunc = "socket_post_create", \
> +       .fixup_ldx = { \
> +               { "socket", "sk", 1 }, \
> +               { tp, field, 2 }, \
> +               { tp, field, 3 }, \
> +       }, \
> +}
> +
> +SK_WRITABLE_FIELD("sock_common", "skc_family", BPF_H, REJECT),
> +SK_WRITABLE_FIELD("sock", "sk_sndtimeo", BPF_DW, REJECT),
> +SK_WRITABLE_FIELD("sock", "sk_priority", BPF_W, ACCEPT),
> +SK_WRITABLE_FIELD("sock", "sk_mark", BPF_W, ACCEPT),
> +SK_WRITABLE_FIELD("sock", "sk_pacing_rate", BPF_DW, REJECT),
> +

have you tried writing it as C program and adding the test to
test_progs? Does something not work there?

> +#undef SK_WRITABLE_FIELD
> --
> 2.36.0.464.gb9c8b46e94-goog
>
