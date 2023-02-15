Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E711E697A2E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbjBOKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjBOKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:48:43 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8781F932;
        Wed, 15 Feb 2023 02:48:41 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id r18so12999340wmq.5;
        Wed, 15 Feb 2023 02:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAMwmmeJTB4y8HRfnrbAEx8AJ0NbXL4pZ1qTwnmZ3fM=;
        b=FnglT4BGUAo2f8rXxJY4/ubPX47gxrEU5xT9CEHU9Yw7gEV0RTieWBVmGgi5sergeb
         TYQfahuIx/lp8JMhsfKemN4Sq1XsCwVSgC+zvV7AW3VM3IEiCWKbpUSkZzdIzY/i78He
         DUB25MUWPcUdhCuRu6AbDdCxsqyDjkVtkMQZe4puMCfmULNXBeqYbSjSC8HbqYWqBnbo
         hVxA+5sIc1qxa/SjEy/2DnVdqRdpD8eDclV06vQHYvRybnJKmQzOBU3i7HRrL+bFgj06
         DMDGWUpyA0qzj8/LIZX03nHzr+I6Qx8lv7xxABv8tBOApjgdY+6yHwzH8HAba27s6FeU
         DZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAMwmmeJTB4y8HRfnrbAEx8AJ0NbXL4pZ1qTwnmZ3fM=;
        b=8LDiLDBJuGGbvxlh+gqjKCpFQYKHYJyqe1JVaDVgsTCuyg+JmksuiHleAhjm0TyeMs
         GlBOPyBydnwTCRRpxLBMJ+X9x23NatoIuAnGuyOM6Hx5xVn5hnlv1mpeBrtoJG2HPH76
         g2MNMF7wZxuUS66p7IKPuT2x2Tw6m31SNeR+zyWqnC2nQM+JUP4NgERLRO62pr/PXlpi
         MGA/QZXSsWiqUJE/ifOux2nbLD8kAVklQKjmxd5U9NotO+tF7+c4nvJCrWrNh5CfoqWF
         Ha3tpUboK5gFEOe/FraSgSSOvkcQ38dJ+oudoIa/bc4NCDNbGbEOfcwerCENklfn5Wtd
         EUTA==
X-Gm-Message-State: AO0yUKULuoyYiIM8S2rcj/J9A9FRhZl5VQL2z2KVg/oMqxEThbbQbjWa
        qTKAhgBYmBcELT9cqG509VU=
X-Google-Smtp-Source: AK7set9FhZ/FFG6E+Bc1xavPehSvyQZ3kfQXgeQ56KeqFIcjYKhqxBO+62NZsfzpAwbf5bypzAPTUA==
X-Received: by 2002:a05:600c:4919:b0:3dc:46e8:982 with SMTP id f25-20020a05600c491900b003dc46e80982mr1571626wmp.19.1676458120240;
        Wed, 15 Feb 2023 02:48:40 -0800 (PST)
Received: from localhost ([2a02:1210:74a0:3200:2fc:d4f0:c121:5e8b])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c19cf00b003dc53217e07sm1833837wmq.16.2023.02.15.02.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 02:48:39 -0800 (PST)
Date:   Wed, 15 Feb 2023 11:48:37 +0100
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/4] bpf: Introduce kptr_rcu.
Message-ID: <20230215104837.gm3ohqzownrtky5k@apollo>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
 <20230215065812.7551-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215065812.7551-3-alexei.starovoitov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 07:58:10AM CET, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>
> The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
> Hence it's safe to dereference them directly from kptr-s in bpf maps.
> The resulting pointer is PTR_TRUSTED and can be passed to kfuncs that expect KF_TRUSTED_ARGS.

But I thought PTR_TRUSTED was meant to ensure that the refcount is always > 0?
E.g. in [0] you said that kernel code should ensure refcount is held while
passing trusted pointer as tracepoint args. It's also clear from what functions
that operate on PTR_TRUSTED are doing. bpf_cgroup_acquire is doing css_get and
not css_tryget. Similarly bpf_cgroup_ancestor also calls cgroup_get which does
css_get instead of css_tryget.

  [0]: https://lore.kernel.org/bpf/CAADnVQJfj9mrFZ+mBfwh8Xba333B6EyHRMdb6DE4s6te_5_V_A@mail.gmail.com

And if we want to do RCU + css_tryget, we already have that in the form of
kptr_get.

I think we've had a similar discussion about this in
https://lore.kernel.org/bpf/20220216214405.tn7thpnvqkxuvwhd@ast-mbp.dhcp.thefacebook.com,
where you advised against directly assuming pointers to RCU protected objects as
trusted where refcount could drop to 0. So then we went the kptr_get route,
because explicit RCU sections weren't available back then to load + inc_not_zero
directly (for sleepable programs).

> Derefrence of other kptr-s returns PTR_UNTRUSTED.
>
> For example:
> struct map_value {
>    struct cgroup __kptr_rcu *cgrp;
> };
>
> SEC("tp_btf/cgroup_mkdir")
> int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
> {
>   struct cgroup *cg, *cg2;
>
>   cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
>   bpf_kptr_xchg(&v->cgrp, cg);
>
>   cg2 = v->cgrp; // cg2 is PTR_TRUSTED | MEM_RCU. This is new feature introduced by this patch.
>
>   bpf_cgroup_ancestor(cg2, level); // safe to do. cg2 will not disappear
							^^ But it's percpu_ref
							can drop to zero, right?

> }
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> [...]
