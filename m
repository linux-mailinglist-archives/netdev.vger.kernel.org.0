Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57E352AFC7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbiERBRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiERBRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:17:20 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB4A2C102
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:17:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h14so551530wrc.6
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66BpVpX1hmsXLIKfSSFdSpdl5oqz90D5jwxwG9o6mz4=;
        b=xRYWEaCNYX3CRkGbSb4Lw1NbuD1fUhSJXWVeeeS+fYrLui8cAamp3GLZ5IrJmOwlHL
         cIwxRHBDy2EYZaX5HQlzo5cHlmXO4fc6AkevIifcdVt3aqG/EefBANpLhfO/IgGNThLi
         XXLG+lLTKSGbegkuAdO/g7AGpPVLaAUdZSBWcy+FO+q+hMmllMvXwCPop9daonKuHsTB
         tglkvTKV9qIWdLh0wlZz6dVSqg1zMF7WsuVzxKms+6AHzX2isFrEv75VOukGFsUyZy5D
         pNTnRKdGNlqV7iWjgnlst45h2wwejrXC1qf/n4xNGqx+LtpHMX4qYW1fo7tfBm8x3pQy
         1pRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66BpVpX1hmsXLIKfSSFdSpdl5oqz90D5jwxwG9o6mz4=;
        b=BiNyf01RI6mKQj9Zc8BnNm+sA++DcatnhCCRduZcyfvhL6y6imxcAwGdVJrEpFCTG7
         11+1SSh5IOQV2hZaVMLvVUs1Y10SAmcQ8kKwCJjMqq20kaI7JvGKLd2BKVDG3+Zl59Ie
         v+cZQgmKqKH4qLB4otwCWvpVfmVbz3HmHbxeAWccJ7LVYk92eLp81iFwSR7CUVdZuiPk
         fIgb3CKsqjwD2f6snEbP5iXfJuP6lUj5DcPryA77EN6f3WKjFzm5uuaEaUqlAgbIaNQX
         Z+ZECU2sn/p+qeoYoCk//7OPAlOQ6HIJ6y4WENN7hsvOMU5+6BygPU+0fGdUxUqWLdxg
         TAlQ==
X-Gm-Message-State: AOAM532Qz7jXA4dyKGg1xqDMIQmQYdNfffusb9wh4bHhuXZORL962FW2
        w6QHG7su7ap8nqcVs9nSOcaamIzp6uWxCcvm9uSx
X-Google-Smtp-Source: ABdhPJwgGJ20dTMB4rX7QcbmClGxzMeLSl+5R1372QnAoz8I90LnDWXFMl7B7wWxBi+NGEuc+n5MNXshqKaGIp7Rhoc=
X-Received: by 2002:a5d:5888:0:b0:20c:9868:9d94 with SMTP id
 n8-20020a5d5888000000b0020c98689d94mr19998482wrf.433.1652836636768; Tue, 17
 May 2022 18:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220503183750.1977-1-duguoweisz@gmail.com>
In-Reply-To: <20220503183750.1977-1-duguoweisz@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 17 May 2022 21:17:06 -0400
Message-ID: <CAHC9VhRfRKS_-A6LGhgMp06wsvHtRj6ZaiQWp8c7U_LXozTeYg@mail.gmail.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
To:     Guowei Du <duguoweisz@gmail.com>
Cc:     jack@suse.cz, amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jmorris@namei.org, serge@hallyn.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, selinux@vger.kernel.org,
        duguowei <duguowei@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 2:38 PM Guowei Du <duguoweisz@gmail.com> wrote:
>
> From: duguowei <duguowei@xiaomi.com>
>
> For now, there have been open/access/open_exec perms for file operation,
> so we add new perms check with unlink/rmdir syscall. if one app deletes
> any file/dir within pubic area, fsnotify can sends fsnotify_event to
> listener to deny that, even if the app have right dac/mac permissions.
>
> Signed-off-by: duguowei <duguowei@xiaomi.com>
> ---
>  fs/notify/fsnotify.c             |  2 +-
>  include/linux/fs.h               |  2 ++
>  include/linux/fsnotify.h         | 16 ++++++++++++++++
>  include/linux/fsnotify_backend.h |  6 +++++-
>  security/security.c              | 12 ++++++++++--
>  security/selinux/hooks.c         |  4 ++++
>  6 files changed, 38 insertions(+), 4 deletions(-)

...

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e9e959343de9..f0780f0eb903 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1801,8 +1801,12 @@ static int may_create(struct inode *dir,
>  }
>
>  #define MAY_LINK       0
> +#ifndef MAY_UNLINK
>  #define MAY_UNLINK     1
> +#endif
> +#ifndef MAY_RMDIR
>  #define MAY_RMDIR      2
> +#endif

In the future if you run into a symbol collision here I would prefer
if you renamed the SELinux constants to something like SEL_MAY_LINK,
etc.

-- 
paul-moore.com
