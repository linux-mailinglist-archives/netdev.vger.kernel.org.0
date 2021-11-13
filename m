Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D5444F093
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 02:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhKMBaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 20:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhKMBaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 20:30:09 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F45DC061766;
        Fri, 12 Nov 2021 17:27:17 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np3so8115192pjb.4;
        Fri, 12 Nov 2021 17:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cpHelnxym1ZdzaK+IqqiuDWAYBCX9hEY4y5A2JWqrOM=;
        b=mxoL5gHLYKVBpe2SOIVblh1WZx6+fNDRummF4BQepLO0bJleW4XdHlUXfd0W5IyiTO
         Yc2aTw+YndP87tQoU9Ysibu/hcdtzMuNSFhej952uMy3ELmtAZRlUlkQICuscFmA8VBi
         0SCatR2QKAtwet675yzV/5WqU9srmJKNnAK7uZbima7v8GHT8OyS0eiHaW5Yomj2ATBn
         Do/TjFqzlXbeM1NCqu5VTvqrYy4RfA9m0oEP8TPB41POmSZRzaHhZGOuA56c/m32LenP
         GhWHelx/NcosQ71Knt6THcRysk+2cOtnLZ+rS7NZD6yDxjDFWwdtgCvXvGtHJ9aXL5+J
         dnig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cpHelnxym1ZdzaK+IqqiuDWAYBCX9hEY4y5A2JWqrOM=;
        b=DS4ilc10CnAUgHKA6OiCrGHTp9xJG8XiZxnPzJ2T+Vfe0ainMlY2jH5hgNYVtklWAH
         umjceovk4c2n+S2QB4EoggMr8H8gC4qEq5/YUvK0Z0ZUmA4DHoKOaxMorO/9FluBh4tt
         WJO4BC919hNYl9pW2Iqc34p2pV9BhcnXbQdYF3f0qLu7kzMhCEqjse6kZXxRzgz2E1XS
         /Qu2Nb21HQlvsSzuzU+H+d7nGey/JVp/oF2fdR8IwHOW50SULI+3vOJxsuF/FGIKnAjm
         YA8blO2pQzReuHiCtCO4FsL6kNBVLpn3PnRW/69HM2wSroQz9oOOeSTtD9wokbk0ZKMr
         wD4A==
X-Gm-Message-State: AOAM533lJWz8+YJ+ReEQuwJuFVfvQ+CkYzqpgMXl868zzpZQKBZf/WuO
        e3711rSvx/ICyLYm5ClqfGPepDHL7BHNL5VV8K4=
X-Google-Smtp-Source: ABdhPJyHwvS/jKW7DRlCUoys/2r2PYkL2HJJEPUsWZK0TMk4zkEsYzYwO0GghgPbqeR33/HUixUyHrQaxUYC0TF1Fzg=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr13068957plh.3.1636766836907; Fri, 12 Nov
 2021 17:27:16 -0800 (PST)
MIME-Version: 1.0
References: <20211111161452.86864-1-lmb@cloudflare.com>
In-Reply-To: <20211111161452.86864-1-lmb@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Nov 2021 17:27:05 -0800
Message-ID: <CAADnVQKWk5VNT9Z_Cy6COO9NMjkUg1p9gYTsPPzH-fi1qCrDiw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: check map in map pruning
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 8:16 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Ensure that two registers with a map_value loaded from a nested
> map are considered equivalent for the purpose of state pruning
> and don't cause the verifier to revisit a pruning point.
>
> This uses a rather crude match on the number of insns visited by
> the verifier, which might change in the future. I've therefore
> tried to keep the code as "unpruneable" as possible by having
> the code paths only converge on the second to last instruction.
>
> Should you require to adjust the test in the future, reducing the
> number of processed instructions should always be safe. Increasing
> them could cause another regression, so proceed with caution.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Link: https://lore.kernel.org/bpf/CACAyw99hVEJFoiBH_ZGyy=+oO-jyydoz6v1DeKPKs2HVsUH28w@mail.gmail.com/
> ---
>  .../selftests/bpf/verifier/map_in_map.c       | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/map_in_map.c b/tools/testing/selftests/bpf/verifier/map_in_map.c
> index 2798927ee9ff..f46c7121e216 100644
> --- a/tools/testing/selftests/bpf/verifier/map_in_map.c
> +++ b/tools/testing/selftests/bpf/verifier/map_in_map.c
> @@ -18,6 +18,39 @@
>         .fixup_map_in_map = { 3 },
>         .result = ACCEPT,
>  },
> +{
> +       "map in map state pruning",
> +       .insns = {
> +       BPF_ST_MEM(0, BPF_REG_10, -4, 0),
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -4),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 11),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> +       BPF_LD_MAP_FD(BPF_REG_1, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
> +       BPF_EXIT_INSN(),
> +       BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .fixup_map_in_map = { 4, 14 },
> +       .flags = BPF_F_TEST_STATE_FREQ,
> +       .result = VERBOSE_ACCEPT,
> +       .errstr = "processed 25 insns",
> +},

Not sure how you've tested it, but it doesn't work in unpriv:
$ test_verifier 789
#789/u map in map state pruning FAIL
processed 26 insns (limit 1000000) max_states_per_insn 0 total_states
2 peak_states 2 mark_read 1
#789/p map in map state pruning OK

I've added
.prog_type = BPF_PROG_TYPE_XDP,
and force pushed.
