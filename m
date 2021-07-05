Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C993BC1AA
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGEQbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:31:41 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A39C061574;
        Mon,  5 Jul 2021 09:29:02 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id z1so17867523ils.0;
        Mon, 05 Jul 2021 09:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=E/Wpg/0LKhyeqhpzLHMYMm3WYVEZfVfhS6xWFKkzmRw=;
        b=MeTxK1mawXRfJE0J4Cy32rpoBh+RqvRMehIe/ZvkRCnRBM0Ekce7L5GvAHgaOZRA4H
         kOzV1TMcVYfohjFKD1gb/4PXo6O3xdGftlrSNXP309SFH4Ga2dXFWGxJQ9Z2k4vk9y+L
         0/Iu/h63sjWI3U9CVzHncAPSKMIqo0w2bryvlD8M7RYI/TSIExtcRnboH2GTd9OfPdPf
         iMpPIMYR4uDXrk3pq8MjHXhAAAweIL3a1X8k+mLsljwHiaFZUwevQuCkE5eOyWtHIgdD
         tSbm3OBAsprVbm7kSKcIM2TBc+PkhjnMjLfJIwS1Vk3a/az6fKrVFh1jk1Bs8TdDBIx+
         dLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=E/Wpg/0LKhyeqhpzLHMYMm3WYVEZfVfhS6xWFKkzmRw=;
        b=gBojaxAq5if7xphVkZNsQfN8AqPaP5U+UPcZnrMKMCjmoys+o157CDSXCNTk7Pw+qI
         6b9v5gHd5cNTF4bJeWrZsZeFqeYo2ckaz1jp4Np+qY4tI8DWF5rCHDj1WEEvPA3Rsoy2
         QH7zqqIg8SPfcevxHchGzBYBUXfSLJnJSMMMWhurpH7rY4Jl17gyCp5yE4ReeZya+Lz2
         tNySpzNHQKNd+dVceiBeoZA3wnHThKYPgdNOiLvWmX958+Gp/KaTr1DftcemDnEqQOG0
         7m2jxkRbdcUQnV8Oz5PARViDOOXFyd94YOWXR9pD64CVmq6aG2S2mcyT+2Gmvz+m08cP
         kPfQ==
X-Gm-Message-State: AOAM532Jw3HbzFsRgnBt8vXPa70ZcNBldgPi3ZPYyDkGQCzsBlFVs2Fj
        8p64al6KaCCWerF8A0Zibik=
X-Google-Smtp-Source: ABdhPJwVzM+yKexAVM7WnJtTSUj4mXHeF3UJo/mThiCe1L+s6+qJLqMF+pjNSvWby26e0vwjgNOlLA==
X-Received: by 2002:a05:6e02:1d96:: with SMTP id h22mr11109ila.295.1625502542289;
        Mon, 05 Jul 2021 09:29:02 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id e14sm6871784ilq.32.2021.07.05.09.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:29:01 -0700 (PDT)
Date:   Mon, 05 Jul 2021 09:28:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <60e33346cc93e_20ea2084e@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWZnQ7A=U9JmzGZrOcOB2V1f22NmbFkcJ0SVdA3iHgSGA@mail.gmail.com>
References: <20210702001123.728035-1-john.fastabend@gmail.com>
 <20210702001123.728035-3-john.fastabend@gmail.com>
 <CAM_iQpWZnQ7A=U9JmzGZrOcOB2V1f22NmbFkcJ0SVdA3iHgSGA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 2/2] bpf, sockmap: sk_prot needs inuse_idx for proc
 stats
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Jul 1, 2021 at 5:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> > We currently do not set this correctly from sockmap side. The result is
> > reading sock stats '/proc/net/sockstat' gives incorrect values. The
> > socket counter is incremented correctly, but because we don't set the
> > counter correctly when we replace sk_prot we may omit the decrement.
> >
> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/sock_map.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 60decd6420ca..016ea5460f8f 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -222,6 +222,9 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
> >         struct bpf_prog *msg_parser = NULL;
> >         struct sk_psock *psock;
> >         int ret;
> > +#ifdef CONFIG_PROC_FS
> > +       int idx;
> > +#endif
> >
> >         /* Only sockets we can redirect into/from in BPF need to hold
> >          * refs to parser/verdict progs and have their sk_data_ready
> > @@ -293,9 +296,15 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
> >         if (msg_parser)
> >                 psock_set_prog(&psock->progs.msg_parser, msg_parser);
> >
> > +#ifdef CONFIG_PROC_FS
> > +       idx = sk->sk_prot->inuse_idx;
> > +#endif
> >         ret = sock_map_init_proto(sk, psock);
> >         if (ret < 0)
> >                 goto out_drop;
> > +#ifdef CONFIG_PROC_FS
> > +       sk->sk_prot->inuse_idx = idx;
> > +#endif
> 
> I think it is better to put these into sock_map_init_proto()
> so that sock_map_link() does not need to worry about the sk_prot
> details.
> 
> Thanks.

Sure, that is fine.
