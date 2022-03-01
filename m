Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4084C9088
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiCAQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCAQjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:39:18 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B993BBEA
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:38:34 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id dy10so2139006qvb.6
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 08:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3oyHDJPXz4MUJgBElW4MaL2dWxxSt5ih3fxmiK5Gs50=;
        b=biU6fsA9UrmFW3BIfaYv5RzawE4Tvt4q/tuJ4G/JQzTVzsvnQkkFS85DkakG9eiGTJ
         nEcbJvECd4Cha/qgxSiVok0JT6iW0D25p0NyClDMHEu8jgkoMVJk/5XEPiiZIu0vAB44
         z/D5vXpGjby5sIB0dKN9jnm8NzVL8I305WeIf791sBTbYhguhUT9ESBrbMJq+fk1l0vx
         N302M1QWTbmMb49UP8I/VrF37DAe8hQKmIH0qOsKZzkvG9CYmbY2Ir3b82MMAgJUQQz3
         Km6BV7bCnyaUhQROiLxoujwvWrzDPw1KcIFMEHlt8VhJxJ1Z2zzmbk7EPVbS6bHBlpBC
         LltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3oyHDJPXz4MUJgBElW4MaL2dWxxSt5ih3fxmiK5Gs50=;
        b=BRngJbpx1io4pbcpoD4vq8/ca/H3eWkqIy7ADE07wklhl2764ENYcOk+u2lzdxeJUF
         LD8wSEFOognrpAKXmJ0ybxgnEegb1BpLSvH90rKKxolfhL0FQyG9jdnDVcI5NsRKuHhP
         30bD9xijoJFPfdaDY8wyJ/cQ1xm2tbY1xitqYEeaeAxPoQ41rBZ0PuJlbgrSrvbUdjzg
         TiCScFZi+YagLM5km6AaZou4t9PbPSnYdqBu0n1o8Xm5qIJRRuTH3w3GnJqlvj+hYME2
         atMnYw7kjW3c1JQTy3PVqM70lkh317CwFMq91BN3KK1y2QwW/6Gwbm7XXusZSTYhhzdz
         HxmA==
X-Gm-Message-State: AOAM5323mJhBjB6eX6wI8P9GNu7WAMnF8KJ17d04NyFqAQ08c+yWsXtb
        erFyZAN3iHP98xOOWWA+1orClUXROz+2iodLq+Zox8Tomjhd7A==
X-Google-Smtp-Source: ABdhPJwQugZDd7FBcl55Uiy4B5juwSw6Er9YBu2Rdfc92MOO/fr+SVNg95zVcDNOFOwnICrqENeY4DIQ3xHg0BazFSk=
X-Received: by 2002:a05:6214:d42:b0:431:d89a:66b6 with SMTP id
 2-20020a0562140d4200b00431d89a66b6mr18251002qvr.58.1646152713708; Tue, 01 Mar
 2022 08:38:33 -0800 (PST)
MIME-Version: 1.0
References: <20220228232332.458871-1-sdf@google.com> <6a6333da-f282-09d2-fd2d-cb67e33a07a1@iogearbox.net>
In-Reply-To: <6a6333da-f282-09d2-fd2d-cb67e33a07a1@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 1 Mar 2022 08:38:22 -0800
Message-ID: <CAKH8qBuPws+aYA-+sbqA2-NEPXNjmmHVGfU99Xb1LD7LomAa3A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: test_run: Fix overflow in xdp frags bpf_test_finish
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 8:33 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/1/22 12:23 AM, Stanislav Fomichev wrote:
> > Syzkaller reports another issue:
> > WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> > check_copy_size include/linux/thread_info.h:230 [inline]
> > WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> > copy_to_user include/linux/uaccess.h:199 [inline]
> > WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
> > bpf_test_finish.isra.0+0x4b2/0x680 net/bpf/test_run.c:171
> >
> > This can happen when the userspace buffer is smaller than head+frags.
> > Return ENOSPC in this case.
> >
> > Fixes: 7855e0db150a ("bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature")
> > Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
> Do we have a Reported-by tag for syzkaller so it can match against its report?

Oops, sorry, totally forgot:

Reported-by: syzbot+5f81df6205ecbbc56ab5@syzkaller.appspotmail.com
