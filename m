Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6217250F954
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiDZJy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348316AbiDZJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:53:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C469B2B262
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:12:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id m20so13991005ejj.10
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=Tazkbf2Odg3ogAZG6EbhaO/RzCg6IyWtHe+4n8iOMbU=;
        b=wocd5g4lccHA084q6SD50ovtb4xIjFO1T/pHRaWVVw8cMWPrcnhs7KqkiNItRRo750
         ngzGkKZ50Sj2PNtDals+b1xAfDjQUcEZ7rkADBecyvBJR9gabvUeXYqIWoq8/6y0T+9B
         IOdplVTIG6I6Po5b9smcT/LV9zWsM8ApNUcco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=Tazkbf2Odg3ogAZG6EbhaO/RzCg6IyWtHe+4n8iOMbU=;
        b=zI6xHd7+IjndpgUgFxgjj9L01Dfwc28r7L+HDn8s+rUprzpihfCDG+G0EPVGLR7vLD
         GMl3zpgFT6+RVC8Gj9kdLIWCZYv+mp5DbEMBva6pvJXfMBaOccZQ1M47c9twtDFt2sbS
         ZbjysgXYfDUyCHwwufbI/z/s95Pg3m+49Lp9l7eT3r3fYtprP+VTnWCB3D9YJhFv4x/f
         QSzCVvAF8yGn+LbTWVTcW6ynkPjRvQsvn/MYWK75O6V13x8FKOIVWeG5nRGYnLzntEDd
         dEdQ3XkPGe6Pc6IGiXclTpaC9+HG4eQWt8mEigkW0j5KX2Zu+tVGdxCmo3ugtAfQg6wD
         yAbA==
X-Gm-Message-State: AOAM532ViR4yS6virh6OCI0B1jCrSID9cv3xXPt2ANMdWRe7hF1PZPji
        RLxhzq4+MItD96USJSM+EvqxXQ==
X-Google-Smtp-Source: ABdhPJyvhAlpzXf0lrFBYj6+muBJR4829Z481olUsuGqULmpHt2WeLI8uSGrQkLXq5nvjmJtGkgP5Q==
X-Received: by 2002:a17:906:a147:b0:6e8:46a4:25a9 with SMTP id bu7-20020a170906a14700b006e846a425a9mr19586482ejb.213.1650964351344;
        Tue, 26 Apr 2022 02:12:31 -0700 (PDT)
Received: from cloudflare.com (79.184.126.143.ipv4.supernova.orange.pl. [79.184.126.143])
        by smtp.gmail.com with ESMTPSA id o2-20020a056402438200b0041fb0f2e155sm1911616edc.20.2022.04.26.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 02:12:31 -0700 (PDT)
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
Date:   Tue, 26 Apr 2022 11:11:09 +0200
In-reply-to: <20220410161042.183540-2-xiyou.wangcong@gmail.com>
Message-ID: <87czh46we9.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 09:10 AM -07, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> a preparation for the next patch which actually introduces
> a new sock ops.
>
> TCP is special here, because it has tcp_read_sock() which is
> mainly used by splice(). tcp_read_sock() supports partial read
> and arbitrary offset, neither of them is needed for sockmap.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/tcp.h |  2 ++
>  net/ipv4/tcp.c    | 72 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 66 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 6d50a662bf89..f0d4ce6855e1 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -667,6 +667,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
>  /* Read 'sendfile()'-style from a TCP socket */
>  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  		  sk_read_actor_t recv_actor);
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +		 sk_read_actor_t recv_actor);

Do you think it would be worth adding docs for the newly added function?
Why it exists and how is it different from the tcp_read_sock which has
the same interface?

[...]
