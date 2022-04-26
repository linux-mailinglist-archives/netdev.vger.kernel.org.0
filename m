Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A950F17D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbiDZGuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242936AbiDZGur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:50:47 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C791245B0;
        Mon, 25 Apr 2022 23:47:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id p62so18392693iod.0;
        Mon, 25 Apr 2022 23:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3bcW6bjqKAaF3e6ps6lc+5dQTOGg5LPeA9dp3wn8TNk=;
        b=lAO2NRj5MFDOrzfoE51HiLxJgZUOfnlE4Wedu6mn7PMMbP65OstJ6RCAo9f+Nzkqmb
         1cN9W3ppdiFGiFg1ihT3gI+rObOYTAWNbIWf32JjjtxpoAbIpS56vg7o7aODlJYAaUjC
         bLDFIWp5aVTpKDAWEpaKAQl7Mt/AZDTX683h1ZsG3zFSUGM3hRQYGcmTXnb/VY7v2ODA
         kqyJSwMFsZzk8PoBDA2oEINinGg3K/OUmFj+u//zlLwJoFiHsHcVB8CsYoloj4C8gCAV
         3obZ9GbIc/K5GNuJZxstKAoKVhmn5NAPlq2Mzh2A3aM5pGKAUSbeveYxg2VMQh9V0N62
         GQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3bcW6bjqKAaF3e6ps6lc+5dQTOGg5LPeA9dp3wn8TNk=;
        b=e3v6q+EpWWKqrLwWq2vlMGvw7V57TF1xo41I1+ZEBnxQMQL7rMBQtlWdWzIy8HYTyn
         RkeS50OrvYnf8946dMe5cREd+d1+d5hGC/ecejg3/8ocL+WFrIiIRdXHwbieBjv9GVya
         a7U8v0zV9bwKMfGsp3TEkHlss/FrKIMFqEI4QyS8jI4rzqoTeWCO6PTpxgt+NiXy5maY
         MONGqrcQTcfGwNUsdjgNeKQCKHHH6URg6vjwKy8+zGkckab9q3rB9IkrK5HBcqQUbLo+
         jxbarxuvPfMA5+uWutzWZRGrHzZL5YDxIMQDWf1hc3RhXBjPRdrlU4EEcz+O8PVFnMB3
         IlqQ==
X-Gm-Message-State: AOAM532xbpaOhE3Q1VwjfTnREpul0D6F4IW8gazqlqu7dXUY2wUa/Uta
        94q6C5Bzp9pQaI87aYLx5LPWejA0pPBpU5DYra+kgPSO
X-Google-Smtp-Source: ABdhPJyPKGSuyNMogyQI9mwxbS+8i4FzOt/x4ctuwMqNnuVfUHgb/1Ysz0W5x8elQQIe9x6wbOL8g5ac/y0YDfCL3Vw=
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id
 j19-20020a056638053300b0032ad418b77bmr5771111jar.237.1650955659841; Mon, 25
 Apr 2022 23:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-4-laoar.shao@gmail.com>
In-Reply-To: <20220423140058.54414-4-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:47:29 -0700
Message-ID: <CAEf4BzapX1CKCX5VWwMkbm5yHukq36UxwcXDduQCMW=-VEEv4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] bpftool: Fix incorrect return in generated
 detach helper
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, Apr 23, 2022 at 7:02 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> There is no return value of bpf_object__detach_skeleton(), so we'd
> better not return it, that is formal.
>
> Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  tools/bpf/bpftool/gen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7678af364793..8f76d8d9996c 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1171,7 +1171,7 @@ static int do_skeleton(int argc, char **argv)
>                 static inline void                                          \n\
>                 %1$s__detach(struct %1$s *obj)                              \n\
>                 {                                                           \n\
> -                       return bpf_object__detach_skeleton(obj->skeleton);  \n\
> +                       bpf_object__detach_skeleton(obj->skeleton);         \n\

It's not incorrect to return the result of void-returning function in
another void-returning function. C compiler allows this and we rely on
this property very explicitly in macros like BPF_PROG and BPF_KPROBE.
So if anything, it's not a fix, at best improvement, but even then
quite optional.


>                 }                                                           \n\
>                 ",
>                 obj_name
> --
> 2.17.1
>
