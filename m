Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14262F508
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241893AbiKRMgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241650AbiKRMgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:36:44 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06F773BA8
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:36:43 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id i131so5467855ybc.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ubfyWKqFfu6u9pn4Vf61LB5hZloX/i6MLfzbKwe+Tjw=;
        b=QGK4LWmTqXwAuvXcES6P+Moc0yON4QgWd3muUk7E4W4198EeTXPV6SJ7SxNSREneKl
         jMUNkkb1d//pyk3ky9u0hPyZcm/0k5AUlpU7pXAu1dPdwolHjgy9Ltl7K9d10F/vyHJu
         WBbbzKfIRNX6piLMEOMAZQ+x4MixJZXSMFuKWYNrEPJI4IT1g0qIBPDxe8HzHJK/5rsO
         HXzZLNd7UvPWQybRcvc3izYnMThCGO0kdLKej5uoqLaCdHrXbo87gYwHP94AhhyMYI6m
         qAq8g3VRZ82/LRIvqV1soLd061+sU/eaF7tFcbTGHEH+FtGriSefF48sn8+OwWDcOvR6
         yTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubfyWKqFfu6u9pn4Vf61LB5hZloX/i6MLfzbKwe+Tjw=;
        b=78kGi4rXkVfYX8u9i4Y7/6B84BUexG/EpVRhC/bD5ExF0nL0Fuhkv3N7c0b1eiMLvF
         MyuXKYgH7dUKXewbTJ642JzJSM4fc/SudfKOGPBUHglBcD7bQfX6JFeTLImIWyw64DpQ
         4UY6UJ4z3sbXpkye5L5zHyB3WEx0nTB5WiexXyrcHLVRzHko4FIhyYzYHUVxyYKfLqCR
         60Vl3FeTfyRkUYRATweeJFzInM28K9OZZ7g7FB3vlXJeq8yrzmxtMEgShrks94qLKouZ
         KkE/x0r2M0OfWYMQ8qnJQFpKk+WdL8WwoPIotz+lUMIuOokwIb0YBLGYJBfhd0cqqgd/
         sIUQ==
X-Gm-Message-State: ANoB5pnqdk+iNr9ll4ewnYwC/h0sU5ZO/Mr+HQdSxMPX0OqKjnMhABgE
        5LNXEsF61Cx+tqgAYTx628wnzWPgGVCCFzttwmapfw==
X-Google-Smtp-Source: AA0mqf7HbXZjMhCTPjtVPTqgENQODUU+7Na9bC+iKx1yukInnmCBDGyf39SnqDwfcTpm8KFXXRG5olChyJLwRUc1sN0=
X-Received: by 2002:a25:bcc6:0:b0:6dd:1c5c:5602 with SMTP id
 l6-20020a25bcc6000000b006dd1c5c5602mr6563128ybm.36.1668775002737; Fri, 18 Nov
 2022 04:36:42 -0800 (PST)
MIME-Version: 1.0
References: <0000000000004e78ec05eda79749@google.com> <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
In-Reply-To: <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Nov 2022 04:36:31 -0800
Message-ID: <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 3:51 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is reporting sleep in atomic context at l2tp_tunnel_register() [1],
> for commit b68777d54fac ("l2tp: Serialize access to sk_user_data with
> sk_callback_lock") missed that udp_tunnel_encap_enable() from
> setup_udp_tunnel_sock() might sleep.
>
> Since we don't want to drop sk->sk_callback_lock inside
> setup_udp_tunnel_sock() right before calling udp_tunnel_encap_enable(),
> introduce a variant which does not call udp_tunnel_encap_enable(). And
> call udp_tunnel_encap_enable() after dropping sk->sk_callback_lock.
>
> Also, drop sk->sk_callback_lock before calling sock_release() in order to
> avoid circular locking dependency problem.

Please look at recent discussion, your patch does not address another
fundamental problem.

Also, Jakub was working on a fix already. Perhaps sync with him to
avoid duplicate work.

https://lore.kernel.org/netdev/20221114191619.124659-1-jakub@cloudflare.com/T/

Thanks.
