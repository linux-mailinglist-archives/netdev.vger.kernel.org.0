Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62384E576E
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbiCWR2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiCWR17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:27:59 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479D27484B;
        Wed, 23 Mar 2022 10:26:29 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t25so3860369lfg.7;
        Wed, 23 Mar 2022 10:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lJMU8Tjj10gJIssCAW7AkaMCyOQjnDJPbnD9fw6PuNY=;
        b=Jj84XPQ5C/gHSM/F8OloJ0YA9t7Myr9aNZwBuMjA5p7hhTpI8iWWVoLPmMMW6MiIXW
         UP5wYHlnuUn1WRx9TsdqnyBo2/eIGgjK/PtPVmj5YoeuvPGTkBL5wBo1CC2ylxx6Cl3O
         6mPYKSa9oLl4csI7iTI5I7DKnKOnQ+YCqi3oP2PZHsTubo4PI8UYcb5iKjSZuBd5uN1/
         iDyXGdl9EV7J3iMK2Qw3/WA8Pf4s5VRXonRL31AmfQcfcl1BYDynbWZwAR1H2R+dDm0N
         8xHVWWuhwnr3CbOUzIe79K3p0VJuHsZ/w53us1Xa3vv5lBtqj9RAByv3pVY7ddAM/IzG
         CyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lJMU8Tjj10gJIssCAW7AkaMCyOQjnDJPbnD9fw6PuNY=;
        b=hTnGEp60Ym1wUvGH67YJU4Cj/g4zzgHz8rp87ch4YBIo7cpiINq/OFP5wUl4GMAPx4
         CBKMcGCJIy/z0MvyBUqviVZamOgQL0zPMcK405ywbflEXeS8nIVaID/Wr7v2CU614n0h
         aLVck5YnL3bgc+E1H8Ro4B3bFKG9Lcqy2MeNgznQb6ngDyg5n/5otBDzVJPstkeupyOd
         VstkSzVWyy+upRnn5Ri/b9cXFe+zcoP3Pinwv4Ny3SP54iOMsyuzB+w+woTedG3ABibE
         gacytIPV1tLJNWHA7SQfkR/RGemwiJ0Q3Lu4/nWHoWzXJ+rcorz2Dmwg8HANd6fqwWMA
         r7/g==
X-Gm-Message-State: AOAM533VBZ1+PaCOLyMBW/5wLygvY4iDKyf2JnG/+mozZNW6FouBhmt2
        OxGe0CISeYAZYaaPP8Q12GwEnOfCl0mMTcTc4rM=
X-Google-Smtp-Source: ABdhPJxrzbbwHDEQCPzyvg+d0htD1vm0vt/GTP4iwjUv4s0MhezDd0P8jXWhvksuWMba0Va98h6c0V6FCWfuY+sfAWk=
X-Received: by 2002:a05:6512:1155:b0:448:bcee:3df0 with SMTP id
 m21-20020a056512115500b00448bcee3df0mr687432lfg.442.1648056387505; Wed, 23
 Mar 2022 10:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220323073626.958652-1-ytcoode@gmail.com>
In-Reply-To: <20220323073626.958652-1-ytcoode@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 23 Mar 2022 10:26:15 -0700
Message-ID: <CAJnrk1YF3PiiHFgQu2K4LN2P-Lx4obQOoQohdgXhG4Fg6WogHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Remove redundant assignment to smap->map.value_size
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, linux-kernel@vger.kernel.org
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

On Wed, Mar 23, 2022 at 2:21 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> The attr->value_size is already assigned to smap->map.value_size
> in bpf_map_init_from_attr(), there is no need to do it again in
> stack_map_alloc()
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

LGTM.
Acked-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  kernel/bpf/stackmap.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 34725bfa1e97..6131b4a19572 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -106,7 +106,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
>                 return ERR_PTR(-ENOMEM);
>
>         bpf_map_init_from_attr(&smap->map, attr);
> -       smap->map.value_size = value_size;
>         smap->n_buckets = n_buckets;
>
>         err = get_callchain_buffers(sysctl_perf_event_max_stack);
> --
> 2.35.0.rc2
>
