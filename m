Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9D53C003
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiFBUny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 16:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbiFBUnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 16:43:52 -0400
Received: from mail-pj1-x1063.google.com (mail-pj1-x1063.google.com [IPv6:2607:f8b0:4864:20::1063])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC793E4E
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 13:43:47 -0700 (PDT)
Received: by mail-pj1-x1063.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so5782606pjs.1
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 13:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:dkim-signature:mime-version:references
         :in-reply-to:from:date:message-id:subject:to:cc;
        bh=7Akd9F5RhYTnk2DKxtOSkM0eLGAw4F7uKrkIutX2DK4=;
        b=A2c3rYUy2nfa3XsHSXQHODk0bmMhKLWK3wpF/HJSirh8PLGcaknuoPULXUCMcW72zF
         zMJQLlCORIm5ALFm+APjlm+I9rB9tsQbLZwQqMPdQISEMcRbXPPK27/ZlVs6XAMds+Pn
         nIqeYXGQdZdDtF1oxTSlu37+PhMsbdCt3c0kX5iCWG6YV2O8Elf5FRu9wVwkKm025HY/
         7swp+BLFV9UMEQBvIIFgVphLyXNiO+V5hMRMNSBHPC/tiB2kB239GKsOyqqW2vKhu5ry
         UE/uwcJDbf8ZV6qIT17HHdOWNNtdJ3MyGqjdT+V9h0h5CQRWvLoduQ+96dEPkG+TubFQ
         STaQ==
X-Gm-Message-State: AOAM531pXFZRuSWtmmQd1Hr0LttrqFlVpHhBVgx/DhbkFc9z1yi5VzGl
        lbSqjLHZP53wNVi/qpvGKR4/XQ8E9bvU7kxK1LzJlG6oNVIA7g==
X-Google-Smtp-Source: ABdhPJwBZhm1K48pZPdVMbLD9OjsInV1TYSXt6N5qBeBVbZTFSYXyIgK1Akl/mnmxNdQ/8A1lZRyJ6EU3bz/
X-Received: by 2002:a17:90b:1e42:b0:1e6:8093:3fb6 with SMTP id pi2-20020a17090b1e4200b001e680933fb6mr6577180pjb.166.1654202627415;
        Thu, 02 Jun 2022 13:43:47 -0700 (PDT)
Received: from netskope.com ([163.116.128.209])
        by smtp-relay.gmail.com with ESMTPS id q14-20020a17090aa00e00b001dbcb119005sm605481pjp.15.2022.06.02.13.43.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 13:43:47 -0700 (PDT)
X-Relaying-Domain: riotgames.com
Received: by mail-qk1-f197.google.com with SMTP id m26-20020a05620a13ba00b006a32a7adb78so4523138qki.10
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 13:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Akd9F5RhYTnk2DKxtOSkM0eLGAw4F7uKrkIutX2DK4=;
        b=d69dWt6HJQoiZC+5MFqWXaicN4JpYi+RWnOOF/pOfRBKwVUmlrSJlrlXBSNIyKNVAi
         z9m12QvfNIs49nr8dth8DdwQsDsdPaes77zgEtQmm12frTzYYvX/FiH+h/o09yPWCgaK
         tDxxQep7h5p0hfLK/lADwNSh/rNY9WFDu6JIM=
X-Received: by 2002:a05:622a:102:b0:304:b7b8:45b3 with SMTP id u2-20020a05622a010200b00304b7b845b3mr5046511qtw.369.1654202625663;
        Thu, 02 Jun 2022 13:43:45 -0700 (PDT)
X-Received: by 2002:a05:622a:102:b0:304:b7b8:45b3 with SMTP id
 u2-20020a05622a010200b00304b7b845b3mr5046491qtw.369.1654202625418; Thu, 02
 Jun 2022 13:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220602173657.36252-1-varshini.elangovan@gmail.com>
In-Reply-To: <20220602173657.36252-1-varshini.elangovan@gmail.com>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Thu, 2 Jun 2022 13:43:34 -0700
Message-ID: <CAC1LvL1=Vf7khHRR+WHNmv1Ose=RnXbXQ6gJtfPDpz8ztia-JQ@mail.gmail.com>
Subject: Re: [PATCH] staging: r8188eu: Add queue_index to xdp_rxq_info
To:     Varshini Elangovan <varshini.elangovan@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
x-netskope-inspected: true
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:37 AM Varshini Elangovan
<varshini.elangovan@gmail.com> wrote:
>
> Queue_index from the xdp_rxq_info is populated in cpumap file.
> Using the NR_CPUS, results in patch check warning, as recommended,
> using the num_possible_cpus() instead of NR_CPUS
>
> Signed-off-by: Varshini Elangovan <varshini.elangovan@gmail.com>
> ---
> kernel/bpf/cpumap.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 650e5d21f90d..756fd81f474c 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -102,8 +102,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>
> bpf_map_init_from_attr(&cmap->map, attr);
>
> - /* Pre-limit array size based on NR_CPUS, not final CPU check */
> - if (cmap->map.max_entries > NR_CPUS) {
> + /* Pre-limit array size based on num_possible_cpus, not final CPU check */
> + if (cmap->map.max_entries > num_possible_cpus()) {
> err = -E2BIG;
> goto free_cmap;
> }
> @@ -227,7 +227,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>
> rxq.dev = xdpf->dev_rx;
> rxq.mem = xdpf->mem;
> - /* TODO: report queue_index to xdp_rxq_info */
> + rxq.queue_index = ++i;

I don't think this is correct. i is the frame index, not the queue index. There
is (as far as I can tell) no correlation between the two.

Additionally, i is the loop variable, and the ++ operator will change its
value, causing frames to be skipped.

>
> xdp_convert_frame_to_buff(xdpf, &xdp);

>
> --
> 2.25.1
>
