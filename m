Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0405651E3A4
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 04:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445352AbiEGCrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 22:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358194AbiEGCrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 22:47:11 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69076A020
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 19:43:25 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r11so15828017ybg.6
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 19:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FlGDlP8OA9wbKdBluGVTt4p68E+0jcpKg1icRl4xMIg=;
        b=nVVfsojOW309Aw3h8LH5g3vWCVXZKl5Q4WNLS5UfMqhIHfLV/I6TSqYf5+UleHmA56
         47YO5FoNilFT9Of3YiZaghbilomSCOpeqR2wN4IHEyf6Gceo/NUOqQqFRP96KvijSIqs
         KVNRussGdf5lXbaUbm6l4DZj4SYZVpOB5XTHyO6wAf51JMsd0Sox4ALrBnU1n6uWJDcO
         3S11RMquCM6NQbox3bOxegxcWqQdi43cmRQeQQpBfrvV1H6DM+acpUlSAUhXwjb5m3Lp
         LodXh6PWUDd78Nf5WcPJJjDFH3hgE0XYb6JZAtzPWCBmuGhC6trg6KX30KE/NZBZzUr5
         wcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FlGDlP8OA9wbKdBluGVTt4p68E+0jcpKg1icRl4xMIg=;
        b=7xVFfgML485gkuQvJQkjDmRAeN+Smc6ipuILQMmQPMFmyQvGpyL73x/wt6i3Qbofou
         BtSWE/NCDoYQ7k10ta+x3b7Y9InekoTd2g5JjXTtbBf21/e6oRSpd57Dq2b9kVbsY6Ir
         ECw1LVNAYP3u9RBraxhJ8MwXfiUcqVPQ8rXNl8aqQkLB9z7BE0xAAZ6mEG7lGfBJ2sg+
         fdSnpGea5xzkgs/QXE1KIRrLmjkZyQ4Xd4LsxgMoXVAWElJEF4ELnQPKLt+WPjax/bF+
         XV9h3/BmFQZtiW3fKPg/qZkaYfVM2yHgdLS7V8RuAAEy2bTLW9GW9vC3pfHQg/Q1HR4c
         U0kA==
X-Gm-Message-State: AOAM530Dq6lPvRvZmlvPrLKNI6VvoqOCshQsnAXpcNwbIV+J4VHyYJ5v
        vRpbuUoXn7Ham9yADpEFo9K2EI1WXBjzoFj58izc3A==
X-Google-Smtp-Source: ABdhPJwONF7jGNgPsA2VgGjqaPYTcWtc9QDtU4qjFPzluG9BK7bU026f2+jEd5lOQF5HZyk7IotQfSdHH9WzRhYgLFU=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr4864253ybx.387.1651891404529; Fri, 06
 May 2022 19:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com> <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org> <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
 <20220506193734.408c2a0d@kernel.org>
In-Reply-To: <20220506193734.408c2a0d@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 19:43:13 -0700
Message-ID: <CANn89iLZJpTgnaEVxWvEaObrebvwivAmX+DGPGeibq5R0BKOBg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>
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

On Fri, May 6, 2022 at 7:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 6 May 2022 19:10:48 -0700 Eric Dumazet wrote:
> > On Fri, May 6, 2022 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> > > cleanly. Gotta be the new W=1 filed overflow warnings, let's bother
> > > Kees.
> >
> > Note that inline_hdr.start is a 2 byte array.
> >
> > Obviously mlx5 driver copies more than 2 bytes of inlined headers.
> >
> > mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs)
> > is called already with attr->ihs > 2
> >
> > So it should already complain ?
>
> It's a static checker, I presume it ignores attr->ihs because
> it can't prove its value is indeed > 2. Unpleasant :/

Well, the unpleasant thing is that I do not see a way to get rid of
this warning.
Networking is full of variable sized headers.

>
> > static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
> > {
> >    struct vlan_ethhdr *vhdr = (struct vlan_ethhdr *)start;
> >    int cpy1_sz = 2 * ETH_ALEN;
> >    int cpy2_sz = ihs - cpy1_sz;
> >
> >     memcpy(&vhdr->addrs, skb->data, cpy1_sz);
> >     vhdr->h_vlan_proto = skb->vlan_proto;
> >     vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
> >     memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz,
> > cpy2_sz);  // Here, more than 2 bytes are copied already
> > }
>
