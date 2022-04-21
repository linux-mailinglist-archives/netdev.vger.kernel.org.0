Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6335050A653
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387208AbiDUQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385664AbiDUQ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 12:58:09 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A61DF06;
        Thu, 21 Apr 2022 09:55:19 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id g21so5927812iom.13;
        Thu, 21 Apr 2022 09:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LaCuNqz23w9a5w7Pz3RIjEiDWBgRwylEstU9JveB5lk=;
        b=YyiGvUT/avLzwSpdf6qDyTEgpemoWsOeN6neVUe5AYsTTUMzchfT6vUlpkSu2h0JkF
         0wiuNKeGvoE8NWiaO+bDIw1cXDaZRNlM5MNhMpFWMEg6IVd0dgL/HTjTrEvJQi6cNi4p
         lOXvvI/Cdxzaa7LT3CG7LiQxYBVhuQH4W3g4uEK5lBLjl51Z0Q/dHhYPday992oPMg1R
         4YUue0oCAvN8M/8/8E9NZm0YHI4s0HQkEk3BHP+/UYFCy3IyzQOvdQW2r0Ne/em2exRR
         rpa/8auoJL8aFJidQHjp7/BxKsU2stm6qWFQ5G4O85REvAVNoSsYMi6TS3yw30STxf4X
         XZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LaCuNqz23w9a5w7Pz3RIjEiDWBgRwylEstU9JveB5lk=;
        b=CYWeyjSR98lkVDETFCmtioo1Ieu3yGeqmSvIDhl7+Xq9lb4QWJJrjwF3PaF0xyv2MZ
         w3G8lRVNy9YzWdMGhXoI8olHuQPhFhr07+sq6YOKIqnxr/JG2OVnSPhxNJdLr7jadzLD
         woVIt5kNUUvxXKOZgzXnAZeB+sO7Q0SmafBTLT+6TLVAcNooyWn4IP8rW78q9hUX8CHG
         WbBRQNZZ0G3b4CCM0CTQ2V89NUXywEopYNFNbO6FoQAjBmdzzosWfbHjvYds+1RKFUa3
         wZyZ0iI0drxevhdzGcM4KQBVoIgzUt4HFwvl/MdxI+y1gkzDDvAbx6vIgVTO4m1Y05oX
         WZWQ==
X-Gm-Message-State: AOAM533SqQ7RiZnnero7lXywkAc7KpOesDbEPivofU7cR4h6ZY90RL0O
        5apksa/4iSxHacHiLA5B8/ZRV5eXr88ekMUTyDI=
X-Google-Smtp-Source: ABdhPJynbin9/LS+2C2qfpD575v+NmYefKbZcieEnacGzcACE8ZeWO0BN3dqJIhMcKBsw7w2uOlxWbYv629Bdvf99yw=
X-Received: by 2002:a05:6638:3393:b0:32a:93cd:7e48 with SMTP id
 h19-20020a056638339300b0032a93cd7e48mr277380jav.93.1650560119063; Thu, 21 Apr
 2022 09:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220421130056.2510372-1-cuigaosheng1@huawei.com>
In-Reply-To: <20220421130056.2510372-1-cuigaosheng1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 Apr 2022 09:55:08 -0700
Message-ID: <CAEf4Bza3inoAHsS0w=nKXNgxyFqzPXJVyDHq03Foody6Vgp7=Q@mail.gmail.com>
Subject: Re: [PATCH -next] libbpf: Add additional null-pointer checking in make_parent_dir
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        gongruiqi1@huawei.com, wangweiyang2@huawei.com
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

On Thu, Apr 21, 2022 at 6:01 AM Gaosheng Cui <cuigaosheng1@huawei.com> wrote:
>
> The make_parent_dir is called without null-pointer checking for path,
> such as bpf_link__pin. To ensure there is no null-pointer dereference
> in make_parent_dir, so make_parent_dir requires additional null-pointer
> checking for path.
>
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b53e51884f9e..5786e6184bf5 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7634,6 +7634,9 @@ static int make_parent_dir(const char *path)
>         char *dname, *dir;
>         int err = 0;
>
> +       if (path == NULL)
> +               return -EINVAL;
> +

API contract is that path shouldn't be NULL. Just like we don't check
link, obj, prog for NULL in every single API, I don't think we need to
do it here, unless I'm missing something?

>         dname = strdup(path);
>         if (dname == NULL)
>                 return -ENOMEM;
> --
> 2.25.1
>
