Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8CF4F5423
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350459AbiDFE1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360332AbiDFD3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:29:30 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80897A1B5;
        Tue,  5 Apr 2022 17:06:41 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id x4so1134193iop.7;
        Tue, 05 Apr 2022 17:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3uMVUs0pn/UnCcTOPF5ZwVE7HfFfyD9+Ot9Na3BVDg=;
        b=Sn10JKm5Gx81Pb9OAi6xGf7VB1Ch3jSbp5gOqq1G8UWNcNp2We6C0osV9LAQJZd5co
         /jJgcaqfdJ1vpR4sj4bAUd8H+k8++2SaS6WAANVD3ZVgRZNWPFdkFGcJ0WSWEIllFMYX
         uatxTj1zt02nzSpzjozns85ATeJGMkrpvXnwV4u9dvvVUwWlPeyw2uwS3gy51zBrPLIZ
         GtxzYaQaPNGqvpu1xF1+AW7iMC2r3+v3mI2Cap8cLmopZlgH0lVi9pEp7WHqv9rpFPU1
         l9pXMvCMivjpKOs/TCSCYb903Y9bvN2P/HmCireQ2XeqLFKc2Wxtgb2MIGvMNsV/XDWD
         QtXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3uMVUs0pn/UnCcTOPF5ZwVE7HfFfyD9+Ot9Na3BVDg=;
        b=2tE+Uivqe388CJFSO4f++T8iXMjpNPMRNjzW79oNIV3gKlUCG0uA5hyvOZMh1mzKzb
         mIsQ6ifky7E6KWs4h43N6kQqnU5RGuUke4iDJjSaw4LzdpOxO1yjBhGzuNXiyVOIcW96
         r9vguuHmP+xxSO8vICF9wwhC+L3Id63i1e2WwC583XPceqM4ObSGRkRiPTndcNObzDos
         F+3doSTtH3fAhNxX8RoumIcozx8tDWqguYoKGFFoEyi7qC29tsBIIo99PJmEV7dmFlcC
         o+7BZZWZU7jYE2zjEZ61UhCQ0/tSB1WtsjhZzmA7Qv12wn/EifYOT5d47p79KPNCZVW/
         AmSA==
X-Gm-Message-State: AOAM5300iZY3Fv7FrUIAZk7iUCqTyUhcT1DV9bJvcJQIi8i16k7j4U8c
        EArVheRC0pwgzrwTbF5SS27CsHqzIsdgnNgKIJ8=
X-Google-Smtp-Source: ABdhPJzGj/GFTls1C8LAXPe5rdMV1t91aQf9IZ8VFJuT1Ht+PqB/QUaSF5fRCRGwrSuONWHnvwJWnJxLmtb+0gxqBLs=
X-Received: by 2002:a05:6638:1685:b0:323:9fed:890a with SMTP id
 f5-20020a056638168500b003239fed890amr3250312jat.103.1649203600893; Tue, 05
 Apr 2022 17:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <1649195156-9465-1-git-send-email-alan.maguire@oracle.com> <1649195156-9465-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1649195156-9465-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 17:06:30 -0700
Message-ID: <CAEf4BzZuz5NVzDa=srfvuMtMg6Jmy85bAaBkgSXiz8h2aTQ9Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: improve string handling for uprobe
 name-based attach
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
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

On Tue, Apr 5, 2022 at 2:46 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> For uprobe attach, libraries are identified by matching a ".so"
> substring in the binary path.  This matches a lot of patterns that do
> not conform to library .so[.version] suffixes, so instead match a ".so"
> _suffix_, and if that fails match a ".so." substring for the versioned
> library case.
>

You are making two separate changes in one patch, let's split them.

> For uprobe auto-attach, the parsing can be simplified for the SEC()
> name to a single ssscanf(); the return value of the sscanf can then

too many sss :)

> be used to distinguish between sections that simply specify
> "u[ret]probe" (and thus cannot auto-attach), those that specify
> "u[ret]probe/binary_path:function+offset" etc.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c          | 77 ++++++++++++++++-------------------------
>  tools/lib/bpf/libbpf_internal.h |  5 +++
>  2 files changed, 35 insertions(+), 47 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 91ce94b..3f23e88 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10750,7 +10750,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>         const char *search_paths[3] = {};
>         int i;
>
> -       if (strstr(file, ".so")) {
> +       if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
>                 search_paths[0] = getenv("LD_LIBRARY_PATH");
>                 search_paths[1] = "/usr/lib64:/usr/lib";
>                 search_paths[2] = arch_specific_lib_paths();
> @@ -10897,60 +10897,43 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>  static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> -       char *func, *probe_name, *func_end;
> -       char *func_name, binary_path[512];
> -       unsigned long long raw_offset;
> +       char *probe_type = NULL, *binary_path = NULL, *func_name = NULL;
> +       int n, ret = -EINVAL;
>         size_t offset = 0;
> -       int n;
>
>         *link = NULL;
>
> -       opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe");
> -       if (opts.retprobe)
> -               probe_name = prog->sec_name + sizeof("uretprobe") - 1;
> -       else
> -               probe_name = prog->sec_name + sizeof("uprobe") - 1;
> -       if (probe_name[0] == '/')
> -               probe_name++;
> -
> -       /* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
> -       if (strlen(probe_name) == 0)
> -               return 0;
> -
> -       snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
> -       /* ':' should be prior to function+offset */
> -       func_name = strrchr(binary_path, ':');
> -       if (!func_name) {
> +       n = sscanf(prog->sec_name, "%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%zu",

note that previously you were using %li for offset which allows
decimal and hexadecimal formats, I think that's convenient, let's
allow that still

> +                  &probe_type, &binary_path, &func_name, &offset);
> +       switch (n) {
> +       case 1:
> +               /* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
> +               ret = 0;
> +               break;
> +       case 2:
>                 pr_warn("section '%s' missing ':function[+offset]' specification\n",
>                         prog->sec_name);

please use 'prog '%s': ' prefix in these attach_xxx() functions for consistency

> -               return -EINVAL;
> -       }
> -       func_name[0] = '\0';
> -       func_name++;
> -       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> -       if (n < 1) {
> -               pr_warn("uprobe name '%s' is invalid\n", func_name);
> -               return -EINVAL;
> -       }
> -       if (opts.retprobe && offset != 0) {
> -               free(func);
> -               pr_warn("uretprobes do not support offset specification\n");
> -               return -EINVAL;
> -       }
> -
> -       /* Is func a raw address? */
> -       errno = 0;
> -       raw_offset = strtoull(func, &func_end, 0);
> -       if (!errno && !*func_end) {
> -               free(func);
> -               func = NULL;
> -               offset = (size_t)raw_offset;
> +               break;
> +       case 3:
> +       case 4:
> +               opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe");

you just parsed probe_type, strcmp() against that instead, no need for
prefix check

> +               if (opts.retprobe && offset != 0) {
> +                       pr_warn("uretprobes do not support offset specification\n");
> +                       break;
> +               }
> +               opts.func_name = func_name;
> +               *link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> +               ret = libbpf_get_error(*link);
> +               break;
> +       default:
> +               pr_warn("uprobe name '%s' is invalid\n", prog->sec_name);

Add "prog '%s': " prefix. Also, the section name is not an uprobe
name. Maybe "prog '%s': invalid format of section definition '%s'\n"?

> +               break;
>         }
> -       opts.func_name = func;
> +       free(probe_type);
> +       free(binary_path);
> +       free(func_name);
>
> -       *link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> -       free(func);
> -       return libbpf_get_error(*link);
> +       return ret;
>  }
>
>  struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index b6247dc..155702a 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -103,6 +103,11 @@
>  #define str_has_pfx(str, pfx) \
>         (strncmp(str, pfx, __builtin_constant_p(pfx) ? sizeof(pfx) - 1 : strlen(pfx)) == 0)
>
> +/* similar for suffix */
> +#define str_has_sfx(str, sfx) \
> +       (strlen(sfx) <= strlen(str) ? \
> +        strncmp(str + strlen(str) - strlen(sfx), sfx, strlen(sfx)) == 0 : 0)
> +

so str_has_pfx() is a macro to avoid strlen() for string literals.
Here you don't do any optimization like that and instead calculating
and recalculating strlen() multiple times. Just make this a static
inline helper function?

and you don't need strncmp() anymore, strcmp() is as safe after all
the strlen() checks and calculations



>  /* Symbol versioning is different between static and shared library.
>   * Properly versioned symbols are needed for shared library, but
>   * only the symbol of the new version is needed for static library.
> --
> 1.8.3.1
>
