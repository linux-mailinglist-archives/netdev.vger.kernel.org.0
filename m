Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A068D410
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjBGK16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjBGK15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:27:57 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991641E5D0
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:27:56 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso12819485wms.0
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 02:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K/a/KL0bMWPgC9CXdCThMrZjlb8QhLXnYKCv4iWo4eY=;
        b=fiugTAuV3sCHtZpCy7nobQTJAl15kavC6CnHqVNMjy3NLSv2d3Osq+HM3sPpS9jrhh
         O9wBFiy0GIXgh/YkxT1WIB+UuNT1bPFDjI7WuBs1AeHcybSL+bkg/k/hAL5B3ABTu0Wr
         4/LxKU6DtyrHfUIrKTKMFRExFla0p8cchTpwd+F/WfwIZJ7TfL6Wi9G7ZEaZjKZOrRzk
         nCSE4zQVh/rMPLGB7Jst8Bi9bLOmnUQvjCOHXfdGN0yG79C0/B84SJdiWdgiHk7Nnj9F
         lo7hXrw/4Z9WDX6nC6qdq1KlsBIgXmP6nxkpvEyY0eOl9dU39dY6v7acuJNF2wzoPgYH
         smoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/a/KL0bMWPgC9CXdCThMrZjlb8QhLXnYKCv4iWo4eY=;
        b=xaEfPOs9OcgQ/wgsna0U45/BhaGLzOaoazyEy1pL5bZrgrmA45jOgeLZhtQUlohkPB
         ZzqSonqr1WCkUU5xD963BDzUd8/G0ZYxIzoISkbFqxXhAkWQko4GfLyHXK/uWGvrzscu
         gL88Ge/kYVgtObbTd/ilSzAcd7ivQx5vKVRQkBnMYu+kzP/JdkBwwovfiP8oJNw7PUrx
         azK6M1zgcqL99Gtiym4sHHb/GIYeJrcV7+3GfJVOx/POPZAlvofqRoJzh0PY72GH9PVm
         MuSLL6r3UGyScNjEnnmCgwSlMmVEtDkjCOtPbBPwqXbYY4ON9IxwAKhknUv5/C8zEzc6
         U9/A==
X-Gm-Message-State: AO0yUKXqrG0SPgPaql83efIqvyPaCFpDA+3Q1cfigejtWXMnyd6z/4v7
        wYUlIfQ6/6Co3yc55F0Zx+X5P1DRZoW9aHu4LSuk+w==
X-Google-Smtp-Source: AK7set8uundn64WctW8w+1nCqgFhNuk8A7jJVnmPWQzU+hczWhZe0Z5JvnFwg5y6ifGJr6fu528b/lyBCyyZJ+4KtRA=
X-Received: by 2002:a05:600c:a0c:b0:3da:27f7:b3da with SMTP id
 z12-20020a05600c0a0c00b003da27f7b3damr977923wmp.176.1675765675152; Tue, 07
 Feb 2023 02:27:55 -0800 (PST)
MIME-Version: 1.0
References: <000000000000269f9a05f02be9d8@google.com> <000000000000ce7ebf05f40de992@google.com>
In-Reply-To: <000000000000ce7ebf05f40de992@google.com>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Tue, 7 Feb 2023 11:27:43 +0100
Message-ID: <CANp29Y5SaORjhSL2X2gHw57532G=ZiecZm4XXKTOQv+dZh+EXA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in copy_verifier_state
To:     syzbot <syzbot+59af7bf76d795311da8c@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        keescook@chromium.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, sdf@google.com, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, v4bel@theori.io,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 6, 2023 at 9:31 PM syzbot
<syzbot+59af7bf76d795311da8c@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 45435d8da71f9f3e6860e6e6ea9667b6ec17ec64
> Author: Kees Cook <keescook@chromium.org>
> Date:   Fri Dec 23 18:28:44 2022 +0000
>
>     bpf: Always use maximal size for copy_array()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14c62f23480000
> start commit:   041fae9c105a Merge tag 'f2fs-for-6.2-rc1' of git://git.ker..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e2f3d9d232a3cac5
> dashboard link: https://syzkaller.appspot.com/bug?extid=59af7bf76d795311da8c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1650d477880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1305f993880000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: bpf: Always use maximal size for copy_array()

Seems reasonable to me.

#syz fix: bpf: Always use maximal size for copy_array()

>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000ce7ebf05f40de992%40google.com.
