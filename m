Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7315617644
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiKCFl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 01:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKCFlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:41:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EA140FA;
        Wed,  2 Nov 2022 22:41:24 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v3so773595pgh.4;
        Wed, 02 Nov 2022 22:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nvmd2WGiE7UyWMF/jvLSucjNrRcSgOhjrSAbsSDYxL4=;
        b=D5u5OZ+FQqZU3D1YeYwRPTgODYNKyCDz1ONJpJA2536owqYeZIW4jIyshyXB80Oye3
         oHpQwqnEE4Eg94lrNOuFH19D/lI0D4R4l0ALeatWFby7fHwnOko96yi395CsZZo88nmB
         EsRVFkT8WRXpxtbezz/sn/XvJBCXVMoSPrNURsU4kL7sZR0WdoZ8aYqTNNzMiJyEYDnB
         kfw2hFHyy8oUacr6XxCIkos7HrwfPZHF+mwc1RhEj0Zt/uVxTwcxiYUEU8BDVr+cOUef
         QhYnSyoEousjgP7C0kWKgxRPNZA6ymD/JzsibjeI3IdKVsLqxusG1Xg0lRnzEy4nNEaK
         Sxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nvmd2WGiE7UyWMF/jvLSucjNrRcSgOhjrSAbsSDYxL4=;
        b=IGf4ORnqLUuYp3at2GLjGdSMQi3A/seZvRAKKu8rU8HvmtMr5hsLVx2AAi5dhzrXyC
         Jn2OnoqU6fEG55DzRH/3cya2tdWWHteFOtYOI1/JH+pwUa9cILviFRPhdcJs7uJ7Ufek
         4L79q8nZ5DSDcDEaxtu6/qeBnDRPXtoKielk8yHIgPqEzyo+HgpBsMZB2qocQ+ewdnv+
         wxEAAsSbnSqmaoBwO17tI0Bo03p1lfnCpVD+ima6qbUJTrhgQ5ZO+QH4/vn+z2n2sqip
         hYrW9AQdv5yLV5Px4JyZo3nN3DehxX929lE8Ec94phTcusM6ae74MnEoNMO9G3iQmjhJ
         l5+g==
X-Gm-Message-State: ACrzQf3yDEriVwUv8NwvEmoCi5RBUaoKh/tkEE7ZADEgLQWwazOHG0mI
        wqqDP6Lz2UUCcwE/caIuw6M=
X-Google-Smtp-Source: AMsMyM4Q0iqZ13zDWJF4Iz9gcY8aADEivbBaTBwy7kL3qrOSKf480wNWVVu9fmyJd9Z7+GXntbjVRg==
X-Received: by 2002:a63:5341:0:b0:46f:d05d:55cf with SMTP id t1-20020a635341000000b0046fd05d55cfmr15145519pgl.356.1667454083917;
        Wed, 02 Nov 2022 22:41:23 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id w24-20020aa79558000000b0056e15b7138esm2328126pfq.157.2022.11.02.22.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 22:41:23 -0700 (PDT)
Date:   Wed, 02 Nov 2022 22:41:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <636354819110e_a055820897@john.notmuch>
In-Reply-To: <20221102043417.279409-1-xiyou.wangcong@gmail.com>
References: <20221102043417.279409-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v2] sock_map: move cancel_work_sync() out of sock lock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Stanislav reported a lockdep warning, which is caused by the
> cancel_work_sync() called inside sock_map_close(), as analyzed
> below by Jakub:
> 
> psock->work.func = sk_psock_backlog()
>   ACQUIRE psock->work_mutex
>     sk_psock_handle_skb()
>       skb_send_sock()
>         __skb_send_sock()
>           sendpage_unlocked()
>             kernel_sendpage()
>               sock->ops->sendpage = inet_sendpage()
>                 sk->sk_prot->sendpage = tcp_sendpage()
>                   ACQUIRE sk->sk_lock
>                     tcp_sendpage_locked()
>                   RELEASE sk->sk_lock
>   RELEASE psock->work_mutex
> 
> sock_map_close()
>   ACQUIRE sk->sk_lock
>   sk_psock_stop()
>     sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
>     cancel_work_sync()
>       __cancel_work_timer()
>         __flush_work()
>           // wait for psock->work to finish
>   RELEASE sk->sk_lock
> 
> We can move the cancel_work_sync() out of the sock lock protection,
> but still before saved_close() was called.
> 
> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

LGTM. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
