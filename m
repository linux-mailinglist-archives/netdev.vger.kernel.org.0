Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB1E66C53F
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjAPQDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjAPQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:03:11 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5050823C46
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:02:25 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 203so30727669yby.10
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lg/NVp30LYpi6nSFKhiEkCfNSHR6YSefKz8d6fnTjXE=;
        b=SAIhV4fMzCTB79rEEAxEfrHMo/x1jasiYi98HuumAyQnqTA7Wfp2qG54bpD+2G2pRT
         3s0Vk6a0VJch2uO/LtiOoBSCHw35++sEgSHUqcsVii0Z+QRLjjyQdgkJmZS3B2eevueB
         9MqSs2HSRBidEpGgo/t+X8QrOdie7ZSlg6VeoZK5ibrAmYESR7VzUbg9rbwjgM+g3+Vw
         P53LhRYBiFLePdvHGQ56c+vZ8HavImSwjlbhz99pvwgC+7sV1sX4I4qsmR3XLa7X1UPP
         vtEQVcnUu5JdXNRP85Xj6Xlk5ehffptQFngQ41Kp6sj5Acey/y3xTfUwk7xZ1+V+mqD5
         B3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lg/NVp30LYpi6nSFKhiEkCfNSHR6YSefKz8d6fnTjXE=;
        b=6oBnCb4EpNIYWxl2e/AlpTDuejgOSFXH3MGgY/BC6tuqTX/FanrHh4uVR7BNmuX9rW
         NrdiiWEmZu8zwF2AJwdVD5Ab4JGRdJ+IsVHu7P720a0O1Z61qckxNoAN4uXbMjtksog+
         CxBH4D2geYiDL6Tc21r1jcqJDN6jk38S1WnAqAbI41rigKoxg4ayDkWUi3ygbUR7bFNL
         SRLxmlpkILYz4EIYdoAbmsFr6cBvCNBzCB/JxT+y8/wDmGn0OKRdT3iLdSrYBUDV39eA
         E5MYfTOZMPDXO9c9MB2vlF+vw2ur0oEdSQjfYJpdLAOtRiYBHdmZEyn/qsvrgvx4Vshd
         oEfw==
X-Gm-Message-State: AFqh2kruvQJShxpkDoIbZrIl4kGBTLYNJtjS6uU+XskBBZS3Mpub5JLQ
        n01g2CZw6SDkYjQxW7jv+s4iTCZ/uzWsy/nhyrd9XQ==
X-Google-Smtp-Source: AMrXdXu/fLy+pB4teoyf/uISoELZl44ThPeR1bCwVLw3fDOGU/70iuYULBLsMBr3Ms+mXIPEnQVLaYyIW4r638aLgLY=
X-Received: by 2002:a25:9012:0:b0:7b8:a0b8:f7ec with SMTP id
 s18-20020a259012000000b007b8a0b8f7ecmr35835ybl.36.1673884944293; Mon, 16 Jan
 2023 08:02:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com> <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com>
In-Reply-To: <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 17:02:12 +0100
Message-ID: <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     David Ahern <dsahern@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
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

On Mon, Jan 16, 2023 at 4:08 PM David Ahern <dsahern@gmail.com> wrote:
>

> not sure why you think it would not be detected. Today's model for gro
> sets tot_len based on skb->len. There is an inherent trust that the
> user's of the gro API set the length correctly. If it is not, the
> payload to userspace would ultimately be non-sense and hence detectable.

Only if you use some kind of upper protocol adding message integrity
verification.

> >
> > As you said, user space sniffing packets now have to guess what is the
> > intent, instead of headers carrying all the needed information
> > that can be fully validated by parsers.
>
> This is a solveable problem within the packet socket API, and the entire
> thing is opt-in. If a user's tcpdump / packet capture program is out of
> date and does not support the new API for large packets, then that user
> does not have to enable large GRO/TSO.

I do not see this being solved yet.

We have enabled BIG TCP only for IPv6, we do not want the same to
magically be enabled for ipv4
when a new kernel is deployed.

Make sure that IPV4 BIG TCP is guarded by a separate tunable.

Note that our initial patches were adding IPv6 tunables for a reason.

We agreed to change them to IFLA_GRO_MAX_SIZE, IFLA_TSO_MAX_SIZE,
as long as they would not enable unwanted/untested behavior.
