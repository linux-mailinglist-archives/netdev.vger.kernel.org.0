Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6855F5F7B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJFDVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiJFDUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:20:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4C12D06;
        Wed,  5 Oct 2022 20:19:53 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k2so1747075ejr.2;
        Wed, 05 Oct 2022 20:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jj9Hs5tS3effP5pd1NzEo0zYNBMFkL6IIGg5iY5UdyU=;
        b=lWvy+qRhZcOBGcz6RvFX03a+UpLtKaWuXaERiKupGeTkIS1p/OS+6q29A2f1M/45pG
         NJnK31RVqb/Z9srSUJ/l1ITrFtV1Ft/MVY26LMrDoLfPGi5dBWD7E+i0rLwYHlIF5QuN
         kWC9hqsSvc07m+RxKT3dlx1sPAsJsq152cYr+g85ecgMRm5t4BKR4l/y3dU2JVffwe7e
         SYyR3eMjHlvl37kZaidBCAnhyaDy3qiceN8EdU+JIdcbKQzfP4HWtN3fkEEx1l0Zvcpb
         4H5mr9R5MMdmntFwZhuuV8BkuimjCBrRb+2gNXYEuhfNHbPRvVNw7BYepiuMHhBiLgE4
         vjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jj9Hs5tS3effP5pd1NzEo0zYNBMFkL6IIGg5iY5UdyU=;
        b=6Uph43NX5gGBk/0O3ClnPFkrwgBXH4lmJPh3eq8idevHx2HOM5WvxbDYhxxrdgfTov
         cESYEiIpbPLWfrUBmNAa1mEjOhCt1lzxg/sCmN1DhQMoUupaEPc0dUZjePPotTIuJv1k
         DZBswPrweOgX2lnjbQO2MM0fa+QrtBLlbp3ZKHtTnEcdG+keIelbfXnz1gqtCB8zwAR7
         btH0RPR//aqF4LdzqCIUZgULrujkXWeM9bhm5Vw9pxCkNkJKuGFGUmNV1AI8YX7iI8LD
         2uewJ2LpBDvrX+IiQk7zy3fr78oYheIou6ChoNhuSMcM7BaWgV9NqorBjwiCh8tC6jqa
         BhgQ==
X-Gm-Message-State: ACrzQf3yxXasDvN+SGMnUOVl/1gwqtgJhIphDPk7I0pVNxh2x7dqenM6
        QjrDSifmxqaeATtQ++Zb1m5EKWUXy7lzcHRja/4=
X-Google-Smtp-Source: AMsMyM54wcQ/pOYKKEJkTQNsRlh7GdhI7Vs+/ywTUBGu8zH3/ZrWRW8PeLkvQ5n0GeRKz9c3Aq/04bb+a5OVqu0TNa8=
X-Received: by 2002:a17:907:3d86:b0:782:1175:153f with SMTP id
 he6-20020a1709073d8600b007821175153fmr2221503ejc.226.1665026391328; Wed, 05
 Oct 2022 20:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-7-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-7-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:37 -0700
Message-ID: <CAEf4BzZUiNC_QcnfzbS9jctVNqNOEBio29k6Qtdd=Fq9WFM6PQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/10] libbpf: Change signature of bpf_prog_query
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Minor signature change for bpf_prog_query() API, no change in behavior.
> An alternative option would be to add a new libbpf introspection API
> with close to 1:1 implementation of bpf_prog_query() but with changed
> prog_ids pointer. Given the change is just minor enough, we went for
> the first option here.
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf.c | 2 +-
>  tools/lib/bpf/bpf.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 1d49a0352836..18b1e91cc469 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -846,7 +846,7 @@ int bpf_prog_query_opts(int target_fd,
>  }
>
>  int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
> -                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
> +                  __u32 *attach_flags, void *prog_ids, __u32 *prog_cnt)
>  {
>         LIBBPF_OPTS(bpf_prog_query_opts, opts);
>         int ret;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 9c50beabdd14..bef7a5282188 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -386,7 +386,7 @@ LIBBPF_API int bpf_prog_query_opts(int target_fd,
>                                    struct bpf_prog_query_opts *opts);
>  LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
>                               __u32 query_flags, __u32 *attach_flags,
> -                             __u32 *prog_ids, __u32 *prog_cnt);
> +                             void *prog_ids, __u32 *prog_cnt);

ugh, this is pretty nasty. Let's not do that. Have you though about
re-using prog_attach_flags (we can add a union to name the field
differently) to return prios instead of adding struct bpf_query_info?
This would be consistent with other uses cases that use PROG_ATTACH
and PROG_QUERY approach?


>
>  LIBBPF_API int bpf_raw_tracepoint_open(const char *name, int prog_fd);
>  LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
> --
> 2.34.1
>
