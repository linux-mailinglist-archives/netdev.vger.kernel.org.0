Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD032F3D2D
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405595AbhALVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437011AbhALUlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:41:36 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE4BC06179F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:40:56 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id j21so900195oou.11
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GOqyNTF7gtUKPVXIMkVFT3geI3snsFvpWMRi06NItYY=;
        b=ZhmlJV62BeU9fJsGlfyvETF+LCKlVC2NajZUVYu+YTBpcA7oEZg+f+cRZvbeGR/wRn
         OE8OA5J2WD9Pyviogsk4vAUx0oNQmVzR8vJjuNxc6R/JAdYYrMuliwJOKaeispULA4s3
         Paz/kpI+jzpctNP+2Igp6sNge3FY1sSX/OxQO1Mm77d4BSdi0VixLEpB9NM9zsJDNE17
         nTGyKfNHi0f22Ba4gFcYkm4igDeQKN59JTV5QfhwG9iHkwNEih7lMpfyyre20lo295AS
         5hblNfZ5Rfz6/jFNkOzYEb9rWjcEeyiCbtE5JTqFWgE0Ik2pVEOWGwT+0JfXpFcHqAKJ
         wqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GOqyNTF7gtUKPVXIMkVFT3geI3snsFvpWMRi06NItYY=;
        b=c6zruqkbKWypCrD1fiy+Jdsd6jaIAILw99YIjoHA2pjeKxueBHH6uFtR2S/nNvtNIN
         hCBUVS5C7Kd5GaCjgZnpvY/YDJNq/NYo8iO5iAfBBUw65dn27boMTF+1Y0Azj8zbBBB9
         N2wbNWTuMIYnhZ65Lb1LlL5vt4L7dTlrBl7qYDfQKk2V+7C8n08AoJi/gg0oGPxwrSRL
         Kqz02qiWN7zHm6HvsNaShi+jwc86iumFwTBGVfzRU+331QfnsNanuAsC1OLSY4YQj0W0
         6PhdNksum58P/e1Nl65uZtMOEboost/jEF9ltouO7WLLCOM+D9bz3X3Wwny1XtdmTyQ2
         R7Ew==
X-Gm-Message-State: AOAM531JKovpf19WH1F77YMpinJ6fJGSRgrV/2I3UTinhrpUWg0VuJ1M
        Ir/rRNbDqgwL/CXq3PCQqrsL7WSeyvSaCsvmHhGwGA==
X-Google-Smtp-Source: ABdhPJz/+VG3D8S0Su6wBVIT9oU9vLMwvxqzB/oumqqIsu0lWVXQRoNiE9y/Wv8b1dAsLKpTLLAHvt9lQNMSp/UwXic=
X-Received: by 2002:a4a:d396:: with SMTP id i22mr552498oos.55.1610484054385;
 Tue, 12 Jan 2021 12:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com> <20210112194143.1494-4-yuri.benditovich@daynix.com>
In-Reply-To: <20210112194143.1494-4-yuri.benditovich@daynix.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 12 Jan 2021 22:40:42 +0200
Message-ID: <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        pablo@netfilter.org, decui@microsoft.com, cai@lca.pw,
        jakub@cloudflare.com, elver@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        bpf@vger.kernel.org
Cc:     Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:42 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> This program type can set skb hash value. It will be useful
> when the tun will support hash reporting feature if virtio-net.
>
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>  drivers/net/tun.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7959b5c2d11f..455f7afc1f36 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
>                 prog = NULL;
>         } else {
>                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> +               if (IS_ERR(prog))
> +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
>                 if (IS_ERR(prog))
>                         return PTR_ERR(prog);
>         }

Comment from Alexei Starovoitov:
Patches 1 and 2 are missing for me, so I couldn't review properly,
but this diff looks odd.
It allows sched_cls prog type to attach to tun.
That means everything that sched_cls progs can do will be done from tun hook?
sched_cls assumes l2 and can modify the packet.
I think crashes are inevitable.

> --
> 2.17.1
>
