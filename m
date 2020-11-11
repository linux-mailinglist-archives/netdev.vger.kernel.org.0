Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E91B2AE755
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgKKEOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgKKEOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:14:45 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CC1C0613D1;
        Tue, 10 Nov 2020 20:14:43 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id k65so699348ybk.5;
        Tue, 10 Nov 2020 20:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGIhTX1iYBMgF744IBDkziq2Q7vA4MuCaT2yYSxn/kE=;
        b=afZuz/fEsATObkVGZ+Bdyj20ctN1tN/V4gTs0dyEazHIIuQ6jPQzez7wr+WEz4atmY
         +t0QsgNpbbUk0dWgGOuxHImRYr1Ru4MuhwuWSEwpsrYIILV023mM+AtPfiwJmwM+tFCi
         7nw72CGuZt0KbRRLPXbfVVBDBHQfkawlN9iqzLo7evCak50NXx7qaLKvSBZtalFdr27G
         eBFMj9kFdWKt8tyIMbjVJYtHvmWJMkIpFLnQjEA862KPJbaPOFnjpXUuq506qmAj1kEF
         h/512GNHzzcdeqad+yRCkIfWXJRyPk42b1+XMrQ2rcO95xWJV6zOCiYsdnIQDkxeE5lB
         QbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGIhTX1iYBMgF744IBDkziq2Q7vA4MuCaT2yYSxn/kE=;
        b=I9cozBk7F5/sDL8Kj5K/sw2ZQOKTsBMX0kT/8izceLWaJOgs26YVPBaqUgE6XSeUad
         J3EURnYqNY/U1FCmdduvrLZYmL1BsBj/nqbuOzMDZvOfhQKMD1Ry80Nfxu9LqhiMw4sK
         GO7bABE4xa1IjCgoVfN1OrT8AVMTBML5AG82wNZ+wofST82wAHAK6dVB83z9Ji4VCK9e
         IaHdVYqy7GM0h9g3uqq3GvHyu1bRuuuM0osnGuYEXsD6VUrcUxi7u6iYhqB7y9d7joFx
         YbKYCJRmG+6CN0kmQoTQpbmj7+d/GBdP3dJ5dTL5grXFoJ7N2O0CTX1jIcnD2g/FHlna
         F3SA==
X-Gm-Message-State: AOAM530Ta9F8WHTyz2pKJPfsA5WzFgw1SY3yJ07dauOf0r72wvAyydHj
        t/SExBfM3BVBjJuMgreMLHCZBHYHJcG3iF7Qv3I=
X-Google-Smtp-Source: ABdhPJxet7rQw0y6nxIveHE7CF+nZHHpGRcztGpne0cnSSXMkm5i1vlorbi4e29hi04uoltOpCouFuJQaEP8UfOxQco=
X-Received: by 2002:a25:e701:: with SMTP id e1mr6632254ybh.510.1605068083120;
 Tue, 10 Nov 2020 20:14:43 -0800 (PST)
MIME-Version: 1.0
References: <1605063541-25424-1-git-send-email-kaixuxia@tencent.com>
In-Reply-To: <1605063541-25424-1-git-send-email-kaixuxia@tencent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 20:14:32 -0800
Message-ID: <CAEf4BzZY2-at9-wprCy58hAnQyBLRzK8mYSHyJht3iceFGKX9w@mail.gmail.com>
Subject: Re: [PATCH v2] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
To:     xiakaixu1987@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 6:59 PM <xiakaixu1987@gmail.com> wrote:
>
> From: Kaixu Xia <kaixuxia@tencent.com>
>
> The unsigned variable datasec_id is assigned a return value from the call
> to check_pseudo_btf_id(), which may return negative error code.
>
> Fixes coccicheck warning:
>
> ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0
>
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
> v2:
>  -split out datasec_id definition into a separate line.
>
>  kernel/bpf/verifier.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6200519582a6..3fea4fc04e94 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9572,7 +9572,8 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>                                struct bpf_insn *insn,
>                                struct bpf_insn_aux_data *aux)
>  {
> -       u32 datasec_id, type, id = insn->imm;
> +       s32 datasec_id;
> +       u32 type, id = insn->imm;
>         const struct btf_var_secinfo *vsi;
>         const struct btf_type *datasec;
>         const struct btf_type *t;
> --
> 2.20.0
>

It would look a bit cleaner if you did it this way:

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 10da26e55130..f674b1403637 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9585,12 +9585,13 @@ static int check_pseudo_btf_id(struct
bpf_verifier_env *env,
                               struct bpf_insn *insn,
                               struct bpf_insn_aux_data *aux)
 {
-       u32 datasec_id, type, id = insn->imm;
        const struct btf_var_secinfo *vsi;
        const struct btf_type *datasec;
        const struct btf_type *t;
        const char *sym_name;
        bool percpu = false;
+       u32 type, id = insn->imm;
+       s32 datasec_id;
        u64 addr;
        int i;
