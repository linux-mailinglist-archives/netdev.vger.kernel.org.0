Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB94B126B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbiBJQMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:12:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243839AbiBJQMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:12:08 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662C2EB
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:12:09 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 192so16785052ybd.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Boy/GIabb2pNN2ysU7kdQPFbp4AoWALHb+LU5Vq3/WE=;
        b=iPLKrZ0sATTgv2QdHv2ngcpOQhncpxBytSMhV7hWWJWXMQwvQu7IvKJet+PUSew2FA
         xh8bDPQ6LtnJxDgj9zpiurcSLjVNAW5d6r+8IDtN6BXABdxmVp5naFxX01Uo11Zjm6zQ
         WZxnfPHZBelBC/582Lus87RK0WWWfxbnAcGxjcbJGPbKrCkH9qlCn+aB+M6Uo2y/ELX3
         wL4n2Pxi/NbNXczHxvRHq3CZXHXvWXTLzMWgooqxudwN8oS4nCoGA0z+q6YEZ8hFsfYa
         6fsVbPY3qAuRpBgHEzjv1jgmTn+ei6o2scQDpCJ6RqvlpHJIfinTorhc1IVyZh8QcLxu
         KHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Boy/GIabb2pNN2ysU7kdQPFbp4AoWALHb+LU5Vq3/WE=;
        b=zp0BvLQkuO5eLsRMZexXwfOkdel+pBwWJFE5Ls4Q7GIWqRx+IBAPuYxYrRvQwHxI9v
         ddtyGmWEe8AHcdLi2Mol6M/9wVLb3dYzfwZ8YTQrZ+jgV1BLdS7wZAHdwKecTtbnzQRJ
         GbK2dGDPqdqqKLj4VxL/96RF0S6paoY2uDznuAa0LEsx4Hlwkt89v+JyNR3+mrhb//UI
         IPMlbBbhBta34y1DA/mC3X6sT6Xkf3M3P69EF/aQtpaXXxgzPybnS0oAPmMjzELKUYw1
         vF0nw6eOFzjGKCWDvsh9KI0s24Wz7offzAMf7OgyPLTvktPdLvyLsFRXUyJVdNRbxhqd
         Gogw==
X-Gm-Message-State: AOAM532Vti2eorqPSXdXqIBTSt3EsMTFEK47sBek+g6l4lLK/+MhL/x3
        yBX3BuG9lDyCzVckqeV4cRafcUNxRsJ8kbvDpIs=
X-Google-Smtp-Source: ABdhPJw5qaWFw8+3CeOuq1Brm1icOahv0aOKwdb8SQ8bxz1f7HZKYt94Y+8ovTz781QjI8+JbGvOudc6VvncE9nQYhI=
X-Received: by 2002:a25:508b:: with SMTP id e133mr7114040ybb.293.1644509528624;
 Thu, 10 Feb 2022 08:12:08 -0800 (PST)
MIME-Version: 1.0
References: <20220210154912.5803-1-claudiajkang@gmail.com>
In-Reply-To: <20220210154912.5803-1-claudiajkang@gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Fri, 11 Feb 2022 01:11:32 +0900
Message-ID: <CAK+SQuR3wn1_nzabwJzqB+iap4DC48msigUbQaKk0bOdGR8FBg@mail.gmail.com>
Subject: Re: [PATCH net] net: hsr: fix suspicious usage in hsr_node_get_first
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 12:49 AM Juhee Kang <claudiajkang@gmail.com> wrote:
>
> Currently, to dereference hlist_node which is result of hlist_first_rcu(),
> rcu_dereference() is used. But, suspicious RCU warnings occur because
> the caller doesn't acquire RCU. So it was solved by adding rcu_read_lock().
>
> The kernel test robot reports:
>     [   53.750001][ T3597] =============================
>     [   53.754849][ T3597] WARNING: suspicious RCU usage
>     [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
>     [   53.766947][ T3597] -----------------------------
>     [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
>     [   53.780129][ T3597] other info that might help us debug this:
>     [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
>     [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:
>
> Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  net/hsr/hsr_framereg.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index b3c6ffa1894d..92abdf855327 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct hlist_head *head)
>  {
>         struct hlist_node *first;
>
> +       rcu_read_lock();
>         first = rcu_dereference(hlist_first_rcu(head));
> +       rcu_read_unlock();
> +
>         if (first)
>                 return hlist_entry(first, struct hsr_node, mac_list);
>
> --
> 2.25.1
>


There are netdev/apply warnings.
I will fix it and I will send v2 patch!!

-- 

Best regards,
Juhee Kang
