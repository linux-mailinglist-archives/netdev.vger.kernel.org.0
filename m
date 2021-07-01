Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8E83B8D74
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 07:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhGAFng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 01:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhGAFnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 01:43:35 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F73C061756;
        Wed, 30 Jun 2021 22:41:05 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u13so9644644lfk.2;
        Wed, 30 Jun 2021 22:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xGmfG856K6AgDGtPMSPLeZTsFwSPkyrkWA8yg2JxaMw=;
        b=eSAd5lcPcJFbP4i6UZS9mbkBJg1z1jtjTZlNffvaA9hI3TfktqZAKGCntRXJ8kS70M
         s1z6V79rR5PCbOUyqzjm6HFsvIhgToxpS0M0mtmFNjY1XOxzjBq2bhY8pktOUJmEzuW0
         viLHstDEnuI4B2e8jQxQWVNA1nqWRIV7zfrnPosvUZgSwIaIQd9hUKGm0lkPSL+WT5LD
         /Qk1EoCWgls7wR3Ubd9rQkgqw63sXegPSXDw4CnuuUkeRf0f1cVHWzAklB81AQeIp9aK
         51nPFc9jsRpNGuTm9jvfqhyDhsU8x9h5ZNd7aOpHsX6e77DKg2O6yBDUk9oACEmnuHqU
         /B2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xGmfG856K6AgDGtPMSPLeZTsFwSPkyrkWA8yg2JxaMw=;
        b=sEg1fFyiBmevJcr2jZO3vNEs2gfdjiObASnZQWaCShI51vsDJtn2VqZINtuXfxW265
         My+8rvh19fIhu/gkMX73ZBrzjhk8ULwYhBjJ8nWktGc+kmFbAUGEXRvo/ly6rHP68Yc3
         ilkgH51ZyW9DwqaKoVkfz5DW3VPNnteOk55mXP6JPY1IDwdrhOQ0hZtEOAb4pqeAL0YJ
         Lp3eXDJmmNPBFzFaf3f4kgt8WFRblphsQscvyQ03ZSXV4AreMWgMsfLLu5sWsLNfXg/p
         9PAtb3mfgYHlGTBqbX/F/mCI+K4nd7DF7/MQj9Pufv7IfVF03MBIScOqxI556qnugz5G
         HLyQ==
X-Gm-Message-State: AOAM531MbMgkRMmYCthhhGFQk8qoRoVNMUuQmXx0JYIGMvQqqV8I7y57
        zQdp4GnxcOCQvzkbmH+XFCp/6F7CZKmbAxmgQOA=
X-Google-Smtp-Source: ABdhPJzFeBgjZgK+9H2gQurnymFyoX9aN0lKdNLTyOqO7ggvlQaqm1rn16geJUT1QK632P6U8p2oCs4J0D4Jhg7122Q=
X-Received: by 2002:ac2:43b4:: with SMTP id t20mr30809417lfl.539.1625118063966;
 Wed, 30 Jun 2021 22:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com> <20210624022518.57875-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210624022518.57875-2-alexei.starovoitov@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 30 Jun 2021 22:40:52 -0700
Message-ID: <CAADnVQJrZdC3f8SxxBqQK9Ov4Kcgao0enBNAhmwJuZPgxwjQUg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     "David S. Miller" <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 7:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> The bpf_timer_init() helper is receiving hidden 'map' argument and
...
> +               if (insn->imm == BPF_FUNC_timer_init) {
> +                       aux = &env->insn_aux_data[i + delta];
> +                       if (bpf_map_ptr_poisoned(aux)) {
> +                               verbose(env, "bpf_timer_init abusing map_ptr\n");
> +                               return -EINVAL;
> +                       }
> +                       map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> +                       {
> +                               struct bpf_insn ld_addrs[2] = {
> +                                       BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
> +                               };

After a couple of hours of ohh so painful debugging I realized that this
approach doesn't work for inner maps. Duh.
For inner maps it remembers inner_map_meta which is a template
of inner map.
Then bpf_timer_cb() passes map ptr into timer callback and if it tries
to do map operations on it the inner_map_meta->ops will be valid,
but the struct bpf_map doesn't have the actual data.
So to support map-in-map we need to require users to pass map pointer
explicitly into bpf_timer_init().
Unfortunately the verifier cannot guarantee that bpf timer field inside
map element is from the same map that is passed as a map ptr.
The verifier can check that they're equivalent from safety pov
via bpf_map_meta_equal(), so common user mistakes will be caught by it.
Still not pretty that it's partially on the user to do:
bpf_timer_init(timer, CLOCK, map);
with 'timer' matching the 'map'.
Another option is to drop 'map' arg from timer callback,
but the usability of the callback will suffer. The inner maps
will be quite painful to use from it.
Anyway I'm going with explicit 'map' arg in the next respin.
Other ideas?
