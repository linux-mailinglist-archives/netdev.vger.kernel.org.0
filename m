Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DE72F1E66
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390521AbhAKTAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731583AbhAKTAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:00:18 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EFDC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:59:38 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id v3so185066ilo.5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 10:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iid3TDnaf9WQOqcIoQQgF4jMfSru8r+JKK19trGCH3g=;
        b=WMMAmJvQ8UcbFldHDjquXbDsP0TIlYtorRi2Uu/PLkIDQsreMFAMyZMlI/NI9hUY9S
         81pMyILWj2c/HKpa5XzHz3JwmUf9xqIl4A4HrBwjrX0Icg8g3qVDO5xbpUldgHZqr61G
         2amaac2UZxh7fpQmI5H7FEVQTiE7I1X1ugIfWBDP/nGvpZW4gcnYH37NLe20sMYxVVAt
         CpppInJmOlpTT5M898u+a7XFmZvt0Bbq7pfx2QxW22NksMjU/hli/8JDU24bl00/zsc2
         DlLoLuNz6SUpbjvE7gaAeJ1FQ3eq/VGo59qukMepqLgWsFQP1G0BcFZCaL4xhtQjfOxc
         E84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iid3TDnaf9WQOqcIoQQgF4jMfSru8r+JKK19trGCH3g=;
        b=R2A5zXRylk8IW36lmEo8n/GdtWuf5ASouRv6l1h4sfCjA/9X6kp35TItjZQbyTFsct
         X8t6qvr+zSyW7CqUGh3dwnkMSo63Nwu1WemioeUcihFfbli1KxDZVL07m+OqRBbJoo/v
         +ybn1M6HhaM0AdzObPHTbSl1UG/LXQD0y2BEPsY6+0TAOmOH9c+N3ne8iD9dT4HNnIVL
         wmgecwnDDGx0+ljpef+WV6QV7qn/ra+II4B8ISUnMxg/0FAvEnFcQ6iSe2nwfGhU1S5m
         FotTTku51MPwRdwmDHizBbw6s9j+PCZwNsoxPez7Tsvd9yQjAtyeCXba3lWTJZKklXmZ
         TgHw==
X-Gm-Message-State: AOAM530I5Tzufy9dcybtSSAXLe+omRrM4UvGyP0nf2v++HG5J6MrAK+x
        S74GwTB+GYxQEr1OYy4G8y6G/RfCi379fw4WII5t+g==
X-Google-Smtp-Source: ABdhPJy8h7ZPQl6W8ujlx7HY6S5M1edD1HQfVY0iKicGbb+yL1zF2wliH+064vPJxkqEodqFjkcFjFhXODkSIL8dJwQ=
X-Received: by 2002:a92:351c:: with SMTP id c28mr533060ila.61.1610391577408;
 Mon, 11 Jan 2021 10:59:37 -0800 (PST)
MIME-Version: 1.0
References: <20210108220930.482456-1-andrii@kernel.org> <20210108220930.482456-5-andrii@kernel.org>
 <2e7a9040-6b16-bb9f-0cab-73161899e1f1@fb.com>
In-Reply-To: <2e7a9040-6b16-bb9f-0cab-73161899e1f1@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Mon, 11 Jan 2021 10:59:26 -0800
Message-ID: <CA+khW7jcXf=qLQB1zcV9TQKNKb64onWicmrx3iH8FNj5broahA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: sync RCU before unloading bpf_testmod
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Hao Luo <haoluo@google.com>

On Sun, Jan 10, 2021 at 8:05 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> > If some of the subtests use module BTFs through ksyms, they will cause
> > bpf_prog to take a refcount on bpf_testmod module, which will prevent it from
> > successfully unloading. Module's refcnt is decremented when bpf_prog is freed,
> > which generally happens in RCU callback. So we need to trigger
> > syncronize_rcu() in the kernel, which can be achieved nicely with
> > membarrier(MEMBARRIER_CMD_GLOBAL) syscall. So do that in kernel_sync_rcu() and
> > make it available to other test inside the test_progs. This synchronize_rcu()
> > is called before attempting to unload bpf_testmod.
> >
> > Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Yonghong Song <yhs@fb.com>
