Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF456AB0C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiGGSuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiGGSuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:50:11 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4E72124D
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:50:10 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 23so20102734pgc.8
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHby+dF+yToePJx/gwaN86DE9hAY7G2nKB6YWYXnZJY=;
        b=rtLffWR5jFvttiDVDp7G9fFlWuP6RIJDXzJA4wy1wmxK1j0GAR/qgRnY8LKOC/WB62
         S2RhOnNcIM775P464ot5xmkXdwlnmzyfQVq+i95nNvMOsYBthV9bVObIOtEath6x6jt8
         7PMY+WU2iypZAXAgt9HSzaC+W0jmR74X5USq6nl4G8XW9nEAusBLM7foWU9XFkN3UZ5n
         Eb2zaZKFO7KpMWyyYYFt5IFz7toPDlDO7dSJ6VKrg3C3V7UxifCQ4Z98sgMmX2tYBkOC
         gfFjbhZJfvE7c6ckUpvOAPt5jpUqbppnxERn8kn3Xp5Ak9X4erIk1mn3KoNglNHVPE0T
         ZMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHby+dF+yToePJx/gwaN86DE9hAY7G2nKB6YWYXnZJY=;
        b=chQKF5jgbMS63UX3NEmi073YaUSlGvj+z3Xw3bTJbolxbiHUAyrztpGexXtmt9Wvrp
         UFwFlqnk0qWKP4DXA1hUFgOcplDHcROAaVoi+KfANd+90dFC0ETga6KXj3bsnmVAgnjU
         CQYXGmxOQ2kwcB67W5EhP+lVxRykbWZT4iMtr0BX79QQz++koogqEt1hBwdh7DxL6VYA
         gFT9CQ28GVPO2rUP03Kfh4qSDZga45TEKmnLWN3uPi7XKRizehtEDQ4RTCwLGRhSsdOA
         mDeeqEizPv2FEWU37+nzzsjb7sMvEK1hncM9pU3u1vYVe5JQJw8TxN2i57sTmLL6Vb1z
         D9VA==
X-Gm-Message-State: AJIora9HDC56LzvbPEcg/a4xmoUJaaYkosW3UjOOcxwchfXWBcfEun4v
        p1V2eWCUW2WC7pWICg1ZZDe+AJYzQmyMQr3HrOR30g==
X-Google-Smtp-Source: AGRyM1vCIqaJyO1gOUSaFLMCRWlOm72eQEGRpiWyy9gVc1yrFWalONUFhA/XulktDkLvX3HcGIg/L0EbbNfkvUDAh6s=
X-Received: by 2002:a17:90b:4b4d:b0:1ef:bff5:de4f with SMTP id
 mi13-20020a17090b4b4d00b001efbff5de4fmr6850664pjb.120.1657219809927; Thu, 07
 Jul 2022 11:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b06e5505e299a9b6@google.com> <CANn89iLuGKyVcNAAjvwWk8HoJrNgZ5HM4itXEsnqzU=+xZLKOQ@mail.gmail.com>
 <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com>
 <YsW7EP45TloIyEtv@pop-os.localdomain> <CAM_iQpVBHvO=4quf6yCbst5JNxg7GNb1hOYjmhF9HkHeR_hEaQ@mail.gmail.com>
In-Reply-To: <CAM_iQpVBHvO=4quf6yCbst5JNxg7GNb1hOYjmhF9HkHeR_hEaQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 7 Jul 2022 11:49:58 -0700
Message-ID: <CAKH8qBtNQ5RS6T4+8xfgoEs0tZv=ppTiDegNVoXcFe1SN_gGBg@mail.gmail.com>
Subject: Re: [syzbot] WARNING in sk_stream_kill_queues (8)
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 11:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Jul 6, 2022 at 9:40 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > I will look into this tonight.
>
> The following patch could work. It uncharges the sk mem before passing skb
> to recv actor but still keeps skb->sk.

This seems to make syzkaller happy.

Tested-by: Stanislav Fomichev <sdf@google.com>

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9d2fd3ced21b..c6b1effb2afd 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk,
> skb_read_actor_t recv_actor)
>                 int used;
>
>                 __skb_unlink(skb, &sk->sk_receive_queue);
> +               WARN_ON(!skb_set_owner_sk_safe(skb, sk));
>                 used = recv_actor(sk, skb);
>                 if (used <= 0) {
>                         if (!copied)
