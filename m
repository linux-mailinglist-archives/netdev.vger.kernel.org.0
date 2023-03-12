Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542D76B6AC3
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 20:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCLTod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCLToc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 15:44:32 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C741233E3;
        Sun, 12 Mar 2023 12:44:31 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id z6so11364968qtv.0;
        Sun, 12 Mar 2023 12:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678650270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s75TtVh70eXktgAGPFXM1e4n0f1fIpDoWOpyHNvx7hs=;
        b=QNmGDQDaxFWHTy/S+ycbrdgtyAKaBMQPbrJUDDArdbaNHGlwHFzTJbXrhH8UhObP/9
         N3BaFLrLzXb5i277vCxxWBgkx/DQw878lQ4qiEfijtdwbys35CvKzPv5F810TaLNYX3K
         DDlWTmcKuubGolonCKZDi2PGN/mjdOy6A8SQoAi5iQPd1VZYnzUKO+n92yzihfZn3e9X
         8A44dDEeHJs/+mZzOSUBhNEotmzo5HgCPhJhIgdkUn37A/Y4IwQKiYrm5hrlJ0jFFbWi
         0x65oX9irbaemwFy2SblQgzrGdZ9opNqw6J64BrY4kA8+VIArRNmtoEhLHiuqrQFDblX
         HSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678650270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s75TtVh70eXktgAGPFXM1e4n0f1fIpDoWOpyHNvx7hs=;
        b=vQPf3psO96Gt8e0ZOdMVboVTyQxPL1zy4ISaY60eKunQMNNgyu865z5TVLhQP0eHrc
         NX27E/aejrsDWszLeysxcCOErjVVhZwkIXrEqOQdyUaM9SMvJDj3QvaYzaj3YMs/YnE8
         PrLtnWnCJ3R10U0O8cMPFPWZN7T3rfz5JKtAqpw8WRZR8o8Oo3EySSkOmDethBIGQ/7v
         /5PyoWMHUoO5cj1Ot77SUzS+6VpLFPJ8m70XNMEbEinEwo0Gz4/bxdLv3rL+auwqStKu
         +K+3p9hPhMRKaLd8NsfH/RBxlY2vHQsi6Ij9+K5/t5eaEB8REQu5bog+jWGe1PWoHdKe
         PBaQ==
X-Gm-Message-State: AO0yUKWUaSwT2RxYW8n0tJEwkLsOnHjSWnJANQBSnhnocxc/sH4KE5Fx
        TJR6T7x11lJAYKj/hk5Ipfc=
X-Google-Smtp-Source: AK7set8rcrw5acOcjzPz7FT5UPrR1dYbpwhgi6PYRlMHUDbS2ewt2aTNJbZejdesCa9P0APvXrektg==
X-Received: by 2002:a05:622a:1041:b0:3bf:c352:c8cc with SMTP id f1-20020a05622a104100b003bfc352c8ccmr58440117qte.31.1678650270483;
        Sun, 12 Mar 2023 12:44:30 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:790c:770f:7bb1:6550])
        by smtp.gmail.com with ESMTPSA id d126-20020a37b484000000b007419f1561fesm3957450qkf.112.2023.03.12.12.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 12:44:29 -0700 (PDT)
Date:   Sun, 12 Mar 2023 12:44:28 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [Patch net-next] sock_map: dump socket map id via diag
Message-ID: <ZA4rnMqTX8UNpcnA@pop-os.localdomain>
References: <20230211201954.256230-1-xiyou.wangcong@gmail.com>
 <871qmjjrnx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qmjjrnx.fsf@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 10:11:12AM +0100, Jakub Sitnicki wrote:
> On Sat, Feb 11, 2023 at 12:19 PM -08, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently there is no way to know which sockmap a socket has been added
> > to from outside, especially for that a socket can be added to multiple
> > sockmap's. We could dump this via socket diag, as shown below.
> >
> > Sample output:
> >
> >   # ./iproute2/misc/ss -tnaie --sockmap
> >   ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
> >
> >   # bpftool map
> >   1: sockmap  flags 0x0
> >   	key 4B  value 4B  max_entries 2  memlock 4096B
> > 	pids echo-sockmap(549)
> >   4: array  name pid_iter.rodata  flags 0x480
> > 	key 4B  value 4B  max_entries 1  memlock 4096B
> > 	btf_id 10  frozen
> > 	pids bpftool(624)
> >
> > In the future, we could dump other sockmap related stats too, hence I
> > make it a nested attribute.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> 
> Sorry for not replying sooner. This sounds useful. Another use case I
> can see here is inspecting process' sockets:
> 
> 1. get a dup FD with pidfd_getfd()
> 2. query sock_diag by socket cookie
> 3. find out which maps socket is in.
> 
> 
> I don't know if it makes sense to tie the naming to sockmap. We also
> have also map type that can hold socket references -
> REUSEPORT_SOCKARRAY.
> 
> We might want to add sock_diag support for REUSEPORT_SOCKARRAY in the
> future as well. So a map-type-agnostic name for the new inet_diag ext
> might be more future proof. Like INET_DIAG_BPF_MAP.

Sounds reasonable. I didn't realize REUSEPORT_SOCKARRAY also needs this.

> 
> 
> Also, can you please add a simple selftest? They often serve as the only
> documentation for the features. Perhaps in
> tools/testing/selftests/bpf/prog_tests/sockmap_basic.c.
> 

Not sure if this makes sense, because this is mostly for socket diag, it
does not seem fitting well in bpf selftests.

In case you wonder how I tested it, I have an iproute2 patch which is
not posted here yet.

Thanks.
