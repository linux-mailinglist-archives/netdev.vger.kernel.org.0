Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C735E5769
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiIVAfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVAfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:35:45 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D316B79686;
        Wed, 21 Sep 2022 17:35:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id sb3so17458556ejb.9;
        Wed, 21 Sep 2022 17:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KtrIxxFWIWlTHEDNVczK3cnXH5wRZy8qQW+YtDSSF5E=;
        b=NAe9dIZVRdlklxh5ZK4x/4YkIB+/0GwVxhJiQ8FU5pkj8LFwFVKu68mQBG4uv1IMBv
         jfwahuyb2YUIX0AJGcrLLmMVeMrvvc0LfeclwUN0QrNSWsC2G2gwdzgd70lJFOpfhq6O
         O4cJ2LucRw35NHIcCZXfR6n0j0SlbyIRSK3APfAbkpdV6ZM/OELTucsIMIbsaSBPQMN+
         Q/GCjujeEiR7FG7jIe+BSUOPBlfEzm9R8CtIDau5gkfyTOdFk2gfGnbSydvCanGGLIfP
         m9nzaTHelBryF+uPENQx9eqvXh0HiJ3T8D4nCV1RokGWlHYnc4efYf3Uay4DrShndWEN
         XZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KtrIxxFWIWlTHEDNVczK3cnXH5wRZy8qQW+YtDSSF5E=;
        b=4hx6+Y+ILAiVdNeeZmMVSdssR5mvhPXkHYyrZNR9VxESby/kkvCJVT16fe9v3KF+a6
         0Xj9Xg0ejtFZGSMJmRRfE4SVf2EKd3dJZyYZeiBnpz8nLNZWyh6O6cSzpk1xgPYjQNRl
         c2zNbJN+IixpYice4bl1ujOIHRmaDQlkLa9FHN0Ev9KC6QH2KWNbaqPwk7VUnA093O4h
         n/pLJxewItdUQUy25M2eM4se1T/sKZHpGcKBlEIpNd6aewDJgNGQAmcS3X6kvWvveaoU
         uBcwYyL4DwjLueYHEX8gLW6X5jJumu7reAqcqHPyTXKiu5SGCQNxLlYWPSw4dytur/Ck
         joBQ==
X-Gm-Message-State: ACrzQf2ncp7YFN6Icb5CFeQxJhEHNmzwXMa1U2lmdXMVpBdD3H7pzWN+
        q+hjdKzuIMxQIePJysGsdO44ZcHhBw90hZopNRs=
X-Google-Smtp-Source: AMsMyM7wMH+u3GXKRVEHVtr9dRdGUlQLCdJ/vWKn1499LPQMHv2GcR2CRr22jquS5oJu7DNeyUpkx9eY14knp1zHJiY=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr662585ejn.302.1663806943354; Wed, 21 Sep
 2022 17:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 17:35:32 -0700
Message-ID: <CAEf4BzZ_KXymmLviTud1WoSwpPk49XZe9ZKQsbqzHxSpx2etKg@mail.gmail.com>
Subject: Re: [bpf-next v3 1/2] libbpf: Add pathname_concat() helper
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
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

On Sun, Sep 18, 2022 at 7:28 PM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Move snprintf and len check to common helper pathname_concat() to make the
> code simpler.
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 47 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3ad1392..43a530d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2096,19 +2096,30 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
>         return true;
>  }
>
> +static int pathname_concat(const char *path, const char *name, char *buf, size_t buflen)
> +{
> +       int len;
> +
> +       len = snprintf(buf, buflen, "%s/%s", path, name);
> +       if (len < 0)
> +               return -EINVAL;
> +       if (len >= buflen)
> +               return -ENAMETOOLONG;
> +
> +       return 0;
> +}
> +
>  static int build_map_pin_path(struct bpf_map *map, const char *path)
>  {
>         char buf[PATH_MAX];
> -       int len;
> +       int err;
>
>         if (!path)
>                 path = "/sys/fs/bpf";
>
> -       len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
> -       if (len < 0)
> -               return -EINVAL;
> -       else if (len >= PATH_MAX)
> -               return -ENAMETOOLONG;
> +       err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);

sizeof(buf) instead of PATH_MAX?

> +       if (err)
> +               return err;
>
>         return bpf_map__set_pin_path(map, buf);
>  }
> @@ -7961,17 +7972,9 @@ int bpf_object__pin_maps(struct bpf_object *obj, const char *path)
>                         continue;
>
>                 if (path) {
> -                       int len;
> -
> -                       len = snprintf(buf, PATH_MAX, "%s/%s", path,
> -                                      bpf_map__name(map));
> -                       if (len < 0) {
> -                               err = -EINVAL;
> -                               goto err_unpin_maps;
> -                       } else if (len >= PATH_MAX) {
> -                               err = -ENAMETOOLONG;
> +                       err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);

same, let's not hardcode constants we don't need to hardcode, just do
sizeof(buf)

> +                       if (err)
>                                 goto err_unpin_maps;
> -                       }
>                         sanitize_pin_path(buf);
>                         pin_path = buf;
>                 } else if (!map->pin_path) {
> @@ -8009,14 +8012,9 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>                 char buf[PATH_MAX];
>
>                 if (path) {
> -                       int len;
> -
> -                       len = snprintf(buf, PATH_MAX, "%s/%s", path,
> -                                      bpf_map__name(map));
> -                       if (len < 0)
> -                               return libbpf_err(-EINVAL);
> -                       else if (len >= PATH_MAX)
> -                               return libbpf_err(-ENAMETOOLONG);
> +                       err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);

ditto here and all the cases below

> +                       if (err)
> +                               return err;
>                         sanitize_pin_path(buf);
>                         pin_path = buf;
>                 } else if (!map->pin_path) {
> @@ -8034,6 +8032,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>  int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>  {
>         struct bpf_program *prog;
> +       char buf[PATH_MAX];
>         int err;
>
>         if (!obj)
> @@ -8045,17 +8044,9 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>         }
>
>         bpf_object__for_each_program(prog, obj) {
> -               char buf[PATH_MAX];
> -               int len;
> -
> -               len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
> -               if (len < 0) {
> -                       err = -EINVAL;
> -                       goto err_unpin_programs;
> -               } else if (len >= PATH_MAX) {
> -                       err = -ENAMETOOLONG;
> +               err = pathname_concat(path, prog->name, buf, PATH_MAX);
> +               if (err)
>                         goto err_unpin_programs;
> -               }
>
>                 err = bpf_program__pin(prog, buf);
>                 if (err)
> @@ -8066,13 +8057,7 @@ int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>
>  err_unpin_programs:
>         while ((prog = bpf_object__prev_program(obj, prog))) {
> -               char buf[PATH_MAX];
> -               int len;
> -
> -               len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
> -               if (len < 0)
> -                       continue;
> -               else if (len >= PATH_MAX)
> +               if (pathname_concat(path, prog->name, buf, PATH_MAX))
>                         continue;
>
>                 bpf_program__unpin(prog, buf);
> @@ -8091,13 +8076,10 @@ int bpf_object__unpin_programs(struct bpf_object *obj, const char *path)
>
>         bpf_object__for_each_program(prog, obj) {
>                 char buf[PATH_MAX];
> -               int len;
>
> -               len = snprintf(buf, PATH_MAX, "%s/%s", path, prog->name);
> -               if (len < 0)
> -                       return libbpf_err(-EINVAL);
> -               else if (len >= PATH_MAX)
> -                       return libbpf_err(-ENAMETOOLONG);
> +               err = pathname_concat(path, prog->name, buf, PATH_MAX);
> +               if (err)
> +                       return libbpf_err(err);
>
>                 err = bpf_program__unpin(prog, buf);
>                 if (err)
> --
> 1.8.3.1
>
