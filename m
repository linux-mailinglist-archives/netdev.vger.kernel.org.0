Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA767A5C9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjAXWc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjAXWcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:32:54 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597AD530DF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:32:17 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qx13so42898964ejb.13
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJ2rvlEry+Pqap+7yAkGgj+W44hMrV2ui8sszC93dHU=;
        b=AYlD+yJmPNSfIVOpjc/GQryoBhsjR97YZbp8hpmnmo1eAOemFg1/nfxBOhf4vsaCee
         G3xsrYDnsdJ6x31eYZBgTbyjuF2Mw2HVACZCo41qsYx/bl/r3zLRg0jDJJQb7CTwM7lU
         h/7NBoSxWQ964kEAd2QBh44zmP/++L26RaWzCvptt+4zs2j1o/UqHQuwkzGpnhxBMbBU
         C2BHEqWAL1jxszvgAFAzsC6tBjhz5N1iKLo9TZWkXq5IC0r0FmK+A2OcyvkxRfbvV9Yw
         ULY8+EA0MOjytf68DZzMsw0nbKtZ6ILMvcjSJbHrKEORA7Au8w+orjHw26cXgpE80huS
         pUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJ2rvlEry+Pqap+7yAkGgj+W44hMrV2ui8sszC93dHU=;
        b=pBX3TI81fzcnv+Gn1MRNKBLLtqj27vNZq4GcBn+taTgGvWUA1GymyNIK018uaidGCe
         oVvcJRIFA62DyC5NpKfgGn4hRabXtOMm6bw+ldcTUscflbH89apIzRJasudkyoqnGmPe
         5HvCa7F6l9/KcNbmA4xf+69NujPRo0+0UDSl5oI7jUremWL7D5dpBnZNbAeRi6624A3z
         QDQAa7dBJCqmrUkHr3QtO9wRrE/0VLLjANJFnTzHII+wu8rRQBOVdRH1v46oS4o8D9Vc
         /NMnwrwJzKgi39nHKDO4ezMOq1gPnnF3XwyQFx1qEamVLP1ZlJ1T0Rq3BxxgrmxzP8ZJ
         saPQ==
X-Gm-Message-State: AFqh2kqhGe7UhRLRKGgZMNqsnCH4evdJUoQEpi9h4eFpB1FHcf+L2pjD
        Jq0fVGqqPvrwvGdwqJpkO3/KZp0ribo=
X-Google-Smtp-Source: AMrXdXthqIdzFsqBGyw2lBKgYYQowp1OjRO9G5fQhoEOF4X2RS33XP8P+e6Rj8z2e+29O1zUtJYC7A==
X-Received: by 2002:a17:906:4557:b0:872:325b:6035 with SMTP id s23-20020a170906455700b00872325b6035mr27792832ejq.34.1674599535802;
        Tue, 24 Jan 2023 14:32:15 -0800 (PST)
Received: from grain.localdomain ([5.18.253.97])
        by smtp.gmail.com with ESMTPSA id gh20-20020a170906e09400b00877a0ebccc0sm1451591ejb.125.2023.01.24.14.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 14:32:14 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
        id 2E47F5A0020; Wed, 25 Jan 2023 01:32:13 +0300 (MSK)
Date:   Wed, 25 Jan 2023 01:32:13 +0300
From:   Cyrill Gorcunov <gorcunov@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     tkhai@ya.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of
 it was assigned by a task on other cpu
Message-ID: <Y9Bcbce4AuHqS/uf@grain>
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124175712.38112-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124175712.38112-1-kuniyu@amazon.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 09:57:12AM -0800, Kuniyuki Iwashima wrote:
> From:   Kirill Tkhai <tkhai@ya.ru>
> Date:   Mon, 23 Jan 2023 01:21:20 +0300
> > Some functions use unlocked check for sock::sk_state. This does not guarantee
> > a new value assigned to sk_state on some CPU is already visible on this CPU.
> > 
> > Example:
> > 
> > [CPU0:Task0]                    [CPU1:Task1]
> > unix_listen()
> >   unix_state_lock(sk);
> >   sk->sk_state = TCP_LISTEN;
> >   unix_state_unlock(sk);
> >                                 unix_accept()
> >                                   if (sk->sk_state != TCP_LISTEN) /* not visible */
> >                                      goto out;                    /* return error */
> > 
> > Task1 may miss new sk->sk_state value, and then unix_accept() returns error.
> > Since in this situation unix_accept() is called chronologically later, such
> > behavior is not obvious and it is wrong.
> 
> Have you seen this on a real workload ?
> 
> It sounds like a userspace bug that accept() is called on a different
> CPU before listen() returns.  At least, accept() is fetching sk at the

I must confess I don't get why accept() can't be called on different cpu
while listen() is in progress. As far as I see there is a small race window
which of course not critical at all since in worst case we simply report an
error back to userspace, still a nit worth to fix.

> same time, then I think there should be no guarantee that sk_state is
> TCP_LISTEN.
> 
> Same for other TCP_ESTABLISHED tests, it seems a program is calling
> sendmsg()/recvmsg() when sk is still TCP_CLOSE and betting concurrent
> connect() will finish earlier.
